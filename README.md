# CanvasView  

**CanvasView** is a Flutter widget that provides a bidirectional scrolling container for displaying multiple positioned widgets. It's designed to efficiently render and manage a large number of child components while allowing smooth panning and interaction.  

## Features  
- **Bidirectional Scrolling**: Navigate freely in both horizontal and vertical directions.  
- **Custom Positioning**: Precisely place widgets at any coordinate within the canvas.  
- **Efficient Rendering**: Optimized for handling multiple widgets with performance in mind.  


## Installation  
Add **CanvasView** to your `pubspec.yaml`:  
```yaml
dependencies:
  canvas_view: 1.0.0
```  
Run `flutter pub get` to fetch the package.  

## Usage  
A simple example of how to use **CanvasView**:  
```dart
CanvasView(
  diagonalDragBehavior: DiagonalDragBehavior.free,
  delegate: CanvasChildDelegate(children: children),
)
```  

Where `children` is a list of `CanvasComponent`:  
```dart
final List<CanvasComponent> children = [
  CanvasComponent(
    id: 'widget1',
    position: Offset(100, 200),
    widget: YourCustomWidget(),
  ),
];
```  

## Customization  
- **`CanvasChildDelegate`**: Manages the layout of positioned children.  
- **`CanvasComponent`**: Represents an individual item with an `id`, `position`, and `widget`.  

## Use Cases  
- Infinite canvas applications  
- Custom diagram builders  
- Interactive maps  
- Flowchart editors  

## License  
This package is distributed under the MIT License.  