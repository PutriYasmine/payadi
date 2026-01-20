import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;
  final bool isExpanded;
  final VoidCallback onToggle;

  const AdminSidebar({
    super.key,
    required this.onTap,
    required this.selectedIndex,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isExpanded ? 240 : 70,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ================= TOGGLE BUTTON =================
          Align(
            alignment: isExpanded ? Alignment.centerRight : Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: onToggle,
            ),
          ),

          const SizedBox(height: 10),

          // ================= HEADER =================
          if (isExpanded) ...[
            const CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 30,
                color: Color(0xFF203A43),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "ADMIN AMANURY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
          ] else
            const SizedBox(height: 30),

          // ================= MENU =================
          _menu(Icons.dashboard, "Dashboard", 0),
          _menu(Icons.inventory_2, "Produk", 1),
          _menu(Icons.shopping_cart_checkout, "Pesanan", 2),
          _menu(Icons.bar_chart, "Laporan", 3),

          const Spacer(),

          if (isExpanded)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "© Amanury 2025",
                style: TextStyle(color: Colors.white54, fontSize: 12),
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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.white70),
            if (isExpanded) ...[
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
