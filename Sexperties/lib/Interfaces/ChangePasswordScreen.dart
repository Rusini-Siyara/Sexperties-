import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(screenWidth,
                          (screenWidth * 0.6666666666666666).toDouble()),
                      painter: CustomShape(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 250,
                      width: 250,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ' \nNew \nPassword',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: screenWidth - 30,
                      height: 55,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Color.fromARGB(255, 0, 74, 173),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 74, 173),
                              width: 2.0,
                            ),
                          ),
                          labelText: 'New Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: screenWidth - 30,
                      height: 55,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Color.fromARGB(255, 0, 74, 173),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 74, 173),
                              width: 2.0,
                            ),
                          ),
                          labelText: 'Re Type Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 55,
                        width: screenWidth - 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 35, 60, 135),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4.0),
                              blurRadius: 4.0,
                              color: Color.fromARGB(63, 0, 0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a gradient
    final gradient = LinearGradient(
      colors: [
        const Color.fromARGB(255, 76, 126, 255),
        const Color.fromARGB(255, 26, 86, 199),
      ],
      stops: [0.0, 1.0], // Adjust the stops as needed
    );

    // Create a shader from the gradient
    final shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Layer 1

    Paint paint_fill_0 = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1744444, size.height * -0.0005667);
    path_0.quadraticBezierTo(size.width * -0.0058444, size.height * -0.0016667,
        size.width * 0.0000222, size.height * 0.2400000);
    path_0.lineTo(0, size.height);
    path_0.quadraticBezierTo(size.width * 0.5732667, size.height * 0.9394667,
        size.width * 0.6428889, size.height * 0.7088000);
    path_0.quadraticBezierTo(size.width * 0.7088222, size.height * 0.4145000,
        size.width * 0.6262889, size.height * -0.0010667);
    path_0.quadraticBezierTo(size.width * 0.5133333, size.height * -0.0022000,
        size.width * 0.1744444, size.height * -0.0005667);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
