import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/domain/enums/date_filter_choice.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/utils/date_helper.dart';

class DateFilterBottomSheet extends StatefulWidget {
  const DateFilterBottomSheet({super.key});

  @override
  State<DateFilterBottomSheet> createState() => _DateFilterBottomSheetState();
}

class _DateFilterBottomSheetState extends State<DateFilterBottomSheet> {
  DateFilterChoice? _selectedDateFilterOption = null;

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_circle_left_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
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
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_selectedDateFilterOption != null) {
                  DateTimeRange releaseDateRange;

                  switch (_selectedDateFilterOption) {
                    case DateFilterChoice.thisWeek:
                      releaseDateRange = DateTimeRange(
                        start: DateHelper.getStartOfThisWeek(),
                        end: DateHelper.getEndOfThisWeek(),
                      );
                      break;
                    case DateFilterChoice.thisMonth:
                      releaseDateRange = DateTimeRange(
                        start: DateHelper.getStartOfThisMonth(),
                        end: DateHelper.getEndOfThisMonth(),
                      );
                      break;
                    case DateFilterChoice.nextMonth:
                      releaseDateRange = DateTimeRange(
                        start: DateHelper.getStartOfNextMonth(),
                        end: DateHelper.getEndOfNextMonth(),
                      );
                      break;
                    default:
                      releaseDateRange = DateTimeRange(
                        start: DateTime.now(),
                        end: DateTime.now(),
                      );
                  }

                  await context.read<UpcomingGamesCubit>().updateDateFilter(
                        choice: _selectedDateFilterOption!,
                        range: releaseDateRange,
                      );

                  context.read<UpcomingGamesCubit>().getGames();

                  Navigator.pop(context);
                }
              },
              child: const Text('Apply Filter'),
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await context.read<UpcomingGamesCubit>().updateDateFilter(
                      choice: null,
                      range: null,
                    );

                context.read<UpcomingGamesCubit>().getGames();

                Navigator.pop(context);
              },
              child: const Text('Clean Selection'),
            ),
          ),
        ],
      ),
    );
  }
}
