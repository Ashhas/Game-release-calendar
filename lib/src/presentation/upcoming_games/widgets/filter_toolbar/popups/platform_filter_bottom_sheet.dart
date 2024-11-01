part of '../filter_toolbar.dart';

class PlatformFilterBottomSheet extends StatefulWidget {
  const PlatformFilterBottomSheet({super.key});

  @override
  State<PlatformFilterBottomSheet> createState() =>
      _PlatformFilterBottomSheetState();
}

class _PlatformFilterBottomSheetState extends State<PlatformFilterBottomSheet> {
  late Set<PlatformFilter> _selectedPlatformFilterOptions;

  @override
  void initState() {
    super.initState();
    _selectedPlatformFilterOptions = Set.of(
      context.read<UpcomingGamesCubit>().state.selectedFilters.platformChoices,
    );
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
                'Filter by Platform',
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
          Expanded(
            child: ListView(
              children: PlatformFilter.values.map((platform) {
                return CheckboxListTile(
                  title: Text(platform.fullName),
                  value: _selectedPlatformFilterOptions.contains(platform),
                  onChanged: (bool? isChecked) {
                    setState(() {
                      if (isChecked == true) {
                        if (!_selectedPlatformFilterOptions
                            .contains(platform)) {
                          _selectedPlatformFilterOptions.add(platform);
                        }
                      } else {
                        _selectedPlatformFilterOptions.remove(platform);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: context.spacings.m),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Apply Filter'),
              onPressed: () {
                _applyFilter(context);
              },
            ),
          ),
          SizedBox(height: context.spacings.xxs),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Clear Selection'),
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
    await context.read<UpcomingGamesCubit>().updatePlatformFilter(
          choices: _selectedPlatformFilterOptions,
        );
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }

  Future<void> _cleanFilter(BuildContext context) async {
    await context.read<UpcomingGamesCubit>().updatePlatformFilter(choices: {});
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }
}
