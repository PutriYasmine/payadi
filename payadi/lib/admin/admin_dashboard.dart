import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        double iconSize = 36;
        double titleSize = 14;
        double valueSize = 18;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 3; // desktop
          iconSize = 40;
          titleSize = 16;
          valueSize = 20;
        } else if (constraints.maxWidth >= 700) {
          crossAxisCount = 2; // tablet
          iconSize = 38;
          titleSize = 15;
          valueSize = 19;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _card(
              "Total Produk",
              "12",
              Icons.inventory,
              iconSize,
              titleSize,
              valueSize,
            ),
            _card(
              "Total Pesanan",
              "34",
              Icons.shopping_cart,
              iconSize,
              titleSize,
              valueSize,
            ),
            _card(
              "Pendapatan",
              "Rp 12.500.000",
              Icons.monetization_on,
              iconSize,
              titleSize,
              valueSize,
            ),
          ],
        );
      },
    );
  }

  Widget _card(
    String title,
    String value,
    IconData icon,
    double iconSize,
    double titleSize,
    double valueSize,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.blueGrey),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: titleSize)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
