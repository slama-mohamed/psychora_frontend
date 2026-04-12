import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/chatbot_interface/presentation/page/chatbot_interface.dart';
import 'package:psychora/features/complete_signup_doctor/presentation/page/doctor_profile_page.dart';
import 'package:psychora/features/complete_signup_student/presentation/widget/complete_form.dart';
import 'package:psychora/features/edit_profile/presentation/page/edit_profile_page.dart';
import 'package:psychora/features/forgot_password/presentation/page/forgot_password.dart';
import 'package:psychora/features/home/presentation/page/home_page.dart';
import 'package:psychora/features/login_page/presentation/page/login_page.dart';
import 'package:psychora/features/patient_dashboard/presentation/page/patient_dashboard_page.dart';
import 'package:psychora/features/profile_page/presentation/page/profile_page.dart';
import 'package:psychora/features/reset_password/presentation/page/reset_password.dart';
import 'package:psychora/features/resources/presentation/page/resources_page.dart';
import 'package:psychora/features/splash_screen/splash_screen.dart';
import 'package:psychora/features/signup_page/presentation/page/signup_page.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String doctorprofilepage = '/doctorprofilepage';
  static const String completeProfileStudent = '/completeprofilestudent';
  static const String chatbotinterface = '/chatbotinterface';
  static const String forgotPassword = '/forgotpassword';
  static const String resetpassword = '/resetpassword';
  static const String patientdashboardpage = '/patientdashboardpage';
  static const String profilepage = '/profilepage';
  static const String resourcesPage = '/resources';
  static const String editProfilePage = '/editprofile';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: splash,
        name: RouteName.splash,
        builder: (context, state) => const SplashScreen(),
      ),
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
        builder: (context, state) => DoctorProfilePage(
          signupData: state.extra is Map<String, dynamic>
              ? state.extra! as Map<String, dynamic>
              : null,
        ),
      ),
      GoRoute(
        path: completeProfileStudent,
        name: RouteName.completeProfileStudent,
        builder: (context, state) => const CompleteProfileStudent(),
      ),
      GoRoute(
        path: chatbotinterface,
        name: RouteName.chatbotinterface,
        builder: (context, state) {
          String? patientId;
          String? patientName;

          if (state.extra is Map<String, dynamic>) {
            final Map<String, dynamic> extra =
                state.extra! as Map<String, dynamic>;
            patientId = extra['patientId'] as String?;
            patientName = extra['patientName'] as String?;
          }

          patientId ??= state.uri.queryParameters['patientId'];
          patientName ??= state.uri.queryParameters['patientName'];

          return ChatbotInterface(
            patientId: patientId,
            patientName: patientName,
          );
        },
      ),
      GoRoute(
        path: forgotPassword,
        name: RouteName.forgotPassword,
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: resetpassword,
        name: RouteName.resetpassword,
        builder: (context, state) => ResetPassword(
          email: state.uri.queryParameters['email'],
          token: state.uri.queryParameters['token'],
        ),
      ),
      GoRoute(
        path: '$resetpassword/:token',
        builder: (context, state) => ResetPassword(
          email: state.uri.queryParameters['email'],
          token: state.pathParameters['token'] ?? state.uri.queryParameters['token'],
        ),
      ),
      GoRoute(
        path: patientdashboardpage,
        name: RouteName.patientdashboardpage,
        builder: (context, state) => const PatientDashboardPage(),
      ),
      GoRoute(
        path: profilepage,
        name: RouteName.profilepage,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: resourcesPage,
        name: RouteName.resourcesPage,
        builder: (context, state) => const ResourcesPage(),
      ),
      GoRoute(
        path: editProfilePage,
        name: RouteName.editProfilePage,
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
}
