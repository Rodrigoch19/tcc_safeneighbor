import 'dart:convert';
import 'dart:io' show Platform;
import 'chat_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  String _currentAddress = "Clique no botão para buscar sua localização exata.";

  bool _isLoading = false;
  bool _isClassified = false;

  String _selectedSeverity = 'Zona de Perigo';

  int _timeIndex = 0;

  final List<String> _fixedTimes = [
    "há 1h",
    "há 6h",
  ];

  final Map<String, Color> _severities = {
    'Zona de Risco': Colors.yellow,
    'Zona de Perigo': Colors.orange,
    'Zona Crítica': Colors.red,
  };

  // =========================
  // PEGAR LOCALIZAÇÃO
  // =========================

  Future<void> _getRealTimeLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _currentAddress = "Buscando localização...";
    });

    if (!kIsWeb && Platform.isWindows) {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _currentAddress =
            "Rua Fictícia de Testes, 123\nCentro - São Paulo/SP\n(Simulação Windows)";
        _isLoading = false;
      });
      return;
    }

    try {
      final Position position = await _determinePosition();

      try {
        final String address = await _reverseGeocodeWithGoogleMaps(
          position.latitude,
          position.longitude,
        );

        if (!mounted) return;

        setState(() {
          _currentAddress = address;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _currentAddress =
              "Localização obtida, mas não foi possível converter o endereço.\n"
              "Latitude: ${position.latitude}\nLongitude: ${position.longitude}";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = "Erro ao obter localização: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _reverseGeocodeWithGoogleMaps(
    double latitude,
    double longitude,
  ) async {
    const String apiKey = 'AIzaSyDHBAFIlEN8qwa-cMNbzlFcJQo_g2Ebk6wf';

    final Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=$latitude,$longitude'
      '&key=$apiKey'
      '&language=pt-BR'
      '&result_type=street_address|route|intersection|premise|subpremise'
      '&location_type=ROOFTOP|RANGE_INTERPOLATED|GEOMETRIC_CENTER',
    );

    final http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      throw 'Erro na API do Google Maps: ${response.statusCode}';
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['status'] != 'OK' ||
        data['results'] is! List ||
        data['results'].isEmpty) {
      throw 'Nenhum endereço encontrado para esta localização.';
    }

    final List<dynamic> results = data['results'] as List<dynamic>;
    final Map<String, dynamic> result = _pickBestGeocodeResult(results);

    return result['formatted_address']?.toString() ??
        'Latitude: $latitude\nLongitude: $longitude';
  }

  Map<String, dynamic> _pickBestGeocodeResult(List<dynamic> results) {
    final List<Map<String, dynamic>> typedResults =
        results.map((item) => Map<String, dynamic>.from(item as Map)).toList();

    typedResults.sort((a, b) {
      final int scoreA = _geocodeScore(a);
      final int scoreB = _geocodeScore(b);
      return scoreB.compareTo(scoreA);
    });

    return typedResults.first;
  }

  int _geocodeScore(Map<String, dynamic> result) {
    final List<dynamic> types =
        result['types'] as List<dynamic>? ?? <dynamic>[];
    final List<dynamic> addressComponents =
        result['address_components'] as List<dynamic>? ?? <dynamic>[];

    int score = 0;

    if (types.contains('street_address')) score += 100;
    if (types.contains('route')) score += 90;
    if (types.contains('intersection')) score += 80;
    if (types.contains('premise')) score += 70;
    if (types.contains('subpremise')) score += 60;
    if (types.contains('neighborhood')) score += 20;
    if (types.contains('locality')) score += 10;

    score += addressComponents.length;
    return score;
  }

  // =========================
  // PERMISSÕES GPS
  // =========================

  Future<Position> _determinePosition() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'O GPS está desativado. Ative a localização no aparelho.';
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Permissão de localização negada. Aceite a permissão para continuar.';
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Permissão de localização negada permanentemente. Abra as configurações do app.';
    }

    if (permission == LocationPermission.unableToDetermine) {
      throw 'Não foi possível confirmar a permissão de localização.';
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      timeLimit: const Duration(seconds: 15),
    );
  }

  // =========================
  // ENVIAR CLASSIFICAÇÃO
  // =========================

  void _sendSeverityClassification() {
    setState(() {
      _isClassified = true;
      _timeIndex = (_timeIndex + 1) % _fixedTimes.length;
    });

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          content: Text(
            "Classificação enviada! "
            "Exibindo tempo: ${_fixedTimes[_timeIndex]}",
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = _severities[_selectedSeverity] ?? Colors.black;

    String timeToShow =
        _timeIndex == 0 ? _fixedTimes.last : _fixedTimes[_timeIndex - 1];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1E3A8A),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'SafeNeighbor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            const Text(
              'Mapa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // ÁREA PRINCIPAL
            // =========================

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 50,
                          color: Colors.redAccent,
                        ),

                        const SizedBox(height: 16),

                        // =========================
                        // ENDEREÇO
                        // =========================

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  _currentAddress,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // =========================
                        // BOTÃO GPS
                        // =========================

                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _getRealTimeLocation,
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Pegar Minha Localização',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // =========================
                        // GRAVIDADE
                        // =========================

                        Text(
                          "Gravidade Selecionada:\n$_selectedSeverity",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: activeColor,
                          ),
                        ),

                        // =========================
                        // ALERTA COMUNITÁRIO
                        // =========================

                        if (_isClassified) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: activeColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: activeColor.withAlpha(90),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.campaign,
                                  size: 18,
                                  color: activeColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Classificado por um usuário $timeToShow",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: activeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildLegenda(),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _sendSeverityClassification,
                  icon: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Enviar Alerta',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F1D1D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Chat de Dúvidas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // =========================
  // LEGENDA
  // =========================

  Widget _buildLegenda() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legenda - Selecione a gravidade da área',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ..._severities.entries.map(
            (item) => _buildSeverityItem(
              item.key,
              item.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityItem(
    String label,
    Color color,
  ) {
    bool isSelected = label == _selectedSeverity;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSeverity = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withAlpha(25) : Colors.transparent,
            border: Border.all(
              color:
                  isSelected ? Colors.white.withAlpha(90) : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
