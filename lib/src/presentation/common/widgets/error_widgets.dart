import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.title,
  });

  final Exception error;
  final VoidCallback? onRetry;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final message = ExceptionHandler.getUserMessage(error);
    final canRetry = ExceptionHandler.isRetryable(error) && onRetry != null;

    return Semantics(
      label: 'Error occurred: $message',
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacings.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Error icon',
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(height: context.spacings.m),
              if (title != null) ...[
                Semantics(
                  header: true,
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: context.spacings.s),
              ],
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (canRetry) ...[
                SizedBox(height: context.spacings.l),
                Semantics(
                  button: true,
                  hint: 'Retry the failed operation',
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    super.key,
    this.message = 'Loading...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Loading progress indicator',
              child: const CircularProgressIndicator(),
            ),
            SizedBox(height: context.spacings.m),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    super.key,
    required this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: context.spacings.m),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacings.s),
            Text(message, textAlign: TextAlign.center),
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: context.spacings.l),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}