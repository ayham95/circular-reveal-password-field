import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:password_field/circular_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  CurvedAnimation _animation;

  /// The controller shared by all text fields so they have the same text
  TextEditingController _textEditingController = TextEditingController();

  /// The variable that controls the contrast of the background
  bool _darkColor = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Width of the text field container
    final width = MediaQuery.of(context).size.width / 1.2;

    /// Height of the text field container
    final height = 80.0;
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        color: _darkColor ? Colors.white : Colors.grey[700],
        child: Center(
          child: Stack(
            children: <Widget>[
              NormalField(
                controller: _textEditingController,
                onTap: () => _onClosedEyeTap(),
                width: width,
                height: height,
              ),
              CircularAnimation(
                offset: Offset(width - 24, 40),
                animation: _animation,
                child: AbnormalField(
                  controller: _textEditingController,
                  onTap: () => _onOpenedEyeTap(),
                  width: width,
                  height: height,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClosedEyeTap() {
    setState(() {
      _animationController.forward();
      _darkColor = true;
    });
  }

  _onOpenedEyeTap() {
    setState(() {
      _animationController.reverse();
      _darkColor = false;
    });
  }
}

/// [NormalField] widget is the widget that hides the password
class NormalField extends StatelessWidget {
  /// A function triggered when the eye icon is tapped
  final Function onTap;
  final double width;
  final double height;

  /// The controller shared by all text fields so they have the same text
  final TextEditingController controller;

  const NormalField(
      {Key key,
      this.onTap,
      @required this.width,
      @required this.height,
      @required this.controller})
      : assert(controller != null),
        assert(width != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 20)],
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                      hintText: 'password',
                      hintStyle: TextStyle(color: Colors.white)),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(36))),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      radius: 20,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          FontAwesomeIcons.eye,
                          color: Colors.grey[900],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

/// [AbnormalField] widget is the widget that shows the password
class AbnormalField extends StatelessWidget {
  /// A function triggered when the eye icon is tapped
  final Function onTap;
  final double width;
  final double height;

  /// The controller shared by all text fields so they have the same text
  final TextEditingController controller;

  const AbnormalField({
    Key key,
    this.onTap,
    @required this.width,
    @required this.height,
    @required this.controller,
  })  : assert(controller != null),
        assert(width != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.lock_open,
                color: Colors.grey[900],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                    hintText: 'password',
                    hintStyle: TextStyle(
                      color: Colors.grey[900],
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.grey[900],
                  ),
                  obscureText: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  radius: 20,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      FontAwesomeIcons.eyeSlash,
                      color: Colors.grey[900],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
