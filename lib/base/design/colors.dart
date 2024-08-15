import 'package:flutter/material.dart';

const primary = Color(0xFF313352);
const secondary = Color(0xFFBE9B34);
const white = Color(0xFFFFFFFF);
const black = Color.fromRGBO(0, 0, 0, 1);
const grey = Color(0xFFD9D9D9);
const greyHint = Color.fromRGBO(191, 186, 186, 1);
const greyIcon = Color.fromRGBO(30, 30, 30, .4);
const borderColor = Color.fromRGBO(217, 217, 217, 0.192);
const bgMenuColor = Color.fromRGBO(217, 217, 217, 0.658);
const red = Color.fromRGBO(236, 66, 96, 1);
const redPrimary = Color(0xFFF44336);
const greyText = Color.fromRGBO(99, 98, 98, 1);
const green = Color(0xFF369B43);
const grey50 = Color(0xFFF5F5F5);

const primaryColor = Color(0xFF004BBC);
const primaryDark = Color.fromARGB(255, 0, 99, 16);
const primaryAccent = Color.fromARGB(255, 156, 18, 220);

const Color primary10 = Color.fromARGB(255, 83, 85, 126);
const Color primary30 = Color(0xFF5C8DD7);
const Color primary50 = Color(0xFF004BBC);
const Color primary70 = Color(0xFF002D71);
const Color primary90 = Color(0xFF001E4B);

const Color secondary90 = Color(0xFF003A49);
const Color secondary70 = Color(0xFF007491);
const Color secondary50 = Color(0xFF00C1F2);
const Color secondary30 = Color(0xFF66DAF7);
const Color secondary10 = Color(0xFFFBC02D);

const Color neutral90 = Color(0xFF101820);
const Color neutral70 = Color(0xFF333333);
const Color neutral50 = Color(0xFFBDBDBD);
const Color neutral30 = Color(0xFFDCDCDC);
const Color neutral20 = Color(0xFF808080);
const Color neutral10 = Color(0xFFF5F1F1);
const Color neutral5 = Color(0xFFFFFFFF);

const bgColor = Color(0xFFFFFFFF);
const bgColorDark = Color.fromARGB(255, 105, 105, 105);

const focusColor = Color.fromARGB(255, 0, 183, 58);
const errorColor = Color(0xFFFF013E);
const successColor = Color.fromARGB(255, 91, 212, 109);
const normalColor = Color.fromARGB(255, 177, 177, 177);
const disabledColor = Color.fromARGB(255, 149, 149, 149);

const appTextColor = Color.fromARGB(255, 27, 27, 27);
const appHintColor = Color(0xFFBDBDBD);
const inputColor = Color(0xFFF5F1F1);

const greySecond = Color.fromARGB(118, 231, 231, 231);
const darkGrey = Color.fromARGB(255, 136, 136, 136);
const cardColor = Color.fromARGB(255, 255, 255, 255);
const favoriteColor = Color.fromARGB(255, 250, 200, 38);
const tabbarColor = Color(0xFFFAFAFA);

// Switch Color
const inactiveThumbColor = Color.fromRGBO(84, 110, 122, 1);
const inactiveTrackColor = Color.fromRGBO(189, 189, 189, 1);

const Map<int, Color> materialColor = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class Gradients {
  static LinearGradient primary() {
    return const LinearGradient(
      colors: [
        Color(0xFF004BBC),
        Color(0xFF00C1F2),
      ],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    );
  }

  static LinearGradient primaryAccent() {
    return const LinearGradient(
      colors: [
        Color(0xFF00C1F2),
        Color(0xFFB2ECFB),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static LinearGradient neutral() {
    return const LinearGradient(
      colors: [
        Color(0xFFDCDCDC),
        Color(0xFFF5F1F1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
