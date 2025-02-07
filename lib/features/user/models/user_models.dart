import '../../../../utils/formatters/formatter.dart';
import '../../../utils/constants/enums.dart';

/// Model class representing user data.
class UserModel {
  final String? id;
  String name;
  int score;
  String email;
  String profilePicture;
  String grade;
  String schoolName;
  String status;
  DateTime? createdAt;
  DateTime? updatedAt;

  /// Constructor for UserModel.
  UserModel({
    this.id,
    required this.email,
    this.name = '',
    this.score = 0,
    this.profilePicture = '',
    this.status = 'active',
    this.createdAt,
    this.grade = '',
    this.schoolName = '',
    this.updatedAt,
  });

  /// Helper methods
  String get fullName => name;

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Static function to create an empty user model.
  static UserModel empty() =>
      UserModel(email: ''); // Default createdAt to current time

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'score': score,
      'profile_picture': profilePicture,
      'grade': grade,
      'school_name': schoolName,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at':
          updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      score: json['score'] ?? 0,
      profilePicture: json['profile_picture'] ?? '',
      grade: json['grade'] ?? 'N/A',
      schoolName: json['school_name'] ?? 'N/A',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
