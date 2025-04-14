import 'package:flutter/material.dart';

/// Custom staggered grid implementation.
class StaggeredGrid extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<StaggeredGridTile> children;

  const StaggeredGrid.count({
    Key? key,
    required this.crossAxisCount,
    this.mainAxisSpacing = 4.0,
    this.crossAxisSpacing = 4.0,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to know available width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final cellWidth = (totalWidth - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;
        final cellHeight = cellWidth; // assume square cells

        // Occupancy grid: each row is a list of booleans representing occupied cells.
        List<List<bool>> occupancy = [];
        List<_TilePosition> positions = [];

        // For each tile, find its placement.
        for (var tile in children) {
          _TilePosition pos = _findPositionForTile(tile, occupancy, crossAxisCount);
          positions.add(pos);
          _markOccupancy(occupancy, pos, tile.crossAxisCellCount, tile.mainAxisCellCount);
        }

        // Total number of rows used.
        int totalRows = occupancy.length;
        double gridHeight = totalRows * cellHeight + (totalRows - 1) * mainAxisSpacing;

        // Create Positioned widgets for every child.
        List<Widget> positionedChildren = [];
        for (int i = 0; i < children.length; i++) {
          final tile = children[i];
          final pos = positions[i];
          double left = pos.col * (cellWidth + crossAxisSpacing);
          double top = pos.row * (cellHeight + mainAxisSpacing);
          double tileWidth = tile.crossAxisCellCount * cellWidth +
              (tile.crossAxisCellCount - 1) * crossAxisSpacing;
          double tileHeight = tile.mainAxisCellCount * cellHeight +
              (tile.mainAxisCellCount - 1) * mainAxisSpacing;
          positionedChildren.add(Positioned(
            left: left,
            top: top,
            width: tileWidth,
            height: tileHeight,
            child: tile.child,
          ));
        }

        return SizedBox(
          width: totalWidth,
          height: gridHeight,
          child: Stack(children: positionedChildren),
        );
      },
    );
  }
}

/// Wraps a child widget with layout parameters for the staggered grid.
class StaggeredGridTile extends StatelessWidget {
  final int crossAxisCellCount;
  final int mainAxisCellCount;
  final Widget child;

  const StaggeredGridTile.count({
    Key? key,
    required this.crossAxisCellCount,
    required this.mainAxisCellCount,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simply return the child widget. The grid uses the [crossAxisCellCount]
    // and [mainAxisCellCount] for layout purposes.
    return child;
  }
}

/// Helper class to hold the grid cell position for a tile.
class _TilePosition {
  int row;
  int col;
  _TilePosition({required this.row, required this.col});
}

/// Finds the first available grid cell position where the tile fits.
_TilePosition _findPositionForTile(StaggeredGridTile tile, List<List<bool>> occupancy, int crossAxisCount) {
  int requiredRows = tile.mainAxisCellCount;
  int requiredCols = tile.crossAxisCellCount;

  int row = 0;
  while (true) {
    // Ensure the grid has enough rows.
    while (occupancy.length < row + requiredRows) {
      occupancy.add(List.filled(crossAxisCount, false));
    }
    for (int col = 0; col <= crossAxisCount - requiredCols; col++) {
      if (_canPlaceAt(occupancy, row, col, requiredRows, requiredCols)) {
        return _TilePosition(row: row, col: col);
      }
    }
    row++;
  }
}

/// Checks if a tile can be placed at the given start row/column.
bool _canPlaceAt(List<List<bool>> occupancy, int startRow, int startCol, int requiredRows, int requiredCols) {
  for (int r = startRow; r < startRow + requiredRows; r++) {
    for (int c = startCol; c < startCol + requiredCols; c++) {
      if (occupancy[r][c]) return false;
    }
  }
  return true;
}

/// Marks cells in the occupancy grid as occupied by the tile.
void _markOccupancy(List<List<bool>> occupancy, _TilePosition pos, int tileCols, int tileRows) {
  for (int r = pos.row; r < pos.row + tileRows; r++) {
    for (int c = pos.col; c < pos.col + tileCols; c++) {
      occupancy[r][c] = true;
    }
  }
}
