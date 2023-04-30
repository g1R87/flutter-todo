import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController =
      TextEditingController(/*text:"default text"*/);
  TextEditingController decsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add a todo"),
        ),
        body: ListView(
          //listview is scrollable by default unlike Column()
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            TextField(
              controller: decsController,
              decoration: const InputDecoration(
                hintText: "Descreption",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: submitData,
              child: const Text("Submit"),
            )
          ],
        ));
  }

  Future<void> submitData() async {
    //three steps
    //1. get data from form
    final title = titleController.text;
    final desc = decsController.text;
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false,
    };
    //2. submit data to the server
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body), //jsonbody parsing
      headers: {
        'Content-Type': 'application/json',
      },
    );

    //show success/failure status visually

    if (response.statusCode == 201) {
      titleController.text = "";
      decsController.text = "";
      print(response.body);
      showSuccessMessage("Creation success");
    } else {
      showFailureMessage("BOOm! fail");
      print("error\n$response.body");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailureMessage(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
