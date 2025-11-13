import 'package:flutter/material.dart';

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  // Daftar kontak dikelompokkan berdasarkan huruf awal
  final Map<String, List<Map<String, String>>> groupedContacts = const {
    'A': [
      {'nama': 'Auriel Hana', 'telepon': '081234567890', 'foto': 'assets/profile1.jpg'},
      {'nama': 'Angga Aldi', 'telepon': '081234567891', 'foto': 'assets/profile2.jpg'},
      {'nama': 'Aira Zahra Putri', 'telepon': '081234567892', 'foto': 'assets/profile3.jpg'},
      {'nama': 'Allysa R', 'telepon': '081234567893', 'foto': 'assets/profile4.jpg'},
    ],
    'B': [
      {'nama': 'Bella Ayu', 'telepon': '081987654321', 'foto': 'assets/profile5.jpg'},
      {'nama': 'Billy Davidson', 'telepon': '081987654322', 'foto': 'assets/profile6.jpg'},
      {'nama': 'Bian Aditya Nugraha', 'telepon': '081987654323', 'foto': 'assets/profile7.jpg'},
    ],
    'C': [
      {'nama': 'Cinta Laura', 'telepon': '082134567890', 'foto': 'assets/profile8.jpg'},
      {'nama': 'Cut Meyriska', 'telepon': '082134567891', 'foto': 'assets/profile9.jpg'},
      {'nama': 'Caesar Hito', 'telepon': '082134567892', 'foto': 'assets/profile10.jpg'},
      {'nama': 'Cindy Oktavia', 'telepon': '082134567893', 'foto': 'assets/profile11.jpg'},
      {'nama': 'Celline', 'telepon': '082134567894', 'foto': 'assets/profile12.jpg'},
    ],
    'D': [
      {'nama': 'Dimas Anggara', 'telepon': '085678901234', 'foto': 'assets/profile13.jpg'},
      {'nama': 'Deva Mahendra', 'telepon': '085678901235', 'foto': 'assets/profile14.jpg'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.add, size: 26),
                    SizedBox(width: 15),
                    Icon(Icons.search, size: 26),
                    SizedBox(width: 15),
                    Icon(Icons.more_vert, size: 26),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Telepon",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "15 kontak dengan nomor telepon",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),

          //PROFIL SAYA
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              title: const Text("Ambar Wulandara",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Profil saya"),
            ),
          ),

          const SizedBox(height: 10),

          // DAFTAR KONTAK BERKELOMPOK
          Expanded(
            child: ListView(
              children: groupedContacts.entries.map((entry) {
                final String huruf = entry.key;
                final List<Map<String, String>> daftar = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        huruf,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                    ),
                    ...daftar.map((kontak) {
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(kontak['foto']!),
                          ),
                          title: Text(
                            kontak['nama']!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(kontak['telepon']!),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
