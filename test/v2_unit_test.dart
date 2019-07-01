// Automated testing falls into a few categories:
//
// A unit test tests a single function, method, or class.

import "dart:async";
import 'package:flutter_test/flutter_test.dart';

import 'package:niventis_app/pharma.dart';

void main() {
  // ---- Unit test
  // Class Pharma
  group('Pharma', () {
    test('with location return pharmas', () {
      Pharma.latt = 43.6426727;
      Pharma.long = 3.8382165;
      Future<List<Pharma>> pharmas = Pharma.getPharmas();
      pharmas.then(expectAsync1((listPharmas) {
        expect(listPharmas.length > 0, true);
      }));
    });
  });

  test('return good pharma name', () {
    Pharma.latt = 43.6328952;
    Pharma.long = 3.8461164;
    Future<List<Pharma>> pharmas = Pharma.getPharmas();
    pharmas.then(expectAsync1((listPharmas) {
      Pharma p = listPharmas[0];
      expect(p.name, "Pharmacie du Père Soulas");
    }));
  });
}
