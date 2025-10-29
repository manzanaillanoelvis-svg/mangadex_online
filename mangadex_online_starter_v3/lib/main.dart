import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/api/search_api.dart';
const String kApiBaseUrl = 'https://mangadex-scraper-api.onrender.com';


void main() => runApp(const AppRoot());

/* ---------------- App Root ---------------- */

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool neon = false;
  final Library store = Library();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MangaDex Online',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(neon: neon),
      home: HomeShell(
        neon: neon,
        onToggleNeon: (v) => setState(() => neon = v),
        store: store,
      ),
    );
  }
}

/* ---------------- Theme ---------------- */

ThemeData buildTheme({required bool neon}) {
  final seed = neon ? const Color(0xFF00FFFF) : const Color(0xFFFFC107);
  final scheme =
      ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: seed);
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    chipTheme: ChipThemeData(
      labelStyle: const TextStyle(color: Colors.white),
      backgroundColor: scheme.primary.withValues(alpha: 0.15),
      side: BorderSide(color: scheme.primary.withValues(alpha: 0.4)),
    ),
  );
}

/* ---------------- Mock catálogo de inicio ---------------- */

class Manga {
  final String title;
  final String url;
  final List<String> tags;
  final List<Chapter> chapters;
  Manga(this.title, this.url, this.tags, this.chapters);
}

class Chapter {
  final String name;
  final String id;
  Chapter(this.name, this.id);
}

final mockCatalog = <Manga>[
  Manga(
    'Boruto: Two Blue Vortex',
    'https://tmo-lector.com/manga/boruto-naruto-next-generations/',
    ['Acción', 'Shonen', 'Ninja'],
    List.generate(8, (i) => Chapter('Capítulo ${i + 1}', 'boruto-${i + 1}')),
  ),
  Manga(
    'Dr. STONE',
    'https://tmo-lector.com/manga/dr-stone/',
    ['Aventura', 'Ciencia', 'Comedia'],
    List.generate(10, (i) => Chapter('Capítulo ${i + 1}', 'drs-${i + 1}')),
  ),
  Manga(
    'Hombre de un apuro',
    'https://tmo-lector.com/manga/hombre-de-un-apuro/',
    ['Drama', 'Seinen'],
    List.generate(6, (i) => Chapter('Capítulo ${i + 1}', 'hdua-${i + 1}')),
  ),
];

/* ---------------- Biblioteca (descargas mock + fichas) ---------------- */

class Library {
  final Map<String, List<String>> _downloadedByManga = {};
  final Map<String, MangaMeta> _savedMetas = {}; // clave: url

  void save(String chapterId, {required String manga}) {
    _downloadedByManga.putIfAbsent(manga, () => <String>[]);
    if (!_downloadedByManga[manga]!.contains(chapterId)) {
      _downloadedByManga[manga]!.add(chapterId);
    }
  }

  bool has(String chapterId) =>
      _downloadedByManga.values.any((list) => list.contains(chapterId));

  List<(String manga, String chapterId)> all() {
    final list = <(String, String)>[];
    _downloadedByManga.forEach((m, chaps) {
      for (final c in chaps) list.add((m, c));
    });
    return list;
  }

  void saveMeta(MangaMeta meta) {
    _savedMetas[meta.url] = meta;
  }

  List<MangaMeta> get savedMetas => _savedMetas.values.toList();
}

/* ---------------- Modelos del scraper / API ---------------- */

class SearchHit {
  final String sourceId;
  final String sourceName;
  final String title;
  final String url;
  final String? cover;
  final String? lang;
  SearchHit({
    required this.sourceId,
    required this.sourceName,
    required this.title,
    required this.url,
    this.cover,
    this.lang,
  });
}

class ChapterMeta {
  final String id;
  final String name;
  final num? number;
  final String url;
  ChapterMeta({required this.id, required this.name, this.number, required this.url});
}

class MangaMeta {
  final String sourceId;
  final String url;
  final String title;
  final List<String> altTitles;
  final String description;
  final List<String> authors;
  final List<String> artists;
  final String status;
  final int? year;
  final List<String> genres;
  final String? cover;
  final List<ChapterMeta> chapters;

  MangaMeta({
    required this.sourceId,
    required this.url,
    required this.title,
    required this.altTitles,
    required this.description,
    required this.authors,
    required this.artists,
    required this.status,
    required this.year,
    required this.genres,
    required this.cover,
    required this.chapters,
  });
}

/* ---------------- API Scraper (interfaz + mock) ---------------- */

abstract class ScraperApi {
  Future<List<SearchHit>> search(String q);
  Future<MangaMeta> fetchMetadata(String url);
}

/// MOCK – sin HTTP
class MockScraperApi implements ScraperApi {
  @override
  Future<List<SearchHit>> search(String q) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lower = q.toLowerCase();
    final demo = [
      SearchHit(
        sourceId: 'tmo',
        sourceName: 'TMO Lector',
        title: 'Dr. STONE',
        url: 'https://tmo-lector.com/manga/dr-stone/',
      ),
      SearchHit(
        sourceId: 'mangadex',
        sourceName: 'MangaDex',
        title: 'Dr. STONE',
        url: 'https://mangadex.org/title/...',
      ),
      SearchHit(
        sourceId: 'tmo',
        sourceName: 'TMO Lector',
        title: 'Boruto: Two Blue Vortex',
        url: 'https://tmo-lector.com/manga/boruto-naruto-next-generations/',
      ),
    ];
    return demo.where((h) => h.title.toLowerCase().contains(lower)).toList();
  }

  @override
  Future<MangaMeta> fetchMetadata(String url) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final isDrStone = url.contains('dr-stone');
    return MangaMeta(
      sourceId: url.contains('tmo') ? 'tmo' : 'mangadex',
      url: url,
      title: isDrStone ? 'Dr. STONE' : 'Boruto: Two Blue Vortex',
      altTitles: const ['ドクターストーン'],
      description: isDrStone
          ? 'Tras un misterioso fenómeno, la humanidad queda petrificada…'
          : 'Secuela con un nuevo arco en la historia de Boruto.',
      authors: const ['Autor Demo'],
      artists: const ['Artista Demo'],
      status: 'ongoing',
      year: 2017,
      genres: isDrStone ? const ['Aventura', 'Ciencia'] : const ['Acción', 'Shonen'],
      cover: null,
      chapters: List.generate(
        5,
        (i) => ChapterMeta(
          id: 'demo-${i + 1}',
          name: 'Capítulo ${i + 1}',
          number: i + 1,
          url: 'https://example.com/cap-${i + 1}',
        ),
      ),
    );
  }
}

/* ---------------- Onboarding simple (omitido en demo) ---------------- */

/* ---------------- HomeShell + Tabs ---------------- */

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.neon,
    required this.onToggleNeon,
    required this.store,
  });
  final bool neon;
  final ValueChanged<bool> onToggleNeon;
  final Library store;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(store: widget.store),
      ExploreTab(store: widget.store),
      LibraryTab(store: widget.store),
      ProfileTab(neon: widget.neon, onToggleNeon: widget.onToggleNeon),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('MangaDex Online')),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Biblioteca'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

/* ---------- HomeTab (catálogo mock) ---------- */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.store});
  final Library store;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: mockCatalog.length,
      itemBuilder: (c, i) {
        final m = mockCatalog[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: cs.primary.withValues(alpha: 0.25),
                      child: const Icon(Icons.menu_book, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MangaDetail(manga: m, store: store),
                        ),
                      ),
                      child: const Text('Ver'),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: -8,
                  children: m.tags.map((t) => Chip(label: Text(t))).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ---------- ExploreTab (buscador con mock scraper) ---------- */

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key, required this.store});
  final Library store;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final ScraperApi api = MockScraperApi();
  Future<List<SearchHit>>? _future;

  void _doSearch(String query) {
    setState(() => _future = api.search(query));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Busca un manga (p. ej. “dr stone”) y presiona Enter…',
            ),
            onSubmitted: _doSearch,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _future == null
                ? const Center(child: Text('Escribe y presiona Enter para buscar'))
                : FutureBuilder<List<SearchHit>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('Error: ${snap.error}'));
                      }
                      final hits = snap.data ?? const [];
                      if (hits.isEmpty) return const Center(child: Text('Sin resultados'));

                      final bySource = <String, List<SearchHit>>{};
                      for (final h in hits) {
                        bySource.putIfAbsent(h.sourceName, () => []).add(h);
                      }

                      return ListView(
                        children: bySource.entries.map((entry) {
                          final sourceName = entry.key;
                          final items = entry.value;
                          return Card(
                            child: ExpansionTile(
                              title: Text(sourceName),
                              subtitle: Text('${items.length} resultado(s)'),
                              children: items.map((h) {
                                return ListTile(
                                  leading: const Icon(Icons.link),
                                  title: Text(h.title),
                                  subtitle: Text(h.url),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () async {
                                    final meta = await api.fetchMetadata(h.url);
                                    if (!context.mounted) return;
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) => _MetaPreviewSheet(
                                        meta: meta,
                                        onSave: () {
                                          widget.store.saveMeta(meta);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Ficha guardada en Biblioteca'),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MetaPreviewSheet extends StatelessWidget {
  const _MetaPreviewSheet({required this.meta, required this.onSave});
  final MangaMeta meta;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meta.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(meta.description.isEmpty ? 'Sin descripción' : meta.description),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: meta.genres.map((g) => Chip(label: Text(g))).toList()),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar ficha'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/* ---------- LibraryTab (fichas + descargas demo) ---------- */

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key, required this.store});
  final Library store;

  @override
  Widget build(BuildContext context) {
    final metas = store.savedMetas;
    final downloads = store.all();

    if (metas.isEmpty && downloads.isEmpty) {
      return const Center(child: Text('Aún no hay contenido en tu biblioteca'));
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (metas.isNotEmpty) ...[
          const Text('Fichas guardadas', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...metas.map((m) => Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(m.title),
                  subtitle: Text('${m.sourceId} • ${m.genres.join(" · ")}'),
                ),
              )),
          const SizedBox(height: 16),
        ],
        if (downloads.isNotEmpty) ...[
          const Text('Capítulos descargados (demo)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...downloads.map((e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.download_done),
                  title: Text(e.$2),
                  subtitle: Text(e.$1),
                ),
              )),
        ],
      ],
    );
  }
}

/* ---------- ProfileTab (modo neón) ---------- */

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.neon, required this.onToggleNeon});
  final bool neon;
  final ValueChanged<bool> onToggleNeon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Tu perfil'),
          subtitle: Text('MangaDex Online'),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Modo neón (alternar)'),
          subtitle: const Text('Por defecto: negro con dorado'),
          value: neon,
          onChanged: onToggleNeon,
        ),
        const SizedBox(height: 12),
        const ListTile(
          title: Text('Acerca de'),
          subtitle: Text(
            'Demo con buscador multi-fuente (mock), selector de fuente y guardado de metadata.',
          ),
        ),
      ],
    );
  }
}

/* ---------- Detalle de catálogo mock (descargas demo) ---------- */

class MangaDetail extends StatelessWidget {
  const MangaDetail({super.key, required this.manga, required this.store});
  final Manga manga;
  final Library store;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(manga.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: cs.primary.withValues(alpha: 0.25),
                    child: const Icon(Icons.menu_book, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      manga.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Capítulos', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...manga.chapters.map((c) {
            final downloaded = store.has(c.id);
            return Card(
              child: ListTile(
                title: Text(c.name),
                subtitle: Text(manga.title),
                trailing: downloaded
                    ? const Icon(Icons.check_circle, color: Colors.lightGreen)
                    : FilledButton.icon(
                        onPressed: () {
                          store.save(c.id, manga: manga.title);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${c.name} descargado')),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Descargar'),
                      ),
              ),
            );
          }),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.public),
            label: const Text('Abrir fuente (demo)'),
          )
        ],
      ),
    );
  }
}
