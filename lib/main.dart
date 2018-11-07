import 'package:flutter/material.dart';
import 'todo_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TodoProvider _todoProvider = TodoProvider();

  void _createTodoAndIncrementCounter() {
    _counter++;

    _todoProvider.insert(Todo.fromMap({"title": "Todo number $_counter"}));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: StreamBuilder(
          stream: _todoProvider.getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Text(snapshot.data[index].title);
                  },
                );
              } else {
                return Text("There are no todos.");
              }
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _createTodoAndIncrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
