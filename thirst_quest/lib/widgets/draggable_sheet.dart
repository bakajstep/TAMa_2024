import 'package:flutter/material.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/controllers/draggable_sheet_child_controller.dart';
import 'package:thirst_quest/notifications/draggable_sheet_changed_size.dart';
import 'package:thirst_quest/utils/double_equals.dart';

class DraggableSheet extends StatefulWidget {
  final DraggableScrollableController controller;
  final List<double> snapSizes;
  final double initialSize;
  final Widget Function(DraggableSheetChildController childController, ScrollController scrollController) child;

  const DraggableSheet({required this.controller, required this.snapSizes, required this.initialSize, required this.child, super.key});

  @override
  DraggableSheetState createState() => DraggableSheetState();

  static void animateSheet(DraggableScrollableController controller, double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class DraggableSheetState extends State<DraggableSheet> {
  final DraggableSheetChildController _childController = DraggableSheetChildController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = widget.controller.size;
    if (doubleInList(widget.snapSizes, currentSize)) { 
      if (!doubleEquals(currentSize, widget.initialSize)) {
        DraggableSheetChangedSize(newSize: currentSize).dispatch(context);
        _childController.onHeightChanged!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.0,
      maxChildSize: constants.bigInfoCardHeight,
      minChildSize: 0.0,
      expand: true,
      snap: true,
      snapSizes: widget.snapSizes,
      snapAnimationDuration: const Duration(milliseconds: 500),
      controller: widget.controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: widget.child(_childController, scrollController),
        );
      },
    );
  }
}