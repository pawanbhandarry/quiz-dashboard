import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/quiz_score_model.dart';

class ScoreRows extends DataTableSource {
  final List<QuizScoreModel> scores;

  ScoreRows(this.scores);

  @override
  DataRow? getRow(int index) {
    if (index >= scores.length) return null;

    final score = scores[index];

    return DataRow2(
      cells: [
        DataCell(Text(score.userName ?? 'Unknown User')),
        DataCell(Text(score.quizTitle ?? 'Unknown Quiz')),
        DataCell(Text('${score.totalScore}/${score.maximumScore}')),
        DataCell(Text(score.formattedDate)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () => _showScoreDetails(score),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteScore(score),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Show score details in a dialog
  void _showScoreDetails(QuizScoreModel score) {
    Get.dialog(
      AlertDialog(
        title: const Text('Score Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${score.userName}'),
            Text('Quiz: ${score.quizTitle}'),
            Text('Score: ${score.totalScore}/${score.maximumScore}'),
            Text('Percentage: ${score.scorePercentage.toStringAsFixed(2)}%'),
            Text('Date: ${score.formattedDate}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Confirm score deletion
  void _confirmDeleteScore(QuizScoreModel score) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Score'),
        content: const Text('Are you sure you want to delete this score?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement score deletion logic
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => scores.length;

  @override
  int get selectedRowCount => 0;
}
