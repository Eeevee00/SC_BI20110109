import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  TextEditingController? nameFieldController;
  String? Function(BuildContext, String?)? nameFieldControllerValidator;
  // State field(s) for emailAddress widget.
  TextEditingController? emailFieldController;
  String? Function(BuildContext, String?)? emailFieldControllerValidator;
  // State field(s) for emailAddress widget.
  TextEditingController? phoneFieldController;
  String? Function(BuildContext, String?)? phoneFieldControllerValidator;
  // State field(s) for emailAddress widget.
  TextEditingController? iCFieldController;
  String? Function(BuildContext, String?)? iCFieldControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    nameFieldController?.dispose();
    emailFieldController?.dispose();
    phoneFieldController?.dispose();
    iCFieldController?.dispose();
  }

  /// Additional helper methods are added here.

}
