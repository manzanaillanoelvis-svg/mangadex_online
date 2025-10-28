import 'package:flutter/material.dart';

class MangaItem {
  final String id;
  final String title;
  final String coverUrl;
  final String? author;
  final String? status;
  MangaItem(this.id, this.title, this.coverUrl, {this.author, this.status});
}

class MangaStore extends ChangeNotifier {
  List<MangaItem> _items = List.generate(
    12,
    (i) => MangaItem("id$i", "Manga #$i", "https://picsum.photos/300/400?random=$i",
        author: "Autor #$i", status: i % 2 == 0 ? "ongoing" : "completed"),
  );
  bool _loading = false;
  String _error = '';

  List<MangaItem> get items => _items;
  bool get loading => _loading;
  String get error => _error;

  Future<void> fetchHome() async {
    notifyListeners();
  }

  Future<void> search(String text) async {
    _loading = true; _error = '';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _items = List.generate(
      9,
      (i) => MangaItem("s$i", "$text #$i", "https://picsum.photos/300/400?random=${i+50}",
          author: "Autor X", status: i % 2 == 0 ? "ongoing" : "completed"),
    );
    _loading = false;
    notifyListeners();
  }
}