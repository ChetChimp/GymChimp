import 'package:flutter/material.dart';
import 'package:gymchimp/openingScreens/login_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _HomePage();
}

class _HomePage extends State<StartPage> {
  void backToLogin(BuildContext ctx) {
    Navigator.of(ctx).push(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
            top: size.width * 1 / 2.75, left: size.width * 1 / 16),
        alignment: Alignment.bottomLeft,
        child: Material(
          child: IconButton(
            // pressedOpacity: 100,
            color: Color.fromARGB(255, 79, 79, 79),

            padding: EdgeInsets.only(
                left: size.width * 1 / 16,
                right: size.width * 1 / 16,
                top: 3,
                bottom: 10),
            icon: const Icon(Icons.lock),
            onPressed: () {
              backToLogin(context);
            }, //validation(context),
          ),
        ),
      ),
    );
  }
}
