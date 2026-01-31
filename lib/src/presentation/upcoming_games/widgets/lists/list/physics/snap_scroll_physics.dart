part of '../game_list.dart';

class SnapScrollPhysics extends ScrollPhysics {
  const SnapScrollPhysics({
    super.parent,
    required this.sectionKeys,
    required this.scrollController,
  });

  final Map<DateTime, GlobalKey> sectionKeys;
  final ScrollController scrollController;

  @override
  SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(
      parent: buildParent(ancestor),
      sectionKeys: sectionKeys,
      scrollController: scrollController,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If we're scrolling fast, let the default physics handle it first
    final Simulation? simulation = super.createBallisticSimulation(
      position,
      velocity,
    );

    // For slow scrolling or when settling, snap to nearest section
    if (velocity.abs() < 100) {
      final targetOffset = _findNearestSectionOffset(position.pixels);
      if (targetOffset != null && (targetOffset - position.pixels).abs() > 10) {
        return ScrollSpringSimulation(
          spring,
          position.pixels,
          targetOffset,
          velocity,
          tolerance: toleranceFor(position),
        );
      }
    }

    return simulation;
  }

  double? _findNearestSectionOffset(double currentOffset) {
    if (sectionKeys.isEmpty || !scrollController.hasClients) return null;

    double? nearestOffset;
    double nearestDistance = double.infinity;
    final scrollOffset = scrollController.offset;

    for (final key in sectionKeys.values) {
      final context = key.currentContext;
      if (context == null) continue;

      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox) continue;

      try {
        // Get the section's position relative to the viewport
        final sectionPosition = renderObject.localToGlobal(Offset.zero);
        final sectionTopOffset = scrollOffset + sectionPosition.dy;

        // Calculate distance from current scroll position
        final distance = (sectionTopOffset - currentOffset).abs();

        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearestOffset = sectionTopOffset;
        }
      } catch (e) {
        // Ignore if renderBox is not ready
      }
    }

    return nearestOffset;
  }
}
