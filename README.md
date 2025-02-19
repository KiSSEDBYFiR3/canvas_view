# CanvasView  

**CanvasView** is a Flutter widget that provides a bidirectional scrolling container for displaying multiple positioned widgets. It's designed to efficiently render and manage a large number of child components while allowing smooth panning and interaction.  

## Features  
- **Bidirectional Scrolling**: Navigate freely in both horizontal and vertical directions.  
- **Custom Positioning**: Precisely place widgets at any coordinate within the canvas.  
- **Efficient Rendering**: Optimized for handling multiple widgets with performance in mind.
  

[Example](https://github.com/user-attachments/assets/a243fc15-0a52-4c0c-a002-5a6a11bd2c8a)

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

## Use Cases  
- Infinite canvas applications  
- Custom diagram builders  
- Interactive maps  
- Flowchart editors  

## License  
This package is distributed under the MIT License.  
