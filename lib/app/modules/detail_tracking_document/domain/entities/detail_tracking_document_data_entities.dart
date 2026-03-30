import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/data/models/detail_progress_model.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/data/models/detail_ptk_model.dart';

class DetailTrackingDocumentDataEntities extends Equatable {
  final DetailPtkModel detailPtk;
  final List<DetailProgressModel> detailProgress;

  const DetailTrackingDocumentDataEntities({
    required this.detailPtk,
    required this.detailProgress,
  });

  @override
  List<Object?> get props => [detailPtk, detailProgress];
}
