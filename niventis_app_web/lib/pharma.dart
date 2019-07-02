import 'dart:convert';

import 'package:flutter_web/cupertino.dart';
import 'package:http/http.dart' as http;

class PharmaDetails {
  final String id;
  final String trainingNeed;

  PharmaDetails({this.id, @required this.trainingNeed});

  factory PharmaDetails.fromJson(Map<String, dynamic> json) {
    return PharmaDetails(
        id: json['id'] as String,
        trainingNeed: json['trainingNeed'] as String);
  }

  Map<String, dynamic> toJson() => {'_id': id, 'trainingNeed': trainingNeed};

  @override
  String toString() => '$trainingNeed';
}

class Pharma {
  final String name;
  final String address;
  final int distance;
  final PharmaDetails details;
  static double latt;
  static double long;

  Pharma({@required this.name, this.address, this.distance, this.details});

  factory Pharma.fromJson(Map<String, dynamic> json) {
    return Pharma(
        name: json['name'] as String,
        address: json['address'] as String,
        distance: json['distance'] as int,
        details: (json['pharmaDetails'] == null) ? null : PharmaDetails.fromJson(json['pharmaDetails'])
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'distance': distance,
        'pharmaDetails': (this.details == null) ? null : details.toJson()
      };

  @override
  String toString() => '$name';

  static Future<List<Pharma>> getPharmas() async {

    Uri uri;
    if (long == null && latt == null) {
      uri = Uri.https('projets.maxdep.fr', '/niventis/api/pharmacies');
    } else {
      var queryParameters = {
        'long': long.toString(),
        'latt': latt.toString(),
      };
      uri = Uri.https(
          'projets.maxdep.fr', '/niventis/api/localisation', queryParameters);
    }
    print(uri.toString());
    final response =
        await http.get(uri, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final responseJson =
          jsonDecode(response.body).cast<Map<String, dynamic>>();
      return responseJson
          .map<Pharma>((json) => new Pharma.fromJson(json))
          .toList();
    } else {
      if (response.statusCode == 404) {
        throw Exception('Impossible d\'obtenir les données.' +
            jsonDecode(response.body)['message']);
      } else {
        throw Exception('Impossible d\'obtenir les données.');
      }
    }
  }
}
