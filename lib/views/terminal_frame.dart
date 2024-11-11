import 'dart:convert';
import 'dart:io';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:terminal/constants/constants.dart';
import 'package:xterm/xterm.dart';
import 'package:zenit_ui/zenit_ui.dart';

class TerminalFrame extends StatefulWidget {
  const TerminalFrame({super.key});

  @override
  State<TerminalFrame> createState() => _TerminalFrameState();
}

String get shell {
  if (Platform.isWindows) {
    return r'cmd.exe';
  } else {
    if (File("/usr/bin/zsh").existsSync()) {
      return r'zsh';
    }
    if (File("/usr/bin/bash").existsSync()) {
      return r'bash';
    }
    return "sh";
  }
}

class TerminalPage {
  final FocusNode focusNode;
  final Terminal terminal;

  const TerminalPage(this.focusNode, this.terminal);
}

class _TerminalFrameState extends State<TerminalFrame> {
  late final List<TabData> terminalTabs;
  late final List<TerminalPage> terminalPages;

  int _selectedIndex = 0;

  final Terminal terminal = Constants.terminal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) _startPty(terminal);
      },
    );

    setState(() {
      terminalPages = [
        TerminalPage(FocusNode(), terminal),
      ];
      terminalTabs = [
        const TabData(
          leading: Icon(Icons.code),
          title: "Page 1",
        ),
      ];
    });
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
            child: TerminalView(terminalPages.elementAt(_selectedIndex).terminal,
                focusNode: terminalPages.elementAt(_selectedIndex).focusNode),
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
    terminalPages.removeAt(index);
    terminalTabs.removeAt(index);
    changeTab(index - 1);
  }

  void newTab() {
    Terminal t = Terminal(
      maxLines: 10000,
    );
    _startPty(t);
    setState(() {
      terminalPages.add(TerminalPage(FocusNode(), t));
      terminalTabs.add(TabData(
        leading: const Icon(Icons.code),
        title: "Page ${terminalTabs.length + 1}",
      ));
    });
    changeTab(terminalTabs.length - 1);
  }

  Pty _startPty(Terminal t) {
    Pty p = Pty.start(
      shell,
      columns: t.viewWidth,
      rows: t.viewHeight,
    );

    p.output.cast<List<int>>().transform(const Utf8Decoder()).listen(t.write);

    p.exitCode.then((code) {
      t.write('the process exited with exit code $code');
    });

    t.onOutput = (data) {
      p.write(const Utf8Encoder().convert(data));
    };

    t.onResize = (w, h, pw, ph) {
      p.resize(h, w);
    };
    return p;
  }
}
