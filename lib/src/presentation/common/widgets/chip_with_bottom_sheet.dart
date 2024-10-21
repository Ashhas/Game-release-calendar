import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(16),
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bottom Sheet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('This is the content of the bottom sheet.'),
              const SizedBox(height: 10),
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
