import 'package:flutter/material.dart';
import 'package:task/feat/table/presentation/widgets/sticky_headers_table.dart';
import 'package:task/feat/table/table_data_model.dart';

class TablePage extends StatelessWidget {
  const TablePage({
    super.key,
    required this.tableDataModel,
  });

  static const routeName = '/table';

  final TableDataModel tableDataModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabela'),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            StickyHeadersTable(
              title: tableDataModel.title,
              columnHeaders: tableDataModel.columnHeaders,
              rowHeaders: tableDataModel.rowHeaders,
              tableData: tableDataModel.tableData,
            ),
            const Text(
                'Jest to moja własna customowa tabela. Flutter ma DataTable widget natomiast nie obsługuje sticky headers. Jest również dostępna gotowa paczka https://pub.dev/packages/table_sticky_headers')
          ],
        ),
      ),
    );
  }
}
