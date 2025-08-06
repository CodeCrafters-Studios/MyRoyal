import 'package:equatable/equatable.dart';

class TraceSerialEntity extends Equatable {
  final int? code;
  final String? message;
  final Data? data;

  const TraceSerialEntity({
    this.code,
    this.message,
    this.data,
  });

  @override
  List<Object?> get props => [code, message, data];
}

class Data {
  final bool? status;
  final String? serial;
  final List<Mutasi>? mutasi;
  final List<Stock>? stock;

  Data({
    this.status,
    this.serial,
    this.mutasi,
    this.stock,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        serial: json["serial"],
        mutasi: json["mutasi"] == null
            ? []
            : List<Mutasi>.from(json["mutasi"]!.map((x) => Mutasi.fromJson(x))),
        stock: json["stock"] == null
            ? []
            : List<Stock>.from(json["stock"]!.map((x) => Stock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "serial": serial,
        "mutasi": mutasi == null
            ? []
            : List<dynamic>.from(mutasi!.map((x) => x.toJson())),
        "stock": stock == null
            ? []
            : List<dynamic>.from(stock!.map((x) => x.toJson())),
      };
}

class Mutasi {
  final String? nobukti;
  final String? tanggal;
  final int? warnaTransaksi;
  final String? transaksi;
  final String? customer;
  final String? ket;
  final String? kodebrg;
  final String? namabrg;
  final String? serial;
  final String? po;
  final String? exsjPick;
  final String? orderPo;
  final String? alamat;

  Mutasi({
    this.nobukti,
    this.tanggal,
    this.warnaTransaksi,
    this.transaksi,
    this.customer,
    this.ket,
    this.kodebrg,
    this.namabrg,
    this.serial,
    this.po,
    this.exsjPick,
    this.orderPo,
    this.alamat,
  });

  factory Mutasi.fromJson(Map<String, dynamic> json) => Mutasi(
        nobukti: json["nobukti"],
        tanggal: json["tanggal"],
        warnaTransaksi: json["warna_transaksi"],
        transaksi: json["transaksi"],
        customer: json["customer"],
        ket: json["ket"],
        kodebrg: json["kodebrg"],
        namabrg: json["namabrg"],
        serial: json["Serial"],
        po: json["po"],
        exsjPick: json["exsj/pick"],
        orderPo: json["order/po"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "nobukti": nobukti,
        "tanggal": tanggal,
        "warna_transaksi": warnaTransaksi,
        "transaksi": transaksi,
        "customer": customer,
        "ket": ket,
        "kodebrg": kodebrg,
        "namabrg": namabrg,
        "Serial": serial,
        "po": po,
        "exsj/pick": exsjPick,
        "order/po": orderPo,
        "alamat": alamat,
      };
}

class Stock {
  final String? serial;
  final String? branch;
  final String? location;
  final String? itemNumber;
  final String? onHand;
  final String? commit;
  final String? intransit;
  final String? receipt;
  final String? onHandDate;
  final String? baseOnDate;
  final String? expiredDate;

  Stock({
    this.serial,
    this.branch,
    this.location,
    this.itemNumber,
    this.onHand,
    this.commit,
    this.intransit,
    this.receipt,
    this.onHandDate,
    this.baseOnDate,
    this.expiredDate,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        serial: json["serial"],
        branch: json["branch"],
        location: json["location"],
        itemNumber: json["item_number"],
        onHand: json["on_hand"],
        commit: json["commit"],
        intransit: json["intransit"],
        receipt: json["receipt"],
        onHandDate: json["on_hand_date"],
        baseOnDate: json["base_on_date"],
        expiredDate: json["expired_date"],
      );

  Map<String, dynamic> toJson() => {
        "serial": serial,
        "branch": branch,
        "location": location,
        "item_number": itemNumber,
        "on_hand": onHand,
        "commit": commit,
        "intransit": intransit,
        "receipt": receipt,
        "on_hand_date": onHandDate,
        "base_on_date": baseOnDate,
        "expired_date": expiredDate,
      };
}
