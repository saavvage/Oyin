import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../infrastructure/export.dart';
import '../contract_draft_store.dart';
import 'match_result_state.dart';

class MatchResultCubit extends Cubit<MatchResultState> {
  MatchResultCubit({
    required String gameId,
    required String challengerName,
    required String opponentName,
    String opponentAvatarUrl = '',
  }) : super(
         MatchResultState.initial(
           gameId: gameId,
           challengerName: challengerName,
           opponentName: opponentName,
           opponentAvatarUrl: opponentAvatarUrl,
         ),
       ) {
    loadGame();
  }

  bool get _isDemoGame => state.gameId.startsWith('demo-game-');

  Future<void> loadGame() async {
    if (_isDemoGame) {
      final draft = ContractDraftStore.get(state.gameId);
      final hasConfirmedContract =
          draft?.confirmed == true && draft?.dateTime != null;
      final contract = hasConfirmedContract
          ? MatchResultContract(
              dateTime: draft!.dateTime!,
              location: draft.location,
              reminder: draft.reminder,
            )
          : null;

      final status = hasConfirmedContract ? 'SCHEDULED' : 'PENDING';
      emit(
        state.copyWith(
          isLoading: false,
          clearError: true,
          statusLabel: status,
          title: _statusTitle(status, hasContract: hasConfirmedContract),
          dateLabel: contract != null
              ? _formatContractDate(contract.dateTime)
              : _statusDateLabel(status),
          locationLabel: contract != null && contract.location.trim().isNotEmpty
              ? contract.location
              : 'Court TBD',
          contract: contract,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final values = await Future.wait<dynamic>([
        GamesApi.getById(state.gameId),
        UsersApi.getMe(),
      ]);

      final game = values[0] as GameDetailsDto;
      final me = values[1] as Map<String, dynamic>;
      final currentUserId = (me['id'] ?? '').toString();

      _applyGame(game, currentUserId: currentUserId);

      if (game.status == 'DISPUTED' && state.disputeId == null) {
        await _resolveMyDisputeId();
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void setScoreLeft(int value) {
    emit(state.copyWith(leftPlayer: state.leftPlayer.copyWith(score: value)));
  }

  void setScoreRight(int value) {
    emit(state.copyWith(rightPlayer: state.rightPlayer.copyWith(score: value)));
  }

  Future<GameResultResponse?> submitResult() async {
    if (!state.canSubmit) {
      return null;
    }

    final left = state.leftPlayer.score!;
    final right = state.rightPlayer.score!;
    final myScore = state.isCurrentUserPlayer1 ? left : right;
    final opponentScore = state.isCurrentUserPlayer1 ? right : left;

    if (_isDemoGame) {
      emit(state.copyWith(isSubmitting: true, clearError: true));
      await Future.delayed(const Duration(milliseconds: 500));
      final status = myScore == opponentScore ? 'PLAYED' : 'PLAYED';
      emit(
        state.copyWith(
          isSubmitting: false,
          statusLabel: status,
          title: 'Result Confirmed',
          dateLabel: 'Completed',
        ),
      );
      return GameResultResponse(
        success: true,
        gameId: state.gameId,
        status: status,
        scoresMatch: true,
        game: null,
      );
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));

    try {
      final response = await GamesApi.submitResult(
        gameId: state.gameId,
        myScore: myScore,
        opponentScore: opponentScore,
      );

      if (response.game != null) {
        final me = await UsersApi.getMe();
        final currentUserId = (me['id'] ?? '').toString();
        _applyGame(response.game!, currentUserId: currentUserId);
      } else {
        await loadGame();
      }

      return response;
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      rethrow;
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  Future<String?> createDispute({
    required String comment,
    String? plaintiffStatement,
    String? defendantStatement,
    String? evidenceUrl,
    List<DisputeEvidenceInput> evidenceItems = const [],
  }) async {
    if (state.isCreatingDispute) {
      return state.disputeId;
    }

    if (_isDemoGame) {
      emit(state.copyWith(isCreatingDispute: true, clearError: true));
      await Future.delayed(const Duration(milliseconds: 400));
      final demoDisputeId = 'seed-dispute-${state.gameId}';
      emit(
        state.copyWith(
          isCreatingDispute: false,
          disputeId: demoDisputeId,
          statusLabel: 'DISPUTED',
        ),
      );
      return demoDisputeId;
    }

    emit(state.copyWith(isCreatingDispute: true, clearError: true));

    try {
      final response = await DisputesApi.createDispute(
        gameId: state.gameId,
        comment: comment,
        subject: state.title,
        sport: 'TENNIS',
        locationLabel: state.locationLabel,
        plaintiffStatement: plaintiffStatement,
        defendantStatement: defendantStatement,
        evidenceUrl: evidenceUrl,
        evidenceItems: evidenceItems,
      );

      emit(
        state.copyWith(
          disputeId: response.disputeId,
          statusLabel: response.dispute?.status ?? response.status,
        ),
      );

      return response.disputeId;
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      rethrow;
    } finally {
      emit(state.copyWith(isCreatingDispute: false));
    }
  }

  Future<String?> resolveDisputeId() async {
    if (state.disputeId != null && state.disputeId!.isNotEmpty) {
      return state.disputeId;
    }

    return _resolveMyDisputeId();
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  Future<String?> _resolveMyDisputeId() async {
    if (_isDemoGame) return state.disputeId;

    try {
      final disputes = await DisputesApi.getMyDisputes();
      final target = disputes.cast<DisputeDetailsDto?>().firstWhere(
        (item) => item?.gameId == state.gameId,
        orElse: () => null,
      );

      if (target != null) {
        emit(state.copyWith(disputeId: target.id, statusLabel: target.status));
        return target.id;
      }
    } catch (_) {
      // ignore lookup errors
    }

    return null;
  }

  void _applyGame(GameDetailsDto game, {required String currentUserId}) {
    final isPlayer1 = game.player1.id == currentUserId;
    final scorePair = _pickScorePair(game);
    final contract = _mapContract(game.contractData);

    emit(
      state.copyWith(
        title: _statusTitle(game.status, hasContract: contract != null),
        dateLabel: _extractDateLabel(game, contract),
        locationLabel: _extractLocation(game, contract),
        statusLabel: game.status,
        isCurrentUserPlayer1: isPlayer1,
        leftPlayer: MatchResultPlayer(
          id: game.player1.id,
          name: game.player1.name,
          avatarUrl: game.player1.avatarUrl,
          isYou: isPlayer1,
          score: scorePair?.$1 ?? state.leftPlayer.score,
        ),
        rightPlayer: MatchResultPlayer(
          id: game.player2.id,
          name: game.player2.name,
          avatarUrl: game.player2.avatarUrl,
          isYou: !isPlayer1,
          score: scorePair?.$2 ?? state.rightPlayer.score,
        ),
        contract: contract,
        disputeId: game.disputeId,
        isLoading: false,
      ),
    );
  }

  (int, int)? _pickScorePair(GameDetailsDto game) {
    final score = game.scorePlayer1 ?? game.scorePlayer2;
    if (score == null || score.isEmpty || !score.contains('-')) {
      return null;
    }

    final parts = score.split('-');
    if (parts.length != 2) {
      return null;
    }

    final left = int.tryParse(parts[0]);
    final right = int.tryParse(parts[1]);
    if (left == null || right == null) {
      return null;
    }

    return (left, right);
  }

  String _extractLocation(GameDetailsDto game, MatchResultContract? contract) {
    final contractLocation = contract?.location.trim() ?? '';
    if (contractLocation.isNotEmpty) {
      return contractLocation;
    }

    if (game.location != null && game.location!.isNotEmpty) {
      return game.location!;
    }
    final status = game.status;
    if (status == 'PENDING') {
      return 'Court TBD';
    }
    return 'Match Arena';
  }

  String _extractDateLabel(GameDetailsDto game, MatchResultContract? contract) {
    if (contract != null) {
      return _formatContractDate(contract.dateTime);
    }
    return _statusDateLabel(game.status);
  }

  String _statusTitle(String status, {required bool hasContract}) {
    switch (status) {
      case 'SCHEDULED':
        return 'Contract Confirmed';
      case 'PLAYED':
        return 'Result Confirmed';
      case 'CONFLICT':
        return 'Result Conflict';
      case 'DISPUTED':
        return 'Dispute In Progress';
      case 'PENDING':
        return hasContract ? 'Contract Confirmed' : 'Challenge Match';
      default:
        return 'Challenge Match';
    }
  }

  String _statusDateLabel(String status) {
    switch (status) {
      case 'PLAYED':
        return 'Completed';
      case 'CONFLICT':
      case 'DISPUTED':
        return 'Review needed';
      default:
        return 'Pending schedule';
    }
  }

  MatchResultContract? _mapContract(GameContractDto? raw) {
    if (raw == null) return null;
    final date = raw.date;
    if (date == null) return null;

    return MatchResultContract(
      dateTime: date,
      location: (raw.location ?? '').trim(),
      reminder: raw.reminder,
    );
  }

  String _formatContractDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }
}
