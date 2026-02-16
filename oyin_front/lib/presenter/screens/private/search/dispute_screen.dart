import 'package:flutter/material.dart';

import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';
import 'dispute/dispute_content.dart';
import 'dispute/widgets/_export.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key, this.disputeId, this.preferJuryDuty = false});

  final String? disputeId;
  final bool preferJuryDuty;

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  bool _isLoading = true;
  bool _isVoting = false;
  String? _error;
  DisputeDetailsDto? _dispute;
  int _selectedMedia = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      DisputeDetailsDto? dispute;

      if (widget.disputeId != null && widget.disputeId!.isNotEmpty) {
        dispute = await DisputesApi.getById(widget.disputeId!);
      } else {
        final juryDuty = await DisputesApi.getJuryDuty();
        if (juryDuty.isNotEmpty) {
          dispute = juryDuty.first;
        }
      }

      dispute ??= await _fallbackMyDispute();

      if (!mounted) return;
      setState(() {
        _dispute = dispute;
        _selectedMedia = 0;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<DisputeDetailsDto?> _fallbackMyDispute() async {
    final myDisputes = await DisputesApi.getMyDisputes();
    if (myDisputes.isEmpty) {
      return null;
    }

    if (widget.disputeId != null && widget.disputeId!.isNotEmpty) {
      return myDisputes.cast<DisputeDetailsDto?>().firstWhere(
        (item) => item?.id == widget.disputeId,
        orElse: () => null,
      );
    }

    return myDisputes.first;
  }

  Future<void> _vote(String side) async {
    if (_dispute == null || _isVoting) return;

    setState(() => _isVoting = true);
    try {
      final response = await DisputesApi.vote(
        disputeId: _dispute!.id,
        winner: side,
      );
      if (!mounted) return;

      setState(() {
        _dispute = response.dispute ?? _dispute;
      });

      if (response.myKarmaAward > 0) {
        AppNotifier.showSuccess(context, '+${response.myKarmaAward} karma');
      }
    } catch (error) {
      if (!mounted) return;
      AppNotifier.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isVoting = false);
      }
    }
  }

  void _setSelectedMedia(int index) {
    setState(() => _selectedMedia = index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? DisputeErrorState(message: _error!, onRetry: _load)
            : _dispute == null
            ? DisputeEmptyState(onRetry: _load)
            : DisputeContent(
                dispute: _dispute!,
                selectedMedia: _selectedMedia,
                isVoting: _isVoting,
                winnerName: _winnerName(_dispute!),
                onSelectMedia: _setSelectedMedia,
                onVote: _vote,
              ),
      ),
    );
  }

  String _winnerName(DisputeDetailsDto dispute) {
    final side = dispute.resolution?.winningSide;
    if (side == 'PLAYER1') return dispute.player1.name;
    if (side == 'PLAYER2') return dispute.player2.name;
    if (side == 'DRAW') return 'Draw';
    return 'Community';
  }
}
