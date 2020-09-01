import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/model/wallets.dart';
import 'package:flutter_sqlite/ui/create_wallet_page.dart';
import 'package:flutter_sqlite/ui/home_page.dart';
import 'package:flutter_sqlite/ui/wallet_manger_page.dart';

class Routes{
  static String home="/HomePage";
  static String createWallet="/CreateWalletPage";
  static String walletManager="/WalletMangerPage";

  static void configureRoutes(Router router) {
    router.define(home, handler: homeRouteHandler);
    router.define(createWallet, handler: createWalletRouteHandler);
    router.define(walletManager, handler: walletManagerRouteHandler);

    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return;
        });
  }
}

//Home page
var homeRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return HomePage();
    });

//Create wallet page
var createWalletRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CreateWalletPage();
    });

//wallet manger page
var walletManagerRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String id = params["id"]?.first;
      String name = params["name"]?.first;
      String address = params["address"]?.first;
      return WalletMangerPage(
          wallets: Wallets(
              id:id,
              name:name,
              walletAddress:address
          ));
    });