import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/models/models.dart';
import 'package:flutter_test_task/models/user.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageFirst extends StatefulWidget {

  PageFirst();

  @override
  _PageFirstState createState() => _PageFirstState();
}

class _PageFirstState extends State<PageFirst> with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Tab> _tabList = _setTabs(count: 3, signInOutDialogPageNumber: 3);
  final controller = PageController(viewportFraction: 0.8);

  int _currentTab = 0;

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: _tabList.length);
    _tabController.addListener(_handleTabChange);
    super.initState();
  }

  void _handleTabChange(){
    if(_currentTab != _tabController.index){
      _currentTab = _tabController.index;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        key: _scaffoldKey,
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Container(
              color: Colors.white,
              child: Wrap(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-50,
                    child: TabBarView(
                      controller: _tabController,
                      children: _tabList.isEmpty
                          ? <Widget>[]
                          : _tabList.map((currentTab) {
                        if(currentTab.key.toString()=="[<'signPage'>]"){
                          return _signTab(Image.asset("assets/images/sign_in_out_image.png"), "Lorem ipsum Dolor Sit Amet Consectetur Adipisicing Elit", orientation);
                        } else {
                          switch (currentTab.text) {
                            case "0":
                              return _aboutTabs(Image.asset("assets/images/first_tab_image.png"), "Welcome to the Store", "Lorem ipsum Dolor Sit Amet Consectetur Adipisicing Elit", orientation);
                            case "1":
                              return _aboutTabs(Image.asset("assets/images/second_tab_image.jpg"), "Lorconsectetur adipisicing", "Lorem ipsum Dolor Sit Amet Consectetur Adipisicing Elit", orientation);
                            default:
                              return _aboutTabs(Image.asset("assets/images/first_tab_image.png"), "Welcome to the Store", "Lorem ipsum Dolor Sit Amet Consectetur Adipisicing Elit", orientation);
                          }
                        }
                      }).toList(),
                    ),
                  ),
                  _currentTab == 2
                      ? InkWell(
                         onTap: () {
                           RouteArgs _args = RouteArgs(
                             user: User(),
                           );
                           Navigator.pushReplacementNamed(context, "/shop", arguments: _args);
                         },
                         child: Container(
                           color: Colors.white,
                           alignment: Alignment.bottomRight,
                           padding: EdgeInsets.only(right: 20),
                           child: Text("Skip >",
                             style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 22,
                                 color: Colors.green
                             ),
                           ),
                         ),
                      )
                      : Container(height: 40),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 20,
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          child: AnimatedSmoothIndicator(
            count: _tabController.length,
            activeIndex: _currentTab,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey,
              activeDotColor: Colors.black,
            ),
            onDotClicked: (index) {
              _tabController.index = index;
            },
          ),
        ),
      ),
    );
  }

  Widget _aboutTabs(Image image, String headerText, String bodyText, Orientation orientation) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Container(
              height: orientation == Orientation.landscape ? 200 : 500,
              child: image,
            ),
            Text(headerText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Text(bodyText,
                style: TextStyle(
                  fontSize: 19,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signTab(Image image, String bodyText, Orientation orientation){
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Container(
              height: orientation == Orientation.landscape ? 200 : 500,
              child: image,
            ),
           Container(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 InkWell(
                   onTap: () {
                     RouteArgs _args = RouteArgs(pageName: "Sign In");
                     Navigator.pushNamed(context, "/login", arguments: _args);
                   },
                   child: Text("Sign In",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 25,
                       color: Colors.green
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.symmetric(horizontal: 20),
                   child: Container(
                       height: 20,
                       child: VerticalDivider(
                         color: Colors.grey,
                         thickness: 2,
                       )
                   ),
                 ),
                 InkWell(
                   onTap: () {
                     RouteArgs _args = RouteArgs(pageName: "Sign Up");
                     Navigator.pushNamed(context, "/login", arguments: _args);
                   },
                   child: Text("Sign Up",
                     style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 25,
                         color: Colors.green
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
               ],
             ),
           ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Text(bodyText,
                style: TextStyle(
                  fontSize: 19,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }



  static List<Tab> _setTabs({@required int count, @required int signInOutDialogPageNumber}){
    List<Tab> toReturn = [];
    for (int i = 0; i < count; i++){
      toReturn.add(Tab(text: "$i", key: Key(signInOutDialogPageNumber-1 == i ? "signPage" : ""),));
    }
    return toReturn.toList();
  }

}
