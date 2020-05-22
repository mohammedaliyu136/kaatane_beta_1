import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List<Widget> tabBarList;
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
    var bloc = Provider.of<CartBloc>(context);
    bloc.restaurant = restaurantDocument.documentID;
    bloc.restaurantDocument = restaurantDocument;

    int totalCount = 0;
    if (bloc.cart.length > 0) {
      //totalCount = bloc.cart.values.reduce((a, b) => a + b);
      totalCount = bloc.cart.length;
    }
    List<Widget> taViewList = [];
    return new WillPopScope(
      onWillPop: (){
        showAlertDialog(context);
      },
      child: MaterialApp(
        title: restaurantDocument['name'],
        theme: ThemeData(
          //primarySwatch: Colors.red,
          primaryColor: Color.fromRGBO(128, 0, 128, 1),
        ),
        home: Scaffold(
          appBar: AppBar(
              title: Text(restaurantDocument['name']),
              leading: IconButton(
                  icon: BackButtonIcon(),
                  onPressed: () {
                    showAlertDialog(context);
                    //Navigator.pop(context);
                  }),
            elevation: 0,
            actions: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Container(
                    height: 150.0,
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
                              color: Colors.white,
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
              ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: DefaultTabController(
                  length: tabBarList.length,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverAppBar(
                          bottom: TabBar(
                            isScrollable: true,
                            indicatorColor: Color.fromRGBO(128, 0, 128, 1),
                            tabs: tabBarList,
                          ),
                          expandedHeight: 220.0,
                          floating: true,
                          pinned: true,
                          snap: true,
                          elevation: 50,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            background: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black, Colors.white],
                                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.softLight,
                              child: Image.network(bloc.restaurantDocument['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.collection('meal').where('restaurant_id', isEqualTo:restaurantDocument.documentID).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              print("***************");
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting: return new Text('Loading...');
                                default:
                                  List<Widget> list0 = [];
                                  for(var i=0; i<ctegory_list.length; i++){
                                    String cat_id = ctegory_list[i].documentID;
                                    List<Widget> list = [];
                                    //print(snapshot.data.documents[i]['title']);
                                    for(var i=0; i<snapshot.data.documents.length; i++){
                                      if(snapshot.data.documents[i]['category_id']==cat_id){
                                        var document =snapshot.data.documents[i];
                                        //list.add(Text(snapshot.data.documents[i]['title']));
                                        list.add(
                                            new Card(
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
                                                          image: NetworkImage(document['img_url']),
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
                                                        Text(document['title'],
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
                                                            Text(" ₦"+document['normal_price'].toString(), style: document['discount']?TextStyle(decoration: TextDecoration.lineThrough, ):TextStyle()),
                                                            document['discount']?Text(" ₦"+document['discount_price'].toString(), style: TextStyle(color: Colors.green)):Container(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Add_To_Cart_btn(document, bloc)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        );
                                      }
                                    }
                                    if(list.length==0){
                                      list0.add(Center(child: Text("No menu to show")));
                                    }else{
                                      list0.add(
                                          ListView(
                                              shrinkWrap: true,
                                              children: list
                                          )
                                      );
                                    }

                                  }
                                  print("=================");
                                  print("=================");
                                  print("=================");
                                  print(list0.length);
                                  return snapshot.data.documents.length!=0?
                                  TabBarView(
                                    children: list0//taViewList
                                  ):new Text("There is no menu to show");

                              }
                            },
                          ),
                        ),

                      ],
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
