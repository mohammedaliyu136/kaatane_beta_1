import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';
import 'package:kaatane/bloc/cart_bloc.dart';
import 'package:kaatane/model/my_order_model.dart';
import 'package:kaatane/ui/meals_page.dart';
import 'package:kaatane/ui/widgets/contact.dart';
import 'package:provider/provider.dart';

import 'drawer2.dart';
//import 'package:firebase_admob/firebase_admob.dart';
class RestaurantPage extends StatefulWidget {
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  CarouselController buttonCarouselController = CarouselController();
  List<DocumentSnapshot> snapshots=[];
  List<DocumentSnapshot> featured_snapshots=[];
  bool isLoadingPage=true;
  bool isLoading = false;

  bool firstLoad = false;

  List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState orderBy('name',) .where('listed', isEqualTo: true)
    setState(() {
      isLoadingPage=true;
    });
    Firestore.instance.collection('Restaurant').orderBy('name',).getDocuments().then((value){
      List<DocumentSnapshot> f_doc = [];
      print(value.documents[0].data['featured']);
      for(var i=0; i<value.documents.length; i++){
        print(value.documents[i].data['name']);
        try{
          if(value.documents[i]['listed']){
            snapshots.add(value.documents[i]);
          }
          if(value.documents[i]['featured'] && value.documents[i]['listed']){
            featured_snapshots.add(value.documents[i]);
          }
        }catch(e){}
      }

      setState(() {
        //snapshots=value.documents;
        print(snapshots);
        print(featured_snapshots);
        isLoadingPage=false;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    var bloc = Provider.of<CartBloc>(context);
    bloc.getVersionFromFirebase();
    //bool isLoading =Provider.of<CartBloc>(context).isLoading;
    //final List<Widget> imageSliders = imgList.map((item) => Container(
    /**
    if(!firstLoad){
      Future<List<OrderModel>> list = bloc.getMyOrdersNotRated();
      print("++++++++++++++");
      print("++++++++++++++");
      print("++++++++++++++");
      list.then(
              (value){
                for(var i=0; i<value.length; i++){
                  print(value[i].order_time);
                  print(DateTime.parse(value[i].order_time));
                  print(DateTime.now());
                  print(DateTime.now().difference(DateTime.parse(value[i].order_time)).inMinutes);

                }
              });
      print(list);
      setState(() {
        firstLoad=true;
      });
    }**/
    final List<Widget> imageSliders = featured_snapshots.map((item) => GestureDetector(
      onTap: (){
        setState(() {
          isLoading=true;
        });
        Firestore.instance.collection('category').where('restaurant_id', isEqualTo: item.documentID).getDocuments().then(
                (val)async{
              List<DocumentSnapshot> ctegory_list = val.documents;
              List<Widget> tabBarList = [];
              ctegory_list.forEach((element) {
                String s = element['title'].toLowerCase();
                tabBarList.add(Tab(text: s[0].toUpperCase() + s.substring(1)));

              });
              isLoading=false;
              bloc.clearAll();
              bloc.not();
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealPage(item, ctegory_list, tabBarList)),
              );
              setState(() {
                isLoading=false;
              });

            }
        );
      },
      child: Container(
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item.data['image'], fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      '${item.data['name']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    )).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kaatane"),
      ),
      drawer: drawer2(context),
      body: !bloc.isLoading&&!isLoadingPage?Container(
        //color: Color.fromRGBO(128, 0, 128, 0.15),
        color: Color.fromRGBO(243,204,243, .7),
        //color: Color.fromRGBO(236, 239, 241, 1),
        child: ListView(children: <Widget>[
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 24,bottom: 12, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Featured", style: TextStyle(fontSize: 18, color: Color.fromRGBO(123,123,123, 1), fontFamily: 'Consola'),),
              ],
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.9,
              enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
            ),
            items: imageSliders,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: featured_snapshots.map((url) {
              int index = featured_snapshots.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(128, 0, 128, 1)
                      : Color.fromRGBO(128, 0, 128, 0.4),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 5,),
          Card(
            elevation: 10,
            color: Color.fromRGBO(236, 239, 241, 1),
            //color: Color.fromRGBO(244,244,244, 1),
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
                  child: Text("Restaurants",
                    style: TextStyle(
                      color: Color.fromRGBO(123,123,123, 1),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Consola'
                    ),),
                ),
                snapshots.length!=0?Column(
                  //shrinkWrap: true,
                  children: snapshots.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
                      child: new GestureDetector(
                        onTap: (){
                          bloc.getCategories(document, context);
                          /*
                          setState(() {
                            isLoadingPage=true;
                          });
                          Firestore.instance.collection('category').where('restaurant_id', isEqualTo: document.documentID).getDocuments().then(
                                  (val){
                                List<DocumentSnapshot> ctegory_list = val.documents;
                                List<Widget> tabBarList = [];
                                ctegory_list.forEach((element) {
                                  tabBarList.add(Tab(text: element['title']));

                                });
                                //isLoading=false;
                                bloc.clearAll();
                                bloc.not();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MealPage(document, ctegory_list, tabBarList)),
                                );
                                setState(() {
                                  isLoadingPage=false;
                                });
                              }
                          );*/
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:30.0,),
                              child: Card(
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:33.0, top: 10, bottom: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 0, ),
                                              child: Text(document['name'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(102,102,102, 1),
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 4.0, ),
                                              child: Text(document['location'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(123,123,123, 1),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w300,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 4.0, bottom: 8.0),
                                              child: Text(document['delivery']?'Delivery Available':'',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(123,123,123, 1),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w300,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top:12.0),
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  child: Center(child: Text('')),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(80), bottom: Radius.circular(80)),
                                      image: DecorationImage(
                                          image: NetworkImage(document['image']),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ):Container()
              ],
            ),
          ),

        ],),
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
    );
  }
}

/**
class MyAppADS extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppADS> {
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

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-2940956011124308/7102705334",
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-2940956011124308~1055978210");
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Demo App"),
        ),
        body: Center(
            child: RaisedButton(
              child: Text('Click on Ads'),
              onPressed: () {
                createInterstitialAd()
                  ..load()
                  ..show();
              },
            )),
      ),
    );
  }
}
    **/