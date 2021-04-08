import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _categoryList = [
    {
      'image': ARMS_WORKOUT,
      'title': 'Arms Workout',
    },
    {
      'image': ABS_WORKOUT,
      'title': 'Abs Workout',
    },
    {
      'image': FULL_BODY_WORKOUT,
      'title': 'Full Body Workout',
    },
  ];

  HomeScreenBloc _homeScreenBloc;
  LoadingBloc _loadingBloc;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _homeScreenBloc = Provider.of<HomeScreenBloc>(context);
      _loadingBloc = Provider.of<LoadingBloc>(context);
      _homeScreenBloc.getUserData();
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: BACKGROUND_COLOR,
          child: SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: BACKGROUND_COLOR,
              drawer: Drawer(),
              body: Padding(
                padding: EdgeInsets.only(left: Utils.getDesignWidth(26), top: Utils.getDesignHeight(20.0), right: Utils.getDesignWidth(26)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(10.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: StreamBuilder(
                              stream: _homeScreenBloc.userNameStream,
                              builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                                return Text(
                                  snapshot.hasData ? "Hello ${snapshot.data.name}" : "Hello Minh Q.N",
                                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35.0,
                                  ),
                                  overflow: TextOverflow.fade,
                                );
                              }
                            ),
                          ),
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                            NetworkImage("https://images.squarespace-cdn.com/content/54b7b93ce4b0a3e130d5d232/1519987165674-QZAGZHQWHWV8OXFW6KRT/icon.png?content-type=image%2Fpng"),
                            backgroundColor: PRIMARY_COLOR,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _greeting(),
                      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Utils.getDesignHeight(40.0),),
                      height: Utils.getDesignHeight(150),
                      width: double.infinity,
                      color: Colors.deepPurpleAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(40.0)),
                      child: Text(
                        "Categories",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _categoryList.length,
                        itemBuilder: (BuildContext context, index){
                          return _categoriesListTile(
                            image: _categoryList[index]['image'],
                            title: _categoryList[index]['title'],
                          );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LoadingBarrier(_loadingBloc.isLoading),
      ],
    );
  }

  Widget _categoriesListTile({String image, String title}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: SHADOW_COLOR,
            offset: Offset(0, 0),
            blurRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: ListTile(
          tileColor: Colors.white,
          contentPadding: EdgeInsets.only(
            left: Utils.getDesignWidth(10.0),
            top: Utils.getDesignHeight(5.0),
            right: Utils.getDesignWidth(10.0),
            bottom: Utils.getDesignHeight(5.0),
          ),
          leading: SvgPicture.asset(
            image,
            height: Utils.getDesignHeight(45),
            width: Utils.getDesignWidth(45),
          ),
          title: Text(title),
          trailing: Icon(Icons.chevron_right_rounded, color: PRIMARY_COLOR,),
        ),
      ),
    );
  }

  String _greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}
