import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'widgets/_scrollbar_stack.dart';
part 'widgets/_scroll_track.dart';
part 'widgets/_scroll_thumb.dart';
part 'widgets/_date_tooltip.dart';
part 'widgets/_tooltip_content.dart';
part 'widgets/_interaction_area.dart';

/// A custom scrollbar that displays date tooltips when scrolling through
/// a date-organized list. Shows a native-style thin scrollbar that reveals
/// date information on hover or during scroll interactions.
class DateScrollbar extends StatefulWidget {
  /// Creates a date-aware scrollbar.
  ///
  /// The [dates] should be sorted chronologically and represent dates
  /// that have content in the scrollable view.
  const DateScrollbar({
    super.key,
    required this.dates,
    required this.scrollController,
    required this.onDateTap,
  });

  /// List of dates that have content, should be sorted chronologically
  final List<DateTime> dates;

  /// ScrollController for the main content area
  final ScrollController scrollController;

  /// Callback when a date is tapped in the scrollbar
  final Function(DateTime date) onDateTap;

  // Constants - made public for part files
  static const double scrollbarWidth = 6.0;
  static const double thumbWidth = 10.0;
  static const double interactionWidth = 12.0; // Reduced from 20 to 12
  static const double tooltipOffset = 20.0;

  @override
  State<DateScrollbar> createState() => _DateScrollbarState();
}

class _DateScrollbarState extends State<DateScrollbar> {
  // UI state
  bool _isScrolling = false;
  bool _isDragging = false;

  // Position tracking
  double _dragPosition = 0.0;
  double _currentScrollPosition = 0.0;
  DateTime? _currentDate;

  // Constants
  static const Duration _hideDelay = Duration(milliseconds: 1500);
  static const Duration _scrollEndDelay = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _attachScrollListeners();
  }

  @override
  void didUpdateWidget(DateScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update if dates list changed (game list extended/modified)
    if (_shouldUpdateScrollPosition(oldWidget)) {
      _scheduleScrollPositionUpdate();
      // Also trigger immediate update if scroll controller has clients
      if (widget.scrollController.hasClients) {
        _updateScrollPosition();
      }
    }
  }

  @override
  void dispose() {
    _detachScrollListeners();
    super.dispose();
  }

  // Lifecycle Methods
  void _attachScrollListeners() {
    widget.scrollController.addListener(_onScroll);
    widget.scrollController.addListener(_updateScrollPosition);
  }

  void _detachScrollListeners() {
    widget.scrollController.removeListener(_onScroll);
    widget.scrollController.removeListener(_updateScrollPosition);
  }

  bool _shouldUpdateScrollPosition(DateScrollbar oldWidget) {
    // Update if dates list length changed or content changed
    return oldWidget.dates.length != widget.dates.length ||
        !_listsEqual(oldWidget.dates, widget.dates);
  }

  bool _listsEqual(List<DateTime> oldDates, List<DateTime> newDates) {
    if (oldDates.length != newDates.length) return false;
    for (int i = 0; i < oldDates.length; i++) {
      if (oldDates[i] != newDates[i]) return false;
    }
    return true;
  }

  void _scheduleScrollPositionUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateScrollPosition();
        // Force a rebuild to reflect the new dates
        setState(() {});
      }
    });
  }

  // Scroll Event Handlers
  void _onScroll() {
    if (_isScrolling) return;

    setState(() => _isScrolling = true);

    Future.delayed(_hideDelay, () {
      if (mounted) setState(() => _isScrolling = false);
    });
  }

  void _updateScrollPosition() {
    if (!_hasValidScrollContext()) return;

    final position = widget.scrollController.position;
    final percentage = _calculateScrollPercentage(position);

    if (mounted) {
      setState(() {
        _currentScrollPosition = percentage;
        if (_isScrolling && !_isDragging) {
          _updateCurrentDateFromScroll();
        }
      });
    }
  }

  // Position Calculations
  bool _hasValidScrollContext() {
    if (!widget.scrollController.hasClients || widget.dates.isEmpty) {
      return false;
    }

    try {
      // Check if position is actually available and valid
      final position = widget.scrollController.position;
      return position.hasContentDimensions;
    } catch (e) {
      return false;
    }
  }

  double _calculateScrollPercentage(ScrollPosition position) {
    try {
      if (!position.hasContentDimensions) return 0.0;

      final maxExtent = position.maxScrollExtent;
      return maxExtent > 0
          ? (position.pixels / maxExtent).clamp(0.0, 1.0)
          : 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  DateTime? _getDateAtPosition(double position) {
    if (widget.dates.isEmpty) return null;

    final index = (position * widget.dates.length)
        .clamp(0, widget.dates.length - 1)
        .floor();
    return widget.dates[index];
  }

  void _updateCurrentDateFromScroll() {
    _currentDate = _getDateAtPosition(_currentScrollPosition);
    _dragPosition = _currentScrollPosition;
  }

  // Interaction Handlers

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final position =
        (details.localPosition.dy / constraints.maxHeight).clamp(0.0, 1.0);

    setState(() {
      _dragPosition = position;
      _currentDate = _getDateAtPosition(position);
    });

    _scrollToPosition(position);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isScrolling = true;
      _isDragging = true;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    Future.delayed(_scrollEndDelay, () {
      if (mounted) {
        setState(() {
          _isScrolling = false;
          _isDragging = false;
          _currentDate = null;
        });
      }
    });
  }

  void _scrollToPosition(double position) {
    if (!widget.scrollController.hasClients) return;

    final scrollPosition =
        position * widget.scrollController.position.maxScrollExtent;
    widget.scrollController.jumpTo(scrollPosition);
  }

  @override
  Widget build(BuildContext context) {
    // Don't show scrollbar if no dates
    if (widget.dates.isEmpty) return const SizedBox.shrink();

    // Check if content is actually scrollable - with proper null checks
    if (widget.scrollController.hasClients) {
      try {
        final position = widget.scrollController.position;
        if (position.maxScrollExtent <= 0) {
          return const SizedBox.shrink();
        }
      } catch (e) {
        // If position is not ready yet, show the scrollbar anyway
        // It will update once the position is available
      }
    }

    return Container(
      width: DateScrollbar.thumbWidth + 2,
      margin: const EdgeInsets.only(right: 4, top: 8, bottom: 8),
      child: LayoutBuilder(
        builder: (context, constraints) => _ScrollbarStack(
          constraints: constraints,
          isScrolling: _isScrolling,
          isDragging: _isDragging,
          dragPosition: _dragPosition,
          currentScrollPosition: _currentScrollPosition,
          currentDate: _currentDate,
          scrollController: widget.scrollController,
          onPanUpdate: _onPanUpdate,
          onPanStart: _onPanStart,
          onPanEnd: _onPanEnd,
        ),
      ),
    );
  }
}
