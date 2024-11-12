import 'dart:math';

import 'package:flutter/services.dart';
import 'package:terminal/backend/backend.dart';
import 'package:terminal/backend/terminal_page.dart';
import 'package:xterm/xterm.dart';
import 'package:zenit_ui/zenit_ui.dart';

class TerminalFrame extends StatefulWidget {
  const TerminalFrame({super.key});

  @override
  State<TerminalFrame> createState() => _TerminalFrameState();
}

class _TerminalFrameState extends State<TerminalFrame> {
  final List<TabData> terminalTabs = List.empty(growable: true);
  final List<TerminalPage> terminalPages = List.empty(growable: true);

  int _selectedIndex = 0;

  final backend = TerminalBackend();

  @override
  void initState() {
    super.initState();
    createTab();
    terminalPages.elementAt(_selectedIndex).focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ZenitTabBar(
            selectedIndex: _selectedIndex,
            tabs: terminalTabs,
            onTabSelected: changeTab,
            onTabClosed: closeTab,
            onAddTab: newTab,
          ),
          Expanded(
            child: TerminalView(
              terminalPages.elementAt(_selectedIndex).terminal,
              focusNode: terminalPages.elementAt(_selectedIndex).focusNode,
            ),
          ),
        ],
      ),
    );
  }

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    terminalPages.elementAt(index).focusNode.requestFocus();
  }

  void closeTab(int index) {
    terminalPages.elementAt(index).focusNode.dispose();
    setState(() {
      terminalPages.removeAt(index);
      terminalTabs.removeAt(index);
    });
    if (terminalTabs.isEmpty) {
      SystemNavigator.pop();
    } else {
      int newIndex = min(index, terminalTabs.length - 1);
      changeTab(newIndex);
    }
  }

  void createTab() {
    Terminal t = backend.createNewTerminal();
    setState(() {
      terminalPages.add(TerminalPage(FocusNode(), t));
      terminalTabs.add(
        TabData(
          leading: SizedBox.shrink(),
          title: "Terminal Page ${terminalTabs.length + 1}",
        ),
      );
    });
  }

  void newTab() {
    createTab();
    changeTab(terminalTabs.length - 1);
  }
}
