import 'package:iroyal/app/modules/my_teams/data/models/my_teams_model.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

abstract class MyTeamsRemoteDataSources {
  Future<MyTeams> getMyTeams();
}

class MyTeamsRemoteDataSourcesImpl extends MyTeamsRemoteDataSources {
  MyTeamsRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<MyTeams> getMyTeams() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: '/api/v1/employees/28/children',
        method: Method.GET,
      );
      final myTeamsResponse = MyTeamsModel.fromJson(r);
      return myTeamsResponse;
    } on ApiException {
      rethrow;
    }
  }
}
