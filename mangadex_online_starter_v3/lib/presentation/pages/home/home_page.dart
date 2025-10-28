import 'package:flutter/material.dart';
import '../../widgets/manga_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.04;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text("MangaDex Online"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
            child: const Text("Para ti", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 3/5,
            ),
            itemCount: 12,
            itemBuilder: (_, i) => MangaCard(
              title: "Título #$i",
              imageUrl: "https://picsum.photos/300/400?random=$i",
              badge: i % 4 == 0 ? "Nuevo" : null,
              onTap: () {},
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}