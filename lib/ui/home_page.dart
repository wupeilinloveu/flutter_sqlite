import 'package:flutter/material.dart';
import 'package:flutter_sqlite/commons/navigate_to_page.dart';
import 'package:flutter_sqlite/commons/strings.dart';
import 'package:flutter_sqlite/routes/route.dart';
import 'package:flutter_sqlite/sqlite/sqlite_wallet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  double circular = 10;
  bool visible = true;

  SqliteWallet _sqliteWallet = new SqliteWallet();
  var _walletList = [];
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    //获取钱包地址的数据
    _getQueryWalletAddressData();
    isFirst = false;
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(isFirst==false){
      _getQueryWalletAddressData();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: new Text(Strings.managerWallet,
              style: new TextStyle(fontSize: 16.0)),
        ),
        actions: <Widget>[
          new Center(
              child: new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: new InkWell(
              onTap: () {
                navigateToPage(context, "${Routes.createWallet}");
              },
              child: Icon(Icons.add),
            ),
          ))
        ],
      ),
      body: new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0xFFECECEB)),
          child: _buildBody(
              context)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBody(BuildContext context) {
    var content;
    if (_walletList != null) {
      content = _buildListViewContent(context);
    } else {
      content = _buildEmptyContent(context);
    }
    return content;
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "- 没有钱包 -",
              style: new TextStyle(fontSize: 16),
            )
          ],
        ));
  }

  Widget _buildListViewContent(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return renderRow(context, index);
      },
      itemCount: _walletList.length,
      controller: _scrollController,
    );
  }

  Widget renderRow(BuildContext context, int i) {
    return new Column(
      children: <Widget>[
        new InkWell(
          onTap: () {
            navigateToPage(context, "${Routes.walletManager}?id=${Uri.encodeComponent("$i")}&name=${Uri.encodeComponent(_walletList[i]["name"])}&address=${Uri.encodeComponent(_walletList[i]["address"])}");
          },
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(circular)),
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: new Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 20.0, 0.0, 20.0),
                              child: new Text(_walletList[i]["name"],
                                  style: new TextStyle(fontSize: 16)),
                            )
                          ],
                        ),
                        Spacer(),
                        new Icon(Icons.more_horiz,
                            size: 25, color: Colors.black38)
                      ],
                    ),
                    new Container(
                      child: new Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 0, top: 10, bottom: 10),
                          child: new Text(_walletList[i]["address"],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: new TextStyle(fontSize: 16))),
                    )
                  ],
                )),
          ),
        )
      ],
    );
  }

  //获取钱包地址的数据
  Future _getQueryWalletAddressData() async {
    await _sqliteWallet.openSqlite();
    var queryWalletAddressList = await _sqliteWallet.queryAll();
    await _sqliteWallet.close();
    setState(() {
      _walletList = queryWalletAddressList;
    });
  }
}
