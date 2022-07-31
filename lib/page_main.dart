import 'package:flutter/material.dart';
import 'page_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Bag Back'),
    );
  }
}


/*
  HOMEPAGE
*/

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  bool showPassword = false;
  bool showMessage = false;

  Widget buildPasswordTextField() {
    return TextField(
      controller: passwordController,
      obscureText: !showPassword,
      decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.security),
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye),
            color: showPassword ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          )),
    );
  }

  void login() {
    print('pass: ${passwordController.text}');
    print('user: ${usernameController.text}');

    if (passwordController.text == usernameController.text) {
      showMessage = false;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const OptionsPage();
          },
        ),
      );
    } else {
      print('ERROR: wrong password.');
      showMessage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 20,),
                buildPasswordTextField(),
                const SizedBox(height: 20,),
                RaisedButton(
                    onPressed: () {
                      setState(() {
                        login();
                      });
                    },
                    child: const Text('Login')),
                const SizedBox(height: 20,),
                Visibility(
                  visible: showMessage,
                  child: Container(
                    height: 30,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red),
                    child: Center(
                      child: Text(
                        '$_counter',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
