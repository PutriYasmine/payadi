import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // ================= TOGGLE BUTTON =================
          Align(
            alignment: isExpanded ? Alignment.centerRight : Alignment.center,
            child: IconButton(
              icon: Icon(
                isExpanded ? Icons.chevron_left : Icons.menu,
                color: const Color(0xFF64748B),
              ),
              onPressed: onToggle,
            ),
          ),

          const SizedBox(height: 8),

          // ================= HEADER =================
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 24,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payadi Admin",
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Administrator",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 24),

          // ================= MENU =================
          _menu(Icons.grid_view_rounded, "Dashboard", 0),
          _menu(Icons.inventory_2_outlined, "Produk", 1),
          _menu(Icons.category_outlined, "Kategori", 2),
          _menu(Icons.shopping_bag_outlined, "Pesanan", 3),
          _menu(Icons.bar_chart_rounded, "Laporan", 4),

          const Spacer(),

          // ================= LOGOUT =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: isExpanded
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    if (isExpanded) ...[
                      const SizedBox(width: 14),
                      const Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          if (isExpanded)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "v1.0.0",
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title, int index) {
    final bool isActive = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B82F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : const Color(0xFF64748B),
              ),
              if (isExpanded) ...[
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
