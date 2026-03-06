import 'package:get/get.dart';
import 'package:iroyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:iroyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:iroyal/app/modules/articles/domain/entities/books_detail_entity.dart';
import 'package:iroyal/app/modules/articles/domain/usecases/get_articles_detail_usecase.dart';
import 'package:iroyal/app/modules/articles/domain/usecases/get_books_detail_usecase.dart';
import 'package:iroyal/app/modules/articles/presentation/views/components/books_view.dart';
import 'package:iroyal/app/modules/home/domain/entities/home_slider.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class ArticlesController extends GetxController {
  ArticlesController({
    required this.getArticlesDetailUsecase,
    required this.getBooksDetailUsecase,
    required this.appDialog,
  });

  late HomeSlider dataArticle;

  RxBool isLoading = false.obs;

  Rx<ArticlesDetailModel> dataArticleDetail = ArticlesDetailModel.empty().obs;
  Rx<BooksDetailModel> dataBookDetail = BooksDetailModel(
    id: 0,
    name: '',
    slug: '',
    description: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
    descriptionHtml: '',
    cover: CoverBooks(
      id: 0,
      name: '',
      url: '',
      createdAt: DateTime(0),
      updatedAt: DateTime(0),
      createdBy: 0,
      updatedBy: 0,
      path: '',
      type: '',
      uploadedTo: 0,
    ),
  ).obs;

  final GetArticlesDetailUsecase getArticlesDetailUsecase;
  final GetBooksDetailUsecase getBooksDetailUsecase;
  final AppDialog appDialog;

  @override
  void onInit() {
    dataArticle = Get.arguments;
    _getDetailArticles();
    super.onInit();
  }

  Future<void> _getDetailArticles() async {
    isLoading.value = true;

    final result = await getArticlesDetailUsecase(dataArticle.id);

    result.fold((l) {
      isLoading.value = false;
      final error = l.properties.first;

      if (error is ApiException) {
        AppUtils.logApp('SERVER ERROR ::: ${error.message}');
      } else {
        AppUtils.logApp('SERVER ERROR ::: $error');
      }
    }, (r) {
      isLoading.value = false;
      dataArticleDetail.value = r;

      AppUtils.logApp('DESSSSSSSSSSS ${r.description}');
    });
  }

  Future<void> getDetailBooks(String id) async {
    isLoading.value = true;

    final result = await getBooksDetailUsecase(id);

    result.fold((l) {
      isLoading.value = false;
    }, (r) {
      isLoading.value = false;
      dataBookDetail.value = r;
      AppUtils.logApp('IMAGE URL ::: ${dataBookDetail.value.cover.url}');
      Get.to(
        () => BooksView(),
        arguments: r,
      );
    });
  }
}
