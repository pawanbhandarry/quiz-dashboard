import '../../../utils/formatters/formatter.dart';

class CategoryModel {
  String id;
  String name;
  String description;
  int noofQuizes;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.noofQuizes = 0,
    this.createdAt,
    this.updatedAt,
  });

  /// Getters for formatted dates
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Empty Helper Function
  static CategoryModel empty() =>
      CategoryModel(id: '', name: '', description: '');

  /// Convert model to Json structure for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'noof_quizes': noofQuizes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Factory constructor to create a CategoryModel from Supabase JSON data
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      noofQuizes: json['noof_quizes'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
