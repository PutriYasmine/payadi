import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori.dart';

class KategoriAdminPage extends StatefulWidget {
  const KategoriAdminPage({super.key});

  @override
  State<KategoriAdminPage> createState() => _KategoriAdminPageState();
}

class _KategoriAdminPageState extends State<KategoriAdminPage> {
  final supabase = Supabase.instance.client;
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('categories')
          .select()
          .order('name', ascending: true);

      if (mounted) {
        setState(() {
          _categories = (response as List)
              .map((e) => Category.fromJson(e))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForm({Category? category}) {
    final nameC = TextEditingController(text: category?.name ?? '');
    final descC = TextEditingController(text: category?.description ?? '');
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(category == null ? "Tambah Kategori" : "Edit Kategori"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Kategori",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                    labelText: "Nama Kategori",
                    hintText: "Misal: Parfum Oud",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descC,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  maxLines: 3,
                ),
                if (isSaving)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(child: LinearProgressIndicator()),
                  ),
              ],
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
                            final data = {
                              'name': nameC.text.trim(),
                              'description': descC.text.trim(),
                            };

                            if (category == null) {
                              await supabase.from('categories').insert(data);
                            } else {
                              await supabase
                                  .from('categories')
                                  .update(data)
                                  .eq('id', category.id!);
                            }

                            if (mounted) Navigator.pop(context);
                            _fetchCategories();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _categories.isEmpty
                  ? _buildEmptyState()
                  : _buildCategoryList(),
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
                "Kategori Produk",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                "Kelola pengelompokan produk Anda",
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showForm(),
          icon: const Icon(Icons.add_rounded),
          label: const Text("Tambah Kategori"),
          style: ElevatedButton.styleFrom(minimumSize: const Size(180, 52)),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Kategori",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Produk Anda butuh rumah. Buat kategori sekarang!",
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.separated(
      itemCount: _categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            title: Text(
              cat.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            subtitle: Text(
              cat.description ?? "Tidak ada deskripsi",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showForm(category: cat),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteCategory(cat.id!),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteCategory(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: const Text(
          "Tindakan ini tidak dapat dibatalkan. Hapus kategori?",
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
        await supabase.from('categories').delete().eq('id', id);
        _fetchCategories();
      } catch (e) {
        debugPrint('Error deleting category: $e');
      }
    }
  }
}
