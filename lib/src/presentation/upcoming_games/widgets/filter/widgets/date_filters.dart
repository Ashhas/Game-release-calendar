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
  final _options = <DateFilterChoice, String>{
    DateFilterChoice.allTime: 'All time',
    DateFilterChoice.thisWeek: 'This Week',
    DateFilterChoice.thisMonth: 'This Month',
    DateFilterChoice.nextMonth: 'Next Month',
    DateFilterChoice.next3Months: 'Next 3 Months',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ..._options.entries.map((entry) {
          return RadioListTile<DateFilterChoice>(
            title: Text(entry.value),
            value: entry.key,
            groupValue: widget.selectedDateFilterOption,
            onChanged: widget.onDateFilterChanged,
          );
        }).toList(),
      ],
    );
  }
}
