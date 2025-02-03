import 'dart:html' as html;
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../models/quiz_score_model.dart';

class ReportController {
  Future<void> generateAndDownloadPDF(List<QuizScoreModel> scores) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();

    final theme = _ReportTheme(
      primaryColor: PdfColors.blue700,
      secondaryColor: PdfColor.fromHex('#2d9cdb'),
      accentColor: PdfColor.fromHex('#27ae60'),
      backgroundColor: PdfColors.white,
      textColor: PdfColors.grey800,
      boldFont: boldFont,
      baseFont: font,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _buildPageTheme(theme),
        header: (context) => _buildHeader(theme),
        footer: (context) => _buildFooter(context, theme),
        build: (context) => [
          _buildSummarySection(scores, theme),
          _buildPerformanceInsights(scores, theme),
          _buildDetailedAnalysis(scores, theme),
        ],
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    _downloadPDF(pdfBytes);
  }

  void _downloadPDF(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download =
          'Quiz_Report_${DateFormat('yyyy_MM_dd').format(DateTime.now())}.pdf';

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  pw.PageTheme _buildPageTheme(_ReportTheme theme) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(font: theme.baseFont, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildHeader(_ReportTheme theme) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 24),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Math Quiz Performance Report',
                  style: pw.TextStyle(
                    font: theme.boldFont,
                    fontSize: 20,
                    color: theme.primaryColor,
                  )),
              pw.Text('Class 10 Mathematics - Semester 1',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: theme.textColor,
                  )),
            ],
          ),
          pw.BarcodeWidget(
            data: 'Quiz-${DateFormat('yyyyMMdd').format(DateTime.now())}',
            barcode: pw.Barcode.qrCode(),
            width: 60,
            height: 60,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummarySection(
      List<QuizScoreModel> scores, _ReportTheme theme) {
    final metrics = _calculateMetrics(scores);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Key Performance Indicators', theme),
        pw.GridView(
          crossAxisCount: 4,
          childAspectRatio: 1.2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildKpiTile('Total Students', scores.length.toString(),
                theme.primaryColor, theme),
            _buildKpiTile('Average Score', '${metrics.averageScore}%',
                theme.secondaryColor, theme),
            _buildKpiTile('Highest Score', '${metrics.highestScore}%',
                theme.accentColor, theme),
            _buildKpiTile(
                'Pass Rate', '${metrics.passRate}%', theme.primaryColor, theme),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 3,
              child: _buildScoreDistributionChart(scores, theme),
            ),
            pw.Expanded(
              flex: 2,
              child: _buildPerformanceGauge(metrics, theme),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPerformanceInsights(
      List<QuizScoreModel> scores, _ReportTheme theme) {
    final categoryStats = _calculateCategoryStats(scores);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Topic Performance Analysis', theme),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 2,
              child: _buildCategoryTable(categoryStats, theme),
            ),
            pw.Expanded(
              flex: 1,
              child: _buildTopPerformerCard(scores, theme),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDetailedAnalysis(
      List<QuizScoreModel> scores, _ReportTheme theme) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Detailed Student Results', theme),
        _buildStudentResultsTable(scores, theme),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title, _ReportTheme theme) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 15),
      decoration: pw.BoxDecoration(
        border:
            pw.Border(left: pw.BorderSide(color: theme.primaryColor, width: 3)),
      ),
      padding: const pw.EdgeInsets.only(left: 10),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          font: theme.boldFont,
          fontSize: 14,
          color: theme.textColor,
        ),
      ),
    );
  }

  pw.Widget _buildKpiTile(
      String title, String value, PdfColor color, _ReportTheme theme) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _withOpacity(color, 0.1),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: color, width: 1),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(value,
              style: pw.TextStyle(
                font: theme.boldFont,
                fontSize: 18,
                color: color,
              )),
          pw.SizedBox(height: 5),
          pw.Text(title,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              )),
        ],
      ),
    );
  }

  pw.Widget _buildScoreDistributionChart(
      List<QuizScoreModel> scores, _ReportTheme theme) {
    final distribution = _calculateScoreDistribution(scores);

    return pw.Container(
      height: 200,
      child: pw.Chart(
        title: pw.Text('Score Distribution',
            style: pw.TextStyle(fontSize: 14, font: theme.boldFont)),
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis(
            distribution.map((d) => d.scoreRange.toDouble()).toList(),
            marginStart: 30,
            marginEnd: 30,
          ),
          yAxis: pw.FixedAxis(
            [0, 5, 10, 15, 20],
            textStyle: const pw.TextStyle(fontSize: 10),
          ),
        ),
        datasets: [
          pw.BarDataSet(
            color: theme.secondaryColor,
            data: distribution
                .map((d) => pw.PointChartValue(
                      d.scoreRange.toDouble(),
                      d.count.toDouble(),
                    ))
                .toList(),
            borderWidth: 20,
            axis: pw.Axis.horizontal,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPerformanceGauge(_Metrics metrics, _ReportTheme theme) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Stack(
        children: [
          pw.Center(
            child: pw.Text('${metrics.averageScore.toStringAsFixed(1)}%',
                style: pw.TextStyle(
                  font: theme.boldFont,
                  fontSize: 24,
                  color: theme.primaryColor,
                )),
          ),
          // Placeholder for PieChart
          pw.Container(
            width: 120,
            height: 120,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: theme.accentColor,
            ),
            child: pw.Center(
              child: pw.Text(
                '${metrics.averageScore.toStringAsFixed(1)}%',
                style: pw.TextStyle(
                  font: theme.boldFont,
                  fontSize: 24,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCategoryTable(
      Map<String, _CategoryStats> stats, _ReportTheme theme) {
    return pw.TableHelper.fromTextArray(
      headerDecoration: pw.BoxDecoration(
        color: theme.primaryColor,
        borderRadius:
            const pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
      ),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 12,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: pw.TextStyle(fontSize: 10, color: theme.textColor),
      headers: ['Category', 'Quizzes', 'Avg Score', 'Pass Rate'],
      data: stats.entries
          .map((e) => [
                e.key,
                e.value.quizCount.toString(),
                '${e.value.averageScore.toStringAsFixed(1)}%',
                '${e.value.passRate.toStringAsFixed(1)}%',
              ])
          .toList(),
    );
  }

  pw.Widget _buildTopPerformerCard(
      List<QuizScoreModel> scores, _ReportTheme theme) {
    final topScore = scores.reduce(
        (a, b) => (a.score / a.totalScore) > (b.score / b.totalScore) ? a : b);

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _withOpacity(theme.accentColor, 0.1),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: theme.accentColor),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Top Performer',
              style: pw.TextStyle(
                font: theme.boldFont,
                color: theme.accentColor,
                fontSize: 14,
              )),
          pw.Divider(color: theme.accentColor),
          pw.SizedBox(height: 8),
          pw.Text(topScore.userName ?? 'N/A',
              style: pw.TextStyle(fontSize: 12, font: theme.boldFont)),
          pw.Text(
              'Score: ${((topScore.score / topScore.totalScore) * 100).toStringAsFixed(1)}%',
              style: pw.TextStyle(fontSize: 10)),
          pw.Text('Category: ${topScore.categoryName ?? 'N/A'}',
              style: pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildStudentResultsTable(
      List<QuizScoreModel> scores, _ReportTheme theme) {
    return pw.TableHelper.fromTextArray(
      headerDecoration: pw.BoxDecoration(
        color: theme.primaryColor,
        borderRadius:
            const pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
      ),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: pw.TextStyle(fontSize: 10, color: theme.textColor),
      headers: ['Student', 'Category', 'Quiz', 'Score (%)', 'Date'],
      data: scores
          .map((score) => [
                score.userName ?? '-',
                score.categoryName ?? '-',
                score.quizTitle ?? '-',
                ((score.score / score.totalScore) * 100).toStringAsFixed(1),
                DateFormat('MMM dd').format(score.createdAt ?? DateTime.now()),
              ])
          .toList(),
    );
  }

  pw.Widget _buildFooter(pw.Context context, _ReportTheme theme) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Generated by QuizMaster Pro',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  PdfColor _withOpacity(PdfColor baseColor, double opacity) {
    final alpha = (opacity.clamp(0.0, 1.0) * 255).round();
    return PdfColor.fromInt((alpha << 24) |
        (baseColor.red.toInt() << 16) |
        (baseColor.green.toInt() << 8) |
        baseColor.blue.toInt());
  }

  _Metrics _calculateMetrics(List<QuizScoreModel> scores) {
    if (scores.isEmpty) return _Metrics(0, 0, 0, 0);

    final total = scores.length;
    final average = scores
            .map((s) => (s.score / s.totalScore) * 100)
            .reduce((a, b) => a + b) /
        total;
    final passRate =
        scores.where((s) => (s.score / s.totalScore) * 100 >= 60).length /
            total *
            100;
    final highest = scores
        .map((s) => (s.score / s.totalScore) * 100)
        .reduce((a, b) => a > b ? a : b);
    final averageTotal =
        scores.map((s) => s.totalScore).reduce((a, b) => a + b) / total;

    return _Metrics(average, passRate, highest, averageTotal);
  }

  List<_ScoreRange> _calculateScoreDistribution(List<QuizScoreModel> scores) {
    final distribution = <int, int>{};
    for (var score in scores) {
      final range = ((score.score / score.totalScore) * 100 ~/ 20) * 20;
      distribution[range] = (distribution[range] ?? 0) + 1;
    }
    return [0, 20, 40, 60, 80]
        .map((r) => _ScoreRange(r, distribution[r] ?? 0))
        .toList();
  }

  Map<String, _CategoryStats> _calculateCategoryStats(
      List<QuizScoreModel> scores) {
    final stats = <String, _CategoryStats>{};
    for (var score in scores) {
      final category = score.categoryName ?? 'Uncategorized';
      stats.putIfAbsent(category, () => _CategoryStats());
      final percentage = (score.score / score.totalScore) * 100;
      stats[category]!.quizCount++;
      stats[category]!.totalScore += percentage;
      if (percentage >= 60) stats[category]!.passCount++;
    }
    return stats;
  }
}

class _ReportTheme {
  final PdfColor primaryColor;
  final PdfColor secondaryColor;
  final PdfColor accentColor;
  final PdfColor backgroundColor;
  final PdfColor textColor;
  final pw.Font? boldFont;
  final pw.Font? baseFont;

  _ReportTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    this.boldFont,
    this.baseFont,
  });
}

class _Metrics {
  final double averageScore;
  final double passRate;
  final double highestScore;
  final double averageTotalScore;

  _Metrics(this.averageScore, this.passRate, this.highestScore,
      this.averageTotalScore);
}

class _ScoreRange {
  final int scoreRange;
  final int count;

  _ScoreRange(this.scoreRange, this.count);
}

class _CategoryStats {
  int quizCount = 0;
  double totalScore = 0;
  int passCount = 0;

  double get averageScore => quizCount == 0 ? 0 : totalScore / quizCount;
  double get passRate => quizCount == 0 ? 0 : (passCount / quizCount) * 100;
}
