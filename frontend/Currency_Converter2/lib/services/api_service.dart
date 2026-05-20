import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  
  // Diese Funktion ruft die main.dart später auf
  Future<double?> berechneWaehrung(String basisWaehrung, String zielWaehrung, double betrag) async {
    final basis = basisWaehrung.toLowerCase();
    final ziel = zielWaehrung.toLowerCase();

    // Euer GitHub API Link
    final url = Uri.parse('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$basis.json');

    try {
      final antwort = await http.get(url);

      if (antwort.statusCode == 200) {
        final daten = jsonDecode(antwort.body);
        final kurs = (daten[basis][ziel] as num).toDouble();
        return betrag * kurs;
      } else {
        print("Fehler beim Abruf: ${antwort.statusCode}");
        return null;
      }
    } catch (fehler) {
      print("Netzwerkfehler: $fehler");
      return null;
    }
  }
}
