import 'package:flutter/material.dart';
import 'package:confetti_anim/confetti.dart';
import 'package:confetti_anim/confetti_alt1.dart';
import 'package:confetti_anim/confetti_alt2.dart';
import 'package:confetti_anim/confetti_alt3.dart';
import 'package:confetti_anim/confetti_alt4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _is_stopped = false;

  _stop_confetti(){
    setState(() {
      _is_stopped = true;
    });
  }


  @override
  Widget build(BuildContext context) {

      ;
      return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child:
        // Falling_Confetti()
          Confetti_Alt_4()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _stop_confetti,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
