import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cupit/states.dart';
import '../shared/cupit/cupit.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal[700],
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),
              ),
              body: state is AppGetDatabaseLoadingStates
                  ? Center(child: CircularProgressIndicator())
                  : cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  selectedItemColor: Colors.teal[700],
                  onTap: (index) {
                    if (cubit.showBottomSheet) {
                      Navigator.pop(context);
                    }
                    cubit.changeIndex(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu), label: 'tasks'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline), label: 'done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive_outlined), label: 'archive'),
                  ]),
            );
          }),
    );
  }
}
