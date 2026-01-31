part of '../filter_bottom_sheet.dart';

class _ContentFilters extends StatefulWidget {
  const _ContentFilters({
    required this.showEroticContent,
    required this.onShowEroticContentChanged,
  });

  final bool showEroticContent;
  final ValueChanged<bool> onShowEroticContentChanged;

  @override
  State<_ContentFilters> createState() => _ContentFiltersState();
}

class _ContentFiltersState extends State<_ContentFilters> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                  'Content Visibility',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.only(left: context.spacings.xxl),
            child: CheckboxListTile(
              title: const Text('Show adult content'),
              value: widget.showEroticContent,
              onChanged: (value) =>
                  widget.onShowEroticContentChanged(value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
      ],
    );
  }
}
