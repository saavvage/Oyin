import 'package:flutter/material.dart';

import '../../../../extensions/_export.dart';
import '../cubit/chat_state.dart';
import '../../../../../app/localization/app_localizations.dart';

class ChatListCard extends StatelessWidget {
  const ChatListCard({
    super.key,
    required this.card,
    required this.onTap,
    this.accentLabel,
    this.actionLabel,
    this.accentColor,
  });

  final ChatCard card;
  final VoidCallback onTap;
  final String? accentLabel;
  final String? actionLabel;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final avatarUrl = card.avatarUrl.trim();
    final cardColor = card.highlight == true
        ? Colors.redAccent.withValues(alpha: 0.12)
        : palette.card;
    final borderColor = card.highlight == true
        ? Colors.redAccent
        : Colors.transparent;
    final statusColor = _statusColor(card.accent, palette);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: palette.accent,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl.isEmpty
                      ? Icon(Icons.person, color: palette.muted)
                      : null,
                ),
                12.hSpacing,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            card.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          6.hSpacing,
                          Icon(
                            Icons.search,
                            size: 14,
                            color: palette.iconMuted,
                          ),
                        ],
                      ),
                      4.vSpacing,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _statusText(card.statusKey, l10n),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      card.timestamp,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: palette.muted),
                    ),
                    if (card.badgeCount != null) ...[
                      6.vSpacing,
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          card.badgeCount.toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            12.vSpacing,
            Text(card.subtitle, style: Theme.of(context).textTheme.bodyMedium),
            if (card.buttonKey != null) ...[
              12.vSpacing,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: card.highlight == true
                        ? const Color(0xFF542B35)
                        : palette.primary,
                    foregroundColor: card.highlight == true
                        ? Colors.redAccent
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _buttonText(card.buttonKey!, l10n),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      6.hSpacing,
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(String? accent, AppPalette palette) {
    switch (accent) {
      case 'red':
        return Colors.redAccent;
      case 'green':
        return palette.success;
      case 'yellow':
        return Colors.amber;
      default:
        return palette.iconMuted;
    }
  }

  String _statusText(String key, AppLocalizations l10n) {
    switch (key) {
      case 'status_dispute_open':
        return l10n.statusDisputeOpen;
      case 'status_contract_signed':
        return l10n.statusContractSigned;
      case 'status_drafting_contract':
        return l10n.statusDraftingContract;
      case 'status_matched':
        return l10n.statusMatched;
      default:
        return key;
    }
  }

  String _buttonText(String key, AppLocalizations l10n) {
    switch (key) {
      case 'resolve':
        return l10n.resolveDispute;
      case 'view':
        return l10n.viewProposal;
      default:
        return key;
    }
  }
}
