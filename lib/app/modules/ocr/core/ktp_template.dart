/// Defines the expected labels on an Indonesian KTP and where their values
/// should physically appear relative to the label.
enum ValuePosition { right, below, rightOrBelow }

class KtpTemplate {
  static const Map<String, KtpLabel> labels = {
    'NIK': KtpLabel(
      key: 'NIK',
      aliases: ['NIK'],
      valuePosition: ValuePosition.below,
    ),
    'Nama': KtpLabel(
      key: 'Nama',
      aliases: ['NAMA', 'NAMA LENGKAP'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Tempat/Tgl Lahir': KtpLabel(
      key: 'Tempat/Tgl Lahir',
      aliases: ['TEMPAT/TGL LAHIR', 'TEMPAT', 'TGL LAHIR'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Jenis Kelamin': KtpLabel(
      key: 'Jenis Kelamin',
      aliases: ['JENIS KELAMIN', 'KELAMIN'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Alamat': KtpLabel(
      key: 'Alamat',
      aliases: ['ALAMAT'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'RT/RW': KtpLabel(
      key: 'RT/RW',
      aliases: ['RT/RW', 'RT', 'RW'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Kel/Desa': KtpLabel(
      key: 'Kel/Desa',
      aliases: ['KEL/DESA', 'KELURAHAN', 'DESA'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Kecamatan': KtpLabel(
      key: 'Kecamatan',
      aliases: ['KECAMATAN', 'KEC'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Agama': KtpLabel(
      key: 'Agama',
      aliases: ['AGAMA'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Status Perkawinan': KtpLabel(
      key: 'Status Perkawinan',
      aliases: ['STATUS PERKAWINAN', 'STATUS'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Pekerjaan': KtpLabel(
      key: 'Pekerjaan',
      aliases: ['PEKERJAAN'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Kewarganegaraan': KtpLabel(
      key: 'Kewarganegaraan',
      aliases: ['KEWARGANEGARAAN'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Gol Darah': KtpLabel(
      key: 'Gol Darah',
      aliases: ['GOL. DARAH', 'GOL DARAH'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Berlaku Hingga': KtpLabel(
      key: 'Berlaku Hingga',
      aliases: ['BERLAKU HINGGA', 'BERLAKU'],
      valuePosition: ValuePosition.rightOrBelow,
    ),
    'Provinsi': KtpLabel(
      key: 'Provinsi',
      aliases: ['PROVINSI'],
      valuePosition: ValuePosition.right, // Actually top header
    ),
    'Kota': KtpLabel(
      key: 'Kota',
      aliases: ['KABUPATEN', 'KOTA', 'JAKARTA'],
      valuePosition: ValuePosition.right, // Actually top header
    ),
  };
}

class KtpLabel {
  final String key;
  final List<String> aliases;
  final ValuePosition valuePosition;

  const KtpLabel({
    required this.key,
    required this.aliases,
    required this.valuePosition,
  });
}
