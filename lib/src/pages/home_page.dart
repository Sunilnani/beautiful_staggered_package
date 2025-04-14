import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/menu_entry.dart';
import 'staggered_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Beautiful Staggered Grid View',
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          MenuEntry(
            title: 'Staggered',
            imageName: 'staggered',
            destination: StaggeredPage(),
          ),
          // Additional menu entries can be added here.
          // For instance: Masonry, Quilted, etc.
        ],
      ),
    );
  }
}
