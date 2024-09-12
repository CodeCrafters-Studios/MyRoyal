import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/detail_progress_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/detail_ptk_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/user_created_model.dart';

class DetailTrackingDocumentDataEntities extends Equatable {
  final DetailPtkModel detailPtk;
  final DetailUserCreatedModel detailUserCreated;
  final List<DetailProgressModel> detailProgress;

  const DetailTrackingDocumentDataEntities({
    required this.detailPtk,
    required this.detailUserCreated,
    required this.detailProgress,
  });

  @override
  List<Object?> get props => [detailPtk, detailUserCreated, detailProgress];
}
