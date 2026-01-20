import 'package:flutter/material.dart';
import '../models/produk.dart';

class ProdukAdminPage extends StatefulWidget {
  const ProdukAdminPage({super.key});

  @override
  State<ProdukAdminPage> createState() => _ProdukAdminPageState();
}

class _ProdukAdminPageState extends State<ProdukAdminPage> {
  final List<Produk> produkList = [
    Produk(
      nama: "Amanury Oud",
      kategori: "Parfum",
      stok: 10,
      aktif: true,
      fotoUrl: "https://via.placeholder.com/80",
      varianHarga: {
        "30ml": 150000,
        "50ml": 250000,
        "100ml": 350000,
      },
    ),
  ];

  // ================= FORM TAMBAH / EDIT =================
  void showForm({Produk? produk, int? index}) {
    final namaC = TextEditingController(text: produk?.nama ?? '');
    final kategoriC = TextEditingController(text: produk?.kategori ?? '');
    final stokC =
        TextEditingController(text: produk != null ? produk.stok.toString() : '');
    final fotoC = TextEditingController(text: produk?.fotoUrl ?? '');

    bool aktif = produk?.aktif ?? true;

    final harga30 = TextEditingController(
        text: produk?.varianHarga["30ml"]?.toString() ?? '');
    final harga50 = TextEditingController(
        text: produk?.varianHarga["50ml"]?.toString() ?? '');
    final harga100 = TextEditingController(
        text: produk?.varianHarga["100ml"]?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(produk == null ? "Tambah Produk" : "Edit Produk"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: namaC,
                      decoration:
                          const InputDecoration(labelText: "Nama Produk")),
                  TextField(
                      controller: kategoriC,
                      decoration:
                          const InputDecoration(labelText: "Kategori")),
                  TextField(
                      controller: fotoC,
                      decoration:
                          const InputDecoration(labelText: "URL Foto")),

                  SwitchListTile(
                    title: const Text("Status Aktif"),
                    value: aktif,
                    onChanged: (v) => setDialogState(() => aktif = v),
                  ),

                  const Divider(),
                  const Text("Varian & Harga",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  TextField(
                      controller: harga30,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "30ml")),
                  TextField(
                      controller: harga50,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "50ml")),
                  TextField(
                      controller: harga100,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "100ml")),

                  TextField(
                      controller: stokC,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Stok")),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal")),
              ElevatedButton(
                onPressed: () {
                  final newProduk = Produk(
                    nama: namaC.text,
                    kategori: kategoriC.text,
                    stok: int.parse(stokC.text),
                    aktif: aktif,
                    fotoUrl: fotoC.text,
                    varianHarga: {
                      "30ml": int.tryParse(harga30.text) ?? 0,
                      "50ml": int.tryParse(harga50.text) ?? 0,
                      "100ml": int.tryParse(harga100.text) ?? 0,
                    },
                  );

                  setState(() {
                    produk == null
                        ? produkList.add(newProduk)
                        : produkList[index!] = newProduk;
                  });

                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= DELETE =================
  void hapusProduk(int index) {
    setState(() => produkList.removeAt(index));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Manajemen Produk",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ElevatedButton.icon(
                onPressed: () => showForm(),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Produk"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // TABLE
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 28,
              columns: const [
                DataColumn(label: Text("Foto")),
                DataColumn(label: Text("Nama")),
                DataColumn(label: Text("Varian")),
                DataColumn(label: Text("Stok")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: produkList.asMap().entries.map((e) {
                final i = e.key;
                final p = e.value;

                return DataRow(cells: [
                  // FOTO
                  DataCell(
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        p.fotoUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // NAMA
                  DataCell(Text(p.nama)),

                  // VARIAN (FIX OVERFLOW 🔥)
                  DataCell(
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: p.varianHarga.entries.map((v) {
                        return Chip(
                          label: Text("${v.key}: Rp ${v.value}"),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: const TextStyle(fontSize: 12),
                        );
                      }).toList(),
                    ),
                  ),

                  // STOK + NOTIFIKASI
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(p.stok.toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        if (p.stok <= 5)
                          const Text(
                            "Stok Menipis",
                            style: TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                      ],
                    ),
                  ),

                  // STATUS
                  DataCell(
                    Chip(
                      label: Text(p.aktif ? "Aktif" : "Nonaktif"),
                      backgroundColor: p.aktif
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
                    ),
                  ),

                  // AKSI
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showForm(produk: p, index: i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => hapusProduk(i),
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
