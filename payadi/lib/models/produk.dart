class Produk {
  String nama;
  String kategori;
  int stok;
  bool aktif;
  String fotoUrl;
  Map<String, int> varianHarga;

  Produk({
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.varianHarga,
    required this.fotoUrl,
    this.aktif = true,
  });
}
