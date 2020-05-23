import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../bloc/cart_bloc.dart';
import '../model/meal.dart';
import '../model/restaurant.dart';
import '../utils/rest_api.dart';
import 'cart_page.dart';
import 'widgets/add_to_cart_btn.dart';
import 'widgets/meal_list_item.dart';
//import 'package:firebase_admob/firebase_admob.dart';


const String testDevice = '8385408453538732DCC4398BB3BF7936';
class MealPage extends StatefulWidget {
  MealPage(this.restaurantDocument, this.ctegory_list, this.tabBarList);
  final DocumentSnapshot restaurantDocument;
  List<DocumentSnapshot> ctegory_list;
  List<Widget> tabBarList;
  @override
  _MealPageState createState() => _MealPageState(restaurantDocument, ctegory_list, tabBarList);
}

class _MealPageState extends State<MealPage> {
  _MealPageState(this.restaurantDocument, this.ctegory_list, this.tabBarList);
  final DocumentSnapshot restaurantDocument;
  List<DocumentSnapshot> ctegory_list;
  List<DocumentSnapshot> meal_list;
  List<Widget> tabBarList;
  BuildContext mContext;
  Color currentColor;

  bool isLoading = true;

  Color titleColor;
  var bloc;

  ScrollController _scrollController;

  bool lastStatus = true;
  /**
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: ["8385408453538732DCC4398BB3BF7936"],
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-2940956011124308/6747288598",
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }
  **/
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Provider.of<CartBloc>(context).clearAll();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you'd like to change vendors?"),
      content: Text("Your current order will be lost"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertColorDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        setState(() {
          currentColor = titleColor;
        });
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {
        String doc_id = restaurantDocument.documentID;
        Firestore.instance.document('Restaurant/$doc_id')
            .updateData({ 'color': currentColor.value});
        Firestore.instance.collection('Restaurant')
            .where('user_id', isEqualTo: restaurantDocument['user_id'])
            .getDocuments()
            .then((value){
          bloc.restaurantDocument =value.documents[0];
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you'd like to change color?"),
      //content: Text("Your current order will be lost"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showColorDialog(BuildContext context) {

    //imageFile!=null?print(imageFile.path.toString()):print("is null");

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Reset"),
      onPressed:  () {
        setState(() {
          print(Colors.white.value==currentColor.value);
          currentColor = Colors.white;
        });
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Done"),
      onPressed:  () {
        Navigator.of(context).pop();
        //FirebaseStorage.instance.getReferenceFromUrl(document['img_url']).then((value) => value.delete().then((value){
        //}));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Pick a color"),
      content: BlockPicker(
        pickerColor: Color.fromRGBO(128, 0, 128, 1),
        onColorChanged: (change){
          setState(() {

            print(change);
            print(change.value);
            print(change.value.toString());
            print(Color(change.value));
            print(Color(int.parse(change.value.toString())));
            currentColor = change;
          });},
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    setState(() {
      if(restaurantDocument['color']!=null){
        titleColor = Color(restaurantDocument['color']);
        currentColor = Color(restaurantDocument['color']);
      }else{
        titleColor = Colors.white;
        currentColor = Colors.white;
      }
    });

    Firestore.instance.collection('meal').where('restaurant_id', isEqualTo: restaurantDocument.documentID).getDocuments()
        .then((meals){
      setState(() {
        print("***************");
        print("***************");
        isLoading = false;
        print(meals.documents.length);
        meal_list=meals.documents;

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    /**
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-2940956011124308~1055978210");
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show(anchorOffset: 55.0,anchorType: AnchorType.bottom,);


    print(_bannerAd);
        **/

    /**
    final title = restaurant.name;
    Future<List<Meal>> meal = fetchMeals(restaurant.id);
    **/
    bloc = Provider.of<CartBloc>(context);
    bloc.restaurant = restaurantDocument.documentID;
    bloc.restaurantDocument = restaurantDocument;

    mContext = context;

    int totalCount = 0;
    if (bloc.cart.length > 0) {
      //totalCount = bloc.cart.values.reduce((a, b) => a + b);
      totalCount = bloc.cart.length;
    }
    List<Widget> taViewList = [];

    return new WillPopScope(
      onWillPop: (){
        if(bloc.isLoggedIn){
          if(titleColor.value!=currentColor.value){
            showAlertColorDialog(mContext);
          }else{
            Navigator.of(mContext).pop();
          }
        }else{
          showAlertDialog(mContext);
        }
      },
      child: MaterialApp(
        title: restaurantDocument['name'],
        theme: ThemeData(
          //primarySwatch: Colors.red,
          primaryColor: Color.fromRGBO(128, 0, 128, 1),
        ),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: DefaultTabController(
                  length: tabBarList.length,
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 200.0,
                          floating: false,
                          pinned: true,
                          leading: IconButton(
                              icon: BackButtonIcon(),
                              color: isShrink ? Colors.white : currentColor,
                              onPressed: () {
                                //showAlertDialog(mContext);
                                if(bloc.isLoggedIn){
                                  if(titleColor.value!=currentColor.value){
                                    showAlertColorDialog(mContext);
                                  }else{
                                    Navigator.of(mContext).pop();
                                  }
                                }else{
                                  showAlertDialog(mContext);
                                }
                                //Navigator.pop(context);
                              }),
                          actions: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Container(
                                  height: 200.0,
                                  width: 30.0,
                                  child: new GestureDetector(
                                    onTap: () {
                                      //_bannerAd.dispose();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartPage(),
                                        ),
                                      );
                                    },
                                    child: new Stack(
                                      children: <Widget>[
                                        new IconButton(
                                          icon: new Icon(
                                            Icons.shopping_cart,
                                            color: currentColor != null?(isShrink ?  Colors.white : currentColor):Colors.white,
                                          ),
                                          onPressed: null,
                                        ),
                                        new Positioned(
                                            child: new Stack(
                                              children: <Widget>[
                                                new Icon(Icons.brightness_1,
                                                    size: 20.0, color: Colors.white),
                                                new Positioned(
                                                    top: totalCount>9 ? 6.0 : 3.0,
                                                    right: totalCount>9 ? 10.0 : 6.0,
                                                    child: new Center(
                                                      child: new Text(
                                                        '$totalCount',//(totalCount+8).toString()+'',
                                                        style: new TextStyle(
                                                            color:  Color.fromRGBO(128, 0, 128, 1),
                                                            fontSize: totalCount>9 ? 10.0 : 12.0,//12.0,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: GestureDetector(
                                onTap: (){
                                  if(bloc.isLoggedIn){
                                    print("0000000000000000000");
                                    print("0000000000000000000");
                                    print("0000000000000000000");
                                    print("change title");
                                    showColorDialog(mContext);
                                  }
                                },
                                child: Text(restaurantDocument['name'],
                                    style: TextStyle(
                                      color: isShrink ? Colors.white : currentColor,
                                    )),
                              ),
                              background: Image.network(restaurantDocument['image'],
                                fit: BoxFit.cover,
                              )),

                        ),
                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              isScrollable: true,
                              labelColor: Color.fromRGBO(128, 0, 128, 1),
                              indicatorColor: Color.fromRGBO(128, 0, 128, 1),
                              unselectedLabelColor: Colors.grey,
                              tabs: tabBarList,
                            ),
                          ),
                          pinned: true,
                        )
                      ];
                    },
                    body: !isLoading?Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.max,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(

                          child: TabBarView(
                            children: ctegory_list.map((DocumentSnapshot cat_document){
                              if(meal_list!=null){
                                print("0000000");
                                print("0000000");
                                print(cat_document.documentID);
                                return ListView.builder(
                                    padding: EdgeInsets.zero,
                                  itemCount: meal_list.length,
                                  itemBuilder: (context, index){
                                    if(cat_document.documentID==meal_list[index]['category_id']){//meal_list[index]
                                      return Card(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8,),
                                              child: Container(
                                                height: 110,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(meal_list[index]['img_url']),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(meal_list[index]['title'],
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Price:"),
                                                      Text(" ₦"+meal_list[index]['normal_price'].toString(), style: meal_list[index]['discount']?TextStyle(decoration: TextDecoration.lineThrough, ):TextStyle()),
                                                      meal_list[index]['discount']?Text(" ₦"+meal_list[index]['discount_price'].toString(), style: TextStyle(color: Colors.green)):Container(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  Add_To_Cart_btn(meal_list[index], bloc)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }else{
                                      return Container();
                                    }

                                  }
                                );
                              }
                              //Container();
                            }).toList(),
                          ),
                        ),

                      ],
                    ):Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),),
                          SizedBox(height: 20,),
                          Text(Provider.of<CartBloc>(context).message, style: TextStyle(fontSize: 20,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.black, Color.fromRGBO(128, 0, 128, 1)]),
                  //borderRadius: BorderRadius.all(Radius.circular(80.0)),
                ),
                //color: Color.fromRGBO(128, 0, 128, 1),
                height: 50, child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:8.0, bottom:8.0, left: 16, right: 8.0),
                    child: Text("$totalCount items", style: TextStyle(color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 8.0),
                    child: SizedBox(width: 2, child:Container(color: Colors.white,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0, bottom:8.0, left: 8.0, right: 8.0),
                    child: Text("₦${bloc.total}", style: TextStyle(color: Colors.white),),
                  ),
                  Spacer(),
                  SizedBox(width: 2, child:Container(color: Colors.white,),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.shopping_cart, color: Colors.white,),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("VIEW CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                    ),
                  ),
                  SizedBox(width: 10,)
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.center,
      child: new Container(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
