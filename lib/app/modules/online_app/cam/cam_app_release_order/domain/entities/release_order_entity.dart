class ReleaseOrderEntity {
  final int code;
  final String message;
  final Data data;

  ReleaseOrderEntity({
    required this.code,
    required this.message,
    required this.data,
  });
}

class Data {
  final bool status;
  final String order;
  final List<Datum> data;

  Data({
    required this.status,
    required this.order,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        order: json["order"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order": order,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String nomorOrder;
  final String kodeHold;
  final String branchPlant;
  final String nomorRma;
  final String tanggalRelease;
  final String jamRelease;
  final String userRelease;
  final String tipeOrder;
  final bool button;

  Datum({
    required this.nomorOrder,
    required this.kodeHold,
    required this.branchPlant,
    required this.nomorRma,
    required this.tanggalRelease,
    required this.jamRelease,
    required this.userRelease,
    required this.tipeOrder,
    required this.button,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        nomorOrder: json["nomor_order"],
        kodeHold: json["kode_hold"],
        branchPlant: json["branch_plant"],
        nomorRma: json["nomor_rma"],
        tanggalRelease: json["tanggal_release"],
        jamRelease: json["jam_release"],
        userRelease: json["user_release"],
        tipeOrder: json["tipe_order"],
        button: json["button"],
      );

  Map<String, dynamic> toJson() => {
        "nomor_order": nomorOrder,
        "kode_hold": kodeHold,
        "branch_plant": branchPlant,
        "nomor_rma": nomorRma,
        "tanggal_release": tanggalRelease,
        "jam_release": jamRelease,
        "user_release": userRelease,
        "tipe_order": tipeOrder,
        "button": button,
      };
}
