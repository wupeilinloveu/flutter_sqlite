import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/commons/navigate_to_page.dart';
import 'package:flutter_sqlite/commons/strings.dart';
import 'package:flutter_sqlite/model/wallets.dart';
import 'package:flutter_sqlite/routes/route.dart';
import 'package:flutter_sqlite/sqlite/sqlite_wallet.dart';

// ignore: must_be_immutable
class WalletMangerPage extends StatefulWidget {
  Wallets wallets;

  WalletMangerPage({@required this.wallets});

  @override
  State<StatefulWidget> createState() => new WalletMangerPageState();
}

class WalletMangerPageState extends State<WalletMangerPage> {
  SqliteWallet _sqliteWallet = new SqliteWallet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.blue,
          title: new Text(Strings.manager, style: new TextStyle(fontSize: 16)),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.0),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          )),
      body: ListView(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                      child: new Text(Strings.walletAddress,
                          style: new TextStyle(fontSize: 16)),
                    )
                  ],
                ),
                new Container(
                  child: new Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 10),
                      child: new Text(widget.wallets.walletAddress,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: new TextStyle(fontSize: 16))),
                ),
              ],
            ),
          ),
          Divider(height: 2, color: Colors.black26),
          new Container(
            decoration: new BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: new Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: new Row(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 20.0),
                          child: new Text(Strings.name,
                              style: new TextStyle(fontSize: 16)),
                        )
                      ],
                    ),
                    Spacer(),
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: new Text(widget.wallets.name,
                              style: new TextStyle(fontSize: 16)),
                        ),
                        new Icon(Icons.chevron_right,
                            size: 25, color: Colors.black38)
                      ],
                    )
                  ],
                )),
          ),
          _buildRemoveButton(context)
        ],
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      height: 47.0,
      child: new RaisedButton(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(Strings.remove, style: new TextStyle(fontSize: 16)),
          ],
        ),
        color: Colors.blue,
        onPressed: () {
          //移除钱包
          _deleteWallet();
        },
      ),
    );
  }

  //移除钱包
  Future _deleteWallet() async {
    await _sqliteWallet.openSqlite();
    await _sqliteWallet.delete(widget.wallets.name);
    await _sqliteWallet.close();
    navigateToPage(context, "${Routes.home}");
  }

}
