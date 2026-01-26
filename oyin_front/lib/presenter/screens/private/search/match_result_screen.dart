import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'cubit/_export.dart';
import 'widgets/_export.dart';

class MatchResultScreen extends StatelessWidget {
  const MatchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchResultCubit(),
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
                  MatchResultHeader(l10n: l10n),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  24.vSpacing,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlayerScoreCard(
                        player: state.leftPlayer,
                        onTap: () {
                          // hook up score picker
                        },
                      ),
                      Text(
                        'VS',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800, color: palette.muted),
                      ),
                      PlayerScoreCard(
                        player: state.rightPlayer,
                        onTap: () {
                          // hook up score picker
                        },
                      ),
                    ],
                  ),
                  24.vSpacing,
                  SubmitBlock(l10n: l10n),
                  24.vSpacing,
                  DisputeBlock(l10n: l10n),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
