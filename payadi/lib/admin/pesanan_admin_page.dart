import 'package:flutter/material.dart';

class PesananAdminPage extends StatelessWidget {
  const PesananAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        ListTile(
          title: Text("Order #001"),
          subtitle: Text("Amanury Oud - 2 pcs"),
          trailing: Text("Dikirim"),
        ),
        ListTile(
          title: Text("Order #002"),
          subtitle: Text("Amanury Floral - 1 pcs"),
          trailing: Text("Diproses"),
        ),
      ],
    );
  }
}
