import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cupit/states.dart';
import 'package:bloc/bloc.dart';
import '../../modules/archive/archive_screen.dart';
import '../../modules/done/done_screen.dart';
import '../../modules/tasks_screen/tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  bool showBottomSheet = false;
  IconData flIcon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  Database? database;
  List<Map> tasks = [];
  List<Map> done = [];
  List<Map> archive = [];
  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> titles = ["New Tasks", "DoneTasks", 'Archive'];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavbarStates());
  }

  void createDataBase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print("database created");
        database
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT , status TEXT )")
            .then((value) {
          print("table created");
        }).catchError((error) {
          print("error when creating table is ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }

  insertDataBase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES ("$title","$date","$time","new")');
    }).then((value) {
      print('$value inserted successfully');
      emit(AppInsertDatabaseStates());
      getDataFromDatabase(database);
    }).catchError((error) {
      print('error when inserting is ${error.toString()}');
    });
  }

  void getDataFromDatabase(database) {
    database?.rawQuery("SELECT * FROM tasks").then((value) {
      tasks = [];
      archive = [];
      done = [];
      value.forEach((element) {
        if (element["status"] == 'new') {
          tasks.add(element);
        } else if (element["status"] == 'archived') {
          archive.add(element);
        } else
          done.add(element);
      });
      emit(AppGetDatabaseStates());
    });
    emit(AppAfterGetDatabaseStates());
  }

  void upDateDatabase({
    required String status,
    required int id,
  }) {
    database?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpDateDatabaseStates());
      getDataFromDatabase(database);
    });
  }

  void deleteFromDatabase({required int id}) {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteFromDatabaseStates());
      getDataFromDatabase(database);
    });
  }

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
  }) {
    showBottomSheet = isShow;
    flIcon = icon;
    emit(AppChangeBottomSheetStates());
  }
}
