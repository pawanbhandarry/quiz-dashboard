import 'package:dashboard/features/reports/controller/quiz_score_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreRows extends DataTableSource {
  final controller = QuizScoreController.instance;

  @override
  DataRow? getRow(int index) {
    final score = controller.filteredItems[index];

    return DataRow2(
      cells: [
        DataCell(Text(score.userName ?? 'Unknown User')),
        DataCell(Text(score.categoryName ?? 'Unknown Category')),
        DataCell(Text(score.quizTitle ?? 'Unknown Quiz')),
        DataCell(Text(score.score.toString())),
        DataCell(Text(score.formattedDate)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length > 10
      ? 10
      : controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
