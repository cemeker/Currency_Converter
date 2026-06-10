import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<double?> berechneWaehrung(String basisWaehrung, String zielWaehrung, double betrag, {bool offlineModus = false}) async {
    final basis = basisWaehrung.toLowerCase();
    final ziel = zielWaehrung.toLowerCase();
    final cacheKey = 'api_cache_$basis';
    
    final prefs = await SharedPreferences.getInstance();

    // 1. Wenn der Nutzer den Offline-Modus aktiviert hat, sofort den Cache nutzen
    if (offlineModus) {
      return _holeAusCache(prefs, cacheKey, basis, ziel, betrag);
    }

    final url = Uri.parse('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$basis.json');

    try {
      final antwort = await http.get(url);

      if (antwort.statusCode == 200) {
        // 2. Juhuu, Internet geht! Wir speichern die Daten sofort als Backup für später.
        await prefs.setString(cacheKey, antwort.body);

        final daten = jsonDecode(antwort.body);
        final kurs = (daten[basis][ziel] as num).toDouble();
        return betrag * kurs;
      } else {
        // Server hat Probleme -> Fallback auf Cache
        return _holeAusCache(prefs, cacheKey, basis, ziel, betrag);
      }
    } catch (fehler) {
      // Kein Internet (Flugmodus) -> Fallback auf Cache
      return _holeAusCache(prefs, cacheKey, basis, ziel, betrag);
    }
  }

  // Hilfsfunktion: Liest die gespeicherten Kurse vom Handy aus
  double? _holeAusCache(SharedPreferences prefs, String cacheKey, String basis, String ziel, double betrag) {
    final gecachteDaten = prefs.getString(cacheKey);
    if (gecachteDaten != null) {
      try {
        final daten = jsonDecode(gecachteDaten);
        final kurs = (daten[basis][ziel] as num).toDouble();
        return betrag * kurs;
      } catch (e) {
        return null;
      }
    }
    return null; // Wenn der Cache komplett leer ist
  }
}
