import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/produk.dart';
import '../models/kategori.dart';

class ProdukAdminPage extends StatefulWidget {
  const ProdukAdminPage({super.key});

  @override
  State<ProdukAdminPage> createState() => _ProdukAdminPageState();
}

class _ProdukAdminPageState extends State<ProdukAdminPage> {
  final supabase = Supabase.instance.client;
  List<Produk> produkList = [];
  List<Category> _categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  Future<void> _fetchProduk() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('products')
          .select('*, product_variants(*)')
          .order('created_at', ascending: false);

      final catData = await supabase
          .from('categories')
          .select()
          .order('name', ascending: true);

      setState(() {
        produkList = (data as List).map((e) => Produk.fromJson(e)).toList();
        _categories = (catData as List)
            .map((e) => Category.fromJson(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching produk: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
      }
    }
  }

  Future<List<String>> _uploadImages(List<XFile> images) async {
    List<String> urls = [];
    for (var image in images) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      final path = 'product_photos/$fileName';

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        await supabase.storage
            .from('products')
            .uploadBinary(
              path,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
      } else {
        await supabase.storage
            .from('products')
            .upload(
              path,
              File(image.path),
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
      }

      final url = supabase.storage.from('products').getPublicUrl(path);
      urls.add(url);
    }
    return urls;
  }

  void showForm({Produk? produk}) {
    final nameC = TextEditingController(text: produk?.name ?? '');
    final descC = TextEditingController(text: produk?.description ?? '');
    final priceC = TextEditingController(text: produk?.price.toString() ?? '');
    final stockC = TextEditingController(text: produk?.stock.toString() ?? '');
    String? selectedCategoryId = produk?.categoryId;

    List<XFile> newImages = [];
    List<String> existingUrls = List.from(produk?.imageUrls ?? []);

    final List<Map<String, dynamic>> variants = (produk?.variants ?? []).map((
      v,
    ) {
      return {
        'id': v.id,
        'name': TextEditingController(text: v.name),
        'price': TextEditingController(text: v.price.toString()),
        'stock': TextEditingController(text: v.stock.toString()),
      };
    }).toList();

    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(produk == null ? "Tambah Produk" : "Edit Produk"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Informasi Produk"),
                      TextField(
                        controller: nameC,
                        decoration: const InputDecoration(
                          labelText: "Nama Produk",
                          hintText: "Contoh: Amanury Oud",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descC,
                        decoration: const InputDecoration(
                          labelText: "Deskripsi",
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceC,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Harga Default",
                                prefixText: "Rp ",
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: stockC,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Stok Default",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Tanpa Kategori"),
                          ),
                          ..._categories.map(
                            (cat) => DropdownMenuItem(
                              value: cat.id,
                              child: Text(cat.name),
                            ),
                          ),
                        ],
                        onChanged: (val) => selectedCategoryId = val,
                        decoration: const InputDecoration(
                          labelText: "Kategori",
                        ),
                      ),

                      const Divider(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _buildLabel("Pilihan Varian")),
                          TextButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                variants.add({
                                  'name': TextEditingController(),
                                  'price': TextEditingController(
                                    text: priceC.text,
                                  ),
                                  'stock': TextEditingController(
                                    text: stockC.text,
                                  ),
                                });
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                            label: const Text("Tambah Varian"),
                          ),
                        ],
                      ),
                      if (variants.isEmpty)
                        const Text(
                          "Belum ada varian. Gunakan harga default.",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ...variants.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var v = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: v['name'],
                                  decoration: const InputDecoration(
                                    labelText: "Nama Varian",
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: v['price'],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Harga",
                                    isDense: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => setDialogState(
                                  () => variants.removeAt(idx),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const Divider(height: 48),
                      _buildLabel("Foto Produk (Maks 20)"),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...existingUrls.map(
                            (url) => _buildImagePreview(
                              url,
                              () => setDialogState(
                                () => existingUrls.remove(url),
                              ),
                            ),
                          ),
                          ...newImages.map(
                            (file) => _buildNewImagePreview(
                              file,
                              () =>
                                  setDialogState(() => newImages.remove(file)),
                            ),
                          ),
                          if (existingUrls.length + newImages.length < 20)
                            _buildAddPhotoButton(
                              setDialogState,
                              existingUrls,
                              newImages,
                            ),
                        ],
                      ),
                      if (isSaving)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Menyimpan data...",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 48),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (nameC.text.isEmpty) return;
                          setDialogState(() => isSaving = true);
                          try {
                            final uploadedUrls = await _uploadImages(newImages);
                            final allUrls = [...existingUrls, ...uploadedUrls];
                            final newProd = Produk(
                              id: produk?.id,
                              name: nameC.text,
                              description: descC.text.trim().isEmpty
                                  ? null
                                  : descC.text.trim(),
                              price: double.tryParse(priceC.text) ?? 0,
                              stock: int.tryParse(stockC.text) ?? 0,
                              imageUrls: allUrls,
                              categoryId: selectedCategoryId,
                            );

                            Map<String, dynamic> data = newProd.toJson();
                            String? prodId;
                            if (produk == null) {
                              data.remove('id');
                              final res = await supabase
                                  .from('products')
                                  .insert(data)
                                  .select()
                                  .single();
                              prodId = res['id'];
                            } else {
                              prodId = produk.id;
                              await supabase
                                  .from('products')
                                  .update(data)
                                  .eq('id', prodId!);
                            }

                            await supabase
                                .from('product_variants')
                                .delete()
                                .eq('product_id', prodId!);
                            if (variants.isNotEmpty) {
                              await supabase
                                  .from('product_variants')
                                  .insert(
                                    variants
                                        .map(
                                          (v) => {
                                            'product_id': prodId,
                                            'name': v['name'].text,
                                            'price':
                                                double.tryParse(
                                                  v['price'].text,
                                                ) ??
                                                0,
                                            'stock':
                                                int.tryParse(v['stock'].text) ??
                                                0,
                                          },
                                        )
                                        .toList(),
                                  );
                            }

                            if (mounted) Navigator.pop(context);
                            _fetchProduk();
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                          }
                        },
                  child: const Text("Simpan"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildImagePreview(String url, VoidCallback onDelete) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
        ),
        Positioned(right: 4, top: 4, child: _deleteCircle(onDelete)),
      ],
    );
  }

  Widget _buildNewImagePreview(XFile file, VoidCallback onDelete) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: kIsWeb
              ? Image.network(
                  file.path,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(file.path),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(right: 4, top: 4, child: _deleteCircle(onDelete)),
      ],
    );
  }

  Widget _deleteCircle(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.cancel, color: Colors.red, size: 20),
      ),
    );
  }

  Widget _buildAddPhotoButton(
    Function setDialogState,
    List<String> existingUrls,
    List<XFile> newImages,
  ) {
    return InkWell(
      onTap: () async {
        final picker = ImagePicker();
        final picked = await picker.pickMultiImage(
          imageQuality: 70,
          maxWidth: 1000,
        );
        if (picked.isNotEmpty) {
          setDialogState(() {
            int left = 20 - (existingUrls.length + newImages.length);
            newImages.addAll(picked.take(left));
          });
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF64748B)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : produkList.isEmpty
                  ? _buildEmptyState()
                  : _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Manajemen Produk",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                "Kelola stok dan harga produk Anda",
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => showForm(),
          icon: const Icon(Icons.add_rounded),
          label: const Text("Tambah Baru"),
          style: ElevatedButton.styleFrom(minimumSize: const Size(160, 52)),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Produk",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Mulai tambahkan produk pertama Anda",
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800
                  ? 3
                  : (constraints.maxWidth > 500 ? 2 : 1));
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.78,
          ),
          itemCount: produkList.length,
          itemBuilder: (context, index) => _buildProductCard(produkList[index]),
        );
      },
    );
  }

  Widget _buildProductCard(Produk p) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                p.imageUrls.isNotEmpty
                    ? Image.network(
                        p.imageUrls.first,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Stok: ${p.stock}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${p.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => showForm(produk: p),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _deleteProduk(p.id!),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFEF4444),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduk(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text(
          "Tindakan ini tidak dapat dibatalkan. Hapus produk?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await supabase.from('products').delete().eq('id', id);
        _fetchProduk();
      } catch (e) {
        debugPrint('Error deleting produk: $e');
      }
    }
  }
}
