import 'dart:async';
import 'package:sqlcool/src/database.dart';

class SelectBloc {
  SelectBloc(this.table,
      {this.offset,
      this.limit,
      this.where,
      this.columns,
      this.select: "*",
      this.joinTable,
      this.joinOn}) {
    this._getItems();
  }

  final String table;
  int offset;
  int limit;
  String columns;
  String where;
  String select;
  String joinTable;
  String joinOn;

  final _itemController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  get items => _itemController.stream;

  dispose() {
    _itemController.close();
  }

  _getItems() async {
    List<Map<String, dynamic>> res;
    if (joinTable == null) {
      res = await db.select(table,
          columns: columns, offset: offset, limit: limit, where: where);
    } else {
      res = await db.join(table, columns, joinTable, joinOn,
          offset: offset, limit: limit, where: where);
    }
    _itemController.sink.add(res);
  }
}
