import 'package:flutter/material.dart';
import 'package:selective_gesture_wrapper/selective_gesture_wrapper.dart';

void main() => runApp(const MaterialApp(home: EditorPage()));

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(3, (index) {
          return SelectableDraggableWidget(
            key: ValueKey(index),
            id: index,
            isSelected: selectedId == index,
            onSelect: () => setState(() => selectedId = index),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.primaries[index],
              child: Center(child: Text('Box $index')),
            ),
          );
        }),
      ),
    );
  }
}

class SelectableDraggableWidget extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onSelect;
  final int id;

  const SelectableDraggableWidget({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onSelect,
    required this.id,
  });

  @override
  State<SelectableDraggableWidget> createState() =>
      _SelectableDraggableWidgetState();
}

class _SelectableDraggableWidgetState extends State<SelectableDraggableWidget> {
  Offset position = const Offset(50, 50);
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    // We wrap with Positioned to control position on screen
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Stack(
        children: [
          // This GestureDetector is for selection tap, covers the entire widget area including scale
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onSelect,
            child: SizedBox(
              width: 100 * scale,
              height: 100 * scale,
            ),
          ),
          // This wrapper controls whether gestures inside are absorbed or passed
          SelectiveGestureWrapper(
            absorbGestures: !widget.isSelected, // absorb gestures when NOT selected
            child: GestureDetector(
              onScaleStart: widget.isSelected ? (_) {} : null,
              onScaleUpdate: widget.isSelected
                  ? (details) {
                setState(() {
                  scale = details.scale.clamp(0.5, 3.0);
                  position += details.focalPointDelta;
                });
              }
                  : null,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: widget.isSelected
                        ? Border.all(color: Colors.blue, width: 3)
                        : null,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
