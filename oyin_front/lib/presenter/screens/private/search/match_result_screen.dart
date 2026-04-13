import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import 'contract_setup_screen.dart';
import 'dispute_evidence_screen.dart';
import 'cubit/_export.dart';
import 'dispute_screen.dart';
import 'widgets/_export.dart';

class MatchResultScreen extends StatelessWidget {
  const MatchResultScreen({
    super.key,
    required this.gameId,
    this.challengerName = 'You',
    this.opponentName = 'Opponent',
    this.opponentAvatarUrl = '',
  });

  final String gameId;
  final String challengerName;
  final String opponentName;
  final String opponentAvatarUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchResultCubit(
        gameId: gameId,
        challengerName: challengerName,
        opponentName: opponentName,
        opponentAvatarUrl: opponentAvatarUrl,
      ),
      child: const _MatchResultView(),
    );
  }
}

class _MatchResultView extends StatelessWidget {
  const _MatchResultView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<MatchResultCubit, MatchResultState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MatchResultHeader(
                    l10n: l10n,
                    onInfo: () => _showInfo(context),
                  ),
                  14.vSpacing,
                  SessionBanner(
                    l10n: l10n,
                    title: state.title,
                    dateLabel: state.dateLabel,
                    locationLabel: state.locationLabel,
                    statusLabel: state.statusLabel,
                  ),
                  12.vSpacing,
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: state.isLoading
                          ? null
                          : () => _openContract(
                              context,
                              forceReadOnly: state.hasContract,
                            ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: state.hasContract
                              ? Colors.greenAccent
                              : palette.muted.withValues(alpha: 0.55),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        state.hasContract
                            ? Icons.verified_rounded
                            : Icons.edit_calendar_rounded,
                        color: state.hasContract
                            ? Colors.greenAccent
                            : palette.muted,
                      ),
                      label: Text(
                        state.hasContract
                            ? l10n.contractViewDetailsButton
                            : l10n.contractOpenButton,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: state.hasContract
                              ? Colors.greenAccent
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  8.vSpacing,
                  Text(
                    state.hasContract
                        ? l10n.contractLockedHint
                        : l10n.contractRequiredBeforeResult,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.muted),
                  ),
                  26.vSpacing,
                  Center(
                    child: Text(
                      l10n.enterFinalScore,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  24.vSpacing,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlayerScoreCard(
                        player: state.leftPlayer,
                        onTap: state.isLoading
                            ? () {}
                            : () => _pickScore(
                                context,
                                onPicked: (value) {
                                  context.read<MatchResultCubit>().setScoreLeft(
                                    value,
                                  );
                                },
                              ),
                      ),
                      Text(
                        'VS',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: palette.muted,
                            ),
                      ),
                      PlayerScoreCard(
                        player: state.rightPlayer,
                        onTap: state.isLoading
                            ? () {}
                            : () => _pickScore(
                                context,
                                onPicked: (value) {
                                  context
                                      .read<MatchResultCubit>()
                                      .setScoreRight(value);
                                },
                              ),
                      ),
                    ],
                  ),
                  24.vSpacing,
                  SubmitBlock(
                    l10n: l10n,
                    enabled: state.canSubmit,
                    isLoading: state.isSubmitting,
                    onPressed: () => _submitResult(context),
                  ),
                  24.vSpacing,
                  DisputeBlock(
                    l10n: l10n,
                    enabled:
                        state.canOpenDispute ||
                        (state.disputeId?.isNotEmpty ?? false),
                    isLoading: state.isCreatingDispute,
                    onTap: () => _openDisputeFlow(context),
                  ),
                  if (state.error != null && state.error!.isNotEmpty) ...[
                    14.vSpacing,
                    Text(
                      state.error!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submitResult(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<MatchResultCubit>();
    final hasContract = await _ensureContractBeforeAction(context);
    if (!context.mounted || !hasContract) return;

    try {
      final result = await cubit.submitResult();
      if (!context.mounted) return;
      if (result == null) {
        AppNotifier.showMessage(
          context,
          l10n.enterScoreBoth,
          title: l10n.notifTitleWarning,
          type: AppNotificationType.warning,
        );
        return;
      }

      switch (result.status) {
        case 'PLAYED':
          AppNotifier.showSuccess(context, l10n.resultConfirmed);
          break;
        case 'CONFLICT':
          AppNotifier.showMessage(
            context,
            l10n.scoreConflict.replaceFirst('{toCourt}', l10n.toCourt),
            title: l10n.notifTitleInfo,
            type: AppNotificationType.info,
          );
          break;
        default:
          AppNotifier.showMessage(
            context,
            l10n.resultSentWaiting,
            title: l10n.notifTitleInfo,
            type: AppNotificationType.info,
          );
      }
    } catch (error) {
      if (!context.mounted) return;
      AppNotifier.showError(context, error);
    }
  }

  Future<void> _openDisputeFlow(BuildContext context) async {
    final cubit = context.read<MatchResultCubit>();
    var state = cubit.state;

    final hasContract = await _ensureContractBeforeAction(context);
    if (!context.mounted || !hasContract) return;
    state = cubit.state;

    if (!state.canOpenDispute && !(state.disputeId?.isNotEmpty ?? false)) {
      final l10n = AppLocalizations.of(context);
      AppNotifier.showMessage(
        context,
        l10n.disputeNotAvailable,
        title: l10n.disputeNotAvailableTitle,
        type: AppNotificationType.info,
      );
      return;
    }

    if (state.disputeId != null && state.disputeId!.isNotEmpty) {
      _openDisputeScreen(context, state.disputeId!);
      return;
    }

    final existing = await cubit.resolveDisputeId();
    if (!context.mounted) return;
    if (existing != null && existing.isNotEmpty) {
      _openDisputeScreen(context, existing);
      return;
    }

    final payload = await Navigator.of(context).push<DisputeEvidenceDraft>(
      MaterialPageRoute(builder: (_) => const DisputeEvidenceScreen()),
    );
    if (!context.mounted || payload == null) return;

    try {
      final disputeId = await cubit.createDispute(
        comment: payload.comment,
        plaintiffStatement: payload.plaintiffStatement,
        defendantStatement: payload.defendantStatement,
        evidenceUrl: payload.evidenceUrl,
        evidenceItems: payload.evidenceItems,
      );

      if (!context.mounted) return;
      if (disputeId != null && disputeId.isNotEmpty) {
        _openDisputeScreen(context, disputeId);
      }
    } catch (error) {
      if (!context.mounted) return;
      AppNotifier.showError(context, error);
    }
  }

  void _openDisputeScreen(BuildContext context, String disputeId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DisputeScreen(disputeId: disputeId)),
    );
  }

  Future<bool> _openContract(
    BuildContext context, {
    required bool forceReadOnly,
  }) async {
    final cubit = context.read<MatchResultCubit>();
    final state = cubit.state;

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ContractSetupScreen(
          gameId: state.gameId,
          forceReadOnly: forceReadOnly,
          initialDateTime: state.contract?.dateTime,
          initialLocation: state.contract?.location,
          initialReminder: state.contract?.reminder,
        ),
      ),
    );

    if (!context.mounted) return false;

    if (updated == true) {
      await cubit.loadGame();
    }

    return updated == true || cubit.state.hasContract;
  }

  Future<bool> _ensureContractBeforeAction(BuildContext context) async {
    final cubit = context.read<MatchResultCubit>();
    if (cubit.state.hasContract) {
      return true;
    }

    final l10n = AppLocalizations.of(context);
    AppNotifier.showMessage(
      context,
      l10n.contractRequiredBeforeResult,
      title: l10n.validationTitle,
      type: AppNotificationType.warning,
    );

    return _openContract(context, forceReadOnly: false);
  }

  static void _showInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showFrostedInfoModal(
      context,
      title: l10n.infoResultTitle,
      subtitle: l10n.infoResultSubtitle,
      tips: [l10n.infoResultTip1, l10n.infoResultTip2, l10n.infoResultTip3],
    );
  }

  Future<void> _pickScore(
    BuildContext context, {
    required ValueChanged<int> onPicked,
  }) async {
    final palette = context.palette;

    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).pickScore,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                12.vSpacing,
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(8, (index) {
                    return SizedBox(
                      width: 52,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '$index',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null) {
      onPicked(picked);
    }
  }
}
