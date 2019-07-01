import 'dart:convert';

import 'package:http/http.dart' as http;


class OpenQuestion {
  final String libelle;
  final String answer;

  OpenQuestion({this.libelle, this.answer});

  factory OpenQuestion.fromJson(Map<String, dynamic> json) {
    return OpenQuestion(
        libelle: json['libelle'], answer: json['answer']);
  }

  Map<String, dynamic> toJson() => {'answer': answer, 'libelle': libelle};

  @override
  String toString() => '$answer $libelle';
}


class QcmQuestion {
  final String libelle;
  final QcmReponse qcmReponse;
  QcmQuestion({this.libelle,this.qcmReponse});

  factory QcmQuestion.fromJson(Map<String, dynamic> json) {
    return QcmQuestion(
        libelle: json['libelle'],qcmReponse: json['qcmReponse');
  }

  Map<String, dynamic> toJson() => {'libelle': libelle,'qcmReponse': qcmReponse};

  @override
  String toString() => '$libelle,$qcmReponse';
}


class QcmReponse {
  final String choix;
  final bool selected;

  QcmReponse({this.choix,this.selected});

  factory QcmReponse.fromJson(Map<String, dynamic> json) {
    return QcmReponse(
        choix: json['choix'], selected: json['selected']);
  }

  Map<String, dynamic> toJson() => {'choix': choix,'selected': selected };

  @override
  String toString() => '$choix,$selected';
}

class Formu {
  final String pharmacyId;
  final OpenQuestion openQuestion;
  final QcmQuestion qcmQuestion;


  Formu({this.pharmacyId, this.openQuestion, this.qcmQuestion});

  factory Formu.fromJson(Map<String, dynamic> json) {
    return Formu(
        pharmacyId: json['pharmacyId'] as String,
        openQuestion: OpenQuestion.fromJson(json['openQuestion']),
        qcmQuestion: QcmQuestion.fromJson(json['qcmQuestion']);
  }

  Map<String, dynamic> toJson() => {
    'pharmacyId': pharmacyId,
    'openQuestion': openQuestion.toJson(),
    'qcmQuestion': qcmQuestion.toJson()
  };

  @override
  String toString() => '$pharmacyId';

  static Future<List<Formu>> getPharmas(double long, double latt) async {
    Uri uri;
    if (long == null && latt == null) {
      uri = Uri.https('projets.maxdep.fr', '/niventis/api/formular');
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
          .map<Formu>((json) => new Formu.fromJson(json))
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
