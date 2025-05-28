import 'package:iroyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:iroyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class ArticlesRemoteDataSources {
  Future<ArticlesDetailModel> getArticlesDetail(String id);
  Future<BooksDetailModel> getBooksDetail(String id);
}

class ArticlesRemoteDataSourcesImpl implements ArticlesRemoteDataSources {
  ArticlesRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<ArticlesDetailModel> getArticlesDetail(String id) async {
    try {
      final r = await httpService.customRequest(
        withToken: true,
        endpoint: 'api/shelves/$id',
        method: Method.GET,
      );
      final articlesDetailResponse = ArticlesDetailModel.fromJson(r);
      return articlesDetailResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  @override
  Future<BooksDetailModel> getBooksDetail(String id) async {
    try {
      final r = await httpService.customRequest(
        withToken: true,
        endpoint: 'api/books/$id',
        method: Method.GET,
      );
      final booksDetailResponse = BooksDetailModel.fromJson(r);
      return booksDetailResponse;
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      rethrow;
    }
  }
}
