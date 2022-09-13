import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../shared/components/components.dart';
import 'package:todo/shared/cupit/cupit.dart';
import '../../shared/cupit/states.dart';

class TasksScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        state is AppAfterGetDatabaseStates;
        {
          AppCubit.get(context).titleController.text = "";
          AppCubit.get(context).dateController.text = "";
          AppCubit.get(context).timeController.text = "";
        }
      },
      builder: (context, state) {
        var tasks = AppCubit.get(context).tasks;
        var cubit = AppCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          body: tasks.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView.separated(
                      itemBuilder: (context, index) =>
                          buildTaskItem(tasks[index], context),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: tasks.length),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu,
                        size: 100,
                        color: Colors.teal[200],
                      ),
                      Text(
                        "No tasks yet,Please Add your tasks",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[200],
                        ),
                      )
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal[700],
            onPressed: () {
              if (cubit.showBottomSheet) {
                Navigator.pop(context);
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet((context) => Container(
                          padding: EdgeInsetsDirectional.all(20),
                          color: Colors.teal[400],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFaild(
                                  controller: cubit.titleController,
                                  keyboardType: TextInputType.text,
                                  prefix: Icons.title,
                                  lable: "Task title",
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "add a title";
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                defaultFormFaild(
                                  controller: cubit.dateController,
                                  keyboardType: TextInputType.datetime,
                                  prefix: Icons.date_range,
                                  lable: "Task date",
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2022-12-31"))
                                        .then((value) {
                                      cubit.dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "add a date";
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                defaultFormFaild(
                                  controller: cubit.timeController,
                                  keyboardType: TextInputType.datetime,
                                  prefix: Icons.watch_later_outlined,
                                  lable: "Task time",
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      cubit.timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "add a time";
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.insertDataBase(
                                        title: cubit.titleController.text,
                                        date: cubit.dateController.text,
                                        time: cubit.timeController.text,
                                      );
                                    }
                                  },
                                  text: "ADD",
                                ),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                });
                cubit.changeBottomSheet(
                    isShow: true, icon: Icons.keyboard_arrow_down);
              }
            },
            child: Icon(cubit.flIcon),
          ),
        );
      },
    );
  }
}
