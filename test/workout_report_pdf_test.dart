import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_gym/widgets/workout_report_pdf.dart';

void main() {
  test('generates a 30-day workout report PDF', () async {
    final bytes = await WorkoutReportPdf.generate();

    expect(utf8.decode(bytes.take(4).toList()), '%PDF');
    expect(bytes.length, greaterThan(1000));
  });
}
