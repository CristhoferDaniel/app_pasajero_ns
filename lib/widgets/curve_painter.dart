part of 'widgets.dart';

// Relación de aspecto 4:1
class CurvePainter extends CustomPainter {
  Color color;

  CurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width / 2,
      size.height * 0.30,
    );
    path.quadraticBezierTo(
      size.width * 0.15,
      -size.height * 0.25,
      0,
      size.height,
    );
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter2 extends CustomPainter {
  Color color;

  CurvePainter2({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width / 2,
      size.height * 0.30,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      -size.height * 0.15,
      0,
      size.height * 0.3,
    );
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter3 extends CustomPainter {
  Color color;

  CurvePainter3({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 1.35,
      size.width * 0.2,
      size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.47,
      size.width * 0.0,
      size.height * 0.5,
    );
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter4 extends CustomPainter {
  Color color;

  CurvePainter4({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width / 2,
      size.height * 0.30,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      -size.height * 0.15,
      0,
      size.height * 0.5,
    );
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MiscCurvePainter extends CustomPainter {
  Color color;

  MiscCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;

    var path = Path();
    path.moveTo(0, height);
    path.quadraticBezierTo(
      width * 0.5,
      -(height * 0.8),
      width,
      height,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class BigHeaderCurvePainter extends CustomPainter {
  Color color;

  BigHeaderCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height * 0.89);
    path.quadraticBezierTo(
      width * 0.63,
      height * 1.05,
      0,
      height * 0.97,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}