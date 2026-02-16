class SportCatalogEntry {
  const SportCatalogEntry({required this.code, required this.label});

  final String code;
  final String label;
}

const List<SportCatalogEntry> kSportCatalog = [
  SportCatalogEntry(code: 'BOXING', label: 'Boxing'),
  SportCatalogEntry(code: 'MUAY_THAI', label: 'Muay Thai'),
  SportCatalogEntry(code: 'BJJ', label: 'BJJ'),
  SportCatalogEntry(code: 'TENNIS', label: 'Tennis'),
  SportCatalogEntry(code: 'PADEL', label: 'Padel'),
  SportCatalogEntry(code: 'BASKETBALL', label: 'Basketball'),
  SportCatalogEntry(code: 'FOOTBALL', label: 'Soccer'),
  SportCatalogEntry(code: 'WRESTLING', label: 'Wrestling'),
  SportCatalogEntry(code: 'SWIMMING', label: 'Swimming'),
  SportCatalogEntry(code: 'RUNNING', label: 'Running'),
  SportCatalogEntry(code: 'MMA', label: 'MMA'),
  SportCatalogEntry(code: 'KICKBOXING', label: 'Kickboxing'),
  SportCatalogEntry(code: 'VOLLEYBALL', label: 'Volleyball'),
  SportCatalogEntry(code: 'TABLE_TENNIS', label: 'Table Tennis'),
];

String sportLabelByCode(String code) {
  final normalized = code.trim().toUpperCase();
  for (final item in kSportCatalog) {
    if (item.code == normalized) {
      return item.label;
    }
  }

  if (normalized.isEmpty) return '';
  return normalized
      .split('_')
      .map((part) {
        if (part.isEmpty) return part;
        return '${part[0]}${part.substring(1).toLowerCase()}';
      })
      .join(' ');
}
