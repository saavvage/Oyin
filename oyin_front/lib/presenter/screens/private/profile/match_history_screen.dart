import 'package:flutter/material.dart';

import '../../../../app/errors/app_errors.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../search/dispute_screen.dart';
import '../search/dispute_evidence_screen.dart';
import '../search/match_result_screen.dart';

class MatchHistoryScreen extends StatefulWidget {
  const MatchHistoryScreen({super.key});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  List<GameHistoryDto> _games = const [];
  bool _isLoading = true;
  AppErrorCode? _errorCode;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorCode = null;
      });
    }

    try {
      final me = await UsersApi.getMe();
      final myId = (me['id'] ?? '').toString();
      final games = await GamesApi.getMyGames(myId);
      if (!mounted) return;
      setState(() {
        _games = games;
        _errorCode = null;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorCode = AppErrorMapper.fromException(error);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  12.hSpacing,
                  Text(
                    l10n.matchHistory,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(palette, l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(dynamic palette, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorCode != null) {
      final code = _errorCode!;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded, size: 52, color: palette.muted),
              12.vSpacing,
              Text(
                _errorTitle(l10n, code),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              8.vSpacing,
              Text(
                _errorMessage(l10n, code),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                textAlign: TextAlign.center,
              ),
              16.vSpacing,
              ElevatedButton(
                onPressed: _load,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_games.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_mma, size: 64, color: palette.muted),
            12.vSpacing,
            Text(
              l10n.matchHistoryDesc,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: palette.muted),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _games.length,
        separatorBuilder: (_, _) => 8.vSpacing,
        itemBuilder: (context, index) => _GameCard(
          game: _games[index],
          onTap: () => _openGameDetails(_games[index]),
          onDisputeTap: _games[index].disputeId != null
              ? () => _openDispute(_games[index].disputeId!)
              : null,
          onCreateDisputeTap: _canCreateDispute(_games[index])
              ? () => _createDispute(_games[index])
              : null,
        ),
      ),
    );
  }

  bool _canCreateDispute(GameHistoryDto game) {
    final hasDispute = game.disputeId != null && game.disputeId!.isNotEmpty;
    return !hasDispute && game.status != 'DISPUTED';
  }

  Future<void> _createDispute(GameHistoryDto game) async {
    final draft = await Navigator.of(context, rootNavigator: true)
        .push<DisputeEvidenceDraft>(
          MaterialPageRoute(builder: (_) => const DisputeEvidenceScreen()),
        );
    if (!mounted || draft == null) return;

    try {
      final response = await DisputesApi.createDispute(
        gameId: game.id,
        comment: draft.comment,
        subject: 'Result dispute',
        plaintiffStatement: draft.plaintiffStatement,
        defendantStatement: draft.defendantStatement,
        evidenceUrl: draft.evidenceUrl,
        evidenceItems: draft.evidenceItems,
      );

      if (!mounted) return;

      AppNotifier.showSuccess(
        context,
        AppLocalizations.of(context).statusDisputeOpen,
      );
      await _load();

      if (!mounted) return;
      final disputeId = response.disputeId;
      if (disputeId.isNotEmpty) {
        _openDispute(disputeId);
      }
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    }
  }

  void _openDispute(String disputeId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DisputeScreen(disputeId: disputeId)),
    );
  }

  void _openGameDetails(GameHistoryDto game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MatchResultScreen(
          gameId: game.id,
          challengerName: 'You',
          opponentName: game.opponentName,
          opponentAvatarUrl: game.opponentAvatarUrl,
          readOnly: true,
        ),
      ),
    );
  }

  String _errorTitle(AppLocalizations l10n, AppErrorCode code) {
    switch (code) {
      case AppErrorCode.noConnection:
        return l10n.errorNoConnectionTitle;
      case AppErrorCode.timeout:
        return l10n.errorTimeoutTitle;
      case AppErrorCode.unauthorized:
        return l10n.errorUnauthorizedTitle;
      case AppErrorCode.forbidden:
        return l10n.errorForbiddenTitle;
      case AppErrorCode.notFound:
        return l10n.errorNotFoundTitle;
      case AppErrorCode.server:
        return l10n.errorServerTitle;
      case AppErrorCode.unknown:
        return l10n.errorUnknownTitle;
    }
  }

  String _errorMessage(AppLocalizations l10n, AppErrorCode code) {
    switch (code) {
      case AppErrorCode.noConnection:
        return l10n.errorNoConnectionMessage;
      case AppErrorCode.timeout:
        return l10n.errorTimeoutMessage;
      case AppErrorCode.unauthorized:
        return l10n.errorUnauthorizedMessage;
      case AppErrorCode.forbidden:
        return l10n.errorForbiddenMessage;
      case AppErrorCode.notFound:
        return l10n.errorNotFoundMessage;
      case AppErrorCode.server:
        return l10n.errorServerMessage;
      case AppErrorCode.unknown:
        return l10n.errorUnknownMessage;
    }
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    required this.onTap,
    this.onDisputeTap,
    this.onCreateDisputeTap,
  });

  final GameHistoryDto game;
  final VoidCallback onTap;
  final VoidCallback? onDisputeTap;
  final VoidCallback? onCreateDisputeTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final hasDispute = game.disputeId != null && game.disputeId!.isNotEmpty;
    final resultColor = _resultColor(game.result, palette);
    final resultLabel = _resultLabel(game.result, l10n);
    final dateLabel = game.createdAt != null
        ? '${game.createdAt!.day.toString().padLeft(2, '0')}.${game.createdAt!.month.toString().padLeft(2, '0')}.${game.createdAt!.year}'
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: palette.accent,
              backgroundImage: game.opponentAvatarUrl.isNotEmpty
                  ? NetworkImage(game.opponentAvatarUrl)
                  : null,
              child: game.opponentAvatarUrl.isEmpty
                  ? Icon(Icons.person, color: palette.muted)
                  : null,
            ),
            12.hSpacing,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.opponentName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  4.vSpacing,
                  Row(
                    children: [
                      if (game.score != null) ...[
                        Text(
                          game.score!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: palette.muted),
                        ),
                        8.hSpacing,
                      ],
                      Text(
                        dateLabel,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: palette.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    resultLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: resultColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (hasDispute) ...[
                  6.vSpacing,
                  GestureDetector(
                    onTap: onDisputeTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gavel, size: 14, color: Colors.orange[700]),
                        4.hSpacing,
                        Text(
                          game.status == 'DISPUTED'
                              ? l10n.statusDispute
                              : l10n.statusConflict,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ] else if (onCreateDisputeTap != null) ...[
                  6.vSpacing,
                  GestureDetector(
                    onTap: onCreateDisputeTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gavel, size: 14, color: Colors.orange[700]),
                        4.hSpacing,
                        Text(
                          l10n.openDispute,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _resultColor(String result, dynamic palette) {
    switch (result) {
      case 'win':
        return Colors.green;
      case 'loss':
        return Colors.redAccent;
      case 'draw':
        return Colors.orange;
      default:
        return palette.muted as Color;
    }
  }

  String _resultLabel(String result, AppLocalizations l10n) {
    switch (result) {
      case 'win':
        return l10n.statusWin;
      case 'loss':
        return l10n.statusLoss;
      case 'draw':
        return l10n.draw.toUpperCase();
      default:
        return l10n.statusPendingResult;
    }
  }
}
