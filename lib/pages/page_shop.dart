import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/database/shop_item_dao.dart';
import 'package:flutter_test_task/models/color_model.dart';
import 'package:flutter_test_task/models/models.dart';
import 'package:flutter_test_task/models/shop_item.dart';
import 'package:flutter_test_task/models/size_model.dart';
import 'package:flutter_test_task/models/user.dart';
import 'package:flutter_test_task/widget/widget_notification_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PageShop extends StatefulWidget {

  final User user;

  PageShop({
    @required this.user,
  });

  @override
  _PageShopState createState() => _PageShopState();

}

class _PageShopState extends State<PageShop> {

  List<int> _orderList = [];

  final GlobalKey<State> _bottomStateBuilderKey = GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initStateAsync());
    super.initState();
  }

  initStateAsync() async {
    await ShopItem.sync();
    ColorModel.sync();
    SizeModel.sync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text("Dresses",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              ColorModel.sync();
            },
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                color: Colors.white
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.touch_app, color: Colors.grey, size: orientation == Orientation.portrait ? 20 : 30,),
                    Text("Tap & hold the product to add to cart", style: TextStyle(color: Colors.grey, fontSize: orientation == Orientation.portrait ? 10 : 20),),
                    Text("SORT BY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: orientation == Orientation.portrait ? 11.5 : 21.5),),
                    InkWell(child: Icon(Icons.height, color: Colors.grey, size: orientation == Orientation.portrait ? 20 : 30,),),
                  ],
                ),
                Divider(thickness: 0.5, color: Colors.grey,),
                FutureBuilder(
                  future: ShopItemDAO().getAll(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.done:
                        if(!snapshot.hasData && snapshot.data.length != 0){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<ShopItem> _shopItemsList = snapshot.data;
                        return Expanded(
                          child: GridView.count(
                            padding: EdgeInsets.all(5),
                            mainAxisSpacing: 6,
                            childAspectRatio: orientation == Orientation.portrait ? 0.5 : 1,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            children: List.generate(_shopItemsList.length, (index) {
                              ShopItem _shopItem = _shopItemsList.elementAt(index);
                              Duration _difference;
                              if (_shopItem.isSale && _shopItem.saleDate!=null){
                                _difference = _shopItem.saleDate.difference(DateTime.now());
                              }
                              return GestureDetector(
                                onTap: () {
                                  RouteArgs _args = RouteArgs(shopItem: _shopItem);
                                  Navigator.pushNamed(context, "/shop_item/info", arguments: _args);
                                },
                                onLongPress: () { //Add to cart
                                  _bottomStateBuilderKey.currentState.setState(() {
                                    _orderList.add(_shopItem.id);
                                  });
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Wrap(
                                        children: [
                                          Text(_shopItem.name, style: TextStyle(color: Colors.green),),
                                          Text(" added to cart.")
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        overflow: Overflow.clip,
                                        children: [
                                          Container(
                                            height: 250,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(_shopItem.image),
                                                fit: BoxFit.fitWidth,
                                              ),
                                              shape: BoxShape.rectangle,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: Icon(_shopItem.isFavorite ? Icons.favorite : Icons.favorite_border),
                                              onPressed: () {
                                                setState(() {
                                                  _shopItem.isFavorite = !_shopItem.isFavorite;
                                                });
                                                ShopItemDAO().setFavorite(_shopItem.id, _shopItem.isFavorite);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(_shopItem.name, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                      Row(
                                        children: [
                                          _shopItem.isSale
                                              ? Text("\$ ${_shopItem.saleAmount.toStringAsFixed(2)}",
                                            style: TextStyle(fontSize: 20),)
                                              : Text("\$ ${_shopItem.amount.toStringAsFixed(2)}",
                                            style: TextStyle(fontSize: 20),),
                                          _shopItem.isSale
                                              ? Container(
                                            padding: EdgeInsets.only(left: 10, top: 5),
                                            child: Text.rich(
                                              TextSpan(
                                                text: "\$ ${_shopItem.amount.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration.lineThrough,),
                                              ),
                                            ),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SmoothStarRating(
                                            allowHalfRating: false,
                                            starCount: 5,
                                            rating: _shopItem.ratio.toDouble(),
                                            size: 15,
                                            isReadOnly:true,
                                            color: Colors.green,
                                            borderColor: Colors.green,
                                          ),
                                          Text("(${_shopItem.ratioCount})", style: TextStyle(fontSize: 15),),
                                        ],
                                      ),
                                      _shopItem.isSale
                                          ? Text("Remain: ${_difference.inDays} days ${(_difference.inHours % 24).toStringAsFixed(0)}h:${(_difference.inMinutes % 60 + 1).toStringAsFixed(0)}m",
                                        style: TextStyle(fontSize: 12, color: Colors.red),)
                                          : Container(),
                                    ],
                                  );
                                }),
                              );
                            }),
                          ),
                        );
                      default:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: StatefulBuilder(
        key: _bottomStateBuilderKey,
        builder: (BuildContext context, StateSetter setState) {
          return BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            onTap: (tab){
              if(tab==2){ //Open cart list with selected items P.S. or we can use switch/case
                // RouteArgs _args = RouteArgs(
                //   orderList: _orderList,
                // );
                // Navigator.pushNamed(context, "/order", arguments: _args);
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.list),
                label: "Category",
              ),
              BottomNavigationBarItem(
                // icon: Icon(FontAwesomeIcons.shoppingBag),
                icon: IconWithNotification(
                  iconData: FontAwesomeIcons.shoppingBag,
                  notificationCount: _orderList.length,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                label: "User",
              ),
            ],
            showSelectedLabels: false,
            showUnselectedLabels: false,
          );
        },
      ),
    );
  }

}