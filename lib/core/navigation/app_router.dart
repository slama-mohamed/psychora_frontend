import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/chatbot_interface/presentation/page/chatbot_interface.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/page/doctor_profile_page.dart';
import 'package:psychora/features/complete_signup_student/presentation/widget/complete_form.dart';
import 'package:psychora/features/forgot_password/presentation/page/forgot_password.dart';
import 'package:psychora/features/home/presentation/page/home_page.dart';
import 'package:psychora/features/login_page/presentation/page/login_page.dart';
import 'package:psychora/features/patient_dashboard/presentation/page/patient_dashboard_page.dart';
import 'package:psychora/features/reset_password/presentation/page/reset_password.dart';
import 'package:psychora/features/signup_page/presentation/page/signup_page.dart';

class AppRouter {
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String doctorprofilepage = '/doctorprofilepage';
  static const String completeProfileStudent = '/completeprofilestudent';
  static const String chatbotinterface = '/chatbotinterface';
  static const String forgotPassword = '/forgotpassword';
  static const String resetpassword = '/resetpassword';
  static const String patientdashboardpage = '/patientdashboardpage';

  static final GoRouter router = GoRouter(
    initialLocation: patientdashboardpage,
    routes: [
      GoRoute(
        path: home,
        name: RouteName.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: login,
        name: RouteName.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: signup,
        name: RouteName.signupName,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: doctorprofilepage,
        name: RouteName.doctorprofilepage,
        builder: (context, state) => const DoctorProfilePage(),
      ),
      GoRoute(
        path: completeProfileStudent,
        name: RouteName.completeProfileStudent,
        builder: (context, state) => const CompleteProfileStudent(),
      ),
      GoRoute(
        path: chatbotinterface,
        name: RouteName.chatbotinterface,
        builder: (context, state) => const ChatbotInterface(),
      ),
      GoRoute(
        path: forgotPassword,
        name: RouteName.forgotPassword,
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: resetpassword,
        name: RouteName.resetpassword,
        builder: (context, state) => const ResetPassword(),
      ),
      GoRoute(
        path: patientdashboardpage,
        name: RouteName.patientdashboardpage,
        builder: (context, state) => const PatientDashboardPage(),
      ),

    ],
  );
}
