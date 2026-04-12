class SportCatalogEntry {
  const SportCatalogEntry({required this.code});

  final String code;
}

const List<SportCatalogEntry> kSportCatalog = [
  SportCatalogEntry(code: 'BOXING'),
  SportCatalogEntry(code: 'MUAY_THAI'),
  SportCatalogEntry(code: 'BJJ'),
  SportCatalogEntry(code: 'TENNIS'),
  SportCatalogEntry(code: 'PADEL'),
  SportCatalogEntry(code: 'BASKETBALL'),
  SportCatalogEntry(code: 'FOOTBALL'),
  SportCatalogEntry(code: 'WRESTLING'),
  SportCatalogEntry(code: 'SWIMMING'),
  SportCatalogEntry(code: 'RUNNING'),
  SportCatalogEntry(code: 'MMA'),
  SportCatalogEntry(code: 'KICKBOXING'),
  SportCatalogEntry(code: 'VOLLEYBALL'),
  SportCatalogEntry(code: 'TABLE_TENNIS'),
];

String normalizeSportCode(String code) =>
    code.trim().toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');

String sportLabelByCode(String code) {
  final normalized = normalizeSportCode(code);
  if (normalized.isEmpty) return '';
  return normalized
      .split('_')
      .map((part) {
        if (part.isEmpty) return part;
        return '${part[0]}${part.substring(1).toLowerCase()}';
      })
      .join(' ');
}
