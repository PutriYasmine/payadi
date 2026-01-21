import 'package:flutter/material.dart';

class PesananAdminPage extends StatefulWidget {
  const PesananAdminPage({super.key});

  @override
  State<PesananAdminPage> createState() => _PesananAdminPageState();
}

class _PesananAdminPageState extends State<PesananAdminPage> {
  final List<Map<String, String>> pesananList = [
    {
      "id": "ORD-2026-001",
      "produk": "Amanury Oud Special Edition - 2 pcs",
      "status": "Dikirim",
      "customer": "Budi Santoso",
      "total": "Rp 750.000",
    },
    {
      "id": "ORD-2026-002",
      "produk": "Amanury Floral Mist - 1 pcs",
      "status": "Diproses",
      "customer": "Siti Aminah",
      "total": "Rp 150.000",
    },
    {
      "id": "ORD-2026-003",
      "produk": "Amanury Signature Pack - 3 pcs",
      "status": "Selesai",
      "customer": "Ariel Noah",
      "total": "Rp 1.200.000",
    },
  ];

  final List<String> statusList = [
    "Diproses",
    "Dikirim",
    "Selesai",
    "Dibatalkan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manajemen Pesanan",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  "Pantau dan kelola pesanan masuk pelanggan",
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: pesananList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = pesananList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p["id"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${p["customer"]} • ${p["produk"]}",
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                p["total"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildStatusBadge(p["status"]!, index),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildStatusBadge(String status, int index) {
    Color color = Colors.blue;
    if (status == "Selesai") color = Colors.green;
    if (status == "Dibatalkan") color = Colors.red;
    if (status == "Diproses") color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          setState(() {
            pesananList[index]["status"] = value;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: color),
          ],
        ),
        itemBuilder: (context) => statusList
            .map(
              (s) => PopupMenuItem(
                value: s,
                child: Text(s, style: const TextStyle(fontSize: 13)),
              ),
            )
            .toList(),
      ),
    );
  }
}
