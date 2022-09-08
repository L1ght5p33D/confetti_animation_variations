import 'dart:collection';
import 'dart:math';
import 'package:flutter/widgets.dart';
import  'dart:async';

class Confetti_Alt_4 extends StatefulWidget {
  static const _defaultColors = [
    Color(0xffd10841),
    Color(0xff1d75fb),
    Color(0xff0050bc),
    Color(0xffa2dcc7),
  ];

  final bool isStopped;

  final List<Color> colors;


  const Confetti_Alt_4({
  this.colors = _defaultColors,
  this.isStopped = false,
  super.key,
});

@override
State<Confetti_Alt_4> createState() => _Confetti_Alt_4State();
}

class ConfettiPainter extends CustomPainter {
  final defaultPaint = Paint();

  int snippets_count = 0;

  final int snippingsGroupDirection = 0;

  int group_idx = 0;

   List snippings = [];

  Size? _size;

  DateTime _lastTime = DateTime.now();

  final UnmodifiableListView<Color> colors;

  String confetti_type;

  ConfettiPainter(
      {required Listenable animation, required Iterable<Color> colors,
        this.snippets_count:0,
        this.group_idx: 0 , this.confetti_type:"default"})
      : colors = UnmodifiableListView(colors),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    print("Confetti painter paint~");
    if (_size == null) {
      // First time we have a size.
      // if (snippings == null){
      //   print("snippings null");
      //   return;
      // }

      if (confetti_type == "upward") {
        snippings!.addAll(List.generate(
            snippets_count,
                (i) =>
                _UpwardPaperSnipping(
                    frontColor: colors[i % colors.length],
                    bounds: size,
                    group_direction: group_idx
                )));
      }
      if (confetti_type == "falling") {
        snippings!.addAll(List.generate(
            snippets_count,
                (i) =>
                _FallingPaperSnipping(
                    frontColor: colors[i % colors.length],
                    bounds: size,
                    group_direction: group_idx
                )));
      }
    }

    final didResize = _size != null && _size != size;
    final now = DateTime.now();
    final dt = now.difference(_lastTime);
    for (final snipping in snippings!) {
      if (didResize) {
        snipping.updateBounds(size);
      }
      snipping.update(dt.inMilliseconds / 1000);

      snipping.draw(canvas);

      // snipping.draw(canvas);
    }

    _size = size;
    _lastTime = now;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

int upward_confetti_group_idx = 0;
int falling_confetti_group_idx = 0;

class _Confetti_Alt_4State extends State<Confetti_Alt_4>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<Widget>? cas_cp = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // We don't really care about the duration, since we're going to
      // use the controller on loop anyway.
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (!widget.isStopped) {
      _controller.repeat();
    }

    if (upward_confetti_group_idx < 200) {
      Timer.periodic(new Duration(milliseconds: 10), (timer) {
        upward_confetti_group_idx += 1;
        setState(() {
          cas_cp!.add(CustomPaint(
            painter: ConfettiPainter(
                colors: widget.colors,
                animation: _controller,
                snippets_count: 10,
                group_idx: upward_confetti_group_idx,
                confetti_type: "upward"
            ),
            willChange: true,
            child: const SizedBox.expand(),
          ));
        });
      });
      Future.delayed(Duration(seconds:4),(){
        Timer.periodic(new Duration(seconds: 1), (timer) {
          cas_cp!.removeAt(0);
        });
      });
    }


    Future.delayed(Duration(seconds:2),(){
        while (falling_confetti_group_idx <= 20){
          falling_confetti_group_idx +=1;
          Future.delayed(Duration(milliseconds: 400 * falling_confetti_group_idx),(){
          cas_cp!.add(CustomPaint(
            painter: ConfettiPainter(
                colors: widget.colors,
                animation: _controller,
                snippets_count: 30,
                group_idx: falling_confetti_group_idx,
                confetti_type: "falling"
            ),
            willChange: true,
            child: const SizedBox.expand(),
          ));
        });
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("confetti alt2 build");

    return Stack(children: cas_cp!);

  }

  @override
  void didUpdateWidget(covariant Confetti_Alt_4 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStopped && !widget.isStopped) {
      _controller.repeat();
    } else if (!oldWidget.isStopped && widget.isStopped) {
      _controller.stop(canceled: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


}

class _UpwardPaperSnipping {
  static final Random _random = Random();
  static const degToRad = pi / 180;
  static const backSideBlend = Color(0x70EEEEEE);

  Size _bounds;

  int group_direction;
  // late final _Vector position = _Vector(
  //   _random.nextDouble() * _bounds.width,
  //   _random.nextDouble() * _bounds.height,
  // );

  late _Vector position = _Vector((_bounds.width/2) + (40 * _random.nextDouble())
      , _bounds.height/2 + (40 * _random.nextDouble()));

  final double rotationSpeed = 800 + _random.nextDouble() * 600;
  final double angle = _random.nextDouble() * 360 * degToRad;

  double rotation = _random.nextDouble() * 360 * degToRad;
  double cosA = 1.0;
  final double size = 7.0;
  final double oscillationSpeed = 0.5 + _random.nextDouble() * 1.5;

  // final double xSpeed = 40 - _random.nextDouble() * 40;
  // final double ySpeed = 60 - _random.nextDouble() * 100;

  late List<_Vector> corners = List.generate(4, (i) {
    final angle = this.angle + degToRad * (45 + i * 90);
    return _Vector(cos(angle), sin(angle));
  });

  double time = _random.nextDouble();
  final Color frontColor;
  late final Color backColor = Color.alphaBlend(backSideBlend, frontColor);

  final paint = Paint()..style = PaintingStyle.fill;

  _UpwardPaperSnipping({
    required this.frontColor,
    required Size bounds,
    this.group_direction: 0
  }) : _bounds = bounds;

  int xVmod = 1;
  int yVmod = 1;
  double xSpeed = 0;
  double ySpeed = 0;

  void draw(Canvas canvas) {

    if(group_direction %2 == 0 )
    {xVmod = -1;}
    xSpeed = xVmod * (300)  + _random.nextDouble() * 300;
    ySpeed =  - (50.0)
        - _random.nextDouble() * 400;

    if (cosA > 0) {
      paint.color = frontColor;
    } else {
      paint.color = backColor;
    }

    final path = Path()
      ..addPolygon(
        List.generate(
            4,
                (index) => Offset(
              position.x + corners[index].x * size,
              position.y + corners[index].y * size * cosA,
            )),
        true,
      );
    canvas.drawPath(path, paint);
  }

  void update(double dt) {

    time += dt;
    rotation += rotationSpeed * dt;
    cosA = cos(degToRad * rotation);
    position.x += time * xSpeed * dt;
    position.y += dt * ySpeed  ;

    if (position.y > _bounds.height) {
      // Move the snipping back to the top.
      position.x = _random.nextDouble() * _bounds.width;
      position.y = 0;
    }
  }

  void updateBounds(Size newBounds) {
    if (!newBounds.contains(Offset(position.x, position.y))) {
      position.x = _random.nextDouble() * newBounds.width;
      position.y = _random.nextDouble() * newBounds.height;
    }
    _bounds = newBounds;
  }
}


class _FallingPaperSnipping {
  static final Random _random = Random();
  static const degToRad = pi / 180;
  static const backSideBlend = Color(0x70EEEEEE);

  Size _bounds;

  int group_direction;
  // late final _Vector position = _Vector(
  //   _random.nextDouble() * _bounds.width,
  //   _random.nextDouble() * _bounds.height,
  // );

  late _Vector position = _Vector((_bounds.width/2) + (_bounds.width * _random.nextDouble())
      , 0 );

  final double rotationSpeed = 800 + _random.nextDouble() * 600;
  final double angle = _random.nextDouble() * 360 * degToRad;

  double rotation = _random.nextDouble() * 360 * degToRad;
  double cosA = 1.0;
  final double size = 7.0;
  final double oscillationSpeed = 0.5 + _random.nextDouble() * 1.5;

  // final double xSpeed = 40 - _random.nextDouble() * 40;
  // final double ySpeed = 60 - _random.nextDouble() * 100;

  late List<_Vector> corners = List.generate(4, (i) {
    final angle = this.angle + degToRad * (45 + i * 90);
    return _Vector(cos(angle), sin(angle));
  });

  double time = _random.nextDouble();
  final Color frontColor;
  late final Color backColor = Color.alphaBlend(backSideBlend, frontColor);

  final paint = Paint()..style = PaintingStyle.fill;

  _FallingPaperSnipping({
    required this.frontColor,
    required Size bounds,
    this.group_direction: 0
  }) : _bounds = bounds;

  int xVmod = 1;
  int yVmod = 1;
  double xSpeed = 0;
  double ySpeed = 0;

  void draw(Canvas canvas) {

    // if(group_direction %2 == 0 )
    // {xVmod = -1;}
    xSpeed =  _random.nextDouble() * 100 - _random.nextDouble() * 200;
    ySpeed = _random.nextDouble() * 200;

    if (cosA > 0) {
      paint.color = frontColor;
    } else {
      paint.color = backColor;
    }

    final path = Path()
      ..addPolygon(
        List.generate(
            4,
                (index) => Offset(
              position.x + corners[index].x * size,
              position.y + corners[index].y * size * cosA,
            )),
        true,
      );
    canvas.drawPath(path, paint);
  }

  void update(double dt) {

    time += dt;
    rotation += rotationSpeed * dt;
    cosA = cos(degToRad * rotation);
    position.x += time * xSpeed * dt;
    position.y += dt * ySpeed  ;

    if (position.y > _bounds.height) {
      // Move the snipping back to the top.
      position.x = _random.nextDouble() * _bounds.width;
      position.y = 0;
    }
  }

  void updateBounds(Size newBounds) {
    if (!newBounds.contains(Offset(position.x, position.y))) {
      position.x = _random.nextDouble() * newBounds.width;
      position.y = _random.nextDouble() * newBounds.height;
    }
    _bounds = newBounds;
  }
}


class _Vector {
  double x, y;
  _Vector(this.x, this.y);
}