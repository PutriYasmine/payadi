import 'package:flutter/material.dart';

class LaporanAdminPage extends StatelessWidget {
  const LaporanAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Total Penjualan Bulan Ini",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Rp 12.500.000",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
