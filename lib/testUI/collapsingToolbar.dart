import 'package:flutter/material.dart';

class SilverAppBarExampleNested extends StatefulWidget {
  @override
  TestingNewState createState() => TestingNewState();
}

class TestingNewState extends State<SilverAppBarExampleNested> {
  ScrollController _scrollController;

  bool lastStatus = true;

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
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primarySwatch: Colors.red,
        primaryColor: Color.fromRGBO(128, 0, 128, 1),
      ),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: DefaultTabController(
                length: 10,
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
                            color: isShrink ?  Colors.white : Colors.red,
                            onPressed: () {
                              //showAlertDialog(mContext);
                              //Navigator.pop(context);
                            }),
                        actions: <Widget>[
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text("text sample",
                                style: TextStyle(
                                  color: isShrink ?  Colors.white : Colors.red,
                                  fontSize: 16.0,
                                )),
                            background: Image.network('http://preprod.tibib-live.com/medias/cached-media/medium/5bea5964109aa-c827b05facc3781485e584dac2f4dddc.png',
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
                            tabs: [
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                              Tab(text: "kkkk"),
                            ],
                          ),
                        ),
                        pinned: true,
                      )
                    ];
                  },
                  body: Center(
                    child:  TabBarView(
                        children: [
                          Text("uu"),
                          Text("oo"),
                          Text("pp"),
                          Text("jjs"),
                          Text("qq"),
                          Text("ee"),
                          Text("ee"),
                          Text("ee"),
                          Text("ee"),
                          Text("ee"),
                        ]//taViewList
                    ),
                  ),
                ),
              ),
            ),
          ],
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
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
