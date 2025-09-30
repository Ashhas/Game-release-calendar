part of '../filter_bottom_sheet.dart';

class Footer extends StatefulWidget {
  const Footer({
    this.onApplyFilter,
    this.onResetFilter,
    super.key,
  });

  final VoidCallback? onApplyFilter;
  final VoidCallback? onResetFilter;

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.primary,
            ),
            onPressed: widget.onResetFilter,
            child: const Text('Clear'),
          ),
        ),
        SizedBox(width: context.spacings.s),
        Expanded(
          child: FilledButton(
            onPressed: widget.onApplyFilter,
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }
}
