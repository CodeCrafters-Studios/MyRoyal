import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class GlobalRepository {
  // Future<Either<Failure, LoginResponse>> getCaheLogin();
  Future<Either<Failure, bool>> verifyToken(String token);
  Future<Either<Failure, String>> getRefreshToken();
  Future<Either<Failure, Locale>> getLanguage();
  Future<Either<Failure, LoginResponse>> getCaheLogin();
}
