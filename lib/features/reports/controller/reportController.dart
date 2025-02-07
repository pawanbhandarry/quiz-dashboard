import 'dart:html' as html;
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import '../../user/models/user_category_stats.dart';
import '../../user/models/user_models.dart';
import '../../user/models/user_performance_matrics.dart';
import '../models/quiz_score_model.dart';

class ReportController {
  final PdfColor _primaryColor = PdfColor.fromHex('#2A4C7D');
  final PdfColor _secondaryColor = PdfColor.fromHex('#4A90E2');
  final PdfColor _accentColor = PdfColor.fromHex('#FF6B6B');
  final PdfColor _successColor = PdfColor.fromHex('#4CAF50');
  final PdfColor _backgroundLight = PdfColor.fromHex('#F8F9FA');

  Future<void> generateStudentPerformanceReport({
    required UserModel student,
    required List<QuizScoreModel> quizScores,
  }) async {
    final limitedQuizScores = quizScores;
    final metrics = _calculatePerformanceMetrics(limitedQuizScores);

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
          _buildHeader(student),
          _buildStudentProfile(student, quizScores),
          _buildPerformanceHighlights(metrics),
          _buildRadialGauges(metrics),
          _buildTopPerfomersSection(metrics, quizScores),
          _buildQuizPerformanceCards(limitedQuizScores),
          _buildCategoryPerformance(limitedQuizScores),
          // _buildRecommendationsSection(metrics),
        ],
        footer: _buildFooter,
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    _downloadPDF(pdfBytes);
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

  pw.Widget _buildPerformanceHighlights(PerformanceMetrics metrics) {
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
              _buildHighlightCard(
                'Overall Score',
                '${metrics.overallScore.toStringAsFixed(1)}%',
              ),
              _buildHighlightCard(
                'Accuracy',
                '${metrics.accuracy.toStringAsFixed(1)}%',
              ),
              _buildHighlightCard(
                'Avg. Time',
                '${metrics.averageTimeTaken.toStringAsFixed(1)}s',
              ),
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

  pw.Widget _buildStudentProfile(
    UserModel student,
    List<QuizScoreModel> quizScores,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Student Profile',
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
                    pw.Text(student.name),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  children: [
                    pw.Text('Email: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(student.email),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Divider(),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _buildProfileItem('Grade', student.grade ?? 'N/A'),
                    _buildProfileItem('School', student.schoolName ?? 'N/A'),
                    _buildProfileItem(
                        'Total Quizzes', quizScores.length.toString()),
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

  pw.Widget _buildHeader(UserModel student) {
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
                'Academic Performance Report',
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

  pw.Widget _buildTopPerfomersSection(
      PerformanceMetrics metrics, List<QuizScoreModel> quizScores) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Performance Highlights',
            style: pw.TextStyle(
              color: _primaryColor,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            children: [
              pw.Expanded(
                child: _buildTopPerformerCard(
                  title: 'Top Quiz',
                  content: [
                    '${metrics.topPerformingQuiz.quizTitle}',
                    'Score: ${metrics.topPerformingQuiz.score}/${metrics.topPerformingQuiz.totalScore}',
                    'Category: ${metrics.topPerformingQuiz.categoryName}',
                  ],
                  color: _secondaryColor,
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Expanded(
                child: _buildTopPerformerCard(
                  title: 'Strongest Category',
                  content: [
                    metrics.topPerformingCategory,
                    'Average Score: ${_calculateCategoryAverage(metrics.topPerformingCategory, quizScores).toStringAsFixed(1)}%',
                    'Total Attempts: ${_countCategoryAttempts(metrics.topPerformingCategory, quizScores)}',
                  ],
                  color: _successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTopPerformerCard({
    required String title,
    required List<String> content,
    required PdfColor color,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: color),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: content
                  .map((item) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Text(
                          item,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ))
                  .toList(),
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
                                score.quizTitle ?? 'N/A',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: PdfColors.blue900,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    score.categoryName ?? 'General',
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      color: PdfColors.blue700,
                                    ),
                                  ),
                                  pw.SizedBox(width: 12),
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

  pw.Widget _buildCategoryPerformance(List<QuizScoreModel> scores) {
    final categoryStats = _calculateDetailedCategoryStats(scores);

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Category Performance Analysis',
            style: pw.TextStyle(
              fontSize: 18,
              color: _primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          ...categoryStats.entries.map((entry) {
            final category = entry.key;
            final stats = entry.value;
            final passRate = (stats.passCount / stats.totalAttempts) * 100;

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 16),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Category Header
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        category,
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.blue900,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${stats.totalAttempts} Attempts',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),

                  // Performance Bar
                  pw.Container(
                    height: 16,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Stack(
                      children: [
                        pw.Container(
                          width: 400 * (stats.averageScore / 100),
                          decoration: pw.BoxDecoration(
                            color: _getPerformanceColor(stats.averageScore),
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 8),

                  // Detailed Stats Grid
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(
                        'Average Score',
                        '${stats.averageScore.toStringAsFixed(1)}%',
                        PdfColors.blue700,
                      ),
                      _buildStatBox(
                        'Highest Score',
                        '${stats.highestScore.toStringAsFixed(1)}%',
                        PdfColors.green700,
                      ),
                      _buildStatBox(
                        'Lowest Score',
                        '${stats.lowestScore.toStringAsFixed(1)}%',
                        PdfColors.red700,
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(
                        'Pass Rate',
                        '${passRate.toStringAsFixed(1)}%',
                        PdfColors.blue700,
                      ),
                      _buildStatBox(
                        'Passed/Total',
                        '${stats.passCount}/${stats.totalAttempts}',
                        PdfColors.grey700,
                      ),
                      _buildStatBox(
                        'Avg Time',
                        '${stats.averageTimeTaken.toStringAsFixed(0)}s',
                        PdfColors.grey700,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
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

  PdfColor _getPerformanceColor(double value) {
    if (value >= 90) return PdfColors.green;
    if (value >= 80) return PdfColors.lightGreen;
    if (value >= 70) return PdfColors.yellow;
    if (value >= 60) return PdfColors.orange;
    return PdfColors.red;
  }

// Helper methods

  Map<String, CategoryStats> _calculateDetailedCategoryStats(
      List<QuizScoreModel> scores) {
    final categoryMap = <String, CategoryStats>{};

    // Group scores by category
    final groupedScores = <String, List<QuizScoreModel>>{};
    for (final score in scores) {
      final category = score.categoryName ?? 'General';
      groupedScores.putIfAbsent(category, () => []).add(score);
    }

    // Calculate detailed stats for each category
    groupedScores.forEach((category, categoryScores) {
      final performances =
          categoryScores.map((s) => (s.score / s.totalScore) * 100).toList();

      final averageScore =
          performances.reduce((a, b) => a + b) / performances.length;
      final highestScore = performances.reduce((a, b) => a > b ? a : b);
      final lowestScore = performances.reduce((a, b) => a < b ? a : b);
      final totalAttempts = categoryScores.length;
      final passCount = categoryScores
          .where((s) => (s.score / s.totalScore) * 100 >= 70)
          .length;
      final averageTimeTaken =
          categoryScores.map((s) => s.timeTaken).reduce((a, b) => a + b) /
              categoryScores.length;

      categoryMap[category] = CategoryStats(
        averageScore: averageScore,
        highestScore: highestScore,
        lowestScore: lowestScore,
        totalAttempts: totalAttempts,
        passCount: passCount,
        averageTimeTaken: averageTimeTaken,
      );
    });

    return categoryMap;
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
      topPerformingCategory: _findTopPerformingCategory(scores),
      improvementNeededCategories: _findImprovementNeededCategories(scores),
      topPerformingQuiz: _findTopPerformingQuiz(scores),
      incorrectRate: incorrectRate,
      skippedRate: skippedRate,
      totalIncorrectAnswers: totalIncorrectAnswers,
      totalSkippedQuestions: totalSkippedQuestions,
    );
  }

  QuizScoreModel _findTopPerformingQuiz(List<QuizScoreModel> scores) {
    return scores.reduce(
        (a, b) => (a.score / a.totalScore) > (b.score / b.totalScore) ? a : b);
  }

  String _findTopPerformingCategory(List<QuizScoreModel> scores) {
    final categoryPerformance = <String, double>{};

    for (var score in scores) {
      final categoryName = score.categoryName ?? 'Uncategorized';
      final performance = (score.score / score.totalScore) * 100;

      categoryPerformance[categoryName] =
          (categoryPerformance[categoryName] ?? 0) + performance;
    }

    return categoryPerformance.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  List<String> _findImprovementNeededCategories(List<QuizScoreModel> scores) {
    return scores
        .where((score) => (score.score / score.totalScore) * 100 < 50)
        .map((score) => score.categoryName ?? 'Uncategorized')
        .toList();
  }

  double _calculateCategoryAverage(
      String category, List<QuizScoreModel> scores) {
    final categoryScores = scores.where((s) => s.categoryName == category);
    if (categoryScores.isEmpty) return 0;
    return (categoryScores.fold(0, (sum, s) => sum + s.score) /
            categoryScores.fold(0, (sum, s) => sum + s.totalScore)) *
        100;
  }

  int _countCategoryAttempts(String category, List<QuizScoreModel> scores) {
    return scores.where((s) => s.categoryName == category).length;
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
}
