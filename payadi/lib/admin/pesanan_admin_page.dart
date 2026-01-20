import 'package:flutter/material.dart';

class PesananAdminPage extends StatefulWidget {
  const PesananAdminPage({super.key});

  @override
  State<PesananAdminPage> createState() => _PesananAdminPageState();
}

class _PesananAdminPageState extends State<PesananAdminPage> {
  final List<Map<String, String>> pesananList = [
    {
      "id": "Order #001",
      "produk": "Amanury Oud - 2 pcs",
      "status": "Dikirim",
    },
    {
      "id": "Order #002",
      "produk": "Amanury Floral - 1 pcs",
      "status": "Diproses",
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
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        final pesanan = pesananList[index];

        return Card(
          child: ListTile(
            title: Text(pesanan["id"]!),
            subtitle: Text(pesanan["produk"]!),
            trailing: DropdownButton<String>(
              value: pesanan["status"],
              items: statusList
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  pesananList[index]["status"] = value!;
                });
              },
            ),
          ),
        );
      },
    );
  }
}