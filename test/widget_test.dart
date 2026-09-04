// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:http_status_guide/data/repositories/status_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled HTTP status code data', () async {
    final repository = StatusRepository();

    final codes = await repository.getAllCodes();

    expect(codes, isNotEmpty);
    expect(codes.any((code) => code.code == 200), isTrue);
  });
}
