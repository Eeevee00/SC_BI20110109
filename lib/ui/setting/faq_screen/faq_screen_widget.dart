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
                  fontSize: 20.0,
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
            child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is MuzikLokal?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'MuzikLokal is a centralized app where music discovery and music talent scouting are made possible. Whether you\'re a seeker that is looking for local events or performing gigs, or host that creates event and job opportunities, we are here to bridge the gaps! Join us in this music gamification journey.' ,
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
                        fontSize: 18.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'Navigate to the \"Event List\" tab to explore a curated list of local music events and gigs. You can use the search bar to find exactly what you\'re looking for. After buying your ticket, event will be added into \"My Event\". Seeker will gain points for every succesful ticket buying.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),

                Text(
                  'How can I discover local job opportunities?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'Navigate to the \"Job List\" tab to explore a curated list of local job openings and performing slots. You can use the search bar to find exactly what you\'re looking for. After submitting your application, job will be added into \"My Job\". Seeker will gain points for every applicantion being approved.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),

                 Text(
                  'How can I create local music events?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'Navigate to the \"Event\" tab to create a music event or gigs. After creating an event post, event can be seen under \"Event List\". Then ticket creation can be made accordingly. Make sure to update picture and and activate event status once details are fill properly. Host gain points for every ticket sold succesfully.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                          fontSize: 14.0,
                        ),
                  ),
                ),

                Text(
                  'How can I create local job opportunities?',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'Navigate to the \"Job\" tab to create a job opening or performing slot. After creating a job post, job can be seen under \"Job List\".  Make sure to update picture and and activate job status once details are fill properly. Host can then view a list of applicant and approve/reject applicants. Host gain points for every approval.',
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
                        fontSize: 18.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                  child: Text(
                    'If you encounter any issues or have feedback to share, please use the \"Help\" option in the app settings. Our support team will review and get back to you as soon as possible.',
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
      ),
    );
  }
}
