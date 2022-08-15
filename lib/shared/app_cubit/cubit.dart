import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/shared/app_cubit/state.dart';
import 'package:flutter_social/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialStates());
  int currentIndex = 0;

  late Database database;


  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> arichvedTasks = [];



  void change(int index)
  {
    currentIndex = index;
    emit(AppChangNavBarStates());
  }
  void createDataBase()
  {
    openDatabase(
      'todo.database',
      version: 1,
      onCreate: (database,version)
      {
        print('database is created');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value) {
          print('table is created');
        }).catchError((error)
        {
          print('Error when creating Table');
        });
      },
      onOpen : (database)
      {
        getDatafromDatebase(database);
        print('database is opened');
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabeasStates());
    });
  }


  insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks (title,time,date,status)VALUES("$title","$time","$date","new")').
      then((value) {
        print('task is Inserted');
        emit(AppInsertDatabeasStates());
        getDatafromDatebase(database);
      }).catchError((error){
        print('Error when insearting task');
      });
      return null;
    });
  }
  void getDatafromDatebase(database)
  {
    newTasks = [];
    doneTasks = [];
    arichvedTasks = [];
    emit(AppGetDatabeasLoadingStates());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element ['status'] == 'new')
          newTasks.add(element);
        else if(element ['status'] == 'done')
          doneTasks.add(element);
        else arichvedTasks.add(element);
      });
      emit(AppGetDatabeasStates());
    });
  }

  void updateData({
    required String states,
    required int id,
  })  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$states', id],
    ).then((value)
    {
      getDatafromDatebase(database);
      emit(AppUpdateDatabeasStates());
    });
  }

  bool isBotton = false;
  IconData icona = Icons.edit;

  void changeBottom({
    required bool isShow,
    required IconData icon
  })
  {
    isBotton = isShow;
    icona = icon;
    emit(AppChangBottomStates());
  }

  void deleteData({
    required int id,
  })  {
    database.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getDatafromDatebase(database);
      emit(AppDeleteDatabeasStates());
    });
  }

  bool isDark = false;

  void changeModeState({formState})
  {
    if (formState != null)
    {
      isDark = formState ;
    }else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) =>
      {
        emit(AppChangeModeState()),
      });
    }
  }

}