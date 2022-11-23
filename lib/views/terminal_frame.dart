import 'dart:convert';
import 'dart:io';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:terminal/constants/constants.dart';
import 'package:xterm/xterm.dart';
import 'package:zenit_ui/zenit_ui.dart';

class TerminalFrame extends StatefulWidget {
  const TerminalFrame({Key? key}) : super(key: key);

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

class _TerminalFrameState extends State<TerminalFrame> {
  late final Map<FocusNode, Terminal> tabs;

  late final Pty pty;

  final Terminal terminal = Constants.terminal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs.entries.first.key.requestFocus();
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
      tabs = {
        FocusNode(): terminal,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabView(
        pages: tabList(),
        onNewPage: () {
          newTab();
        },
        onPageClosed: (index) {
          closeTab(index);
        },
        onPageChanged: (index) {
          changeTab(index);
        },
      ),
    );
  }

  List<TabViewPage> tabList() {
    return tabs
        .map(
          (FocusNode focusNode, Terminal terminal) => MapEntry(
            focusNode,
            TabViewPage(
              title: "Terminal",
              view: TerminalView(
                terminal,
                focusNode: focusNode,
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  void changeTab(int index) {
    tabs.entries.elementAt(index).key.requestFocus();
  }

  void closeTab(int index) {
    tabs.removeWhere((key, value) =>
        tabs.entries.elementAt(index).key == key && tabs.entries.elementAt(index).value == value);
    tabs.entries.elementAt(tabs.length - 1).key.requestFocus();
  }

  void newTab() {
    Terminal t = Terminal(
      maxLines: 10000,
    );
    _startPty(t);
    setState(() {
      tabs.addEntries([MapEntry(FocusNode(), t)]);
    });
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
