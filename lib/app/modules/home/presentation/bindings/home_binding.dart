import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:iroyal/app/modules/help_and_support/controllers/help_and_support_controller.dart';
import 'package:iroyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/my_teams/data/repositories/my_teams_repository_impl.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:iroyal/app/modules/my_teams/presentation/controllers/my_teams_controller.dart';
import 'package:iroyal/app/modules/notifications/presentation/controllers/notifications_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tracking_document/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/tracking_document/data/repositories/tracking_document_repositories_impl.dart';
import 'package:iroyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:iroyal/app/modules/tracking_document/domain/usecase/get_tracking_document.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/controllers/tracking_document_controller.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // My Teams
    Get
      ..lazyPut<MyTeamsController>(
        () => MyTeamsController(
          getMyTeams: Get.find(),
          getUser: Get.find(),
        ),
      )
      ..lazyPut<MyTeamsRemoteDataSourcesImpl>(
        () => MyTeamsRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<MyTeamsRepositoryImpl>(
        () => MyTeamsRepositoryImpl(
          remoteData: Get.find<MyTeamsRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetMyTeams(
          Get.find<MyTeamsRepositoryImpl>(),
        ),
      )

      // Tracking Document
      ..lazyPut<TrackingDocumentController>(
        () => TrackingDocumentController(
          getTrackingDocument: Get.find(),
        ),
      )
      ..lazyPut<TrackingDocumentRemoteDataSourcesImpl>(
        () => TrackingDocumentRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<TrackingDocumentRepositoriesImpl>(
        () => TrackingDocumentRepositoriesImpl(
          remoteData: Get.find<TrackingDocumentRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetTrackingDocument(
          Get.find<TrackingDocumentRepository>(),
        ),
      )

      // Notifications
      ..lazyPut<NotificationsController>(
        () => NotificationsController(),
      )

      // Help & Support
      ..lazyPut<HelpAndSupportController>(
        () => HelpAndSupportController(),
      )

      // Tasks
      ..lazyPut<TasksController>(
        () => TasksController(appDialog: Get.find<AppDialogImpl>()),
      )

      // Detail Tasks
      ..lazyPut<DetailTasksController>(
        () => DetailTasksController(),
      );
  }
}
