import 'package:flutter/material.dart';

class ReaderPage extends StatefulWidget {
  final List<String> imageUrls;
  final String chapterTitle;
  const ReaderPage({super.key, required this.imageUrls, required this.chapterTitle});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  bool _uiVisible = true;

  void _toggleUI() => setState(() => _uiVisible = !_uiVisible);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleUI,
            child: ListView.builder(
              itemCount: widget.imageUrls.length,
              itemBuilder: (_, i) => Image.network(
                widget.imageUrls[i],
                fit: BoxFit.contain,
                loadingBuilder: (c, w, p) {
                  if (p == null) return w;
                  return AspectRatio(
                    aspectRatio: 3/4,
                    child: Container(
                      color: const Color(0xFF0B0B0F),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_uiVisible)
            SafeArea(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                    Expanded(child: Text(widget.chapterTitle, overflow: TextOverflow.ellipsis)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
                  ],
                ),
              ),
            ),
          if (_uiVisible)
            Positioned(
              left: 12, right: 12, bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.brightness_6_outlined)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.file_download_outlined)),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}