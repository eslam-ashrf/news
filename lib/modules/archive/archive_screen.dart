import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import 'package:todo/shared/cupit/cupit.dart';
import '../../shared/cupit/states.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archive;
        return tasks.length > 0
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
                      Icons.archive,
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
              );
      },
    );
  }
}
