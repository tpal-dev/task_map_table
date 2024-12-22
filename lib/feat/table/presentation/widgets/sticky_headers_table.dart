import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum SortType {
  none(icon: Icons.sort),
  ascending(icon: Icons.arrow_upward),
  descending(icon: Icons.arrow_downward);

  const SortType({required this.icon});
  final IconData icon;
}

class StickyHeadersTable extends StatefulWidget {
  final String title;
  final double cellHeight = 50.0;
  final double cellWidth = 110.0;
  final List<String> columnHeaders;
  final List<String> rowHeaders;
  final List<List<String>> tableData;

  const StickyHeadersTable({
    super.key,
    required this.title,
    required this.columnHeaders,
    required this.rowHeaders,
    required this.tableData,
  });

  @override
  State<StickyHeadersTable> createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  final ScrollController _headerVerticalScrollController = ScrollController();
  final ScrollController _headerHorizontalScrollController = ScrollController();
  final ScrollController _dataVerticalScrollController = ScrollController();
  final ScrollController _dataHorizontalScrollController = ScrollController();

  List<SortType> _sortStates = [];
  List<List<String>> _tableData = [];

  @override
  void initState() {
    super.initState();
    _tableData = widget.tableData;
    _sortStates = List.generate(widget.tableData.length, (index) => SortType.none);

    _dataVerticalScrollController.addListener(() {
      if (_headerVerticalScrollController.hasClients) {
        _headerVerticalScrollController.jumpTo(_dataVerticalScrollController.offset);
      }
    });

    _dataHorizontalScrollController.addListener(() {
      if (_headerHorizontalScrollController.hasClients) {
        _headerHorizontalScrollController.jumpTo(_dataHorizontalScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _headerVerticalScrollController.dispose();
    _headerHorizontalScrollController.dispose();
    _dataVerticalScrollController.dispose();
    _dataHorizontalScrollController.dispose();
    super.dispose();
  }

  void _sortRow(int rowIndex) {
    setState(() {
      List<String> rowData = _tableData[rowIndex];

      switch (_sortStates[rowIndex]) {
        case SortType.none:
          rowData.sort();
          _sortStates[rowIndex] = SortType.ascending;
          break;
        case SortType.ascending:
          rowData.sort((a, b) => b.compareTo(a));
          _sortStates[rowIndex] = SortType.descending;
          break;
        case SortType.descending:
          _tableData[rowIndex] = List.from(widget.tableData[rowIndex]);
          _sortStates[rowIndex] = SortType.none;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // Title top left corner
          Positioned(
            top: 0,
            left: 0,
            width: widget.cellWidth,
            height: widget.cellHeight,
            child: Container(
              alignment: Alignment.center,
              color: Colors.grey[400],
              child: Text(widget.title),
            ),
          ),

          // Column headers
          Positioned(
            top: 0,
            left: widget.cellWidth,
            right: 0,
            height: widget.cellHeight,
            child: SingleChildScrollView(
              controller: _headerHorizontalScrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: widget.columnHeaders.map((header) {
                  return Container(
                    width: widget.cellWidth,
                    height: widget.cellHeight,
                    alignment: Alignment.center,
                    color: Colors.grey[300],
                    child: Text(header),
                  );
                }).toList(),
              ),
            ),
          ),

          // Row headers
          Positioned(
            top: 50,
            left: 0,
            bottom: 0,
            width: widget.cellWidth,
            child: SingleChildScrollView(
              controller: _headerVerticalScrollController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  Column(
                    children: widget.rowHeaders.mapIndexed((index, header) {
                      return Container(
                        width: widget.cellWidth,
                        height: widget.cellHeight,
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(_sortStates[index].icon),
                              onPressed: () => _sortRow(index),
                            ),
                            FittedBox(
                              child: Text(header),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Data section
          Positioned(
            top: widget.cellHeight,
            left: widget.cellWidth,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: _dataHorizontalScrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SingleChildScrollView(
                controller: _dataVerticalScrollController,
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: _tableData.mapIndexed((index, row) {
                    return Row(
                      children: row.map((cell) {
                        return Container(
                          width: widget.cellWidth,
                          height: widget.cellHeight,
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(cell),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
