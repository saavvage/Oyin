import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

class DisputeEvidenceDraft {
  const DisputeEvidenceDraft({
    required this.comment,
    required this.plaintiffStatement,
    required this.defendantStatement,
    required this.evidenceUrl,
    required this.evidenceItems,
  });

  final String comment;
  final String plaintiffStatement;
  final String defendantStatement;
  final String? evidenceUrl;
  final List<DisputeEvidenceInput> evidenceItems;
}

class DisputeEvidenceScreen extends StatefulWidget {
  const DisputeEvidenceScreen({super.key});

  @override
  State<DisputeEvidenceScreen> createState() => _DisputeEvidenceScreenState();
}

class _DisputeEvidenceScreenState extends State<DisputeEvidenceScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  XFile? _pickedVideo;
  bool _isSubmitting = false;
  bool _isUploadingVideo = false;

  bool get _isBusy => _isSubmitting || _isUploadingVideo;

  @override
  void dispose() {
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    if (_isBusy) return;

    try {
      final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (!mounted || picked == null) return;
      setState(() => _pickedVideo = picked);
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    }
  }

  Future<void> _submit() async {
    if (_isBusy) return;

    final l10n = AppLocalizations.of(context);
    final description = _descriptionController.text.trim();
    final evidenceLink = _urlController.text.trim();

    if (description.isEmpty) {
      AppNotifier.showMessage(
        context,
        l10n.disputeEvidenceDescriptionRequired,
        title: l10n.validationTitle,
        type: AppNotificationType.warning,
      );
      return;
    }

    if (_pickedVideo == null && evidenceLink.isEmpty) {
      AppNotifier.showMessage(
        context,
        l10n.disputeEvidenceRequired,
        title: l10n.validationTitle,
        type: AppNotificationType.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? firstEvidenceUrl;
      final evidenceItems = <DisputeEvidenceInput>[];

      if (_pickedVideo != null) {
        setState(() => _isUploadingVideo = true);
        final upload = await DisputesApi.uploadEvidenceFile(
          File(_pickedVideo!.path),
        );
        setState(() => _isUploadingVideo = false);

        if (upload == null || upload.url.isEmpty) {
          throw l10n.disputeEvidenceUploadFailed;
        }

        evidenceItems.add(
          DisputeEvidenceInput(
            type: upload.type,
            url: upload.url,
            thumbnailUrl: upload.thumbnailUrl,
            durationLabel: upload.durationLabel,
          ),
        );
        firstEvidenceUrl = upload.url;
      }

      if (evidenceLink.isNotEmpty) {
        final type = _typeFromUrl(evidenceLink);
        evidenceItems.add(
          DisputeEvidenceInput(
            type: type,
            url: evidenceLink,
            thumbnailUrl: type == 'PHOTO' ? evidenceLink : null,
          ),
        );
        firstEvidenceUrl ??= evidenceLink;
      }

      if (!mounted) return;
      Navigator.of(context).pop(
        DisputeEvidenceDraft(
          comment: description,
          plaintiffStatement: description,
          defendantStatement: '',
          evidenceUrl: firstEvidenceUrl,
          evidenceItems: evidenceItems,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isUploadingVideo = false;
        });
      }
    }
  }

  String _typeFromUrl(String url) {
    final lower = url.toLowerCase();
    const photoExt = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp'];
    if (photoExt.any(lower.contains)) {
      return 'PHOTO';
    }
    return 'VIDEO';
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
              padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: _isBusy
                        ? null
                        : () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      l10n.disputeEvidenceScreenTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.disputeEvidenceProvideDetailsTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    6.vSpacing,
                    Text(
                      l10n.disputeEvidenceProvideDetailsHint,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                    ),
                    16.vSpacing,
                    Text(
                      l10n.disputeEvidenceDescriptionLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.vSpacing,
                    TextField(
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: 6,
                      enabled: !_isBusy,
                      decoration: InputDecoration(
                        hintText: l10n.disputeEvidenceDescriptionHint,
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    18.vSpacing,
                    Text(
                      l10n.disputeEvidenceVideoTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.vSpacing,
                    GestureDetector(
                      onTap: _isBusy ? null : _pickVideo,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: palette.muted.withValues(alpha: 0.4),
                            width: 1.2,
                          ),
                        ),
                        child: _pickedVideo == null
                            ? Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: palette.primary.withValues(
                                      alpha: 0.22,
                                    ),
                                    child: Icon(
                                      Icons.cloud_upload_rounded,
                                      color: palette.primary,
                                    ),
                                  ),
                                  10.vSpacing,
                                  Text(
                                    l10n.disputeEvidenceTapUpload,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  4.vSpacing,
                                  Text(
                                    l10n.disputeEvidenceVideoHint,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: palette.muted),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  const Icon(Icons.videocam_rounded),
                                  10.hSpacing,
                                  Expanded(
                                    child: Text(
                                      _pickedVideo!.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _isBusy
                                        ? null
                                        : () => setState(
                                            () => _pickedVideo = null,
                                          ),
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    18.vSpacing,
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: palette.muted.withValues(alpha: 0.25),
                          ),
                        ),
                        12.hSpacing,
                        Text(
                          l10n.disputeEvidenceOrLink,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: palette.muted,
                                letterSpacing: 1,
                              ),
                        ),
                        12.hSpacing,
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: palette.muted.withValues(alpha: 0.25),
                          ),
                        ),
                      ],
                    ),
                    14.vSpacing,
                    Text(
                      l10n.disputeEvidenceUrlLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.vSpacing,
                    TextField(
                      controller: _urlController,
                      enabled: !_isBusy,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        hintText: l10n.disputeEvidenceUrlHint,
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    18.vSpacing,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isBusy ? null : _submit,
                        icon: _isBusy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                        label: Text(l10n.disputeEvidenceSubmit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.primary,
                          foregroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    12.vSpacing,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.disputeEvidenceFootnote,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: palette.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
