import 'package:equatable/equatable.dart';

class PayrollDataOverviewEntity extends Equatable {
  const PayrollDataOverviewEntity({required this.data});

  final DataOverview data;

  @override
  List<Object?> get props => [data];
}

class DataOverview {
  final String pendapatanSebelumPajak;
  final String potonganPajak;
  final String persentasePotonganPajak;
  final String pendapatanSesudahPajak;
  final String totalPotongan;
  final String gajiBersih;
  final String pembulatan;
  final String gajiPokok;

  DataOverview({
    required this.pendapatanSebelumPajak,
    required this.potonganPajak,
    required this.persentasePotonganPajak,
    required this.pendapatanSesudahPajak,
    required this.totalPotongan,
    required this.gajiBersih,
    required this.pembulatan,
    required this.gajiPokok,
  });

  factory DataOverview.fromJson(Map<String, dynamic> json) => DataOverview(
        pendapatanSebelumPajak: json["pendapatan_sebelum_pajak"],
        potonganPajak: json["potongan_pajak"],
        persentasePotonganPajak: json["persentase_potongan_pajak"],
        pendapatanSesudahPajak: json["pendapatan_sesudah_pajak"],
        totalPotongan: json["total_potongan"],
        gajiBersih: json["gaji_bersih"],
        pembulatan: json["pembulatan"],
        gajiPokok: json["gaji_pokok"],
      );

  Map<String, dynamic> toJson() => {
        "pendapatan_sebelum_pajak": pendapatanSebelumPajak,
        "potongan_pajak": potonganPajak,
        "persentase_potongan_pajak": persentasePotonganPajak,
        "pendapatan_sesudah_pajak": pendapatanSesudahPajak,
        "total_potongan": totalPotongan,
        "gaji_bersih": gajiBersih,
        "pembulatan": pembulatan,
        "gaji_pokok": gajiPokok,
      };
}
