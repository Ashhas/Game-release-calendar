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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: context.spacings.m),
        ElevatedButton(
          child: const Text('Clear Selection'),
          onPressed: widget.onResetFilter,
        ),
        SizedBox(height: context.spacings.xxs),
        ElevatedButton(
          child: const Text('Apply Filter'),
          onPressed: widget.onApplyFilter,
        ),
        SizedBox(height: context.spacings.m),
      ],
    );
  }
}
