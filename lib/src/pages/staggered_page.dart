import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/image_tile.dart'; // This now creates a text tile.
import '../widgets/staggered_grid.dart';

class StaggeredPage extends StatelessWidget {
  const StaggeredPage({Key? key}) : super(key: key);

  // Configuration for grid tiles.
  static const tiles = [
    _TileConfig(2, 2),
    _TileConfig(2, 1),
    _TileConfig(1, 2),
    _TileConfig(1, 1),
    _TileConfig(2, 2),
    _TileConfig(1, 2),
    _TileConfig(1, 1),
    _TileConfig(3, 1),
    _TileConfig(1, 1),
    _TileConfig(4, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Staggered',
      child: SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: tiles.mapIndexed((index, tile) {
            return StaggeredGridTile.count(
              crossAxisCellCount: tile.crossAxisCount,
              mainAxisCellCount: tile.mainAxisCount,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ImageTile( // Now shows text in a colored container.
                    index: index,
                    width: tile.crossAxisCount * 100,
                    height: tile.mainAxisCount * 100,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Simple tile configuration class.
class _TileConfig {
  final int crossAxisCount;
  final int mainAxisCount;
  const _TileConfig(this.crossAxisCount, this.mainAxisCount);
}
