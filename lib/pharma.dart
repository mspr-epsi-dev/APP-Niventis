import 'dart:convert';

import 'package:http/http.dart' as http;

class Address {
  final int nbr;
  final String street;
  final String city;

  Address({this.nbr, this.street, this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        nbr: json['nbr'], street: json['street'], city: json['city']);
  }

  Map<String, dynamic> toJson() => {'nbr': nbr, 'street': street, 'city': city};

  @override
  String toString() => '$nbr $street, $city';
}

class Pharma {
  final String id;
  final String name;
  final Address address;
  final String trainingNeed;
  final List location;

  Pharma({this.id, this.name, this.address, this.trainingNeed, this.location});

  factory Pharma.fromJson(Map<String, dynamic> json) {
    return Pharma(
        id: json['_id'] as String,
        name: json['name'] as String,
        address: Address.fromJson(json['adress']),
        trainingNeed: json['trainingNeed'] as String,
        location: json['gpsCoordinates'] as List);
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'adress': address.toJson(),
        'trainingNeed': trainingNeed,
        'gpsCoordinates': location,
      };

  @override
  String toString() => '$name';

  static Future<List<Pharma>> getPharmas(double long, double latt) async {
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
