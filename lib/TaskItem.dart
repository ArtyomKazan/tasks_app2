import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Settings.dart';
import 'rest.dart';
import 'package:transparent_image/transparent_image.dart'
  show kTransparentImage;

class TaskItem extends StatelessWidget {

  var Item = "";
  var ShipList = {};
  var tl = Rest(url,token);

  TaskItem({required this.Item, required this.ShipList});

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(title: Text('Просмотр задачи')),

      body: FutureBuilder(
        future: tl.GetTasksInfo("getTaskInfo", Item),
        builder:(context, snapshot){
          if(snapshot.hasError){
            return Text("error");
          }
          else if(snapshot.hasData){
            var result = [];
            String complet = "";
            result = snapshot.data!;
            print(result);
            if(result[0]['complete']=="1"){
              complet = "Задача завершена";
            }
            else{
              complet = "Задача не завершена";
            }
            var timestamp = int.parse(result[0]['created']);
            var myDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            var format = new DateFormat("d.M.y");
            var dat = format.format(myDate);
            timestamp = int.parse(result[0]['dat']);
            myDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            format = new DateFormat("d.M.y");
            var srok = format.format(myDate);

            var ship = ShipList[result[0]['ship_id']];

            return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(result[0]['name'], style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(complet, style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Поставлена: " + dat, style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Срок: " + srok, style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Теплоход: " + ship, style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Автор: " + result[0]['author_str'], style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Text("Ответственный: " + result[0]['executor'], style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Помощник: " + result[0]['helpers'], style: TextStyle(fontSize: 18.0))
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(result[0]['text'], style: TextStyle(fontSize: 20.0))
                  ),
                  // галерея
                  FutureBuilder(
                      future: tl.GetTaskPictures("getTaskPictures", Item),
                      builder:(context, snapshot){
                        if(snapshot.hasError){
                          return Text("error1");
                        }
                        else if(snapshot.hasData){
                          var result2 = [];
                          result2 = snapshot.data!;
                          print(result2);
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: result2.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: result2[index]),
                                );
                              }
                          );
                        }
                        else{
                          return Text("Загружаем картинки, если есть...");
                        }
                      }
                  ),
                  // переписка
                  FutureBuilder(
                      future: tl.GetTaskPictures("getTaskPosts", Item),
                      builder:(context, snapshot){
                        if(snapshot.hasError){
                          return Text("error1");
                        }
                        else if(snapshot.hasData){
                          var result3 = [];
                          result3 = snapshot.data!;

                          return ListView.builder(
                              //scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: result3.length,
                              itemBuilder: (BuildContext context, int index) {
                                var timestamp = int.parse(result3[index]['date']);
                                var myDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                                var format = new DateFormat("d.M.y H:m");
                                var dat = format.format(myDate);
                                return Container(
                                  child: ListTile(
                                    title: Text(result3[index]["text"]),
                                    subtitle: Text(" -- " + result3[index]["author_str"] + " в " + dat)
                                  ),
                                );
                              }
                          );
                        }
                        else{
                          return Text("Загружаем переписку, если есть...");
                        }
                      }
                  )
                ],
            );
          }
          else
          {
              return Center(child: const CircularProgressIndicator());
          }
        }
      ),

    );

  }

}