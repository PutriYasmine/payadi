import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'produk_admin_page.dart';
import 'pesanan_admin_page.dart';
import 'laporan_admin_page.dart';
import 'kategori_admin_page.dart';
import '../widget/admin_sidebar.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int selectedIndex = 0;
  bool isSidebarExpanded = true;
  bool isMobileMenuOpen = false;

  final pages = [
    const AdminDashboard(),
    const ProdukAdminPage(),
    const KategoriAdminPage(),
    const PesananAdminPage(),
    const LaporanAdminPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1024;
        final bool isTablet =
            constraints.maxWidth >= 640 && constraints.maxWidth < 1024;

        // Auto-collapse sidebar on smaller screens if it was expanded
        if (!isDesktop && isSidebarExpanded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => isSidebarExpanded = false);
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: !isDesktop
              ? AppBar(
                  title: const Text("Payadi Admin"),
                  leading: IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => setState(() => isMobileMenuOpen = true),
                  ),
                )
              : null,
          body: Stack(
            children: [
              Row(
                children: [
                  // ================= SIDEBAR (DESKTOP/TABLET) =================
                  if (isDesktop || isTablet)
                    AdminSidebar(
                      selectedIndex: selectedIndex,
                      isExpanded: isSidebarExpanded,
                      onToggle: () => setState(
                        () => isSidebarExpanded = !isSidebarExpanded,
                      ),
                      onTap: (i) => setState(() => selectedIndex = i),
                    ),

                  // ================= MAIN CONTENT =================
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: isDesktop ? 0 : 0),
                      child: pages[selectedIndex],
                    ),
                  ),
                ],
              ),

              // ================= MOBILE SIDEBAR OVERLAY =================
              if (!isDesktop && !isTablet && isMobileMenuOpen) ...[
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() => isMobileMenuOpen = false),
                    child: Container(color: Colors.black54),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: AdminSidebar(
                    selectedIndex: selectedIndex,
                    isExpanded: true,
                    onToggle: () => setState(() => isMobileMenuOpen = false),
                    onTap: (i) {
                      setState(() {
                        selectedIndex = i;
                        isMobileMenuOpen = false;
                      });
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
