import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import '../../../mixins/infinite_scroll.dart';
import 'cubit/messanger_cubit.dart';
import 'cubit/messanger_state.dart';

class MessangerScreen extends StatefulWidget {
  const MessangerScreen({
    required this.chatId,
    required this.partnerName,
    required this.partnerAvatarUrl,
    super.key,
  });

  final String chatId;
  final String partnerName;
  final String partnerAvatarUrl;

  @override
  State<MessangerScreen> createState() => _MessangerScreenState();
}

class _MessangerScreenState extends State<MessangerScreen>
    with InfiniteScrollMixin {
  final TextEditingController _messageController = TextEditingController();
  late final MessangerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MessangerCubit(
      chatId: widget.chatId,
      partnerName: widget.partnerName,
      partnerAvatarUrl: widget.partnerAvatarUrl,
    );
    _cubit.loadInitial();

    setupInfiniteScroll(
      onLoadMore: () => _cubit.loadMore(),
      canLoadMore: () => _cubit.state.hasMore && !_cubit.state.isLoadingMore,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: palette.background,
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<MessangerCubit, MessangerState>(
                builder: (context, state) {
                  return _Header(
                    name: state.partnerName,
                    avatarUrl: state.partnerAvatarUrl,
                    onMenu: _onMenuAction,
                  );
                },
              ),
              8.vSpacing,
              Expanded(
                child: BlocBuilder<MessangerCubit, MessangerState>(
                  builder: (context, state) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.messengerStartConversation,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.colored(palette.muted),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount:
                          state.messages.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (state.isLoadingMore &&
                            index == state.messages.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        final message = state.messages[index];
                        return _MessageBubble(message: message);
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<MessangerCubit, MessangerState>(
                builder: (context, state) {
                  return _InputBar(
                    controller: _messageController,
                    isBlocked: state.isBlocked,
                    onSend: _sendMessage,
                    onAttach: _showAttachmentSheet,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_cubit.state.isBlocked) return;
    final text = _messageController.text;
    _messageController.clear();
    await _cubit.sendText(text);
    if (!mounted) return;
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onMenuAction(_MenuAction action) async {
    switch (action) {
      case _MenuAction.delete:
        await _confirmDeleteChat();
        break;
      case _MenuAction.block:
        await _confirmBlockUser();
        break;
      case _MenuAction.report:
        await _openReportModal();
        break;
    }
  }

  Future<void> _confirmDeleteChat() async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirmAction(
      title: l10n.messengerDialogDeleteTitle,
      desc: l10n.messengerDialogDeleteDesc,
      confirmLabel: l10n.messengerDialogDeleteConfirm,
      onConfirm: () => _cubit.deleteChat(),
    );
    if (!ok || !mounted) return;
    _showSnack(
      l10n.messengerChatDeleted,
      title: l10n.notifTitleSuccess,
      type: AppNotificationType.success,
    );
  }

  Future<void> _confirmBlockUser() async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirmAction(
      title: l10n.messengerDialogBlockTitle,
      desc: l10n.messengerDialogBlockDesc,
      confirmLabel: l10n.messengerDialogBlockConfirm,
      onConfirm: () => _cubit.blockUser(),
    );
    if (!ok || !mounted) return;
    _showSnack(
      l10n.messengerUserBlocked,
      title: l10n.notifTitleSuccess,
      type: AppNotificationType.success,
    );
  }

  Future<bool> _confirmAction({
    required String title,
    required String desc,
    required String confirmLabel,
    required Future<bool> Function() onConfirm,
  }) async {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.card,
        title: Text(title),
        content: Text(desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonNo),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    if (result != true) return false;

    final ok = await onConfirm();
    if (!mounted) return false;
    if (!ok) {
      _showSnack(
        l10n.messengerSomethingWrong,
        title: l10n.notifTitleError,
        type: AppNotificationType.error,
      );
      return false;
    }
    return true;
  }

  Future<void> _openReportModal() async {
    final l10n = AppLocalizations.of(context);
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ReportSheet(
        partnerName: _cubit.state.partnerName,
        onSubmit: (reason) => _cubit.reportUser(reason: reason),
      ),
    );

    if (sent == true && mounted) {
      _showSnack(
        l10n.messengerReportSent,
        title: l10n.notifTitleSuccess,
        type: AppNotificationType.success,
      );
    }
  }

  Future<void> _showAttachmentSheet() async {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetAction(
                  icon: Icons.camera_alt,
                  title: l10n.messengerAttachmentCamera,
                  onTap: () => _pickCameraPhoto(context),
                ),
                12.vSpacing,
                _SheetAction(
                  icon: Icons.photo_library,
                  title: l10n.messengerAttachmentLibrary,
                  onTap: () => _pickMedia(context),
                ),
                12.vSpacing,
                _SheetAction(
                  icon: Icons.attach_file,
                  title: l10n.messengerAttachmentFile,
                  onTap: () => _pickFile(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickCameraPhoto(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (file == null) return;
    await _cubit.sendAttachment(
      MessageAttachment(
        type: AttachmentType.image,
        name: l10n.messengerAttachmentPhoto,
        path: file.path,
      ),
    );
  }

  Future<void> _pickMedia(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    Navigator.of(context).pop();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetAction(
                  icon: Icons.photo,
                  title: l10n.messengerAttachmentPhoto,
                  onTap: () async {
                    Navigator.of(context).pop();
                    final file = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (file == null) return;
                    await _cubit.sendAttachment(
                      MessageAttachment(
                        type: AttachmentType.image,
                        name: l10n.messengerAttachmentPhoto,
                        path: file.path,
                      ),
                    );
                  },
                ),
                12.vSpacing,
                _SheetAction(
                  icon: Icons.videocam,
                  title: l10n.messengerAttachmentVideo,
                  onTap: () async {
                    Navigator.of(context).pop();
                    final file = await ImagePicker().pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (file == null) return;
                    await _cubit.sendAttachment(
                      MessageAttachment(
                        type: AttachmentType.video,
                        name: l10n.messengerAttachmentVideo,
                        path: file.path,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    Navigator.of(context).pop();
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    await _cubit.sendAttachment(
      MessageAttachment(
        type: AttachmentType.file,
        name: file.name,
        path: file.path ?? '',
      ),
    );
  }

  void _showSnack(
    String message, {
    String? title,
    AppNotificationType type = AppNotificationType.info,
  }) {
    final l10n = AppLocalizations.of(context);
    AppNotifier.showMessage(
      context,
      message,
      title: title ?? l10n.notifTitleInfo,
      type: type,
    );
  }
}

enum _MenuAction { delete, block, report }

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.avatarUrl,
    required this.onMenu,
  });

  final String name;
  final String avatarUrl;
  final Future<void> Function(_MenuAction action) onMenu;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    final safeAvatarUrl = avatarUrl.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: palette.accent,
            backgroundImage: safeAvatarUrl.isNotEmpty
                ? NetworkImage(safeAvatarUrl)
                : null,
            child: safeAvatarUrl.isEmpty
                ? Icon(Icons.person, color: palette.muted)
                : null,
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.weighted(FontWeight.w700),
                ),
                Text(
                  l10n.messengerOnline,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.colored(palette.muted),
                ),
              ],
            ),
          ),
          PopupMenuButton<_MenuAction>(
            tooltip: '',
            color: palette.card,
            surfaceTintColor: Colors.transparent,
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: palette.badge),
            ),
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: palette.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.badge),
              ),
              child: const Icon(Icons.more_horiz_rounded, size: 22),
            ),
            onSelected: onMenu,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _MenuAction.delete,
                child: _MenuActionRow(
                  icon: Icons.delete_outline_rounded,
                  label: l10n.messengerActionDeleteChat,
                  iconColor: Colors.redAccent,
                ),
              ),
              PopupMenuItem(
                value: _MenuAction.block,
                child: _MenuActionRow(
                  icon: Icons.block_rounded,
                  label: l10n.messengerActionBlockUser,
                  iconColor: Colors.orangeAccent,
                ),
              ),
              PopupMenuItem(
                value: _MenuAction.report,
                child: _MenuActionRow(
                  icon: Icons.flag_rounded,
                  label: l10n.messengerActionReport,
                  iconColor: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuActionRow extends StatelessWidget {
  const _MenuActionRow({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        10.hSpacing,
        Text(label),
      ],
    );
  }
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.partnerName, required this.onSubmit});

  final String partnerName;
  final Future<bool> Function(String reason) onSubmit;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  static const int _maxChars = 500;

  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;
  String? _errorText;
  int _usedChars = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final reason = _controller.text.trim();
    if (reason.isEmpty) {
      setState(() => _errorText = l10n.messengerReportDescriptionRequired);
      return;
    }

    setState(() {
      _errorText = null;
      _isSending = true;
    });

    final ok = await widget.onSubmit(reason);
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => _isSending = false);
    AppNotifier.showMessage(
      context,
      l10n.messengerSomethingWrong,
      title: l10n.notifTitleError,
      type: AppNotificationType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final used = _usedChars;
    final left = (_maxChars - used).clamp(0, _maxChars).toInt();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.badge,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            14.vSpacing,
            Text(
              l10n.messengerDialogReportTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.weighted(FontWeight.w800),
            ),
            12.vSpacing,
            Text(
              l10n.messengerReportTargetLabel,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.colored(palette.muted),
            ),
            8.vSpacing,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: palette.badge),
              ),
              child: Text(
                widget.partnerName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.weighted(FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            14.vSpacing,
            Text(
              l10n.messengerReportDescriptionTitle,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.colored(palette.muted),
            ),
            8.vSpacing,
            TextField(
              controller: _controller,
              enabled: !_isSending,
              maxLength: _maxChars,
              maxLines: 7,
              minLines: 5,
              onChanged: (value) {
                setState(() {
                  _usedChars = value.length;
                  if (_errorText != null) {
                    _errorText = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: l10n.messengerReportDescriptionHint,
                alignLabelWithHint: true,
                errorText: _errorText,
                counterText: '',
                filled: true,
                fillColor: palette.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: palette.badge),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: palette.badge),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: palette.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            6.vSpacing,
            Text(
              l10n.messengerReportCounter(used, _maxChars, left),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.colored(palette.muted),
            ),
            16.vSpacing,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        l10n.messengerDialogReportConfirm,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isMine = message.isMine;

    final bgColor = isMine ? palette.primary : palette.card;
    final textColor = isMine ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.74,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMine ? 16 : 4),
                bottomRight: Radius.circular(isMine ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.attachments.isNotEmpty) ...[
                  _AttachmentRow(attachments: message.attachments),
                  if (message.text.isNotEmpty) 8.vSpacing,
                ],
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.colored(textColor),
                  ),
                6.vSpacing,
                Text(
                  _formatTime(message.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.colored(
                    isMine ? Colors.black54 : palette.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({required this.attachments});

  final List<MessageAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: attachments.map((att) {
        IconData icon;
        switch (att.type) {
          case AttachmentType.image:
            icon = Icons.photo;
            break;
          case AttachmentType.video:
            icon = Icons.videocam;
            break;
          case AttachmentType.file:
            icon = Icons.insert_drive_file;
            break;
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: palette.primary),
              8.hSpacing,
              Flexible(
                child: Text(
                  att.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.colored(Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onAttach,
    required this.isBlocked,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: isBlocked ? null : onAttach,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: palette.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: palette.badge),
                ),
                child: Icon(Icons.add, color: palette.primary),
              ),
            ),
            10.hSpacing,
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isBlocked,
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: isBlocked
                      ? l10n.messengerBlockedHint
                      : l10n.messengerMessageHint,
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodySmall?.colored(palette.muted),
                  filled: true,
                  fillColor: palette.card,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            10.hSpacing,
            GestureDetector(
              onTap: isBlocked ? null : onSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isBlocked ? palette.badge : palette.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: isBlocked ? palette.muted : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.badge),
        ),
        child: Row(
          children: [
            Icon(icon, color: palette.primary),
            12.hSpacing,
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.weighted(FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
