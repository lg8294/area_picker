import 'package:area_picker/src/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});
  testWidgets('load data', (WidgetTester tester) async {
    final data = loadData();
    print(data.map((e) => e.toJson()).toList());
  });
}
