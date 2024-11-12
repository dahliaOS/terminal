import 'package:flutter/widgets.dart';
import 'package:xterm/xterm.dart';

class TerminalPage {
  final FocusNode focusNode;
  final Terminal terminal;
  const TerminalPage(this.focusNode, this.terminal);
}
