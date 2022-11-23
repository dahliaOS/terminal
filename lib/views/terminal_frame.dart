import 'dart:convert';
import 'dart:io';

import 'package:flutter_pty/flutter_pty.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs.entries.first.key.requestFocus();
  }

  final terminal = Terminal(
    maxLines: 10000,
  );

  final terminalController = TerminalController();

  late final Pty pty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) _startPty();
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
        pages: tabs
            .map((FocusNode focusNode, Terminal terminal) => MapEntry(
                focusNode,
                TabViewPage(
                  title: "Terminal",
                  view: TerminalView(
                    terminal,
                    focusNode: focusNode,
                  ),
                )))
            .values
            .toList(),
        onNewPage: () => setState(() {
          tabs.addEntries([MapEntry(FocusNode(), terminal)]);
        }),
        onPageClosed: (index) {
          tabs.removeWhere((key, value) =>
              tabs.entries.elementAt(index).key == key && tabs.entries.elementAt(index).value == value);
          tabs.entries.elementAt(tabs.length - 1).key.requestFocus();
        },
        onPageChanged: (index) {
          tabs.entries.elementAt(index).key.requestFocus();
        },
      ),
    );
  }

  void _startPty() {
    pty = Pty.start(
      shell,
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
    );

    pty.output.cast<List<int>>().transform(const Utf8Decoder()).listen(terminal.write);

    pty.exitCode.then((code) {
      terminal.write('the process exited with exit code $code');
    });

    terminal.onOutput = (data) {
      pty.write(const Utf8Encoder().convert(data));
    };

    terminal.onResize = (w, h, pw, ph) {
      pty.resize(h, w);
    };
  }
}
