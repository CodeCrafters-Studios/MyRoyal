import 'package:iroyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:iroyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

abstract class ArticlesRemoteDataSources {
  Future<ArticlesDetailModel> getArticlesDetail(String id);
  Future<BooksDetailModel> getBooksDetail(String id);
}

class ArticlesRemoteDataSourcesImpl implements ArticlesRemoteDataSources {
  ArticlesRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<ArticlesDetailModel> getArticlesDetail(String id) async {
    final r = await httpService.customRequest(
      withToken: true,
      endpoint: 'api/shelves/$id',
      method: Method.GET,
      showPopUp: true,
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    final articlesDetailResponse = ArticlesDetailModel.fromJson(r);
    return articlesDetailResponse;
  }

  @override
  Future<BooksDetailModel> getBooksDetail(String id) async {
    final r = await httpService.customRequest(
      withToken: true,
      endpoint: 'api/books/$id',
      method: Method.GET,
      showPopUp: true,
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    final booksDetailResponse = BooksDetailModel.fromJson(r);
    return booksDetailResponse;
  }
}
