import 'package:flutter/material.dart';

class LaporanAdminPage extends StatelessWidget {
  const LaporanAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= JUDUL =================
            const Text(
              "Laporan Penjualan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // ================= RINGKASAN =================
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _SummaryCard(
                  title: "Total Penjualan",
                  value: "Rp 12.500.000",
                  icon: Icons.payments,
                  color: Colors.green,
                ),
                _SummaryCard(
                  title: "Total Pesanan",
                  value: "124",
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                ),
                _SummaryCard(
                  title: "Produk Terjual",
                  value: "356",
                  icon: Icons.inventory,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ================= STATUS PESANAN =================
            const Text(
              "Status Pesanan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                _StatusChip(label: "Diproses", jumlah: 18, color: Colors.orange),
                SizedBox(width: 10),
                _StatusChip(label: "Dikirim", jumlah: 72, color: Colors.blue),
                SizedBox(width: 10),
                _StatusChip(label: "Selesai", jumlah: 34, color: Colors.green),
              ],
            ),

            const SizedBox(height: 30),

            // ================= TRANSAKSI TERBARU =================
            const Text(
              "Transaksi Terbaru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade100),
                columns: const [
                  DataColumn(label: Text("Tanggal")),
                  DataColumn(label: Text("Produk")),
                  DataColumn(label: Text("Jumlah")),
                  DataColumn(label: Text("Total")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("20 Jan 2026")),
                    DataCell(Text("Amanury Oud 50ml")),
                    DataCell(Text("2")),
                    DataCell(Text("Rp 500.000")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("19 Jan 2026")),
                    DataCell(Text("Amanury Floral 30ml")),
                    DataCell(Text("1")),
                    DataCell(Text("Rp 150.000")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("18 Jan 2026")),
                    DataCell(Text("Amanury Oud 100ml")),
                    DataCell(Text("1")),
                    DataCell(Text("Rp 350.000")),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SUMMARY CARD =================
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

// ================= STATUS CHIP =================
class _StatusChip extends StatelessWidget {
  final String label;
  final int jumlah;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.jumlah,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      label: Text(
        "$label ($jumlah)",
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
