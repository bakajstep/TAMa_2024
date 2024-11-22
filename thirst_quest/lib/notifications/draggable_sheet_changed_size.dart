import 'package:flutter/material.dart';

class DraggableSheetChangedSize extends Notification {
  final double newSize;

  DraggableSheetChangedSize({required this.newSize});
}