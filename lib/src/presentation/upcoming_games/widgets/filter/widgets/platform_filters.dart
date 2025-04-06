part of '../filter_bottom_sheet.dart';

class _PlatformFilters extends StatefulWidget {
  const _PlatformFilters({
    required this.selectedPlatformFilterOptions,
  });

  final Set<PlatformFilter> selectedPlatformFilterOptions;

  @override
  State<_PlatformFilters> createState() => _PlatformFiltersState();
}

class _PlatformFiltersState extends State<_PlatformFilters> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text(
          'Platforms',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...PlatformFilter.values.map((platform) {
          return CheckboxListTile(
            title: Text(platform.fullName),
            value: widget.selectedPlatformFilterOptions.contains(platform),
            onChanged: (bool? isChecked) {
              setState(() {
                if (isChecked == true) {
                  if (!widget.selectedPlatformFilterOptions
                      .contains(platform)) {
                    widget.selectedPlatformFilterOptions.add(platform);
                  }
                } else {
                  widget.selectedPlatformFilterOptions.remove(platform);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }
}
