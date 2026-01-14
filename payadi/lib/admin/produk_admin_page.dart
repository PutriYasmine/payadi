import 'package:flutter/material.dart';
import '../models/produk.dart';

class ProdukAdminPage extends StatefulWidget {
  const ProdukAdminPage({super.key});

  @override
  State<ProdukAdminPage> createState() => _ProdukAdminPageState();
}

class _ProdukAdminPageState extends State<ProdukAdminPage> {
  final List<Produk> produkList = [
    Produk(nama: "Amanury Oud", kategori: "Parfum", harga: 350000, stok: 10),
  ];

  void tambahProduk() {
    setState(() {
      produkList.add(
        Produk(
          nama: "Parfum Baru",
          kategori: "Parfum",
          harga: 250000,
          stok: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: tambahProduk,
            child: const Text("Tambah Produk"),
          ),
        ),
        const SizedBox(height: 10),
        DataTable(
          columns: const [
            DataColumn(label: Text("Nama")),
            DataColumn(label: Text("Kategori")),
            DataColumn(label: Text("Harga")),
            DataColumn(label: Text("Stok")),
          ],
          rows: produkList
              .map(
                (p) => DataRow(cells: [
                  DataCell(Text(p.nama)),
                  DataCell(Text(p.kategori)),
                  DataCell(Text("Rp ${p.harga}")),
                  DataCell(Text(p.stok.toString())),
                ]),
              )
              .toList(),
        ),
      ],
    );
  }
}
