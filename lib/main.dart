import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tools/util/assets_app.dart';
import 'package:flutter_tools/util/sized_app.dart';

import 'git/git_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: (BuildContext context, Widget? child){
        return Scaffold(
          body: child,
        );
      },
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: "/splash",
    );
  }
}

class RoutesName {
  static const String MENU_PAGE = '/menu_page';
  static const String GIT_PAGE = '/git_page';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(
          settings: RouteSettings(name:settings.name),
          builder: (context) => SplashPage(),
        );
      case RoutesName.MENU_PAGE:
        return MaterialPageRoute(
          settings: RouteSettings(name:settings.name),
          builder: (context) => MenuPage(),
        );
      case RoutesName.GIT_PAGE:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => GitPage(),
        );
      default:
        return MaterialPageRoute(
          settings: RouteSettings(name:'/error'),
          builder: (context) =>
            Scaffold(body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Invalid route"),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(RoutesName.MENU_PAGE, (Route<dynamic> route) => false);
                  },
                  child: Text('Voltar ao menu')
                )
              ],
            )),
        );
    }
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(RoutesName.MENU_PAGE, (Route<dynamic> route) => false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(SizedApp.to == null) SizedApp(MediaQuery.of(context).size);
    return Center(
      child: Text("Splash"),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  _navigateTo(String route){
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    if(!kIsWeb){
      if(!Platform.isWindows)
        return Center(child: Text("web/desktop"));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MenuButtonComponent(text: "Git", onTap: () {
          _navigateTo(RoutesName.GIT_PAGE);
        }, icon: Image.asset(AssetsApp.to.gitLogo)),
        MenuButtonComponent(text: "Outras", onTap: () {})
      ],
    );
  }
}

class MenuButtonComponent extends StatefulWidget {
  final String text;
  final Widget? icon;
  final Function() onTap;
  const MenuButtonComponent({Key? key, required this.text, required this.onTap, this.icon}) : super(key: key);
  @override
  _MenuButtonComponentState createState() => _MenuButtonComponentState();
}

class _MenuButtonComponentState extends State<MenuButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(1,1),
              spreadRadius: 1
            )
          ]
        ),
        height: 100,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon == null ? SizedBox() :
            SizedBox(
              height: 50,
              width: 100,
              child: widget.icon,
            ),
            SizedBox(height: 5),
            Center(child: Text(widget.text)),
          ],
        ),
      ),
    );
  }
}