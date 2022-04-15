import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_reminder/ui/theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  InputField(
      {required this.hint, required this.title, this.controller, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titletyle,
          ),
          Container(
            padding: EdgeInsets.only(left: 14.0),
            margin: EdgeInsets.only(top: 5),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey, width: 1.0)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autocorrect: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                    controller: controller,
                    style: subTitlestyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitlestyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
