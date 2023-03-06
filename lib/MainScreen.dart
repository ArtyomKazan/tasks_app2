import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Settings.dart';


class MainScreen extends StatelessWidget {

  var result = [];
  var ship = 0;
  var title = "Все задачи";
  var shipList = {};

  MainScreen({required this.result, required this.ship,  required this.title, required this.shipList});

  @override
  Widget build(BuildContext context) {

    var newresult = [];
    for(final e in result){
      if(e['ship_id'] == ship.toString()){
        newresult.add(e);
      }
      if(ship.toString() == "0"){
        newresult.add(e);
      }
    }

    return Scaffold(
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: newresult.length,
          itemBuilder: (BuildContext context, int index) {
            var timestamp = int.parse(newresult[index]['dat']);
            var timestampNow = DateTime.now().millisecondsSinceEpoch / 1000;
            var CardColor = Colors.black12;
            if (timestamp < (timestampNow + 432000) &&
                int.parse(newresult[index]['complete']) != 1) {
              CardColor = Colors.red;
            }
            if (int.parse(newresult[index]['complete']) == 1) {
              CardColor = Colors.green;
            }
            var myDate = DateTime.fromMillisecondsSinceEpoch(
                timestamp * 1000);
            var format = new DateFormat("d.M.y");
            var dateString = format.format(myDate);
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: CardColor,
                ),
              ),
              child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/view/'+newresult[index]['id']);
                  },
                  child: ListTile(
                    title: Text(newresult[index]['name'], style: TextStyle(fontSize: 18.0)),
                    subtitle: Text("Срок: " + dateString + "\nТеплоход: " + shipList[newresult[index]['ship_id']], style: TextStyle(fontSize: 12.0)),
                  ),
                ),
            );
          }
      ),
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton(
            //key: _menuKey,
            icon: const Icon(
                Icons.filter_list,
                color: Colors.white
            ),
            itemBuilder: (_) => const<PopupMenuItem<String>>[
              PopupMenuItem<String>(
                  child: Text("Панферов"),
                  value: 'ship1'
              ),
              PopupMenuItem<String>(
                  child: Text('Достоевский'),
                  value: 'ship2'
              ),
            ],
            onSelected: (value) {
              print("value:$value");
              Navigator.pushNamed(context, '/'+value);
            },
          )
        ],
      ),
    );
  }

}
