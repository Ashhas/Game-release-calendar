import 'package:flutter/material.dart';

/// A pill-style tab bar with smooth animations
/// Replaces MoonTabBar.pill with native Flutter components
class PillTabBar extends StatelessWidget {
  const PillTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  final TabController tabController;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: colorScheme.primary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
        tabs: tabs.map((label) => Tab(text: label)).toList(),
      ),
    );
  }
}

/// Extension to create PillTabBar easily from TabController
extension PillTabBarExtension on TabController {
  Widget pillTabBar(List<String> labels) {
    return PillTabBar(
      tabController: this,
      tabs: labels,
    );
  }
}