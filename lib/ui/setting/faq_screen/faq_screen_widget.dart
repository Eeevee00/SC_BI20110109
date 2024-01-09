import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'faq_screen_model.dart';
export 'faq_screen_model.dart';

class FaqScreenWidget extends StatefulWidget {
  const FaqScreenWidget({Key? key}) : super(key: key);

  @override
  _FaqScreenWidgetState createState() => _FaqScreenWidgetState();
}

class _FaqScreenWidgetState extends State<FaqScreenWidget> {
  late FaqScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FaqScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'FAQ',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is Muzik Local?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'Muzik Local is a music discovery app that connects you with local artists and events in your area. Discover new music, find local gigs, and connect with fellow music enthusiasts.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),
                Text(
                  'How do I download and install Muzik Local?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'To download Muzik Local, visit the App Store (iOS) or Google Play Store (Android) on your device. Search for \"Muzik Local\" and follow the on-screen instructions to install the app.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),
                Text(
                  'How can I discover local music events?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'Navigate to the \"Events\" tab to explore a curated list of local music events, concerts, and gigs. You can filter events by genre, date, and location to find exactly what you\'re looking for.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),
                Text(
                  'How can I report issues or provide feedback?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'If you encounter any issues or have feedback to share, please use the \"Help\" option in the app settings. Our support team is here to assist you.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
