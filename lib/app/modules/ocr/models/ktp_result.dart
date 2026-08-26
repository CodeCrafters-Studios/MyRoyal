class KtpField {
  String value;
  double confidence;
  bool corrected;
  String source;

  KtpField({
    required this.value,
    this.confidence = 100.0,
    this.corrected = false,
    this.source = 'original',
  });

  bool get isHighConfidence => confidence >= 80.0;
  bool get isEmpty => value.isEmpty;

  @override
  String toString() {
    return 'KtpField(value: $value, confidence: $confidence, corrected: $corrected, source: $source)';
  }
}

class KtpResult {
  KtpField nik = KtpField(value: '');
  KtpField name = KtpField(value: '');
  KtpField birthPlace = KtpField(value: '');
  KtpField birthDate = KtpField(value: '');
  KtpField gender = KtpField(value: '');
  KtpField address = KtpField(value: '');
  KtpField rt = KtpField(value: '');
  KtpField rw = KtpField(value: '');
  KtpField village = KtpField(value: '');
  KtpField district = KtpField(value: '');
  KtpField city = KtpField(value: '');
  KtpField province = KtpField(value: '');
  KtpField religion = KtpField(value: '');
  KtpField maritalStatus = KtpField(value: '');
  KtpField work = KtpField(value: '');
  KtpField nationality = KtpField(value: '');

  Map<String, KtpField> toMap() {
    return {
      'NIK': nik,
      'Nama Lengkap': name,
      'Tempat Lahir': birthPlace,
      'Tanggal Lahir': birthDate,
      'Jenis Kelamin': gender,
      'Alamat': address,
      'RT': rt,
      'RW': rw,
      'Kelurahan/Desa': village,
      'Kecamatan': district,
      'Kota/Kabupaten': city,
      'Provinsi': province,
      'Agama': religion,
      'Status Perkawinan': maritalStatus,
      'Pekerjaan': work,
      'Kewarganegaraan': nationality,
    };
  }

  // Debug string
  @override
  String toString() {
    String out = '=== KTP OCR RESULT ===\n';
    toMap().forEach((key, field) {
      out +=
          '$key: ${field.value} (Conf: ${field.confidence}%, Corrected: ${field.corrected}, Source: ${field.source})\n';
    });
    return out;
  }
}
