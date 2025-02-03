// routes.dart
// HwzWCNey7HQoyDLe
class TRoutes {
  static const login = '/login';
  static const forgetPassword = '/forgetPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';
  static const users = '/users';
  static const reports = '/reports';

  static const quizes = '/quizes';
  static const createQuiz = '/createQuiz';
  static const editQuiz = '/editQuiz';

  static const questions = '/questions';
  static const addQuestion = '/addQuestion';
  static const editQuestion = '/editQuestion';
  static const uploadQuestions = '/uploadQuestions';

  static const createUser = '/createUser';
  static const userDetails = '/userDetails';

  static const activationCodes = '/activationCodes';
  static const createActivationCode = '/createActivationCode';
  static const editActivationCode = '/editActivationCode';
  static const settings = '/settings';
  static const profile = '/profile';

  static List sideMenuItems = [
    login,
    forgetPassword,
    dashboard,
    categories,
    users,
    questions,
    quizes,
    reports,
    activationCodes,
    settings,
    profile,
  ];
}

// All App Screens
class AppScreens {
  static const home = '/';
  static const store = '/store';
  static const favourites = '/favourites';
  static const settings = '/settings';
  static const subCategories = '/sub-categories';
  static const search = '/search';
  static const userProfile = '/user-profile';
  static const signUp = '/signup';
  static const signupSuccess = '/signup-success';
  static const verifyEmail = '/verify-email';
  static const signIn = '/sign-in';
  static const resetPassword = '/reset-password';
  static const forgetPassword = '/forget-password';
  static const onBoarding = '/on-boarding';

  static List<String> allAppScreenItems = [
    onBoarding,
    signIn,
    signUp,
    verifyEmail,
    resetPassword,
    forgetPassword,
    home,
    store,
    favourites,
    settings,
    subCategories,
    search,
    userProfile,
  ];
}
