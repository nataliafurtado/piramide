
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawTronco extends CustomPainter {
  Paint _paint;
  int multi;
  int total;

  DrawTronco(this.multi, this.total) {
    _paint = Paint()
      // ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill;
  }

  int _multiplicador(int mu) {
    return 2 + mu * 2;
  }

  Color escolherCoresPiramide() {
    if (total == 3) {
      return _cor3(multi);
    } else if (total == 4) {
      return _cor45(multi);
    } else if (total == 5) {
      return _cor45(multi);
    }
    return _cor3(multi);
  }

  Color _cor45(int i) {
    if (i == 0) {
      return Colors.redAccent.shade200;
    } else if (i == 1) {
      return Colors.orangeAccent;
    } else if (i == 2) {
      return Colors.yellowAccent.shade700;
    } else if (i == 3) {
      return Colors.blueAccent.shade100;
    }
    return Colors.blue.shade400;
  }

  Color _cor3(int i) {
    if (i == 0) {
      return Colors.redAccent.shade200;
    } else if (i == 1) {
      return Colors.orangeAccent;
    } else if (i == 2) {
      return Colors.yellowAccent.shade700;
    }
    return Colors.blue.shade400;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int m = _multiplicador(multi);
    _paint.color = escolherCoresPiramide();
    var path = Path();
    path.moveTo(size.width / m, 0);
    path.lineTo((size.width * (m - 1)) / m, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    //path.lineTo(0 , );
    //path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


class DrawTronco2 extends CustomPainter {
  Paint _paint;
  int multi;

  DrawTronco2(this.multi) {
    _paint = Paint()
      // ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill;
  }

  int _multiplicador(int mu) {
    return 2 + mu * 2;
  }

  Color _cor(int i) {
    if (i == 0) {
      return Colors.redAccent.shade200;
    } else if (i == 1) {
      return Colors.orangeAccent;
    } else if (i == 2) {
      return Colors.yellowAccent.shade700;
    } else if (i == 3) {
      return Colors.blueAccent.shade100;
    }
    return Colors.blue.shade400;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int m = _multiplicador(multi);
    _paint.color = _cor(multi);
    var path = Path();
    path.moveTo(size.width / m, 0);
    path.lineTo((size.width * (m - 1)) / m, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    //path.lineTo(0 , );
    //path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
