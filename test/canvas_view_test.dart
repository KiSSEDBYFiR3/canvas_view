import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:canvas_view/canvas_view.dart';

void main() {
  testWidgets('Finds children on canvas', (tester) async {
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
        widget: SizedBox(key: ValueKey('1'), child: child),
      ),
    );
    controller.addComponent(
      CanvasComponent(
        id: '2',
        position: Offset(280, 296),
        widget: SizedBox(key: ValueKey('3'), child: child),
      ),
    );
    controller.addComponent(
      CanvasComponent(
        id: '3',
        position: Offset(130, 145),
        widget: SizedBox(key: ValueKey('3'), child: child),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CanvasView(
            delegate: CanvasChildDelegate(
              children: controller.getAllComponents().values.toList(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Container), findsExactly(3));
  });
}
