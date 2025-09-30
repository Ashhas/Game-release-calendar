part of '../filter_bottom_sheet.dart';

/// Category filter section with collapsible UI and chip-based selection.
class _CategoryFilters extends StatefulWidget {
  const _CategoryFilters({
    required this.selectedCategoryFilterOptions,
  });

  final Set<int> selectedCategoryFilterOptions;

  @override
  State<_CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends State<_CategoryFilters> {
  /// Maps GameCategory enum values to display names.
  static String _getCategoryDisplayName(GameCategory category) {
    return category.description;
  }

  /// Maps GameCategory enum values to short names for chips.
  static String _getCategoryShortName(GameCategory category) {
    switch (category) {
      case GameCategory.mainGame:
        return 'Main';
      case GameCategory.expansion:
        return 'DLC';
      case GameCategory.bundle:
        return 'Bundle';
      case GameCategory.standaloneExpansion:
        return 'Standalone';
      case GameCategory.mod:
        return 'Mod';
      case GameCategory.episode:
        return 'Episode';
      case GameCategory.season:
        return 'Season';
      case GameCategory.remake:
        return 'Remake';
      case GameCategory.remaster:
        return 'Remaster';
      case GameCategory.expandedGame:
        return 'Expanded';
      case GameCategory.port:
        return 'Port';
      case GameCategory.fork:
        return 'Fork';
      case GameCategory.pack:
        return 'Pack';
      case GameCategory.update:
        return 'Update';
      case GameCategory.dlcAddon:
        return 'DLC';
      case GameCategory.fangame:
        return 'Fan Game';
    }
  }

  /// Converts a Set<int> to Set<GameCategory> for the collapsible component.
  Set<GameCategory> get _selectedCategories {
    return widget.selectedCategoryFilterOptions
        .map((id) => GameCategory.values.firstWhere(
              (category) => category.value == id,
              orElse: () => GameCategory.mainGame,
            ))
        .toSet();
  }

  /// Handles selection/deselection of category filters.
  void _onCategorySelectionChanged(GameCategory category, bool selected) {
    setState(() {
      if (selected) {
        widget.selectedCategoryFilterOptions.add(category.value);
      } else {
        widget.selectedCategoryFilterOptions.remove(category.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.spacings.m),
        _CollapsibleFilterSection<GameCategory>(
          title: 'Categories',
          selectedItems: _selectedCategories,
          allItems: GameCategory.values,
          itemDisplayName: _getCategoryDisplayName,
          itemShortName: _getCategoryShortName,
          onSelectionChanged: _onCategorySelectionChanged,
        ),
      ],
    );
  }
}
