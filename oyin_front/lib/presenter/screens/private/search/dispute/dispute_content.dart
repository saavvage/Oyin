import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations.dart';
import '../../../../../infrastructure/export.dart';
import '../../../../extensions/_export.dart';
import '../../../../widgets/_export.dart';
import 'widgets/_export.dart';

class DisputeContent extends StatelessWidget {
  const DisputeContent({
    super.key,
    required this.dispute,
    required this.selectedMedia,
    required this.isVoting,
    required this.winnerName,
    required this.onSelectMedia,
    required this.onVote,
  });

  final DisputeDetailsDto dispute;
  final int selectedMedia;
  final bool isVoting;
  final String winnerName;
  final ValueChanged<int> onSelectMedia;
  final ValueChanged<String> onVote;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final media = dispute.evidence;
    final selected = media.isNotEmpty
        ? media[selectedMedia.clamp(0, media.length - 1)]
        : null;
    final isResolved = dispute.status == 'RESOLVED';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: Text(
                  l10n.disputeHeader(dispute.displayId),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () => _showInfo(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisputeRewardCard(
                  karma: dispute.rewardKarma,
                  isResolved: isResolved,
                  winnerName: winnerName,
                ),
                16.vSpacing,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: palette.accent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.sportName(dispute.sport),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      10.vSpacing,
                      Text(
                        dispute.subject,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      6.vSpacing,
                      Text(
                        dispute.locationLabel,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: palette.muted),
                      ),
                    ],
                  ),
                ),
                16.vSpacing,
                Text(
                  l10n.disputeEvidence,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                10.vSpacing,
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: palette.card,
                      child: selected == null
                          ? Center(child: Text(l10n.noEvidence))
                          : _buildEvidencePreview(context, selected),
                    ),
                  ),
                ),
                if (media.length > 1) ...[
                  10.vSpacing,
                  SizedBox(
                    height: 76,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: media.length,
                      separatorBuilder: (context, index) => 10.hSpacing,
                      itemBuilder: (context, index) {
                        final item = media[index];
                        final active = index == selectedMedia;
                        return GestureDetector(
                          onTap: () => onSelectMedia(index),
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _buildEvidenceThumbnail(item),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                18.vSpacing,
                Text(
                  l10n.disputeStatements,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                10.vSpacing,
                DisputeStatementCard(
                  color: Colors.blueAccent,
                  name: dispute.plaintiff.name,
                  role: l10n.disputeRolePlaintiff,
                  text: dispute.plaintiff.statement.isNotEmpty
                      ? dispute.plaintiff.statement
                      : dispute.description,
                ),
                10.vSpacing,
                DisputeStatementCard(
                  color: Colors.redAccent,
                  name: dispute.defendant.name,
                  role: l10n.disputeRoleDefendant,
                  text: dispute.defendant.statement.isNotEmpty
                      ? dispute.defendant.statement
                      : l10n.disputeDefendantFallback,
                ),
                16.vSpacing,
                DisputeVotesBar(dispute: dispute),
                18.vSpacing,
                if (!isResolved && dispute.canVote)
                  DisputeVoteButtons(
                    isVoting: isVoting,
                    player1Name: dispute.player1.name,
                    player2Name: dispute.player2.name,
                    onVotePlayer1: () => onVote('PLAYER1'),
                    onVotePlayer2: () => onVote('PLAYER2'),
                    onVoteDraw: () => onVote('DRAW'),
                  )
                else if (!isResolved)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: palette.card,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      dispute.hasVoted
                          ? l10n.disputeVoteAccepted
                          : l10n.disputeVoteParticipantWait,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                    ),
                  ),
                if (isResolved)
                  DisputeResolvedBlock(
                    dispute: dispute,
                    winnerName: winnerName,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showFrostedInfoModal(
      context,
      title: l10n.infoDisputeTitle,
      subtitle: l10n.infoDisputeSubtitle,
      tips: [l10n.infoDisputeTip1, l10n.infoDisputeTip2, l10n.infoDisputeTip3],
    );
  }

  Widget _buildEvidencePreview(BuildContext context, DisputeEvidenceDto item) {
    final previewUrl = item.thumbnailUrl?.isNotEmpty == true
        ? item.thumbnailUrl!
        : item.url;
    final isVideo = item.type.toUpperCase() == 'VIDEO';

    return Stack(
      children: [
        Positioned.fill(
          child:
              isVideo &&
                  (item.thumbnailUrl == null || item.thumbnailUrl!.isEmpty)
              ? Container(color: Colors.black12)
              : Image.network(
                  previewUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(color: Colors.black12),
                ),
        ),
        if (isVideo)
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              child: const Icon(Icons.play_arrow_rounded, size: 40),
            ),
          ),
      ],
    );
  }

  Widget _buildEvidenceThumbnail(DisputeEvidenceDto item) {
    final thumbUrl = item.thumbnailUrl?.isNotEmpty == true
        ? item.thumbnailUrl!
        : item.url;
    final isVideo = item.type.toUpperCase() == 'VIDEO';

    if (isVideo && (item.thumbnailUrl == null || item.thumbnailUrl!.isEmpty)) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.play_circle_fill_rounded),
      );
    }

    return Image.network(
      thumbUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: Icon(
          isVideo ? Icons.play_circle_fill_rounded : Icons.broken_image_rounded,
        ),
      ),
    );
  }
}
