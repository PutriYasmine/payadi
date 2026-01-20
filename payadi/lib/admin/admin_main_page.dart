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
  int selectedIndex = 0;
  bool isSidebarOpen = false;

  final pages = [
    const AdminDashboard(),
    ProdukAdminPage(),
    const PesananAdminPage(),
    const LaporanAdminPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Amanury"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() => isSidebarOpen = true);
          },
        ),
      ),
      body: Stack(
        children: [
          // ================= CONTENT (FULL WIDTH) =================
          pages[selectedIndex],

          // ================= SIDEBAR OVERLAY =================
          if (isSidebarOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => isSidebarOpen = false),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),

          if (isSidebarOpen)
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              child: AdminSidebar(
                selectedIndex: selectedIndex,
                isExpanded: true,
                onToggle: () => setState(() => isSidebarOpen = false),
                onTap: (i) {
                  setState(() {
                    selectedIndex = i;
                    isSidebarOpen = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
