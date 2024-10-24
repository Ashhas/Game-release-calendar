part of '../game_detail_view.dart';

class IconRow extends StatefulWidget {
  const IconRow({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  State<IconRow> createState() => _IconRowState();
}

class _IconRowState extends State<IconRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            context.read<GameDetailCubit>().saveGame(widget.game);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notification_add_outlined,
                size: 28,
              ),
              SizedBox(height: 4),
              // Optional: Add some space between the icon and the text
              Text('Reminder'),
            ],
          ),
        ),
        SizedBox(width: context.spacings.l),
        InkWell(
          onTap: () => UrlLaunchFunctions.openUrl(
            widget.game.url,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.web,
                size: 28,
              ),
              SizedBox(height: context.spacings.xxs),
              const Text('Website'),
            ],
          ),
        ),
      ],
    );
  }
}
