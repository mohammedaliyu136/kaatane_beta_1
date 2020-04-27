import 'package:flutter/material.dart';

class SilverAppBarExampleNested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("kkkkkkkkk"),
        elevation: 0,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
                height: 150.0,
                width: 30.0,
                child: new GestureDetector(
                  onTap: () {
                    //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                        //builder: (context) => CartPage(),
                      //),
                    //);
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
                                  top: 3.0,
                                  right: 6.0,
                                  child: new Center(
                                    child: new Text(
                                      '4',//(totalCount+8).toString()+'',
                                      style: new TextStyle(
                                          color:  Color.fromRGBO(128, 0, 128, 1),
                                          fontSize: 12.0,//12.0,
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
                    Tab(text: "Call"),
                    Tab(text: "Message 1"),
                    Tab(text: "Message 2"),
                  ],
                ),
                expandedHeight: 220.0,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 50,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Image.network(
                    'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                    fit: BoxFit.cover,
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
                    Center(child: Text("Call"),),
                    Center(child: Text("Message 1"),),
                    Center(child: Text("Message 2"),),
                  ],
                ),
              ),
              Container(color: Color.fromRGBO(128, 0, 128, 1), height: 50, child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:8.0, bottom:8.0, left: 16, right: 8.0),
                    child: Text("0 items", style: TextStyle(color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 8.0),
                    child: SizedBox(width: 2, child:Container(color: Colors.white,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0, bottom:8.0, left: 8.0, right: 8.0),
                    child: Text("N00.0", style: TextStyle(color: Colors.white),),
                  ),
                  Spacer(),
                  SizedBox(width: 2, child:Container(color: Colors.white,),),
                  GestureDetector(
                    onTap: (){
                      //Navigator.push(
                        //context,
                        //MaterialPageRoute(
                          //builder: (context) => CartPage(),
                        //),
                      //);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.shopping_cart, color: Colors.white,),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      //Navigator.push(
                        //context,
                        //MaterialPageRoute(
                          //builder: (context) => CartPage(),
                        //),
                      //);
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
