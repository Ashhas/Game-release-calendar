/// Helper utilities for search functionality.
///
/// Contains methods to improve search matching, particularly for APIs
/// that require exact character matching like IGDB.
class SearchHelper {
  /// Adds accented character variants to improve search matching for IGDB API.
  /// IGDB requires exact character matching, so "pokemon" won't find "pokémon".
  /// This method generates common accented variants of the search query.
  static List<String> addAccentedVariants(String query) {
    final variants = <String>[];

    // Common character mappings for game titles
    final charMap = {
      'e': ['é', 'è', 'ê', 'ë'],
      'a': ['á', 'à', 'â', 'ä', 'ã'],
      'o': ['ó', 'ò', 'ô', 'ö', 'õ'],
      'u': ['ú', 'ù', 'û', 'ü'],
      'i': ['í', 'ì', 'î', 'ï'],
      'n': ['ñ'],
      'c': ['ç'],
    };

    String currentVariant = query.toLowerCase();

    // Generate variants by replacing each character with its accented versions
    for (final entry in charMap.entries) {
      final baseChar = entry.key;
      final accentedChars = entry.value;

      if (currentVariant.contains(baseChar)) {
        for (final accentedChar in accentedChars) {
          final variant = currentVariant.replaceAll(baseChar, accentedChar);
          if (variant != query.toLowerCase() && !variants.contains(variant)) {
            variants.add(variant);
          }
        }
      }
    }

    return variants;
  }
}
