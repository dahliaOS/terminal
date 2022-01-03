/*
Copyright 2020 The dahliaOS Authors

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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'root-widget.dart';

void main() => runApp(RootTerminalApp());

class RootTerminalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFF212121),
        canvasColor: const Color(0xFF303030),
      ),
      home: RootTerminal(),
    );
  }
}

class RootTerminal extends StatefulWidget {
  const RootTerminal({Key? key}) : super(key: key);
  @override
  RootTerminalState createState() => RootTerminalState();
}

class RootTerminalState extends State<RootTerminal>
    with TickerProviderStateMixin {
  List<Tab> tabs = [];
  late TabController tabController;
  var count = 1;
  void newTab() {
    setState(() {
      tabs.add(
        Tab(
          child: Row(
            children: <Widget>[
              Text('Root Session ' '$count'),
              const Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(child: Container()),
              GestureDetector(
                child: const Icon(
                  Icons.clear,
                  size: 16,
                  //color: Colors.black,
                ),
                onTap: closeCurrentTab,
              ),
            ],
          ),
        ),
      );
      count++;
      tabController = TabController(length: tabs.length, vsync: this);
    });
  }

  void closeCurrentTab() {
    setState(() {
      tabs.removeAt(tabController.index);
      tabController = TabController(length: tabs.length, vsync: this);
    });
  }

  @override
  void initState() {
    super.initState();
    tabs.add(
      Tab(
        child: Row(
          children: <Widget>[
            const Text('Root Session ' '0'),
            const Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            Expanded(child: Container()),
            GestureDetector(
              child: const Icon(
                Icons.clear,
                size: 16,
                //color: Colors.black,
              ),
              onTap: closeCurrentTab,
            ),
          ],
        ),
      ),
    );
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xFF212121),
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(
                  55.0), // here the desired height of the status bar
              child: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.red[600],
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(
                          55.0), // here the desired height of the status bar
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: TabBar(
                                controller: tabController,
                                labelColor: const Color(0xFFffffff),
                                unselectedLabelColor: Colors.white,
                                indicator: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    color: Color(0xFF212121)),
                                tabs: tabs.map((tab) => tab).toList()),
                          )),
                          Center(
                            child: IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                onPressed: newTab),
                          ),
                          Center(
                            child: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                color: Colors.white,
                                onPressed: newTab),
                          ),
                          Center(
                            child: IconButton(
                                icon: const Icon(Icons.more_vert),
                                color: Colors.white,
                                onPressed: newTab),
                          )
                        ],
                      )) // A trick to trigger TabBar rebuild.
                  )),
          body: Stack(
            children: [
              Center(
                child: const Text(
                  "owo whats this",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TabBarView(
                controller: tabController,
                children: tabs.map((tab) => Terminal()).toList(),
              ),
            ],
          )),
    );
  }
}
