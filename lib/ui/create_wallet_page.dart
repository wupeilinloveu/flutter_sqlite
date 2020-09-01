import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/commons/navigate_to_page.dart';
import 'package:flutter_sqlite/commons/strings.dart';
import 'package:flutter_sqlite/routes/route.dart';
import 'package:flutter_sqlite/sqlite/sqlite_wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import "package:hex/hex.dart";
import 'package:web3dart/web3dart.dart';

class CreateWalletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CreateWalletPageState();
}

class CreateWalletPageState extends State<CreateWalletPage> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  bool _isObscure = true;
  Color _eyeColor;
  bool _isObscure2 = true;
  Color _eyeColor2;

  SqliteWallet _sqliteWallet = new SqliteWallet();
  String _address;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.blue,
          title: new Text(Strings.createWallet, style: new TextStyle(fontSize: 16)),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.0),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          )),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: _name,
                  decoration: new InputDecoration(
                    hintText: Strings.nameRequired,
                    labelText: Strings.name,
                  ),
                  maxLines: 1,
                ),
                new TextField(
                  controller: _password,
                  obscureText: _isObscure,
                  maxLines: 1,
                  decoration: new InputDecoration(
                      hintText: Strings.passwordRequired,
                      labelText: Strings.password,
                   suffixIcon:  IconButton(
                     icon: Icon(
                       Icons.remove_red_eye,
                       color: _eyeColor,
                     ),
                     onPressed: (){
                       setState(() {
                         _isObscure = !_isObscure;
                         _eyeColor = _isObscure ? Colors.grey : Colors.black;
                       });
                     },
                   )),
                  keyboardType: TextInputType.text,
                ),
                new TextField(
                  controller: _confirmPassword,
                  obscureText: _isObscure2,
                  maxLines: 1,
                  decoration: new InputDecoration(
                      hintText: Strings.confirmPasswordRequired,
                      labelText: Strings.confirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _eyeColor2,
                    ),
                    onPressed: (){
                      setState(() {
                        _isObscure2 = !_isObscure2;
                        _eyeColor2 = _isObscure2 ? Colors.grey : Colors.black;
                      });
                    },
                  )
                  ),
                  keyboardType: TextInputType.text,
                ),
                _buildCreateWalletBottom(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateWalletBottom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          height: 54.0,
          margin: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
          child: new RaisedButton(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(Strings.create, style: new TextStyle(fontSize: 16)),
              ],
            ),
            color: Colors.blue,
            onPressed: () {
              _checkInput(context);
            },
          ),
        ),
      ],
    );
  }

  _checkInput(BuildContext context) {
    if (_name.text.length == 0) {
      _showDialog(context, Strings.nameRequired);
    } else if (_password.text.length == 0) {
      _showDialog(context, Strings.passwordRequired);
    } else if (_confirmPassword.text.length == 0) {
      _showDialog(context, Strings.confirmPasswordRequired);
    } else if (_password.text != _confirmPassword.text) {
      _showDialog(context, Strings.passwordMismatch);
    } else {
      //创建钱包
      createWallet();
      navigateToPage(context, "${Routes.home}");
    }
  }

  //创建钱包
  Future createWallet() async {
    _getWalletAddress(_password.text);
    await _sqliteWallet.openSqlite();//打开数据库
    await _sqliteWallet.insert(_name.text, _address);//插入数据
    await _sqliteWallet.close();//关闭数据库
  }

  Future _getWalletAddress(String password) async {
    //随机生成助记词
    String seed = bip39.mnemonicToSeedHex(password);
    KeyData master = ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    //通过助记词生成私钥
    String privateKey = HEX.encode(master.key);

    //通过私钥拿到地址信息
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    setState(() {
      _address = address.toString();
    });
  }

  _showDialog(BuildContext context, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: new Text(message, style: new TextStyle(fontSize: 16)),
            actions: <Widget>[
              new CupertinoDialogAction(
                child: new Text(Strings.ok, style: new TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}
