import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/api_service.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const CurrencyApp());
}

class CurrencyApp extends StatefulWidget {
  const CurrencyApp({super.key});

  @override
  State<CurrencyApp> createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  bool _darkMode = true;
  String _language = 'Deutsch';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CurrencyConverter',
      debugShowCheckedModeBanner: false,

      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.greenDark,
          surface: AppColors.lightCard,
        ),
      ),

      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.green,
          surface: AppColors.darkCard,
        ),
      ),

      builder: (context, child) {
        final isDark = _darkMode;

        return Container(
          color: isDark ? AppColors.darkBg : AppColors.lightOuterBg,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 430,
                maxHeight: kIsWeb ? 760 : double.infinity,
              ),
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },

      home: MainScreen(
        darkMode: _darkMode,
        language: _language,
        onDarkModeChanged: (value) {
          setState(() {
            _darkMode = value;
          });
        },
        onLanguageChanged: (value) {
          setState(() {
            _language = value;
          });
        },
      ),
    );
  }
}

// Farben
class AppColors {
  static const darkBg = Color(0xFF0A0E1A);
  static const darkCard = Color(0xFF111827);
  static const darkCardLight = Color(0xFF1A2235);
  static const darkText = Color(0xFFE8EDF5);
  static const darkTextMuted = Color(0xFF6B7A99);
  static const darkBorder = Color(0xFF1E2D45);

  static const lightBg = Color(0xFFF4F6FA);
  static const lightOuterBg = Color(0xFFE8EEF6);
  static const lightCard = Colors.white;
  static const lightCardLight = Color(0xFFF0F3F8);
  static const lightText = Color(0xFF111827);
  static const lightTextMuted = Color(0xFF65758B);
  static const lightBorder = Color(0xFFD7DEE9);

  static const green = Color(0xFF00FF9D);
  static const greenDark = Color(0xFF00A86B);
  static const red = Color(0xFFFF4D6A);
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color bgColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.darkBg : AppColors.lightBg;
}

Color cardColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.darkCard : AppColors.lightCard;
}

Color cardLightColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.darkCardLight : AppColors.lightCardLight;
}

Color textColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.darkText : AppColors.lightText;
}

Color mutedColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.darkTextMuted : AppColors.lightTextMuted;
}

Color borderColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.darkBorder : AppColors.lightBorder;
}

Color greenColor(BuildContext context) {
  return isDarkMode(context) ? AppColors.green : AppColors.greenDark;
}

// Wechselkurse, Basis EUR
const Map<String, double> kRates = {
  'EUR': 1.0,
  'USD': 1.085,
  'GBP': 0.856,
  'CHF': 0.972,
  'JPY': 161.4,
  'TRY': 35.2,
  'CAD': 1.472,
  'AUD': 1.653,
  'INR': 90.15,
  'BTC': 0.0000164,

  'AED': 3.98,
  'AFN': 77.1,
  'ALL': 100.2,
  'AMD': 420.0,
  'ANG': 1.95,
  'AOA': 930.0,
  'ARS': 930.0,
  'AWG': 1.95,
  'AZN': 1.84,
  'BAM': 1.96,
  'BBD': 2.17,
  'BDT': 127.0,
  'BGN': 1.96,
  'BHD': 0.41,
  'BIF': 3100.0,
  'BMD': 1.085,
  'BND': 1.46,
  'BOB': 7.50,
  'BRL': 5.40,
  'BSD': 1.085,
  'BTN': 90.1,
  'BWP': 14.8,
  'BYN': 3.55,
  'BZD': 2.18,
  'CDF': 3000.0,
  'CLP': 1030.0,
  'CNY': 7.85,
  'COP': 4250.0,
  'CRC': 560.0,
  'CUP': 26.0,
  'CVE': 110.0,
  'CZK': 25.2,
  'DJF': 193.0,
  'DKK': 7.46,
  'DOP': 64.0,
  'DZD': 145.0,
  'EGP': 52.0,
  'ETB': 61.0,
  'GEL': 2.95,
  'GHS': 16.0,
  'GMD': 73.0,
  'GNF': 9300.0,
  'GTQ': 8.45,
  'HKD': 8.48,
  'HNL': 26.8,
  'HRK': 7.53,
  'HUF': 390.0,
  'IDR': 17500.0,
  'ILS': 4.02,
  'IQD': 1420.0,
  'IRR': 45700.0,
  'ISK': 150.0,
  'JMD': 170.0,
  'JOD': 0.77,
  'KES': 140.0,
  'KGS': 96.0,
  'KHR': 4450.0,
  'KRW': 1480.0,
  'KWD': 0.33,
  'KZT': 485.0,
  'LAK': 23000.0,
  'LBP': 97000.0,
  'LKR': 325.0,
  'MAD': 10.8,
  'MDL': 19.3,
  'MKD': 61.5,
  'MMK': 3500.0,
  'MNT': 3700.0,
  'MOP': 8.75,
  'MXN': 18.5,
  'MYR': 5.10,
  'NGN': 1600.0,
  'NOK': 11.5,
  'NPR': 144.0,
  'NZD': 1.78,
  'OMR': 0.42,
  'PEN': 4.05,
  'PHP': 62.0,
  'PKR': 301.0,
  'PLN': 4.32,
  'QAR': 3.95,
  'RON': 4.97,
  'RSD': 117.0,
  'RUB': 98.0,
  'SAR': 4.07,
  'SEK': 11.3,
  'SGD': 1.46,
  'THB': 39.0,
  'TND': 3.38,
  'TWD': 35.0,
  'UAH': 43.0,
  'UYU': 42.0,
  'VND': 27500.0,
  'ZAR': 20.1,
};

const Map<String, String> kFlags = {
  'EUR': '🇪🇺',
  'USD': '🇺🇸',
  'GBP': '🇬🇧',
  'CHF': '🇨🇭',
  'JPY': '🇯🇵',
  'TRY': '🇹🇷',
  'CAD': '🇨🇦',
  'AUD': '🇦🇺',
  'INR': '🇮🇳',
  'BTC': '₿',
  'AED': '🇦🇪',
  'BRL': '🇧🇷',
  'CNY': '🇨🇳',
  'DKK': '🇩🇰',
  'EGP': '🇪🇬',
  'HKD': '🇭🇰',
  'ILS': '🇮🇱',
  'KRW': '🇰🇷',
  'MXN': '🇲🇽',
  'NOK': '🇳🇴',
  'NZD': '🇳🇿',
  'PLN': '🇵🇱',
  'RUB': '🇷🇺',
  'SAR': '🇸🇦',
  'SEK': '🇸🇪',
  'SGD': '🇸🇬',
  'THB': '🇹🇭',
  'UAH': '🇺🇦',
  'ZAR': '🇿🇦',
};

const Map<String, String> kNames = {
  'EUR': 'Euro',
  'USD': 'US-Dollar',
  'GBP': 'Brit. Pfund',
  'CHF': 'Schweizer Franken',
  'JPY': 'Japanischer Yen',
  'TRY': 'Türkische Lira',
  'CAD': 'Kanadischer Dollar',
  'AUD': 'Australischer Dollar',
  'INR': 'Indische Rupie',
  'BTC': 'Bitcoin',
};

String flagOf(String currency) {
  return kFlags[currency] ?? '💱';
}

String nameOf(String currency) {
  return kNames[currency] ?? currency;
}

String tr(String language, String de, String en) {
  return language == 'English' ? en : de;
}

// Header
class BrandHeader extends StatelessWidget {
  final bool showNotification;

  const BrandHeader({
    super.key,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: green.withOpacity(0.13),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: green.withOpacity(0.35)),
          ),
          child: Icon(
            Icons.currency_exchange,
            color: green,
            size: 19,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'CurrencyConverter',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: green,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (showNotification)
          Icon(
            Icons.notifications_outlined,
            color: mutedColor(context),
            size: 22,
          ),
      ],
    );
  }
}

// Hauptscreen
class MainScreen extends StatefulWidget {
  final bool darkMode;
  final String language;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String> onLanguageChanged;

  const MainScreen({
    super.key,
    required this.darkMode,
    required this.language,
    required this.onDarkModeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      ConverterScreen(language: widget.language),
      FavoritesScreen(language: widget.language),
      HistoryScreen(language: widget.language),
      SettingsScreen(
        darkMode: widget.darkMode,
        language: widget.language,
        onDarkModeChanged: widget.onDarkModeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: bgColor(context),
      body: screens[_tab],
      bottomNavigationBar: _BottomNav(
        current: _tab,
        language: widget.language,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// Bottom Navigation
class _BottomNav extends StatelessWidget {
  final int current;
  final String language;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.current,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    final items = [
      (Icons.currency_exchange, tr(language, 'Konverter', 'Converter')),
      (Icons.star_outline, tr(language, 'Favoriten', 'Favorites')),
      (Icons.show_chart, tr(language, 'Verlauf', 'History')),
      (Icons.settings_outlined, tr(language, 'Settings', 'Settings')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardColor(context),
        border: Border(top: BorderSide(color: borderColor(context))),
      ),
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = i == current;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].$1,
                    color: active ? green : mutedColor(context),
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: active ? green : mutedColor(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Konverter
class ConverterScreen extends StatefulWidget {
  final String language;

  const ConverterScreen({
    super.key,
    required this.language,
  });

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String _from = 'EUR';
  String _to = 'USD';
  String _input = '1000';

  double get _inputValue => double.tryParse(_input) ?? 1000;

  String _resultText = 'Lade...';
  
  @override
  void initState() {
    super.initState();
    // Das sagt der App: Rechne SOFORT einmal um, wenn du startest!
    _rechneMitApi(); 
  }

  Future<void> _rechneMitApi() async {
    final ergebnis = await ApiService().berechneWaehrung(_from, _to, _inputValue);
    if (ergebnis != null) {
      setState(() {
        _resultText = ergebnis.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _resultText = 'Fehler';
      });
    }
  }

  double get _rate => kRates[_to]! / kRates[_from]!;

  void _pressKey(String key) {
    setState(() {
      if (key == '⌫') {
        if (_input.length > 1) {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
        }
      } else if (key == '.') {
        if (!_input.contains('.')) {
          _input += '.';
        }
      } else {
        if (_input == '0') {
          _input = key;
        } else {
          _input += key;
        }
      }
    });
    _rechneMitApi();
  }

  void _swap() {
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
    _rechneMitApi();
  }

  String _formatDisplay(String raw) {
    final val = double.tryParse(raw);

    if (val == null) return raw;

    if (val >= 1000) {
      final parts = val.toStringAsFixed(0).split('');
      final result = StringBuffer();

      for (int i = 0; i < parts.length; i++) {
        if (i > 0 && (parts.length - i) % 3 == 0) {
          result.write('.');
        }
        result.write(parts[i]);
      }

      return result.toString();
    }

    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            children: [
              const BrandHeader(),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: cardColor(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor(context)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _CurrencyRow(
                      currency: _from,
                      amount: _formatDisplay(_input),
                      isFrom: true,
                      onTap: () => _pickCurrency(true),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(child: Divider(color: borderColor(context))),
                        GestureDetector(
                          onTap: _swap,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: green.withOpacity(0.35)),
                            ),
                            child: Icon(
                              Icons.swap_vert,
                              color: green,
                              size: 19,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: borderColor(context))),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _CurrencyRow(
                      currency: _to,
                      amount: _resultText,
                      isFrom: false,
                      onTap: () => _pickCurrency(false),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor(context),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            '1 $_from =',
                            style: TextStyle(
                              color: mutedColor(context),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${_rate.toStringAsFixed(4)} $_to',
                            style: TextStyle(
                              color: textColor(context),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '+0.2%',
                              style: TextStyle(
                                color: green,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _Numpad(onKey: _pressKey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCurrency(bool isFrom) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _CurrencyPicker(selected: isFrom ? _from : _to);
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _from = picked;
        } else {
          _to = picked;
        }
      });
      _rechneMitApi();
    }
  }
}

class _CurrencyRow extends StatelessWidget {
  final String currency;
  final String amount;
  final bool isFrom;
  final VoidCallback onTap;

  const _CurrencyRow({
    required this.currency,
    required this.amount,
    required this.isFrom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: cardLightColor(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor(context)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  flagOf(currency),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 7),
                Text(
                  currency,
                  style: TextStyle(
                    color: textColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: mutedColor(context),
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  amount,
                  maxLines: 1,
                  style: TextStyle(
                    color: isFrom ? textColor(context) : green,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Text(
                nameOf(currency),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: mutedColor(context),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Numpad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const _Numpad({
    required this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          children: row.map((key) {
            final isDelete = key == '⌫';

            return Expanded(
              child: GestureDetector(
                onTap: () => onKey(key),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDelete ? green.withOpacity(0.12) : cardColor(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDelete ? green.withOpacity(0.35) : borderColor(context),
                    ),
                  ),
                  child: Center(
                    child: isDelete
                        ? Icon(
                            Icons.backspace_outlined,
                            color: green,
                            size: 20,
                          )
                        : Text(
                            key,
                            style: TextStyle(
                              color: textColor(context),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _CurrencyPicker extends StatelessWidget {
  final String selected;

  const _CurrencyPicker({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: borderColor(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Währung wählen',
            style: TextStyle(
              color: textColor(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: kRates.keys.map((currency) {
                final selectedCurrency = currency == selected;

                return ListTile(
                  leading: Text(
                    flagOf(currency),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    currency,
                    style: TextStyle(
                      color: selectedCurrency ? green : textColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    nameOf(currency),
                    style: TextStyle(
                      color: mutedColor(context),
                      fontSize: 12,
                    ),
                  ),
                  trailing: selectedCurrency
                      ? Icon(Icons.check_circle, color: green)
                      : null,
                  onTap: () => Navigator.pop(context, currency),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Favoriten
class FavoritesScreen extends StatefulWidget {
  final String language;

  const FavoritesScreen({
    super.key,
    required this.language,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<(String, String, double, double)> _favs = [
    ('EUR', 'USD', 1.0850, 0.2),
    ('GBP', 'EUR', 1.1712, -0.8),
    ('BTC', 'EUR', 58420.0, 2.1),
  ];

  Future<void> _addFavorite() async {
    String from = 'EUR';
    String to = 'USD';

    final result = await showModalBottomSheet<(String, String)>(
      context: context,
      backgroundColor: cardColor(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: borderColor(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      tr(widget.language, 'Währungspaar hinzufügen', 'Add currency pair'),
                      style: TextStyle(
                        color: textColor(context),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _CurrencyDropdown(
                      label: tr(widget.language, 'Von', 'From'),
                      value: from,
                      onChanged: (value) {
                        setModalState(() {
                          from = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _CurrencyDropdown(
                      label: tr(widget.language, 'Nach', 'To'),
                      value: to,
                      onChanged: (value) {
                        setModalState(() {
                          to = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, (from, to));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor(context),
                          foregroundColor: isDarkMode(context)
                              ? AppColors.darkBg
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.add),
                        label: Text(
                          tr(widget.language, 'Hinzufügen', 'Add'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      final rate = kRates[result.$2]! / kRates[result.$1]!;

      setState(() {
        _favs.add((result.$1, result.$2, rate, 0.0));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.$1} / ${result.$2} wurde hinzugefügt'),
          backgroundColor: cardColor(context),
        ),
      );
    }
  }

  void _deleteFavorite(int index) {
    final deleted = _favs[index];

    setState(() {
      _favs.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deleted.$1} / ${deleted.$2} wurde gelöscht'),
        backgroundColor: cardColor(context),
      ),
    );
  }

  void _clearFavorites() {
    setState(() {
      _favs.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr(widget.language, 'Alle Favoriten wurden gelöscht', 'All favorites deleted')),
        backgroundColor: cardColor(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandHeader(showNotification: true),
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: Text(
                    tr(widget.language, 'Favoriten', 'Favorites'),
                    style: TextStyle(
                      color: textColor(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_favs.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearFavorites,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                      size: 18,
                    ),
                    label: Text(
                      tr(widget.language, 'Alle löschen', 'Delete all'),
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: _favs.isEmpty
                  ? Center(
                      child: Text(
                        tr(widget.language, 'Keine Favoriten vorhanden', 'No favorites yet'),
                        style: TextStyle(color: mutedColor(context)),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _favs.length,
                      itemBuilder: (_, i) {
                        final f = _favs[i];
                        final positive = f.$4 >= 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor(context)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: green.withOpacity(0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${f.$1} / ${f.$2}',
                                      style: TextStyle(
                                        color: textColor(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      nameOf(f.$1),
                                      style: TextStyle(
                                        color: mutedColor(context),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    f.$3 > 1000
                                        ? f.$3.toStringAsFixed(0)
                                        : f.$3.toStringAsFixed(4),
                                    style: TextStyle(
                                      color: textColor(context),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${positive ? '+' : ''}${f.$4.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: positive ? green : AppColors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 10),

                              GestureDetector(
                                onTap: () => _deleteFavorite(i),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            GestureDetector(
              onTap: _addFavorite,
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: green.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: green),
                    const SizedBox(width: 8),
                    Text(
                      tr(widget.language, 'Währungspaar hinzufügen', 'Add currency pair'),
                      style: TextStyle(
                        color: green.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencyDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: cardColor(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: mutedColor(context)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenColor(context)),
        ),
      ),
      items: kRates.keys.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(
            '${flagOf(currency)} $currency',
            style: TextStyle(color: textColor(context)),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

// Verlauf
class HistoryScreen extends StatefulWidget {
  final String language;

  const HistoryScreen({
    super.key,
    required this.language,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<(String, String, double, double)> items = [
    ('EUR', 'USD', 150.0, 163.24),
    ('GBP', 'EUR', 1200.0, 1409.50),
    ('CHF', 'EUR', 50.0, 51.20),
    ('JPY', 'USD', 5000.0, 32.15),
    ('EUR', 'USD', 200.0, 184.50),
  ];

  void _clearHistory() {
    setState(() {
      items.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr(widget.language, 'Verlauf wurde gelöscht', 'History deleted')),
        backgroundColor: cardColor(context),
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandHeader(showNotification: true),
            const SizedBox(height: 18),

            Text(
              tr(widget.language, 'Währungs-Zentrale', 'Currency Center'),
              style: TextStyle(
                color: textColor(context),
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tr(widget.language, 'Verlauf deiner letzten Umrechnungen', 'History of your last conversions'),
              style: TextStyle(
                color: mutedColor(context),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: cardColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor(context)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: mutedColor(context), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: textColor(context), fontSize: 14),
                      decoration: InputDecoration(
                        hintText: tr(widget.language, 'Suche nach Land oder Währung', 'Search country or currency'),
                        hintStyle: TextStyle(
                          color: mutedColor(context),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    tr(widget.language, 'Letzte Abfragen', 'Recent queries'),
                    style: TextStyle(
                      color: textColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (items.isNotEmpty)
                  TextButton(
                    onPressed: _clearHistory,
                    child: Text(
                      tr(widget.language, 'ALLE LÖSCHEN', 'DELETE ALL'),
                      style: TextStyle(
                        color: green,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        tr(widget.language, 'Noch kein Verlauf vorhanden', 'No history yet'),
                        style: TextStyle(color: mutedColor(context)),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final item = items[i];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardColor(context),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor(context)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.currency_exchange,
                                  color: green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.$1} zu ${item.$2}',
                                      style: TextStyle(
                                        color: textColor(context),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${flagOf(item.$1)} ${item.$1} • 1 MIN',
                                      style: TextStyle(
                                        color: mutedColor(context),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item.$3.toStringAsFixed(2)} ${item.$1}',
                                    style: TextStyle(
                                      color: mutedColor(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${item.$4.toStringAsFixed(2)} ${item.$2}',
                                    style: TextStyle(
                                      color: green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 8),

                              GestureDetector(
                                onTap: () => _deleteItem(i),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: mutedColor(context),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings
class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final String language;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String> onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.language,
    required this.onDarkModeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _offlineMode = false;
  String _homeCurrency = 'EUR';
  String _fontSize = 'Standard';
  int _cacheSize = 234;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: cardColor(context),
      ),
    );
  }

  Future<void> _pickLanguage() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _OptionSheet(
          title: tr(widget.language, 'Sprache auswählen', 'Choose language'),
          options: const ['Deutsch', 'English'],
          selected: widget.language,
        );
      },
    );

    if (result != null) {
      widget.onLanguageChanged(result);
      _showMessage(
        result == 'English'
            ? 'Language changed to English'
            : 'Sprache wurde auf Deutsch geändert',
      );
    }
  }

  Future<void> _pickHomeCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _OptionSheet(
          title: tr(widget.language, 'Heimwährung auswählen', 'Choose home currency'),
          options: kRates.keys.toList(),
          selected: _homeCurrency,
        );
      },
    );

    if (result != null) {
      setState(() {
        _homeCurrency = result;
      });

      _showMessage(
        tr(
          widget.language,
          'Heimwährung wurde auf $result geändert',
          'Home currency changed to $result',
        ),
      );
    }
  }

  Future<void> _pickFontSize() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _OptionSheet(
          title: tr(widget.language, 'Schriftgröße auswählen', 'Choose font size'),
          options: const ['Klein', 'Standard', 'Groß'],
          selected: _fontSize,
        );
      },
    );

    if (result != null) {
      setState(() {
        _fontSize = result;
      });

      _showMessage(
        tr(widget.language, 'Schriftgröße wurde geändert', 'Font size changed'),
      );
    }
  }

  void _clearCache() {
    setState(() {
      _cacheSize = 0;
    });

    _showMessage(
      tr(widget.language, 'Cache wurde geleert', 'Cache cleared'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          const BrandHeader(),
          const SizedBox(height: 20),

          Text(
            tr(widget.language, 'App Einstellungen', 'App Settings'),
            style: TextStyle(
              color: textColor(context),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            tr(
              widget.language,
              'Verwalte deine Einstellungen und passe die App an.',
              'Manage your settings and customize the app.',
            ),
            style: TextStyle(
              color: mutedColor(context),
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          _SettingsSection(
            title: tr(widget.language, 'ALLGEMEIN', 'GENERAL'),
            items: [
              _SettingsTile(
                icon: Icons.translate,
                label: tr(widget.language, 'Sprache', 'Language'),
                onTap: _pickLanguage,
                trailing: Text(
                  '${widget.language} ›',
                  style: TextStyle(color: mutedColor(context), fontSize: 13),
                ),
              ),
              _SettingsTile(
                icon: Icons.home_outlined,
                label: tr(widget.language, 'Heimwährung', 'Home currency'),
                onTap: _pickHomeCurrency,
                trailing: Text(
                  '$_homeCurrency ›',
                  style: TextStyle(color: mutedColor(context), fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _SettingsSection(
            title: tr(widget.language, 'DARSTELLUNG', 'APPEARANCE'),
            items: [
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                label: tr(widget.language, 'Dunkelmodus', 'Dark mode'),
                trailing: Switch(
                  value: widget.darkMode,
                  onChanged: (value) {
                    widget.onDarkModeChanged(value);

                    _showMessage(
                      value
                          ? tr(widget.language, 'Dunkelmodus aktiviert', 'Dark mode enabled')
                          : tr(widget.language, 'Hellmodus aktiviert', 'Light mode enabled'),
                    );
                  },
                  activeThumbColor: greenColor(context),
                ),
              ),
              _SettingsTile(
                icon: Icons.text_fields,
                label: tr(widget.language, 'Schriftgröße', 'Font size'),
                onTap: _pickFontSize,
                trailing: Text(
                  '$_fontSize ›',
                  style: TextStyle(color: mutedColor(context), fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _SettingsSection(
            title: tr(widget.language, 'DATEN', 'DATA'),
            items: [
              _SettingsTile(
                icon: Icons.wifi_off_outlined,
                label: tr(widget.language, 'Offline-Modus', 'Offline mode'),
                trailing: Switch(
                  value: _offlineMode,
                  onChanged: (value) {
                    setState(() {
                      _offlineMode = value;
                    });

                    _showMessage(
                      value
                          ? tr(widget.language, 'Offline-Modus aktiviert', 'Offline mode enabled')
                          : tr(widget.language, 'Offline-Modus deaktiviert', 'Offline mode disabled'),
                    );
                  },
                  activeThumbColor: greenColor(context),
                ),
              ),
              _SettingsTile(
                icon: Icons.cleaning_services_outlined,
                label: tr(widget.language, 'Cache leeren', 'Clear cache'),
                onTap: _clearCache,
                trailing: Text(
                  _cacheSize == 0
                      ? tr(widget.language, 'Leer ›', 'Empty ›')
                      : '$_cacheSize KB ›',
                  style: TextStyle(color: mutedColor(context), fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;

  const _OptionSheet({
    required this.title,
    required this.options,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final green = greenColor(context);

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor(context),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...options.map((option) {
            final active = option == selected;

            return ListTile(
              title: Text(
                option,
                style: TextStyle(
                  color: active ? green : textColor(context),
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: active
                  ? Icon(Icons.check_circle, color: green)
                  : null,
              onTap: () => Navigator.pop(context, option),
            );
          }),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: mutedColor(context),
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor(context)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;

              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: borderColor(context),
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: greenColor(context),
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor(context),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: trailing,
      dense: true,
    );
  }
}