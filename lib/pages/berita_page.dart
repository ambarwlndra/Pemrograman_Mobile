import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';


class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  String? sunsetTime;
  Map<String, dynamic>? weather;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();

    // refresh otomatis tiap 10 menit
    Timer.periodic(const Duration(minutes: 10), (timer) {
      fetchWeather();
    });
  }


  Future<void> fetchWeather() async {
      const cuacaUrl =
          'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=32.73.01.1001'; // Bandung
      const sunsetUrl =
          'https://api.sunrisesunset.io/json?lat=-6.9175&lng=107.6191&timezone=Asia/Jakarta'; // Bandung

      try {
        final response = await http.get(Uri.parse(cuacaUrl));
        final sunsetResponse = await http.get(Uri.parse(sunsetUrl));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final cuacaHariIni = data['data'][0]['cuaca'][0][0];

          // ambil waktu sunset
          if (sunsetResponse.statusCode == 200) {
            final sunsetData = jsonDecode(sunsetResponse.body);
            sunsetTime = sunsetData['results']?['sunset'] ?? '–';
          }

          setState(() {
            weather = cuacaHariIni;
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
    final List<Map<String, String>> beritaList = [
      {
        'sumber': 'KOMPAS TV',
        'judul':
        'Menkeu Purbaya Sampaikan Keinginan Ikut ke China untuk Bahas Proyek KCIC',
        'gambar': 'assets/berita1.jpg',
        'waktu': '1 jam lalu',
      },
      {
        'sumber': 'CNN Indonesia',
        'judul':
        'Fakta Terduga Siswa Pelaku Ledakan SMA 72, Merasa Tertindas dan Dendam',
        'gambar': 'assets/berita2.jpg',
        'waktu': '2 jam lalu',
      },
      {
        'sumber': 'Detik News',
        'judul': 'BMKG: Perkirakan Bandung dan mayoritas wilayah berawan-hujan',
        'gambar': 'assets/berita3.jpg',
        'waktu': '3 jam lalu',
      },
      {
        'sumber': 'CNN Indonesia',
        'judul': 'Piala Dunia U-17 2025: Hakikat Timnas Indonesia Naik Kelas',
        'gambar': 'assets/berita4.jpg',
        'waktu': '8 jam lalu',
      },
    ];

    // Data cuaca
    final suhu = weather?['t']?.toString() ?? '26';
    final kelembapan = weather?['hu']?.toString() ?? '76';
    final kondisi = weather?['weather_desc'] ?? 'Berawan';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CUACA
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header Bandung
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Bandung",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/profile.jpg'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 3 Kartu
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _WeatherCard(
                          icon: Icons.cloud,
                          label: '$suhu°C',
                          sub: '$kelembapan%',
                        ),
                        _WeatherCard(
                          icon: Icons.wb_sunny_outlined,
                          label: sunsetTime ?? '–',
                          sub: 'Matahari Terbenam',
                        ),
                        const _WeatherCard(
                          icon: Icons.settings,
                          label: 'Sesi',
                          sub: 'Berita Terbaru',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // DAFTAR BERITA
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: beritaList.map((berita) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              berita['gambar']!,
                              width: 90,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            berita['judul']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${berita['sumber']} • ${berita['waktu']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: const Icon(Icons.more_vert, size: 20),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk kartu cuaca
class _WeatherCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;

  const _WeatherCard({
    required this.icon,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
