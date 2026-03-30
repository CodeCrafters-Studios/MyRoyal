import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/help_and_support/entities/popular_questions.dart';

class HelpAndSupportController extends GetxController {
  List<PopularQuestions> listPopularQuestions = <PopularQuestions>[
    PopularQuestions(
      title: 'What is MyRoyal Mobile Apps?',
      description:
          'MyRoyal application is designed to address these issues by providing an integrated platform that simplifies the management of various daily activities for both Managers or HR and Employees. This application offers 15 core features as part of its MVP (Minimum Viable Product), aimed at reducing complexity and enhancing operational efficiency.',
    ),
    PopularQuestions(
      title: 'I forgot my password when logging in. What should I do?',
      description:
          'If you forgot your password when logging in, please contact our helpdesk for assistance 0811-2465-515 or 0811-2000-5071.',
    ),
    PopularQuestions(
      title: 'Is it possible to access two accounts on different devices?',
      description:
          'No, to ensure security and user privacy, we enforce a One Device, One Account system.',
    ),
    PopularQuestions(
      title: 'Can I change my password?',
      description:
          'If you want to change your password when logging in, please contact our helpdesk for assistance 0811-2465-515 or 0811-2000-5071.',
    ),
    PopularQuestions(
      title: 'How do I change my profile picture?',
      description:
          'Go to settings → Profile → Edit Profile → Tap Profile Picture → Choose from Gallery or Camera → Tap Continue Button',
    ),
  ];
}
