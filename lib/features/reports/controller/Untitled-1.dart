// import 'dart:typed_data';
// import 'dart:math' as math;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:universal_html/html.dart' as html;
// import 'package:get/get.dart';

// import '../../user/models/user_models.dart';
// import '../models/quiz_score_model.dart';
// import 'quiz_score_controller.dart';

// // Color definitions
// final primaryColor = PdfColor.fromHex('#2563eb');
// final secondaryColor = PdfColor.fromHex('#f59e0b');
// final accentColor = PdfColor.fromHex('#10b981');
// final errorColor = PdfColor.fromHex('#ef4444');
// final bgLight = PdfColor.fromHex('#f3f4f6');
// final textDark = PdfColor.fromHex('#1f2937');
// final textMuted = PdfColor.fromHex('#6b7280');

// final chartColors = [
//   PdfColor.fromHex('#3b82f6'),
//   PdfColor.fromHex('#10b981'),
//   PdfColor.fromHex('#f59e0b'),
//   PdfColor.fromHex('#ef4444'),
//   PdfColor.fromHex('#8b5cf6'),
// ];

// class ReportController {
//   final QuizScoreController _quizScoreController = QuizScoreController.instance;

//   String _getReportType(
//       String selectedUser, String selectedQuiz, String selectedCategory) {
//     if (selectedUser.isNotEmpty) return 'user';
//     if (selectedQuiz.isNotEmpty) return 'quiz';
//     if (selectedCategory.isNotEmpty) return 'category';
//     return 'overall';
//   }

//   Future<void> generateReport() async {
//     final selectedUser = _quizScoreController.selectedUser.value;
//     final selectedQuiz = _quizScoreController.selectedQuiz.value;
//     final selectedCategory = _quizScoreController.selectedCategory.value;
//     final List<QuizScoreModel> scores = _quizScoreController.filteredItems;

//     if (scores.isEmpty) {
//       print("No data available for the selected filters.");
//       return;
//     }

//     final pdf = pw.Document();

//     // Add cover page
//     pdf.addPage(_buildCoverPage(selectedUser, selectedQuiz, selectedCategory));

//     // Add report content based on selection
//     if (selectedUser.isNotEmpty) {
//       final user = _quizScoreController.users
//           .firstWhereOrNull((u) => u.id == selectedUser);
//       if (user != null) {
//         pdf.addPage(_buildUserReport(user, scores));
//       }
//     } else if (selectedQuiz.isNotEmpty) {
//       pdf.addPage(_buildQuizReport(scores));
//     } else if (selectedCategory.isNotEmpty) {
//       pdf.addPage(_buildCategoryReport(scores));
//     }

//     final Uint8List pdfBytes = await pdf.save();
//     _downloadPdf(pdfBytes, selectedUser, selectedQuiz, selectedCategory);
//   }

//   pw.Widget _buildSectionTitle(String title) {
//     return pw.Text(
//       title,
//       style: pw.TextStyle(
//         fontSize: 18,
//         fontWeight: pw.FontWeight.bold,
//         color: textDark,
//       ),
//     );
//   }

//   pw.Widget _buildPerformanceChart(List<QuizScoreModel> scores) {
//     final sortedScores = List<QuizScoreModel>.from(scores)
//       ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

//     return pw.Container(
//       height: 200,
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(
//         color: PdfColors.white,
//         borderRadius: pw.BorderRadius.circular(10),
//         border: pw.Border.all(color: PdfColors.grey300),
//       ),
//       child: pw.CustomPaint(
//         painter: (context, size) {
//           final paint = pw.Paint()
//             ..color = primaryColor
//             ..strokeWidth = 2.0;

//           final points = _calculateTimelinePoints(sortedScores, size);
//           context.drawPath(
//             points,
//             paint,
//             mode: pw.PaintingMode.stroke,
//           );
//         },
//       ),
//     );
//   }

//   pw.Widget _buildCategoryHeader(QuizScoreModel score) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(
//         color: bgLight,
//         borderRadius: pw.BorderRadius.circular(10),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'Category: ${score.categoryName ?? "Unknown Category"}',
//             style: pw.TextStyle(
//               fontSize: 24,
//               fontWeight: pw.FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _buildQuizHeader(QuizScoreModel score) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(
//         color: bgLight,
//         borderRadius: pw.BorderRadius.circular(10),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'Quiz: ${score.quizTitle ?? "Unknown Quiz"}',
//             style: pw.TextStyle(
//               fontSize: 24,
//               fontWeight: pw.FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _buildCategoryOverview(CategoryStats stats) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(
//         color: PdfColors.white,
//         borderRadius: pw.BorderRadius.circular(10),
//         border: pw.Border.all(color: PdfColors.grey300),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'Category Overview',
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//           pw.SizedBox(height: 15),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               _buildStatItem('Total Quizzes', '${stats.totalQuizzes}'),
//               _buildStatItem('Average Score', '${stats.averageScore.round()}%'),
//               _buildStatItem(
//                   'Completion Rate', '${stats.completionRate.round()}%'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _buildStatItem(String label, String value) {
//     return pw.Column(
//       children: [
//         pw.Text(
//           value,
//           style: pw.TextStyle(
//             fontSize: 24,
//             fontWeight: pw.FontWeight.bold,
//             color: primaryColor,
//           ),
//         ),
//         pw.SizedBox(height: 5),
//         pw.Text(
//           label,
//           style: pw.TextStyle(
//             fontSize: 12,
//             color: textMuted,
//           ),
//         ),
//       ],
//     );
//   }

//   pw.Widget _buildPerformanceTrends(List<QuizScoreModel> scores) {
//     final monthlyAverages = _calculateMonthlyAverages(scores);

//     return pw.Container(
//       height: 200,
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(
//         color: PdfColors.white,
//         borderRadius: pw.BorderRadius.circular(10),
//         border: pw.Border.all(color: PdfColors.grey300),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'Monthly Performance Trends',
//             style: pw.TextStyle(
//               fontSize: 16,
//               fontWeight: pw.FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//           pw.SizedBox(height: 20),
//           pw.Expanded(
//             child: pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: monthlyAverages.entries.map((entry) {
//                 return pw.Expanded(
//                   child: pw.Column(
//                     mainAxisAlignment: pw.MainAxisAlignment.end,
//                     children: [
//                       pw.Container(
//                         height: entry.value,
//                         margin: const pw.EdgeInsets.symmetric(horizontal: 4),
//                         decoration: pw.BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: pw.BorderRadius.vertical(
//                               top: pw.Radius.circular(4)),
//                         ),
//                       ),
//                       pw.SizedBox(height: 8),
//                       pw.Text(
//                         entry.key,
//                         style: pw.TextStyle(fontSize: 10),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _buildCategoryLeaderboard(List<QuizScoreModel> scores) {
//     final topScores = _getTopPerformers(scores);

//     return pw.Container(
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(
//         color: PdfColors.white,
//         borderRadius: pw.BorderRadius.circular(10),
//         border: pw.Border.all(color: PdfColors.grey300),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'Category Leaderboard',
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//           pw.SizedBox(height: 15),
//           ...topScores.map((score) => _buildTopPerformerItem(score)),
//         ],
//       ),
//     );
//   }

//   Map<String, double> _calculateMonthlyAverages(List<QuizScoreModel> scores) {
//     final monthlyScores = <String, List<int>>{};

//     for (var score in scores) {
//       final month = _getMonthName(score.createdAt!);
//       monthlyScores.putIfAbsent(month, () => []).add(score.score);
//     }

//     final averages = <String, double>{};
//     monthlyScores.forEach((month, scores) {
//       averages[month] = scores.reduce((a, b) => a + b) / scores.length;
//     });

//     return averages;
//   }

//   String _getMonthName(DateTime date) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return months[date.month - 1];
//   }

//   List<QuizScoreModel> _getTopPerformers(List<QuizScoreModel> scores) {
//     final sortedScores = List<QuizScoreModel>.from(scores)
//       ..sort((a, b) => b.score.compareTo(a.score));
//     return sortedScores.take(5).toList();
//   }

//   double _calculateCompletionRate(List<QuizScoreModel> scores) {
//     final completedCount = scores.where((s) => s.score >= 0).length;
//     return (completedCount / scores.length * 100);
//   }

//   double _calculateAverageScore(List<QuizScoreModel> scores) {
//     return (scores.fold(0, (sum, s) => sum + s.score) / scores.length)
//         .roundToDouble();
//   }

//   void _downloadPdf(Uint8List pdfBytes, String selectedUser,
//       String selectedQuiz, String selectedCategory) {
//     final blob = html.Blob([pdfBytes], 'application/pdf');
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final dateStr = DateTime.now().toString().split(' ')[0];
//     final reportType =
//         _getReportType(selectedUser, selectedQuiz, selectedCategory);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute('download', '${reportType}_report_$dateStr.pdf')
//       ..click();
//     html.Url.revokeObjectUrl(url);
//   }
// }

// class CategoryStats {
//   final int totalQuizzes;
//   final double averageScore;
//   final double completionRate;
//   final List<QuizScoreModel> topPerformers;

//   CategoryStats({
//     required this.totalQuizzes,
//     required this.averageScore,
//     required this.completionRate,
//     required this.topPerformers,
//   });
// }

// class StatItem {
//   final String label;
//   final String value;
//   final PdfColor color;

//   StatItem(this.label, this.value, this.color);
// }
