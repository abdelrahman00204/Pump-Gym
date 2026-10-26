import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pump_gym/dummy_data/workout_history_dummy_data.dart';

class WorkoutReportPdf extends pw.StatelessWidget {
  WorkoutReportPdf();

  static const _downloadChannel = MethodChannel('pump_gym/pdf_download');

  static const _background = PdfColor.fromInt(0xff101112);
  static const _surface = PdfColor.fromInt(0xff1b1c1e);
  static const _accent = PdfColor.fromInt(0xffd6ff24);
  static const _foreground = PdfColor.fromInt(0xfff4f4f4);
  static const _muted = PdfColor.fromInt(0xff9297a0);
  static const _line = PdfColor.fromInt(0xff393b3e);

  static Future<void> download() async {
    final bytes = await generate();
    await _downloadChannel.invokeMethod<void>('downloadPdf', {
      'bytes': bytes,
      'fileName': 'PUMP_GYM_30_DAY_PERFORMANCE_REPORT.pdf',
    });
  }

  static Future<Uint8List> generate() async {
    final document = pw.Document();
    document.addPage(
      pw.Page(
        // The report draws its own border and padding, so the page itself has
        // no white margins around it.
        pageFormat: PdfPageFormat.a4.copyWith(
          marginLeft: 0,
          marginTop: 0,
          marginRight: 0,
          marginBottom: 0,
        ),
        build: (_) => WorkoutReportPdf(),
      ),
    );
    return document.save();
  }

  @override
  pw.Widget build(pw.Context context) {
    final today = DateTime.now();
    final generatedDate = '${today.month.toString().padLeft(2, '0')}/'
        '${today.day.toString().padLeft(2, '0')}/'
        '${today.year}';

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _background,
        border: pw.Border.all(color: _accent, width: 1),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      padding: const pw.EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'PUMP ',
                      style: pw.TextStyle(
                        color: _foreground,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.TextSpan(
                      text: 'GYM OS',
                      style: pw.TextStyle(
                        color: _accent,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Text(
                '30-DAY PERFORMANCE CERTIFICATE',
                style: const pw.TextStyle(
                  color: _muted,
                  fontSize: 5.5,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Container(height: 0.7, color: _line),
          pw.SizedBox(height: 11),
          pw.Text(
            workoutHistoryProfileDummyData.name,
            style: pw.TextStyle(
              color: _foreground,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            '${workoutHistoryProfileDummyData.rank} - '
            'Level ${workoutHistoryProfileDummyData.level} - '
            '${workoutHistoryProfileDummyData.experiencePoints} XP',
            style: const pw.TextStyle(color: _muted, fontSize: 7.5),
          ),
          pw.SizedBox(height: 11),
          pw.Row(
            children: [
              _metric(
                workoutHistoryStatsDummyData[0].value,
                workoutHistoryStatsDummyData[0].label,
              ),
              pw.SizedBox(width: 5),
              _metric(
                workoutHistoryStatsDummyData[1].value,
                workoutHistoryStatsDummyData[1].label,
              ),
              pw.SizedBox(width: 5),
              _metric(
                workoutHistoryStatsDummyData[2].value,
                workoutHistoryStatsDummyData[2].label,
              ),
              pw.SizedBox(width: 5),
              _metric(
                workoutHistoryStatsDummyData[3].value,
                'PRS',
              ),
            ],
          ),
          pw.SizedBox(height: 11),
          pw.Text(
            'Best day: $workoutHistoryBestDayDummyData - '
            '${_formatVolume(workoutHistoryDaysDummyData[12].volumeLbs)} lbs | '
            'Longest streak: $workoutHistoryLongestStreakDummyData days',
            style: const pw.TextStyle(color: _muted, fontSize: 6.5),
          ),
          pw.SizedBox(height: 11),
          pw.Text(
            'DAILY LOG',
            style: pw.TextStyle(
              color: _accent,
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          pw.SizedBox(height: 5),
          _tableHeader(),
          for (var index = 0;
              index < workoutHistoryDaysDummyData.length;
              index++)
            _tableRow(index + 1, workoutHistoryDaysDummyData[index]),
          pw.Spacer(),
          pw.Container(height: 0.7, color: _line),
          pw.SizedBox(height: 7),
          pw.Text(
            'GENERATED BY PUMP GYM OS - $generatedDate',
            style: const pw.TextStyle(
              color: _muted,
              fontSize: 5.5,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _metric(String value, String label) {
    return pw.Expanded(
      child: pw.Container(
        height: 38,
        decoration: pw.BoxDecoration(
          color: _surface,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(
                color: _accent,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              label,
              style: const pw.TextStyle(color: _muted, fontSize: 4.5),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _tableHeader() => pw.Container(
        padding: const pw.EdgeInsets.fromLTRB(3, 0, 3, 4),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _line, width: 0.6)),
        ),
        child: pw.Row(
          children: [
            _tableCell('Day', flex: 2, header: true),
            _tableCell('Workout', flex: 5, header: true),
            _tableCell('Intensity', flex: 4, header: true),
            _tableCell('Volume', flex: 3, header: true, alignRight: true),
          ],
        ),
      );

  static pw.Widget _tableRow(int day, WorkoutHistoryDayDummyData workout) =>
      pw.Container(
        // Give the 30 daily entries enough height to fill the report page.
        height: 20,
        padding: const pw.EdgeInsets.symmetric(horizontal: 3),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _line, width: 0.45)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            _tableCell('Day $day', flex: 2),
            _tableCell(workout.workout, flex: 5),
            _tableCell(_formatIntensity(workout.intensity), flex: 4),
            _tableCell(
              '${_formatVolume(workout.volumeLbs)} lbs',
              flex: 3,
              alignRight: true,
            ),
          ],
        ),
      );

  static String _formatVolume(int volume) => volume.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );

  static String _formatIntensity(WorkoutIntensity intensity) {
    final label = intensity.name;
    return '${label[0].toUpperCase()}${label.substring(1)}';
  }

  static pw.Widget _tableCell(
    String text, {
    required int flex,
    bool header = false,
    bool alignRight = false,
  }) =>
      pw.Expanded(
        flex: flex,
        child: pw.Text(
          text,
          textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
          maxLines: 1,
          style: pw.TextStyle(
            color: header ? _muted : _foreground,
            fontSize: header ? 6 : 6.1,
            fontWeight: header || text.startsWith('Day ')
                ? pw.FontWeight.bold
                : pw.FontWeight.normal,
          ),
        ),
      );
}
