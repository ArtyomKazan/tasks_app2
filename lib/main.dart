import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'rest.dart';
import 'Settings.dart';
import 'MainScreen.dart';
import 'TaskItem.dart';
import 'package:intl/intl.dart';

const url="http://tasks.kit-site.com/rest/data.php";
const token = "p&@15L!43P6";

void main() async {

  var tl  = Rest(url,token);
  var shipList = await tl.GetRestJson("getShipsList");
  var result = await tl.GetTasksList("getGlobalTaskList");
  //print(result);

  runApp(MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/':(BuildContext context) => MainScreen(result: result, ship: 0, title: "Все задачи", shipList: shipList),
        '/ship1':(BuildContext context) => MainScreen(result: result, ship: 1, title: "Панферов", shipList: shipList),
        '/ship2':(BuildContext context) => MainScreen(result: result, ship: 2, title: "Достоевский", shipList: shipList),
        //'/view':(BuildContext context) => TaskItem(),
      },

      onGenerateRoute: (routeSettings){
        var path = routeSettings.name!.split('/');
        if (path[1] == "view") {
          return new MaterialPageRoute(
            builder: (context) => new TaskItem(Item: path[2], ShipList: shipList),
            settings: routeSettings,
          );
        }
      }

  ));

}