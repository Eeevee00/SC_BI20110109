import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/form_field_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_job_form_model.dart';
export 'edit_job_form_model.dart';
import '../../../updateLocation.dart';
import 'package:intl/intl.dart';
import '../../../data/models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_image.dart';

class EditJobFormWidget extends StatefulWidget {
  final Jobs job;
  const EditJobFormWidget({required this.job});

  @override
  _EditJobFormWidgetState createState() => _EditJobFormWidgetState();
}

class _EditJobFormWidgetState extends State<EditJobFormWidget> {
  late EditJobFormModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();

  var title;
  var contact_number;
  var category;
  var event_date_start;
  var event_date_end;
  var event_time_start;
  var event_time_end;
  var event_deadline;
  var description;
  var address;
  late var userLocation = "";
  var latitude;
  var longitude;

  var _image;
  late Jobs currentJob;
  CollectionReference docJob = FirebaseFirestore.instance.collection('job');

  var status = false;
  final EditProfileState _editProfileState = EditProfileState();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditJobFormModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??= TextEditingController();
    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??= TextEditingController();
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController1.text = widget.job.title!;
    _model.textController2.text = widget.job.salary!;
    _model.textController3.text = widget.job.phone!;
    _model.textController4.text = DateFormat('dd/MM/yyyy').format(widget.job.date!.toDate());
    _model.textController5.text = widget.job.start_time!;
    _model.textController6.text = widget.job.end_time!;
    _model.textController7.text = widget.job.location!['address'];
    _model.textController8.text = widget.job.description!;
    
    _initializeFirebase();
  }

  _initializeFirebase() async {
    return docJob.doc(widget.job.uid).snapshots().listen((data) async {
      currentJob = Jobs.fromDocument(data);
      var list = data['image'];
      var stringList = list.join("");
      setState(() {
        currentJob = Jobs.fromDocument(data);
        _image = stringList;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> updateJob() async {
    var job_uid = widget.job.uid;
    

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DateFormat dateFormat = DateFormat('dd/MM/yyyy');

        DateTime startDate = dateFormat.parse(_model.textController4.text);

        if(latitude == null && longitude == null){
          await firestore.doc('job/$job_uid').update({
              'date': Timestamp.fromDate(startDate),
              'start_time': _model.textController6.text,
              'end_time': _model.textController5.text,
              'description': _model.textController8.text,
              'location': {
                'address': _model.textController7.text,
                'latitude': widget.job.location!['latitude'],
                'longitude': widget.job.location!['latitude'],
              },
              'title': _model.textController1.text,
              'salary': _model.textController2.text,
              'phone': _model.textController3.text,
              'organizer_phone': _model.textController3.text,
          });
        }
        else{
          await firestore.doc('job/$job_uid').update({
              'date': Timestamp.fromDate(startDate),
              'start_time': _model.textController6.text,
              'end_time': _model.textController5.text,
              'description': _model.textController8.text,
              'location': {
                'address': _model.textController7.text,
                'latitude': latitude,
                'longitude': longitude,
              },
              'title': _model.textController1.text,
              'salary': _model.textController2.text,
              'phone': _model.textController3.text,
              'organizer_phone': _model.textController3.text,
          });
        }

        Alert(
            context: context,
            type: AlertType.success,
            title: "Update Job",
            desc: "Successfully update job",
            buttons: [
            DialogButton(
                child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: const Color(0xFFEE8B60),
                onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                },
                width: 120,
            )
            ],
        ).show();
        
    } catch (error) {
        print('Error saving job details: $error');
    } finally {
        setState(() {
          _isProcessing = false;
        });
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null){
      setSelectedDate(picked);
      print(picked);

      _model.textController4.text = DateFormat('dd/MM/yyyy').format(picked!.toLocal());
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Handle the selected time, e.g., update the text field
      String formattedTime = pickedTime.format(context);
      _model.textController6.text = formattedTime;
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Handle the selected time, e.g., update the text field
      String formattedTime = pickedTime.format(context);
      _model.textController5.text = formattedTime;
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
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Update Job',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _registerFormKey,
                child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 20.0),
                    child: Text(
                      'Update Job Detail',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                    ),
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 120,
                                    backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                    child: Material(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      child: Stack(
                                        children: <Widget>[
                                          _image == "Empty" ? 
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Image.network(
                                                'https://user-images.githubusercontent.com/43302778/106805462-7a908400-6645-11eb-958f-cd72b74a17b3.jpg',
                                                width: double.infinity,
                                                height: 160.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          )
                                          :
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Image.network(
                                                _image,
                                                width: double.infinity,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30)),
                                              color: Theme.of(context).primaryColor,
                                              child: IconButton(
                                                  alignment: Alignment.center,
                                                  icon: Icon(
                                                    Icons.photo_camera,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    var a = await _editProfileState.source(
                                                        context, currentJob, true);
                                                    _initializeFirebase();
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.textController1,
                      focusNode: _model.textFieldFocusNode1,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Job Title',
                        hintText: 'Enter title',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                        labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter job title';
                            }
                            return null;
                          },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.textController2,
                      focusNode: _model.textFieldFocusNode2,
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Job Salary Per Hour',
                        hintText: 'Enter salary per hour',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                        labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter salary per hour';
                            }
                            return null;
                          },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.textController3,
                      focusNode: _model.textFieldFocusNode3,
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Contact Number to Apply',
                        hintText: 'Enter phone number',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                        labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact number to apply';
                            }
                            return null;
                          },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.textController4,
                      focusNode: _model.textFieldFocusNode4,
                      obscureText: false,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'Job Available Date',
                        hintText: 'Enter job date',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                        labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the date this job available';
                            }
                            return null;
                          },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.textController6,
                      focusNode: _model.textFieldFocusNode6,
                      obscureText: false,
                      readOnly: true,
                      onTap: () => _selectStartTime(context),
                      decoration: InputDecoration(
                        labelText: 'Job Working Hour (Start)',
                        hintText: 'Enter start working hour',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                        labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter start working hour';
                            }
                            return null;
                          },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: TextFormField(
                      controller: _model.textController5,
                      focusNode: _model.textFieldFocusNode5,
                      obscureText: false,
                      readOnly: true,
                        onTap: () => _selectEndTime(context),
                      decoration: InputDecoration(
                        labelText: 'Job Working Hour (End)',
                        hintText: 'Enter end working hour',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                        labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter end of the working hour';
                            }
                            return null;
                          },
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController7,
                        readOnly: true,
                        focusNode: _model.textFieldFocusNode7,
                        obscureText: false,
                        onTap: () async {
                          address = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Test(userLocation),
                            ),
                          );

                          if (address != null) {
                            setState(() {
                              print(address['PlaceName']);
                              print(address['latitude']);
                              print(address['longitude']);
                              // address = address['PlaceName'];
                              latitude = address['latitude'];
                              longitude = address['longitude'];
                              //userLocation = address['PlaceName'];
                            });
                            _model.textController7.text = address['PlaceName'];
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Event Venue',
                          hintText: 'Enter the venue',
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          labelStyle: TextStyle( // Add this block for label text style
                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  FlutterFlowTheme.of(context).primaryBackground,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        maxLines: 10,
                        minLines: 5,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event venue';
                            }
                            return null;
                          },
                      ),
                    ),
                  TextFormField(
                    controller: _model.textController8,
                    focusNode: _model.textFieldFocusNode8,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Job Description',
                      hintText: 'Enter description',
                      hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                      labelStyle: TextStyle( // Add this block for label text style
                          color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                        ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryText,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    maxLines: 10,
                    minLines: 5,
                    validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter job description';
                            }
                            return null;
                          },
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_registerFormKey.currentState?.validate() ?? false) {
                            await updateJob();
                          }
                      },
                      text: 'Update',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 55.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  fontSize: 14.0,
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
          ),
        ),
      ),
    );
  }
}
