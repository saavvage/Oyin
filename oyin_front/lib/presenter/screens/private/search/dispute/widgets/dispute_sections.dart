import 'package:flutter/material.dart';

import '../../../../../../app/localization/app_localizations.dart';
import '../../../../../extensions/_export.dart';
import '../../../../../../infrastructure/export.dart';

class DisputeRewardCard extends StatelessWidget {
  const DisputeRewardCard({
    super.key,
    required this.karma,
    required this.isResolved,
    required this.winnerName,
  });

  final int karma;
  final bool isResolved;
  final String winnerName;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 0.35),
            Colors.blue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green.withValues(alpha: 0.22),
            child: Icon(
              isResolved ? Icons.check_rounded : Icons.bolt_rounded,
              color: Colors.greenAccent,
            ),
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isResolved ? '+$karma Karma Earned' : '+$karma Karma Pending',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                4.vSpacing,
                Text(
                  isResolved
                      ? 'Final verdict: $winnerName.'
                      : 'Review impartially to earn your reward.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisputeStatementCard extends StatelessWidget {
  const DisputeStatementCard({
    super.key,
    required this.color,
    required this.name,
    required this.role,
    required this.text,
  });

  final Color color;
  final String name;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name · $role',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          8.vSpacing,
          Text(text),
        ],
      ),
    );
  }
}

class DisputeVotesBar extends StatelessWidget {
  const DisputeVotesBar({super.key, required this.dispute});

  final DisputeDetailsDto dispute;

  @override
  Widget build(BuildContext context) {
    final summary = dispute.voteSummary;
    return Row(
      children: [
        _VoteCounter(
          label: dispute.player1.name,
          value: summary.player1,
          color: Colors.blueAccent,
        ),
        10.hSpacing,
        _VoteCounter(
          label: dispute.player2.name,
          value: summary.player2,
          color: Colors.redAccent,
        ),
        10.hSpacing,
        _VoteCounter(label: AppLocalizations.of(context).draw, value: summary.draw, color: Colors.grey),
      ],
    );
  }
}

class _VoteCounter extends StatelessWidget {
  const _VoteCounter({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.55)),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            4.vSpacing,
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class DisputeVoteButtons extends StatelessWidget {
  const DisputeVoteButtons({
    super.key,
    required this.isVoting,
    required this.player1Name,
    required this.player2Name,
    required this.onVotePlayer1,
    required this.onVotePlayer2,
    required this.onVoteDraw,
  });

  final bool isVoting;
  final String player1Name;
  final String player2Name;
  final VoidCallback onVotePlayer1;
  final VoidCallback onVotePlayer2;
  final VoidCallback onVoteDraw;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isVoting ? null : onVotePlayer1,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context).voteFor(player1Name)),
              ),
            ),
            10.hSpacing,
            Expanded(
              child: ElevatedButton(
                onPressed: isVoting ? null : onVotePlayer2,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context).voteFor(player2Name)),
              ),
            ),
          ],
        ),
        10.vSpacing,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isVoting ? null : onVoteDraw,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(AppLocalizations.of(context).cannotDetermine),
          ),
        ),
      ],
    );
  }
}

class DisputeResolvedBlock extends StatelessWidget {
  const DisputeResolvedBlock({
    super.key,
    required this.dispute,
    required this.winnerName,
  });

  final DisputeDetailsDto dispute;
  final String winnerName;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final rating = dispute.resolution?.ratingImpact;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Verdict',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.blueAccent,
              letterSpacing: 1,
            ),
          ),
          6.vSpacing,
          Text(
            '$winnerName won',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (rating != null) ...[
            12.vSpacing,
            Text(
              'Rating impact: ${rating.player1Before ?? '-'} -> ${rating.player1After ?? '-'} | '
              '${rating.player2Before ?? '-'} -> ${rating.player2After ?? '-'}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
          ],
          14.vSpacing,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(AppLocalizations.of(context).returnToDashboard),
            ),
          ),
        ],
      ),
    );
  }
}
