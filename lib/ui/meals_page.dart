import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:kaatane/admin/STRINGVALUE.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../bloc/cart_bloc.dart';
import '../model/meal.dart';
import '../model/restaurant.dart';
import '../utils/rest_api.dart';
import 'package:intl/intl.dart';
import 'button.dart';
import 'cart_page.dart';
import 'meal_item.dart';
import 'widgets/add_to_cart_btn.dart';
import 'widgets/contact.dart';
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

  bool isOpened = true;
  bool isFirstOpened = false;

  String openingAndClosing = "";

  bool isLoading = true;
  bool isDiscount = false;

  int cat_len = 0;

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
        Provider.of<CartBloc>(context).not();
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
  preOrderDialog(BuildContext context) {

    //imageFile!=null?print(imageFile.path.toString()):print("is null");

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
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
      title: Text("Pre-Orders Only"),
      content: Text("The is a home based vendor. Orders made here might take up to 24 hours."),
      actions: [
        cancelButton,
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
        _scrollController.offset > (150 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    int len = 0;
    print("00000000000");
    ctegory_list.forEach((element) {
      len += element['title'].length;
      print(element['title'].length);
    });

    setState(() {
      cat_len=len;
      if(restaurantDocument['color']!=null){
        titleColor = Color(restaurantDocument['color']);
        currentColor = Color(restaurantDocument['color']);
      }else{
        titleColor = Colors.white;
        currentColor = Colors.white;
      }
    });

    Firestore.instance.collection('meal')
        .where('restaurant_id', isEqualTo: restaurantDocument.documentID)
        .where('listed', isEqualTo: true).getDocuments()
        .then((meals){
      setState(() {
        print("***************");
        print("***************");
        isLoading = false;
        print(meals.documents.length);
        meal_list=meals.documents;
      });
      for (var i = 1; i <= meals.documents.length; i++) {
        if(meals.documents[i]['discount']){
          setState(() {
            isDiscount = true;
          });
          //break;
        }
      }
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
    if (Provider.of<CartBloc>(context).cart.length > 0) {
      //totalCount = bloc.cart.values.reduce((a, b) => a + b);
      totalCount = Provider.of<CartBloc>(context).cart.length;
    }
    List<Widget> taViewList = [];

    try{
      String currentTime = TimeOfDay.now().hour.toString()+(TimeOfDay.now().minute<10?'0${TimeOfDay.now().minute}':TimeOfDay.now().minute.toString()).toString();
      //String currentTime = Timestamp.now().toDate().toUtc()
      String openingTime = restaurantDocument['openingTime'].split(" ")[0].split(":").join("");
      String closingTime = restaurantDocument['closingTime'].split(" ")[0].split(":").join("");
      setState(() {
        openingAndClosing = "${restaurantDocument['openingTime']} -- ${restaurantDocument['closingTime']}";
      });
      if(int.parse(currentTime)>int.parse(openingTime) && int.parse(currentTime)<int.parse(closingTime) && restaurantDocument['days'].split('-')[DateTime.now().weekday-1].toString()=='1'){
        print("open");
      }else{
        setState(() {
          isOpened=false;
        });
      }
    }catch(err){
      setState(() {
        isOpened=true;
        openingAndClosing="";
      });
    }

    return new WillPopScope(
      onWillPop: (){
        if(bloc.isLoggedIn){
          if(titleColor.value!=currentColor.value){
            showAlertColorDialog(mContext);
          }else{
            Navigator.of(mContext).pop();
          }
        }else{
          if(totalCount!=0){
            showAlertDialog(mContext);
          }else{
            Navigator.of(mContext).pop();
          }
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
                          leading: !isShrink?Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                boxShadow: [
                                  BoxShadow(color:Colors.grey.withOpacity(0.3),spreadRadius:2, blurRadius: 7, offset: Offset(0,3)),
                                ]
                              ),
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back),//BackButtonIcon(),
                                  color: Colors.black,//isShrink ? Colors.white : currentColor,
                                  onPressed: () {
                                    //showAlertDialog(mContext);
                                    if(bloc.isLoggedIn){
                                      if(titleColor.value!=currentColor.value){
                                        showAlertColorDialog(mContext);
                                      }else{
                                        Navigator.of(mContext).pop();
                                      }
                                    }else{
                                      if(totalCount!=0){
                                        showAlertDialog(mContext);
                                      }else{
                                        Navigator.of(mContext).pop();
                                      }
                                    }
                                    //Navigator.pop(context);
                                  }),
                            ),
                          ):IconButton(
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
                                  if(totalCount!=0){
                                    showAlertDialog(mContext);
                                  }else{
                                    Navigator.of(mContext).pop();
                                  }
                                }
                                //Navigator.pop(context);
                              }),
                          flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              titlePadding: !isShrink?EdgeInsets.all(0):null,
                              title: GestureDetector(
                                onTap: (){
                                  if(bloc.isLoggedIn){
                                    showColorDialog(mContext);
                                  }
                                },
                                child: isShrink?Text(restaurantDocument['name'],
                                    style: TextStyle(
                                      color: isShrink ? Colors.white : currentColor,
                                    )):SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(color:Colors.grey.withOpacity(0.5),spreadRadius:2, blurRadius: 7, offset: Offset(0,3)),
                                              ]
                                          ), //Colors.black38,Color.fromRGBO(128, 0, 128, 99),
                                          child: ListTile(
                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                            contentPadding: EdgeInsets.only(left: 13.0, right: 2.0, top:0, bottom:0),
                                            title: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(restaurantDocument['name'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,////Colors.white,//Color.fromRGBO(128, 0, 128, 1),
                                                    )),
                                                SizedBox(height: 3,),
                                                openingAndClosing!=""&&(restaurantDocument['is_home_based'] == null)?Row(

                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.access_time, size: 10.0, color: Color.fromRGBO(128, 0, 128, 1)),
                                                    SizedBox(width: 3.0),
                                                    Text("$openingAndClosing",
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey,////Colors.white,//Color.fromRGBO(128, 0, 128, 1),
                                                        )),

                                                  ],
                                                ):Container(),
                                                (restaurantDocument['is_home_based'] != null)?(restaurantDocument['is_home_based'] != false)?Row(

                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    /*
                                                    Text("${restaurantDocument["home_based_delivery_time"]}hrs - Pre-orders only",
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey,////Colors.white,//Color.fromRGBO(128, 0, 128, 1),
                                                        )),*/
                                                    Text("Pre-orders only",
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey,////Colors.white,//Color.fromRGBO(128, 0, 128, 1),
                                                        )),

                                                  ],
                                                ):Row(

                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.access_time, size: 10.0, color: Color.fromRGBO(128, 0, 128, 1)),
                                                    SizedBox(width: 3.0),
                                                    Text("$openingAndClosing",
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey,////Colors.white,//Color.fromRGBO(128, 0, 128, 1),
                                                        )),

                                                  ],
                                                ):Container()
                                              ],
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () async {
                                                await FlutterPhoneState.startPhoneCall(restaurantDocument["phone_number"]);
                                                print(restaurantDocument["phone_number"]);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(500),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(color:Colors.grey.withOpacity(0.3),spreadRadius:2, blurRadius: 7, offset: Offset(0,3)),
                                                    ]
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.call, size: 20, color: Color.fromRGBO(128, 0, 128, 1)),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                              background: Image.network(restaurantDocument['image'],
                                fit: BoxFit.cover,
                              )),

                        ),

                        !isOpened?SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:20.0),
                            child: Center(child: Text("This Restaurant is closed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)),
                          ),
                        ):SliverToBoxAdapter(),

                        isDiscount?SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top:18.0, left: 18, ),
                                    child: Text("Deals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                  ),
                                ],
                              ),
                              meal_list!=null?Container(
                                height: isOpened?130.0:80,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18, ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: meal_list.length,
                                    itemBuilder: (context, index) {

                                      if(meal_list[index]['discount']&&meal_list[index]['listed']){
                                        return Container(
                                          width: 220.0,
                                          child: Card(
                                            elevation: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(child: Text(meal_list[index]['title'], maxLines: 2, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),)),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(NumberFormat.currency(symbol: "₦", decimalDigits: 0).format(int.parse(meal_list[index]['normal_price'])), style: meal_list[index]['discount']?TextStyle(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold, color: Color.fromRGBO(128, 0, 128, 1)):TextStyle()),
                                                      meal_list[index]['discount']?Text(" ₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(int.parse(meal_list[index]['discount_price']))}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)):Container(),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  isOpened?Row(
                                                    children: <Widget>[
                                                      Spacer(),
                                                      isOpened?Button(meal_list[index]):Container(),
                                                      //Container(height: 50, width: 50, color: Colors.greenAccent,),
                                                    ],
                                                  ):Container()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }else{
                                        return Container(height: 1.0,);
                                      }
                                    },
                                  ),
                                ),
                              ):Container(),
                            ],
                          ),
                        ):SliverToBoxAdapter(),

                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              isScrollable: cat_len<30?false:true,
                              labelColor: Color.fromRGBO(128, 0, 128, 1),
                              indicatorColor: Color.fromRGBO(128, 0, 128, 1),
                              unselectedLabelColor: Colors.grey,
                              tabs: tabBarList,
                            ),isShrink
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
                                //print(cat_document.documentID);
                                return ListView.builder(
                                    padding: EdgeInsets.zero,
                                  itemCount: meal_list.length,
                                  itemBuilder: (context, index){
                                    if(cat_document.documentID==meal_list[index]['category_id']){//meal_list[index]
                                      print(NumberFormat.currency(symbol: "", decimalDigits: 0).format(2000));
                                      return Meal_Item(meal_list[index],isOpened);
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
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
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
                      child: Text("${Provider.of<CartBloc>(context).count_total} ${Provider.of<CartBloc>(context).count_total>1?ITEMS_LABEL_TEXT:ITEM_LABEL_TEXT}", style: TextStyle(color: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 8.0),
                      child: SizedBox(width: 2, child:Container(color: Colors.white,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0, bottom:8.0, left: 8.0, right: 8.0),
                      child: Text("₦${NumberFormat.currency(symbol: "", decimalDigits: 0).format(bloc.total)}", style: TextStyle(color: Colors.white),),
                    ),
                    Spacer(),
                    SizedBox(width: 2, child:Container(color: Colors.white,),),
                    Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart, color: Colors.white,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(VIEW_CART_LABEL_TEXT, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                      )
                    ],),
                    /*
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.teal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.shopping_cart, color: Colors.white,),
                        ),
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
                      child: Container(
                        color: Colors.teal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("VIEW CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                        ),
                      ),
                    ),*/
                    SizedBox(width: 10,)
                  ],
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.isShrink);

  final TabBar _tabBar;
  bool isShrink;

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
        color: Colors.grey[50],//isShrink?Colors.white:Colors.transparent,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
