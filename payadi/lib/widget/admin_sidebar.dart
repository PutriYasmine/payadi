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
      width: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // ================= HEADER =================
          Column(
            children: const [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 32,
                  color: Color(0xFF203A43),
                ),
              ),
              SizedBox(height: 12),
              Text(
                "ADMIN AMANURY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // ================= MENU =================
          _menu(Icons.dashboard, "Dashboard", 0),
          _menu(Icons.inventory_2, "Produk", 1),
          _menu(Icons.shopping_cart_checkout, "Pesanan", 2),
          _menu(Icons.bar_chart, "Laporan", 3),

          const Spacer(),

          // ================= FOOTER =================
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "© Amanury 2025",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title, int index) {
    final bool isActive = selectedIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 15,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
