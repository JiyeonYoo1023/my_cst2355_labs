import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  var isChecked = false;
  late TextEditingController _login;
  late TextEditingController _passwd;
  var imageSource = "images/question-mark.png";


  @override
  void initState() {
    super.initState();
    _login = TextEditingController();
    _passwd = TextEditingController();
  }

  @override
  void dispose() {
    _login.dispose();
    _passwd.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: _login,
                decoration: InputDecoration(
                  hintText:"Login",
                  border: OutlineInputBorder(),
                )),
            TextField(controller: _passwd,
              decoration: InputDecoration(
                hintText:"Password",
                border: OutlineInputBorder(),
                label: Text("Password"),
              ), //obscureText:true,

            ),

            ElevatedButton(
              onPressed: () {
                var txt = _passwd.value.text;
                setState(() {
                  if (txt == "QWERTY123") {
                    imageSource = "images/idea.png";
                    Semantics( label: 'Light bulb Image',
                        child: Image.asset(imageSource, width:300, height:300));
                  }
                  else if(txt != "ASDF") {
                    imageSource = "images/stop.png";
                    Semantics( label: "Stop Image",
                        child: Image.asset(imageSource, width:300, height:300));
                  }
                });
              },
              child: Text("Login", style:TextStyle(fontSize:30)),

            ),
            Semantics( label: 'Question Mark Image', child: Image.asset(imageSource, width:300, height:300)),
          ],
        ),
      ),
    );
  }
}
