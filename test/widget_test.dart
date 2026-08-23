import 'package:flutter_test/flutter_test.dart';
import 'package:sereng/main.dart';

void main() {
  testWidgets('Sereng app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SerengApp());

    expect(find.text('Recently Played'), findsOneWidget);
    expect(find.text('Midnight'), findsOneWidget);
    expect(find.text('Dreamscape'), findsOneWidget);
  });
}
