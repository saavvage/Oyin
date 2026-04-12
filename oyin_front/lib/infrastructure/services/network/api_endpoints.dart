class ApiEndpoints {
  static const String health = '/';

  // Auth
  static const String authRegister = '/auth/register';
  static const String authLoginPassword = '/auth/login-password';
  static const String authLogin = '/auth/login';
  static const String authVerify = '/auth/verify';

  // Users
  static const String usersMe = '/users/me';
  static const String usersUpdateProfile = '/users/me';
  static const String usersOnboarding = '/users/onboarding';
  static const String usersLocation = '/users/me/location';
  static const String usersPushSettings = '/users/me/push-settings';
  static const String usersPushToken = '/users/me/push-token';
  static const String usersSportProfiles = '/users/me/sport-profiles';
  static const String usersAvailability = '/users/me/availability';
  static const String usersAvatar = '/users/me/avatar';

  // Matchmaking
  static const String matchmakingFeed = '/matchmaking/feed';
  static const String matchmakingSwipe = '/matchmaking/swipe';
  static const String matchmakingResetDislikes = '/matchmaking/reset-dislikes';

  // Arena
  static const String arenaLeaderboard = '/arena/leaderboard';
  static const String arenaChallenge = '/arena/challenge';

  // Chat
  static const String chatsThreads = '/chats/threads';
  static const String chatsCreateThread = '/chats/threads';
  static String chatsMessages(String threadId) =>
      '/chats/threads/$threadId/messages';
  static String chatsDelete(String threadId) => '/chats/threads/$threadId';
  static String chatsBlock(String threadId) => '/chats/threads/$threadId/block';
  static String chatsReport(String threadId) =>
      '/chats/threads/$threadId/report';

  // Games
  static const String gamesMy = '/games/my';
  static String gamesResult(String gameId) => '/games/$gameId/result';
  static String gamesById(String gameId) => '/games/$gameId';

  // Wallet
  static const String walletBalance = '/wallet/balance';
  static const String walletDailyReward = '/wallet/daily-reward';
  static const String walletTransfer = '/wallet/transfer';
  static const String walletStore = '/wallet/store';
  static const String walletStoreBuy = '/wallet/store/buy';
  static const String walletHistory = '/wallet/history';

  // Disputes
  static const String disputesCreate = '/disputes';
  static const String disputesJuryDuty = '/disputes/jury-duty';
  static const String disputesMy = '/disputes/my';
  static String disputesById(String id) => '/disputes/$id';
  static String disputesVote(String id) => '/disputes/$id/vote';
}
