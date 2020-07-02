import 'package:tracers/tracers.dart' as Log;
import 'package:sqlite_controller/sqlite_controller.dart' as SQL;

import '../modules/initial_module.dart';
import '../resources/app_localizations.dart';
import '../resources/constants.dart' as Constants;

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mode_theme/mode_theme.dart';

class InitialScreen extends ModularStatelessWidget<InitialModule> {
  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Constants.modeIcon,
            onPressed: () {
              ModeTheme.of(context).toggleBrightness();
            },
          )
        ],
        title: Text(tr(context, 'Title')), //TODO provide translations in "languages/en.json"
      ),
      body: _InitialWidget(), // body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'NoOp',
        child: Icon(Icons.add),
      ),
    );
  }
}

//MARK:
class _InitialWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _buildDatabase();
    return Text('Initial Widget');
  }

  //MARK: Creates a really uses collection of tables to serve as a guide for sqlite development
  void _buildDatabase() async {
    try {
      await SQL.SqliteController.initialize(name: Constants.databaseName);
      await _buildSiblings();
      await _buildAddress();
      await _buildName();
      await _loading();
      await _getTheColumns();
    } catch (error) {
      Log.e('${error.toString()}');
    }
  }

  Future<void> _buildSiblings() async {
    try {
      final String create = '''
      CREATE TABLE IF NOT EXISTS siblings (
         addressId INTEGER,
         nameId INTEGER,
         PRIMARY KEY (addressId, nameId),
         FOREIGN KEY (addressId)
           REFERENCES address (rowid),
         FOREIGN KEY (nameId)
           REFERENCES name (rowid)
      )
      ''';
      await SQL.SqliteController.database.execute(create);
    } catch (error) {
      Log.e('${error.toString()}');
    }
  }

  Future<void> _buildAddress() async {
    try {
      final String create = '''
      CREATE TABLE IF NOT EXISTS address (
        address TEXT,
        age INTEGER,
        weight REAL,
        dob TEXT,
        name INTEGER,
        FOREIGN KEY (name)
          REFERENCES name (rowId)
      )
      ''';
      await SQL.SqliteController.database.execute(create);
    } catch (error) {
      Log.e('${error.toString()}');
    }
  }

  Future<void> _buildName() async {
    try {
      final String create = '''
      CREATE TABLE IF NOT EXISTS name (
        first TEXT,
        last TEXT
      )
      ''';
      await SQL.SqliteController.database.execute(create);
    } catch (error) {
      Log.e('${error.toString()}');
    }
  }

  Future<void> _loading() async {
    try {
      Map<String, dynamic> name = {'first': 'Steven', 'last': 'Smith'};
      final database = SQL.SqliteController.database;
      int nameRowid = await database.insert('name', name);
      Map<String, dynamic> address = {
        'address': '2526 Orange Tree',
        'age': 59,
        'weight': 209.5,
        'dob': '1960-12-19T19:56:00Z',
        'name': nameRowid,
      };
      int addressId = await database.insert('address', address);
      Map<String, dynamic> brother = {'first': 'Richard', 'last': 'Smith'};
      int broId = await database.insert('name', brother);
      Map<String, dynamic> bro = {'addressId': addressId, 'nameId': broId};
      int broRow = await database.insert('siblings', bro);
      Log.t('broRow $broRow');

      Map<String, dynamic> sister = {'first': 'DeeDee', 'last': 'Grau'};
      int sisId = await database.insert('name', sister);
      Map<String, dynamic> sis = {'addressId': addressId, 'nameId': sisId};
      int sisRow = await database.insert('siblings', sis);
      Log.t('sisRow $sisRow');
      Log.t('Done');
    } catch (error) {
      Log.e('${error.toString()}');
    }
  }

  Future<void> _getTheColumns() async {
    final database = SQL.SqliteController.database;
    final sql = 'PRAGMA table_info(address)';
    List<Map<String, dynamic>> results = await database.rawQuery(sql);
    Log.v('result: ${results.toString()}');
    for (Map<String, dynamic> row in results) {
      final name = row['name'];
      Log.v('name $name');
    }
  }
}
