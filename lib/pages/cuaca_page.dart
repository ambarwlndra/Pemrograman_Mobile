import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CuacaPage extends StatefulWidget {
  const CuacaPage({super.key});

  @override
  State<CuacaPage> createState() => _CuacaPageState();
}

class _CuacaPageState extends State<CuacaPage> {
  Map<String, dynamic>? weather;
  String? lokasi;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    const url = 'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=32.73.01.1001';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lokasiData = data['lokasi'];
        final cuacaHariIni = data['data'][0]['cuaca'][0][0];
        setState(() {
          weather = cuacaHariIni;
          lokasi = "${lokasiData['desa']}, ${lokasiData['kotkab']}, ${lokasiData['provinsi']}";
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetchWeather: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cuaca Hari Ini',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(child: Text("Gagal memuat data cuaca 😢"))
          : buildWeatherInfo(),
    );
  }

  Widget buildWeatherInfo() {
    final suhu = weather?['t']?.toString() ?? '--';
    final kondisi = weather?['weather_desc'] ?? 'Tidak diketahui';
    final kelembapan = weather?['hu']?.toString() ?? '--';
    final angin = weather?['ws']?.toString() ?? '--';
    final arahAngin = weather?['wd'] ?? '--';
    final iconUrl = weather?['image'] ??
        'https://cdn-icons-png.flaticon.com/512/1116/1116453.png';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          // besar suhu
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6EC6FF), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  lokasi ?? 'Bandung',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                ),

                Text(
                  kondisi,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white70, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 5),
                Text(
                  "Update: ${weather?['datetime'] ?? '-'}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),


                Image.network(
                  iconUrl,
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stack) =>
                  const Icon(Icons.cloud, color: Colors.white, size: 100),
                ),
                const SizedBox(height: 10),
                Text(
                  "$suhu°C",
                  style: const TextStyle(
                    fontSize: 64,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  kondisi,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white70, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                // Info kecil di bawah suhu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MiniInfo(icon: Icons.water_drop, label: 'Humidity', value: '$kelembapan%'),
                    _MiniInfo(icon: Icons.air, label: 'Wind', value: '$angin km/h'),
                    _MiniInfo(icon: Icons.navigation, label: 'Direction', value: arahAngin),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 📅 Ramalan 7 Hari (Dummy)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "7-Day Forecasts",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: List.generate(7, (index) {
                final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                final weathers = [
                  "Mostly Clear",
                  "Thunderstorm",
                  "Windy",
                  "Partly Cloudy",
                  "Sunny",
                  "Showers",
                  "Cloudy"
                ];
                final temps = ["29°/16°", "28°/18°", "30°/19°", "31°/20°", "33°/22°", "32°/21°", "28°/17°"];

                return ListTile(
                  leading: Icon(Icons.wb_sunny, color: Colors.blueAccent.shade400),
                  title: Text(days[index],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(weathers[index]),
                  trailing: Text(temps[index],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniInfo({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
