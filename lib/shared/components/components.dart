import 'package:flutter/material.dart';
import 'package:todo/shared/cupit/cupit.dart';

Widget defaultButton({
  double width = double.infinity,
  required void Function() function,
  required String text,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
          color: Colors.teal[700],
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget buildTaskItem(Map item, context) => Dismissible(
      key: UniqueKey(),
      onDismissed: (dirction) {
        AppCubit.get(context).deleteFromDatabase(id: item["id"]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsetsDirectional.only(
            start: 20,
            top: 12,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.teal[500],
            borderRadius: BorderRadius.circular(25),
          ),
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item["title"]}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Row(
                      children: [
                        Text(
                          '${item["date"]}',
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        ),
                        Text(' . '),
                        Text(
                          '${item["time"]}',
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (AppCubit.get(context).currentIndex == 0)
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .upDateDatabase(status: 'archived', id: item['id']);
                    },
                    icon: Icon(
                      Icons.archive_outlined,
                      color: Colors.black54,
                    )),
              if (AppCubit.get(context).currentIndex == 1)
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .upDateDatabase(status: 'archived', id: item['id']);
                    },
                    icon: Icon(
                      Icons.archive_outlined,
                      color: Colors.black54,
                    )),
              if (AppCubit.get(context).currentIndex == 0)
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .upDateDatabase(status: 'done', id: item['id']);
                    },
                    icon: Icon(Icons.check_circle_outline,
                        color: Colors.black54)),
              if (AppCubit.get(context).currentIndex == 2)
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .upDateDatabase(status: 'done', id: item['id']);
                    },
                    icon: Icon(Icons.check_circle_outline,
                        color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
Widget defaultFormFaild({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required IconData prefix,
  required String lable,
  BuildContext? context,
  String? Function(String?)? validate,
  void Function()? onTap,
  IconData? suffix,
  bool ispassword = false,
  void Function()? onPressed,
  ispssword,
}) =>
    TextFormField(
      cursorColor: Colors.teal,
      controller: controller,
      keyboardType: keyboardType,
      validator: validate,
      obscureText: ispassword,
      onTap: onTap,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.teal)),
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(suffix),
        ),
        hintText: lable,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );