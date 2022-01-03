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

import 'package:flutter/material.dart';
import 'terminal_widget.dart';

void main() => runApp(const TerminalApp());

class TerminalApp extends StatelessWidget {
  const TerminalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF212121),
        canvasColor: const Color(0xFF303030),
        platform: TargetPlatform.fuchsia,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
            .copyWith(secondary: const Color(0xFFff6507)),
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const TerminalUI(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => const SettingsScreen(),
      },
    );
  }
}

class TerminalUI extends StatefulWidget {
  const TerminalUI({Key? key}) : super(key: key);
  @override
  TerminalUIState createState() => TerminalUIState();
}

class TerminalUIState extends State<TerminalUI> with TickerProviderStateMixin {
  List<Tab> tabs = [];
  late TabController tabController;
  var count = 1;
  void newTab() {
    setState(() {
      tabs.add(
        Tab(
          child: Row(
            children: <Widget>[
              Text('Session ' '$count'),
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

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
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
            const Text('Session ' '0'),
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
            preferredSize:
                const Size.fromHeight(55.0), // here the desired height
            child: AppBar(
                elevation: 0.0,
                backgroundColor: const Color(0xFF282828),
                bottom: PreferredSize(
                    preferredSize:
                        const Size.fromHeight(55.0), // here the desired height
                    child: Row(
                      children: [
                        Expanded(
                            child: TabBar(
                                controller: tabController,
                                labelColor: const Color(0xFFffffff),
                                unselectedLabelColor: Colors.white,
                                indicator: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    color: Color(0xFF212121)),
                                tabs: tabs.map((tab) => tab).toList())),
                        Center(
                          child: IconButton(
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                              onPressed: newTab),
                        ),
                        Center(
                          child: IconButton(
                            icon: const Icon(Icons.settings),
                            color: Colors.white,
                            onPressed: () {
                              // Navigate to the second screen using a named route.
                              Navigator.pushNamed(context, '/second');
                            },
                          ),
                        ),
                      ],
                    )) // A trick to trigger TabBar rebuild.
                )),
        body: TabBarView(
          controller: tabController,
          children: tabs.map((tab) => const Terminal()).toList(),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF282828),
            title: const Text("Settings"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Appearance",
                ),
                Tab(text: "Keyboard & mouse"),
                Tab(
                  text: "Behavior",
                ),
                Tab(
                  text: "About",
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(
                child: SizedBox(
                  width: 800,
                  child: AppearanceWidget(),
                ),
              ),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ));
  }
}

Widget themeCard(Color bgcolor, Color fgcolor1, Color fgcolor2, Color fgcolor3,
    String themeName) {
  return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
          height: 100,
          width: 120,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(children: <Widget>[
                Container(
                  height: 75,
                  width: 120,
                  color: bgcolor,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'user@host',
                          style: TextStyle(
                              fontFamily: "Cousine",
                              fontSize: 12,
                              color: fgcolor1),
                          children: <TextSpan>[
                            TextSpan(
                              text: '~',
                              style: TextStyle(
                                  fontFamily: "Cousine",
                                  fontSize: 12,
                                  color: fgcolor2),
                            ),
                            TextSpan(
                              text: '\$',
                              style: TextStyle(
                                fontSize: 12,
                                color: fgcolor3,
                                fontFamily: "Cousine",
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  width: 120,
                  color: Colors.grey[800],
                  child: Center(
                    child: Text(themeName),
                  ),
                )
              ]))));
}

class AppearanceWidget extends StatelessWidget {
  const AppearanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(25),
            child: Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                  const Text(
                    "Theme",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          themeCard(
                              const Color(0xFF222222),
                              const Color(0xFFf2f2f2),
                              const Color(0xFFf2f2f2),
                              const Color(0xFFf2f2f2),
                              "Default Dark"),
                          themeCard(
                              const Color(0xff150896),
                              const Color(0xff766CF9),
                              const Color(0xff766CF9),
                              const Color(0xff766CF9),
                              "C64"),
                          themeCard(Colors.white, Colors.black, Colors.black,
                              Colors.black, "xterm"),
                          themeCard(
                              const Color(0xff37474f),
                              const Color(0xff4caf50),
                              const Color(0xff4caf50),
                              const Color(0xff4caf50),
                              "San Gorgonio"),
                          themeCard(
                              const Color(0xff000000),
                              const Color(0xff32cd32),
                              const Color(0xff32cd32),
                              const Color(0xff32cd32),
                              "Hackerman"),
                          themeCard(
                              const Color(0xff282a36),
                              const Color(0xffbd93f9),
                              const Color(0xff50fa7b),
                              const Color(0xfff8f8f2),
                              "Dracula"),
                          themeCard(
                              const Color(0xff2D0922),
                              const Color(0xff7EDA34),
                              const Color(0xff1D89D6),
                              const Color(0xffFDFEFC),
                              "Unity"),
                          themeCard(
                              const Color(0xff26292E),
                              const Color(0xffF85A5A),
                              const Color(0xff39ABDC),
                              const Color(0xffFDFEFC),
                              "Subspace"),
                          themeCard(
                              const Color(0xff212D34),
                              const Color(0xff55B1C2),
                              const Color(0xff32A5F1),
                              const Color(0xff7DE5D2),
                              "Argon"),
                          themeCard(
                              const Color(0xffe0e0e0),
                              const Color(0xff616161),
                              const Color(0xff424242),
                              const Color(0xff212121),
                              "Noir Light"),
                        ],
                      )
                    ],
                  ),
                ])))));
  }
}
