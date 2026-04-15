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

  static const Map<String, String> _sportKeyByCodeOrName = {
    'BOXING': LocaleKeys.sportBoxing,
    'MUAY_THAI': LocaleKeys.sportMuayThai,
    'MUAYTHAI': LocaleKeys.sportMuayThai,
    'BJJ': LocaleKeys.sportBjj,
    'TENNIS': LocaleKeys.sportTennis,
    'PADEL': LocaleKeys.sportPadel,
    'BASKETBALL': LocaleKeys.sportBasketball,
    'FOOTBALL': LocaleKeys.sportFootball,
    'SOCCER': LocaleKeys.sportFootball,
    'WRESTLING': LocaleKeys.sportWrestling,
    'SWIMMING': LocaleKeys.sportSwimming,
    'RUNNING': LocaleKeys.sportRunning,
    'MMA': LocaleKeys.sportMma,
    'KICKBOXING': LocaleKeys.sportKickboxing,
    'VOLLEYBALL': LocaleKeys.sportVolleyball,
    'TABLE_TENNIS': LocaleKeys.sportTableTennis,
    'TABLETENNIS': LocaleKeys.sportTableTennis,
  };

  static const Map<String, String> _skillTagKeyByCodeOrName = {
    'STRIKING': LocaleKeys.skillTagStriking,
    'CARDIO': LocaleKeys.skillTagCardio,
    'ENDURANCE': LocaleKeys.skillTagEndurance,
    'DEFENSE': LocaleKeys.skillTagDefense,
    'DEFENCE': LocaleKeys.skillTagDefense,
    'FOOTWORK': LocaleKeys.skillTagFootwork,
    'SERVE': LocaleKeys.skillTagServe,
    'AGILITY': LocaleKeys.skillTagAgility,
    'TECHNIQUE': LocaleKeys.skillTagTechnique,
    'SPEED': LocaleKeys.skillTagSpeed,
    'CLINCH': LocaleKeys.skillTagClinch,
    'POWER': LocaleKeys.skillTagPower,
    'STAMINA': LocaleKeys.skillTagStamina,
    'PACE': LocaleKeys.skillTagPace,
    'PASSING': LocaleKeys.skillTagPassing,
    'GRAPPLING': LocaleKeys.skillTagGrappling,
    'SOUTHPAW': LocaleKeys.skillTagSouthpaw,
    'SOUTH_PAW': LocaleKeys.skillTagSouthpaw,
  };

  String _normalizeToken(String value) =>
      value.trim().toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');

  String _humanizeToken(String value) {
    final normalized = _normalizeToken(value);
    if (normalized.isEmpty) return '';
    return normalized
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) {
          if (part.length <= 2) return part;
          return '${part[0]}${part.substring(1).toLowerCase()}';
        })
        .join(' ');
  }

  String sportName(String codeOrName) {
    final key = _sportKeyByCodeOrName[_normalizeToken(codeOrName)];
    if (key != null) {
      return _string(key);
    }
    return _humanizeToken(codeOrName);
  }

  List<String> sportNames(Iterable<String> values) =>
      values.map(sportName).where((value) => value.isNotEmpty).toList();

  String skillTag(String codeOrName) {
    final key = _skillTagKeyByCodeOrName[_normalizeToken(codeOrName)];
    if (key != null) {
      return _string(key);
    }
    return _humanizeToken(codeOrName);
  }

  List<String> skillTags(Iterable<String> values) =>
      values.map(skillTag).where((value) => value.isNotEmpty).toList();

  String levelName(String codeOrName) {
    switch (_normalizeToken(codeOrName)) {
      case 'SEMI_PRO':
      case 'SEMIPRO':
        return levelSemiPro;
      case 'PRO':
      case 'PROFESSIONAL':
        return levelProfessional;
      case 'AMATEUR':
        return levelAmateur;
      default:
        return _humanizeToken(codeOrName);
    }
  }

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
  String get leagueBronze => _string(LocaleKeys.leagueBronze);
  String get leagueSilver => _string(LocaleKeys.leagueSilver);
  String get leaguePlatinum => _string(LocaleKeys.leaguePlatinum);
  String get leagueDiamond => _string(LocaleKeys.leagueDiamond);
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
  String get availabilityLocation => _string(LocaleKeys.availabilityLocation);
  String get availabilityLocationHint =>
      _string(LocaleKeys.availabilityLocationHint);
  String get availabilityWeeklySchedule =>
      _string(LocaleKeys.availabilityWeeklySchedule);
  String get availabilitySelectAll => _string(LocaleKeys.availabilitySelectAll);
  String get availabilityWeekdays => _string(LocaleKeys.availabilityWeekdays);
  String get availabilityWeekends => _string(LocaleKeys.availabilityWeekends);
  String get availabilityTimeMorning =>
      _string(LocaleKeys.availabilityTimeMorning);
  String get availabilityTimeDay => _string(LocaleKeys.availabilityTimeDay);
  String get availabilityTimeEvening =>
      _string(LocaleKeys.availabilityTimeEvening);
  String get availabilityDayMon => _string(LocaleKeys.availabilityDayMon);
  String get availabilityDayTue => _string(LocaleKeys.availabilityDayTue);
  String get availabilityDayWed => _string(LocaleKeys.availabilityDayWed);
  String get availabilityDayThu => _string(LocaleKeys.availabilityDayThu);
  String get availabilityDayFri => _string(LocaleKeys.availabilityDayFri);
  String get availabilityDaySat => _string(LocaleKeys.availabilityDaySat);
  String get availabilityDaySun => _string(LocaleKeys.availabilityDaySun);
  String get availabilitySupportInfo =>
      _string(LocaleKeys.availabilitySupportInfo);
  String get availabilityHelpFaq => _string(LocaleKeys.availabilityHelpFaq);
  String get aboutUs => _string(LocaleKeys.aboutUs);
  String get availabilityFindPartners =>
      _string(LocaleKeys.availabilityFindPartners);
  String get availabilitySaved => _string(LocaleKeys.availabilitySaved);
  String get availabilityLoadFailed =>
      _string(LocaleKeys.availabilityLoadFailed);
  String get availabilityProfileRequired =>
      _string(LocaleKeys.availabilityProfileRequired);
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
  String get accountOverviewTitle => _string(LocaleKeys.accountOverviewTitle);
  String get accountOverviewContacts =>
      _string(LocaleKeys.accountOverviewContacts);
  String get accountOverviewSports => _string(LocaleKeys.accountOverviewSports);
  String get accountOverviewNoSports =>
      _string(LocaleKeys.accountOverviewNoSports);
  String get accountOverviewAvailability =>
      _string(LocaleKeys.accountOverviewAvailability);
  String get accountOverviewNoAvailability =>
      _string(LocaleKeys.accountOverviewNoAvailability);
  String get accountOverviewStatistics =>
      _string(LocaleKeys.accountOverviewStatistics);
  String get accountOverviewNoStats =>
      _string(LocaleKeys.accountOverviewNoStats);
  String get accountOverviewBirthDate =>
      _string(LocaleKeys.accountOverviewBirthDate);
  String get accountOverviewExperienceYears =>
      _string(LocaleKeys.accountOverviewExperienceYears);
  String get accountOverviewWinRate =>
      _string(LocaleKeys.accountOverviewWinRate);
  String get accountOverviewWins => _string(LocaleKeys.accountOverviewWins);
  String get accountOverviewLosses => _string(LocaleKeys.accountOverviewLosses);
  String get accountOverviewDraws => _string(LocaleKeys.accountOverviewDraws);
  String get notSet => _string(LocaleKeys.notSet);
  String get commonYes => _string(LocaleKeys.commonYes);
  String get commonNo => _string(LocaleKeys.commonNo);
  String get verified => _string(LocaleKeys.verified);
  String get notVerified => _string(LocaleKeys.notVerified);
  String get securityContactsTitle => _string(LocaleKeys.securityContactsTitle);
  String get securityPasswordTitle => _string(LocaleKeys.securityPasswordTitle);
  String get securityPasswordSubtitle =>
      _string(LocaleKeys.securityPasswordSubtitle);
  String get securityCurrentPasswordOptional =>
      _string(LocaleKeys.securityCurrentPasswordOptional);
  String get securityNewPassword => _string(LocaleKeys.securityNewPassword);
  String get securityConfirmPassword =>
      _string(LocaleKeys.securityConfirmPassword);
  String get securityVerificationMethod =>
      _string(LocaleKeys.securityVerificationMethod);
  String get securityChangePasswordAction =>
      _string(LocaleKeys.securityChangePasswordAction);
  String get securityNoVerificationChannel =>
      _string(LocaleKeys.securityNoVerificationChannel);
  String get securityPhoneNotSet => _string(LocaleKeys.securityPhoneNotSet);
  String get securityCodeSent => _string(LocaleKeys.securityCodeSent);
  String get securityCodeRequired => _string(LocaleKeys.securityCodeRequired);
  String get securityPasswordChanged =>
      _string(LocaleKeys.securityPasswordChanged);
  String get securityEmailTitle => _string(LocaleKeys.securityEmailTitle);
  String get securityChangeEmailAction =>
      _string(LocaleKeys.securityChangeEmailAction);
  String get securityEmailChanged => _string(LocaleKeys.securityEmailChanged);
  String get securityPhoneTitle => _string(LocaleKeys.securityPhoneTitle);
  String get securityChangePhoneAction =>
      _string(LocaleKeys.securityChangePhoneAction);
  String get securityPhoneChanged => _string(LocaleKeys.securityPhoneChanged);
  String get blockedUsersUnblock => _string(LocaleKeys.blockedUsersUnblock);
  String get blockedUsersUnblocked => _string(LocaleKeys.blockedUsersUnblocked);
  String get helpContactTitle => _string(LocaleKeys.helpContactTitle);
  String get helpContactBody => _string(LocaleKeys.helpContactBody);
  String get helpFaqQ1 => _string(LocaleKeys.helpFaqQ1);
  String get helpFaqA1 => _string(LocaleKeys.helpFaqA1);
  String get helpFaqQ2 => _string(LocaleKeys.helpFaqQ2);
  String get helpFaqA2 => _string(LocaleKeys.helpFaqA2);
  String get helpFaqQ3 => _string(LocaleKeys.helpFaqQ3);
  String get helpFaqA3 => _string(LocaleKeys.helpFaqA3);
  String get helpFaqQ4 => _string(LocaleKeys.helpFaqQ4);
  String get helpFaqA4 => _string(LocaleKeys.helpFaqA4);
  String get fairPlayRule1 => _string(LocaleKeys.fairPlayRule1);
  String get fairPlayRule2 => _string(LocaleKeys.fairPlayRule2);
  String get fairPlayRule3 => _string(LocaleKeys.fairPlayRule3);
  String get fairPlayRule4 => _string(LocaleKeys.fairPlayRule4);
  String get fairPlayRule5 => _string(LocaleKeys.fairPlayRule5);
  String get fairPlayPenaltyNote => _string(LocaleKeys.fairPlayPenaltyNote);
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
  String get tabDisputes => _string(LocaleKeys.tabDisputes);
  String get noDisputes => _string(LocaleKeys.noDisputes);
  String get myDisputes => _string(LocaleKeys.myDisputes);
  String get communityDisputes => _string(LocaleKeys.communityDisputes);
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
  String get aiOnline => _string(LocaleKeys.aiOnline);
  String get aiOffline => _string(LocaleKeys.aiOffline);
  String get aiMessageHint => _string(LocaleKeys.aiMessageHint);
  String get aiWelcomeMessage => _string(LocaleKeys.aiWelcomeMessage);
  String get aiSuggestion1 => _string(LocaleKeys.aiSuggestion1);
  String get aiSuggestion2 => _string(LocaleKeys.aiSuggestion2);
  String get aiSuggestion3 => _string(LocaleKeys.aiSuggestion3);
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
  String get arenaMatching => _string(LocaleKeys.arenaMatching);
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
  String get authCredentialRegisterSubtitle =>
      _string(LocaleKeys.authCredentialRegisterSubtitle);
  String get authCredentialLoginSubtitle =>
      _string(LocaleKeys.authCredentialLoginSubtitle);
  String get authCredentialOptional =>
      _string(LocaleKeys.authCredentialOptional);
  String get authCredentialLoginLabel =>
      _string(LocaleKeys.authCredentialLoginLabel);
  String get authCredentialLoginHint =>
      _string(LocaleKeys.authCredentialLoginHint);
  String get authCredentialPasswordLabel =>
      _string(LocaleKeys.authCredentialPasswordLabel);
  String get authCredentialConfirmPasswordLabel =>
      _string(LocaleKeys.authCredentialConfirmPasswordLabel);
  String get authCredentialSwitchToLogin =>
      _string(LocaleKeys.authCredentialSwitchToLogin);
  String get authCredentialSwitchToRegister =>
      _string(LocaleKeys.authCredentialSwitchToRegister);
  String get authCredentialUseOtp => _string(LocaleKeys.authCredentialUseOtp);
  String get authCredentialPasswordTooShort =>
      _string(LocaleKeys.authCredentialPasswordTooShort);
  String get authCredentialPasswordsMismatch =>
      _string(LocaleKeys.authCredentialPasswordsMismatch);
  String get authCredentialLoginRequired =>
      _string(LocaleKeys.authCredentialLoginRequired);
  String get authCredentialEmailRegistered =>
      _string(LocaleKeys.authCredentialEmailRegistered);
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
  String get messengerReportTargetLabel =>
      _string(LocaleKeys.messengerReportTargetLabel);
  String get messengerReportDescriptionTitle =>
      _string(LocaleKeys.messengerReportDescriptionTitle);
  String get messengerReportDescriptionHint =>
      _string(LocaleKeys.messengerReportDescriptionHint);
  String get messengerReportDescriptionRequired =>
      _string(LocaleKeys.messengerReportDescriptionRequired);
  String messengerReportCounter(int used, int max, int left) =>
      _string(LocaleKeys.messengerReportCounter)
          .replaceFirst('{used}', used.toString())
          .replaceFirst('{max}', max.toString())
          .replaceFirst('{left}', left.toString());
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
  String get onboardingDetailsLocalProfileCreatedSuccess =>
      _string(LocaleKeys.onboardingDetailsLocalProfileCreatedSuccess);
  String get profileAvatarChooseGallery =>
      _string(LocaleKeys.profileAvatarChooseGallery);
  String get profileAvatarTakePhoto =>
      _string(LocaleKeys.profileAvatarTakePhoto);
  String get profileVerifyPhoneTitle =>
      _string(LocaleKeys.profileVerifyPhoneTitle);
  String get profileVerifyPhoneSubtitle =>
      _string(LocaleKeys.profileVerifyPhoneSubtitle);
  String get profileVerifyPhoneAction =>
      _string(LocaleKeys.profileVerifyPhoneAction);
  String get authSkipForNow => _string(LocaleKeys.authSkipForNow);
  String get authSkipDialogTitle => _string(LocaleKeys.authSkipDialogTitle);
  String get authSkipDialogMessage => _string(LocaleKeys.authSkipDialogMessage);
  String get authSkipDialogConfirm => _string(LocaleKeys.authSkipDialogConfirm);
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
  String rankWithValue(String value) =>
      _string(LocaleKeys.rankWithValue).replaceFirst('{value}', value);

  // Info modals
  String get infoChatTitle => _string(LocaleKeys.infoChatTitle);
  String get infoChatSubtitle => _string(LocaleKeys.infoChatSubtitle);
  String get infoChatTip1 => _string(LocaleKeys.infoChatTip1);
  String get infoChatTip2 => _string(LocaleKeys.infoChatTip2);
  String get infoChatTip3 => _string(LocaleKeys.infoChatTip3);
  String get infoAiSubtitle => _string(LocaleKeys.infoAiSubtitle);
  String get infoAiTip1 => _string(LocaleKeys.infoAiTip1);
  String get infoAiTip2 => _string(LocaleKeys.infoAiTip2);
  String get infoMatchSubtitle => _string(LocaleKeys.infoMatchSubtitle);
  String get infoMatchTip1 => _string(LocaleKeys.infoMatchTip1);
  String get infoMatchTip2 => _string(LocaleKeys.infoMatchTip2);
  String get infoMatchTip3 => _string(LocaleKeys.infoMatchTip3);
  String get infoDisputeTitle => _string(LocaleKeys.infoDisputeTitle);
  String get infoDisputeSubtitle => _string(LocaleKeys.infoDisputeSubtitle);
  String get infoDisputeTip1 => _string(LocaleKeys.infoDisputeTip1);
  String get infoDisputeTip2 => _string(LocaleKeys.infoDisputeTip2);
  String get infoDisputeTip3 => _string(LocaleKeys.infoDisputeTip3);
  String get infoResultTitle => _string(LocaleKeys.infoResultTitle);
  String get infoResultSubtitle => _string(LocaleKeys.infoResultSubtitle);
  String get infoResultTip1 => _string(LocaleKeys.infoResultTip1);
  String get infoResultTip2 => _string(LocaleKeys.infoResultTip2);
  String get infoResultTip3 => _string(LocaleKeys.infoResultTip3);
  String get infoNextMatchTip1 => _string(LocaleKeys.infoNextMatchTip1);
  String get infoNextMatchTip2 => _string(LocaleKeys.infoNextMatchTip2);
  String get infoNextMatchTip3 => _string(LocaleKeys.infoNextMatchTip3);
  String get infoAuthTitle => _string(LocaleKeys.infoAuthTitle);
  String get infoAuthSubtitle => _string(LocaleKeys.infoAuthSubtitle);
  String get infoAuthTip1 => _string(LocaleKeys.infoAuthTip1);
  String get infoAuthTip2 => _string(LocaleKeys.infoAuthTip2);
  String get infoAuthTip3 => _string(LocaleKeys.infoAuthTip3);
  String get settingsAuthSubtitle => _string(LocaleKeys.settingsAuthSubtitle);
  String get settingsAuthTip1 => _string(LocaleKeys.settingsAuthTip1);
  String get settingsAuthTip2 => _string(LocaleKeys.settingsAuthTip2);
  String get settingsLinkedSubtitle =>
      _string(LocaleKeys.settingsLinkedSubtitle);
  String get settingsLinkedTip => _string(LocaleKeys.settingsLinkedTip);
  String get settingsMatchSubtitle => _string(LocaleKeys.settingsMatchSubtitle);
  String get settingsMatchTip1 => _string(LocaleKeys.settingsMatchTip1);
  String get settingsMatchTip2 => _string(LocaleKeys.settingsMatchTip2);
  String get settingsBlockedSubtitle =>
      _string(LocaleKeys.settingsBlockedSubtitle);
  String get settingsBlockedTip1 => _string(LocaleKeys.settingsBlockedTip1);
  String get settingsBlockedTip2 => _string(LocaleKeys.settingsBlockedTip2);
  String get settingsHelpSubtitle => _string(LocaleKeys.settingsHelpSubtitle);
  String get settingsHelpTip1 => _string(LocaleKeys.settingsHelpTip1);
  String get settingsHelpTip2 => _string(LocaleKeys.settingsHelpTip2);
  String get settingsFairPlaySubtitle =>
      _string(LocaleKeys.settingsFairPlaySubtitle);
  String get settingsFairPlayTip1 => _string(LocaleKeys.settingsFairPlayTip1);
  String get settingsFairPlayTip2 => _string(LocaleKeys.settingsFairPlayTip2);
  String get settingsFairPlayTip3 => _string(LocaleKeys.settingsFairPlayTip3);
  String get settingsFairPlayTip4 => _string(LocaleKeys.settingsFairPlayTip4);

  // Notifications / messages
  String get nameRequired => _string(LocaleKeys.nameRequired);
  String get profileUpdated => _string(LocaleKeys.profileUpdated);
  String get enterScoreBoth => _string(LocaleKeys.enterScoreBoth);
  String get resultConfirmed => _string(LocaleKeys.resultConfirmed);
  String get scoreConflict => _string(LocaleKeys.scoreConflict);
  String get resultSentWaiting => _string(LocaleKeys.resultSentWaiting);
  String get disputeNotAvailable => _string(LocaleKeys.disputeNotAvailable);
  String get disputeNotAvailableTitle =>
      _string(LocaleKeys.disputeNotAvailableTitle);
  String get addDisputeComment => _string(LocaleKeys.addDisputeComment);
  String get validationTitle => _string(LocaleKeys.validationTitle);
  String get karmaDemo => _string(LocaleKeys.karmaDemo);
  String get voteCountedDemo => _string(LocaleKeys.voteCountedDemo);
  String get enterValidEmail => _string(LocaleKeys.enterValidEmail);
  String itemPurchased(String name) =>
      _string(LocaleKeys.itemPurchased).replaceFirst('{name}', name);
  String coinsSent(int coins, String name) => _string(
    LocaleKeys.coinsSent,
  ).replaceFirst('{coins}', coins.toString()).replaceFirst('{name}', name);
  String disputeHeader(String id) =>
      _string(LocaleKeys.disputeHeader).replaceFirst('{id}', id);
  String get disputeEvidence => _string(LocaleKeys.disputeEvidence);
  String get disputeStatements => _string(LocaleKeys.disputeStatements);
  String get disputeRolePlaintiff => _string(LocaleKeys.disputeRolePlaintiff);
  String get disputeRoleDefendant => _string(LocaleKeys.disputeRoleDefendant);
  String get disputeDefendantFallback =>
      _string(LocaleKeys.disputeDefendantFallback);
  String get disputeVoteAccepted => _string(LocaleKeys.disputeVoteAccepted);
  String get disputeVoteParticipantWait =>
      _string(LocaleKeys.disputeVoteParticipantWait);
  String disputeRewardEarned(int karma) => _string(
    LocaleKeys.disputeRewardEarned,
  ).replaceFirst('{karma}', karma.toString());
  String disputeRewardPending(int karma) => _string(
    LocaleKeys.disputeRewardPending,
  ).replaceFirst('{karma}', karma.toString());
  String get disputeRewardReviewPrompt =>
      _string(LocaleKeys.disputeRewardReviewPrompt);
  String disputeRewardFinalVerdict(String winnerName) => _string(
    LocaleKeys.disputeRewardFinalVerdict,
  ).replaceFirst('{winnerName}', winnerName);
  String get disputeResolvedFinalVerdict =>
      _string(LocaleKeys.disputeResolvedFinalVerdict);
  String disputeResolvedWinner(String winnerName) => _string(
    LocaleKeys.disputeResolvedWinner,
  ).replaceFirst('{winnerName}', winnerName);
  String disputeResolvedRatingImpact({
    required String player1Before,
    required String player1After,
    required String player2Before,
    required String player2After,
  }) => _string(LocaleKeys.disputeResolvedRatingImpact)
      .replaceFirst('{player1Before}', player1Before)
      .replaceFirst('{player1After}', player1After)
      .replaceFirst('{player2Before}', player2Before)
      .replaceFirst('{player2After}', player2After);
  String get disputeWinnerCommunity =>
      _string(LocaleKeys.disputeWinnerCommunity);

  // Buttons
  String get save => _string(LocaleKeys.save);
  String get sendToCourt => _string(LocaleKeys.sendToCourt);
  String get noEvidence => _string(LocaleKeys.noEvidence);
  String get retry => _string(LocaleKeys.retry);
  String get refresh => _string(LocaleKeys.refresh);
  String voteFor(String name) =>
      _string(LocaleKeys.voteFor).replaceFirst('{name}', name);
  String get cannotDetermine => _string(LocaleKeys.cannotDetermine);
  String get returnToDashboard => _string(LocaleKeys.returnToDashboard);
  String get ok => _string(LocaleKeys.ok);
  String get pickScore => _string(LocaleKeys.pickScore);
  String get statusWin => _string(LocaleKeys.statusWin);
  String get statusLoss => _string(LocaleKeys.statusLoss);
  String get draw => _string(LocaleKeys.draw);
  String get statusPendingResult => _string(LocaleKeys.statusPendingResult);
  String get statusConflict => _string(LocaleKeys.statusConflict);
  String get statusDispute => _string(LocaleKeys.statusDispute);
  String get coinsLabel => _string(LocaleKeys.coinsLabel);

  // Form labels
  String get disputeCommentLabel => _string(LocaleKeys.disputeCommentLabel);
  String get plaintiffStatementLabel =>
      _string(LocaleKeys.plaintiffStatementLabel);
  String get defendantStatementLabel =>
      _string(LocaleKeys.defendantStatementLabel);
  String get evidenceLinkLabel => _string(LocaleKeys.evidenceLinkLabel);
  String get openDispute => _string(LocaleKeys.openDispute);
  String get disputeLoadFailed => _string(LocaleKeys.disputeLoadFailed);
  String get noActiveDisputes => _string(LocaleKeys.noActiveDisputes);
  String get noActiveDisputesDesc => _string(LocaleKeys.noActiveDisputesDesc);
  String get disputeEvidenceScreenTitle =>
      _string(LocaleKeys.disputeEvidenceScreenTitle);
  String get disputeEvidenceProvideDetailsTitle =>
      _string(LocaleKeys.disputeEvidenceProvideDetailsTitle);
  String get disputeEvidenceProvideDetailsHint =>
      _string(LocaleKeys.disputeEvidenceProvideDetailsHint);
  String get disputeEvidenceDescriptionLabel =>
      _string(LocaleKeys.disputeEvidenceDescriptionLabel);
  String get disputeEvidenceDescriptionHint =>
      _string(LocaleKeys.disputeEvidenceDescriptionHint);
  String get disputeEvidenceVideoTitle =>
      _string(LocaleKeys.disputeEvidenceVideoTitle);
  String get disputeEvidenceTapUpload =>
      _string(LocaleKeys.disputeEvidenceTapUpload);
  String get disputeEvidenceVideoHint =>
      _string(LocaleKeys.disputeEvidenceVideoHint);
  String get disputeEvidenceOrLink => _string(LocaleKeys.disputeEvidenceOrLink);
  String get disputeEvidenceUrlLabel =>
      _string(LocaleKeys.disputeEvidenceUrlLabel);
  String get disputeEvidenceUrlHint =>
      _string(LocaleKeys.disputeEvidenceUrlHint);
  String get disputeEvidenceSubmit => _string(LocaleKeys.disputeEvidenceSubmit);
  String get disputeEvidenceFootnote =>
      _string(LocaleKeys.disputeEvidenceFootnote);
  String get disputeEvidenceDescriptionRequired =>
      _string(LocaleKeys.disputeEvidenceDescriptionRequired);
  String get disputeEvidenceRequired =>
      _string(LocaleKeys.disputeEvidenceRequired);
  String get disputeEvidenceUploadFailed =>
      _string(LocaleKeys.disputeEvidenceUploadFailed);
  String get contractSetupTitle => _string(LocaleKeys.contractSetupTitle);
  String get contractProgressTitle => _string(LocaleKeys.contractProgressTitle);
  String get contractStepContract => _string(LocaleKeys.contractStepContract);
  String get contractStepResult => _string(LocaleKeys.contractStepResult);
  String get contractLockedHint => _string(LocaleKeys.contractLockedHint);
  String get contractLogistics => _string(LocaleKeys.contractLogistics);
  String get contractDateLabel => _string(LocaleKeys.contractDateLabel);
  String get contractTimeLabel => _string(LocaleKeys.contractTimeLabel);
  String get contractDatePlaceholder =>
      _string(LocaleKeys.contractDatePlaceholder);
  String get contractTimePlaceholder =>
      _string(LocaleKeys.contractTimePlaceholder);
  String get contractLocationLabel => _string(LocaleKeys.contractLocationLabel);
  String get contractLocationHint => _string(LocaleKeys.contractLocationHint);
  String get contractNotificationsTitle =>
      _string(LocaleKeys.contractNotificationsTitle);
  String get contractReminderToggle =>
      _string(LocaleKeys.contractReminderToggle);
  String get contractAgreementStatusTitle =>
      _string(LocaleKeys.contractAgreementStatusTitle);
  String get contractAgreementYou => _string(LocaleKeys.contractAgreementYou);
  String get contractAgreementYouStatusPending =>
      _string(LocaleKeys.contractAgreementYouStatusPending);
  String get contractAgreementYouStatusLocked =>
      _string(LocaleKeys.contractAgreementYouStatusLocked);
  String get contractAgreementOpponent =>
      _string(LocaleKeys.contractAgreementOpponent);
  String get contractAgreementOpponentStatus =>
      _string(LocaleKeys.contractAgreementOpponentStatus);
  String get contractCodeOfConduct => _string(LocaleKeys.contractCodeOfConduct);
  String get contractProposeButton => _string(LocaleKeys.contractProposeButton);
  String get contractSaved => _string(LocaleKeys.contractSaved);
  String get contractRequiredDate => _string(LocaleKeys.contractRequiredDate);
  String get contractRequiredLocation =>
      _string(LocaleKeys.contractRequiredLocation);
  String get contractAgreementRequired =>
      _string(LocaleKeys.contractAgreementRequired);
  String get contractOpenButton => _string(LocaleKeys.contractOpenButton);
  String get contractViewDetailsButton =>
      _string(LocaleKeys.contractViewDetailsButton);
  String get contractRequiredBeforeResult =>
      _string(LocaleKeys.contractRequiredBeforeResult);

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
    LocaleKeys.leagueBronze: 'Bronze League',
    LocaleKeys.leagueSilver: 'Silver League',
    LocaleKeys.leaguePlatinum: 'Platinum League',
    LocaleKeys.leagueDiamond: 'Diamond League',
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
    LocaleKeys.availabilityLocation: 'Location',
    LocaleKeys.availabilityLocationHint: 'Enter your city (e.g. Almaty)',
    LocaleKeys.availabilityWeeklySchedule: 'Weekly Schedule',
    LocaleKeys.availabilitySelectAll: 'Select All',
    LocaleKeys.availabilityWeekdays: 'Weekdays',
    LocaleKeys.availabilityWeekends: 'Weekends',
    LocaleKeys.availabilityTimeMorning: 'Morning',
    LocaleKeys.availabilityTimeDay: 'Day',
    LocaleKeys.availabilityTimeEvening: 'Evening',
    LocaleKeys.availabilityDayMon: 'Mon',
    LocaleKeys.availabilityDayTue: 'Tue',
    LocaleKeys.availabilityDayWed: 'Wed',
    LocaleKeys.availabilityDayThu: 'Thu',
    LocaleKeys.availabilityDayFri: 'Fri',
    LocaleKeys.availabilityDaySat: 'Sat',
    LocaleKeys.availabilityDaySun: 'Sun',
    LocaleKeys.availabilitySupportInfo: 'Support & Info',
    LocaleKeys.availabilityHelpFaq: 'Help / FAQ',
    LocaleKeys.aboutUs: 'About Us',
    LocaleKeys.availabilityFindPartners: 'Find Partners',
    LocaleKeys.availabilitySaved: 'Availability saved',
    LocaleKeys.availabilityLoadFailed: 'Failed to load availability',
    LocaleKeys.availabilityProfileRequired:
        'Create sport profile first to save availability.',
    LocaleKeys.sportPreferences: 'Sport Preferences',
    LocaleKeys.sportPreferencesDesc: 'Pick boxing, muay thai, BJJ',
    LocaleKeys.matchHistory: 'Match History',
    LocaleKeys.matchHistoryDesc: 'View past spars and disputes',
    LocaleKeys.searchSettingsPlaceholder: 'Search settings, disputes, privacy…',
    LocaleKeys.account: 'Account',
    LocaleKeys.personalInfo: 'Personal Information',
    LocaleKeys.passwordSecurity: 'Password & Security',
    LocaleKeys.linkedAccounts: 'Linked Accounts',
    LocaleKeys.accountOverviewTitle: 'Account Card',
    LocaleKeys.accountOverviewContacts: 'Contacts & Verification',
    LocaleKeys.accountOverviewSports: 'Sports, Level & Skills',
    LocaleKeys.accountOverviewNoSports: 'No sport preferences yet.',
    LocaleKeys.accountOverviewAvailability: 'My Availability',
    LocaleKeys.accountOverviewNoAvailability:
        'Availability is not configured yet.',
    LocaleKeys.accountOverviewStatistics: 'Sparring Statistics',
    LocaleKeys.accountOverviewNoStats: 'No completed sparrings yet.',
    LocaleKeys.accountOverviewBirthDate: 'Birth date',
    LocaleKeys.accountOverviewExperienceYears: 'Experience (years)',
    LocaleKeys.accountOverviewWinRate: 'Win rate',
    LocaleKeys.accountOverviewWins: 'Wins',
    LocaleKeys.accountOverviewLosses: 'Losses',
    LocaleKeys.accountOverviewDraws: 'Draws',
    LocaleKeys.notSet: 'Not set',
    LocaleKeys.commonYes: 'Yes',
    LocaleKeys.commonNo: 'No',
    LocaleKeys.verified: 'Verified',
    LocaleKeys.notVerified: 'Not verified',
    LocaleKeys.securityContactsTitle: 'Recovery contacts',
    LocaleKeys.securityPasswordTitle: 'Change password',
    LocaleKeys.securityPasswordSubtitle:
        'Use current password or verify via email/phone code.',
    LocaleKeys.securityCurrentPasswordOptional: 'Current password (optional)',
    LocaleKeys.securityNewPassword: 'New password',
    LocaleKeys.securityConfirmPassword: 'Confirm new password',
    LocaleKeys.securityVerificationMethod: 'Verification method',
    LocaleKeys.securityChangePasswordAction: 'Update password',
    LocaleKeys.securityNoVerificationChannel:
        'Choose email or phone for verification.',
    LocaleKeys.securityPhoneNotSet: 'Phone number is not set.',
    LocaleKeys.securityCodeSent: 'Verification code sent.',
    LocaleKeys.securityCodeRequired: 'Enter verification code.',
    LocaleKeys.securityPasswordChanged: 'Password updated successfully.',
    LocaleKeys.securityEmailTitle: 'Change email',
    LocaleKeys.securityChangeEmailAction: 'Verify and change email',
    LocaleKeys.securityEmailChanged: 'Email updated and verified.',
    LocaleKeys.securityPhoneTitle: 'Change phone',
    LocaleKeys.securityChangePhoneAction: 'Verify and change phone',
    LocaleKeys.securityPhoneChanged: 'Phone updated and verified.',
    LocaleKeys.blockedUsersUnblock: 'Unblock',
    LocaleKeys.blockedUsersUnblocked: 'User unblocked.',
    LocaleKeys.helpContactTitle: 'Support contact',
    LocaleKeys.helpContactBody:
        'For payment issues, disputes, or account access problems, contact support: oyin.support@gmail.com',
    LocaleKeys.helpFaqQ1: 'How do I submit sparring result?',
    LocaleKeys.helpFaqA1:
        'Open the match card, enter score for both players, and submit. Result is confirmed when both sides send matching score.',
    LocaleKeys.helpFaqQ2: 'What if opponent sent different score?',
    LocaleKeys.helpFaqA2:
        'Open dispute from result screen and attach evidence (video/link/comment). Jury voting will resolve the final verdict.',
    LocaleKeys.helpFaqQ3: 'How do I change phone or email?',
    LocaleKeys.helpFaqA3:
        'Go to Settings → Password & Security and verify changes by OTP code.',
    LocaleKeys.helpFaqQ4: 'Why can’t I find new opponents?',
    LocaleKeys.helpFaqA4:
        'Check sparring filters (distance/age), sport preferences and public visibility in settings.',
    LocaleKeys.fairPlayRule1:
        'Submit only truthful match scores agreed by both athletes.',
    LocaleKeys.fairPlayRule2:
        'Respect confirmed contract time and location, notify early about changes.',
    LocaleKeys.fairPlayRule3:
        'In disputes, provide real evidence and avoid false accusations.',
    LocaleKeys.fairPlayRule4:
        'Harassment, insults, threats and hate speech are prohibited.',
    LocaleKeys.fairPlayRule5:
        'Repeated violations reduce reliability score and may limit account access.',
    LocaleKeys.fairPlayPenaltyNote:
        'Moderation may reset results, issue temporary restrictions, or suspend account for severe abuse.',
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
    LocaleKeys.tabDisputes: 'Disputes',
    LocaleKeys.noDisputes: 'No disputes yet',
    LocaleKeys.myDisputes: 'My disputes',
    LocaleKeys.communityDisputes: 'Community disputes',
    LocaleKeys.actionRequired: 'Action Required',
    LocaleKeys.upcoming: 'Upcoming',
    LocaleKeys.resolveDispute: 'Resolve Dispute',
    LocaleKeys.viewProposal: 'View Proposal',
    LocaleKeys.contractSigned: 'CONTRACT SIGNED',
    LocaleKeys.draftingContract: 'DRAFTING CONTRACT…',
    LocaleKeys.matched: 'Matched! Start chatting to set up.',
    LocaleKeys.aiAssistant: 'AI Assistant',
    LocaleKeys.aiComingSoon: 'Coming soon',
    LocaleKeys.aiAssistantSubtitle: 'Get AI-powered sports tips and advice.',
    LocaleKeys.aiOnline: 'Online',
    LocaleKeys.aiOffline: 'Offline',
    LocaleKeys.aiMessageHint: 'Ask me anything about sports...',
    LocaleKeys.aiWelcomeMessage:
        'Ask me about warm-ups, injury prevention, technique tips, or match preparation.',
    LocaleKeys.aiSuggestion1: 'How to warm up?',
    LocaleKeys.aiSuggestion2: 'Injury prevention tips',
    LocaleKeys.aiSuggestion3: 'Match preparation',
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
    LocaleKeys.arenaMatching: 'Matching',
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
    LocaleKeys.authCredentialRegisterSubtitle:
        'Create an account and complete your athlete profile',
    LocaleKeys.authCredentialLoginSubtitle:
        'Sign in to an existing account with login and password',
    LocaleKeys.authCredentialOptional: '(optional)',
    LocaleKeys.authCredentialLoginLabel: 'Login',
    LocaleKeys.authCredentialLoginHint: 'Email or phone',
    LocaleKeys.authCredentialPasswordLabel: 'Password',
    LocaleKeys.authCredentialConfirmPasswordLabel: 'Confirm password',
    LocaleKeys.authCredentialSwitchToLogin: 'Already have an account? Log In',
    LocaleKeys.authCredentialSwitchToRegister: 'No account yet? Get Started',
    LocaleKeys.authCredentialUseOtp: 'Sign in with verification code',
    LocaleKeys.authCredentialPasswordTooShort:
        'Password must be at least 6 characters',
    LocaleKeys.authCredentialPasswordsMismatch: 'Passwords do not match',
    LocaleKeys.authCredentialLoginRequired: 'Enter login and password',
    LocaleKeys.authCredentialEmailRegistered:
        'This email is already registered. Use the "Log In" button.',
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
    LocaleKeys.messengerReportTargetLabel: 'User nickname',
    LocaleKeys.messengerReportDescriptionTitle: 'Problem description',
    LocaleKeys.messengerReportDescriptionHint:
        'Describe what happened (max 500 characters)',
    LocaleKeys.messengerReportDescriptionRequired:
        'Please describe the problem.',
    LocaleKeys.messengerReportCounter: '{used}/{max} • Left: {left}',
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
    LocaleKeys.onboardingDetailsLocalProfileCreatedSuccess:
        'Local profile saved. Verify phone later in Profile.',
    LocaleKeys.profileAvatarChooseGallery: 'Choose from gallery',
    LocaleKeys.profileAvatarTakePhoto: 'Take a photo',
    LocaleKeys.profileVerifyPhoneTitle: 'Phone not verified',
    LocaleKeys.profileVerifyPhoneSubtitle:
        'You are in guest mode. Verify your number to enable full online features.',
    LocaleKeys.profileVerifyPhoneAction: 'Verify phone',
    LocaleKeys.authSkipForNow: 'Skip for now',
    LocaleKeys.authSkipDialogTitle: 'Continue without SMS?',
    LocaleKeys.authSkipDialogMessage:
        'You can create profile now and verify phone later in Profile settings.',
    LocaleKeys.authSkipDialogConfirm: 'Continue without SMS',
    LocaleKeys.sportPreferencesSearchHint: 'Search sports',
    LocaleKeys.sportPreferencesLevelLabel: 'Level',
    LocaleKeys.sportPreferencesExperienceHint: 'Experience years',
    LocaleKeys.sportPreferencesAddSkillHint: 'Add skill tag',
    LocaleKeys.sportPreferencesSave: 'Save',
    LocaleKeys.sportPreferencesSaving: 'Saving...',
    LocaleKeys.sportPreferencesSelectAtLeastOne: 'Select at least one sport.',
    LocaleKeys.sportPreferencesUpdatedSuccess: 'Sport preferences updated',
    LocaleKeys.rankWithValue: 'Rank {value}',
    LocaleKeys.sportBoxing: 'Boxing',
    LocaleKeys.sportMuayThai: 'Muay Thai',
    LocaleKeys.sportBjj: 'BJJ',
    LocaleKeys.sportTennis: 'Tennis',
    LocaleKeys.sportPadel: 'Padel',
    LocaleKeys.sportBasketball: 'Basketball',
    LocaleKeys.sportFootball: 'Football',
    LocaleKeys.sportWrestling: 'Wrestling',
    LocaleKeys.sportSwimming: 'Swimming',
    LocaleKeys.sportRunning: 'Running',
    LocaleKeys.sportMma: 'MMA',
    LocaleKeys.sportKickboxing: 'Kickboxing',
    LocaleKeys.sportVolleyball: 'Volleyball',
    LocaleKeys.sportTableTennis: 'Table Tennis',
    LocaleKeys.skillTagStriking: 'Striking',
    LocaleKeys.skillTagCardio: 'Cardio',
    LocaleKeys.skillTagEndurance: 'Endurance',
    LocaleKeys.skillTagDefense: 'Defense',
    LocaleKeys.skillTagFootwork: 'Footwork',
    LocaleKeys.skillTagServe: 'Serve',
    LocaleKeys.skillTagAgility: 'Agility',
    LocaleKeys.skillTagTechnique: 'Technique',
    LocaleKeys.skillTagSpeed: 'Speed',
    LocaleKeys.skillTagClinch: 'Clinch',
    LocaleKeys.skillTagPower: 'Power',
    LocaleKeys.skillTagStamina: 'Stamina',
    LocaleKeys.skillTagPace: 'Pace',
    LocaleKeys.skillTagPassing: 'Passing',
    LocaleKeys.skillTagGrappling: 'Grappling',
    LocaleKeys.skillTagSouthpaw: 'Southpaw',
    // Info modals
    LocaleKeys.infoChatTitle: 'What to do here',
    LocaleKeys.infoChatSubtitle: 'What to do on this screen',
    LocaleKeys.infoChatTip1: 'Action Required cards need your attention first.',
    LocaleKeys.infoChatTip2:
        'Tap Resolve Dispute to open an active dispute and vote.',
    LocaleKeys.infoChatTip3: 'Tap a card to open the chat with the player.',
    LocaleKeys.infoAiSubtitle: 'Module is being prepared for launch.',
    LocaleKeys.infoAiTip1:
        'Match preparation recommendations and dispute analysis will appear here.',
    LocaleKeys.infoAiTip2:
        'For now, tips on evidence and fair play are available.',
    LocaleKeys.infoMatchSubtitle: 'Tips for quick matching',
    LocaleKeys.infoMatchTip1:
        'Swipe right if you are ready to arrange a training session.',
    LocaleKeys.infoMatchTip2:
        'Tap the info card to view the full player profile.',
    LocaleKeys.infoMatchTip3:
        'Change distance and age filters if you run out of cards.',
    LocaleKeys.infoDisputeTitle: 'How the court works',
    LocaleKeys.infoDisputeSubtitle: 'Vote based on evidence only.',
    LocaleKeys.infoDisputeTip1:
        'First watch the video and photos, then read the statements.',
    LocaleKeys.infoDisputeTip2:
        'Your vote is counted once and cannot be changed.',
    LocaleKeys.infoDisputeTip3:
        'After 3 matching votes the dispute is closed automatically.',
    LocaleKeys.infoResultTitle: 'How to submit a result',
    LocaleKeys.infoResultSubtitle:
        'The final score must be confirmed by both sides.',
    LocaleKeys.infoResultTip1:
        'Tap a player card and select their final score.',
    LocaleKeys.infoResultTip2:
        'After submitting, the other player must send a matching result.',
    LocaleKeys.infoResultTip3:
        'If scores differ, open a dispute via "To Court".',
    LocaleKeys.infoNextMatchTip1:
        'Check the meeting place and time in advance.',
    LocaleKeys.infoNextMatchTip2:
        'If plans change, notify your opponent in the chat.',
    LocaleKeys.infoNextMatchTip3:
        'After the match, don\'t forget to submit the final result.',
    LocaleKeys.infoAuthTitle: 'How to start',
    LocaleKeys.infoAuthSubtitle:
        'Brief intro to login and getting started in Oyin.',
    LocaleKeys.infoAuthTip1:
        'Log in with your phone number and verification code.',
    LocaleKeys.infoAuthTip2: 'Fill in your profile to get relevant matches.',
    LocaleKeys.infoAuthTip3:
        'After login, search, challenges and dispute court are available.',
    // Settings info
    LocaleKeys.settingsAuthSubtitle: 'Phone-based authentication is used.',
    LocaleKeys.settingsAuthTip1:
        'Your account is secured by phone verification.',
    LocaleKeys.settingsAuthTip2:
        'No password is required — OTP codes are sent to your phone.',
    LocaleKeys.settingsLinkedSubtitle: 'No linked accounts yet.',
    LocaleKeys.settingsLinkedTip: 'Social account linking is coming soon.',
    LocaleKeys.settingsMatchSubtitle: 'Configure your sparring settings.',
    LocaleKeys.settingsMatchTip1:
        'Use match filters above to set distance and age range.',
    LocaleKeys.settingsMatchTip2:
        'Sport preferences can be changed in your profile.',
    LocaleKeys.settingsBlockedSubtitle: 'No blocked users.',
    LocaleKeys.settingsBlockedTip1: 'You can block users from the chat screen.',
    LocaleKeys.settingsBlockedTip2:
        'Blocked users cannot send you messages or challenges.',
    LocaleKeys.settingsHelpSubtitle: 'Need help?',
    LocaleKeys.settingsHelpTip1: 'Contact support via the chat or email.',
    LocaleKeys.settingsHelpTip2: 'Check the FAQ section for common questions.',
    LocaleKeys.settingsFairPlaySubtitle:
        'Fair play keeps the community strong.',
    LocaleKeys.settingsFairPlayTip1: 'Always report accurate match results.',
    LocaleKeys.settingsFairPlayTip2:
        'Disputes are resolved by community jury votes.',
    LocaleKeys.settingsFairPlayTip3:
        'Repeated false reports lower your reliability score.',
    LocaleKeys.settingsFairPlayTip4: 'High karma earns store rewards.',
    // Notifications
    LocaleKeys.nameRequired: 'Name is required',
    LocaleKeys.profileUpdated: 'Profile updated',
    LocaleKeys.enterScoreBoth: 'Enter score for both players.',
    LocaleKeys.resultConfirmed: 'Result confirmed. Match complete.',
    LocaleKeys.scoreConflict:
        'Scores don\'t match. You can open a dispute via "{toCourt}".',
    LocaleKeys.resultSentWaiting:
        'Result sent. Waiting for the other player to confirm.',
    LocaleKeys.disputeNotAvailable:
        'Dispute is available after CONFLICT status or if already created.',
    LocaleKeys.disputeNotAvailableTitle: 'Not available yet',
    LocaleKeys.addDisputeComment: 'Add a comment to the dispute.',
    LocaleKeys.validationTitle: 'Validation',
    LocaleKeys.karmaDemo: '+50 karma (demo)',
    LocaleKeys.voteCountedDemo: 'Vote counted (demo)',
    LocaleKeys.enterValidEmail: 'Please enter a valid email address',
    LocaleKeys.itemPurchased: '{name} purchased!',
    LocaleKeys.coinsSent: '{coins} coins sent to {name}',
    LocaleKeys.disputeHeader: 'Dispute #{id}',
    LocaleKeys.disputeEvidence: 'Evidence',
    LocaleKeys.disputeStatements: 'Statements',
    LocaleKeys.disputeRolePlaintiff: 'Plaintiff',
    LocaleKeys.disputeRoleDefendant: 'Defendant',
    LocaleKeys.disputeDefendantFallback:
        'The call was incorrect according to my view.',
    LocaleKeys.disputeVoteAccepted:
        'Your vote was accepted. Waiting for final verdict.',
    LocaleKeys.disputeVoteParticipantWait:
        'You are part of this dispute. Please wait for community decision.',
    LocaleKeys.disputeRewardEarned: '+{karma} Karma Earned',
    LocaleKeys.disputeRewardPending: '+{karma} Karma Pending',
    LocaleKeys.disputeRewardReviewPrompt:
        'Review impartially to earn your reward.',
    LocaleKeys.disputeRewardFinalVerdict: 'Final verdict: {winnerName}.',
    LocaleKeys.disputeResolvedFinalVerdict: 'Final Verdict',
    LocaleKeys.disputeResolvedWinner: '{winnerName} won',
    LocaleKeys.disputeResolvedRatingImpact:
        'Rating impact: {player1Before} -> {player1After} | {player2Before} -> {player2After}',
    LocaleKeys.disputeWinnerCommunity: 'Community',
    // Buttons
    LocaleKeys.save: 'Save',
    LocaleKeys.sendToCourt: 'Send to court',
    LocaleKeys.noEvidence: 'No evidence attached',
    LocaleKeys.retry: 'Retry',
    LocaleKeys.refresh: 'Refresh',
    LocaleKeys.voteFor: 'Vote {name}',
    LocaleKeys.cannotDetermine: 'Cannot determine / Draw',
    LocaleKeys.returnToDashboard: 'Return to dashboard',
    LocaleKeys.ok: 'OK',
    LocaleKeys.pickScore: 'Pick score',
    LocaleKeys.statusWin: 'WIN',
    LocaleKeys.statusLoss: 'LOSS',
    LocaleKeys.draw: 'Draw',
    LocaleKeys.statusPendingResult: 'PENDING',
    LocaleKeys.statusConflict: 'Conflict',
    LocaleKeys.statusDispute: 'Dispute',
    LocaleKeys.coinsLabel: 'coins',
    // Form labels
    LocaleKeys.disputeCommentLabel: 'Dispute comment *',
    LocaleKeys.plaintiffStatementLabel: 'Plaintiff statement (optional)',
    LocaleKeys.defendantStatementLabel: 'Defendant statement (optional)',
    LocaleKeys.evidenceLinkLabel: 'Link to video/photo evidence (optional)',
    LocaleKeys.openDispute: 'Open dispute',
    LocaleKeys.disputeLoadFailed: 'Failed to load dispute',
    LocaleKeys.noActiveDisputes: 'No active disputes available',
    LocaleKeys.noActiveDisputesDesc:
        'When a dispute is opened, it will appear here for review.',
    LocaleKeys.disputeEvidenceScreenTitle: 'Dispute Evidence',
    LocaleKeys.disputeEvidenceProvideDetailsTitle: 'Provide Details',
    LocaleKeys.disputeEvidenceProvideDetailsHint:
        'Please describe the incident clearly and attach evidence for fair review.',
    LocaleKeys.disputeEvidenceDescriptionLabel: 'Description of events',
    LocaleKeys.disputeEvidenceDescriptionHint:
        'Explain what happened during the session...',
    LocaleKeys.disputeEvidenceVideoTitle: 'Video Evidence',
    LocaleKeys.disputeEvidenceTapUpload: 'Tap to upload video',
    LocaleKeys.disputeEvidenceVideoHint: 'MP4, MOV up to 100MB',
    LocaleKeys.disputeEvidenceOrLink: 'OR PROVIDE LINK',
    LocaleKeys.disputeEvidenceUrlLabel: 'Video URL',
    LocaleKeys.disputeEvidenceUrlHint: 'e.g. YouTube, Vimeo link',
    LocaleKeys.disputeEvidenceSubmit: 'Submit Evidence',
    LocaleKeys.disputeEvidenceFootnote:
        'Evidence cannot be edited after sending.',
    LocaleKeys.disputeEvidenceDescriptionRequired:
        'Please add a description of the incident.',
    LocaleKeys.disputeEvidenceRequired:
        'Attach video evidence or provide a link.',
    LocaleKeys.disputeEvidenceUploadFailed:
        'Failed to upload video evidence. Please try again.',
    LocaleKeys.contractSetupTitle: 'New Sparring Contract',
    LocaleKeys.contractProgressTitle: 'Progress',
    LocaleKeys.contractStepContract: '1. Contract',
    LocaleKeys.contractStepResult: '2. Result',
    LocaleKeys.contractLockedHint:
        'Contract is confirmed and locked. Date, time and location cannot be changed.',
    LocaleKeys.contractLogistics: 'Logistics',
    LocaleKeys.contractDateLabel: 'Date',
    LocaleKeys.contractTimeLabel: 'Time',
    LocaleKeys.contractDatePlaceholder: 'Select date',
    LocaleKeys.contractTimePlaceholder: 'Select time',
    LocaleKeys.contractLocationLabel: 'Location',
    LocaleKeys.contractLocationHint: 'City Gym, Brooklyn',
    LocaleKeys.contractNotificationsTitle: 'Notifications',
    LocaleKeys.contractReminderToggle: 'Last minute reminder',
    LocaleKeys.contractAgreementStatusTitle: 'Agreement Status',
    LocaleKeys.contractAgreementYou: 'You',
    LocaleKeys.contractAgreementYouStatusPending: 'Ready to sign',
    LocaleKeys.contractAgreementYouStatusLocked: 'Signed',
    LocaleKeys.contractAgreementOpponent: 'Opponent',
    LocaleKeys.contractAgreementOpponentStatus: 'Waiting for signature...',
    LocaleKeys.contractCodeOfConduct:
        'I agree to the Sparring Code of Conduct and dispute policy.',
    LocaleKeys.contractProposeButton: 'Propose Contract',
    LocaleKeys.contractSaved: 'Contract saved. Data is now locked.',
    LocaleKeys.contractRequiredDate: 'Select date and time for sparring.',
    LocaleKeys.contractRequiredLocation: 'Enter sparring location.',
    LocaleKeys.contractAgreementRequired:
        'Confirm agreement with the code of conduct.',
    LocaleKeys.contractOpenButton: 'Create Contract',
    LocaleKeys.contractViewDetailsButton: 'View Confirmed Contract',
    LocaleKeys.contractRequiredBeforeResult:
        'Create and confirm contract first. Only then result/dispute is available.',
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
    LocaleKeys.leagueBronze: 'Бронзовая лига',
    LocaleKeys.leagueSilver: 'Серебряная лига',
    LocaleKeys.leaguePlatinum: 'Платиновая лига',
    LocaleKeys.leagueDiamond: 'Бриллиантовая лига',
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
    LocaleKeys.availabilityLocation: 'Локация',
    LocaleKeys.availabilityLocationHint: 'Введите город (например, Алматы)',
    LocaleKeys.availabilityWeeklySchedule: 'Еженедельный график',
    LocaleKeys.availabilitySelectAll: 'Выбрать всё',
    LocaleKeys.availabilityWeekdays: 'Будни',
    LocaleKeys.availabilityWeekends: 'Выходные',
    LocaleKeys.availabilityTimeMorning: 'Утро',
    LocaleKeys.availabilityTimeDay: 'День',
    LocaleKeys.availabilityTimeEvening: 'Вечер',
    LocaleKeys.availabilityDayMon: 'Пн',
    LocaleKeys.availabilityDayTue: 'Вт',
    LocaleKeys.availabilityDayWed: 'Ср',
    LocaleKeys.availabilityDayThu: 'Чт',
    LocaleKeys.availabilityDayFri: 'Пт',
    LocaleKeys.availabilityDaySat: 'Сб',
    LocaleKeys.availabilityDaySun: 'Вс',
    LocaleKeys.availabilitySupportInfo: 'Поддержка и инфо',
    LocaleKeys.availabilityHelpFaq: 'Помощь / FAQ',
    LocaleKeys.aboutUs: 'О нас',
    LocaleKeys.availabilityFindPartners: 'Найти партнёров',
    LocaleKeys.availabilitySaved: 'Доступность сохранена',
    LocaleKeys.availabilityLoadFailed: 'Не удалось загрузить доступность',
    LocaleKeys.availabilityProfileRequired:
        'Сначала создайте спортивный профиль, чтобы сохранить расписание.',
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
    LocaleKeys.accountOverviewTitle: 'Карточка аккаунта',
    LocaleKeys.accountOverviewContacts: 'Контакты и верификация',
    LocaleKeys.accountOverviewSports: 'Спорт, уровень и навыки',
    LocaleKeys.accountOverviewNoSports:
        'Спортивные предпочтения пока не заполнены.',
    LocaleKeys.accountOverviewAvailability: 'Моя доступность',
    LocaleKeys.accountOverviewNoAvailability: 'Доступность пока не настроена.',
    LocaleKeys.accountOverviewStatistics: 'Статистика спаррингов',
    LocaleKeys.accountOverviewNoStats: 'Завершённых спаррингов пока нет.',
    LocaleKeys.accountOverviewBirthDate: 'Дата рождения',
    LocaleKeys.accountOverviewExperienceYears: 'Опыт (лет)',
    LocaleKeys.accountOverviewWinRate: 'Процент побед',
    LocaleKeys.accountOverviewWins: 'Победы',
    LocaleKeys.accountOverviewLosses: 'Поражения',
    LocaleKeys.accountOverviewDraws: 'Ничьи',
    LocaleKeys.notSet: 'Не указано',
    LocaleKeys.commonYes: 'Да',
    LocaleKeys.commonNo: 'Нет',
    LocaleKeys.verified: 'Подтверждено',
    LocaleKeys.notVerified: 'Не подтверждено',
    LocaleKeys.securityContactsTitle: 'Контакты для восстановления',
    LocaleKeys.securityPasswordTitle: 'Смена пароля',
    LocaleKeys.securityPasswordSubtitle:
        'Используйте текущий пароль или подтверждение кодом по email/телефону.',
    LocaleKeys.securityCurrentPasswordOptional:
        'Текущий пароль (необязательно)',
    LocaleKeys.securityNewPassword: 'Новый пароль',
    LocaleKeys.securityConfirmPassword: 'Подтвердите новый пароль',
    LocaleKeys.securityVerificationMethod: 'Способ подтверждения',
    LocaleKeys.securityChangePasswordAction: 'Обновить пароль',
    LocaleKeys.securityNoVerificationChannel:
        'Выберите email или телефон для подтверждения.',
    LocaleKeys.securityPhoneNotSet: 'Номер телефона не указан.',
    LocaleKeys.securityCodeSent: 'Код подтверждения отправлен.',
    LocaleKeys.securityCodeRequired: 'Введите код.',
    LocaleKeys.securityPasswordChanged: 'Пароль успешно обновлён.',
    LocaleKeys.securityEmailTitle: 'Смена email',
    LocaleKeys.securityChangeEmailAction: 'Подтвердить и сменить email',
    LocaleKeys.securityEmailChanged: 'Email обновлён и подтверждён.',
    LocaleKeys.securityPhoneTitle: 'Смена телефона',
    LocaleKeys.securityChangePhoneAction: 'Подтвердить и сменить телефон',
    LocaleKeys.securityPhoneChanged: 'Телефон обновлён и подтверждён.',
    LocaleKeys.blockedUsersUnblock: 'Разблокировать',
    LocaleKeys.blockedUsersUnblocked: 'Пользователь разблокирован.',
    LocaleKeys.helpContactTitle: 'Контакты поддержки',
    LocaleKeys.helpContactBody:
        'По вопросам оплаты, споров или доступа к аккаунту пишите: oyin.support@gmail.com',
    LocaleKeys.helpFaqQ1: 'Как отправить результат спарринга?',
    LocaleKeys.helpFaqA1:
        'Откройте карточку матча, укажите счёт обоих игроков и отправьте. Результат подтвердится, когда обе стороны отправят одинаковый счёт.',
    LocaleKeys.helpFaqQ2: 'Что делать, если соперник указал другой счёт?',
    LocaleKeys.helpFaqA2:
        'Откройте спор на экране результата и приложите доказательства (видео/ссылку/комментарий). Итог решит голосование жюри.',
    LocaleKeys.helpFaqQ3: 'Как поменять телефон или email?',
    LocaleKeys.helpFaqA3:
        'Перейдите в Настройки → Пароль и безопасность и подтвердите изменение кодом.',
    LocaleKeys.helpFaqQ4: 'Почему не находятся новые соперники?',
    LocaleKeys.helpFaqA4:
        'Проверьте фильтры спарринга (расстояние/возраст), спортивные предпочтения и публичность профиля в настройках.',
    LocaleKeys.fairPlayRule1:
        'Отправляйте только правдивый результат матча, согласованный обоими спортсменами.',
    LocaleKeys.fairPlayRule2:
        'Соблюдайте подтверждённые время и место контракта, заранее предупреждайте об изменениях.',
    LocaleKeys.fairPlayRule3:
        'В спорах прикладывайте реальные доказательства и не подавайте ложные обвинения.',
    LocaleKeys.fairPlayRule4:
        'Оскорбления, угрозы, травля и язык ненависти запрещены.',
    LocaleKeys.fairPlayRule5:
        'Повторные нарушения снижают надёжность и могут ограничить доступ к аккаунту.',
    LocaleKeys.fairPlayPenaltyNote:
        'Модерация может сбросить результаты, выдать временные ограничения или заблокировать аккаунт за серьёзные нарушения.',
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
    LocaleKeys.tabDisputes: 'Споры',
    LocaleKeys.noDisputes: 'Споров пока нет',
    LocaleKeys.myDisputes: 'Мои споры',
    LocaleKeys.communityDisputes: 'Споры других',
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
        'Получите AI-советы по спорту и тренировкам.',
    LocaleKeys.aiOnline: 'Онлайн',
    LocaleKeys.aiOffline: 'Не в сети',
    LocaleKeys.aiMessageHint: 'Спросите что-нибудь о спорте...',
    LocaleKeys.aiWelcomeMessage:
        'Спросите меня о разминке, профилактике травм, технике или подготовке к матчу.',
    LocaleKeys.aiSuggestion1: 'Как размяться?',
    LocaleKeys.aiSuggestion2: 'Профилактика травм',
    LocaleKeys.aiSuggestion3: 'Подготовка к матчу',
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
    LocaleKeys.arenaMatching: 'Матчинг',
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
    LocaleKeys.authCredentialRegisterSubtitle:
        'Создайте аккаунт и заполните профиль спортсмена',
    LocaleKeys.authCredentialLoginSubtitle:
        'Вход в существующий аккаунт по логину и паролю',
    LocaleKeys.authCredentialOptional: '(необязательно)',
    LocaleKeys.authCredentialLoginLabel: 'Логин',
    LocaleKeys.authCredentialLoginHint: 'Почта или телефон',
    LocaleKeys.authCredentialPasswordLabel: 'Пароль',
    LocaleKeys.authCredentialConfirmPasswordLabel: 'Подтвердите пароль',
    LocaleKeys.authCredentialSwitchToLogin: 'Уже есть аккаунт? Войти',
    LocaleKeys.authCredentialSwitchToRegister: 'Нет аккаунта? Начать',
    LocaleKeys.authCredentialUseOtp: 'Войти через код подтверждения',
    LocaleKeys.authCredentialPasswordTooShort:
        'Пароль должен быть минимум 6 символов',
    LocaleKeys.authCredentialPasswordsMismatch: 'Пароли не совпадают',
    LocaleKeys.authCredentialLoginRequired: 'Введите логин и пароль',
    LocaleKeys.authCredentialEmailRegistered:
        'Этот email уже зарегистрирован. Используйте кнопку "Войти".',
    LocaleKeys.phoneNumber: 'Номер телефона',
    LocaleKeys.sendCode: 'Отправить код',
    LocaleKeys.phoneEntryTitle: 'Заходим на ринг.',
    LocaleKeys.phoneEntrySubtitle:
        'Укажи телефон, чтобы подтвердить аккаунт и найти спарринг-партнёров.',
    LocaleKeys.termsAgree:
        'Продолжая, вы соглашаетесь с Условиями и Политикой конфиденциальности.',
    LocaleKeys.verificationTitle: 'Введите код',
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
    LocaleKeys.messengerReportTargetLabel: 'Никнейм пользователя',
    LocaleKeys.messengerReportDescriptionTitle: 'Описание проблемы',
    LocaleKeys.messengerReportDescriptionHint:
        'Опишите проблему (максимум 500 символов)',
    LocaleKeys.messengerReportDescriptionRequired:
        'Опишите проблему перед отправкой.',
    LocaleKeys.messengerReportCounter: '{used}/{max} • Осталось: {left}',
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
    LocaleKeys.onboardingSportSelectionTitle: 'Чем занимаешься?',
    LocaleKeys.onboardingSportSelectionSubtitle:
        'Выбери все подходящие. Позже можно добавить ещё.',
    LocaleKeys.onboardingSportSelectionSearchHint:
        'Поиск дисциплин (например, Бокс, Падел)',
    LocaleKeys.onboardingSportSelectionInfo:
        'Каждый выбранный вид спорта создаст отдельный профиль для спарринга.',
    LocaleKeys.onboardingSportSelectionCreateProfiles: 'Выбрано видов: {count}',
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
    LocaleKeys.onboardingDetailsLocalProfileCreatedSuccess:
        'Локальный профиль сохранён. Подтверди телефон позже в профиле.',
    LocaleKeys.profileAvatarChooseGallery: 'Выбрать из галереи',
    LocaleKeys.profileAvatarTakePhoto: 'Сделать фото',
    LocaleKeys.profileVerifyPhoneTitle: 'Телефон не подтверждён',
    LocaleKeys.profileVerifyPhoneSubtitle:
        'Сейчас включён гостевой режим. Подтверди номер, чтобы открыть все онлайн-функции.',
    LocaleKeys.profileVerifyPhoneAction: 'Подтвердить телефон',
    LocaleKeys.authSkipForNow: 'Пропустить',
    LocaleKeys.authSkipDialogTitle: 'Продолжить без СМС?',
    LocaleKeys.authSkipDialogMessage:
        'Ты сможешь создать профиль сейчас и подтвердить номер позже в настройках профиля.',
    LocaleKeys.authSkipDialogConfirm: 'Продолжить без СМС',
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
    LocaleKeys.rankWithValue: 'Ранг {value}',
    LocaleKeys.sportBoxing: 'Бокс',
    LocaleKeys.sportMuayThai: 'Муай Тай',
    LocaleKeys.sportBjj: 'BJJ',
    LocaleKeys.sportTennis: 'Теннис',
    LocaleKeys.sportPadel: 'Падел',
    LocaleKeys.sportBasketball: 'Баскетбол',
    LocaleKeys.sportFootball: 'Футбол',
    LocaleKeys.sportWrestling: 'Борьба',
    LocaleKeys.sportSwimming: 'Плавание',
    LocaleKeys.sportRunning: 'Бег',
    LocaleKeys.sportMma: 'MMA',
    LocaleKeys.sportKickboxing: 'Кикбоксинг',
    LocaleKeys.sportVolleyball: 'Волейбол',
    LocaleKeys.sportTableTennis: 'Настольный теннис',
    LocaleKeys.skillTagStriking: 'Ударка',
    LocaleKeys.skillTagCardio: 'Кардио',
    LocaleKeys.skillTagEndurance: 'Выносливость',
    LocaleKeys.skillTagDefense: 'Защита',
    LocaleKeys.skillTagFootwork: 'Работа ног',
    LocaleKeys.skillTagServe: 'Подача',
    LocaleKeys.skillTagAgility: 'Ловкость',
    LocaleKeys.skillTagTechnique: 'Техника',
    LocaleKeys.skillTagSpeed: 'Скорость',
    LocaleKeys.skillTagClinch: 'Клинч',
    LocaleKeys.skillTagPower: 'Сила',
    LocaleKeys.skillTagStamina: 'Стамина',
    LocaleKeys.skillTagPace: 'Темп',
    LocaleKeys.skillTagPassing: 'Пасы',
    LocaleKeys.skillTagGrappling: 'Грэпплинг',
    LocaleKeys.skillTagSouthpaw: 'Левша',
    // Info modals
    LocaleKeys.infoChatTitle: 'Что делать',
    LocaleKeys.infoChatSubtitle: 'Что делать на этом экране',
    LocaleKeys.infoChatTip1:
        'Карточки с Action Required требуют вашего действия в первую очередь.',
    LocaleKeys.infoChatTip2:
        'Нажмите Resolve Dispute, чтобы перейти к открытому спору и проголосовать.',
    LocaleKeys.infoChatTip3:
        'Обычный тап по карточке открывает диалог с игроком.',
    LocaleKeys.infoAiSubtitle: 'Модуль готовится к запуску.',
    LocaleKeys.infoAiTip1:
        'Здесь будут рекомендации по подготовке к матчу и разборы споров.',
    LocaleKeys.infoAiTip2:
        'На первом этапе доступны подсказки по доказательствам и fair-play.',
    LocaleKeys.infoMatchSubtitle: 'Подсказки для быстрого матчинга',
    LocaleKeys.infoMatchTip1:
        'Используйте свайп вправо, если готовы договориться о тренировке.',
    LocaleKeys.infoMatchTip2:
        'Нажимайте на карточку инфо, чтобы посмотреть полный профиль игрока.',
    LocaleKeys.infoMatchTip3:
        'Меняйте фильтры по расстоянию и возрасту, если карточки закончились.',
    LocaleKeys.infoDisputeTitle: 'Как работает суд',
    LocaleKeys.infoDisputeSubtitle: 'Голосуйте только по доказательствам.',
    LocaleKeys.infoDisputeTip1:
        'Сначала смотрите видео и фото, потом читайте заявления сторон.',
    LocaleKeys.infoDisputeTip2:
        'Голос учитывается один раз и изменить его нельзя.',
    LocaleKeys.infoDisputeTip3:
        'После 3 совпадающих голосов спор закрывается автоматически.',
    LocaleKeys.infoResultTitle: 'Как отправить результат',
    LocaleKeys.infoResultSubtitle:
        'Финальный счёт должен подтвердиться обеими сторонами.',
    LocaleKeys.infoResultTip1:
        'Нажмите на карточку игрока и выберите его итоговый счёт.',
    LocaleKeys.infoResultTip2:
        'После отправки второй игрок должен отправить совпадающий результат.',
    LocaleKeys.infoResultTip3:
        'Если данные расходятся, открывайте спор через «В суд».',
    LocaleKeys.infoNextMatchTip1: 'Проверьте место и время встречи заранее.',
    LocaleKeys.infoNextMatchTip2:
        'Если планы изменились, предупредите соперника в чате.',
    LocaleKeys.infoNextMatchTip3:
        'После матча не забудьте отправить итоговый результат.',
    LocaleKeys.infoAuthTitle: 'Как начать',
    LocaleKeys.infoAuthSubtitle: 'Коротко про вход и старт в Oyin.',
    LocaleKeys.infoAuthTip1: 'Войдите по номеру телефона и коду подтверждения.',
    LocaleKeys.infoAuthTip2:
        'Заполните профиль, чтобы получать релевантные матчи.',
    LocaleKeys.infoAuthTip3:
        'После входа доступны поиск, челленджи и суд по спорам.',
    // Settings info
    LocaleKeys.settingsAuthSubtitle: 'Используется аутентификация по телефону.',
    LocaleKeys.settingsAuthTip1:
        'Ваш аккаунт защищён верификацией по телефону.',
    LocaleKeys.settingsAuthTip2:
        'Пароль не нужен — OTP-коды отправляются на ваш телефон.',
    LocaleKeys.settingsLinkedSubtitle: 'Привязанных аккаунтов пока нет.',
    LocaleKeys.settingsLinkedTip: 'Привязка соцсетей скоро появится.',
    LocaleKeys.settingsMatchSubtitle: 'Настройте параметры спарринга.',
    LocaleKeys.settingsMatchTip1:
        'Используйте фильтры матчей для настройки расстояния и возраста.',
    LocaleKeys.settingsMatchTip2:
        'Спортивные предпочтения можно изменить в профиле.',
    LocaleKeys.settingsBlockedSubtitle: 'Заблокированных пользователей нет.',
    LocaleKeys.settingsBlockedTip1: 'Заблокировать можно из экрана чата.',
    LocaleKeys.settingsBlockedTip2:
        'Заблокированные не могут отправлять сообщения и вызовы.',
    LocaleKeys.settingsHelpSubtitle: 'Нужна помощь?',
    LocaleKeys.settingsHelpTip1: 'Свяжитесь с поддержкой через чат или email.',
    LocaleKeys.settingsHelpTip2:
        'Загляните в FAQ для ответов на частые вопросы.',
    LocaleKeys.settingsFairPlaySubtitle: 'Честная игра — основа сообщества.',
    LocaleKeys.settingsFairPlayTip1:
        'Всегда указывайте точные результаты матчей.',
    LocaleKeys.settingsFairPlayTip2: 'Споры разрешаются голосованием жюри.',
    LocaleKeys.settingsFairPlayTip3:
        'Повторные ложные жалобы снижают рейтинг надёжности.',
    LocaleKeys.settingsFairPlayTip4: 'Высокая карма даёт бонусы в магазине.',
    // Notifications
    LocaleKeys.nameRequired: 'Имя обязательно',
    LocaleKeys.profileUpdated: 'Профиль обновлён',
    LocaleKeys.enterScoreBoth: 'Укажите счёт для обоих игроков.',
    LocaleKeys.resultConfirmed: 'Результат подтверждён. Матч завершён.',
    LocaleKeys.scoreConflict:
        'Счёт не совпал. Можно открыть спор через кнопку «{toCourt}».',
    LocaleKeys.resultSentWaiting:
        'Результат отправлен. Ждём подтверждение второго игрока.',
    LocaleKeys.disputeNotAvailable:
        'Спор можно открыть после статуса CONFLICT или если спор уже создан.',
    LocaleKeys.disputeNotAvailableTitle: 'Пока недоступно',
    LocaleKeys.addDisputeComment: 'Добавьте комментарий к спору.',
    LocaleKeys.validationTitle: 'Проверка',
    LocaleKeys.karmaDemo: '+50 карма (демо)',
    LocaleKeys.voteCountedDemo: 'Голос учтён (демо)',
    LocaleKeys.enterValidEmail: 'Введите корректный адрес электронной почты',
    LocaleKeys.itemPurchased: '{name} куплен!',
    LocaleKeys.coinsSent: '{coins} монет отправлено {name}',
    LocaleKeys.disputeHeader: 'Спор №{id}',
    LocaleKeys.disputeEvidence: 'Доказательства',
    LocaleKeys.disputeStatements: 'Заявления',
    LocaleKeys.disputeRolePlaintiff: 'Истец',
    LocaleKeys.disputeRoleDefendant: 'Ответчик',
    LocaleKeys.disputeDefendantFallback:
        'По моему мнению, решение было неверным.',
    LocaleKeys.disputeVoteAccepted: 'Ваш голос принят. Ждём финальный вердикт.',
    LocaleKeys.disputeVoteParticipantWait:
        'Вы участник спора. Ожидайте решение сообщества.',
    LocaleKeys.disputeRewardEarned: '+{karma} кармы получено',
    LocaleKeys.disputeRewardPending: '+{karma} кармы ожидается',
    LocaleKeys.disputeRewardReviewPrompt:
        'Изучите материалы объективно, чтобы получить награду.',
    LocaleKeys.disputeRewardFinalVerdict: 'Финальный вердикт: {winnerName}.',
    LocaleKeys.disputeResolvedFinalVerdict: 'Финальный вердикт',
    LocaleKeys.disputeResolvedWinner: '{winnerName} победил',
    LocaleKeys.disputeResolvedRatingImpact:
        'Изменение рейтинга: {player1Before} -> {player1After} | {player2Before} -> {player2After}',
    LocaleKeys.disputeWinnerCommunity: 'Сообщество',
    // Buttons
    LocaleKeys.save: 'Сохранить',
    LocaleKeys.sendToCourt: 'Отправить в суд',
    LocaleKeys.noEvidence: 'Доказательства не прикреплены',
    LocaleKeys.retry: 'Повторить',
    LocaleKeys.refresh: 'Обновить',
    LocaleKeys.voteFor: 'За {name}',
    LocaleKeys.cannotDetermine: 'Невозможно определить / Ничья',
    LocaleKeys.returnToDashboard: 'Вернуться на главную',
    LocaleKeys.ok: 'OK',
    LocaleKeys.pickScore: 'Выберите счёт',
    LocaleKeys.statusWin: 'ПОБЕДА',
    LocaleKeys.statusLoss: 'ПОРАЖЕНИЕ',
    LocaleKeys.draw: 'Ничья',
    LocaleKeys.statusPendingResult: 'В ОЖИДАНИИ',
    LocaleKeys.statusConflict: 'Конфликт',
    LocaleKeys.statusDispute: 'Спор',
    LocaleKeys.coinsLabel: 'монет',
    // Form labels
    LocaleKeys.disputeCommentLabel: 'Комментарий к спору *',
    LocaleKeys.plaintiffStatementLabel: 'Заявление истца (необязательно)',
    LocaleKeys.defendantStatementLabel: 'Заявление ответчика (необязательно)',
    LocaleKeys.evidenceLinkLabel:
        'Ссылка на видео/фото доказательства (необязательно)',
    LocaleKeys.openDispute: 'Открыть спор',
    LocaleKeys.disputeLoadFailed: 'Не удалось загрузить спор',
    LocaleKeys.noActiveDisputes: 'Нет активных споров',
    LocaleKeys.noActiveDisputesDesc:
        'Когда спор будет открыт, он появится здесь для рассмотрения.',
    LocaleKeys.disputeEvidenceScreenTitle: 'Доказательства спора',
    LocaleKeys.disputeEvidenceProvideDetailsTitle: 'Укажите детали',
    LocaleKeys.disputeEvidenceProvideDetailsHint:
        'Опишите ситуацию максимально ясно и добавьте доказательства для честного рассмотрения.',
    LocaleKeys.disputeEvidenceDescriptionLabel: 'Описание событий',
    LocaleKeys.disputeEvidenceDescriptionHint:
        'Опишите, что произошло во время сессии...',
    LocaleKeys.disputeEvidenceVideoTitle: 'Видео-доказательство',
    LocaleKeys.disputeEvidenceTapUpload: 'Нажмите, чтобы загрузить видео',
    LocaleKeys.disputeEvidenceVideoHint: 'MP4, MOV до 100MB',
    LocaleKeys.disputeEvidenceOrLink: 'ИЛИ ДОБАВЬТЕ ССЫЛКУ',
    LocaleKeys.disputeEvidenceUrlLabel: 'Ссылка на видео',
    LocaleKeys.disputeEvidenceUrlHint: 'например, ссылка YouTube или Vimeo',
    LocaleKeys.disputeEvidenceSubmit: 'Отправить доказательства',
    LocaleKeys.disputeEvidenceFootnote:
        'После отправки доказательства нельзя изменить.',
    LocaleKeys.disputeEvidenceDescriptionRequired:
        'Добавьте описание инцидента.',
    LocaleKeys.disputeEvidenceRequired:
        'Прикрепите видео-доказательство или добавьте ссылку.',
    LocaleKeys.disputeEvidenceUploadFailed:
        'Не удалось загрузить видео-доказательство. Попробуйте снова.',
    LocaleKeys.contractSetupTitle: 'Новый контракт на спарринг',
    LocaleKeys.contractProgressTitle: 'Прогресс',
    LocaleKeys.contractStepContract: '1. Контракт',
    LocaleKeys.contractStepResult: '2. Результат',
    LocaleKeys.contractLockedHint:
        'Контракт подтвержден и зафиксирован. Дату, время и локацию изменить нельзя.',
    LocaleKeys.contractLogistics: 'Логистика',
    LocaleKeys.contractDateLabel: 'Дата',
    LocaleKeys.contractTimeLabel: 'Время',
    LocaleKeys.contractDatePlaceholder: 'Выберите дату',
    LocaleKeys.contractTimePlaceholder: 'Выберите время',
    LocaleKeys.contractLocationLabel: 'Локация',
    LocaleKeys.contractLocationHint: 'City Gym, Brooklyn',
    LocaleKeys.contractNotificationsTitle: 'Уведомления',
    LocaleKeys.contractReminderToggle: 'Напоминание перед началом',
    LocaleKeys.contractAgreementStatusTitle: 'Статус соглашения',
    LocaleKeys.contractAgreementYou: 'Вы',
    LocaleKeys.contractAgreementYouStatusPending: 'Готов подписать',
    LocaleKeys.contractAgreementYouStatusLocked: 'Подписано',
    LocaleKeys.contractAgreementOpponent: 'Оппонент',
    LocaleKeys.contractAgreementOpponentStatus: 'Ожидает подписи...',
    LocaleKeys.contractCodeOfConduct:
        'Я согласен с кодексом спарринга и политикой разрешения споров.',
    LocaleKeys.contractProposeButton: 'Отправить контракт',
    LocaleKeys.contractSaved: 'Контракт сохранен. Данные зафиксированы.',
    LocaleKeys.contractRequiredDate: 'Выберите дату и время спарринга.',
    LocaleKeys.contractRequiredLocation: 'Укажите локацию спарринга.',
    LocaleKeys.contractAgreementRequired:
        'Подтвердите согласие с кодексом поведения.',
    LocaleKeys.contractOpenButton: 'Создать контракт',
    LocaleKeys.contractViewDetailsButton: 'Посмотреть утвержденный контракт',
    LocaleKeys.contractRequiredBeforeResult:
        'Сначала создайте и подтвердите контракт. Затем доступны результат/суд.',
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
    LocaleKeys.leagueBronze: 'Қола лига',
    LocaleKeys.leagueSilver: 'Күміс лига',
    LocaleKeys.leaguePlatinum: 'Платина лига',
    LocaleKeys.leagueDiamond: 'Алмаз лига',
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
    LocaleKeys.availabilityLocation: 'Локация',
    LocaleKeys.availabilityLocationHint: 'Қаланы енгізіңіз (мысалы, Алматы)',
    LocaleKeys.availabilityWeeklySchedule: 'Апталық кесте',
    LocaleKeys.availabilitySelectAll: 'Барлығын таңдау',
    LocaleKeys.availabilityWeekdays: 'Жұмыс күндері',
    LocaleKeys.availabilityWeekends: 'Демалыс күндері',
    LocaleKeys.availabilityTimeMorning: 'Таң',
    LocaleKeys.availabilityTimeDay: 'Күндіз',
    LocaleKeys.availabilityTimeEvening: 'Кеш',
    LocaleKeys.availabilityDayMon: 'Дс',
    LocaleKeys.availabilityDayTue: 'Сс',
    LocaleKeys.availabilityDayWed: 'Ср',
    LocaleKeys.availabilityDayThu: 'Бс',
    LocaleKeys.availabilityDayFri: 'Жм',
    LocaleKeys.availabilityDaySat: 'Сб',
    LocaleKeys.availabilityDaySun: 'Жс',
    LocaleKeys.availabilitySupportInfo: 'Қолдау және ақпарат',
    LocaleKeys.availabilityHelpFaq: 'Көмек / FAQ',
    LocaleKeys.aboutUs: 'Біз туралы',
    LocaleKeys.availabilityFindPartners: 'Серіктес табу',
    LocaleKeys.availabilitySaved: 'Қолжетімділік сақталды',
    LocaleKeys.availabilityLoadFailed: 'Қолжетімділікті жүктеу мүмкін болмады',
    LocaleKeys.availabilityProfileRequired:
        'Кестені сақтау үшін алдымен спорт профилін жасаңыз.',
    LocaleKeys.sportPreferences: 'Спорт қалаулары',
    LocaleKeys.sportPreferencesDesc: 'Бокс, муай тай, BJJ',
    LocaleKeys.matchHistory: 'Жекпе-жек тарихы',
    LocaleKeys.matchHistoryDesc: 'Өткен спаррингтер мен даулар',
    LocaleKeys.searchSettingsPlaceholder: 'Баптаулар, даулар, құпиялылық...',
    LocaleKeys.account: 'Аккаунт',
    LocaleKeys.personalInfo: 'Жеке деректер',
    LocaleKeys.passwordSecurity: 'Қауіпсіздік',
    LocaleKeys.linkedAccounts: 'Байланған аккаунттар',
    LocaleKeys.accountOverviewTitle: 'Аккаунт картасы',
    LocaleKeys.accountOverviewContacts: 'Байланыс және верификация',
    LocaleKeys.accountOverviewSports: 'Спорт, деңгей және дағдылар',
    LocaleKeys.accountOverviewNoSports: 'Спорттық қалаулар әлі толтырылмаған.',
    LocaleKeys.accountOverviewAvailability: 'Менің қолжетімділігім',
    LocaleKeys.accountOverviewNoAvailability: 'Қолжетімділік әлі бапталмаған.',
    LocaleKeys.accountOverviewStatistics: 'Спарринг статистикасы',
    LocaleKeys.accountOverviewNoStats: 'Аяқталған спаррингтер әлі жоқ.',
    LocaleKeys.accountOverviewBirthDate: 'Туған күні',
    LocaleKeys.accountOverviewExperienceYears: 'Тәжірибе (жыл)',
    LocaleKeys.accountOverviewWinRate: 'Жеңіс пайызы',
    LocaleKeys.accountOverviewWins: 'Жеңіс',
    LocaleKeys.accountOverviewLosses: 'Жеңіліс',
    LocaleKeys.accountOverviewDraws: 'Тең ойын',
    LocaleKeys.notSet: 'Көрсетілмеген',
    LocaleKeys.commonYes: 'Иә',
    LocaleKeys.commonNo: 'Жоқ',
    LocaleKeys.verified: 'Расталған',
    LocaleKeys.notVerified: 'Расталмаған',
    LocaleKeys.securityContactsTitle: 'Қалпына келтіру байланыстары',
    LocaleKeys.securityPasswordTitle: 'Құпиясөзді өзгерту',
    LocaleKeys.securityPasswordSubtitle:
        'Ағымдағы құпиясөзді немесе email/телефон коды арқылы растауды қолданыңыз.',
    LocaleKeys.securityCurrentPasswordOptional:
        'Ағымдағы құпиясөз (міндетті емес)',
    LocaleKeys.securityNewPassword: 'Жаңа құпиясөз',
    LocaleKeys.securityConfirmPassword: 'Жаңа құпиясөзді растау',
    LocaleKeys.securityVerificationMethod: 'Растау тәсілі',
    LocaleKeys.securityChangePasswordAction: 'Құпиясөзді жаңарту',
    LocaleKeys.securityNoVerificationChannel:
        'Растау үшін email немесе телефон таңдаңыз.',
    LocaleKeys.securityPhoneNotSet: 'Телефон нөмірі көрсетілмеген.',
    LocaleKeys.securityCodeSent: 'Растау коды жіберілді.',
    LocaleKeys.securityCodeRequired: 'Растау кодын енгізіңіз.',
    LocaleKeys.securityPasswordChanged: 'Құпиясөз сәтті жаңартылды.',
    LocaleKeys.securityEmailTitle: 'Email өзгерту',
    LocaleKeys.securityChangeEmailAction: 'Email-ды растау және өзгерту',
    LocaleKeys.securityEmailChanged: 'Email жаңартылды және расталды.',
    LocaleKeys.securityPhoneTitle: 'Телефон өзгерту',
    LocaleKeys.securityChangePhoneAction: 'Телефонды растау және өзгерту',
    LocaleKeys.securityPhoneChanged: 'Телефон жаңартылды және расталды.',
    LocaleKeys.blockedUsersUnblock: 'Бұғаттан шығару',
    LocaleKeys.blockedUsersUnblocked: 'Пайдаланушы бұғаттан шығарылды.',
    LocaleKeys.helpContactTitle: 'Қолдау байланысы',
    LocaleKeys.helpContactBody:
        'Төлем, дау немесе аккаунтқа кіру мәселелері бойынша жазыңыз: oyin.support@gmail.com',
    LocaleKeys.helpFaqQ1: 'Спарринг нәтижесін қалай жіберемін?',
    LocaleKeys.helpFaqA1:
        'Матч карточкасын ашып, екі ойыншының есебін енгізіп жіберіңіз. Екі тарап бірдей есеп жібергенде нәтиже расталады.',
    LocaleKeys.helpFaqQ2: 'Қарсылас басқа есеп жіберсе не істеймін?',
    LocaleKeys.helpFaqA2:
        'Нәтиже экранынан дау ашып, дәлел қосыңыз (видео/сілтеме/пікір). Соңғы шешімді қазылар дауыс беруі шығарады.',
    LocaleKeys.helpFaqQ3: 'Телефонды немесе email-ды қалай ауыстырамын?',
    LocaleKeys.helpFaqA3:
        'Баптаулар → Қауіпсіздік бөліміне өтіп, өзгерісті OTP кодпен растаңыз.',
    LocaleKeys.helpFaqQ4: 'Неге жаңа қарсыластар табылмайды?',
    LocaleKeys.helpFaqA4:
        'Баптаулардан спарринг фильтрлерін (қашықтық/жас), спорт қалауларын және профильдің ашықтығын тексеріңіз.',
    LocaleKeys.fairPlayRule1:
        'Екі спортшы келіскен матч нәтижесін ғана шынайы түрде жіберіңіз.',
    LocaleKeys.fairPlayRule2:
        'Расталған келісімшарттағы уақыт пен орынды сақтаңыз, өзгеріс болса алдын ала хабарлаңыз.',
    LocaleKeys.fairPlayRule3:
        'Дауда нақты дәлел беріңіз және жалған айып тағудан аулақ болыңыз.',
    LocaleKeys.fairPlayRule4:
        'Қорлау, қоқан-лоқы, буллинг және өшпенділік тіліне тыйым салынады.',
    LocaleKeys.fairPlayRule5:
        'Қайталанатын бұзушылық сенімділік рейтингін төмендетіп, аккаунтқа шектеу әкелуі мүмкін.',
    LocaleKeys.fairPlayPenaltyNote:
        'Модерация нәтижені жоя алады, уақытша шектеу қоя алады немесе ауыр бұзушылық үшін аккаунтты тоқтата алады.',
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
    LocaleKeys.tabDisputes: 'Даулар',
    LocaleKeys.noDisputes: 'Даулар әлі жоқ',
    LocaleKeys.myDisputes: 'Менің дауларым',
    LocaleKeys.communityDisputes: 'Басқалардың даулары',
    LocaleKeys.actionRequired: 'Әрекет қажет',
    LocaleKeys.upcoming: 'Жақында',
    LocaleKeys.resolveDispute: 'Дауды шешу',
    LocaleKeys.viewProposal: 'Ұсынысты қарау',
    LocaleKeys.contractSigned: 'КЕЛІСІМШАРТ ҚОЛ ҚОЙЫЛДЫ',
    LocaleKeys.draftingContract: 'КЕЛІСІМШАРТ ДАЙЫНДАЛУДА',
    LocaleKeys.matched: 'Матч! Жоспарлау үшін жазыңыз.',
    LocaleKeys.aiAssistant: 'AI-ассистент',
    LocaleKeys.aiComingSoon: 'Жақында',
    LocaleKeys.aiAssistantSubtitle: 'Спорт бойынша AI-кеңестер алыңыз.',
    LocaleKeys.aiOnline: 'Онлайн',
    LocaleKeys.aiOffline: 'Офлайн',
    LocaleKeys.aiMessageHint: 'Спорт туралы сұрақ қойыңыз...',
    LocaleKeys.aiWelcomeMessage:
        'Жаттығу, жарақаттанудың алдын алу, техника немесе матчқа дайындық туралы сұраңыз.',
    LocaleKeys.aiSuggestion1: 'Қалай жылыну керек?',
    LocaleKeys.aiSuggestion2: 'Жарақаттанудың алдын алу',
    LocaleKeys.aiSuggestion3: 'Матчқа дайындық',
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
    LocaleKeys.arenaMatching: 'Матчинг',
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
    LocaleKeys.authCredentialRegisterSubtitle:
        'Аккаунт ашып, спортшы профилін толтырыңыз',
    LocaleKeys.authCredentialLoginSubtitle:
        'Бар аккаунтқа логин мен құпиясөз арқылы кіріңіз',
    LocaleKeys.authCredentialOptional: '(міндетті емес)',
    LocaleKeys.authCredentialLoginLabel: 'Логин',
    LocaleKeys.authCredentialLoginHint: 'Email немесе телефон',
    LocaleKeys.authCredentialPasswordLabel: 'Құпиясөз',
    LocaleKeys.authCredentialConfirmPasswordLabel: 'Құпиясөзді растаңыз',
    LocaleKeys.authCredentialSwitchToLogin: 'Аккаунтыңыз бар ма? Кіру',
    LocaleKeys.authCredentialSwitchToRegister: 'Аккаунт жоқ па? Бастау',
    LocaleKeys.authCredentialUseOtp: 'Растау коды арқылы кіру',
    LocaleKeys.authCredentialPasswordTooShort:
        'Құпиясөз кемінде 6 таңбадан тұруы керек',
    LocaleKeys.authCredentialPasswordsMismatch: 'Құпиясөздер сәйкес келмейді',
    LocaleKeys.authCredentialLoginRequired: 'Логин мен құпиясөзді енгізіңіз',
    LocaleKeys.authCredentialEmailRegistered:
        'Бұл email әлдеқашан тіркелген. "Кіру" батырмасын пайдаланыңыз.',
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
    LocaleKeys.messengerReportTargetLabel: 'Пайдаланушы никнеймі',
    LocaleKeys.messengerReportDescriptionTitle: 'Мәселе сипаттамасы',
    LocaleKeys.messengerReportDescriptionHint:
        'Мәселені сипаттаңыз (ең көбі 500 таңба)',
    LocaleKeys.messengerReportDescriptionRequired:
        'Жібермес бұрын мәселені сипаттаңыз.',
    LocaleKeys.messengerReportCounter: '{used}/{max} • Қалды: {left}',
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
    LocaleKeys.onboardingDetailsLocalProfileCreatedSuccess:
        'Жергілікті профиль сақталды. Телефонды кейін Профильде раста.',
    LocaleKeys.profileAvatarChooseGallery: 'Галереядан таңдау',
    LocaleKeys.profileAvatarTakePhoto: 'Фото түсіру',
    LocaleKeys.profileVerifyPhoneTitle: 'Телефон расталмаған',
    LocaleKeys.profileVerifyPhoneSubtitle:
        'Қазір қонақ режимі қосулы. Барлық онлайн мүмкіндіктер үшін нөмірді раста.',
    LocaleKeys.profileVerifyPhoneAction: 'Телефонды растау',
    LocaleKeys.authSkipForNow: 'Қазір өткізу',
    LocaleKeys.authSkipDialogTitle: 'SMS-сыз жалғастыру керек пе?',
    LocaleKeys.authSkipDialogMessage:
        'Профильді қазір толтыра аласың, телефонды кейін профиль баптауларында растайсың.',
    LocaleKeys.authSkipDialogConfirm: 'SMS-сыз жалғастыру',
    LocaleKeys.sportPreferencesSearchHint: 'Спорт түрлерін іздеу',
    LocaleKeys.sportPreferencesLevelLabel: 'Деңгей',
    LocaleKeys.sportPreferencesExperienceHint: 'Тәжірибе (жыл)',
    LocaleKeys.sportPreferencesAddSkillHint: 'Дағды тегін қосу',
    LocaleKeys.sportPreferencesSave: 'Сақтау',
    LocaleKeys.sportPreferencesSaving: 'Сақталуда...',
    LocaleKeys.sportPreferencesSelectAtLeastOne:
        'Кемінде бір спорт түрін таңдаңыз.',
    LocaleKeys.sportPreferencesUpdatedSuccess: 'Спорт баптаулары жаңартылды',
    LocaleKeys.rankWithValue: 'Дәреже {value}',
    LocaleKeys.sportBoxing: 'Бокс',
    LocaleKeys.sportMuayThai: 'Муай Тай',
    LocaleKeys.sportBjj: 'BJJ',
    LocaleKeys.sportTennis: 'Теннис',
    LocaleKeys.sportPadel: 'Падел',
    LocaleKeys.sportBasketball: 'Баскетбол',
    LocaleKeys.sportFootball: 'Футбол',
    LocaleKeys.sportWrestling: 'Күрес',
    LocaleKeys.sportSwimming: 'Жүзу',
    LocaleKeys.sportRunning: 'Жүгіру',
    LocaleKeys.sportMma: 'MMA',
    LocaleKeys.sportKickboxing: 'Кикбоксинг',
    LocaleKeys.sportVolleyball: 'Волейбол',
    LocaleKeys.sportTableTennis: 'Үстел теннисі',
    LocaleKeys.skillTagStriking: 'Соққы техникасы',
    LocaleKeys.skillTagCardio: 'Кардио',
    LocaleKeys.skillTagEndurance: 'Төзімділік',
    LocaleKeys.skillTagDefense: 'Қорғаныс',
    LocaleKeys.skillTagFootwork: 'Аяқ жұмысы',
    LocaleKeys.skillTagServe: 'Доп беру',
    LocaleKeys.skillTagAgility: 'Шапшаңдық',
    LocaleKeys.skillTagTechnique: 'Техника',
    LocaleKeys.skillTagSpeed: 'Жылдамдық',
    LocaleKeys.skillTagClinch: 'Клинч',
    LocaleKeys.skillTagPower: 'Күш',
    LocaleKeys.skillTagStamina: 'Стамина',
    LocaleKeys.skillTagPace: 'Қарқын',
    LocaleKeys.skillTagPassing: 'Пас беру',
    LocaleKeys.skillTagGrappling: 'Грэпплинг',
    LocaleKeys.skillTagSouthpaw: 'Солақай',
    // Info modals
    LocaleKeys.infoChatTitle: 'Не істеу керек',
    LocaleKeys.infoChatSubtitle: 'Бұл экранда не істеу керек',
    LocaleKeys.infoChatTip1:
        'Action Required карточкалары алдымен сіздің назарыңызды қажет етеді.',
    LocaleKeys.infoChatTip2:
        'Resolve Dispute басып ашық дауға өтіп дауыс беріңіз.',
    LocaleKeys.infoChatTip3: 'Карточканы басып ойыншымен чат ашыңыз.',
    LocaleKeys.infoAiSubtitle: 'Модуль іске қосуға дайындалуда.',
    LocaleKeys.infoAiTip1:
        'Матчқа дайындық бойынша ұсыныстар мен дау талдаулар мұнда болады.',
    LocaleKeys.infoAiTip2:
        'Алғашқы кезеңде дәлелдемелер мен fair-play кеңестері қолжетімді.',
    LocaleKeys.infoMatchSubtitle: 'Жылдам матчинг кеңестері',
    LocaleKeys.infoMatchTip1:
        'Жаттығу ұйымдастыруға дайын болсаңыз оңға сырғытыңыз.',
    LocaleKeys.infoMatchTip2:
        'Ойыншының толық профилін көру үшін инфо карточкасын басыңыз.',
    LocaleKeys.infoMatchTip3:
        'Карточкалар біткенде қашықтық пен жас фильтрлерін өзгертіңіз.',
    LocaleKeys.infoDisputeTitle: 'Сот қалай жұмыс істейді',
    LocaleKeys.infoDisputeSubtitle: 'Тек дәлелдемелер бойынша дауыс беріңіз.',
    LocaleKeys.infoDisputeTip1:
        'Алдымен бейне мен фотоларды қараңыз, содан кейін мәлімдемелерді оқыңыз.',
    LocaleKeys.infoDisputeTip2:
        'Дауысыңыз бір рет есептеледі және өзгертуге болмайды.',
    LocaleKeys.infoDisputeTip3:
        '3 сәйкес дауыстан кейін дау автоматты түрде жабылады.',
    LocaleKeys.infoResultTitle: 'Нәтижені қалай жіберу',
    LocaleKeys.infoResultSubtitle: 'Соңғы есеп екі тарап бекітуі керек.',
    LocaleKeys.infoResultTip1:
        'Ойыншы карточкасын басып оның соңғы есебін таңдаңыз.',
    LocaleKeys.infoResultTip2:
        'Жібергеннен кейін екінші ойыншы сәйкес нәтиже жіберуі керек.',
    LocaleKeys.infoResultTip3:
        'Деректер сәйкес келмесе «Сотқа» арқылы дау ашыңыз.',
    LocaleKeys.infoNextMatchTip1:
        'Кездесу орны мен уақытын алдын ала тексеріңіз.',
    LocaleKeys.infoNextMatchTip2:
        'Жоспар өзгерсе, қарсыласыңызды чатта ескертіңіз.',
    LocaleKeys.infoNextMatchTip3:
        'Матчтан кейін соңғы нәтижені жіберуді ұмытпаңыз.',
    LocaleKeys.infoAuthTitle: 'Қалай бастау',
    LocaleKeys.infoAuthSubtitle: 'Oyin-ға кіру және бастау туралы қысқаша.',
    LocaleKeys.infoAuthTip1: 'Телефон нөмірі мен растау коды арқылы кіріңіз.',
    LocaleKeys.infoAuthTip2: 'Сәйкес матчтар алу үшін профиліңізді толтырыңыз.',
    LocaleKeys.infoAuthTip3:
        'Кіргеннен кейін іздеу, челленджер мен дау соты қолжетімді.',
    // Settings info
    LocaleKeys.settingsAuthSubtitle:
        'Телефон арқылы аутентификация қолданылады.',
    LocaleKeys.settingsAuthTip1:
        'Аккаунтыңыз телефон верификациясымен қорғалған.',
    LocaleKeys.settingsAuthTip2:
        'Құпиясөз қажет емес — OTP кодтар телефоныңызға жіберіледі.',
    LocaleKeys.settingsLinkedSubtitle: 'Байланысқан аккаунттар жоқ.',
    LocaleKeys.settingsLinkedTip:
        'Әлеуметтік желі байланысы жақында қолжетімді болады.',
    LocaleKeys.settingsMatchSubtitle: 'Спарринг баптауларын конфигурациялаңыз.',
    LocaleKeys.settingsMatchTip1:
        'Қашықтық пен жас диапазонын орнату үшін матч фильтрлерін пайдаланыңыз.',
    LocaleKeys.settingsMatchTip2:
        'Спорт баптауларын профильде өзгертуге болады.',
    LocaleKeys.settingsBlockedSubtitle: 'Бұғатталған пайдаланушылар жоқ.',
    LocaleKeys.settingsBlockedTip1:
        'Чат экранынан пайдаланушыларды бұғаттай аласыз.',
    LocaleKeys.settingsBlockedTip2:
        'Бұғатталған пайдаланушылар хабарлама мен челлендж жібере алмайды.',
    LocaleKeys.settingsHelpSubtitle: 'Көмек қажет пе?',
    LocaleKeys.settingsHelpTip1:
        'Чат немесе email арқылы қолдау қызметіне хабарласыңыз.',
    LocaleKeys.settingsHelpTip2:
        'Жиі қойылатын сұрақтар үшін FAQ бөлімін қараңыз.',
    LocaleKeys.settingsFairPlaySubtitle: 'Әділ ойын қоғамдастықтың негізі.',
    LocaleKeys.settingsFairPlayTip1: 'Матч нәтижелерін дәл көрсетіңіз.',
    LocaleKeys.settingsFairPlayTip2:
        'Даулар қауымдастық қазылар дауысымен шешіледі.',
    LocaleKeys.settingsFairPlayTip3:
        'Қайталанатын жалған шағымдар сенімділік рейтингін төмендетеді.',
    LocaleKeys.settingsFairPlayTip4: 'Жоғары карма дүкенде бонустар береді.',
    // Notifications
    LocaleKeys.nameRequired: 'Аты міндетті',
    LocaleKeys.profileUpdated: 'Профиль жаңартылды',
    LocaleKeys.enterScoreBoth: 'Екі ойыншы үшін есепті көрсетіңіз.',
    LocaleKeys.resultConfirmed: 'Нәтиже расталды. Матч аяқталды.',
    LocaleKeys.scoreConflict:
        'Есеп сәйкес келмеді. «{toCourt}» арқылы дау ашуға болады.',
    LocaleKeys.resultSentWaiting:
        'Нәтиже жіберілді. Екінші ойыншының растауын күтеміз.',
    LocaleKeys.disputeNotAvailable:
        'CONFLICT мәртебесінен кейін немесе дау жасалған болса дау ашуға болады.',
    LocaleKeys.disputeNotAvailableTitle: 'Әлі қолжетімді емес',
    LocaleKeys.addDisputeComment: 'Дауға пікір қосыңыз.',
    LocaleKeys.validationTitle: 'Тексеру',
    LocaleKeys.karmaDemo: '+50 карма (демо)',
    LocaleKeys.voteCountedDemo: 'Дауыс есептелді (демо)',
    LocaleKeys.enterValidEmail:
        'Жарамды электрондық пошта мекенжайын енгізіңіз',
    LocaleKeys.itemPurchased: '{name} сатып алынды!',
    LocaleKeys.coinsSent: '{coins} монета {name} жіберілді',
    LocaleKeys.disputeHeader: 'Дау №{id}',
    LocaleKeys.disputeEvidence: 'Дәлелдер',
    LocaleKeys.disputeStatements: 'Мәлімдемелер',
    LocaleKeys.disputeRolePlaintiff: 'Талапкер',
    LocaleKeys.disputeRoleDefendant: 'Жауапкер',
    LocaleKeys.disputeDefendantFallback: 'Менің ойымша, шешім қате болды.',
    LocaleKeys.disputeVoteAccepted:
        'Дауысыңыз қабылданды. Соңғы шешімді күтіңіз.',
    LocaleKeys.disputeVoteParticipantWait:
        'Сіз осы даудың қатысушысысыз. Қауымдастық шешімін күтіңіз.',
    LocaleKeys.disputeRewardEarned: '+{karma} карма алдыңыз',
    LocaleKeys.disputeRewardPending: '+{karma} карма күтілуде',
    LocaleKeys.disputeRewardReviewPrompt:
        'Сыйақы алу үшін материалдарды бейтарап қарап шығыңыз.',
    LocaleKeys.disputeRewardFinalVerdict: 'Қорытынды шешім: {winnerName}.',
    LocaleKeys.disputeResolvedFinalVerdict: 'Қорытынды шешім',
    LocaleKeys.disputeResolvedWinner: '{winnerName} жеңді',
    LocaleKeys.disputeResolvedRatingImpact:
        'Рейтинг өзгерісі: {player1Before} -> {player1After} | {player2Before} -> {player2After}',
    LocaleKeys.disputeWinnerCommunity: 'Қауымдастық',
    // Buttons
    LocaleKeys.save: 'Сақтау',
    LocaleKeys.sendToCourt: 'Сотқа жіберу',
    LocaleKeys.noEvidence: 'Дәлелдемелер тіркелмеген',
    LocaleKeys.retry: 'Қайталау',
    LocaleKeys.refresh: 'Жаңарту',
    LocaleKeys.voteFor: '{name} үшін',
    LocaleKeys.cannotDetermine: 'Анықтау мүмкін емес / Тең',
    LocaleKeys.returnToDashboard: 'Басты бетке оралу',
    LocaleKeys.ok: 'OK',
    LocaleKeys.pickScore: 'Есепті таңдаңыз',
    LocaleKeys.statusWin: 'ЖЕҢІС',
    LocaleKeys.statusLoss: 'ЖЕҢІЛІС',
    LocaleKeys.draw: 'Тең',
    LocaleKeys.statusPendingResult: 'КҮТІЛУДЕ',
    LocaleKeys.statusConflict: 'Қақтығыс',
    LocaleKeys.statusDispute: 'Дау',
    LocaleKeys.coinsLabel: 'монета',
    // Form labels
    LocaleKeys.disputeCommentLabel: 'Дауға пікір *',
    LocaleKeys.plaintiffStatementLabel: 'Талапкер мәлімдемесі (міндетті емес)',
    LocaleKeys.defendantStatementLabel: 'Жауапкер мәлімдемесі (міндетті емес)',
    LocaleKeys.evidenceLinkLabel:
        'Бейне/фото дәлелдемелерге сілтеме (міндетті емес)',
    LocaleKeys.openDispute: 'Дау ашу',
    LocaleKeys.disputeLoadFailed: 'Дауды жүктеу мүмкін болмады',
    LocaleKeys.noActiveDisputes: 'Белсенді даулар жоқ',
    LocaleKeys.noActiveDisputesDesc:
        'Дау ашылғанда, ол мұнда қарау үшін пайда болады.',
    LocaleKeys.disputeEvidenceScreenTitle: 'Дау дәлелдері',
    LocaleKeys.disputeEvidenceProvideDetailsTitle: 'Мәлімет беріңіз',
    LocaleKeys.disputeEvidenceProvideDetailsHint:
        'Оқиғаны анық сипаттап, әділ қарау үшін дәлелдерді тіркеңіз.',
    LocaleKeys.disputeEvidenceDescriptionLabel: 'Оқиға сипаттамасы',
    LocaleKeys.disputeEvidenceDescriptionHint:
        'Сессия кезінде не болғанын сипаттаңыз...',
    LocaleKeys.disputeEvidenceVideoTitle: 'Видео дәлел',
    LocaleKeys.disputeEvidenceTapUpload: 'Видеоны жүктеу үшін басыңыз',
    LocaleKeys.disputeEvidenceVideoHint: 'MP4, MOV 100MB дейін',
    LocaleKeys.disputeEvidenceOrLink: 'НЕМЕСЕ СІЛТЕМЕ ҚОСЫҢЫЗ',
    LocaleKeys.disputeEvidenceUrlLabel: 'Видео сілтемесі',
    LocaleKeys.disputeEvidenceUrlHint: 'мысалы, YouTube немесе Vimeo сілтемесі',
    LocaleKeys.disputeEvidenceSubmit: 'Дәлелдерді жіберу',
    LocaleKeys.disputeEvidenceFootnote:
        'Жіберілгеннен кейін дәлелдерді өзгертуге болмайды.',
    LocaleKeys.disputeEvidenceDescriptionRequired:
        'Инцидент сипаттамасын қосыңыз.',
    LocaleKeys.disputeEvidenceRequired:
        'Видео дәлел тіркеңіз немесе сілтеме қосыңыз.',
    LocaleKeys.disputeEvidenceUploadFailed:
        'Видео дәлелді жүктеу мүмкін болмады. Қайта көріңіз.',
    LocaleKeys.contractSetupTitle: 'Жаңа спарринг келісімшарты',
    LocaleKeys.contractProgressTitle: 'Прогресс',
    LocaleKeys.contractStepContract: '1. Келісімшарт',
    LocaleKeys.contractStepResult: '2. Нәтиже',
    LocaleKeys.contractLockedHint:
        'Келісімшарт бекітілді және құлыпталды. Күн, уақыт, орын өзгертілмейді.',
    LocaleKeys.contractLogistics: 'Логистика',
    LocaleKeys.contractDateLabel: 'Күні',
    LocaleKeys.contractTimeLabel: 'Уақыты',
    LocaleKeys.contractDatePlaceholder: 'Күнді таңдаңыз',
    LocaleKeys.contractTimePlaceholder: 'Уақытты таңдаңыз',
    LocaleKeys.contractLocationLabel: 'Орын',
    LocaleKeys.contractLocationHint: 'City Gym, Brooklyn',
    LocaleKeys.contractNotificationsTitle: 'Хабарламалар',
    LocaleKeys.contractReminderToggle: 'Басталар алдындағы еске салу',
    LocaleKeys.contractAgreementStatusTitle: 'Келісім статусы',
    LocaleKeys.contractAgreementYou: 'Сіз',
    LocaleKeys.contractAgreementYouStatusPending: 'Қол қоюға дайын',
    LocaleKeys.contractAgreementYouStatusLocked: 'Қол қойылды',
    LocaleKeys.contractAgreementOpponent: 'Қарсылас',
    LocaleKeys.contractAgreementOpponentStatus: 'Қол қоюды күтіп тұр...',
    LocaleKeys.contractCodeOfConduct:
        'Мен спарринг ережелерімен және дауды шешу саясатына келісемін.',
    LocaleKeys.contractProposeButton: 'Келісімшарт ұсыну',
    LocaleKeys.contractSaved:
        'Келісімшарт сақталды. Мәліметтер енді өзгермейді.',
    LocaleKeys.contractRequiredDate: 'Спарринг күні мен уақытын таңдаңыз.',
    LocaleKeys.contractRequiredLocation: 'Спарринг орнын енгізіңіз.',
    LocaleKeys.contractAgreementRequired:
        'Ережелермен келісетініңізді растаңыз.',
    LocaleKeys.contractOpenButton: 'Келісімшарт құру',
    LocaleKeys.contractViewDetailsButton: 'Бекітілген келісімшартты көру',
    LocaleKeys.contractRequiredBeforeResult:
        'Алдымен келісімшартты құрып, бекітіңіз. Содан кейін нәтиже/дау қолжетімді.',
  },
};
