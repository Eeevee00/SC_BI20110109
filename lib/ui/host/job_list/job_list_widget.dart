import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'job_list_model.dart';
export 'job_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import '../../../data/models/job_model.dart';
import '../../../search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/skeleton_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../feedback_detail_screen/feedback_detail_screen_widget.dart';
import 'package:intl/intl.dart';

import '../new_job/new_job_form_widget.dart';

import '../job_detail/job_detail_host_widget.dart';

class JobListScreenWidget extends StatefulWidget {
  final String uid;
  const JobListScreenWidget({required this.uid});

  @override
  _JobListScreenWidgetState createState() =>
      _JobListScreenWidgetState();
}

class _JobListScreenWidgetState
    extends State<JobListScreenWidget> {
  late JobListScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  CollectionReference docJobs = FirebaseFirestore.instance.collection('job');
  List<Jobs> jobs = [];
  List<Jobs> jobList = [];

  @override
  void initState() {
    getJobList();
    super.initState();
    _model = createModel(context, () => JobListScreenModel());
    init();
      getJobList();

  }

  @override
  void dispose() {
    _model.dispose();
    debouncer?.cancel();
    super.dispose();
  }
  

  getJobList() async {
    jobList.clear();
    jobs.clear();
    try {
      var data = await db.collection('/job').where('organizer_uid', isEqualTo: widget.uid).get();

      if (data.docs.isEmpty) {
        init();
        jobs.clear();
        jobList.clear();
        print('No jobs available');
        return;
      }

      jobList.clear();

      for (var doc in data.docs) {
        Jobs? temp = Jobs.fromDocument(doc);
        jobList.add(temp);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error getting jobs: $error');
    }
  }
    
  init(){
    final list = jobList;
    setState(() => this.jobs = list);
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    
    return formattedDate;
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");

    return stringList;
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
            'Job List',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //New Job Button
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 30.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewJobFormWidget(),
                              ),
                            );
                            getJobList();
                          },
                          text: 'New Job',
                          options: FFButtonOptions(
                            width: 130.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primaryText,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                            elevation: 2.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Search and Job List
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 24.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,

                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'Job List',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall,
                                    ),
                                  ),
                                  buildSearch(),

                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.63,
                                          //width: MediaQuery.of(context).size.width * 0.85,
                                          child: ListView.builder(
                                            itemCount: jobs.length,
                                            itemBuilder: (context, index) {
                                              final noti = jobs[index];
                                              return buildJob(noti);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                

                                SizedBox(height: 20.0,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Job Name or Location',
    onChanged: searchJob,
  );

  void searchJob(String query) {
    final notify = jobList.where((notify) {
    final title = notify.title!.toLowerCase();
    final address = notify.location!['address']!.toLowerCase();
    final searchLower = query.toLowerCase();

    return title.contains(searchLower) || address.contains(searchLower) ;
    }).toList();

    setState(() {
      this.query = query;
      this.jobs = notify;
    });
  }

  Widget buildJob(Jobs job) => 
  Padding(
    padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0), // Size of container 
    child: InkWell(
      // onTap: () async {
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => JobDetailHostWidget(job: job),
      //     ),
      //   );
      //   getJobList();
      // },

      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailHostWidget(job: job),
          ),
        );

        // Check if the result is not null and update the state accordingly.
        if (result != null) {
          getJobList();
        }
      },
      child: Stack(
        children: [
          //The whole container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 0.0,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  offset: Offset(0.0, 1.0),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 220.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,                     
                        image: Image.network('',).image,
                      ),
                      borderRadius:BorderRadius.circular(24.0),
                    ),
                    child: Stack(
                      children: [
                        // Image as bg
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                              child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 5.0,
                                  ),
                                  child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      borderRadius: BorderRadius.circular(12.0), // Make sure to match the outer radius
                                      image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(image(job.image!)),
                                      ),
                                  ),
                                  ),
                              ),
                          ),

                        //Gradient Container
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  FlutterFlowTheme.of(context).primaryBackground.withOpacity(0.7),
                                ],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize:MainAxisSize.max,
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  // Job title
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                    child: Row(
                                      mainAxisSize:MainAxisSize.max,
                                      children: [
                                        Icon(Icons.event_rounded,
                                          color: FlutterFlowTheme.of(context).customColor1,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            job.title!,
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  fontFamily:'Outfit',
                                                  color: FlutterFlowTheme.of(context).customColor1,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Job description
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                      child: Text(
                                        job.description!,
                                        textAlign:TextAlign.start,
                                        maxLines: 2,
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily:'Outfit',
                                              color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                      ),
                                  ),

                                  //Salary
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Salary',
                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily:'Outfit',
                                                  color: FlutterFlowTheme.of(context).customColor1,
                                                ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                            child: Text(
                                              "RM" + (job.salary ?? ''),
                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily:'Outfit',
                                                  color: FlutterFlowTheme.of(context).customColor1,
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ),

                                  // Time
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize:MainAxisSize.max,
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Time',
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily:'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
                                              ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                            child: Text(
                                              job.start_time! + " - " + job.end_time!,
                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                    fontFamily:'Outfit',
                                                    color: FlutterFlowTheme.of(context).customColor1,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ),

                                  //Date
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize:MainAxisSize.max,
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Date',
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily:'Outfit',
                                              color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                          child: Text(
                                            formatTimestamp(job.start_date) + " - " + formatTimestamp(job.end_date),
                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily:'Outfit',
                                                  color: FlutterFlowTheme.of(context).customColor1,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Location
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize:MainAxisSize.max,
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Location',
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily:'Outfit',
                                              color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                        ),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                                    child: Text(
                                                                job.location?['address'],
                                                                textAlign: TextAlign.end,
                                                                maxLines: 2,
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      fontFamily:'Outfit',
                                                                      color: FlutterFlowTheme.of(context).customColor1,
                                                                    ),
                                                                ),
                                                          ),
                                                  ),
                                      ],
                                    ),
                                  ),

                                  // Row(
                                  //   mainAxisSize:
                                  //       MainAxisSize.max,
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment
                                  //           .spaceBetween,
                                  //   children: [
                                  //     Padding(
                                  //       padding:
                                  //           EdgeInsetsDirectional
                                  //               .fromSTEB(
                                  //                   0.0,
                                  //                   16.0,
                                  //                   0.0,
                                  //                   0.0),
                                  //       child:
                                  //           FFButtonWidget(
                                  //         onPressed: () async {
                                  //           await Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //               builder: (context) => JobDetailHostWidget(job: job),
                                  //             ),
                                  //           );
                                  //           getJobList();
                                  //         },
                                  //         text: 'Detail',
                                  //         options:
                                  //             FFButtonOptions(
                                  //           width: 150.0,
                                  //           height: 44.0,
                                  //           padding:
                                  //               EdgeInsetsDirectional
                                  //                   .fromSTEB(
                                  //                       0.0,
                                  //                       0.0,
                                  //                       0.0,
                                  //                       0.0),
                                  //           iconPadding:
                                  //               EdgeInsetsDirectional
                                  //                   .fromSTEB(
                                  //                       0.0,
                                  //                       0.0,
                                  //                       0.0,
                                  //                       0.0),
                                  //           color: FlutterFlowTheme.of(
                                  //                   context)
                                  //               .primaryText,
                                  //           textStyle: FlutterFlowTheme.of(
                                  //                   context)
                                  //               .titleSmall
                                  //               .override(
                                  //                 fontFamily:
                                  //                     'Outfit',
                                  //                 color: FlutterFlowTheme.of(
                                  //                         context)
                                  //                     .secondaryBackground,
                                  //               ),
                                  //           elevation: 0.0,
                                  //           borderRadius:
                                  //               BorderRadius
                                  //                   .circular(
                                  //                       12.0),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),

                                ],
                              ),
                            ),
                          ),

                      ],
                    ),
                  ),//349
                ),
            ),

          ),

          //Status: Active /inactive 
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              width: 70.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(0.0),
                ),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                child: Text(
                job.status! ? 'Active' : 'Inactive',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    ),
                ),
              ),
            ),
          ),

        ],
    )
    ),
  );


}
