import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart';

import '../../../data/repositories/questions/questions_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../quizes/models/quizes_models.dart';
import '../models/question_models.dart';

import 'dart:async';
import 'package:universal_html/html.dart' show AnchorElement, Blob, Url;

class UploadQuestionController extends GetxController {
  static UploadQuestionController get instance => Get.find();

  // Observables
  Rx<QuizModel> selectedQuiz = QuizModel.empty().obs;
  RxList<QuestionModel> preparedQuestions = <QuestionModel>[].obs;
  RxBool isFileRead = false.obs;
  RxBool isUploading = false.obs;
  late final QuestionRepository _questionRepository;
  @override
  void onInit() {
    super.onInit();
    _questionRepository = Get.put(QuestionRepository());
  }

  // Read CSV File
  Future<void> readCSVFile() async {
    try {
      // Validate quiz selection
      if (selectedQuiz.value.id.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Quiz Selection', message: 'Select a quiz before uploading');
        return;
      }

      // Pick CSV file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        // Clear previous prepared questions
        preparedQuestions.clear();

        // Read CSV content
        String csvString = String.fromCharCodes(result.files.first.bytes!);
        List<List<dynamic>> csvTable = const CsvToListConverter()
            .convert(csvString, eol: '\n', fieldDelimiter: ',');
        if (csvTable.isNotEmpty) {
          csvTable.removeAt(0);
        }
        // Validate CSV
        if (csvTable.length < 2) {
          TLoaders.errorSnackBar(
              title: 'Invalid File',
              message: 'CSV must contain at least two rows');
          return;
        }

        // Process questions (skip header)
        for (var row in csvTable.skip(1)) {
          if (row.length < 7) continue;
          final correctOptionKey =
              row[5].toString().toUpperCase(); // Ensure it's uppercase
          final question = QuestionModel(
            id: '',
            question: row[0].toString(),
            options: {
              'A': row[1].toString(),
              'B': row[2].toString(),
              'C': row[3].toString(),
              'D': row[4].toString(),
            },
            correctAnswer: '',
            explanation: row[6].toString(),
            quizId: selectedQuiz.value.id,
            categoryId: selectedQuiz.value.categoryId,
            imageUrl: row.length > 7 ? row[7].toString() : null,
          );
          final correctAnswerValue =
              question.options[correctOptionKey] ?? ''; // Get actual answer
          question.correctAnswer = correctAnswerValue;
          preparedQuestions.add(question);
        }

        // Set file read state
        isFileRead.value = preparedQuestions.isNotEmpty;

        TLoaders.successSnackBar(
            title: 'File Processed',
            message: '${preparedQuestions.length} questions ready to upload');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'File Reading Error', message: e.toString());
      isFileRead.value = false;
    }
  }

  // Bulk Upload Prepared Questions
  Future<void> uploadPreparedQuestions() async {
    if (preparedQuestions.isEmpty) {
      TLoaders.errorSnackBar(
          title: 'No Questions', message: 'Please read a CSV file first');
      return;
    }

    try {
      // Network check
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet', message: 'Check your internet connection');
        return;
      }

      TFullScreenLoader.popUpCircular();
      isUploading.value = true;

      // Upload questions
      for (var question in preparedQuestions) {
        await _questionRepository.createQuestion(question);
      }

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Upload Complete',
          message: '${preparedQuestions.length} questions uploaded');

      // Reset states
      preparedQuestions.clear();
      isFileRead.value = false;
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Upload Error', message: e.toString());
    } finally {
      isUploading.value = false;
    }
  }

  // Generate CSV Template
  void downloadCSVTemplate() {
    List<List<dynamic>> csvData = [
      [
        'Question',
        'Option A',
        'Option B',
        'Option C',
        'Option D',
        'Correct Answer',
        'Explanation',
        'Image URL'
      ],
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final blob = Blob([utf8.encode(csv)]);
    final url = Url.createObjectUrl(blob);

    AnchorElement(href: url)
      ..setAttribute('download', 'question_template.csv')
      ..click();

    Url.revokeObjectUrl(url);
  }
}
