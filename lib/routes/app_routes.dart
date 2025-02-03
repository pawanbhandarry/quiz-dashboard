import 'package:dashboard/features/authentication/screens/password_configuration/reset_password/reset_password.dart';
import 'package:dashboard/features/question/screens/add_questions/add_question.dart';
import 'package:dashboard/features/question/screens/all_questions/questions.dart';
import 'package:dashboard/features/question/screens/upload_questions/upload_question.dart';
import 'package:dashboard/features/quizes/screens/alll_quizes/quizes.dart';
import 'package:dashboard/features/reports/reports.dart';

import 'package:dashboard/features/setting/screens/profile/profile.dart';

import 'package:dashboard/features/category/screens/all_categories/categories.dart';
import 'package:dashboard/features/category/screens/create_category/create_category.dart';
import 'package:dashboard/features/category/screens/edit_category/edit_category.dart';
import 'package:dashboard/features/user/screens/all_users/users.dart';

import 'package:get/get.dart';
import '../features/activation_code/screens/all_activation_code/activation_code.dart';
import '../features/activation_code/screens/create_activation_code/create_activation_code.dart';
import '../features/activation_code/screens/edit_activation_code/edit_activation_code.dart';
import '../features/authentication/screens/forget_password/forget_password.dart';
import '../features/authentication/screens/login/login.dart';
import '../features/question/screens/edit_questions/edit_question.dart';
import '../features/quizes/screens/create_quiz/create_quiz.dart';
import '../features/quizes/screens/edit_quiz/edit_quiz.dart';
import '../features/user/screens/user_detail/user.dart';
import '../features/dashboard/screens/dashboard.dart';
import 'routes.dart';
import 'routes_middleware.dart';

class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.login, page: () => const LoginScreen()),
    GetPage(
        name: TRoutes.forgetPassword, page: () => const ForgetPasswordScreen()),
    GetPage(
        name: TRoutes.resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(
        name: TRoutes.dashboard,
        page: () => const DashboardScreen(),
        middlewares: [TRouteMiddleware()]),

    // Categories
    GetPage(
        name: TRoutes.categories,
        page: () => const CategoriesScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.createCategory,
        page: () => const CreateCategoryScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.editCategory,
        page: () => const EditCategoryScreen(),
        middlewares: [TRouteMiddleware()]),

    // Quizes
    GetPage(
        name: TRoutes.quizes,
        page: () => const QuizesScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.createQuiz,
        page: () => const CreateQuizScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.editQuiz,
        page: () => const EditQuizScreen(),
        middlewares: [TRouteMiddleware()]),
// QUESTION: Add the routes for the questions
    GetPage(
        name: TRoutes.questions,
        page: () => const QuestionsScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.addQuestion,
        page: () => const AddQuestionScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.editQuestion,
        page: () => const EditQuestionScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.uploadQuestions,
        page: () => const UploadQuestionScreen(),
        middlewares: [TRouteMiddleware()]),
//Reports
    GetPage(
        name: TRoutes.reports,
        page: () => const RepostsScreen(),
        middlewares: [TRouteMiddleware()]),
    // Users
    GetPage(
        name: TRoutes.users,
        page: () => const UsersScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.userDetails,
        page: () => const UserDetailScreen(),
        middlewares: [TRouteMiddleware()]),

    //Activation Code
    GetPage(
        name: TRoutes.activationCodes,
        page: () => const ActivationCodeScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.createActivationCode,
        page: () => const CreateActivationCodeScreen(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.editActivationCode,
        page: () => const EditActivationCodeScreen(),
        middlewares: [TRouteMiddleware()]),

    // GetPage(
    //     name: TRoutes.settings,
    //     page: () => const SettingsScreen(),
    //     middlewares: [TRouteMiddleware()]),
    GetPage(
        name: TRoutes.profile,
        page: () => const ProfileScreen(),
        middlewares: [TRouteMiddleware()]),
  ];
}
