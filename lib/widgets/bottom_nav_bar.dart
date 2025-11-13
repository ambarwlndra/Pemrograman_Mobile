import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Import semua halaman
import '../pages/biodata_page.dart';
import '../pages/kontak_page.dart';
import '../pages/kalkulator_page.dart';
import '../pages/cuaca_page.dart';
import '../pages/berita_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;

  // Urutan halaman sesuai urutan ikon
  final List<Widget> _pages = const [
    BiodataPage(),
    KontakPage(),
    KalkulatorPage(),
    CuacaPage(),
    BeritaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF6F6F6),
      body: _pages[_page],

      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 500),

        // Urutan ikon sesuai halaman di atas
        items: const [
          Icon(Icons.person, size: 20, color: Colors.white),         // Biodata
          Icon(Icons.contacts, size: 20, color: Colors.white),       // Kontak
          Icon(Icons.calculate, size: 20, color: Colors.white),      // Kalkulator
          Icon(Icons.cloud, size: 20, color: Colors.white),          // Cuaca
          Icon(Icons.newspaper, size: 20, color: Colors.white),      // Berita
        ],

        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
