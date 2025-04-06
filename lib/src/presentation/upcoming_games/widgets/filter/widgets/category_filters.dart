part of '../filter_bottom_sheet.dart';

class _CategoryFilters extends StatefulWidget {
  const _CategoryFilters({
    required this.selectedCategoryFilterOptions,
  });

  final Set<int> selectedCategoryFilterOptions;

  @override
  State<_CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends State<_CategoryFilters> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...GameCategory.values.map((category) {
          return CheckboxListTile(
            title: Text(category.description),
            value:
                widget.selectedCategoryFilterOptions.contains(category.value),
            onChanged: (isChecked) {
              setState(
                () {
                  if (isChecked == true) {
                    if (!widget.selectedCategoryFilterOptions
                        .contains(category)) {
                      widget.selectedCategoryFilterOptions.add(category.value);
                    }
                  } else {
                    widget.selectedCategoryFilterOptions.remove(category.value);
                  }
                },
              );
            },
          );
        }).toList(),
      ],
    );
  }
}
