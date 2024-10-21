part of '../filter_bar.dart';

class DateFilterBottomSheet extends StatefulWidget {
  const DateFilterBottomSheet({super.key});

  @override
  State<DateFilterBottomSheet> createState() => _DateFilterBottomSheetState();
}

class _DateFilterBottomSheetState extends State<DateFilterBottomSheet> {
  late DateFilterChoice? _selectedDateFilterOption;

  @override
  void initState() {
    super.initState();
    _selectedDateFilterOption = context
        .read<UpcomingGamesCubit>()
        .state
        .selectedFilters
        .releaseDateChoice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacings.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Date',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_circle_left_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: context.spacings.m),
          RadioListTile<DateFilterChoice>(
            title: const Text('This Week'),
            value: DateFilterChoice.thisWeek,
            groupValue: _selectedDateFilterOption,
            onChanged: (DateFilterChoice? value) {
              setState(() {
                if (value != null) {
                  _selectedDateFilterOption = value;
                }
              });
            },
          ),
          RadioListTile<DateFilterChoice>(
            title: const Text('This Month'),
            value: DateFilterChoice.thisMonth,
            groupValue: _selectedDateFilterOption,
            onChanged: (DateFilterChoice? value) {
              setState(() {
                if (value != null) {
                  _selectedDateFilterOption = value;
                }
              });
            },
          ),
          SizedBox(height: context.spacings.m),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Apply Filter'),
              onPressed: () {
                _selectedDateFilterOption != null
                    ? _applyFilter(context)
                    : null;
              },
            ),
          ),
          SizedBox(height: context.spacings.xxs),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Clean Selection'),
              onPressed: () {
                _cleanFilter(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _applyFilter(BuildContext context) async {
    final releaseDateRange =
        DateHelper.getDateRangeForChoice(_selectedDateFilterOption!);
    await context.read<UpcomingGamesCubit>().updateDateFilter(
          choice: _selectedDateFilterOption!,
          range: releaseDateRange,
        );
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }

  Future<void> _cleanFilter(BuildContext context) async {
    await context
        .read<UpcomingGamesCubit>()
        .updateDateFilter(choice: null, range: null);
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }
}
