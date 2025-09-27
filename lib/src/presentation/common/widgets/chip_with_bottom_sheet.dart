import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class ChipWithBottomSheet extends StatelessWidget {
  const ChipWithBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chip with BottomSheet"),
      ),
      body: Center(
        child: FilterChip(
          label: const Text('Open BottomSheet'),
          selected: false,
          onSelected: (_) {
            _showBottomSheet(context);
          },
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(context.spacings.m),
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.spacings.m),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bottom Sheet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: context.spacings.xs),
              const Text('This is the content of the bottom sheet.'),
              SizedBox(height: context.spacings.xs),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
