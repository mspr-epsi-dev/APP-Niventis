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
    test('no location return all pharmas', () {
      Future<List<Pharma>> pharmas = Pharma.getPharmas(null, null);
      pharmas.then(expectAsync1((listPharmas){
        expect(listPharmas.length, 5);
      }));
    });

    test('with location return pharmas', () {
      Future<List<Pharma>> pharmas = Pharma.getPharmas(43.6426727, 3.8382165);
      pharmas.then(expectAsync1((listPharmas){
        expect(listPharmas.length, inInclusiveRange(1, 5));
      }));
    });
  });
  // Class Address
  group('Address', () {
    test('return good address', () {
      Future<List<Pharma>> pharmas = Pharma.getPharmas(null, null);
      pharmas.then(expectAsync1((listPharmas){
        Pharma p = listPharmas[0];
        Address adresse = p.address;
        expect(adresse.nbr, 34);
        expect(adresse.city, "Montpellier");
        expect(adresse.street, "Boulevard du jeu de Paume");
      }));
    });
  });
}
