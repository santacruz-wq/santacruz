import 'package:flutter_test/flutter_test.dart';

import 'package:santa_cruz_de_la_plazuela/main.dart';

void main() {
  testWidgets(
    'La aplicación inicia correctamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(MyApp), findsOneWidget);
    },
  );
}