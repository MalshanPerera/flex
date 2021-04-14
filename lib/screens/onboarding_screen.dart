import 'package:dots_indicator/dots_indicator.dart';
import 'package:flex/bloc/onboarding_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  OnBoardingBloc _onBoardingBloc;
  PageController _pageController = PageController(initialPage: 0);

  List<Map<String, String>> detailsList = [
    {
      'imagePath': 'assets/images/logo.png',
      'description':
      'Welcome to Flex Fitness Application\nThis application is adapted to the user type you got from the test previously.',
    },
    {
      'imagePath': 'assets/images/logo.png',
      'description':
      'It has 3 Categories. Full Body Workout, Arms Workout & Abs Workout.\nPoints will be added when you complete a workout and it will determine your place in the leaderboard.',
    },
    {
      'imagePath': 'assets/images/logo.png',
      'description':
      'Other Gamification elements(Level, Progress, Achievements & Badges) will various according to the selected user type.',
    },
    {
      'imagePath': 'assets/images/logo.png',
      'description':
      'Enjoy!!\nWelcome to Flex',
    },
  ];

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _onBoardingBloc = Provider.of<OnBoardingBloc>(context);
      _isLoaded = true;
    }

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: PRIMARY_COLOR,
          body: Padding(
            padding: EdgeInsets.only(top: Utils.getDesignHeight(100)),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: detailsList.length,
                    itemBuilder: (context, index) {
                      return _view(
                        imagePath: detailsList[index]['imagePath'],
                        description: detailsList[index]['description'],
                      );
                    },
                    onPageChanged: (index){
                      _onBoardingBloc.pageViewSink.add(index);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Utils.getDesignHeight(64)),
                  child: StreamBuilder(
                    stream: _onBoardingBloc.pageViewStream,
                    initialData: 0,
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      return DotsIndicator(
                        dotsCount: 4,
                        decorator: DotsDecorator(
                          color: Colors.deepPurpleAccent,
                          activeColor: Colors.white,
                        ),
                        position: snapshot.data.toDouble(),
                      );
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Utils.getDesignHeight(30), bottom: Utils.getDesignHeight(61)),
                  child: StreamBuilder(
                    stream: _onBoardingBloc.pageViewStream,
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      return _getStartedButton(
                        position: snapshot.data ?? 0,
                        onTap: snapshot.data != 3 ? () {} : () {
                          _onBoardingBloc.navigateToHomeScreen();
                        },
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _view({String imagePath, String description}) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: Utils.getDesignWidth(268),
          height: Utils.getDesignHeight(342),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Utils.getDesignWidth(42)),
          child: Text(
            description,
            style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
              fontSize: 15.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _getStartedButton({int position, VoidCallback onTap}){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          Utils.getDesignWidth(31),
          Utils.getDesignHeight(10),
          Utils.getDesignWidth(31),
          Utils.getDesignHeight(10),
        ),
        decoration: BoxDecoration(
            color: position != 3 ? Colors.grey : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0),),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: Offset(0.0, 3.0),
              )
            ]
        ),
        child: Text(
          "GET STARTED",
          style: Theme.of(context).primaryTextTheme.button.copyWith(
            color: PRIMARY_COLOR
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
