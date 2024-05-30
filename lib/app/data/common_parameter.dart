// import 'dart:math';

// import 'package:intl/intl.dart';
// import 'package:iroyal/base/utils/token/app_token.dart';

// abstract class CommonParam {
//   DateTime get date;
//   String get trxDateTime;
//   String get sytemTraceAuditDate;
//   String get systemTraceAudit;

//   Future<Map<String, dynamic>> get commonParams;
// }

// class CommonParamsImpl implements CommonParam {
//   CommonParamsImpl({required this.appToken});

//   final AppToken appToken;
//   @override
//   DateTime get date => DateTime.now();
//   @override
//   String get trxDateTime => DateFormat('yyyyMMddHHmmss').format(date);
//   @override
//   String get sytemTraceAuditDate => DateFormat('DD').format(date);
//   @override
//   String get systemTraceAudit =>
//       '$sytemTraceAuditDate${Random.secure().nextInt(1000) * 1000 + 1}';

//   @override
//   Future<Map<String, dynamic>> get commonParams async {
//     final token = await appToken.getToken();
//     return {
//       // 'pos_terminal_type': '6017',
//       // 'trx_date_time': trxDateTime,
//       // 'system_trace_audit': systemTraceAudit,
//       'token': token,
//     };
//   }
// }
