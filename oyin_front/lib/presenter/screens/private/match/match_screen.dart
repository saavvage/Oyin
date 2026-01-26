import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import 'cubit/_export.dart';
import 'widgets/_export.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchCubit(),
      child: const _MatchView(),
    );
  }
}

class _MatchView extends StatelessWidget {
  const _MatchView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<MatchCubit, MatchState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MatchHeader(l10n: l10n),
                  20.vSpacing,
                  MatchModeSwitch(
                    l10n: l10n,
                    nearbySelected: state.nearbySelected,
                    timeMatchSelected: state.timeMatchSelected,
                    onNearby: () => context.read<MatchCubit>().selectNearby(),
                    onTimeMatch: () => context.read<MatchCubit>().selectTimeMatch(),
                  ),
                  20.vSpacing,
                  MatchProfileCard(
                    profile: state.profile,
                    l10n: l10n,
                  ),
                  20.vSpacing,
                  MatchActionsRow(l10n: l10n),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
