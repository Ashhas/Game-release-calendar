part of '../game_detail_view.dart';

class IconRow extends StatelessWidget {
  const IconRow({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},

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
            game.url,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.web,
                size: 28,
              ),
              SizedBox(height: context.spacings.xxs),
              // Optional: Add some space between the icon and the text
              const Text('Website'),
            ],
          ),
        ),
      ],
    );
  }
}
