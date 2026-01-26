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

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  String get searchSettingsPlaceholder => _string(LocaleKeys.searchSettingsPlaceholder);
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

  String nameAndAge(String name, int age) =>
      _string(LocaleKeys.nameAge).replaceFirst('{name}', name).replaceFirst('{age}', age.toString());

  String sportAndLevel(String sport, String level) => _string(LocaleKeys.sportLevel)
      .replaceFirst('{sport}', sport)
      .replaceFirst('{level}', level);

  String formatDistanceKm(double value) =>
      _string(LocaleKeys.distanceKm).replaceFirst('{value}', value.toStringAsFixed(1));

  String formatRating(double value) =>
      _string(LocaleKeys.rating).replaceFirst('{value}', value.toStringAsFixed(1));

  String formatTodayAt(String time) =>
      _string(LocaleKeys.todayAt).replaceFirst('{time}', time);

  String versionLabel(String version) => _string(LocaleKeys.version).replaceFirst('{version}', version);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
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
    LocaleKeys.disputeNote: 'Initiating a dispute will freeze the result and require evidence submission.',
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
    LocaleKeys.aiAssistantSubtitle: 'We will connect your personal fight-AI helper here.',
    LocaleKeys.madeWithCare: 'Made with care for you ❤️',
    LocaleKeys.language: 'Language',
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
    LocaleKeys.searchSettingsPlaceholder: 'Искать по настройкам, спорам, приватности…',
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
    LocaleKeys.aiAssistantSubtitle: 'Здесь будет подключен ваш персональный AI-ассистент.',
    LocaleKeys.madeWithCare: 'Сделано с заботой для вас ❤️',
    LocaleKeys.language: 'Язык',
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
    LocaleKeys.disputeNote: 'Дауды бастау нәтижені тоқтатады және дәлелдер сұрайды.',
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
  },
};
