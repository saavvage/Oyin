import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'locale_keys.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('kk'),
    Locale('kk', 'KZ'),
  ];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  String _string(String key) =>
      _localizedValues[locale.languageCode]?[key] ??
      _localizedValues['en']?[key] ??
      key;

  String get discovery => _string(LocaleKeys.discovery);
  String get findPartners => _string(LocaleKeys.findPartners);
  String get nearby => _string(LocaleKeys.nearby);
  String get timeMatch => _string(LocaleKeys.timeMatch);
  String get skills => _string(LocaleKeys.skills);
  String get info => _string(LocaleKeys.info);
  String get actionPass => _string(LocaleKeys.actionPass);
  String get actionBoost => _string(LocaleKeys.actionBoost);
  String get actionLike => _string(LocaleKeys.actionLike);
  String get actionInfo => _string(LocaleKeys.actionInfo);
  String get navMatch => _string(LocaleKeys.navMatch);
  String get navSearch => _string(LocaleKeys.navSearch);
  String get navChats => _string(LocaleKeys.navChats);
  String get navProfile => _string(LocaleKeys.navProfile);
  String get profile => _string(LocaleKeys.profile);
  String get settings => _string(LocaleKeys.settings);
  String get leagueGold => _string(LocaleKeys.leagueGold);
  String get performanceStats => _string(LocaleKeys.performanceStats);
  String get reputation => _string(LocaleKeys.reputation);
  String get record => _string(LocaleKeys.record);
  String get matches => _string(LocaleKeys.matches);
  String get reliability => _string(LocaleKeys.reliability);
  String get nextMatch => _string(LocaleKeys.nextMatch);
  String get viewCalendar => _string(LocaleKeys.viewCalendar);
  String get opponent => _string(LocaleKeys.opponent);
  String get statusConfirmed => _string(LocaleKeys.statusConfirmed);
  String get details => _string(LocaleKeys.details);
  String get settingsHistory => _string(LocaleKeys.settingsHistory);
  String get availability => _string(LocaleKeys.availability);
  String get availabilityDesc => _string(LocaleKeys.availabilityDesc);
  String get sportPreferences => _string(LocaleKeys.sportPreferences);
  String get sportPreferencesDesc => _string(LocaleKeys.sportPreferencesDesc);
  String get matchHistory => _string(LocaleKeys.matchHistory);
  String get matchHistoryDesc => _string(LocaleKeys.matchHistoryDesc);
  String get searchSettingsPlaceholder =>
      _string(LocaleKeys.searchSettingsPlaceholder);
  String get account => _string(LocaleKeys.account);
  String get personalInfo => _string(LocaleKeys.personalInfo);
  String get passwordSecurity => _string(LocaleKeys.passwordSecurity);
  String get linkedAccounts => _string(LocaleKeys.linkedAccounts);
  String get sparringPrivacy => _string(LocaleKeys.sparringPrivacy);
  String get publicVisibility => _string(LocaleKeys.publicVisibility);
  String get publicVisibilityDesc => _string(LocaleKeys.publicVisibilityDesc);
  String get sparringPreferences => _string(LocaleKeys.sparringPreferences);
  String get blockedUsers => _string(LocaleKeys.blockedUsers);
  String get notifications => _string(LocaleKeys.notifications);
  String get matchRequests => _string(LocaleKeys.matchRequests);
  String get disputeUpdates => _string(LocaleKeys.disputeUpdates);
  String get support => _string(LocaleKeys.support);
  String get helpCenter => _string(LocaleKeys.helpCenter);
  String get fairPlayRules => _string(LocaleKeys.fairPlayRules);
  String get logout => _string(LocaleKeys.logout);
  String get matchResult => _string(LocaleKeys.matchResult);
  String get sparringSession => _string(LocaleKeys.sparringSession);
  String get pending => _string(LocaleKeys.pending);
  String get enterFinalScore => _string(LocaleKeys.enterFinalScore);
  String get submitResult => _string(LocaleKeys.submitResult);
  String get dispute => _string(LocaleKeys.dispute);
  String get toCourt => _string(LocaleKeys.toCourt);
  String get disputeNote => _string(LocaleKeys.disputeNote);
  String get scoreConfirmNote => _string(LocaleKeys.scoreConfirmNote);
  String get you => _string(LocaleKeys.you);
  String get chats => _string(LocaleKeys.chats);
  String get myGames => _string(LocaleKeys.myGames);
  String get searchMatches => _string(LocaleKeys.searchMatches);
  String get tabActiveMatches => _string(LocaleKeys.tabActiveMatches);
  String get tabArchived => _string(LocaleKeys.tabArchived);
  String get actionRequired => _string(LocaleKeys.actionRequired);
  String get upcoming => _string(LocaleKeys.upcoming);
  String get resolveDispute => _string(LocaleKeys.resolveDispute);
  String get viewProposal => _string(LocaleKeys.viewProposal);
  String get contractSigned => _string(LocaleKeys.contractSigned);
  String get draftingContract => _string(LocaleKeys.draftingContract);
  String get matched => _string(LocaleKeys.matched);
  String get aiAssistant => _string(LocaleKeys.aiAssistant);
  String get aiComingSoon => _string(LocaleKeys.aiComingSoon);
  String get aiAssistantSubtitle => _string(LocaleKeys.aiAssistantSubtitle);
  String get madeWithCare => _string(LocaleKeys.madeWithCare);
  String get language => _string(LocaleKeys.language);
  String get reputationExcellent => _string(LocaleKeys.reputationExcellent);
  String matchesDeltaThisMonth(String value) =>
      _string(LocaleKeys.matchesDeltaThisMonth).replaceFirst('{value}', value);
  String get statusDisputeOpen => _string(LocaleKeys.statusDisputeOpen);
  String get statusContractSigned => _string(LocaleKeys.statusContractSigned);
  String get statusDraftingContract =>
      _string(LocaleKeys.statusDraftingContract);
  String get statusMatched => _string(LocaleKeys.statusMatched);
  String get arenaTitle => _string(LocaleKeys.arenaTitle);
  String get arenaStanding => _string(LocaleKeys.arenaStanding);
  String get arenaRank => _string(LocaleKeys.arenaRank);
  String arenaRating(String value) =>
      _string(LocaleKeys.arenaRating).replaceFirst('{value}', value);
  String get arenaAllPlayers => _string(LocaleKeys.arenaAllPlayers);
  String get arenaFairFight => _string(LocaleKeys.arenaFairFight);
  String get arenaInRange => _string(LocaleKeys.arenaInRange);
  String get arenaChallenge => _string(LocaleKeys.arenaChallenge);
  String get arenaPending => _string(LocaleKeys.arenaPending);
  String walletBalance(String value) =>
      _string(LocaleKeys.walletBalance).replaceFirst('{value}', value);
  String get walletTransfer => _string(LocaleKeys.walletTransfer);
  String get walletStore => _string(LocaleKeys.walletStore);
  String get walletHistory => _string(LocaleKeys.walletHistory);
  String get walletDailyReward => _string(LocaleKeys.walletDailyReward);
  String get walletClaimBonus => _string(LocaleKeys.walletClaimBonus);
  String get walletClaim => _string(LocaleKeys.walletClaim);
  String get walletDailyStreak => _string(LocaleKeys.walletDailyStreak);
  String walletDay(String value) =>
      _string(LocaleKeys.walletDay).replaceFirst('{value}', value);
  String get walletGetReward => _string(LocaleKeys.walletGetReward);
  String walletCoins(String value) =>
      _string(LocaleKeys.walletCoins).replaceFirst('{value}', value);
  String get walletPhoneNumber => _string(LocaleKeys.walletPhoneNumber);
  String get walletCoinsAmount => _string(LocaleKeys.walletCoinsAmount);
  String get walletBuy => _string(LocaleKeys.walletBuy);
  String get walletSend => _string(LocaleKeys.walletSend);
  String get storeItemGym => _string(LocaleKeys.storeItemGym);
  String get storeItemEquipment => _string(LocaleKeys.storeItemEquipment);
  String get storeItemCoach => _string(LocaleKeys.storeItemCoach);
  String get storeItemEnergy => _string(LocaleKeys.storeItemEnergy);
  String get onboardingTitle => _string(LocaleKeys.onboardingTitle);
  String get onboardingSubtitle => _string(LocaleKeys.onboardingSubtitle);
  String get getStarted => _string(LocaleKeys.getStarted);
  String get logIn => _string(LocaleKeys.logIn);
  String get phoneNumberLabel => _string(LocaleKeys.phoneNumber);
  String get sendCode => _string(LocaleKeys.sendCode);
  String get phoneEntryTitle => _string(LocaleKeys.phoneEntryTitle);
  String get phoneEntrySubtitle => _string(LocaleKeys.phoneEntrySubtitle);
  String get termsAgree => _string(LocaleKeys.termsAgree);
  String get verificationTitle => _string(LocaleKeys.verificationTitle);
  String verificationSubtitle(String phone) =>
      _string(LocaleKeys.verificationSubtitle).replaceFirst('{phone}', phone);
  String get resendCode => _string(LocaleKeys.resendCode);
  String get verifyIdentity => _string(LocaleKeys.verifyIdentity);
  String get profileInfoTitle => _string(LocaleKeys.profileInfoTitle);
  String get profileInfoSubtitle => _string(LocaleKeys.profileInfoSubtitle);
  String get firstName => _string(LocaleKeys.firstName);
  String get lastName => _string(LocaleKeys.lastName);
  String get email => _string(LocaleKeys.email);
  String get birthDate => _string(LocaleKeys.birthDate);
  String get city => _string(LocaleKeys.city);
  String get continueLabel => _string(LocaleKeys.continueLabel);

  String get notifTitleSuccess => _string(LocaleKeys.notifTitleSuccess);
  String get notifTitleWarning => _string(LocaleKeys.notifTitleWarning);
  String get notifTitleInfo => _string(LocaleKeys.notifTitleInfo);
  String get notifTitleError => _string(LocaleKeys.notifTitleError);

  String get errorNoConnectionTitle =>
      _string(LocaleKeys.errorNoConnectionTitle);
  String get errorNoConnectionMessage =>
      _string(LocaleKeys.errorNoConnectionMessage);
  String get errorTimeoutTitle => _string(LocaleKeys.errorTimeoutTitle);
  String get errorTimeoutMessage => _string(LocaleKeys.errorTimeoutMessage);
  String get errorUnauthorizedTitle =>
      _string(LocaleKeys.errorUnauthorizedTitle);
  String get errorUnauthorizedMessage =>
      _string(LocaleKeys.errorUnauthorizedMessage);
  String get errorForbiddenTitle => _string(LocaleKeys.errorForbiddenTitle);
  String get errorForbiddenMessage => _string(LocaleKeys.errorForbiddenMessage);
  String get errorNotFoundTitle => _string(LocaleKeys.errorNotFoundTitle);
  String get errorNotFoundMessage => _string(LocaleKeys.errorNotFoundMessage);
  String get errorServerTitle => _string(LocaleKeys.errorServerTitle);
  String get errorServerMessage => _string(LocaleKeys.errorServerMessage);
  String get errorUnknownTitle => _string(LocaleKeys.errorUnknownTitle);
  String get errorUnknownMessage => _string(LocaleKeys.errorUnknownMessage);

  String get phoneNumberIncompleteTitle =>
      _string(LocaleKeys.phoneNumberIncompleteTitle);
  String get phoneNumberIncompleteMessage =>
      _string(LocaleKeys.phoneNumberIncompleteMessage);
  String get verifyCodeIncompleteTitle =>
      _string(LocaleKeys.verifyCodeIncompleteTitle);
  String get verifyCodeIncompleteMessage =>
      _string(LocaleKeys.verifyCodeIncompleteMessage);
  String get profileSavedMessage => _string(LocaleKeys.profileSavedMessage);

  String get messengerStartConversation =>
      _string(LocaleKeys.messengerStartConversation);
  String get messengerOnline => _string(LocaleKeys.messengerOnline);
  String get messengerMessageHint => _string(LocaleKeys.messengerMessageHint);
  String get messengerBlockedHint => _string(LocaleKeys.messengerBlockedHint);
  String get messengerActionDeleteChat =>
      _string(LocaleKeys.messengerActionDeleteChat);
  String get messengerActionBlockUser =>
      _string(LocaleKeys.messengerActionBlockUser);
  String get messengerActionReport => _string(LocaleKeys.messengerActionReport);
  String get messengerDialogDeleteTitle =>
      _string(LocaleKeys.messengerDialogDeleteTitle);
  String get messengerDialogDeleteDesc =>
      _string(LocaleKeys.messengerDialogDeleteDesc);
  String get messengerDialogDeleteConfirm =>
      _string(LocaleKeys.messengerDialogDeleteConfirm);
  String get messengerDialogBlockTitle =>
      _string(LocaleKeys.messengerDialogBlockTitle);
  String get messengerDialogBlockDesc =>
      _string(LocaleKeys.messengerDialogBlockDesc);
  String get messengerDialogBlockConfirm =>
      _string(LocaleKeys.messengerDialogBlockConfirm);
  String get messengerDialogReportTitle =>
      _string(LocaleKeys.messengerDialogReportTitle);
  String get messengerDialogReportDesc =>
      _string(LocaleKeys.messengerDialogReportDesc);
  String get messengerDialogReportConfirm =>
      _string(LocaleKeys.messengerDialogReportConfirm);
  String get messengerDialogCancel => _string(LocaleKeys.messengerDialogCancel);
  String get messengerChatDeleted => _string(LocaleKeys.messengerChatDeleted);
  String get messengerUserBlocked => _string(LocaleKeys.messengerUserBlocked);
  String get messengerReportSent => _string(LocaleKeys.messengerReportSent);
  String get messengerSomethingWrong =>
      _string(LocaleKeys.messengerSomethingWrong);
  String get messengerAttachmentCamera =>
      _string(LocaleKeys.messengerAttachmentCamera);
  String get messengerAttachmentLibrary =>
      _string(LocaleKeys.messengerAttachmentLibrary);
  String get messengerAttachmentFile =>
      _string(LocaleKeys.messengerAttachmentFile);
  String get messengerAttachmentPhoto =>
      _string(LocaleKeys.messengerAttachmentPhoto);
  String get messengerAttachmentVideo =>
      _string(LocaleKeys.messengerAttachmentVideo);
  String get matchFiltersTitle => _string(LocaleKeys.matchFiltersTitle);
  String get matchFiltersDistance => _string(LocaleKeys.matchFiltersDistance);
  String matchFiltersDistanceValue(int min, int max) => _string(
    LocaleKeys.matchFiltersDistanceValue,
  ).replaceFirst('{min}', min.toString()).replaceFirst('{max}', max.toString());
  String get matchFiltersAge => _string(LocaleKeys.matchFiltersAge);
  String matchFiltersAgeValue(int min, int max) => _string(
    LocaleKeys.matchFiltersAgeValue,
  ).replaceFirst('{min}', min.toString()).replaceFirst('{max}', max.toString());
  String get matchFiltersApply => _string(LocaleKeys.matchFiltersApply);
  String get matchFinishTitle => _string(LocaleKeys.matchFinishTitle);
  String get matchFinishSubtitle => _string(LocaleKeys.matchFinishSubtitle);
  String get matchResetDislikes => _string(LocaleKeys.matchResetDislikes);
  String get matchTryChangeFilters => _string(LocaleKeys.matchTryChangeFilters);
  String get matchProfileDetailsTitle =>
      _string(LocaleKeys.matchProfileDetailsTitle);
  String get matchProfileCityLabel => _string(LocaleKeys.matchProfileCityLabel);
  String get matchProfileDistanceLabel =>
      _string(LocaleKeys.matchProfileDistanceLabel);
  String get matchProfileRatingLabel =>
      _string(LocaleKeys.matchProfileRatingLabel);
  String get matchProfileSportsLabel =>
      _string(LocaleKeys.matchProfileSportsLabel);
  String get matchProfileLevelLabel =>
      _string(LocaleKeys.matchProfileLevelLabel);
  String get levelAmateur => _string(LocaleKeys.levelAmateur);
  String get levelSemiPro => _string(LocaleKeys.levelSemiPro);
  String get levelProfessional => _string(LocaleKeys.levelProfessional);
  String get onboardingSportSelectionTitle =>
      _string(LocaleKeys.onboardingSportSelectionTitle);
  String get onboardingSportSelectionSubtitle =>
      _string(LocaleKeys.onboardingSportSelectionSubtitle);
  String get onboardingSportSelectionSearchHint =>
      _string(LocaleKeys.onboardingSportSelectionSearchHint);
  String get onboardingSportSelectionInfo =>
      _string(LocaleKeys.onboardingSportSelectionInfo);
  String onboardingSportSelectionCreateProfiles(int count) => _string(
    LocaleKeys.onboardingSportSelectionCreateProfiles,
  ).replaceFirst('{count}', count.toString());
  String get onboardingLevelChoosePathTitle =>
      _string(LocaleKeys.onboardingLevelChoosePathTitle);
  String get onboardingLevelChoosePathSubtitle =>
      _string(LocaleKeys.onboardingLevelChoosePathSubtitle);
  String get onboardingLevelAmateurSubtitle =>
      _string(LocaleKeys.onboardingLevelAmateurSubtitle);
  String get onboardingLevelAmateurDetail1 =>
      _string(LocaleKeys.onboardingLevelAmateurDetail1);
  String get onboardingLevelAmateurDetail2 =>
      _string(LocaleKeys.onboardingLevelAmateurDetail2);
  String get onboardingLevelSemiProSubtitle =>
      _string(LocaleKeys.onboardingLevelSemiProSubtitle);
  String get onboardingLevelSemiProDetail1 =>
      _string(LocaleKeys.onboardingLevelSemiProDetail1);
  String get onboardingLevelSemiProDetail2 =>
      _string(LocaleKeys.onboardingLevelSemiProDetail2);
  String get onboardingLevelProfessionalSubtitle =>
      _string(LocaleKeys.onboardingLevelProfessionalSubtitle);
  String get onboardingLevelProfessionalDetail1 =>
      _string(LocaleKeys.onboardingLevelProfessionalDetail1);
  String get onboardingLevelProfessionalDetail2 =>
      _string(LocaleKeys.onboardingLevelProfessionalDetail2);
  String get onboardingLevelWhyItMatters =>
      _string(LocaleKeys.onboardingLevelWhyItMatters);
  String onboardingDetailsProfileTitle(String level) => _string(
    LocaleKeys.onboardingDetailsProfileTitle,
  ).replaceFirst('{level}', level);
  String get onboardingDetailsFillSubtitle =>
      _string(LocaleKeys.onboardingDetailsFillSubtitle);
  String get onboardingDetailsExperienceLabel =>
      _string(LocaleKeys.onboardingDetailsExperienceLabel);
  String get onboardingDetailsExperienceHint =>
      _string(LocaleKeys.onboardingDetailsExperienceHint);
  String get onboardingDetailsYearsSuffix =>
      _string(LocaleKeys.onboardingDetailsYearsSuffix);
  String get onboardingDetailsExperienceDesc =>
      _string(LocaleKeys.onboardingDetailsExperienceDesc);
  String get onboardingDetailsSkillsLabel =>
      _string(LocaleKeys.onboardingDetailsSkillsLabel);
  String get onboardingDetailsAddSkillHint =>
      _string(LocaleKeys.onboardingDetailsAddSkillHint);
  String get onboardingDetailsSuggestionsLabel =>
      _string(LocaleKeys.onboardingDetailsSuggestionsLabel);
  String get onboardingDetailsCompleteProfile =>
      _string(LocaleKeys.onboardingDetailsCompleteProfile);
  String get onboardingDetailsSelectSportLevelWarning =>
      _string(LocaleKeys.onboardingDetailsSelectSportLevelWarning);
  String get onboardingDetailsProfileCreatedSuccess =>
      _string(LocaleKeys.onboardingDetailsProfileCreatedSuccess);
  String get onboardingDetailsLevelFallback =>
      _string(LocaleKeys.onboardingDetailsLevelFallback);
  String get profileAvatarChooseGallery =>
      _string(LocaleKeys.profileAvatarChooseGallery);
  String get profileAvatarTakePhoto =>
      _string(LocaleKeys.profileAvatarTakePhoto);
  String get sportPreferencesSearchHint =>
      _string(LocaleKeys.sportPreferencesSearchHint);
  String get sportPreferencesLevelLabel =>
      _string(LocaleKeys.sportPreferencesLevelLabel);
  String get sportPreferencesExperienceHint =>
      _string(LocaleKeys.sportPreferencesExperienceHint);
  String get sportPreferencesAddSkillHint =>
      _string(LocaleKeys.sportPreferencesAddSkillHint);
  String get sportPreferencesSave => _string(LocaleKeys.sportPreferencesSave);
  String get sportPreferencesSaving =>
      _string(LocaleKeys.sportPreferencesSaving);
  String get sportPreferencesSelectAtLeastOne =>
      _string(LocaleKeys.sportPreferencesSelectAtLeastOne);
  String get sportPreferencesUpdatedSuccess =>
      _string(LocaleKeys.sportPreferencesUpdatedSuccess);

  String nameAndAge(String name, int age) => _string(
    LocaleKeys.nameAge,
  ).replaceFirst('{name}', name).replaceFirst('{age}', age.toString());

  String sportAndLevel(String sport, String level) => _string(
    LocaleKeys.sportLevel,
  ).replaceFirst('{sport}', sport).replaceFirst('{level}', level);

  String formatDistanceKm(double value) => _string(
    LocaleKeys.distanceKm,
  ).replaceFirst('{value}', value.toStringAsFixed(1));

  String formatRating(double value) => _string(
    LocaleKeys.rating,
  ).replaceFirst('{value}', value.toStringAsFixed(1));

  String formatTodayAt(String time) =>
      _string(LocaleKeys.todayAt).replaceFirst('{time}', time);

  String versionLabel(String version) =>
      _string(LocaleKeys.version).replaceFirst('{version}', version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    LocaleKeys.discovery: 'Discovery',
    LocaleKeys.findPartners: 'Find Partners',
    LocaleKeys.nearby: 'Nearby',
    LocaleKeys.timeMatch: 'Time Match',
    LocaleKeys.skills: 'Skills',
    LocaleKeys.info: 'Info',
    LocaleKeys.actionPass: 'Pass',
    LocaleKeys.actionBoost: 'Boost',
    LocaleKeys.actionLike: 'Match',
    LocaleKeys.actionInfo: 'Info',
    LocaleKeys.navMatch: 'Match',
    LocaleKeys.navSearch: 'Search',
    LocaleKeys.navChats: 'Chats',
    LocaleKeys.navProfile: 'Profile',
    LocaleKeys.nameAge: '{name}, {age}',
    LocaleKeys.sportLevel: '{sport} • {level}',
    LocaleKeys.distanceKm: '{value} km away',
    LocaleKeys.rating: '{value}',
    LocaleKeys.profile: 'Profile',
    LocaleKeys.settings: 'Settings',
    LocaleKeys.leagueGold: 'Gold League',
    LocaleKeys.location: '{city}, {country}',
    LocaleKeys.performanceStats: 'Performance Stats',
    LocaleKeys.reputation: 'Reputation',
    LocaleKeys.record: 'Record',
    LocaleKeys.matches: 'Matches',
    LocaleKeys.reliability: 'Reliability',
    LocaleKeys.nextMatch: 'Next Match',
    LocaleKeys.viewCalendar: 'View Calendar',
    LocaleKeys.opponent: 'Opponent',
    LocaleKeys.statusConfirmed: 'Confirmed',
    LocaleKeys.todayAt: 'Today, {time}',
    LocaleKeys.details: 'Details',
    LocaleKeys.settingsHistory: 'Settings & History',
    LocaleKeys.availability: 'My Availability',
    LocaleKeys.availabilityDesc: 'Manage your training slots',
    LocaleKeys.sportPreferences: 'Sport Preferences',
    LocaleKeys.sportPreferencesDesc: 'Pick boxing, muay thai, BJJ',
    LocaleKeys.matchHistory: 'Match History',
    LocaleKeys.matchHistoryDesc: 'View past spars and disputes',
    LocaleKeys.searchSettingsPlaceholder: 'Search settings, disputes, privacy…',
    LocaleKeys.account: 'Account',
    LocaleKeys.personalInfo: 'Personal Information',
    LocaleKeys.passwordSecurity: 'Password & Security',
    LocaleKeys.linkedAccounts: 'Linked Accounts',
    LocaleKeys.sparringPrivacy: 'Sparring & Privacy',
    LocaleKeys.publicVisibility: 'Public Visibility',
    LocaleKeys.publicVisibilityDesc: 'Allow others to find you for matches',
    LocaleKeys.sparringPreferences: 'Sparring Preferences',
    LocaleKeys.blockedUsers: 'Blocked Users',
    LocaleKeys.notifications: 'Notifications',
    LocaleKeys.matchRequests: 'Match Requests',
    LocaleKeys.disputeUpdates: 'Dispute Updates',
    LocaleKeys.support: 'Support',
    LocaleKeys.helpCenter: 'Help Center & FAQ',
    LocaleKeys.fairPlayRules: 'Fair Play Rules',
    LocaleKeys.logout: 'Log Out',
    LocaleKeys.version: 'Version {version}',
    LocaleKeys.matchResult: 'Match Result',
    LocaleKeys.sparringSession: 'Sparring Session',
    LocaleKeys.pending: 'Pending',
    LocaleKeys.enterFinalScore: 'Enter Final Score',
    LocaleKeys.submitResult: 'Submit Result',
    LocaleKeys.dispute: 'Dispute?',
    LocaleKeys.toCourt: 'To Court',
    LocaleKeys.disputeNote:
        'Initiating a dispute will freeze the result and require evidence submission.',
    LocaleKeys.scoreConfirmNote: 'Score must be confirmed by opponent.',
    LocaleKeys.you: 'YOU',
    LocaleKeys.chats: 'Chats',
    LocaleKeys.myGames: 'My Games',
    LocaleKeys.searchMatches: 'Search matches...',
    LocaleKeys.tabActiveMatches: 'Active Matches',
    LocaleKeys.tabArchived: 'Archived',
    LocaleKeys.actionRequired: 'Action Required',
    LocaleKeys.upcoming: 'Upcoming',
    LocaleKeys.resolveDispute: 'Resolve Dispute',
    LocaleKeys.viewProposal: 'View Proposal',
    LocaleKeys.contractSigned: 'CONTRACT SIGNED',
    LocaleKeys.draftingContract: 'DRAFTING CONTRACT…',
    LocaleKeys.matched: 'Matched! Start chatting to set up.',
    LocaleKeys.aiAssistant: 'AI Assistant',
    LocaleKeys.aiComingSoon: 'Coming soon',
    LocaleKeys.aiAssistantSubtitle:
        'We will connect your personal fight-AI helper here.',
    LocaleKeys.madeWithCare: 'Made with care for you ❤️',
    LocaleKeys.language: 'Language',
    LocaleKeys.reputationExcellent: 'Excellent',
    LocaleKeys.matchesDeltaThisMonth: '+{value} this mo.',
    LocaleKeys.statusDisputeOpen: 'Dispute Open',
    LocaleKeys.statusContractSigned: 'CONTRACT SIGNED',
    LocaleKeys.statusDraftingContract: 'DRAFTING CONTRACT…',
    LocaleKeys.statusMatched: 'Matched',
    LocaleKeys.arenaTitle: 'Arena',
    LocaleKeys.arenaStanding: 'YOUR STANDING',
    LocaleKeys.arenaRank: 'Rank',
    LocaleKeys.arenaRating: 'Rating: {value}',
    LocaleKeys.arenaAllPlayers: 'All Players',
    LocaleKeys.arenaFairFight: 'Fair Fight (+/- 200)',
    LocaleKeys.arenaInRange: 'In your range',
    LocaleKeys.arenaChallenge: 'Challenge',
    LocaleKeys.arenaPending: 'Pending',
    LocaleKeys.walletBalance: 'Balance: {value}',
    LocaleKeys.walletTransfer: 'Transfer',
    LocaleKeys.walletStore: 'Store',
    LocaleKeys.walletHistory: 'History',
    LocaleKeys.walletDailyReward: 'Daily reward',
    LocaleKeys.walletClaimBonus: 'Claim your streak bonus',
    LocaleKeys.walletClaim: 'Claim',
    LocaleKeys.walletDailyStreak: 'Daily streak',
    LocaleKeys.walletDay: 'Day {value}',
    LocaleKeys.walletGetReward: 'Get reward',
    LocaleKeys.walletCoins: '{value} coins',
    LocaleKeys.walletPhoneNumber: 'Phone number',
    LocaleKeys.walletCoinsAmount: 'Coins amount',
    LocaleKeys.walletBuy: 'Buy',
    LocaleKeys.walletSend: 'Send',
    LocaleKeys.storeItemGym: 'Gym pass',
    LocaleKeys.storeItemEquipment: 'Equipment',
    LocaleKeys.storeItemCoach: 'Coach session',
    LocaleKeys.storeItemEnergy: 'Energy drink',
    LocaleKeys.onboardingTitle: 'Train Harder,\nTogether.',
    LocaleKeys.onboardingSubtitle:
        'The hybrid matching system for fighters. Find partners, track stats, and grow safely.',
    LocaleKeys.getStarted: 'Get Started',
    LocaleKeys.logIn: 'Log In',
    LocaleKeys.phoneNumber: 'Phone Number',
    LocaleKeys.sendCode: 'Send Code',
    LocaleKeys.phoneEntryTitle: 'Let’s get you in the ring.',
    LocaleKeys.phoneEntrySubtitle:
        'Enter your phone number to verify your account and find sparring partners.',
    LocaleKeys.termsAgree:
        'By continuing, you agree to our Terms & Privacy Policy.',
    LocaleKeys.verificationTitle: 'Enter Verification Code',
    LocaleKeys.verificationSubtitle:
        'We sent a code to {phone}. Enter it below to continue.',
    LocaleKeys.resendCode: 'Resend',
    LocaleKeys.verifyIdentity: 'Verify Identity',
    LocaleKeys.profileInfoTitle: 'Tell us about you',
    LocaleKeys.profileInfoSubtitle: 'We’ll use this to personalise matches.',
    LocaleKeys.firstName: 'First Name',
    LocaleKeys.lastName: 'Last Name',
    LocaleKeys.email: 'Email',
    LocaleKeys.birthDate: 'Date of Birth',
    LocaleKeys.city: 'City',
    LocaleKeys.continueLabel: 'Continue',

    LocaleKeys.notifTitleSuccess: 'Success',
    LocaleKeys.notifTitleWarning: 'Warning',
    LocaleKeys.notifTitleInfo: 'Notification',
    LocaleKeys.notifTitleError: 'Error',
    LocaleKeys.errorNoConnectionTitle: 'No connection',
    LocaleKeys.errorNoConnectionMessage:
        'Check your internet connection and try again.',
    LocaleKeys.errorTimeoutTitle: 'Server timeout',
    LocaleKeys.errorTimeoutMessage: 'Please try again later.',
    LocaleKeys.errorUnauthorizedTitle: 'Session expired',
    LocaleKeys.errorUnauthorizedMessage: 'Please sign in again.',
    LocaleKeys.errorForbiddenTitle: 'Access denied',
    LocaleKeys.errorForbiddenMessage:
        'You do not have permission to perform this action.',
    LocaleKeys.errorNotFoundTitle: 'Not found',
    LocaleKeys.errorNotFoundMessage: 'Requested data was not found.',
    LocaleKeys.errorServerTitle: 'Server error',
    LocaleKeys.errorServerMessage: 'Please try again later or contact support.',
    LocaleKeys.errorUnknownTitle: 'Error',
    LocaleKeys.errorUnknownMessage: 'Something went wrong. Please try again.',
    LocaleKeys.phoneNumberIncompleteTitle: 'Invalid phone',
    LocaleKeys.phoneNumberIncompleteMessage: 'Enter the full phone number.',
    LocaleKeys.verifyCodeIncompleteTitle: 'Verification code',
    LocaleKeys.verifyCodeIncompleteMessage: 'Enter the full code.',
    LocaleKeys.profileSavedMessage: 'Profile saved',
    LocaleKeys.messengerStartConversation: 'Start chatting',
    LocaleKeys.messengerOnline: 'Online',
    LocaleKeys.messengerMessageHint: 'Message...',
    LocaleKeys.messengerBlockedHint: 'You blocked this user',
    LocaleKeys.messengerActionDeleteChat: 'Delete chat',
    LocaleKeys.messengerActionBlockUser: 'Block user',
    LocaleKeys.messengerActionReport: 'Report',
    LocaleKeys.messengerDialogDeleteTitle: 'Delete chat?',
    LocaleKeys.messengerDialogDeleteDesc:
        'The dialog will be removed only for you.',
    LocaleKeys.messengerDialogDeleteConfirm: 'Delete',
    LocaleKeys.messengerDialogBlockTitle: 'Block user?',
    LocaleKeys.messengerDialogBlockDesc: 'You will stop receiving messages.',
    LocaleKeys.messengerDialogBlockConfirm: 'Block',
    LocaleKeys.messengerDialogReportTitle: 'Send report?',
    LocaleKeys.messengerDialogReportDesc: 'We will review your report.',
    LocaleKeys.messengerDialogReportConfirm: 'Send',
    LocaleKeys.messengerDialogCancel: 'Cancel',
    LocaleKeys.messengerChatDeleted: 'Chat deleted',
    LocaleKeys.messengerUserBlocked: 'User blocked',
    LocaleKeys.messengerReportSent: 'Report sent',
    LocaleKeys.messengerSomethingWrong: 'Something went wrong',
    LocaleKeys.messengerAttachmentCamera: 'Take photo',
    LocaleKeys.messengerAttachmentLibrary: 'Add photo/video',
    LocaleKeys.messengerAttachmentFile: 'Attach file',
    LocaleKeys.messengerAttachmentPhoto: 'Photo',
    LocaleKeys.messengerAttachmentVideo: 'Video',
    LocaleKeys.matchFiltersTitle: 'Search filters',
    LocaleKeys.matchFiltersDistance: 'Distance',
    LocaleKeys.matchFiltersDistanceValue: '{min}–{max} km',
    LocaleKeys.matchFiltersAge: 'Age range',
    LocaleKeys.matchFiltersAgeValue: '{min}–{max} yrs',
    LocaleKeys.matchFiltersApply: 'Apply filters',
    LocaleKeys.matchFinishTitle: 'Swipes are over',
    LocaleKeys.matchFinishSubtitle:
        'Try changing filters or reset dislikes to see more.',
    LocaleKeys.matchResetDislikes: 'Reset dislikes',
    LocaleKeys.matchTryChangeFilters: 'Try changing filters',
    LocaleKeys.matchProfileDetailsTitle: 'Profile details',
    LocaleKeys.matchProfileCityLabel: 'City',
    LocaleKeys.matchProfileDistanceLabel: 'Distance',
    LocaleKeys.matchProfileRatingLabel: 'Rating',
    LocaleKeys.matchProfileSportsLabel: 'Sports',
    LocaleKeys.matchProfileLevelLabel: 'Level',
    LocaleKeys.levelAmateur: 'Amateur',
    LocaleKeys.levelSemiPro: 'Semi-Pro',
    LocaleKeys.levelProfessional: 'Professional',
    LocaleKeys.onboardingSportSelectionTitle: 'What do you play?',
    LocaleKeys.onboardingSportSelectionSubtitle:
        'Tap all that apply. You can add more later.',
    LocaleKeys.onboardingSportSelectionSearchHint:
        'Search disciplines (e.g. Boxing, Padel)',
    LocaleKeys.onboardingSportSelectionInfo:
        'Each selected sport creates a separate sparring profile.',
    LocaleKeys.onboardingSportSelectionCreateProfiles:
        'Create {count} profile(s)',
    LocaleKeys.onboardingLevelChoosePathTitle: 'Choose your path',
    LocaleKeys.onboardingLevelChoosePathSubtitle:
        'Select your level to get the right matchups.',
    LocaleKeys.onboardingLevelAmateurSubtitle: 'Start at ~800-1000 ELO',
    LocaleKeys.onboardingLevelAmateurDetail1:
        'Simple onboarding and instant access to matches.',
    LocaleKeys.onboardingLevelAmateurDetail2:
        'Best for casual players and newcomers.',
    LocaleKeys.onboardingLevelSemiProSubtitle: 'Start at ~1100-1400 ELO',
    LocaleKeys.onboardingLevelSemiProDetail1:
        'For consistent training and local tournament experience.',
    LocaleKeys.onboardingLevelSemiProDetail2:
        'Balanced matchmaking with stronger opponents.',
    LocaleKeys.onboardingLevelProfessionalSubtitle: 'Start at ~1500 ELO',
    LocaleKeys.onboardingLevelProfessionalDetail1:
        'Requires stronger competitive track record.',
    LocaleKeys.onboardingLevelProfessionalDetail2:
        'Manual moderation can be applied for access.',
    LocaleKeys.onboardingLevelWhyItMatters:
        'Accurate starting level improves fair matchmaking from day one.',
    LocaleKeys.onboardingDetailsProfileTitle: '{level} Profile',
    LocaleKeys.onboardingDetailsFillSubtitle:
        'Fill in details to improve your match quality.',
    LocaleKeys.onboardingDetailsExperienceLabel: 'Experience (Years)',
    LocaleKeys.onboardingDetailsExperienceHint: 'e.g. 2',
    LocaleKeys.onboardingDetailsYearsSuffix: 'Years',
    LocaleKeys.onboardingDetailsExperienceDesc:
        'Total time you have been practicing selected sports.',
    LocaleKeys.onboardingDetailsSkillsLabel: 'Skills & Tags',
    LocaleKeys.onboardingDetailsAddSkillHint: 'Add skill (e.g. Kickboxing)',
    LocaleKeys.onboardingDetailsSuggestionsLabel: 'Suggestions',
    LocaleKeys.onboardingDetailsCompleteProfile: 'Complete Profile',
    LocaleKeys.onboardingDetailsSelectSportLevelWarning:
        'Please select sports and level first.',
    LocaleKeys.onboardingDetailsProfileCreatedSuccess:
        'Profile created successfully',
    LocaleKeys.onboardingDetailsLevelFallback: 'Sports',
    LocaleKeys.profileAvatarChooseGallery: 'Choose from gallery',
    LocaleKeys.profileAvatarTakePhoto: 'Take a photo',
    LocaleKeys.sportPreferencesSearchHint: 'Search sports',
    LocaleKeys.sportPreferencesLevelLabel: 'Level',
    LocaleKeys.sportPreferencesExperienceHint: 'Experience years',
    LocaleKeys.sportPreferencesAddSkillHint: 'Add skill tag',
    LocaleKeys.sportPreferencesSave: 'Save',
    LocaleKeys.sportPreferencesSaving: 'Saving...',
    LocaleKeys.sportPreferencesSelectAtLeastOne: 'Select at least one sport.',
    LocaleKeys.sportPreferencesUpdatedSuccess: 'Sport preferences updated',
  },
  'ru': {
    LocaleKeys.discovery: 'Поиск',
    LocaleKeys.findPartners: 'Найди партнёров',
    LocaleKeys.nearby: 'Рядом',
    LocaleKeys.timeMatch: 'Подбор по времени',
    LocaleKeys.skills: 'Навыки',
    LocaleKeys.info: 'Инфо',
    LocaleKeys.actionPass: 'Пропустить',
    LocaleKeys.actionBoost: 'Буст',
    LocaleKeys.actionLike: 'Матч',
    LocaleKeys.actionInfo: 'Инфо',
    LocaleKeys.navMatch: 'Матч',
    LocaleKeys.navSearch: 'Поиск',
    LocaleKeys.navChats: 'Чаты',
    LocaleKeys.navProfile: 'Профиль',
    LocaleKeys.nameAge: '{name}, {age}',
    LocaleKeys.sportLevel: '{sport} • {level}',
    LocaleKeys.distanceKm: '{value} км от вас',
    LocaleKeys.rating: '{value}',
    LocaleKeys.profile: 'Профиль',
    LocaleKeys.settings: 'Настройки',
    LocaleKeys.leagueGold: 'Золотая лига',
    LocaleKeys.location: '{city}, {country}',
    LocaleKeys.performanceStats: 'Статистика',
    LocaleKeys.reputation: 'Репутация',
    LocaleKeys.record: 'Рекорд',
    LocaleKeys.matches: 'Бои',
    LocaleKeys.reliability: 'Надёжность',
    LocaleKeys.nextMatch: 'Следующий матч',
    LocaleKeys.viewCalendar: 'Календарь',
    LocaleKeys.opponent: 'Оппонент',
    LocaleKeys.statusConfirmed: 'Подтверждено',
    LocaleKeys.todayAt: 'Сегодня, {time}',
    LocaleKeys.details: 'Подробнее',
    LocaleKeys.settingsHistory: 'Настройки и история',
    LocaleKeys.availability: 'Доступность',
    LocaleKeys.availabilityDesc: 'Управляй слотами тренировок',
    LocaleKeys.sportPreferences: 'Спортивные предпочтения',
    LocaleKeys.sportPreferencesDesc: 'Бокс, муай тай, BJJ',
    LocaleKeys.matchHistory: 'История боёв',
    LocaleKeys.matchHistoryDesc: 'Прошлые спарринги и споры',
    LocaleKeys.searchSettingsPlaceholder:
        'Искать по настройкам, спорам, приватности…',
    LocaleKeys.account: 'Аккаунт',
    LocaleKeys.personalInfo: 'Личные данные',
    LocaleKeys.passwordSecurity: 'Пароль и безопасность',
    LocaleKeys.linkedAccounts: 'Связанные аккаунты',
    LocaleKeys.sparringPrivacy: 'Спарринги и приватность',
    LocaleKeys.publicVisibility: 'Публичность',
    LocaleKeys.publicVisibilityDesc: 'Позволять находить меня для матчей',
    LocaleKeys.sparringPreferences: 'Предпочтения спаррингов',
    LocaleKeys.blockedUsers: 'Чёрный список',
    LocaleKeys.notifications: 'Уведомления',
    LocaleKeys.matchRequests: 'Запросы на матч',
    LocaleKeys.disputeUpdates: 'Обновления споров',
    LocaleKeys.support: 'Поддержка',
    LocaleKeys.helpCenter: 'Центр помощи и FAQ',
    LocaleKeys.fairPlayRules: 'Правила честной игры',
    LocaleKeys.logout: 'Выйти',
    LocaleKeys.version: 'Версия {version}',
    LocaleKeys.matchResult: 'Результат матча',
    LocaleKeys.sparringSession: 'Спарринг',
    LocaleKeys.pending: 'В ожидании',
    LocaleKeys.enterFinalScore: 'Введите финальный счёт',
    LocaleKeys.submitResult: 'Отправить результат',
    LocaleKeys.dispute: 'Спор?',
    LocaleKeys.toCourt: 'В суд',
    LocaleKeys.disputeNote:
        'Инициируя спор, вы замораживаете результат и обязаны предоставить доказательства.',
    LocaleKeys.scoreConfirmNote: 'Счёт должен быть подтверждён оппонентом.',
    LocaleKeys.you: 'ВЫ',
    LocaleKeys.chats: 'Чаты',
    LocaleKeys.myGames: 'Мои матчи',
    LocaleKeys.searchMatches: 'Поиск матчей...',
    LocaleKeys.tabActiveMatches: 'Активные',
    LocaleKeys.tabArchived: 'Архив',
    LocaleKeys.actionRequired: 'Требуют действий',
    LocaleKeys.upcoming: 'Скоро',
    LocaleKeys.resolveDispute: 'Решить спор',
    LocaleKeys.viewProposal: 'Смотреть предложение',
    LocaleKeys.contractSigned: 'КОНТРАКТ ПОДПИСАН',
    LocaleKeys.draftingContract: 'КОНТРАКТ ГОТОВИТСЯ',
    LocaleKeys.matched: 'Матч! Напиши, чтобы договориться.',
    LocaleKeys.aiAssistant: 'AI-ассистент',
    LocaleKeys.aiComingSoon: 'Скоро',
    LocaleKeys.aiAssistantSubtitle:
        'Здесь будет подключен ваш персональный AI-ассистент.',
    LocaleKeys.madeWithCare: 'Сделано с заботой для вас ❤️',
    LocaleKeys.language: 'Язык',
    LocaleKeys.reputationExcellent: 'Отлично',
    LocaleKeys.matchesDeltaThisMonth: '+{value} в этом мес.',
    LocaleKeys.statusDisputeOpen: 'Открыт спор',
    LocaleKeys.statusContractSigned: 'КОНТРАКТ ПОДПИСАН',
    LocaleKeys.statusDraftingContract: 'КОНТРАКТ ГОТОВИТСЯ',
    LocaleKeys.statusMatched: 'Матч!',
    LocaleKeys.arenaTitle: 'Арена',
    LocaleKeys.arenaStanding: 'ТВОЙ РЕЙТИНГ',
    LocaleKeys.arenaRank: 'Ранг',
    LocaleKeys.arenaRating: 'Рейтинг: {value}',
    LocaleKeys.arenaAllPlayers: 'Все игроки',
    LocaleKeys.arenaFairFight: 'Честный бой (+/- 200)',
    LocaleKeys.arenaInRange: 'В твоём диапазоне',
    LocaleKeys.arenaChallenge: 'Бросить вызов',
    LocaleKeys.arenaPending: 'Ожидание',
    LocaleKeys.walletBalance: 'Баланс: {value}',
    LocaleKeys.walletTransfer: 'Перевод',
    LocaleKeys.walletStore: 'Магазин',
    LocaleKeys.walletHistory: 'История',
    LocaleKeys.walletDailyReward: 'Ежедневная награда',
    LocaleKeys.walletClaimBonus: 'Забери бонус за серию',
    LocaleKeys.walletClaim: 'Получить',
    LocaleKeys.walletDailyStreak: 'Ежедневная серия',
    LocaleKeys.walletDay: '{value}-й день',
    LocaleKeys.walletGetReward: 'Забрать награду',
    LocaleKeys.walletCoins: '{value} монет',
    LocaleKeys.walletPhoneNumber: 'Номер телефона',
    LocaleKeys.walletCoinsAmount: 'Количество монет',
    LocaleKeys.walletBuy: 'Купить',
    LocaleKeys.walletSend: 'Отправить',
    LocaleKeys.storeItemGym: 'Абонемент в зал',
    LocaleKeys.storeItemEquipment: 'Экипировка',
    LocaleKeys.storeItemCoach: 'Тренировка с коучем',
    LocaleKeys.storeItemEnergy: 'Энергетик',
    LocaleKeys.onboardingTitle: 'Тренируйся сильнее,\nвместе.',
    LocaleKeys.onboardingSubtitle:
        'Гибридная система матчмейкинга для бойцов. Находи партнёров, веди статистику и прогрессируй безопасно.',
    LocaleKeys.getStarted: 'Начать',
    LocaleKeys.logIn: 'Войти',
    LocaleKeys.phoneNumber: 'Номер телефона',
    LocaleKeys.sendCode: 'Отправить код',
    LocaleKeys.phoneEntryTitle: 'Заходим на ринг.',
    LocaleKeys.phoneEntrySubtitle:
        'Укажи телефон, чтобы подтвердить аккаунт и найти спарринг-партнёров.',
    LocaleKeys.termsAgree:
        'Продолжая, вы соглашаетесь с Условиями и Политикой конфиденциальности.',
    LocaleKeys.verificationTitle: 'Введите код подтверждения',
    LocaleKeys.verificationSubtitle:
        'Мы отправили код на {phone}. Введите его ниже, чтобы продолжить.',
    LocaleKeys.resendCode: 'Отправить ещё раз',
    LocaleKeys.verifyIdentity: 'Подтвердить личность',
    LocaleKeys.profileInfoTitle: 'Расскажи о себе',
    LocaleKeys.profileInfoSubtitle: 'Это поможет нам персонализировать подбор.',
    LocaleKeys.firstName: 'Имя',
    LocaleKeys.lastName: 'Фамилия',
    LocaleKeys.email: 'Почта',
    LocaleKeys.birthDate: 'Дата рождения',
    LocaleKeys.city: 'Город',
    LocaleKeys.continueLabel: 'Далее',

    LocaleKeys.notifTitleSuccess: 'Успешно',
    LocaleKeys.notifTitleWarning: 'Предупреждение',
    LocaleKeys.notifTitleInfo: 'Уведомление',
    LocaleKeys.notifTitleError: 'Ошибка',
    LocaleKeys.errorNoConnectionTitle: 'Нет соединения',
    LocaleKeys.errorNoConnectionMessage:
        'Проверьте подключение к интернету и попробуйте снова.',
    LocaleKeys.errorTimeoutTitle: 'Сервер не отвечает',
    LocaleKeys.errorTimeoutMessage: 'Попробуйте повторить позже.',
    LocaleKeys.errorUnauthorizedTitle: 'Сессия истекла',
    LocaleKeys.errorUnauthorizedMessage: 'Пожалуйста, войдите снова.',
    LocaleKeys.errorForbiddenTitle: 'Нет доступа',
    LocaleKeys.errorForbiddenMessage:
        'Недостаточно прав для выполнения действия.',
    LocaleKeys.errorNotFoundTitle: 'Не найдено',
    LocaleKeys.errorNotFoundMessage: 'Запрошенные данные не найдены.',
    LocaleKeys.errorServerTitle: 'Ошибка сервера',
    LocaleKeys.errorServerMessage:
        'Попробуйте позже или свяжитесь с поддержкой.',
    LocaleKeys.errorUnknownTitle: 'Ошибка',
    LocaleKeys.errorUnknownMessage: 'Что-то пошло не так. Попробуйте снова.',
    LocaleKeys.phoneNumberIncompleteTitle: 'Некорректный номер',
    LocaleKeys.phoneNumberIncompleteMessage:
        'Введите номер телефона полностью.',
    LocaleKeys.verifyCodeIncompleteTitle: 'Код подтверждения',
    LocaleKeys.verifyCodeIncompleteMessage: 'Введите код полностью.',
    LocaleKeys.profileSavedMessage: 'Профиль сохранён',
    LocaleKeys.messengerStartConversation: 'Начните общение',
    LocaleKeys.messengerOnline: 'Онлайн',
    LocaleKeys.messengerMessageHint: 'Сообщение...',
    LocaleKeys.messengerBlockedHint: 'Вы заблокировали пользователя',
    LocaleKeys.messengerActionDeleteChat: 'Удалить чат',
    LocaleKeys.messengerActionBlockUser: 'Заблокировать',
    LocaleKeys.messengerActionReport: 'Пожаловаться',
    LocaleKeys.messengerDialogDeleteTitle: 'Удалить чат?',
    LocaleKeys.messengerDialogDeleteDesc: 'Диалог будет удален только у вас.',
    LocaleKeys.messengerDialogDeleteConfirm: 'Удалить',
    LocaleKeys.messengerDialogBlockTitle: 'Заблокировать пользователя?',
    LocaleKeys.messengerDialogBlockDesc: 'Вы перестанете получать сообщения.',
    LocaleKeys.messengerDialogBlockConfirm: 'Заблокировать',
    LocaleKeys.messengerDialogReportTitle: 'Отправить жалобу?',
    LocaleKeys.messengerDialogReportDesc: 'Мы рассмотрим вашу жалобу.',
    LocaleKeys.messengerDialogReportConfirm: 'Отправить',
    LocaleKeys.messengerDialogCancel: 'Отмена',
    LocaleKeys.messengerChatDeleted: 'Чат удален',
    LocaleKeys.messengerUserBlocked: 'Пользователь заблокирован',
    LocaleKeys.messengerReportSent: 'Жалоба отправлена',
    LocaleKeys.messengerSomethingWrong: 'Что-то пошло не так',
    LocaleKeys.messengerAttachmentCamera: 'Сделать фото',
    LocaleKeys.messengerAttachmentLibrary: 'Добавить фото/видео',
    LocaleKeys.messengerAttachmentFile: 'Прикрепить файл',
    LocaleKeys.messengerAttachmentPhoto: 'Фото',
    LocaleKeys.messengerAttachmentVideo: 'Видео',
    LocaleKeys.matchFiltersTitle: 'Фильтр поиска',
    LocaleKeys.matchFiltersDistance: 'Дистанция',
    LocaleKeys.matchFiltersDistanceValue: '{min}–{max} км',
    LocaleKeys.matchFiltersAge: 'Возраст',
    LocaleKeys.matchFiltersAgeValue: '{min}–{max} лет',
    LocaleKeys.matchFiltersApply: 'Применить фильтр',
    LocaleKeys.matchFinishTitle: 'Свайпы закончились',
    LocaleKeys.matchFinishSubtitle:
        'Попробуйте изменить фильтр или отменить дизлайки.',
    LocaleKeys.matchResetDislikes: 'Отменить дизлайки',
    LocaleKeys.matchTryChangeFilters: 'Попробуйте изменить фильтр',
    LocaleKeys.matchProfileDetailsTitle: 'Профиль',
    LocaleKeys.matchProfileCityLabel: 'Город',
    LocaleKeys.matchProfileDistanceLabel: 'Дистанция',
    LocaleKeys.matchProfileRatingLabel: 'Рейтинг',
    LocaleKeys.matchProfileSportsLabel: 'Виды спорта',
    LocaleKeys.matchProfileLevelLabel: 'Уровень',
    LocaleKeys.levelAmateur: 'Любитель',
    LocaleKeys.levelSemiPro: 'Полупрофи',
    LocaleKeys.levelProfessional: 'Профессионал',
    LocaleKeys.onboardingSportSelectionTitle: 'Во что играешь?',
    LocaleKeys.onboardingSportSelectionSubtitle:
        'Выбери все подходящие. Позже можно добавить ещё.',
    LocaleKeys.onboardingSportSelectionSearchHint:
        'Поиск дисциплин (например, Бокс, Падел)',
    LocaleKeys.onboardingSportSelectionInfo:
        'Каждый выбранный вид спорта создаст отдельный профиль для спарринга.',
    LocaleKeys.onboardingSportSelectionCreateProfiles:
        'Создать профили: {count}',
    LocaleKeys.onboardingLevelChoosePathTitle: 'Выбери свой путь',
    LocaleKeys.onboardingLevelChoosePathSubtitle:
        'Выбери уровень, чтобы получить подходящие матчи.',
    LocaleKeys.onboardingLevelAmateurSubtitle: 'Старт с ~800-1000 ELO',
    LocaleKeys.onboardingLevelAmateurDetail1:
        'Простой онбординг и мгновенный доступ к матчам.',
    LocaleKeys.onboardingLevelAmateurDetail2:
        'Подходит новичкам и тем, кто играет для себя.',
    LocaleKeys.onboardingLevelSemiProSubtitle: 'Старт с ~1100-1400 ELO',
    LocaleKeys.onboardingLevelSemiProDetail1:
        'Для регулярных тренировок и локальных турниров.',
    LocaleKeys.onboardingLevelSemiProDetail2:
        'Сбалансированный подбор с более сильными соперниками.',
    LocaleKeys.onboardingLevelProfessionalSubtitle: 'Старт с ~1500 ELO',
    LocaleKeys.onboardingLevelProfessionalDetail1:
        'Требуется более высокий соревновательный уровень.',
    LocaleKeys.onboardingLevelProfessionalDetail2:
        'Для доступа может применяться ручная модерация.',
    LocaleKeys.onboardingLevelWhyItMatters:
        'Точный стартовый уровень делает матчмейкинг честнее с первого дня.',
    LocaleKeys.onboardingDetailsProfileTitle: 'Профиль: {level}',
    LocaleKeys.onboardingDetailsFillSubtitle:
        'Заполни детали, чтобы повысить качество подбора.',
    LocaleKeys.onboardingDetailsExperienceLabel: 'Опыт (лет)',
    LocaleKeys.onboardingDetailsExperienceHint: 'например, 2',
    LocaleKeys.onboardingDetailsYearsSuffix: 'лет',
    LocaleKeys.onboardingDetailsExperienceDesc:
        'Сколько лет ты занимаешься выбранными видами спорта.',
    LocaleKeys.onboardingDetailsSkillsLabel: 'Навыки и теги',
    LocaleKeys.onboardingDetailsAddSkillHint:
        'Добавь навык (например, Кикбоксинг)',
    LocaleKeys.onboardingDetailsSuggestionsLabel: 'Подсказки',
    LocaleKeys.onboardingDetailsCompleteProfile: 'Завершить профиль',
    LocaleKeys.onboardingDetailsSelectSportLevelWarning:
        'Сначала выбери вид спорта и уровень.',
    LocaleKeys.onboardingDetailsProfileCreatedSuccess: 'Профиль успешно создан',
    LocaleKeys.onboardingDetailsLevelFallback: 'Спорт',
    LocaleKeys.profileAvatarChooseGallery: 'Выбрать из галереи',
    LocaleKeys.profileAvatarTakePhoto: 'Сделать фото',
    LocaleKeys.sportPreferencesSearchHint: 'Поиск видов спорта',
    LocaleKeys.sportPreferencesLevelLabel: 'Уровень',
    LocaleKeys.sportPreferencesExperienceHint: 'Опыт в годах',
    LocaleKeys.sportPreferencesAddSkillHint: 'Добавить тег навыка',
    LocaleKeys.sportPreferencesSave: 'Сохранить',
    LocaleKeys.sportPreferencesSaving: 'Сохранение...',
    LocaleKeys.sportPreferencesSelectAtLeastOne:
        'Выберите хотя бы один вид спорта.',
    LocaleKeys.sportPreferencesUpdatedSuccess:
        'Спортивные предпочтения обновлены',
  },
  'kk': {
    LocaleKeys.discovery: 'Іздеу',
    LocaleKeys.findPartners: 'Серіктестерді тап',
    LocaleKeys.nearby: 'Жақын',
    LocaleKeys.timeMatch: 'Уақыт бойынша таңдау',
    LocaleKeys.skills: 'Дағдылар',
    LocaleKeys.info: 'Ақпарат',
    LocaleKeys.actionPass: 'Өткізу',
    LocaleKeys.actionBoost: 'Буст',
    LocaleKeys.actionLike: 'Матч',
    LocaleKeys.actionInfo: 'Ақпарат',
    LocaleKeys.navMatch: 'Матч',
    LocaleKeys.navSearch: 'Іздеу',
    LocaleKeys.navChats: 'Чаттар',
    LocaleKeys.navProfile: 'Профиль',
    LocaleKeys.nameAge: '{name}, {age}',
    LocaleKeys.sportLevel: '{sport} • {level}',
    LocaleKeys.distanceKm: '{value} км қашықтықта',
    LocaleKeys.rating: '{value}',
    LocaleKeys.profile: 'Профиль',
    LocaleKeys.settings: 'Баптаулар',
    LocaleKeys.leagueGold: 'Алтын лига',
    LocaleKeys.location: '{city}, {country}',
    LocaleKeys.performanceStats: 'Статистика',
    LocaleKeys.reputation: 'Бедел',
    LocaleKeys.record: 'Рекорд',
    LocaleKeys.matches: 'Жекпе-жек',
    LocaleKeys.reliability: 'Сенімділік',
    LocaleKeys.nextMatch: 'Келесі матч',
    LocaleKeys.viewCalendar: 'Күнтізбе',
    LocaleKeys.opponent: 'Қарсылас',
    LocaleKeys.statusConfirmed: 'Расталды',
    LocaleKeys.todayAt: 'Бүгін, {time}',
    LocaleKeys.details: 'Толығырақ',
    LocaleKeys.settingsHistory: 'Баптаулар және тарих',
    LocaleKeys.availability: 'Қолжетімділік',
    LocaleKeys.availabilityDesc: 'Жаттығу слоттарын басқару',
    LocaleKeys.sportPreferences: 'Спорт қалаулары',
    LocaleKeys.sportPreferencesDesc: 'Бокс, муай тай, BJJ',
    LocaleKeys.matchHistory: 'Жекпе-жек тарихы',
    LocaleKeys.matchHistoryDesc: 'Өткен спаррингтер мен даулар',
    LocaleKeys.searchSettingsPlaceholder: 'Баптаулар, даулар, құпиялылық...',
    LocaleKeys.account: 'Аккаунт',
    LocaleKeys.personalInfo: 'Жеке деректер',
    LocaleKeys.passwordSecurity: 'Қауіпсіздік',
    LocaleKeys.linkedAccounts: 'Байланған аккаунттар',
    LocaleKeys.sparringPrivacy: 'Спарринг және құпиялылық',
    LocaleKeys.publicVisibility: 'Публичность',
    LocaleKeys.publicVisibilityDesc: 'Мені матчқа табуға рұқсат ету',
    LocaleKeys.sparringPreferences: 'Спарринг қалаулары',
    LocaleKeys.blockedUsers: 'Қара тізім',
    LocaleKeys.notifications: 'Хабарландырулар',
    LocaleKeys.matchRequests: 'Матч сұраулары',
    LocaleKeys.disputeUpdates: 'Даулар туралы жаңартулар',
    LocaleKeys.support: 'Қолдау',
    LocaleKeys.helpCenter: 'Көмек және FAQ',
    LocaleKeys.fairPlayRules: 'Fair play ережелері',
    LocaleKeys.logout: 'Шығу',
    LocaleKeys.version: 'Нұсқа {version}',
    LocaleKeys.matchResult: 'Матч нәтижесі',
    LocaleKeys.sparringSession: 'Спарринг',
    LocaleKeys.pending: 'Күтілуде',
    LocaleKeys.enterFinalScore: 'Қорытынды есепті енгізіңіз',
    LocaleKeys.submitResult: 'Нәтижені жіберу',
    LocaleKeys.dispute: 'Даудың бар ма?',
    LocaleKeys.toCourt: 'Сотқа',
    LocaleKeys.disputeNote:
        'Дауды бастау нәтижені тоқтатады және дәлелдер сұрайды.',
    LocaleKeys.scoreConfirmNote: 'Есеп қарсылас тарапынан расталуы керек.',
    LocaleKeys.you: 'СІЗ',
    LocaleKeys.chats: 'Чаттар',
    LocaleKeys.myGames: 'Менің матчтарым',
    LocaleKeys.searchMatches: 'Матчтарды іздеу...',
    LocaleKeys.tabActiveMatches: 'Белсенді',
    LocaleKeys.tabArchived: 'Архив',
    LocaleKeys.actionRequired: 'Әрекет қажет',
    LocaleKeys.upcoming: 'Жақында',
    LocaleKeys.resolveDispute: 'Дауды шешу',
    LocaleKeys.viewProposal: 'Ұсынысты қарау',
    LocaleKeys.contractSigned: 'КЕЛІСІМШАРТ ҚОЛ ҚОЙЫЛДЫ',
    LocaleKeys.draftingContract: 'КЕЛІСІМШАРТ ДАЙЫНДАЛУДА',
    LocaleKeys.matched: 'Матч! Жоспарлау үшін жазыңыз.',
    LocaleKeys.aiAssistant: 'AI-ассистент',
    LocaleKeys.aiComingSoon: 'Жақында',
    LocaleKeys.aiAssistantSubtitle: 'Мұнда сіздің жеке fight-AI қосылады.',
    LocaleKeys.madeWithCare: 'Сіз үшін қамқорлықпен жасалды ❤️',
    LocaleKeys.language: 'Тіл',
    LocaleKeys.reputationExcellent: 'Өте жақсы',
    LocaleKeys.matchesDeltaThisMonth: '+{value} осы айда',
    LocaleKeys.statusDisputeOpen: 'Даудың ашылды',
    LocaleKeys.statusContractSigned: 'ШАРТ ҚОЛ ҚОЙЫЛДЫ',
    LocaleKeys.statusDraftingContract: 'ШАРТ ДАЙЫНДАЛУДА',
    LocaleKeys.statusMatched: 'Матч',
    LocaleKeys.arenaTitle: 'Арена',
    LocaleKeys.arenaStanding: 'СЕНІҢ КӨРСЕТКІШІҢ',
    LocaleKeys.arenaRank: 'Дәреже',
    LocaleKeys.arenaRating: 'Рейтинг: {value}',
    LocaleKeys.arenaAllPlayers: 'Барлық ойыншылар',
    LocaleKeys.arenaFairFight: 'Әділ жекпе-жек (+/- 200)',
    LocaleKeys.arenaInRange: 'Сенің диапазонда',
    LocaleKeys.arenaChallenge: 'Шақыру',
    LocaleKeys.arenaPending: 'Күту',
    LocaleKeys.walletBalance: 'Баланс: {value}',
    LocaleKeys.walletTransfer: 'Аудару',
    LocaleKeys.walletStore: 'Дүкен',
    LocaleKeys.walletHistory: 'Тарих',
    LocaleKeys.walletDailyReward: 'Күн сайынғы сыйақы',
    LocaleKeys.walletClaimBonus: 'Серия бонусын ал',
    LocaleKeys.walletClaim: 'Алу',
    LocaleKeys.walletDailyStreak: 'Күн сайынғы серия',
    LocaleKeys.walletDay: '{value}-күн',
    LocaleKeys.walletGetReward: 'Сыйақыны алу',
    LocaleKeys.walletCoins: '{value} монета',
    LocaleKeys.walletPhoneNumber: 'Телефон нөмірі',
    LocaleKeys.walletCoinsAmount: 'Монет саны',
    LocaleKeys.walletBuy: 'Сатып алу',
    LocaleKeys.walletSend: 'Жіберу',
    LocaleKeys.storeItemGym: 'Зал абонементі',
    LocaleKeys.storeItemEquipment: 'Жабдық',
    LocaleKeys.storeItemCoach: 'Жаттықтыру сабағы',
    LocaleKeys.storeItemEnergy: 'Энергетик',
    LocaleKeys.onboardingTitle: 'Күшті жаттығу,\nбірге.',
    LocaleKeys.onboardingSubtitle:
        'Жекпе-жекшілерге арналған гибридті матчинг. Серіктестерді тап, статистиканы жүргіз, қауіпсіз дамы.',
    LocaleKeys.getStarted: 'Бастау',
    LocaleKeys.logIn: 'Кіру',
    LocaleKeys.phoneNumber: 'Телефон нөмірі',
    LocaleKeys.sendCode: 'Код жіберу',
    LocaleKeys.phoneEntryTitle: 'Рингке кірейік.',
    LocaleKeys.phoneEntrySubtitle:
        'Аккаунтты растау және спарринг табу үшін нөмірді енгіз.',
    LocaleKeys.termsAgree:
        'Жалғастыру арқылы Шарттармен және Құпиялылық саясатымен келісесіз.',
    LocaleKeys.verificationTitle: 'Растау кодын енгізіңіз',
    LocaleKeys.verificationSubtitle:
        'Код {phone} нөміріне жіберілді. Жалғастыру үшін енгізіңіз.',
    LocaleKeys.resendCode: 'Қайта жіберу',
    LocaleKeys.verifyIdentity: 'Тұлғаны растау',
    LocaleKeys.profileInfoTitle: 'Өзің туралы айт',
    LocaleKeys.profileInfoSubtitle: 'Біз матчты жеке баптаймыз.',
    LocaleKeys.firstName: 'Аты',
    LocaleKeys.lastName: 'Тегі',
    LocaleKeys.email: 'Email',
    LocaleKeys.birthDate: 'Туған күн',
    LocaleKeys.city: 'Қала',
    LocaleKeys.continueLabel: 'Жалғастыру',

    LocaleKeys.notifTitleSuccess: 'Сәтті',
    LocaleKeys.notifTitleWarning: 'Ескерту',
    LocaleKeys.notifTitleInfo: 'Хабарлама',
    LocaleKeys.notifTitleError: 'Қате',
    LocaleKeys.errorNoConnectionTitle: 'Байланыс жоқ',
    LocaleKeys.errorNoConnectionMessage:
        'Интернетке қосылуды тексеріп, қайта көріңіз.',
    LocaleKeys.errorTimeoutTitle: 'Сервер жауап бермейді',
    LocaleKeys.errorTimeoutMessage: 'Кейінірек қайталап көріңіз.',
    LocaleKeys.errorUnauthorizedTitle: 'Сеанс аяқталды',
    LocaleKeys.errorUnauthorizedMessage: 'Қайта кіріңіз.',
    LocaleKeys.errorForbiddenTitle: 'Қатынау жоқ',
    LocaleKeys.errorForbiddenMessage: 'Бұл әрекетті орындауға рұқсат жоқ.',
    LocaleKeys.errorNotFoundTitle: 'Табылмады',
    LocaleKeys.errorNotFoundMessage: 'Сұралған деректер табылмады.',
    LocaleKeys.errorServerTitle: 'Сервер қатесі',
    LocaleKeys.errorServerMessage: 'Кейінірек көріңіз немесе қолдауға жазыңыз.',
    LocaleKeys.errorUnknownTitle: 'Қате',
    LocaleKeys.errorUnknownMessage: 'Бірдеңе дұрыс емес. Қайта көріңіз.',
    LocaleKeys.phoneNumberIncompleteTitle: 'Қате нөмір',
    LocaleKeys.phoneNumberIncompleteMessage: 'Телефон нөмірін толық енгізіңіз.',
    LocaleKeys.verifyCodeIncompleteTitle: 'Растау коды',
    LocaleKeys.verifyCodeIncompleteMessage: 'Кодты толық енгізіңіз.',
    LocaleKeys.profileSavedMessage: 'Профиль сақталды',
    LocaleKeys.messengerStartConversation: 'Әңгіме бастаңыз',
    LocaleKeys.messengerOnline: 'Онлайн',
    LocaleKeys.messengerMessageHint: 'Хабарлама...',
    LocaleKeys.messengerBlockedHint: 'Сіз бұл пайдаланушыны бұғаттадыңыз',
    LocaleKeys.messengerActionDeleteChat: 'Чатты жою',
    LocaleKeys.messengerActionBlockUser: 'Пайдаланушыны бұғаттау',
    LocaleKeys.messengerActionReport: 'Шағымдану',
    LocaleKeys.messengerDialogDeleteTitle: 'Чатты жою керек пе?',
    LocaleKeys.messengerDialogDeleteDesc: 'Диалог тек сізде жойылады.',
    LocaleKeys.messengerDialogDeleteConfirm: 'Жою',
    LocaleKeys.messengerDialogBlockTitle: 'Пайдаланушыны бұғаттайсыз ба?',
    LocaleKeys.messengerDialogBlockDesc: 'Сіз хабарламаларды алмайсыз.',
    LocaleKeys.messengerDialogBlockConfirm: 'Бұғаттау',
    LocaleKeys.messengerDialogReportTitle: 'Шағым жіберу керек пе?',
    LocaleKeys.messengerDialogReportDesc: 'Шағымыңызды қарастырамыз.',
    LocaleKeys.messengerDialogReportConfirm: 'Жіберу',
    LocaleKeys.messengerDialogCancel: 'Бас тарту',
    LocaleKeys.messengerChatDeleted: 'Чат жойылды',
    LocaleKeys.messengerUserBlocked: 'Пайдаланушы бұғатталды',
    LocaleKeys.messengerReportSent: 'Шағым жіберілді',
    LocaleKeys.messengerSomethingWrong: 'Қате орын алды',
    LocaleKeys.messengerAttachmentCamera: 'Фото түсіру',
    LocaleKeys.messengerAttachmentLibrary: 'Фото/видео қосу',
    LocaleKeys.messengerAttachmentFile: 'Файлды тіркеу',
    LocaleKeys.messengerAttachmentPhoto: 'Фото',
    LocaleKeys.messengerAttachmentVideo: 'Видео',
    LocaleKeys.matchFiltersTitle: 'Іздеу сүзгілері',
    LocaleKeys.matchFiltersDistance: 'Қашықтық',
    LocaleKeys.matchFiltersDistanceValue: '{min}–{max} км',
    LocaleKeys.matchFiltersAge: 'Жас',
    LocaleKeys.matchFiltersAgeValue: '{min}–{max} жас',
    LocaleKeys.matchFiltersApply: 'Сүзгіні қолдану',
    LocaleKeys.matchFinishTitle: 'Свайптар аяқталды',
    LocaleKeys.matchFinishSubtitle:
        'Сүзгіні өзгертіп көріңіз немесе дизлайктарды қайтарыңыз.',
    LocaleKeys.matchResetDislikes: 'Дизлайктарды қайтару',
    LocaleKeys.matchTryChangeFilters: 'Сүзгіні өзгертіп көріңіз',
    LocaleKeys.matchProfileDetailsTitle: 'Профиль',
    LocaleKeys.matchProfileCityLabel: 'Қала',
    LocaleKeys.matchProfileDistanceLabel: 'Қашықтық',
    LocaleKeys.matchProfileRatingLabel: 'Рейтинг',
    LocaleKeys.matchProfileSportsLabel: 'Спорт түрлері',
    LocaleKeys.matchProfileLevelLabel: 'Деңгейі',
    LocaleKeys.levelAmateur: 'Әуесқой',
    LocaleKeys.levelSemiPro: 'Жартылай кәсіпқой',
    LocaleKeys.levelProfessional: 'Кәсіпқой',
    LocaleKeys.onboardingSportSelectionTitle: 'Қай спортпен айналысасың?',
    LocaleKeys.onboardingSportSelectionSubtitle:
        'Сәйкес келетінінің бәрін таңда. Кейін тағы қоса аласың.',
    LocaleKeys.onboardingSportSelectionSearchHint:
        'Пәндерді іздеу (мысалы, Бокс, Падел)',
    LocaleKeys.onboardingSportSelectionInfo:
        'Таңдалған әр спорт түрі үшін бөлек спарринг профилі жасалады.',
    LocaleKeys.onboardingSportSelectionCreateProfiles: '{count} профиль жасау',
    LocaleKeys.onboardingLevelChoosePathTitle: 'Жолыңды таңда',
    LocaleKeys.onboardingLevelChoosePathSubtitle:
        'Дұрыс матчтар үшін деңгейіңді таңда.',
    LocaleKeys.onboardingLevelAmateurSubtitle: 'Бастапқысы ~800-1000 ELO',
    LocaleKeys.onboardingLevelAmateurDetail1:
        'Оңай онбординг және матчтарға жылдам қолжеткізу.',
    LocaleKeys.onboardingLevelAmateurDetail2:
        'Жаңадан бастағандар мен әуесқойларға ыңғайлы.',
    LocaleKeys.onboardingLevelSemiProSubtitle: 'Бастапқысы ~1100-1400 ELO',
    LocaleKeys.onboardingLevelSemiProDetail1:
        'Тұрақты жаттығу және жергілікті турнир тәжірибесі үшін.',
    LocaleKeys.onboardingLevelSemiProDetail2:
        'Күштірек қарсыластармен теңгерімді матчмейкинг.',
    LocaleKeys.onboardingLevelProfessionalSubtitle: 'Бастапқысы ~1500 ELO',
    LocaleKeys.onboardingLevelProfessionalDetail1:
        'Жоғары жарыс тәжірибесі қажет.',
    LocaleKeys.onboardingLevelProfessionalDetail2:
        'Қолжеткізу үшін қолмен модерация қолданылуы мүмкін.',
    LocaleKeys.onboardingLevelWhyItMatters:
        'Деңгейді дұрыс бастау алғашқы күннен әділ матчмейкинг береді.',
    LocaleKeys.onboardingDetailsProfileTitle: '{level} профилі',
    LocaleKeys.onboardingDetailsFillSubtitle:
        'Матч сапасын арттыру үшін мәліметтерді толтыр.',
    LocaleKeys.onboardingDetailsExperienceLabel: 'Тәжірибе (жыл)',
    LocaleKeys.onboardingDetailsExperienceHint: 'мысалы, 2',
    LocaleKeys.onboardingDetailsYearsSuffix: 'Жыл',
    LocaleKeys.onboardingDetailsExperienceDesc:
        'Таңдалған спорт түрлерімен айналысқан жалпы уақытың.',
    LocaleKeys.onboardingDetailsSkillsLabel: 'Дағдылар мен тегтер',
    LocaleKeys.onboardingDetailsAddSkillHint: 'Дағды қосу (мысалы, Кикбоксинг)',
    LocaleKeys.onboardingDetailsSuggestionsLabel: 'Ұсыныстар',
    LocaleKeys.onboardingDetailsCompleteProfile: 'Профильді аяқтау',
    LocaleKeys.onboardingDetailsSelectSportLevelWarning:
        'Алдымен спорт пен деңгейді таңда.',
    LocaleKeys.onboardingDetailsProfileCreatedSuccess: 'Профиль сәтті жасалды',
    LocaleKeys.onboardingDetailsLevelFallback: 'Спорт',
    LocaleKeys.profileAvatarChooseGallery: 'Галереядан таңдау',
    LocaleKeys.profileAvatarTakePhoto: 'Фото түсіру',
    LocaleKeys.sportPreferencesSearchHint: 'Спорт түрлерін іздеу',
    LocaleKeys.sportPreferencesLevelLabel: 'Деңгей',
    LocaleKeys.sportPreferencesExperienceHint: 'Тәжірибе (жыл)',
    LocaleKeys.sportPreferencesAddSkillHint: 'Дағды тегін қосу',
    LocaleKeys.sportPreferencesSave: 'Сақтау',
    LocaleKeys.sportPreferencesSaving: 'Сақталуда...',
    LocaleKeys.sportPreferencesSelectAtLeastOne:
        'Кемінде бір спорт түрін таңдаңыз.',
    LocaleKeys.sportPreferencesUpdatedSuccess: 'Спорт баптаулары жаңартылды',
  },
};
