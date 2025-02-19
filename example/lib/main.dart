import 'package:canvas_view/canvas_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CanvasView Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'CanvasView Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = CanvasController();
    final child = Container(
      color: Colors.red,
      height: 200,
      width: 200,
      child: Center(child: Text('0')),
    );

    controller.addComponent(
      CanvasComponent(
        id: '1',
        position: Offset(10, 15),
        widget: Draggable(
          onDragUpdate: (details) {
            controller.updateComponentWithId('1', delta: details.delta);
          },
          feedback: SizedBox.shrink(),
          child: child,
        ),
      ),
    );
    controller.addComponent(
      CanvasComponent(
        id: '2',
        position: Offset(280, 296),
        widget: Draggable(
          onDragUpdate: (details) {
            controller.updateComponentWithId('2', delta: details.delta);
          },
          feedback: SizedBox.shrink(),
          child: child,
        ),
      ),
    );
    controller.addComponent(
      CanvasComponent(
        id: '3',
        position: Offset(130, 145),
        widget: Draggable(
          onDragUpdate: (details) {
            controller.updateComponentWithId('3', delta: details.delta);
          },
          feedback: SizedBox.shrink(),
          child: child,
        ),
      ),
    );
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final children = controller.getAllComponents().values.toList();

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: GestureDetector(
            onScaleUpdate: (details) {
              controller.scale = details.scale;
            },
            child: Transform.scale(
              scale: controller.scale,
              child: CanvasView(
                diagonalDragBehavior: DiagonalDragBehavior.free,
                delegate: CanvasChildDelegate(children: children),
              ),
            ),
          ),
        );
      },
    );
  }
}
