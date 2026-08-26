class SaveEmployeeOsRequestModel {
  final int id;
  final String idCard;
  final String fullName;
  final int religionId;
  final String bloodType;
  final int mainSkill;
  final List<int> additionalSkill;
  final String joinDate;
  final bool isManufacturing;
  final bool isDirect;
  final String action;

  SaveEmployeeOsRequestModel({
    required this.id,
    required this.idCard,
    required this.fullName,
    required this.religionId,
    required this.bloodType,
    required this.mainSkill,
    this.additionalSkill = const [],
    required this.joinDate,
    required this.isManufacturing,
    required this.isDirect,
    this.action = 'approve',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_card': idCard,
        'full_name': fullName,
        'religion_id': religionId,
        'blood_type': bloodType,
        'main_skill': mainSkill,
        'additional_skill': additionalSkill,
        'join_date': joinDate,
        'is_manufacturing': isManufacturing,
        'is_direct': isDirect,
        'action': action,
      };
}
