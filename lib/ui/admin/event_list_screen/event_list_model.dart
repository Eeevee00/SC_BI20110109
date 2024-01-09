import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'event_list_widget.dart' show EventListScreenWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventListScreenModel
    extends FlutterFlowModel<EventListScreenWidget> {
  final unfocusNode = FocusNode();
  void initState(BuildContext context) {}
  void dispose() {
    unfocusNode.dispose();
  }
}
