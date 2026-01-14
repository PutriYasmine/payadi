import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const AdminSidebar({
    super.key,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color.fromARGB(255, 22, 43, 66),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "ADMIN AMANURY",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 30),
          _menu(Icons.dashboard, "Dashboard", 0),
          _menu(Icons.inventory, "Produk", 1),
          _menu(Icons.shopping_cart, "Pesanan", 2),
          _menu(Icons.bar_chart, "Laporan", 3),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title, int index) {
    return ListTile(
      selected: selectedIndex == index,
      selectedTileColor: Colors.grey.shade800,
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => onTap(index),
    );
  }
}
