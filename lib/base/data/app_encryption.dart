import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

const String keyAES = '914cf752-f9d5-11ea-8e66-f8cab84cf539';

abstract class AppEncrypt {
  String encryptString({required String data, required String token});
  Map<String, dynamic> encryptParams(Map<String, dynamic> params);
}

class AppEncryptImpl implements AppEncrypt {
  @override
  String encryptString({required String data, required String token}) {
    return encryptAESCryptoJS("'$data'", token);
  }

  String encryptAESCryptoJS(String plainText, String passphrase) {
    try {
      final salt = genRandomWithNonZero(8);
      final keyAndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyAndIV.item1);
      final iv = encrypt.IV(keyAndIV.item2);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      final encryptedBytesWithSalt = Uint8List.fromList(
        createUint8ListFromString('Salted__') + salt + encrypted.bytes,
      );
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      rethrow;
    }
  }

  Uint8List createUint8ListFromString(String s) {
    final ret = Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const randomMax = 245;
    final uint8list = Uint8List(seedLength);
    for (var i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }

  Tuple2<Uint8List, Uint8List> deriveKeyAndIV(
    String passphrase,
    Uint8List salt,
  ) {
    final password = createUint8ListFromString(passphrase);
    var concatenatedHashes = Uint8List(0);
    var currentHash = Uint8List(0);
    var enoughBytesForKey = false;
    var preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      // int preHashLength = currentHash.length + password.length + salt.length;
      if (currentHash.isNotEmpty) {
        preHash = Uint8List.fromList(currentHash + password + salt);
      } else {
        preHash = Uint8List.fromList(password + salt);
      }

      currentHash = Uint8List.fromList(md5.convert(preHash).bytes);
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    final keyBytes = concatenatedHashes.sublist(0, 32);
    final ivBytes = concatenatedHashes.sublist(32, 48);
    return Tuple2(keyBytes, ivBytes);
  }

  @override
  Map<String, dynamic> encryptParams(Map<String, dynamic> params) {
    return {'data': encryptAESCryptoJS(jsonEncode(params), keyAES)};
  }
}

// String stringEncryptAES({required String data}) {
//   final encrypted = encryptAESCryptoJS(data, EncryptKey.keyAES);
//   return encrypted;
// }

// String stringEncryptAESSingle({required String data, required String token}) {
//   final encrypted = encryptAESCryptoJS(data, token);
//   return encrypted;
// }

// String stringDecryptAESSingle({required String data, required String token}) {
//   final encrypted = decryptAESCryptoJS(data, token);
//   return encrypted;
// }

// String stringDecryptAES({required String data}) {
//   final decrypted = decryptAESCryptoJS(data, EncryptKey.keyAES);
//   return decrypted;
// }

// String mapEncryptAES({required Map<String, dynamic> data}) {
//   final rawJson = jsonEncode(data);
//   debugPrint('data raw request sebelum encrypt: $rawJson');
//   final encrypted = encryptAESCryptoJS(rawJson, EncryptKey.keyAES);
//   return encrypted;
// }

// String encryptAESCryptoJS(String plainText, String passphrase) {
//   try {
//     final salt = genRandomWithNonZero(8);
//     final keyAndIV = deriveKeyAndIV(passphrase, salt);
//     final key = encrypt.Key(keyAndIV.item1);
//     final iv = encrypt.IV(keyAndIV.item2);

//     final encrypter = encrypt.Encrypter(
//       encrypt.AES(key, mode: encrypt.AESMode.cbc),
//     );
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     final encryptedBytesWithSalt = Uint8List.fromList(
//       createUint8ListFromString('Salted__') + salt + encrypted.bytes,
//     );
//     return base64.encode(encryptedBytesWithSalt);
//   } catch (error) {
//     rethrow;
//   }
// }

// String decryptAESCryptoJS(String encrypted, String passphrase) {
//   try {
//     final encryptedBytesWithSalt = base64.decode(encrypted);

//     final encryptedBytes =
//         encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
//     final salt = encryptedBytesWithSalt.sublist(8, 16);
//     final keyAndIV = deriveKeyAndIV(passphrase, salt);
//     final key = encrypt.Key(keyAndIV.item1);
//     final iv = encrypt.IV(keyAndIV.item2);

//     final encrypter = encrypt.Encrypter(
//       encrypt.AES(key, mode: encrypt.AESMode.cbc),
//     );
//     final decrypted =
//         encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
//     return decrypted;
//   } catch (error) {
//     rethrow;
//   }
// }

// Tuple2<Uint8List, Uint8List> deriveKeyAndIV(String passphrase, Uint8List salt) {
//   final password = createUint8ListFromString(passphrase);
//   var concatenatedHashes = Uint8List(0);
//   var currentHash = Uint8List(0);
//   var enoughBytesForKey = false;
//   var preHash = Uint8List(0);

//   while (!enoughBytesForKey) {
//     // int preHashLength = currentHash.length + password.length + salt.length;
//     if (currentHash.isNotEmpty) {
//       preHash = Uint8List.fromList(currentHash + password + salt);
//     } else {
//       preHash = Uint8List.fromList(password + salt);
//     }

//     currentHash = Uint8List.fromList(md5.convert(preHash).bytes);
//     concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
//     if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
//   }

//   final keyBytes = concatenatedHashes.sublist(0, 32);
//   final ivBytes = concatenatedHashes.sublist(32, 48);
//   return Tuple2(keyBytes, ivBytes);
// }

// Uint8List createUint8ListFromString(String s) {
//   final ret = Uint8List(s.length);
//   for (var i = 0; i < s.length; i++) {
//     ret[i] = s.codeUnitAt(i);
//   }
//   return ret;
// }

// Uint8List genRandomWithNonZero(int seedLength) {
//   final random = Random.secure();
//   const randomMax = 245;
//   final uint8list = Uint8List(seedLength);
//   for (var i = 0; i < seedLength; i++) {
//     uint8list[i] = random.nextInt(randomMax) + 1;
//   }
//   return uint8list;
// }
