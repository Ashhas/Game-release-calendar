part of '../filter_bottom_sheet.dart';

/// Platform filter section with collapsible UI and chip-based selection.
class _PlatformFilters extends StatefulWidget {
  const _PlatformFilters({
    required this.selectedPlatformFilterOptions,
  });

  final Set<PlatformFilter> selectedPlatformFilterOptions;

  @override
  State<_PlatformFilters> createState() => _PlatformFiltersState();
}

class _PlatformFiltersState extends State<_PlatformFilters> {
  /// Handles selection/deselection of platform filters.
  void _onPlatformSelectionChanged(PlatformFilter platform, bool selected) {
    setState(() {
      if (selected) {
        widget.selectedPlatformFilterOptions.add(platform);
      } else {
        widget.selectedPlatformFilterOptions.remove(platform);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CollapsibleFilterSection<PlatformFilter>(
      title: 'Platforms',
      selectedItems: widget.selectedPlatformFilterOptions,
      allItems: PlatformFilter.values,
      itemDisplayName: (platform) => platform.fullName,
      itemShortName: (platform) => platform.abbreviation,
      onSelectionChanged: _onPlatformSelectionChanged,
    );
  }
}
