import '../models/ktp_result.dart';
import '../parsers/field_parser.dart';
import '../parsers/nik_parser.dart';
import '../parsers/ttl_parser.dart';
import '../parsers/rt_rw_parser.dart';
import '../parsers/dictionary_parser.dart';
import '../utils/ktp_dictionaries.dart';

class KtpResultBuilder {
  final Map<String, String> rawExtractedFields;
  final String sourceImageVariant;

  KtpResultBuilder(this.rawExtractedFields, this.sourceImageVariant);

  KtpResult build() {
    KtpResult result = KtpResult();

    for (var entry in rawExtractedFields.entries) {
      String label = entry.key;
      String rawValue = entry.value;

      switch (label) {
        case 'NIK':
          result.nik = NikParser().parse(rawValue, sourceImageVariant);
          break;
        case 'Nama':
          result.name = AlphaParser().parse(rawValue, sourceImageVariant);
          break;
        case 'Tempat/Tgl Lahir':
          var ttlFields = TtlParser().parse(rawValue, sourceImageVariant);
          result.birthPlace = ttlFields['Tempat Lahir']!;
          result.birthDate = ttlFields['Tgl Lahir']!;
          break;
        case 'Jenis Kelamin':
          result.gender = DictionaryParser(
                  dictionary: KtpDictionaries.genders, maxDistance: 3)
              .parse(rawValue, sourceImageVariant);
          break;
        case 'Alamat':
          result.address = KtpField(
              value: rawValue, confidence: 90.0, source: sourceImageVariant);
          break;
        case 'RT/RW':
          var rtrwFields = RtRwParser().parse(rawValue, sourceImageVariant);
          result.rt = rtrwFields['RT']!;
          result.rw = rtrwFields['RW']!;
          break;
        case 'Kel/Desa':
          result.village = AlphaParser().parse(rawValue, sourceImageVariant);
          break;
        case 'Kecamatan':
          result.district = AlphaParser().parse(
              rawValue.replaceAll('KECAMATAN', '').trim(), sourceImageVariant);
          break;
        case 'Agama':
          result.religion = DictionaryParser(
                  dictionary: KtpDictionaries.religions, maxDistance: 2)
              .parse(rawValue, sourceImageVariant);
          break;
        case 'Status Perkawinan':
          result.maritalStatus = DictionaryParser(
                  dictionary: KtpDictionaries.maritalStatuses, maxDistance: 3)
              .parse(rawValue, sourceImageVariant);
          break;
        case 'Pekerjaan':
          result.work =
              DictionaryParser(dictionary: KtpDictionaries.jobs, maxDistance: 4)
                  .parse(rawValue, sourceImageVariant);
          break;
        case 'Kewarganegaraan':
          result.nationality = DictionaryParser(
                  dictionary: KtpDictionaries.nationalities, maxDistance: 1)
              .parse(rawValue, sourceImageVariant);
          break;
        case 'Provinsi':
          result.province = DictionaryParser(
                  dictionary: KtpDictionaries.provinces, maxDistance: 3)
              .parse(rawValue.replaceAll('PROVINSI', '').trim(),
                  sourceImageVariant);
          break;
        case 'Kota':
          String cleanCity = rawValue
              .replaceAll('KABUPATEN', '')
              .replaceAll('KOTA', '')
              .trim();
          result.city = AlphaParser().parse(cleanCity, sourceImageVariant);
          break;
      }
    }

    return result;
  }
}
