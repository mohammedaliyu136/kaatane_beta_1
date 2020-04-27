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

class MealPage extends StatelessWidget {
  MealPage(this.restaurant);
  final Restaurant restaurant;
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
    final title = restaurant.name;
    Future<List<Meal>> meal = fetchMeals(restaurant.id);
    var bloc = Provider.of<CartBloc>(context);
    bloc.restaurant = restaurant.id;
    int totalCount = 0;
    if (bloc.cart.length > 0) {
      //totalCount = bloc.cart.values.reduce((a, b) => a + b);
      totalCount = bloc.cart.length;
    }
    return MaterialApp(
      title: title,
      theme: ThemeData(
        //primarySwatch: Colors.red,
        primaryColor: Color.fromRGBO(128, 0, 128, 1),
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
                icon: BackButtonIcon(),
                onPressed: () {
                  Navigator.pop(context);
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
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  bottom: TabBar(
                    indicatorColor: Color.fromRGBO(128, 0, 128, 1),
                    tabs: [
                      Tab(text: "Meals"),
                      Tab(text: "Snacks"),
                      Tab(text: "Drinks"),
                    ],
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
                      child: Image.network(
                        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
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
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<List<Meal>>(
                          future: meal,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, index) {
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
                                                  image: NetworkImage(snapshot.data[index].img_url),
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
                                                Text(snapshot.data[index].name,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                                SizedBox(
                                                  height: 4.0,
                                                ),
                                                Text(
                                                    "Price: ₦${snapshot.data[index].price.toString()}"),
                                                SizedBox(
                                                  height: 4.0,
                                                ),
                                                Add_To_Cart_btn(snapshot.data[index])
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );}
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text("Failed to load, please check your internet connect"));//Text("${snapshot.error}");
                            }

                            // By default, show a loading spinner.
                            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(128, 0, 128, 1)),));
                          },
                        ),
                      ),
                      Center(child: Text("Snacks"),),
                      Center(child: Text("Drinks"),),
                    ],
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
      ),
    );
  }
}
