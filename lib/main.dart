import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyWidget(),
    ),
  );
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Pixel();
  }
}


Container buildSettings(IconData icon, String title, Color color, Color splash,
    String text, BuildContext context) {
  return new Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child:
            Text('GENERAL',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff222222),
                            fontWeight: FontWeight.w600))
            ,
          );
}

final TextEditingController editingController = new TextEditingController();

class Pixel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      Material(
          color: Color(0xffffffff),
          elevation: 10,
          child: 
          Container(width: 300, child:
          Column(children: [
            Container(
                height: 50,
                color: Color(0xffeeeeee),
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.settings, color: Color(0xffff3D00))),
                  Text('Settings',
                      style:
                          TextStyle(fontSize: 20, color: Color(0xff222222)))
                ])),
          



 new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: new Column(children: <Widget>[
Container(
color: Color(0xffeeeeee),
child:
 Container(
        
      padding: new EdgeInsets.only(left: 10,right: 10,top: 0),
      margin: new EdgeInsets.only(bottom: 10.0),
      child: new Material(
          color: Colors.white,
        borderRadius: const BorderRadius.all(const Radius.circular(25)),
        elevation: 5.0,
        child: new Container(
            width:700,
          height: 35.0,
          margin: new EdgeInsets.only(left: 10,right:5),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    style: new TextStyle(color: Colors.grey[900],fontSize: 15,),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[900],fontSize: 15,),
                      icon: Icon(Icons.search, color: const Color(0xFFff3d00),),
                      hintText: 'Search settings...',
                      border: InputBorder.none
                    ),
                    onSubmitted: null,
                    controller: editingController,
                  )
              )
            ],
          ),
        ),
      ),
    ),
),

new Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child:
            Text('GENERAL',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff222222),
                            fontWeight: FontWeight.w600))
            ,
          ),



                    ])),

            
          ])))
    ]));
  }
}


