class ScanOcrFieldOutput {
  final String value;
  final double confidence;
  final String source;

  ScanOcrFieldOutput({
    required this.value,
    required this.confidence,
    required this.source,
  });

  factory ScanOcrFieldOutput.fromJson(Map<String, dynamic> json) {
    return ScanOcrFieldOutput(
      value: json['value']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      source: json['source']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'confidence': confidence,
      'source': source,
    };
  }
}

class ScanOcrQuality {
  final double score;
  final double sharpness;
  final double brightness;

  ScanOcrQuality({
    required this.score,
    required this.sharpness,
    required this.brightness,
  });

  factory ScanOcrQuality.fromJson(Map<String, dynamic> json) {
    return ScanOcrQuality(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      sharpness: (json['sharpness'] as num?)?.toDouble() ?? 0.0,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'sharpness': sharpness,
      'brightness': brightness,
    };
  }
}

class ScanOcrDataModel {
  final bool success;
  final Map<String, ScanOcrFieldOutput>? data;
  final ScanOcrQuality? quality;
  final List<String>? warnings;

  ScanOcrDataModel({
    required this.success,
    this.data,
    this.quality,
    this.warnings,
  });

  factory ScanOcrDataModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> targetMap = json;

    if (json['data_ocr'] is Map<String, dynamic>) {
      targetMap = json['data_ocr'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic>) {
      final dataObj = json['data'] as Map<String, dynamic>;
      if (dataObj['data_ocr'] is Map<String, dynamic>) {
        targetMap = dataObj['data_ocr'] as Map<String, dynamic>;
      }
    }

    Map<String, dynamic>? fieldsObj;
    if (targetMap['data'] is Map<String, dynamic>) {
      fieldsObj = targetMap['data'] as Map<String, dynamic>;
    } else {
      bool containsFieldObjects = targetMap.values.any(
        (val) => val is Map<String, dynamic> && val.containsKey('value'),
      );
      if (containsFieldObjects) {
        fieldsObj = targetMap;
      }
    }

    Map<String, ScanOcrFieldOutput>? parsedData;
    if (fieldsObj != null) {
      parsedData = {};
      fieldsObj.forEach((key, val) {
        if (val is Map<String, dynamic>) {
          parsedData![key] = ScanOcrFieldOutput.fromJson(val);
        }
      });
    }

    ScanOcrQuality? parsedQuality;
    final qualityObj = targetMap['quality'] ?? json['quality'];
    if (qualityObj is Map<String, dynamic>) {
      parsedQuality = ScanOcrQuality.fromJson(qualityObj);
    }

    List<String>? parsedWarnings;
    final warningsObj = targetMap['warnings'] ?? json['warnings'];
    if (warningsObj is List) {
      parsedWarnings = List<String>.from(warningsObj);
    }

    final bool success = (targetMap['success'] as bool?) ??
        (json['success'] as bool?) ??
        (json['code'] == 200 ? true : null) ??
        (parsedData != null && parsedData.isNotEmpty);

    return ScanOcrDataModel(
      success: success,
      data: parsedData,
      quality: parsedQuality,
      warnings: parsedWarnings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((key, value) => MapEntry(key, value.toJson())),
      'quality': quality?.toJson(),
      'warnings': warnings,
    };
  }
}

class DataInputOsModel {
  final String noRegistration;
  final String firstName;
  final String lastName;
  final String birthplace;
  final DateTime dateOfBirth;
  final String maritalStatus;
  final String gender;
  final bool smoker;
  final String idCard;
  final bool active;
  final String religionId;
  final String bloodType;
  final dynamic mainSkill;
  final dynamic additionalSkill;
  final bool isInternal;
  final String uuid;
  final String state;
  final dynamic profilePicture;
  final dynamic profilePicturePath;
  final dynamic profilePictureName;
  final dynamic profilePictureDriver;
  final String employeeNumber;

  DataInputOsModel({
    required this.noRegistration,
    required this.firstName,
    required this.lastName,
    required this.birthplace,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.gender,
    required this.smoker,
    required this.idCard,
    required this.active,
    required this.religionId,
    required this.bloodType,
    required this.mainSkill,
    required this.additionalSkill,
    required this.isInternal,
    required this.uuid,
    required this.state,
    required this.profilePicture,
    required this.profilePicturePath,
    required this.profilePictureName,
    required this.profilePictureDriver,
    required this.employeeNumber,
  });

  factory DataInputOsModel.fromJson(Map<String, dynamic> json) =>
      DataInputOsModel(
        noRegistration: json["no_registration"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        birthplace: json["birthplace"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        maritalStatus: json["marital_status"],
        gender: json["gender"],
        smoker: json["smoker"],
        idCard: json["id_card"],
        active: json["active"],
        religionId: json["religion_id"],
        bloodType: json["blood_type"],
        mainSkill: json["main_skill"],
        additionalSkill: json["additional_skill"],
        isInternal: json["is_internal"],
        uuid: json["uuid"],
        state: json["state"],
        profilePicture: json["profile_picture"],
        profilePicturePath: json["profile_picture_path"],
        profilePictureName: json["profile_picture_name"],
        profilePictureDriver: json["profile_picture_driver"],
        employeeNumber: json["employee_number"],
      );

  Map<String, dynamic> toJson() => {
        "no_registration": noRegistration,
        "first_name": firstName,
        "last_name": lastName,
        "birthplace": birthplace,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "marital_status": maritalStatus,
        "gender": gender,
        "smoker": smoker,
        "id_card": idCard,
        "active": active,
        "religion_id": religionId,
        "blood_type": bloodType,
        "main_skill": mainSkill,
        "additional_skill": additionalSkill,
        "is_internal": isInternal,
        "uuid": uuid,
        "state": state,
        "profile_picture": profilePicture,
        "profile_picture_path": profilePicturePath,
        "profile_picture_name": profilePictureName,
        "profile_picture_driver": profilePictureDriver,
        "employee_number": employeeNumber,
      };
}

class ScanOcrResponseDataModel {
  final int id;
  final ScanOcrDataModel dataOcr;
  final DataInputOsModel? dataInputOsModel;
  final bool different;

  ScanOcrResponseDataModel({
    required this.id,
    required this.dataOcr,
    this.dataInputOsModel,
    required this.different,
  });

  factory ScanOcrResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ScanOcrResponseDataModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      dataOcr: json['data_ocr'] is Map<String, dynamic>
          ? ScanOcrDataModel.fromJson(
              json['data_ocr'] as Map<String, dynamic>,
            )
          : ScanOcrDataModel(
              success: false,
              data: {},
              warnings: [],
            ),
      dataInputOsModel: json['data_inputed_os'] is Map<String, dynamic>
          ? DataInputOsModel.fromJson(
              json['data_inputed_os'] as Map<String, dynamic>,
            )
          : null,
      different: json['different'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_ocr': dataOcr.toJson(),
      'data_inputed_os': dataInputOsModel?.toJson(),
      'different': different,
    };
  }
}

class ScanOcrResponseModel {
  final int code;
  final String message;
  final ScanOcrResponseDataModel? data;

  ScanOcrResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory ScanOcrResponseModel.fromJson(Map<String, dynamic> json) {
    return ScanOcrResponseModel(
      code: (json['code'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? ScanOcrResponseDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  bool get success => code == 200 && data?.dataOcr.success == true;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
