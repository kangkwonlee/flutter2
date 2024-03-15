import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferences 인스턴스를 어디서든 접근 가능하도록 전역 변수로 선언
//late : 나중에 꼭 값을 할당해준다는 의미.
late SharedPreferences prefs;

void main() async {
  //main()함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  //Shared_preferences 인스턴스 생성
  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SharedPreferences 에서 온보딩 완료 여부 조회
    //isOnboarded에 해당하는 값에서 null을 반환하는 경우 false를 기본값으로 지정
    bool isOnboarded = prefs.getBool('isOnboarded') ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isOnboarded ? HomePage() : TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: '현재의 나',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: 'assets/images/recent.png',
    ),
    Introduction(
      title: '수료 후의 나',
      subTitle: 'Your order will be immediately collected and',
      imageUrl: 'assets/images/recent1.png',
    ),
    Introduction(
      title: '10년 후의 나',
      subTitle: 'Pick up delivery at your door and enjoy groceries',
      imageUrl: 'assets/images/onboarding5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        //마지막페이지가 나오거나 skip을 해서 Homepage로 가기전에 isOnboarded를 true로 바꿔준다.
        prefs.setBool('isOnboarded', true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), //MaterialPageRoute
        );
      },
      // foregroundColor: Colors.red,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            prefs.clear();
          },
          icon: Icon(Icons.delete),
        )
      ]),
      body: Center(
        child: Text(
          'Welcome to Home Page!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
