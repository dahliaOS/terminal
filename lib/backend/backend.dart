import 'dart:convert';
import 'dart:io';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class TerminalBackend {
  static String get loginShell => Platform.environment['SHELL'] ?? "sh";

  Terminal createNewTerminal() {
    Terminal t = Terminal(
      maxLines: 10000,
    );
    _startPty(t);
    return t;
  }

  Pty _startPty(Terminal t) {
    Pty p = Pty.start(
      loginShell,
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
