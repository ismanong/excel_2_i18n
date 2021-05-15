import 'package:flutter/material.dart';

class CsvDataTable extends StatelessWidget {
  final List<List> csv;
  CsvDataTable({Key? key, required this.csv}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (csv.isEmpty) {
      child = Container();
    } else {
      child = _buildDataTable();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }

  Widget _buildDataTable() {
    List<List> rowsCopy = new List.from(csv);
    List<dynamic> rowHead = rowsCopy.removeAt(0); //删除数组,返回删除项,获取标题
    List<List> rowBody = rowsCopy; // 获取内容

    List<DataColumn> columns = rowHead.map((dynamic e) {
      return DataColumn(
        label: Container(
          width: 40.0,
          child: Text('$e'),
        ),
      );
    }).toList();

    List<DataRow> rows = rowBody.map((List e) {
      List<DataCell> cells = e.map((text) {
        return DataCell(Container(
          width: 40.0,
          child: Text('$text'),
        ));
      }).toList();
      return DataRow(
        cells: cells,
      );
    }).toList();

    return DataTable(
      horizontalMargin: 0.0, //表格边缘和内容之间的水平边距
      columnSpacing: 0.0,
      dataRowHeight: 20.0,
      headingRowHeight: 30.0,
      columns: columns,
      rows: rows,
    );
  }
}
