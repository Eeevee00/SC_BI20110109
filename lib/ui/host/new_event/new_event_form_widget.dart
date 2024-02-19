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
import 'new_event_form_model.dart';
export 'new_event_form_model.dart';
import '../../../updateLocation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewEventFormWidget extends StatefulWidget {
  const NewEventFormWidget({Key? key}) : super(key: key);

  @override
  _NewEventFormWidgetState createState() => _NewEventFormWidgetState();
}

class _NewEventFormWidgetState extends State<NewEventFormWidget> {
  late NewEventFormModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();
  var title;
  var contact_number;
  //var category;
  var event_date_start;
  var event_date_end;
  var event_time_start;
  var event_time_end;
  var event_deadline;
  var description;
  var address;
  late var userLocation = "";
  double latitude = 0.0;
  double longitude = 0.0;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewEventFormModel());

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

    _model.textController9 ??= TextEditingController();
    _model.textFieldFocusNode9 ??= FocusNode();
  }

  Future<void> saveEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DateFormat dateFormat = DateFormat('dd/MM/yyyy');

        DateTime startDate = dateFormat.parse(_model.textController3.text);
        DateTime endDate = dateFormat.parse(_model.textController4.text);

        DocumentReference eventsRef = await firestore.collection('event').add({
            'title': _model.textController1.text,
            'phone': _model.textController2.text,
            //'category': _model.dropDownValueController!.value!,
            'start_date': Timestamp.fromDate(startDate),
            'end_date': Timestamp.fromDate(endDate),
            'start_time': _model.textController5.text,
            'end_time': _model.textController6.text,
            'location': {
              'address': _model.textController8.text,
              'latitude': latitude,
              'longitude': longitude,
            },
            'description': _model.textController9.text,
            'image': ['https://images.unsplash.com/photo-1517457373958-b7bdd4587205?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw2fHxldmVudHxlbnwwfHx8fDE3MDI2OTMwMzR8MA&ixlib=rb-4.0.3&q=80&w=1080'], 
            //'image': ['https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg'], 
            'uid': '', 
            //'deadline': FieldValue.serverTimestamp(),
            'status': false,
            'organizer_uid': prefs.getString("current_user_uid"),
            'organizer_name': prefs.getString("current_user_name"),
            'organizer_email': prefs.getString("current_user_email"),
            'organizer_image': prefs.getString("current_user_image"),
        });

        String eventUid = eventsRef.id;

        await eventsRef.update({'uid': eventUid});
        Alert(
            context: context,
            type: AlertType.success,
            title: "Add New Event",
            desc: "Successfully added new event",
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
        print('Event details saved successfully with UID: $eventUid');
    } catch (error) {
        print('Error saving event details: $error');
    } finally {
        setState(() {
          _isProcessing = false;
        });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  Future<void> _selectStartTime(BuildContext context) async {
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

  Future<void> _selectEndTime(BuildContext context) async {
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

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      if (selectedDate != null && picked.isBefore(selectedDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('End date cannot be before start date'),
          ),
        );
      } else {
        _model.textController4.text = DateFormat('dd/MM/yyyy').format(picked.toLocal());
      }
    }
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

      _model.textController3.text = DateFormat('dd/MM/yyyy').format(picked!.toLocal());
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
                'New Event',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
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
                        'Create New Event',
                        style:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                 fontSize: 20.0,

                                ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                        child: Center(
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 500),
                                imageUrl: 'https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg',
                                width: 250,
                                fit: BoxFit.cover,
                            ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                        child: Center(
                            child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                                Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                    'Update image once successfully added reward to confirm reward',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                    ),
                                    ),
                                ),
                                ),
                            ],
                            ),
                        ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Event Title',
                          hintText: 'Enter title',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                              return 'Please enter event title';
                            }
                            return null;
                          },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numeric input
                        decoration: InputDecoration(
                          labelText: 'Contact Number to Apply',
                          hintText: 'Enter phone number',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                          labelStyle: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryText,
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
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact number';
                            }
                            return null;
                          },
                      ),
                    ),
                    //Dropdown category
                    // Padding(
                    //   padding:
                    //       EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    //   child: FlutterFlowDropDown<String>(
                    //     controller: _model.dropDownValueController ??=
                    //         FormFieldController<String>(null),
                    //     options: [
                    //       'Category 1',
                    //       'Category 2',
                    //       'Category 3',
                    //       'Category 4',
                    //       'Category 5',
                    //       'Category 6',
                    //       'Category 7',
                    //       'Category 8',
                    //       'Category 9',
                    //       'Category 10'
                    //       ],
                    //     onChanged: (val) =>
                    //         setState(() => _model.dropDownValue = val),
                            
                    //     width: double.infinity,
                    //     height: 50.0,
                    //     textStyle: FlutterFlowTheme.of(context).bodyMedium,
                    //     hintText: 'Please select event category',
                    //     icon: Icon(
                    //       Icons.keyboard_arrow_down_rounded,
                    //       color: FlutterFlowTheme.of(context).primaryText,
                    //       size: 24.0,
                    //     ),
                    //     fillColor:
                    //         FlutterFlowTheme.of(context).primaryBackground,
                    //     elevation: 2.0,
                    //     borderColor:
                    //         FlutterFlowTheme.of(context).primaryBackground,
                    //     borderWidth: 2.0,
                    //     borderRadius: 8.0,
                    //     margin: EdgeInsetsDirectional.fromSTEB(
                    //         16.0, 4.0, 16.0, 4.0),
                    //     hidesUnderline: true,
                    //     isSearchable: false,
                    //     isMultiSelect: false,
                        
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context), // Function to open date picker
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _model.textController3,
                            focusNode: _model.textFieldFocusNode3,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Event Date (Start)',
                              hintText: 'Enter start date',
                              hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                              labelStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
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
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter when the event start';
                            }
                            return null;
                          },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: AbsorbPointer(
                          absorbing: true, 
                          child: TextFormField(
                            controller: _model.textController4,
                            focusNode: _model.textFieldFocusNode4,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Event Date (End)',
                              hintText: 'Enter end date',
                              hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                              labelStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
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
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter when the event end';
                            }
                            return null;
                          },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: GestureDetector(
                        onTap: () => _selectStartTime(context),
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextFormField(
                            controller: _model.textController5,
                            focusNode: _model.textFieldFocusNode5,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Event Time (Start)',
                              hintText: 'Enter event start time',
                              hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                              labelStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
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
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter what time the event start';
                            }
                            return null;
                          },
                          ),
                        ),
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
                        onTap: () => _selectEndTime(context),
                        decoration: InputDecoration(
                          labelText: 'Event Time (End)',
                          hintText: 'Enter event end time',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                          labelStyle: TextStyle( 
                            color: FlutterFlowTheme.of(context).primaryText,
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
                              return 'Please enter what time the event end';
                            }
                            return null;
                          },
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    //   child: TextFormField(
                    //     controller: _model.textController7,
                    //     focusNode: _model.textFieldFocusNode7,
                    //     obscureText: false,
                    //     decoration: InputDecoration(
                    //       labelText: 'Event Deadline',
                    //       hintText: 'Enter event deadline',
                    //       hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                    //       labelStyle: TextStyle( // Add this block for label text style
                    //         color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color:
                    //               FlutterFlowTheme.of(context).primaryBackground,
                    //           width: 2.0,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5.0),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: FlutterFlowTheme.of(context).primaryText,
                    //           width: 2.0,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5.0),
                    //       ),
                    //       errorBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Color(0x00000000),
                    //           width: 2.0,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5.0),
                    //       ),
                    //       focusedErrorBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Color(0x00000000),
                    //           width: 2.0,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5.0),
                    //       ),
                    //       filled: true,
                    //       fillColor:
                    //           FlutterFlowTheme.of(context).primaryBackground,
                    //     ),
                    //     style: FlutterFlowTheme.of(context).bodyMedium,
                    //     validator:
                    //         _model.textController7Validator.asValidator(context),
                    //   ),
                    // ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController8,
                        readOnly: true,
                        focusNode: _model.textFieldFocusNode8,
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
                            _model.textController8.text = address['PlaceName'];
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Event Venue',
                          hintText: 'Enter the venue',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                        minLines: 2,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event venue';
                            }
                            return null;
                          },
                      ),
                    ),
                    TextFormField(
                      controller: _model.textController9,
                      focusNode: _model.textFieldFocusNode9,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Event Description',
                        hintText: 'Enter description',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                              return 'Please enter event description';
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
                            await saveEvent();
                          }
                        },
                        text: 'Submit',
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
                                    fontSize: 18.0,
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
