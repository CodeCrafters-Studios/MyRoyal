import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/help_and_support/entities/popular_questions.dart';

class HelpAndSupportController extends GetxController {
  List<PopularQuestions> listPopularQuestions = <PopularQuestions>[
    PopularQuestions(
      title: 'Apa itu MyRoyal Mobile Apps?',
      description:
          'Aplikasi MyRoyal dirancang untuk mengatasi masalah ini dengan menyediakan platform terintegrasi yang menyederhanakan pengelolaan berbagai aktivitas sehari-hari bagi Manajer atau HR dan Karyawan. Aplikasi ini menawarkan 15 fitur inti sebagai bagian dari MVP (Minimum Viable Product), yang bertujuan untuk mengurangi kompleksitas dan meningkatkan efisiensi operasional.',
    ),
    PopularQuestions(
      title: 'Saya lupa password saat login. Apa yang harus saya lakukan?',
      description:
          'Jika Anda lupa password saat login, silakan hubungi helpdesk kami untuk mendapatkan bantuan 0811-2465-515 atau 0811-2000-5071.',
    ),
    PopularQuestions(
      title: 'Apakah mungkin mengakses dua akun pada perangkat yang berbeda?',
      description:
          'Tidak, untuk memastikan keamanan dan privasi pengguna, kami menerapkan sistem Satu Perangkat, Satu Akun.',
    ),
    PopularQuestions(
      title: 'Dapatkah saya mengubah kata sandi saya?',
      description:
          'Jika Anda ingin mengubah kata sandi saat login, silakan hubungi helpdesk kami untuk mendapatkan bantuan 0811-2465-515 atau 0811-2000-5071.',
    ),
    PopularQuestions(
      title: 'Bagaimana cara mengubah foto profil saya?',
      description:
          'Masuk ke Pengaturan → Profil → Edit Profil → Ketuk Foto Profil → Pilih dari Galeri atau Kamera → Ketuk Tombol Lanjutkan',
    ),
  ];
}
