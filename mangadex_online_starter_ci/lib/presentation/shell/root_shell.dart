import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/explore/explore_page.dart';
import '../pages/library/library_page.dart';
import '../pages/profile/profile_page.dart';
class RootShell extends StatefulWidget { const RootShell({super.key}); @override State<RootShell> createState()=>_RootShellState(); }
class _RootShellState extends State<RootShell> {
  int _index = 0;
  final _pages = const [HomePage(), ExplorePage(), LibraryPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index, onDestinationSelected: (i)=>setState(()=>_index=i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.bookmarks_outlined), label: 'Biblioteca'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}