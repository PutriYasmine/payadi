import 'produk.dart';

enum StatusPesanan {
  menunggu,
  diproses,
  dikirim,
  selesai,
  dibatalkan,
}

class Pesanan {
  final String id;
  final String namaPembeli;
  final List<Produk> items;
  final int totalHarga;
  final DateTime tanggal;
  StatusPesanan status;

  Pesanan({
    required this.id,
    required this.namaPembeli,
    required this.items,
    required this.totalHarga,
    required this.tanggal,
    this.status = StatusPesanan.menunggu,
  });
}
