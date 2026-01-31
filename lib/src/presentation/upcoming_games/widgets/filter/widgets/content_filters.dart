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
                  'Content',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (!_isExpanded && !widget.showEroticContent)
                  Chip(
                    label: Text(
                      'Safe',
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
            child: SwitchListTile(
              title: const Text('Show adult content'),
              subtitle: const Text('Include games with erotic themes'),
              value: widget.showEroticContent,
              onChanged: widget.onShowEroticContentChanged,
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}
