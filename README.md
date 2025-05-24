<p align="center">
	<i>A lightweight Flutter wrapper to selectively absorb or allow gesture interactions</i>
</p>
<p align="center">
	<a href="https://pub.dev/packages/selective_gesture_wrapper" target="_blank"><img src="https://img.shields.io/pub/v/selective_gesture_wrapper.svg" alt="Pub Version"></a>
	<a href="https://github.com/sourabhappdev/selective_gesture_wrapper/actions" target="_blank"><img src="https://github.com/sourabhappdev/selective_gesture_wrapper/workflows/build/badge.svg" alt="Build Status"></a>
	<a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License"></a>
	<a href="https://flutter.dev" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Platform"></a>
</p>

---

# selective_gesture_wrapper

`selective_gesture_wrapper` is a simple but powerful widget that lets you selectively absorb gestures on parts of your widget tree. Perfect for editors, canvases, and tools where only selected items should respond to drag, scale, or tap events.

---

## 🚀 Features

- ✅ Conditionally absorb gesture events using a simple flag
- ✅ Works with `GestureDetector`, `Draggable`, `InteractiveViewer`, and more
- ✅ Lightweight and dependency-free
- ✅ Fully compatible with Flutter's rendering pipeline

---

## 🛠 Installation

```yaml
flutter pub add selective_gesture_wrapper
```

---

## 📦 Import

```dart
import 'package:selective_gesture_wrapper/selective_gesture_wrapper.dart';
```

---

## 🌍 Basic Usage

```dart
void main() {
  SelectiveGestureWrapper(
    absorbGestures: true, // or false to allow gestures
    child: GestureDetector(
      onTap: () => print("Tapped"),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
    ),
  );

}
```

---

## 💡 Basic Example

```dart
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
  Offset position = const Offset(50.0, 50.0);
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: SelectiveGestureWrapper(
        absorbGestures: !widget.isSelected,
        child: GestureDetector(
          onTap: widget.onSelect,
          onScaleUpdate: widget.isSelected
              ? (details) {
            setState(() {
              scale = details.scale;
              position += details.focalPointDelta;
            });
          }
              : null,
          child: Transform.scale(
            scale: scale,
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
    );
  }
}

```

---

## 📃 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT)

---

## ❤️ Contribute

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

GitHub → [https://github.com/sourabhappdev/selective_gesture_wrapper/tree/dev](https://github.com/sourabhappdev/selective_gesture_wrapper/tree/dev)

---
