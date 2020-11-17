import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/models/shop_item.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PageShopItemInfo extends StatefulWidget {

  final ShopItem shopItem;

  PageShopItemInfo({
    this.shopItem
  });

  @override
  _PageShopItemInfoState createState() => _PageShopItemInfoState();

}

class _PageShopItemInfoState extends State<PageShopItemInfo> {

  ShopItem _shopItem;
  List<String> _listSize = ["small", "medium", "large"];
  List<String> _listColor = ["Light Grey", "Black", "White", "Yellow", "Red"];
  List<int> _listCartCount = _setArray(count: 8);
  String _selectedSize, _selectedColor;
  int _selectedCount;

  @override
  void initState() {
    super.initState();
    _shopItem = widget.shopItem;
    _selectedSize = _listSize.elementAt(0);
    _selectedColor = _listColor.elementAt(0);
    _selectedCount = _listCartCount.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              overflow: Overflow.clip,
              children: [
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_shopItem.image),
                      fit: BoxFit.fitWidth,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.2),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Size", style: TextStyle(fontWeight: FontWeight.bold),),
                        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                          return DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _selectedSize,
                                items: _listSize
                                    .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                                    .toList(),
                                onChanged: (value) {
                                  _selectedSize = value;
                                  setState(() {});
                                },
                              ));
                        }),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.2),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Color", style: TextStyle(fontWeight: FontWeight.bold),),
                        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                          return Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                width: 20,
                                height: 20,
                                color: _setColor(_selectedColor),
                              ),
                              DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: _selectedColor,
                                    items: _listColor
                                        .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                                        .toList(),
                                    onChanged: (value) {
                                      _selectedColor = value;
                                      setState(() {});
                                    },
                                  )
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width/1.4,
                        height: 48,
                        child: RaisedButton(
                          child: Text("ADD TO CART", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          color: Colors.green,
                          onPressed: (){},
                        ),
                      ),
                      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.2),
                            color: Colors.grey[200],
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                                value: _selectedCount,
                                items: _listCartCount
                                    .map((count) => DropdownMenuItem(value: count, child: Text("$count")))
                                    .toList(),
                                onChanged: (value) {
                                  _selectedCount = value;
                                  setState(() {});
                                },
                              )
                          ),
                        );
                      }),
                    ],
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text("Description"),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(_shopItem.description),
                            Container(
                              margin: EdgeInsets.only(top: 30, bottom: 10),
                              child: Row(
                                children: [
                                  Text("Product Code: "),
                                  Text(_shopItem.productCode, style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text("Category "),
                                  InkWell(
                                    onTap: () { //Route to selected category
                                      // RouteArgs _args = RouteArgs(
                                      //   category: _shopItem.category,
                                      // );
                                      // Navigator.pushNamed(context, "/category", arguments: _args);
                                    },
                                    child: Text(_shopItem.category, style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.green),),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text("Material "),
                                  Text(_shopItem.material, style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text("County "),
                                  Text(_shopItem.country, style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static List<int> _setArray({@required int count}){
    List<int> _toReturn = [];
    for (int i = 1; i <= count; i++){
      _toReturn.add(i);
    }
    return _toReturn;
  }

  Color _setColor(String colorName){
    switch (colorName){
      case "Light Grey":
        return Colors.grey;
      case "Black":
        return Colors.black;
      case "White":
        return Colors.white;
      case "Yellow":
        return Colors.yellow;
      case "Red":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}