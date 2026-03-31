import 'package:MyRoyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:MyRoyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/services/http_service.dart';

abstract class ArticlesRemoteDataSources {
  Future<ArticlesDetailModel> getArticlesDetail(String id);
  Future<BooksDetailModel> getBooksDetail(String id);
}

class ArticlesRemoteDataSourcesImpl implements ArticlesRemoteDataSources {
  ArticlesRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<ArticlesDetailModel> getArticlesDetail(String id) async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'api/shelves/$id',
      method: Method.GET,
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    final articlesDetailResponse = ArticlesDetailModel.fromJson(r);
    return articlesDetailResponse;
  }

  @override
  Future<BooksDetailModel> getBooksDetail(String id) async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'api/books/$id',
      method: Method.GET,
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    final booksDetailResponse = BooksDetailModel.fromJson(r);
    return booksDetailResponse;
  }
}
