import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
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
                    enabled: true,
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

    try {
      final result = await cubit.submitResult();
      if (!context.mounted) return;
      if (result == null) {
        AppNotifier.showMessage(
          context,
          'Укажите счёт для обоих игроков.',
          title: l10n.notifTitleWarning,
          type: AppNotificationType.warning,
        );
        return;
      }

      switch (result.status) {
        case 'PLAYED':
          AppNotifier.showSuccess(
            context,
            'Результат подтверждён. Матч завершён.',
          );
          break;
        case 'CONFLICT':
          AppNotifier.showMessage(
            context,
            'Счёт не совпал. Можно открыть спор через кнопку «${l10n.toCourt}».',
            title: l10n.notifTitleInfo,
            type: AppNotificationType.info,
          );
          break;
        default:
          AppNotifier.showMessage(
            context,
            'Результат отправлен. Ждём подтверждение второго игрока.',
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
    final state = cubit.state;

    if (!state.canOpenDispute && !(state.disputeId?.isNotEmpty ?? false)) {
      AppNotifier.showMessage(
        context,
        'Спор можно открыть после статуса CONFLICT или если спор уже создан.',
        title: 'Пока недоступно',
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

    final payload = await _showCreateDisputeSheet(context);
    if (!context.mounted || payload == null) return;

    try {
      final disputeId = await cubit.createDispute(
        comment: payload.comment,
        plaintiffStatement: payload.plaintiffStatement,
        defendantStatement: payload.defendantStatement,
        evidenceUrl: payload.evidenceUrl,
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

  static void _showInfo(BuildContext context) {
    showFrostedInfoModal(
      context,
      title: 'Как отправить результат',
      subtitle: 'Финальный счёт должен подтвердиться обеими сторонами.',
      tips: const [
        'Нажмите на карточку игрока и выберите его итоговый счёт.',
        'После отправки второй игрок должен отправить совпадающий результат.',
        'Если данные расходятся, открывайте спор через «В суд».',
      ],
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
                  'Выберите счёт',
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

  Future<_CreateDisputePayload?> _showCreateDisputeSheet(
    BuildContext context,
  ) async {
    final palette = context.palette;
    final commentController = TextEditingController();
    final plaintiffController = TextEditingController();
    final defendantController = TextEditingController();
    final evidenceController = TextEditingController();

    final payload = await showModalBottomSheet<_CreateDisputePayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Открыть спор',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                12.vSpacing,
                _SheetField(
                  controller: commentController,
                  label: 'Комментарий к спору *',
                  minLines: 2,
                ),
                10.vSpacing,
                _SheetField(
                  controller: plaintiffController,
                  label: 'Заявление истца (опционально)',
                  minLines: 2,
                ),
                10.vSpacing,
                _SheetField(
                  controller: defendantController,
                  label: 'Заявление ответчика (опционально)',
                  minLines: 2,
                ),
                10.vSpacing,
                _SheetField(
                  controller: evidenceController,
                  label: 'Ссылка на видео/фото доказательства (опционально)',
                ),
                14.vSpacing,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final comment = commentController.text.trim();
                      if (comment.isEmpty) {
                        AppNotifier.showMessage(
                          context,
                          'Добавьте комментарий к спору.',
                          title: 'Проверка',
                          type: AppNotificationType.warning,
                        );
                        return;
                      }

                      Navigator.of(context).pop(
                        _CreateDisputePayload(
                          comment: comment,
                          plaintiffStatement: plaintiffController.text.trim(),
                          defendantStatement: defendantController.text.trim(),
                          evidenceUrl: evidenceController.text.trim(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Отправить в суд'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    commentController.dispose();
    plaintiffController.dispose();
    defendantController.dispose();
    evidenceController.dispose();

    return payload;
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    this.minLines,
  });

  final TextEditingController controller;
  final String label;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: minLines != null ? minLines! + 2 : 1,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: palette.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CreateDisputePayload {
  const _CreateDisputePayload({
    required this.comment,
    required this.plaintiffStatement,
    required this.defendantStatement,
    required this.evidenceUrl,
  });

  final String comment;
  final String plaintiffStatement;
  final String defendantStatement;
  final String evidenceUrl;
}
