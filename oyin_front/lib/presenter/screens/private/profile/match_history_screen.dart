import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../search/dispute_screen.dart';

class MatchHistoryScreen extends StatefulWidget {
  const MatchHistoryScreen({super.key});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  List<GameHistoryDto> _games = const [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final me = await UsersApi.getMe();
      final myId = (me['id'] ?? '').toString();
      final games = await GamesApi.getMyGames(myId);
      if (!mounted) return;
      setState(() {
        _games = games;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
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

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, style: TextStyle(color: palette.muted)),
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
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: palette.muted),
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
          onDisputeTap: _games[index].disputeId != null
              ? () => _openDispute(_games[index].disputeId!)
              : null,
        ),
      ),
    );
  }

  void _openDispute(String disputeId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DisputeScreen(disputeId: disputeId)),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, this.onDisputeTap});

  final GameHistoryDto game;
  final VoidCallback? onDisputeTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final resultColor = _resultColor(game.result, palette);
    final resultLabel = _resultLabel(game.result);
    final dateLabel = game.createdAt != null
        ? '${game.createdAt!.day.toString().padLeft(2, '0')}.${game.createdAt!.month.toString().padLeft(2, '0')}.${game.createdAt!.year}'
        : '';

    return Container(
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
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                4.vSpacing,
                Row(
                  children: [
                    if (game.score != null) ...[
                      Text(
                        game.score!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: palette.muted),
                      ),
                      8.hSpacing,
                    ],
                    Text(
                      dateLabel,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: palette.muted),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              if (game.status == 'CONFLICT' || game.status == 'DISPUTED') ...[
                6.vSpacing,
                GestureDetector(
                  onTap: onDisputeTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.gavel, size: 14, color: Colors.orange[700]),
                      4.hSpacing,
                      Text(
                        game.status == 'DISPUTED' ? 'Dispute' : 'Conflict',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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

  String _resultLabel(String result) {
    switch (result) {
      case 'win':
        return 'WIN';
      case 'loss':
        return 'LOSS';
      case 'draw':
        return 'DRAW';
      default:
        return 'PENDING';
    }
  }
}
