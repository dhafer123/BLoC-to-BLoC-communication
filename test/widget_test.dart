import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_to_bloc/app.dart';
import 'package:bloc_to_bloc/core/di/injection.dart';

void main() {
  testWidgets('renders the Shelf catalog', (tester) async {
    configureDependencies();
    await tester.pumpWidget(const ShelfApp());
    await tester.pump();

    expect(find.text('SHELF'), findsOneWidget);
    expect(find.text('Find your next\nsmall obsession.'), findsOneWidget);
  });
}
