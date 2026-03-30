import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/articles/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/articles/data/repositories/articles_repository_impl.dart';
import 'package:MyRoyal/app/modules/articles/domain/usecases/get_articles_detail_usecase.dart';
import 'package:MyRoyal/app/modules/articles/domain/usecases/get_books_detail_usecase.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/articles_controller.dart';

class ArticlesBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<ArticlesRemoteDataSourcesImpl>(
        () =>
            ArticlesRemoteDataSourcesImpl(httpService: Get.find<HttpService>()),
      )
      ..lazyPut<ArticlesRepositoryImpl>(
        () => ArticlesRepositoryImpl(Get.find<ArticlesRemoteDataSourcesImpl>()),
      )
      ..lazyPut<GetArticlesDetailUsecase>(
        () => GetArticlesDetailUsecase(Get.find<ArticlesRepositoryImpl>()),
      )
      ..lazyPut<GetBooksDetailUsecase>(
        () => GetBooksDetailUsecase(Get.find<ArticlesRepositoryImpl>()),
      )
      ..lazyPut<ArticlesController>(
        () => ArticlesController(
            getArticlesDetailUsecase: Get.find<GetArticlesDetailUsecase>(),
            getBooksDetailUsecase: Get.find<GetBooksDetailUsecase>(),
            appDialog: Get.find<AppDialogImpl>()),
      );
  }
}
