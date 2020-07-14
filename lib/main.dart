/*
Copyright 2019 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'rgb.dart';

void main() {
  runApp(new TerminalApp());
}

class TerminalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Terminal',
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new Terminal(),
    );
  }
}

class Terminal extends StatefulWidget {
  Terminal({Key key}) : super(key: key);
  @override
  _TerminalState createState() => new _TerminalState();
}

void terminulll() {
  print('yep, you pressed it! good job');
}

class _TerminalState extends State<Terminal> {
  final myController = TextEditingController();

  String output = "";
  bool yourmotherisbadstreamstate = false;

  Future<Process> _process = Process.start('bash', []);
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  pressEnter() {
    setState(() {
      output += "\$ " + myController.text + "\n";
    });
  }

  updateOutput(var data) {
    setState(() {
      print(data);
      output += data;
    });
  }

  Widget _myWidget(BuildContext context, String myString) {
    final wordToStyle = 'text';
    final style = TextStyle(color: Colors.blue);
    final spans = _getSpans(myString);

    return RichText(
      text: TextSpan(
        style: new TextStyle(
            fontSize: 15.0,
            color: const Color(0xFFf2f2f2),
            fontFamily:
                "SourceCodePro"), //Theme.of(context).textTheme.body1.copyWith(fontSize: 10),
        children: spans,
      ),
    );
  }

  Color getANSI(number, currentShade) {
    switch (number) {
      case '30':
        return Colors.black;
      case '31':
        return Colors.red[currentShade];
      case '32':
        return Colors.green[currentShade];
      case '33':
        return Colors.yellow[currentShade];
      case '34':
        return Colors.blue[currentShade];
      case '35':
        return Colors.pink[currentShade];
      case '36':
        return Colors.cyan[currentShade];
      case '37':
        return Colors.white;
      case '40':
        return Colors.black;
      case '41':
        return Colors.red[currentShade];
      case '42':
        return Colors.green[currentShade];
      case '43':
        return Colors.yellow[currentShade];
      case '44':
        return Colors.blue[currentShade];
      case '45':
        return Colors.pink[currentShade];
      case '46':
        return Colors.cyan[currentShade];
      case '47':
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  List<TextSpan> _getSpans(String text) {
    List<TextSpan> spans = [];
    RegExp re = RegExp(r'\u001b\[(\?)*(\d*|\d+;\d+;\d+)([a-zA-Z])');
    int spanBoundary = 0;
    int startIndex = 0;
    int currentShade = 500;
    String currentColorCode = '37';
    String currentBackgroundColorCode = '40';
    Color currentColor = Color(0xFFf2f2f2);
    Color currentBackgroundColor = null;
    while (true) {
      startIndex = text.indexOf(re, spanBoundary);
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(
            text: text.substring(spanBoundary, startIndex),
            style: TextStyle(
                color: currentColor, backgroundColor: currentBackgroundColor)));
      }
      if (startIndex == -1) {
        spans.add(TextSpan(
            text: text.substring(spanBoundary),
            style: TextStyle(
                color: currentColor, backgroundColor: currentBackgroundColor)));
        return spans;
      }
      Match reMatch = re.firstMatch(text.substring(spanBoundary));
      String match = re.stringMatch(text.substring(spanBoundary));
      if (reMatch.group(1) == null && reMatch.group(3) == 'm') {
        String colorCode = reMatch.group(2);
        switch (colorCode) {
          case '0':
          case '':
            currentShade = 500;
            currentColor = Color(0xFFf2f2f2);
            currentBackgroundColor = null;
            break;
          case '1':
            currentShade = 300;
            currentColor = getANSI(currentColorCode, currentShade);
            break;
          default:
            if (colorCode.contains(';')) {
              var args = colorCode.split(';');
              colorCode = args[2];
              if (args[0] == '38') {
                currentColor = Color.fromRGBO(
                    rgb[int.parse(colorCode)][0],
                    rgb[int.parse(colorCode)][1],
                    rgb[int.parse(colorCode)][2],
                    1.0);
              } else if (args[0] == '48') {
                currentBackgroundColor = Color.fromRGBO(
                    rgb[int.parse(colorCode)][0],
                    rgb[int.parse(colorCode)][1],
                    rgb[int.parse(colorCode)][2],
                    1.0);
              }
            } else if (int.parse(colorCode) >= 30 &&
                int.parse(colorCode) < 38) {
              currentColorCode = colorCode;
              currentColor = getANSI(currentColorCode, currentShade);
            } else if (int.parse(colorCode) >= 40 &&
                int.parse(colorCode) < 48) {
              currentBackgroundColorCode = colorCode;
              currentBackgroundColor =
                  getANSI(currentBackgroundColorCode, currentShade);
            }
            break;
        }
      }
      int endIndex = startIndex + match.length;
      spanBoundary = endIndex;
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: const Color(0xFF222222),
        body: FutureBuilder<Process>(
            future: _process,
            builder: (BuildContext context, AsyncSnapshot<Process> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                var process = snapshot.data;
                if (!yourmotherisbadstreamstate) {
                  process.stdout.transform(utf8.decoder).listen((data) {
                    print(data);
                    updateOutput(data);
                  });
                  process.stderr.transform(utf8.decoder).listen((data) {
                    print(data);
                    updateOutput(data);
                  });
                  yourmotherisbadstreamstate = true;
                }
                children = <Widget>[
                  Container(
                      height: 55,
                      color: Color(0xff292929),
                      child: Row(children: [
                        new IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: terminulll,
                          iconSize: 25.0,
                          color: const Color(0xFFffffff),
                        ),
                        Expanded(
                            child: Center(
                                child: Text('Terminal',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xffffffff))))),
                        new IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            process.stdin.writeln(myController.text);
                            pressEnter();
                            myController.clear();
                            print(myController.text);
                          },
                          iconSize: 25.0,
                          color: const Color(0xFFffffff),
                        ),
                        new IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            showGeneralDialog(
                              barrierLabel: "Barrier",
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: Duration(milliseconds: 120),
                              context: context,
                              pageBuilder: (_, __, ___) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 500,
                                    width: 600,
                                    child: SizedBox.expand(
                                      child: new Center(
                                          child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [],
                                      )),
                                    ),
                                    margin: EdgeInsets.only(
                                        bottom: 75, left: 12, right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              transitionBuilder: (_, anim, __, child) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: child,
                                );
                              },
                            );
                          },
                          iconSize: 25.0,
                          color: const Color(0xFFffffff),
                        ),
                      ])),
                  new Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                      scrollDirection: Axis.vertical,
                      child: new Container(
                        child: _myWidget(context, output),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                  new Padding(
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) {
                        if (event.runtimeType.toString() == 'RawKeyDownEvent' &&
                            event.logicalKey.keyId == 4295426088) {
                          process.stdin.writeln(myController.text);
                          pressEnter();
                          myController.clear();
                        }
                      },
                      child: new TextFormField(
                        controller: myController,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: const Color(0xFFf2f2f2),
                          fontFamily: "Cousine",
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: "\$",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFf2f2f2)),
                        ),
                        autocorrect: false,
                        autofocus: true,
                        minLines: null,
                        maxLines: null,

                        //initialValue: "debug_shell \$",
                        cursorColor: const Color(0xFFf2f2f2),
                        cursorRadius: Radius.circular(0.0),
                        cursorWidth: 10.0,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              } else {
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading...'),
                  )
                ];
              }
              return Column(
                children: children,
              );
            }));
  }
}

class RootTerminalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Root Terminal',
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new RootTerminal(),
    );
  }
}

class RootTerminal extends StatefulWidget {
  RootTerminal({Key key}) : super(key: key);
  @override
  _RootTerminalState createState() => new _RootTerminalState();
}

class _RootTerminalState extends State<RootTerminal> {
  final rootController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    rootController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: new Column(children: [
        Container(
            height: 55,
            color: Colors.red[600],
            child: Row(children: [
              new IconButton(
                icon: const Icon(Icons.add),
                onPressed: terminulll,
                iconSize: 25.0,
                color: const Color(0xFFffffff),
              ),
              Expanded(
                  child: Center(
                      child: Text('Root Terminal',
                          style: TextStyle(
                              fontSize: 18, color: Color(0xffffffff))))),
              new IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  print(rootController.text);
                },
                iconSize: 25.0,
                color: const Color(0xFFffffff),
              ),
              new IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: terminulll,
                iconSize: 25.0,
                color: const Color(0xFFffffff),
              ),
            ])),
        new Expanded(
          child: new Padding(
            child: new TextFormField(
              controller: rootController,
              onFieldSubmitted: (_) async {
                print(rootController.text);
              },
              style: TextStyle(
                fontSize: 15.0,
                color: const Color(0xFFf2f2f2),
                fontFamily: "Cousine",
              ),
              decoration: InputDecoration.collapsed(hintText: ""),
              autocorrect: false,
              minLines: null,
              maxLines: null,
              expands: true,
              //initialValue: "debug_shell \#",
              cursorColor: Colors.red[500],
              cursorRadius: Radius.circular(0.0),
              cursorWidth: 10.0,
            ),
            padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
          ),
        ),
      ]),
    );
  }
}
