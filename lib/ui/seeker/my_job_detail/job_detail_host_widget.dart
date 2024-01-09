import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'job_detail_host_model.dart';
export 'job_detail_host_model.dart';
import 'dart:async';
import '../../../data/models/job_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../host/job_applicant_list/applicant_list_widget.dart';

import '../../host/review_job/review.dart';
import '../../host/ticket_list/ticket_list_screen_widget.dart';

import '../../host/edit_job/edit_job_form_widget.dart';
import '../job_application/job_application_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobDetailHostWidget extends StatefulWidget {
  final Jobs job;
  const JobDetailHostWidget({required this.job});

  @override
  _JobDetailHostWidgetState createState() => _JobDetailHostWidgetState();
}

class _JobDetailHostWidgetState extends State<JobDetailHostWidget> {
  late JobDetailHostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var status = false;
  var _image;
  var title;
  var start_date;
  var end_date;
  var start_time;
  var end_time;
  var address;
  var name;
  var phone;
  var email;
  var description;

  var user_uid;

  var status_apply = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobDetailHostModel());
    status = widget.job.status!;
    _image = widget.job.image;
    title = widget.job.title!;
    start_date = widget.job.date;
    start_time = widget.job.start_time!;
    end_time = widget.job.end_time!;
    address = widget.job.location!['address'];
    name = widget.job.organizer_name!;
    phone = widget.job.phone!;
    email = widget.job.organizer_email!;
    description = widget.job.description!;
    checkApplication();
  }

  checkApplication()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var job_uid = widget.job.uid;
    var user_uid = prefs.getString("current_user_uid");

    // Reference to the job document
    var jobReference = FirebaseFirestore.instance.collection('job').doc(job_uid);

    var participantsReference = jobReference.collection('participant');

    // Fetch the job document
    var jobSnapshot = await jobReference.get();

    if (jobSnapshot.exists) {
      var participantSnapshot = await participantsReference
          .where('uid', isEqualTo: user_uid)
          .limit(1)
          .get();

      if (participantSnapshot.docs.isNotEmpty) {
        setState(() {
          status_apply = true;
        });
        
        print('Participant found');
      } else {
        setState(() {
          status_apply = false;
        });
        print('Participant not found');
      }
    } else {
      print('Job not found');
    }
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
  }

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    
    return formattedDate;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  getJobDetail() async {
    var job_uid = widget.job.uid;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Assuming 'tickets' is the collection and 'ticket_uid' is the document ID
      DocumentSnapshot jobDoc = await firestore.doc('/job/$job_uid').get();

      if (jobDoc.exists) {
        // Access the data from the document
        Map<String, dynamic> jobData = jobDoc.data() as Map<String, dynamic>;

        setState(() {
          _image = jobData['image'];
          title = jobData['title'];
          start_date = jobData['date'];
          end_date = jobData['end_date'];
          start_time = jobData['start_time'];
          end_time = jobData['end_time'];
          address = jobData['location']['address'];
          name = jobData['organizer_name'];
          phone = jobData['phone'];
          email = jobData['organizer_email'];
          description = jobData['description'];
        });
      } else {
        print('Job document does not exist');
      }
    } catch (error) {
      print('Error fetching ticket details: $error');
    }
  }

  void deleteJob() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete Job",
      desc: "Are you sure you want to delete this job?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);

            await FirebaseFirestore.instance.collection('job').doc(widget.job.uid).delete();

            Alert(
              context: context,
              type: AlertType.success,
              title: "Job Deleted",
              desc: "The job has been successfully deleted.",
              buttons: [
                DialogButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ).show();
          },
        ),
      ],
    ).show();
  }


  void changeStatusJob(bool currentStatus) async {
    bool newStatus = !currentStatus;

    try {
      await FirebaseFirestore.instance.collection('job').doc(widget.job.uid).update({
        'status': newStatus,
      });

      String statusMessage = newStatus ? "active" : "inactive";
      setState(() {
          status = newStatus;
      });

      // Show a success message
      Alert(
        context: context,
        type: AlertType.success,
        title: "Status Updated",
        desc: "The job is now $statusMessage.",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ).show();
    } catch (error) {
      // Show an error message if update fails
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Failed to update job status. Please try again.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ).show();
    }
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
            'Job Detail',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      image(_image),
                      width: double.infinity,
                      height: 240.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toString(),
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 20.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor1,
                                      size: 36.0,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Text(
                                          formatTimestamp(start_date),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Text(
                                          start_time + " - " + end_time,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: FlutterFlowTheme.of(context).customColor1,
                                      size: 36,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address,
                                      maxLines: 3,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).customColor1,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 20.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          widget.job.organizer_image!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Text(
                                          name!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Text(
                                              'Organizer',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 20.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 8.0, 0.0),
                                          child: Icon(
                                            Icons.phone,
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                            size: 24.0,
                                          ),
                                        ),
                                        Text(
                                          phone!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 8.0, 0.0),
                                        child: Icon(
                                          Icons.email,
                                          color: FlutterFlowTheme.of(context)
                                              .customColor1,
                                          size: 24.0,
                                        ),
                                      ),
                                      Text(
                                        email!,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            'About Job',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            widget.job.description!,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 16.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if(status_apply == true){
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "Job Applied",
                                  desc: "You already send application to apply for this job, someone will reach you once your application have been review.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Close",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ).show();
                              }
                              else{
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobApplicationWidget(),
                                  ),
                                );
                              }
                            },
                            text: 'Apply This Job',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 4.0,
                                  ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(eventID: widget.job.uid!),
                                ),
                              );
                            },
                            text: 'View Feedback/rating',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 4.0,
                                  ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
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
