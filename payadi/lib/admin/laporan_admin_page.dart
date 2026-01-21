import 'package:flutter/material.dart';

class LaporanAdminPage extends StatelessWidget {
  const LaporanAdminPage({super.key});

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
                  "Laporan & Analisis",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  "Data performa penjualan bisnis Anda",
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ================= SUMMARY =================
            LayoutBuilder(
              builder: (context, constraints) {
                int count = constraints.maxWidth > 900
                    ? 3
                    : (constraints.maxWidth > 500 ? 2 : 1);
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: count,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.2,
                  children: const [
                    _MiniReportCard(
                      title: "Growth",
                      value: "+24.5%",
                      icon: Icons.trending_up_rounded,
                      color: Colors.green,
                    ),
                    _MiniReportCard(
                      title: "Conversion Rate",
                      value: "4.2%",
                      icon: Icons.track_changes_rounded,
                      color: Colors.blue,
                    ),
                    _MiniReportCard(
                      title: "Active Users",
                      value: "892",
                      icon: Icons.people_outline_rounded,
                      color: Colors.orange,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // ================= CHARTS PLACEHOLDER / LIST =================
            const Text(
              "Histori Penjualan Terbaru",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dummyTransactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final t = _dummyTransactions[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.history_edu_rounded,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    title: Text(
                      t['produk']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      t['tanggal']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          t['total']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Qty: ${t['jumlah']}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<Map<String, String>> _dummyTransactions = [
    {
      "tanggal": "21 Jan 2026",
      "produk": "Amanury Floral Mist Special",
      "jumlah": "2",
      "total": "Rp 500.000",
    },
    {
      "tanggal": "20 Jan 2026",
      "produk": "Amanury Oud Series 50ml",
      "jumlah": "1",
      "total": "Rp 350.000",
    },
    {
      "tanggal": "20 Jan 2026",
      "produk": "Amanury Signature Pack",
      "jumlah": "1",
      "total": "Rp 450.000",
    },
  ];
}

class _MiniReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniReportCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
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
