import 'package:get/get.dart';
import 'package:iroyal/app/modules/help-and-support/entities/popular_questions.dart';

class HelpAndSupportController extends GetxController {
  List<PopularQuestions> listPopularQuestions = <PopularQuestions>[
    PopularQuestions(
      title: 'What is i-Royal Mobile Apps?',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    ),
    PopularQuestions(
      title: 'I forgot my password when logging in. What should I do?',
      description:
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
    ),
    PopularQuestions(
      title: 'Is it possible to access two accounts on different devices?',
      description:
          'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    PopularQuestions(
      title: 'Can I change my password?',
      description:
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    ),
    PopularQuestions(
      title: 'How do I change my profile picture?',
      description:
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
    ),
  ];
}
