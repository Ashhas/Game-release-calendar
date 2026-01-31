part of '../filter_bottom_sheet.dart';

class _DateFilters extends StatefulWidget {
  const _DateFilters({
    required this.selectedDateFilterOption,
    required this.onDateFilterChanged,
  });

  final DateFilterChoice? selectedDateFilterOption;
  final Function(DateFilterChoice? choice)? onDateFilterChanged;

  @override
  State<_DateFilters> createState() => _DateFiltersState();
}

class _DateFiltersState extends State<_DateFilters> {
  bool _isExpanded = true; // Start expanded by default for date range

  final _options = <DateFilterChoice, String>{
    DateFilterChoice.allTime: 'All time',
    DateFilterChoice.thisWeek: 'This Week',
    DateFilterChoice.thisMonth: 'This Month',
    DateFilterChoice.nextMonth: 'Next Month',
    DateFilterChoice.next3Months: 'Next 3 Months',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacings.xs),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 24,
                ),
                SizedBox(width: context.spacings.xs),
                const Text(
                  'Date Range',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (widget.selectedDateFilterOption != null && !_isExpanded)
                  Chip(
                    label: Text(
                      _options[widget.selectedDateFilterOption] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    backgroundColor: colorScheme.primary,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacings.xs,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.only(left: context.spacings.xxl),
            child: Wrap(
              spacing: context.spacings.xxs,
              runSpacing: context.spacings.xxs,
              children: _options.entries.map((entry) {
                final isSelected = widget.selectedDateFilterOption == entry.key;
                return ChoiceChip(
                  label: Text(
                    entry.value,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  onSelected: (selected) {
                    widget.onDateFilterChanged?.call(
                      selected ? entry.key : null,
                    );
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
