import 'dart:html' as html;
import 'dart:typed_data';

import 'package:dashboard/features/quizes/models/quizes_models.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import '../models/quiz_score_model.dart';

class QuizReportController {
  // Existing code...
  final PdfColor _primaryColor = PdfColor.fromHex('#2A4C7D');
  final PdfColor _secondaryColor = PdfColor.fromHex('#4A90E2');
  final PdfColor _accentColor = PdfColor.fromHex('#FF6B6B');
  final PdfColor _successColor = PdfColor.fromHex('#4CAF50');
  final PdfColor _backgroundLight = PdfColor.fromHex('#F8F9FA');
  Future<void> generateQuizReport({
    required QuizModel quiz,
    required List<QuizScoreModel> quizScores, // Scores for this quiz
  }) async {
    final metrics = _calculatePerformanceMetrics(quizScores);
    final pdf = pw.Document(
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(
          fontSize: 12,
          color: PdfColors.grey800,
        ),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(42),
        build: (context) => [
          _buildQuizHeader(quiz),
          _buildQuizInfo(quiz),
          _buildQuizPerformanceHighlights(quizScores),
          _buildRadialGauges(metrics),
          // _buildQuizOverview(quiz),
          _buildTopPerformers(quizScores),
          _buildQuizPerformanceCards(quizScores),
          _buildQuizDetailedStats(quizScores),
        ],
        footer: _buildFooter,
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    _downloadPDF(pdfBytes, 'Quiz_Report_${quiz.title}.pdf');
  }

  pw.Widget _buildQuizHeader(QuizModel quiz) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _primaryColor,
        borderRadius:
            const pw.BorderRadius.vertical(top: pw.Radius.circular(8)),
      ),
      padding: const pw.EdgeInsets.all(24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Quiz Performance Report',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuizInfo(
    QuizModel quiz,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Quiz Information',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.grey200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text('Name: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(quiz.title),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Text('Category: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(quiz.categoryName!),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Divider(),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _buildProfileItem(
                        'Total Time', "${quiz.timer.toString()} mins" ?? 'N/A'),
                    _buildProfileItem('Sharable Code',
                        quiz.shareableCode.toString() ?? 'N/A'),
                    _buildProfileItem(
                        'Total Questions', quiz.description.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildProfileItem(String title, String value) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.grey600,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey200)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by LQlogic',
            style: pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 10,
            ),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuizOverview(QuizScoreModel quiz) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Quiz Overview',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.grey200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text('Total Questions: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${quiz.totalScore}'),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Text('Average Score: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        '${(quiz.score / quiz.totalScore * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Text('Time Taken: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${quiz.timeTaken}s'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuizPerformanceHighlights(List<QuizScoreModel> scores) {
    final totalUsers = scores.length;
    final averageScore =
        scores.fold(0, (sum, score) => sum + score.score) / totalUsers;
    final accuracy = scores.fold(0.0,
            (double sum, score) => sum + (score.score / score.totalScore)) /
        totalUsers *
        100;
    final averageTimeTaken =
        scores.fold(0, (sum, score) => sum + score.timeTaken) / totalUsers;

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Performance Highlights',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildHighlightCard('Total Participant', '$totalUsers'),
              _buildHighlightCard(
                  'Average Score', '${averageScore.toStringAsFixed(1)}%'),
              _buildHighlightCard(
                  'Avg. Time', '${averageTimeTaken.toStringAsFixed(1)}s'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHighlightCard(
    String title,
    String value,
  ) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 12,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuizPerformanceCards(List<QuizScoreModel> scores) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Quiz Performance Breakdown',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          ...scores.map((score) {
            final totalQuestions = score.totalScore;
            final correctAnswers = score.score;
            final incorrectAnswers = score.incorrectAnswers;
            final skippedQuestions =
                totalQuestions - (correctAnswers + incorrectAnswers);
            final performance = (correctAnswers / totalQuestions) * 100;
            final accuracy =
                (correctAnswers / (correctAnswers + incorrectAnswers)) * 100;
            final passFailStatus = performance >= 70 ? 'Pass' : 'Fail';
            final formattedDate = score.createdAt != null
                ? '${score.createdAt!.day}/${score.createdAt!.month}/${score.createdAt!.year}'
                : 'N/A';
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header section
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: const pw.BorderRadius.vertical(
                        top: pw.Radius.circular(8),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                score.userName ?? 'Unknown User',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.blue900,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'Attempted: $formattedDate',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.grey700,
                                  fontStyle: pw.FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: pw.BoxDecoration(
                            color: passFailStatus == 'Pass'
                                ? PdfColors.green100
                                : PdfColors.red100,
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(12),
                            ),
                          ),
                          child: pw.Text(
                            passFailStatus,
                            style: pw.TextStyle(
                              color: passFailStatus == 'Pass'
                                  ? PdfColors.green700
                                  : PdfColors.red700,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stats section
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                                'Total Questions', '$totalQuestions'),
                            _buildStatItem(
                                'Correct Answers', '$correctAnswers'),
                            _buildStatItem('Incorrect', '$incorrectAnswers'),
                            _buildStatItem('Skipped', '$skippedQuestions'),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem('Final Score',
                                '${performance.toStringAsFixed(1)}%'),
                            _buildStatItem(
                                'Accuracy', '${accuracy.toStringAsFixed(1)}%'),
                            _buildStatItem('Time Taken', '${score.timeTaken}s'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  pw.Widget _buildStatItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTopPerformers(List<QuizScoreModel> scores) {
    final topPerformers = scores
        .where((score) => (score.score / score.totalScore) >= 0.8)
        .take(5)
        .toList();

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Top Performers',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          ...topPerformers
              .map((score) => _buildUserPerformanceCard(score))
              .toList(),
        ],
      ),
    );
  }

  pw.Widget _buildUserPerformanceCard(QuizScoreModel score) {
    final performance = (score.score / score.totalScore) * 100;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'User: ${score.userName ?? 'N/A'}',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Score: ${score.score}/${score.totalScore}'),
              pw.Text('Performance: ${performance.toStringAsFixed(1)}%'),
              pw.Text('Time Taken: ${score.timeTaken}s'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuizDetailedStats(List<QuizScoreModel> scores) {
    if (scores.isEmpty) return pw.SizedBox();

    // Calculate statistics
    final totalAttempts = scores.length;
    final passCount =
        scores.where((s) => (s.score / s.totalScore) * 100 >= 70).length;
    final passRate = (passCount / totalAttempts) * 100;
    final averageScore = scores.fold(
            0.0, (double sum, s) => sum + (s.score / s.totalScore * 100)) /
        totalAttempts;
    final highestScore = scores.fold(
        0,
        (max, s) => (s.score / s.totalScore * 100).toInt() > max
            ? (s.score / s.totalScore * 100).toInt()
            : max);
    final lowestScore = scores.fold(
        double.infinity,
        (min, s) => (s.score / s.totalScore * 100) < min
            ? (s.score / s.totalScore * 100)
            : min);
    final averageTime =
        scores.fold(0, (sum, s) => sum + s.timeTaken) / totalAttempts;
    final totalCorrect = scores.fold(0, (sum, s) => sum + s.score);
    final totalIncorrect = scores.fold(0, (sum, s) => sum + s.incorrectAnswers);
    final totalSkipped = scores.fold(
        0, (sum, s) => sum + (s.totalScore - s.score - s.incorrectAnswers));

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Detailed Statistics',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              children: [
                // Pass Rate Progress Bar
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Pass Rate',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.blue900,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '${passRate.toStringAsFixed(1)}%',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: _getPerformanceColor(passRate),
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Container(
                      height: 16,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Stack(
                        children: [
                          pw.Container(
                            width: 400 * (passRate / 100),
                            decoration: pw.BoxDecoration(
                              color: _getPerformanceColor(passRate),
                              borderRadius: pw.BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 16),
                  ],
                ),
                // First Row of Stats
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBox(
                      'Total Attempts',
                      '$totalAttempts',
                      PdfColors.blue700,
                    ),
                    _buildStatBox(
                      'Average Score',
                      '${averageScore.toStringAsFixed(1)}%',
                      _getPerformanceColor(averageScore),
                    ),
                    _buildStatBox(
                      'Avg. Time',
                      '${averageTime.toStringAsFixed(0)}s',
                      PdfColors.grey700,
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                // Second Row of Stats
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBox(
                      'Highest Score',
                      '${highestScore.toStringAsFixed(1)}%',
                      PdfColors.green700,
                    ),
                    _buildStatBox(
                      'Lowest Score',
                      '${lowestScore.toStringAsFixed(1)}%',
                      PdfColors.red700,
                    ),
                    _buildStatBox(
                      'Passed/Total',
                      '$passCount/$totalAttempts',
                      PdfColors.grey700,
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                // Question Breakdown
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Question Breakdown',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.blue900,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuestionStat(
                            'Correct', totalCorrect, PdfColors.green700),
                        _buildQuestionStat(
                            'Incorrect', totalIncorrect, PdfColors.red700),
                        _buildQuestionStat(
                            'Skipped', totalSkipped, PdfColors.orange700),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildStatBox(String label, String value, PdfColor valueColor) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              color: valueColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuestionStat(String label, int value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Container(
          width: 60,
          height: 60,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
          ),
          child: pw.Center(
            child: pw.Text(
              '$value',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildRadialGauges(PerformanceMetrics metrics) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildRadialGauge(
                'Overall Progress',
                metrics.overallScore,
                _primaryColor,
              ),
              _buildRadialGauge(
                'Accuracy Rate',
                metrics.accuracy,
                _accentColor,
              ),
              _buildRadialGauge(
                'Incorrect Rate',
                metrics.incorrectRate,
                PdfColors.red400,
              ),
              _buildRadialGauge(
                'Skipped Rate',
                metrics.skippedRate,
                PdfColors.orange400,
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          _buildProgressSummary(metrics),
        ],
      ),
    );
  }

  pw.Widget _buildProgressSummary(PerformanceMetrics metrics) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Detailed Progress Summary',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Total Questions',
                '${metrics.totalQuizzes * 100}',
                PdfColors.blue700,
              ),
              _buildSummaryItem(
                'Correct Answers',
                '${(metrics.totalQuizzes * 100 - metrics.totalIncorrectAnswers - metrics.totalSkippedQuestions)}',
                PdfColors.green700,
              ),
              _buildSummaryItem(
                'Incorrect Answers',
                '${metrics.totalIncorrectAnswers}',
                PdfColors.red700,
              ),
              _buildSummaryItem(
                'Skipped Questions',
                '${metrics.totalSkippedQuestions}',
                PdfColors.orange700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildRadialGauge(String title, double value, PdfColor color) {
    return pw.Container(
      width: 140, // Reduced from 200
      height: 140, // Reduced from 200
      child: pw.Stack(
        alignment: pw.Alignment.center,
        children: [
          pw.Container(
            width: 120, // Reduced from 180
            height: 120, // Reduced from 180
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: PdfColors.grey50,
            ),
          ),
          pw.Transform.rotate(
            angle: -1.5708, // -90 degrees in radians
            child: pw.SizedBox(
              width: 110, // Reduced from 160
              height: 110, // Reduced from 160
              child: pw.CircularProgressIndicator(
                value: value / 100,
                backgroundColor: PdfColors.grey200,
                color: color,
                strokeWidth: 10, // Reduced from 12
              ),
            ),
          ),
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                '${value.toStringAsFixed(1)}%',
                style: pw.TextStyle(
                  fontSize: 18, // Reduced from 24
                  fontWeight: pw.FontWeight.bold,
                  color: color,
                ),
              ),
              pw.SizedBox(height: 2), // Reduced from 4
              pw.Text(
                title,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 10, // Reduced from 12
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PdfColor _getPerformanceColor(double value) {
    if (value >= 90) return PdfColors.green;
    if (value >= 80) return PdfColors.lightGreen;
    if (value >= 70) return PdfColors.yellow;
    if (value >= 60) return PdfColors.orange;
    return PdfColors.red;
  }

  PerformanceMetrics _calculatePerformanceMetrics(List<QuizScoreModel> scores) {
    if (scores.isEmpty) return PerformanceMetrics.empty();

    final totalQuizzes = scores.length;
    final totalCorrectAnswers =
        scores.fold(0, (sum, score) => sum + score.score);
    final totalQuestions =
        scores.fold(0, (sum, score) => sum + score.totalScore);
    final totalIncorrectAnswers =
        scores.fold(0, (sum, score) => sum + score.incorrectAnswers);

    // Calculate skipped questions
    final totalSkippedQuestions = scores.fold(
        0,
        (sum, score) =>
            sum + (score.totalScore - (score.score + score.incorrectAnswers)));

    final overallScore = (totalCorrectAnswers / totalQuestions) * 100;
    final accuracy =
        (totalCorrectAnswers / (totalCorrectAnswers + totalIncorrectAnswers)) *
            100;
    final incorrectRate = (totalIncorrectAnswers / totalQuestions) * 100;
    final skippedRate = (totalSkippedQuestions / totalQuestions) * 100;

    final averageTimeTaken =
        scores.map((s) => s.timeTaken).reduce((a, b) => a + b) / totalQuizzes;

    return PerformanceMetrics(
      totalQuizzes: totalQuizzes,
      overallScore: overallScore,
      accuracy: accuracy,
      averageTimeTaken: averageTimeTaken,
      incorrectRate: incorrectRate,
      skippedRate: skippedRate,
      totalIncorrectAnswers: totalIncorrectAnswers,
      totalSkippedQuestions: totalSkippedQuestions,
    );
  }

  void _downloadPDF(Uint8List pdfBytes, String fileName) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = fileName;

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}

class PerformanceMetrics {
  final int totalQuizzes;
  final double overallScore;
  final double accuracy;
  final double averageTimeTaken;

  final double incorrectRate; // New field
  final double skippedRate; // New field
  final int totalIncorrectAnswers; // New field
  final int totalSkippedQuestions; // New field

  PerformanceMetrics({
    required this.totalQuizzes,
    required this.overallScore,
    required this.accuracy,
    required this.averageTimeTaken,
    required this.incorrectRate,
    required this.skippedRate,
    required this.totalIncorrectAnswers,
    required this.totalSkippedQuestions,
  });

  factory PerformanceMetrics.empty() {
    return PerformanceMetrics(
      totalQuizzes: 0,
      overallScore: 0,
      accuracy: 0,
      averageTimeTaken: 0,
      incorrectRate: 0,
      skippedRate: 0,
      totalIncorrectAnswers: 0,
      totalSkippedQuestions: 0,
    );
  }
}
