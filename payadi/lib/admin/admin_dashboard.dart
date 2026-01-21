import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard Overview",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  "Selamat datang di pusat kendali Payadi",
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ================= STATS CARDS =================
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1000
                    ? 3
                    : (constraints.maxWidth > 600 ? 2 : 1);
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(
                      title: "Total Produk",
                      value: "152",
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF3B82F6),
                      trend: "+12% dari bulan lalu",
                    ),
                    _StatCard(
                      title: "Total Pesanan",
                      value: "1,240",
                      icon: Icons.shopping_bag_rounded,
                      color: const Color(0xFF10B981),
                      trend: "+8.4% dari bulan lalu",
                    ),
                    _StatCard(
                      title: "Revenue",
                      value: "Rp 12.5M",
                      icon: Icons.payments_rounded,
                      color: const Color(0xFF8B5CF6),
                      trend: "+15% dari bulan lalu",
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 48),

            // ================= RECENT ACTIVITY SECTION =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aktivitas Terakhir",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text("Lihat Semua")),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  _ActivityItem(
                    title: "Produk baru ditambahkan",
                    subtitle: "Amanury Floral Mist Special Edition",
                    time: "2 jam yang lalu",
                    icon: Icons.add_circle_outline,
                    iconColor: Colors.blue,
                  ),
                  const Divider(indent: 70, height: 1),
                  _ActivityItem(
                    title: "Pesanan baru #8812",
                    subtitle: "Pembayaran terverifikasi - Rp 250.000",
                    time: "5 jam yang lalu",
                    icon: Icons.shopping_cart_outlined,
                    iconColor: Colors.green,
                  ),
                  const Divider(indent: 70, height: 1),
                  _ActivityItem(
                    title: "Stok menipis",
                    subtitle: "Amanury Oud Series (Sisa 3 unit)",
                    time: "Yesterday",
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
      ),
    );
  }
}
