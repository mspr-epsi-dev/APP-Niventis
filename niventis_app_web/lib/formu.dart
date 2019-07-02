import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenQuestion {
  final String libelle;
  final String answer;

  OpenQuestion({this.libelle, this.answer});

  factory OpenQuestion.fromJson(Map<String, dynamic> json) {
    return OpenQuestion(libelle: json ['libelle'], answer: json['answer']);
  }

  Map<String, dynamic> toJson() => {'answer': answer, 'libelle': libelle};

  @override
  String toString() => '$answer $libelle';
}

class QcmQuestion {
  final String libelle;
  final List<Answers> answers;

  QcmQuestion({this.libelle, this.answers});

  factory QcmQuestion.fromJson(Map<String, dynamic> json) {
    return QcmQuestion(
        libelle: json['libelle'],
        answers: json['answers'].cast<Map<String, dynamic>>().map<Answers>((json) => new Answers.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() =>
      {'libelle': libelle, 'answers': jsonEncode(answers)};

  @override
  String toString() => '$libelle,$answers';
}

class Answers {
  final String choix;
  final bool selected;

  Answers({this.choix, this.selected});

  factory Answers.fromJson(Map<String, dynamic> json) {
    return Answers(choix: json['choix'], selected: json['selected']);
  }

  Map<String, dynamic> toJson() => {'choix': choix, 'selected': selected};

  @override
  String toString() => '$choix,$selected';
}

class Formu {
  final String pharmacyId;
  final List<OpenQuestion> openQuestions;
  final List<QcmQuestion> qcmQuestions;

  Formu({this.pharmacyId, this.openQuestions, this.qcmQuestions});

  factory Formu.fromJson(Map<String, dynamic> json) {
    return Formu(
        pharmacyId: json['pharmacyId'] as String,
        openQuestions: json['openQuestion'].cast<Map<String, dynamic>>().map<OpenQuestion>((json) => new OpenQuestion.fromJson(json)).toList(),
        qcmQuestions: json['qcmQuestion'].cast<Map<String, dynamic>>().map<QcmQuestion>((json) => new QcmQuestion.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() => {
    'pharmacyId': pharmacyId,
    'openQuestion': jsonEncode(openQuestions),
    'qcmQuestion': jsonEncode(qcmQuestions),
  };

  @override
  String toString() => '$pharmacyId';

  static Future<List<Formu>> getFormus() async {
    Uri uri;
    uri = Uri.https('projets.maxdep.fr', '/niventis/api/formular');

    final response =
    await http.get(uri, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final responseJson =
      jsonDecode(response.body).cast<Map<String, dynamic>>();
      print(responseJson);
      return responseJson
          .map<Formu>((json) => new Formu.fromJson(json)).toList();
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
