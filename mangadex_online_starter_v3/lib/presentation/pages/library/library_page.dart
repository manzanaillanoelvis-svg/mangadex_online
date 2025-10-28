import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.playlist_play), title: Text('Continuar leyendo'), subtitle: Text('Tu progreso reciente')),
          ListTile(leading: Icon(Icons.favorite_outline), title: Text('Favoritos')),
          ListTile(leading: Icon(Icons.file_download_outlined), title: Text('Descargados')),
        ],
      ),
    );
  }
}