import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
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

      if (_isDemoDisputeId(widget.disputeId)) {
        dispute = _buildDemoDispute(widget.disputeId!);
      } else if (widget.disputeId != null && widget.disputeId!.isNotEmpty) {
        dispute = await DisputesApi.getById(widget.disputeId!);
      } else {
        final juryDuty = await DisputesApi.getJuryDuty();
        if (juryDuty.isNotEmpty) {
          dispute = juryDuty.first;
        }
      }

      dispute ??= await _fallbackMyDispute();
      if (dispute == null && widget.preferJuryDuty) {
        dispute = _buildDemoDispute('seed-dispute-default');
      }

      if (!mounted) return;
      setState(() {
        _dispute = dispute;
        _selectedMedia = 0;
      });
    } catch (error) {
      if (!mounted) return;
      if (_isDemoDisputeId(widget.disputeId)) {
        setState(() {
          _dispute = _buildDemoDispute(widget.disputeId!);
          _selectedMedia = 0;
          _error = null;
        });
      } else {
        setState(() {
          _error = error.toString();
        });
      }
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
    if (_isDemoDisputeId(_dispute!.id)) {
      final updated = _applyDemoVote(_dispute!, side);
      setState(() => _dispute = updated);
      final l10n = AppLocalizations.of(context);
      AppNotifier.showSuccess(
        context,
        updated.status == 'RESOLVED'
            ? l10n.karmaDemo
            : l10n.voteCountedDemo,
      );
      return;
    }

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

  bool _isDemoDisputeId(String? disputeId) {
    if (disputeId == null || disputeId.isEmpty) return false;
    return disputeId.startsWith('seed-dispute-');
  }

  DisputeDetailsDto _buildDemoDispute(String disputeId) {
    final now = DateTime.now();
    return DisputeDetailsDto(
      id: disputeId,
      displayId: '4920',
      gameId: 'seed-game-4920',
      status: 'VOTING',
      sport: 'Tennis',
      subject: 'Set 3 Tie-breaker Dispute',
      locationLabel: 'Santa Monica, CA',
      description:
          'Final rally line call is contested. Please review slow-motion evidence.',
      createdAt: now.subtract(const Duration(minutes: 18)),
      resolvedAt: null,
      rewardKarma: 50,
      player1: const DisputePlayerSideDto(
        id: 'seed-player-1',
        name: 'John D.',
        avatarUrl: 'https://i.pravatar.cc/200?img=12',
        reliabilityScore: 91,
      ),
      player2: const DisputePlayerSideDto(
        id: 'seed-player-2',
        name: 'Sarah M.',
        avatarUrl: 'https://i.pravatar.cc/200?img=47',
        reliabilityScore: 84,
      ),
      plaintiff: const DisputeParticipantDto(
        id: 'seed-player-1',
        name: 'John D.',
        avatarUrl: 'https://i.pravatar.cc/200?img=12',
        statement:
            'I clearly hit the line on the final serve. Slow-motion at 00:45 shows chalk flying up.',
      ),
      defendant: const DisputeParticipantDto(
        id: 'seed-player-2',
        name: 'Sarah M.',
        avatarUrl: 'https://i.pravatar.cc/200?img=47',
        statement:
            'The ball was out by at least two inches. The mark in the second photo is from a previous rally.',
      ),
      evidence: const [
        DisputeEvidenceDto(
          id: 'seed-ev-1',
          type: 'VIDEO',
          url:
              'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1280&q=80',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?auto=format&fit=crop&w=1280&q=80',
          durationLabel: '02:00',
        ),
        DisputeEvidenceDto(
          id: 'seed-ev-2',
          type: 'PHOTO',
          url:
              'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
          durationLabel: null,
        ),
        DisputeEvidenceDto(
          id: 'seed-ev-3',
          type: 'PHOTO',
          url:
              'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=80',
          durationLabel: null,
        ),
      ],
      voteSummary: const DisputeVoteSummaryDto(
        total: 2,
        requiredToResolve: 3,
        player1: 1,
        player2: 1,
        draw: 0,
      ),
      hasVoted: false,
      myVote: null,
      canVote: true,
      resolution: null,
    );
  }

  DisputeDetailsDto _applyDemoVote(DisputeDetailsDto dispute, String side) {
    var player1Votes = dispute.voteSummary.player1;
    var player2Votes = dispute.voteSummary.player2;
    var drawVotes = dispute.voteSummary.draw;

    switch (side) {
      case 'PLAYER1':
        player1Votes += 1;
        break;
      case 'PLAYER2':
        player2Votes += 1;
        break;
      case 'DRAW':
        drawVotes += 1;
        break;
      default:
        break;
    }

    final requiredVotes = dispute.voteSummary.requiredToResolve;
    final totalVotes = player1Votes + player2Votes + drawVotes;

    String status = dispute.status;
    DateTime? resolvedAt = dispute.resolvedAt;
    DisputeResolutionDto? resolution = dispute.resolution;

    final hasPlayer1Winner = player1Votes >= requiredVotes;
    final hasPlayer2Winner = player2Votes >= requiredVotes;
    final hasDrawWinner = drawVotes >= requiredVotes;

    if (hasPlayer1Winner || hasPlayer2Winner || hasDrawWinner) {
      status = 'RESOLVED';
      resolvedAt = DateTime.now();

      final winningSide = hasPlayer1Winner
          ? 'PLAYER1'
          : hasPlayer2Winner
          ? 'PLAYER2'
          : 'DRAW';

      final winner = winningSide == 'DRAW'
          ? null
          : (winningSide == 'PLAYER1'
                ? DisputeResolutionPersonDto(
                    id: dispute.player1.id,
                    name: dispute.player1.name,
                    avatarUrl: dispute.player1.avatarUrl,
                  )
                : DisputeResolutionPersonDto(
                    id: dispute.player2.id,
                    name: dispute.player2.name,
                    avatarUrl: dispute.player2.avatarUrl,
                  ));

      final loser = winningSide == 'DRAW'
          ? null
          : (winningSide == 'PLAYER1'
                ? DisputeResolutionPersonDto(
                    id: dispute.player2.id,
                    name: dispute.player2.name,
                    avatarUrl: dispute.player2.avatarUrl,
                  )
                : DisputeResolutionPersonDto(
                    id: dispute.player1.id,
                    name: dispute.player1.name,
                    avatarUrl: dispute.player1.avatarUrl,
                  ));

      resolution = DisputeResolutionDto(
        winningSide: winningSide,
        winner: winner,
        loser: loser,
        ratingImpact: const DisputeRatingImpactDto(
          player1Before: 1250,
          player1After: 1275,
          player2Before: 1180,
          player2After: 1155,
        ),
      );
    }

    return DisputeDetailsDto(
      id: dispute.id,
      displayId: dispute.displayId,
      gameId: dispute.gameId,
      status: status,
      sport: dispute.sport,
      subject: dispute.subject,
      locationLabel: dispute.locationLabel,
      description: dispute.description,
      createdAt: dispute.createdAt,
      resolvedAt: resolvedAt,
      rewardKarma: dispute.rewardKarma,
      player1: dispute.player1,
      player2: dispute.player2,
      plaintiff: dispute.plaintiff,
      defendant: dispute.defendant,
      evidence: dispute.evidence,
      voteSummary: DisputeVoteSummaryDto(
        total: totalVotes,
        requiredToResolve: requiredVotes,
        player1: player1Votes,
        player2: player2Votes,
        draw: drawVotes,
      ),
      hasVoted: true,
      myVote: side,
      canVote: false,
      resolution: resolution,
    );
  }
}
