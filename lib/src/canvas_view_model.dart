import 'package:canvas_view/src/canvas_component.dart';
import 'package:flutter/widgets.dart';

/// Controller to help modify Canvas's and its children's state
class CanvasController<T extends CanvasComponent> extends ChangeNotifier {
  final Map<String, T> _components = {};

  double get scale => _scale;
  double _scale = 1.0;

  set scale(double scale) {
    _scale = scale;
    notifyListeners();
  }

  Map<String, T> getAllComponents() => Map<String, T>.from(_components);

  void updateComponentWithId(String id, {Offset? offset, Offset? delta}) {
    final component = _components[id];
    if (component == null) return;

    bool needUpdate = false;

    if (offset != null) {
      component.position = offset;
      needUpdate = true;
    }

    if (delta != null) {
      component.position += delta;
      needUpdate = true;
    }

    if (needUpdate) {
      notifyListeners();
    }
  }

  void addComponent(T component) {
    _components.addAll({component.id: component});
    notifyListeners();
  }

  void removeComponentWithId(String id) {
    final res = _components.remove(id);

    if (res != null) {
      notifyListeners();
    }
  }
}
