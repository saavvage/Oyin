import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../infrastructure/export.dart';
import '../../../extensions/_export.dart';
import '../../../widgets/_export.dart';

class AccountOverviewScreen extends StatefulWidget {
  const AccountOverviewScreen({super.key});

  @override
  State<AccountOverviewScreen> createState() => _AccountOverviewScreenState();
}

class _AccountOverviewScreenState extends State<AccountOverviewScreen> {
  bool _loading = true;
  Map<String, dynamic> _me = const {};
  UserAvailabilitySettings? _availability;
  List<GameHistoryDto> _games = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final me = await UsersApi.getMe();
      final userId = (me['id'] ?? '').toString();
      final availability = await UsersApi.getAvailabilitySettings();
      final games = userId.isEmpty
          ? const <GameHistoryDto>[]
          : await GamesApi.getMyGames(userId);

      if (!mounted) return;
      setState(() {
        _me = me;
        _availability = availability;
        _games = games;
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
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

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
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  8.hSpacing,
                  Text(
                    l10n.accountOverviewTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroCard(context, l10n),
                        16.vSpacing,
                        _buildContactsCard(context, l10n),
                        16.vSpacing,
                        _buildSportsCard(context, l10n),
                        16.vSpacing,
                        _buildAvailabilityCard(context, l10n),
                        16.vSpacing,
                        _buildStatsCard(context, l10n),
                        24.vSpacing,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    final name = (_me['name'] ?? '').toString().trim();
    final city = (_me['city'] ?? '').toString().trim();
    final birthDate = (_me['birthDate'] ?? '').toString().trim();
    final avatarUrl = (_me['avatarUrl'] ?? '').toString().trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: palette.accent,
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl.isEmpty
                ? const Icon(Icons.person, size: 34, color: Colors.white)
                : null,
          ),
          12.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? l10n.profile : name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                4.vSpacing,
                if (city.isNotEmpty)
                  Text(
                    city,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                  ),
                if (birthDate.isNotEmpty)
                  Text(
                    '${l10n.accountOverviewBirthDate}: ${_formatDate(birthDate)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.muted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsCard(BuildContext context, AppLocalizations l10n) {
    final palette = context.palette;
    final email = (_me['email'] ?? '').toString().trim();
    final phone = (_me['phone'] ?? '').toString().trim();
    final emailVerified = _me['emailVerified'] == true;
    final phoneVerified = _me['phoneVerified'] == true;

    return _SectionCard(
      title: l10n.accountOverviewContacts,
      child: Column(
        children: [
          _lineItem(
            context,
            icon: Icons.email_outlined,
            title: l10n.email,
            value: email.isEmpty ? l10n.notSet : email,
            tag: emailVerified ? l10n.verified : l10n.notVerified,
            tagColor: emailVerified ? palette.success : palette.danger,
          ),
          10.vSpacing,
          _lineItem(
            context,
            icon: Icons.phone_outlined,
            title: l10n.phoneNumberLabel,
            value: phone.isEmpty || phone.startsWith('tmp_')
                ? l10n.notSet
                : phone,
            tag: phoneVerified ? l10n.verified : l10n.notVerified,
            tagColor: phoneVerified ? palette.success : palette.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildSportsCard(BuildContext context, AppLocalizations l10n) {
    final sportProfiles = _extractSportProfiles(_me['sportProfiles']);
    if (sportProfiles.isEmpty) {
      return _SectionCard(
        title: l10n.accountOverviewSports,
        child: Text(
          l10n.accountOverviewNoSports,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.palette.muted),
        ),
      );
    }

    return _SectionCard(
      title: l10n.accountOverviewSports,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sportProfiles.map((profile) {
          final sportName = l10n.sportName(profile.sport);
          final level = l10n.levelName(profile.level);
          final skills = profile.skills.map(l10n.skillTag).toList();
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.palette.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$sportName • $level',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (profile.experienceYears > 0) ...[
                  6.vSpacing,
                  Text(
                    '${l10n.accountOverviewExperienceYears}: ${profile.experienceYears}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.palette.muted,
                    ),
                  ),
                ],
                if (skills.isNotEmpty) ...[
                  8.vSpacing,
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: skills
                        .map(
                          (skill) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.palette.card,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              skill,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvailabilityCard(BuildContext context, AppLocalizations l10n) {
    final schedule = _availability?.schedule ?? const <String, dynamic>{};
    final lines = _availabilitySummary(schedule, l10n);
    return _SectionCard(
      title: l10n.accountOverviewAvailability,
      child: lines.isEmpty
          ? Text(
              l10n.accountOverviewNoAvailability,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.palette.muted),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        line,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildStatsCard(BuildContext context, AppLocalizations l10n) {
    final stats = _calculateStats(_games);
    return _SectionCard(
      title: l10n.accountOverviewStatistics,
      child: stats.total == 0
          ? Text(
              l10n.accountOverviewNoStats,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.palette.muted),
            )
          : Column(
              children: [
                _lineItem(
                  context,
                  icon: Icons.sports_score_outlined,
                  title: l10n.matches,
                  value: '${stats.total}',
                ),
                8.vSpacing,
                _lineItem(
                  context,
                  icon: Icons.trending_up_outlined,
                  title: l10n.accountOverviewWins,
                  value: '${stats.wins}',
                ),
                8.vSpacing,
                _lineItem(
                  context,
                  icon: Icons.trending_down_outlined,
                  title: l10n.accountOverviewLosses,
                  value: '${stats.losses}',
                ),
                8.vSpacing,
                _lineItem(
                  context,
                  icon: Icons.remove_outlined,
                  title: l10n.accountOverviewDraws,
                  value: '${stats.draws}',
                ),
                8.vSpacing,
                _lineItem(
                  context,
                  icon: Icons.percent_rounded,
                  title: l10n.accountOverviewWinRate,
                  value: '${stats.winRate.toStringAsFixed(1)}%',
                ),
              ],
            ),
    );
  }

  Widget _lineItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? tag,
    Color? tagColor,
  }) {
    final palette = context.palette;
    final safeTag = tag ?? '';
    final hasTag = safeTag.isNotEmpty;

    if (hasTag) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 18, color: palette.muted),
          ),
          8.hSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.muted),
                ),
                2.vSpacing,
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          8.hSpacing,
          Flexible(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (tagColor ?? palette.muted).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  safeTag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: tagColor ?? palette.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: palette.muted),
        8.hSpacing,
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  List<_SportProfileRow> _extractSportProfiles(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((item) {
      final map = item.cast<String, dynamic>();
      final rawSkills = map['skills'];
      final skills = rawSkills is List
          ? rawSkills
                .whereType<String>()
                .where((s) => s.trim().isNotEmpty)
                .toList()
          : const <String>[];
      return _SportProfileRow(
        sport: (map['sportType'] ?? '').toString(),
        level: (map['level'] ?? '').toString(),
        skills: skills,
        experienceYears: (map['experienceYears'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  List<String> _availabilitySummary(
    Map<String, dynamic> raw,
    AppLocalizations l10n,
  ) {
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    const slots = ['morning', 'day', 'evening'];
    final dayLabels = {
      'mon': l10n.availabilityDayMon,
      'tue': l10n.availabilityDayTue,
      'wed': l10n.availabilityDayWed,
      'thu': l10n.availabilityDayThu,
      'fri': l10n.availabilityDayFri,
      'sat': l10n.availabilityDaySat,
      'sun': l10n.availabilityDaySun,
    };
    final slotLabels = {
      'morning': l10n.availabilityTimeMorning,
      'day': l10n.availabilityTimeDay,
      'evening': l10n.availabilityTimeEvening,
    };

    final daysRaw = raw['days'];
    final source = daysRaw is Map
        ? daysRaw.cast<String, dynamic>()
        : raw.cast<String, dynamic>();

    final result = <String>[];
    for (final day in days) {
      final dayValue =
          source[day] ??
          source[day.toUpperCase()] ??
          source['${day[0].toUpperCase()}${day.substring(1)}'];
      if (dayValue is! Map) continue;
      final map = dayValue.cast<String, dynamic>();
      final enabled = slots
          .where((slot) {
            final value = map[slot] ?? map[slot.toUpperCase()];
            return value == true ||
                value == 1 ||
                value == '1' ||
                value == 'true';
          })
          .map((slot) => slotLabels[slot] ?? slot)
          .toList();
      if (enabled.isEmpty) continue;
      result.add('${dayLabels[day]}: ${enabled.join(', ')}');
    }
    return result;
  }

  String _formatDate(String raw) {
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  _Stats _calculateStats(List<GameHistoryDto> games) {
    var wins = 0;
    var losses = 0;
    var draws = 0;
    for (final game in games) {
      if (game.result == 'win') wins++;
      if (game.result == 'loss') losses++;
      if (game.result == 'draw') draws++;
    }
    final total = wins + losses + draws;
    final winRate = total == 0 ? 0.0 : (wins / total) * 100;
    return _Stats(
      wins: wins,
      losses: losses,
      draws: draws,
      total: total,
      winRate: winRate,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          10.vSpacing,
          child,
        ],
      ),
    );
  }
}

class _SportProfileRow {
  const _SportProfileRow({
    required this.sport,
    required this.level,
    required this.skills,
    required this.experienceYears,
  });

  final String sport;
  final String level;
  final List<String> skills;
  final int experienceYears;
}

class _Stats {
  const _Stats({
    required this.wins,
    required this.losses,
    required this.draws,
    required this.total,
    required this.winRate,
  });

  final int wins;
  final int losses;
  final int draws;
  final int total;
  final double winRate;
}
