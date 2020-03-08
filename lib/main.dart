import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicktodoapp/todo_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick TODO App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Quick TODO App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> todos;
  TextEditingController controller;
  String newTodo;

  @override
  void initState() {
    controller = new TextEditingController();
    todos = [];
    newTodo = '';
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            generateAddTodoForm(),
            generateClearAllButton(context),
            todos.isNotEmpty
                ? generateTodoList(todos)
                : generateAllClearNotification(),
          ],
        ),
      ),
    );
  }

  RaisedButton generateClearAllButton(BuildContext context) {
    return RaisedButton(
      child: Text('Clear all'),
      onPressed: todos.isNotEmpty
          ? () {
              showDialog(
                context: context,
                child: AlertDialog(
                    title: Text('Are you sure you want to clear all items?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          setState(() {
                            todos.clear();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ]),
              );
            }
          : null,
    );
  }

  Expanded generateTodoList(List<TodoItem> todos) {
    return Expanded(
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          TodoItem item = todos[index];
          return ListTile(
            title: Text(
              item.description,
              style: TextStyle(
                color: item.done ? Colors.grey : Colors.black,
                decoration: item.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontSize: 20,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                item.done
                    ? setState(() {
                        todos.removeAt(index);
                      })
                    : showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Item not done yet. Are you sure?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                setState(() {
                                  todos.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
              },
            ),
            onTap: () {
              setState(() {
                item.done = !item.done;
              });
            },
          );
        },
      ),
    );
  }

  Widget generateAddTodoForm() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Add a new TODO',
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => controller.clear());
                      setState(() {
                        controller.text = '';
                      });
                    },
                  )
                : null,
          ),
          autofocus: false,
          controller: controller,
          onChanged: (text) {
            setState(() {
              newTodo = text;
            });
          },
        ),
        RaisedButton(
          child: Text('Add'),
          onPressed: controller.text.isNotEmpty
              ? () {
                  setState(() {
                    todos.add(new TodoItem(newTodo, false));
                  });
                  controller.text = '';
                }
              : null,
        ),
      ],
    );
  }

  Widget generateAllClearNotification() {
    return Column(
      children: <Widget>[
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ),
        Text(
          'All done!',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
