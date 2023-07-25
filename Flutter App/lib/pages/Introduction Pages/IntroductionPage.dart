import 'package:camera/camera.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:driver_behaviour_gp/main.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:flutter/material.dart';

class IntroductioPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const IntroductioPage({super.key, required this.cameras});

  @override
  State<IntroductioPage> createState() => _IntroductioPageState();
}

class _IntroductioPageState extends State<IntroductioPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<String> _imagePaths = [
    'lib/Images/safeDriving.png',
    'lib/Images/distracted.PNG',
    'lib/Images/seatbelt.PNG',
    'lib/Images/drowsy.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          appBarLogo()
        ],
      ),
      body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _imagePaths.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: getWidth(context, 1),
                        height: 400,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _imagePaths[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      DotsIndicator(
                        dotsCount: _imagePaths.length,
                        position: _currentIndex,
                        decorator: DotsDecorator(
                          color: Colors.grey,
                          activeColor: Color(0xff5ac181),
                          size: Size.square(10),
                          activeSize: Size(12, 12),
                        ),
                      ),
                      SizedBox(height: 30),
                      getText(index, context)
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(cameras: cameras!)));
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 22, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 100),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    backgroundColor: Color(0xff5ac18e),
                  ),
                  onPressed: () {
                    if (_currentIndex < _imagePaths.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else if (_currentIndex == _imagePaths.length - 1) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(cameras: cameras!)));
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),

    );
  }
}


