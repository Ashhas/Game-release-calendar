part of '../game_detail_view.dart';

class GameToolbar extends StatelessWidget {
  const GameToolbar({
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
          onTap: () {
            context.read<GameDetailCubit>().scheduleNotification(game);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notification_add_outlined,
                size: 28,
              ),
              SizedBox(height: 4),
              Text('Reminder'),
            ],
          ),
        ),
        SizedBox(width: context.spacings.l),
        InkWell(
          onTap: () => UrlHelper.openUrl(
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
              const Text('Website'),
            ],
          ),
        ),
      ],
    );
  }
}
