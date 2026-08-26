import 'dart:ui';

class NormalizedRect {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const NormalizedRect({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  double get width => right - left;
  double get height => bottom - top;

  Rect toRect(double imageWidth, double imageHeight) {
    return Rect.fromLTRB(
      (left * imageWidth).clamp(0.0, imageWidth),
      (top * imageHeight).clamp(0.0, imageHeight),
      (right * imageWidth).clamp(0.0, imageWidth),
      (bottom * imageHeight).clamp(0.0, imageHeight),
    );
  }

  NormalizedRect expand(double padPercent) {
    return NormalizedRect(
      left: (left - padPercent).clamp(0.0, 1.0),
      top: (top - padPercent).clamp(0.0, 1.0),
      right: (right + padPercent).clamp(0.0, 1.0),
      bottom: (bottom + padPercent).clamp(0.0, 1.0),
    );
  }

  @override
  String toString() =>
      'NormalizedRect(L:${left.toStringAsFixed(3)}, T:${top.toStringAsFixed(3)}, R:${right.toStringAsFixed(3)}, B:${bottom.toStringAsFixed(3)})';
}

class KtpFieldRegion {
  final String field;
  final NormalizedRect normalizedRect;

  const KtpFieldRegion({
    required this.field,
    required this.normalizedRect,
  });
}

class KtpFieldRegions {
  static const KtpFieldRegion nik = KtpFieldRegion(
    field: 'NIK',
    normalizedRect:
        NormalizedRect(left: 0.16, top: 0.13, right: 0.88, bottom: 0.25),
  );

  static const KtpFieldRegion name = KtpFieldRegion(
    field: 'Nama Lengkap',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.23, right: 0.72, bottom: 0.32),
  );

  static const KtpFieldRegion birthPlaceDate = KtpFieldRegion(
    field: 'Tempat/Tgl Lahir',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.29, right: 0.72, bottom: 0.38),
  );

  static const KtpFieldRegion gender = KtpFieldRegion(
    field: 'Jenis Kelamin',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.35, right: 0.58, bottom: 0.44),
  );

  static const KtpFieldRegion address = KtpFieldRegion(
    field: 'Alamat',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.41, right: 0.72, bottom: 0.50),
  );

  static const KtpFieldRegion rtRw = KtpFieldRegion(
    field: 'RT/RW',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.47, right: 0.58, bottom: 0.56),
  );

  static const KtpFieldRegion village = KtpFieldRegion(
    field: 'Kelurahan/Desa',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.53, right: 0.72, bottom: 0.62),
  );

  static const KtpFieldRegion district = KtpFieldRegion(
    field: 'Kecamatan',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.59, right: 0.72, bottom: 0.68),
  );

  static const KtpFieldRegion religion = KtpFieldRegion(
    field: 'Agama',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.65, right: 0.60, bottom: 0.74),
  );

  static const KtpFieldRegion maritalStatus = KtpFieldRegion(
    field: 'Status Perkawinan',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.71, right: 0.68, bottom: 0.80),
  );

  static const KtpFieldRegion work = KtpFieldRegion(
    field: 'Pekerjaan',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.77, right: 0.70, bottom: 0.86),
  );

  static const KtpFieldRegion nationality = KtpFieldRegion(
    field: 'Kewarganegaraan',
    normalizedRect:
        NormalizedRect(left: 0.24, top: 0.83, right: 0.68, bottom: 0.92),
  );

  static const KtpFieldRegion provinceHeader = KtpFieldRegion(
    field: 'Provinsi Header',
    normalizedRect:
        NormalizedRect(left: 0.15, top: 0.00, right: 0.85, bottom: 0.08),
  );

  static const KtpFieldRegion cityHeader = KtpFieldRegion(
    field: 'Kota/Kabupaten Header',
    normalizedRect:
        NormalizedRect(left: 0.15, top: 0.06, right: 0.85, bottom: 0.14),
  );

  static List<KtpFieldRegion> get allRegions => [
        nik,
        name,
        birthPlaceDate,
        gender,
        address,
        rtRw,
        village,
        district,
        religion,
        maritalStatus,
        work,
        nationality,
      ];
}
