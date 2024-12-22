import 'dart:math';

class TableDataModel {
  final String title;
  final List<String> columnHeaders;
  final List<String> rowHeaders;
  final List<List<String>> tableData;

  TableDataModel({
    required this.title,
    required this.columnHeaders,
    required this.rowHeaders,
    required this.tableData,
  });

  factory TableDataModel.mock() {
    final columnHeaders = List.generate(8, (index) => '${index + 1}');
    final rowHeaders = [
      'Wodór',
      'Hel',
      'Lit',
      'Beryl',
      'Bor',
      'Węgiel',
      'Azot',
      'Tlen',
    ];

    final random = Random();
    final tableData = List.generate(
      8,
      (rowIndex) => List.generate(
        8,
        (colIndex) => ((random.nextDouble() * 10) + (rowIndex * 10)).toStringAsFixed(2),
      ),
    );

    return TableDataModel(
      title: 'Pierwiastki',
      columnHeaders: columnHeaders,
      rowHeaders: rowHeaders,
      tableData: tableData,
    );
  }
}
