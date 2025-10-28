import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/manga_store.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Buscar mangas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onSubmitted: (q) => context.read<MangaStore>().search(q),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: ['Acción', 'Aventura', 'Comedia', 'Drama', 'Romance', 'Seinen', 'Shounen']
                  .map((g) => FilterChip(label: Text(g), selected: false, onSelected: (_) => context.read<MangaStore>().search(g))).toList(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<MangaStore>(builder: (_, s, __) {
                if (s.loading) return const Center(child: CircularProgressIndicator());
                if (s.error.isNotEmpty) return Center(child: Text("Error: ${s.error}"));
                if (s.items.isEmpty) return const Center(child: Text("Sin resultados"));
                return ListView.separated(
                  itemBuilder: (_, i) => ListTile(
                    leading: const Icon(Icons.book_outlined),
                    title: Text(s.items[i].title),
                    subtitle: Text((s.items[i].author ?? '').isEmpty ? 'Autor desconocido' : s.items[i].author!),
                    onTap: () {},
                  ),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: s.items.length,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}