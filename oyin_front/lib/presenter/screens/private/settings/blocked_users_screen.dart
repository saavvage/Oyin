import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  bool _loading = true;
  List<ChatThreadDto> _blocked = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final blocked = await ChatApi.getBlockedThreads();
      if (!mounted) return;
      setState(() {
        _blocked = blocked;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppNotifier.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

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
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  8.hSpacing,
                  Expanded(
                    child: Text(
                      l10n.blockedUsers,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: _blocked.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: palette.card,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        color: palette.muted,
                                        size: 36,
                                      ),
                                      10.vSpacing,
                                      Text(
                                        l10n.settingsBlockedSubtitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      6.vSpacing,
                                      Text(
                                        l10n.settingsBlockedTip1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: palette.muted),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              itemCount: _blocked.length,
                              itemBuilder: (context, index) {
                                final item = _blocked[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: palette.card,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: palette.accent,
                                        backgroundImage:
                                            item.avatarUrl.isNotEmpty
                                            ? NetworkImage(item.avatarUrl)
                                            : null,
                                        child: item.avatarUrl.isEmpty
                                            ? const Icon(Icons.person)
                                            : null,
                                      ),
                                      10.hSpacing,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            if (item.subtitle.isNotEmpty) ...[
                                              4.vSpacing,
                                              Text(
                                                item.subtitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: palette.muted,
                                                    ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => _unblock(item),
                                        child: Text(
                                          l10n.blockedUsersUnblock,
                                          style: TextStyle(
                                            color: palette.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _unblock(ChatThreadDto item) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ChatApi.unblockThread(item.id);
      if (!mounted) return;
      setState(() {
        _blocked = _blocked.where((thread) => thread.id != item.id).toList();
      });
      AppNotifier.showSuccess(context, l10n.blockedUsersUnblocked);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    }
  }
}
