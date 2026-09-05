import 'package:flutter_test/flutter_test.dart';
import 'package:sereng/main.dart';

void main() {
  testWidgets('SERENG app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SerengApp());

    expect(find.text('SERENG'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
