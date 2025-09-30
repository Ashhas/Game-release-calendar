part of '../filter_bottom_sheet.dart';

/// A reusable collapsible filter section that displays a title, count badge,
/// preview chips when collapsed, and selectable chips when expanded.
class _CollapsibleFilterSection<T> extends StatefulWidget {
  const _CollapsibleFilterSection({
    required this.title,
    required this.selectedItems,
    required this.allItems,
    required this.itemDisplayName,
    required this.itemShortName,
    required this.onSelectionChanged,
    this.isExpandedByDefault = false,
  });

  final String title;
  final Set<T> selectedItems;
  final List<T> allItems;
  final String Function(T item) itemDisplayName;
  final String Function(T item) itemShortName;
  final void Function(T item, bool selected) onSelectionChanged;
  final bool isExpandedByDefault;

  @override
  State<_CollapsibleFilterSection<T>> createState() => _CollapsibleFilterSectionState<T>();
}

class _CollapsibleFilterSectionState<T> extends State<_CollapsibleFilterSection<T>> {
  late bool _isExpanded;


  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpandedByDefault;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CollapsibleSectionHeader<T>(
          title: widget.title,
          selectedItems: widget.selectedItems,
          isExpanded: _isExpanded,
          onToggle: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        _CollapsibleSectionPreview<T>(
          isExpanded: _isExpanded,
          selectedItems: widget.selectedItems,
          itemShortName: widget.itemShortName,
          onSelectionChanged: widget.onSelectionChanged,
        ),
        _CollapsibleSectionContent<T>(
          isExpanded: _isExpanded,
          selectedItems: widget.selectedItems,
          allItems: widget.allItems,
          itemDisplayName: widget.itemDisplayName,
          onSelectionChanged: widget.onSelectionChanged,
        ),
      ],
    );
  }
}

class _CollapsibleSectionHeader<T> extends StatelessWidget {
  const _CollapsibleSectionHeader({
    required this.title,
    required this.selectedItems,
    required this.isExpanded,
    required this.onToggle,
  });

  final String title;
  final Set<T> selectedItems;
  final bool isExpanded;
  final VoidCallback onToggle;

  static const double _iconSize = 24.0;
  static const double _badgeFontSize = 12.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSelectedItems = selectedItems.isNotEmpty;

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacings.xs),
        child: Row(
          children: [
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: _iconSize,
            ),
            SizedBox(width: context.spacings.xs),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (hasSelectedItems && !isExpanded)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacings.xs,
                  vertical: context.spacings.xxs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Text(
                  '${selectedItems.length}',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: _badgeFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CollapsibleSectionPreview<T> extends StatelessWidget {
  const _CollapsibleSectionPreview({
    required this.isExpanded,
    required this.selectedItems,
    required this.itemShortName,
    required this.onSelectionChanged,
  });

  final bool isExpanded;
  final Set<T> selectedItems;
  final String Function(T item) itemShortName;
  final void Function(T item, bool selected) onSelectionChanged;

  static const double _chipFontSize = 12.0;

  @override
  Widget build(BuildContext context) {
    if (isExpanded || selectedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: context.spacings.xxl,
        bottom: context.spacings.xs,
      ),
      child: Wrap(
        spacing: context.spacings.xxs,
        runSpacing: context.spacings.xxs,
        children: selectedItems.map((item) {
          return Chip(
            label: Text(
              itemShortName(item),
              style: TextStyle(
                fontSize: _chipFontSize,
                color: colorScheme.onPrimary,
              ),
            ),
            backgroundColor: colorScheme.primary,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.symmetric(horizontal: context.spacings.xs),
            deleteIcon: Icon(
              Icons.close,
              size: 16,
              color: colorScheme.onPrimary,
            ),
            onDeleted: () {
              onSelectionChanged(item, false);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _CollapsibleSectionContent<T> extends StatelessWidget {
  const _CollapsibleSectionContent({
    required this.isExpanded,
    required this.selectedItems,
    required this.allItems,
    required this.itemDisplayName,
    required this.onSelectionChanged,
  });

  final bool isExpanded;
  final Set<T> selectedItems;
  final List<T> allItems;
  final String Function(T item) itemDisplayName;
  final void Function(T item, bool selected) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: context.spacings.xxl),
      child: Wrap(
        spacing: context.spacings.xxs,
        runSpacing: context.spacings.xxs,
        children: allItems.map((item) {
          final isSelected = selectedItems.contains(item);
          return FilterChip(
            label: Text(
              itemDisplayName(item),
              style: TextStyle(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              ),
            ),
            selected: isSelected,
            selectedColor: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
            onSelected: (selected) {
              onSelectionChanged(item, selected);
            },
          );
        }).toList(),
      ),
    );
  }
}