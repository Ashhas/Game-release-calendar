part of '../filter_bar.dart';

class PlatformFilterBottomSheet extends StatefulWidget {
  const PlatformFilterBottomSheet({super.key});

  @override
  State<PlatformFilterBottomSheet> createState() =>
      _PlatformFilterBottomSheetState();
}

class _PlatformFilterBottomSheetState extends State<PlatformFilterBottomSheet> {
  late PlatformFilterChoice? _selectedPlatformFilterOption;

  @override
  void initState() {
    super.initState();
    _selectedPlatformFilterOption =
        context.read<UpcomingGamesCubit>().state.selectedFilters.platform;
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
          RadioListTile<PlatformFilterChoice>(
            title: Text(PlatformFilterChoice.ps5.fullName),
            value: PlatformFilterChoice.ps5,
            groupValue: _selectedPlatformFilterOption,
            onChanged: (PlatformFilterChoice? value) {
              setState(() {
                if (value != null) {
                  _selectedPlatformFilterOption = value;
                }
              });
            },
          ),
          RadioListTile<PlatformFilterChoice>(
            title: Text(PlatformFilterChoice.pc.fullName),
            value: PlatformFilterChoice.pc,
            groupValue: _selectedPlatformFilterOption,
            onChanged: (PlatformFilterChoice? value) {
              setState(() {
                if (value != null) {
                  _selectedPlatformFilterOption = value;
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
                _selectedPlatformFilterOption != null
                    ? _applyFilter(context)
                    : null;
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
          choice: _selectedPlatformFilterOption,
        );
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }

  Future<void> _cleanFilter(BuildContext context) async {
    await context.read<UpcomingGamesCubit>().updatePlatformFilter(choice: null);
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }
}
