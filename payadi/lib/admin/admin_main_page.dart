import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'produk_admin_page.dart';
import 'pesanan_admin_page.dart';
import 'laporan_admin_page.dart';
import '../../widget/admin_sidebar.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int index = 0;

  final pages = [
    const AdminDashboard(),
    ProdukAdminPage(),
    const PesananAdminPage(),
    const LaporanAdminPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: index,
            onTap: (i) => setState(() => index = i),
          ),
          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}
