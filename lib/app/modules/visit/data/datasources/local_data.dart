import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:MyRoyal/app/modules/visit/data/models/locations_model.dart';

import 'package:MyRoyal/app/modules/visit/domain/entities/locations.dart';

abstract class VisitLocalDataSources {
  Future<List<Locations>> fetchLocations();
}

class VisitLocalDataSourcesImpl extends VisitLocalDataSources {
  VisitLocalDataSourcesImpl();

  @override
  Future<List<Locations>> fetchLocations() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/locations.json');
      final data = await json.decode(response);

      final List<LocationsModel> locations = (data['stations'] as List)
          .map((location) => LocationsModel.fromJson(location))
          .toList();

      return locations;
    } catch (e) {
      throw Exception('Failed to load locations');
    }
  }
}
