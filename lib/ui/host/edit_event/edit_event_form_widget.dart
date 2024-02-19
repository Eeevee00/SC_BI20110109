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
import 'edit_event_form_model.dart';
export 'edit_event_form_model.dart';
import '../../../updateLocation.dart';
import 'package:intl/intl.dart';
import '../../../data/models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_image.dart';


class EditEventFormWidget extends StatefulWidget {
  final Event event;
  const EditEventFormWidget({required this.event});

  @override
  _EditEventFormWidgetState createState() => _EditEventFormWidgetState();
}

class _EditEventFormWidgetState extends State<EditEventFormWidget> {
  late EditEventFormModel _model;

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
  var latitude;
  var longitude;

  var _image;
  late Event currentEvent;
  CollectionReference docEvent = FirebaseFirestore.instance.collection('event');

  var status = false;
  final EditProfileState _editProfileState = EditProfileState();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditEventFormModel());

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

    _model.textController1.text = widget.event.title!;
    _model.textController2.text = widget.event.phone!;
    _model.textController3.text = DateFormat('dd/MM/yyyy').format(widget.event.start_date!.toDate());
    _model.textController4.text = DateFormat('dd/MM/yyyy').format(widget.event.end_date!.toDate());
    _model.textController5.text = widget.event.start_time!;
    _model.textController6.text = widget.event.end_time!;
    _model.textController8.text = widget.event.location!['address'];
    _model.textController9.text = widget.event.description!;
    event_date_start = DateFormat('dd/MM/yyyy').format(widget.event.start_date!.toDate());
    event_date_end = DateFormat('dd/MM/yyyy').format(widget.event.end_date!.toDate());
    _initializeFirebase();
  }

  _initializeFirebase() async {
    return docEvent.doc(widget.event.uid).snapshots().listen((data) async {
      currentEvent = Event.fromDocument(data);
      var list = data['image'];
      var stringList = list.join("");
      setState(() {
        currentEvent = Event.fromDocument(data);
        _image = stringList;
      });
    });
  }

  Future<void> saveEvent() async {
    var event_uid = widget.event.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DateFormat dateFormat = DateFormat('dd/MM/yyyy');

        DateTime startDate = dateFormat.parse(_model.textController3.text);
        DateTime endDate = dateFormat.parse(_model.textController4.text);

        if(latitude == null && longitude == null){
          await firestore.doc('event/$event_uid').update({
              'title': _model.textController1.text,
              'phone': _model.textController2.text,
              'start_date': Timestamp.fromDate(startDate),
              'end_date': Timestamp.fromDate(endDate),
              'start_time': _model.textController5.text,
              'end_time': _model.textController6.text,
              'location': {
                'address': _model.textController8.text,
                'latitude': widget.event.location!['latitude'],
                'longitude': widget.event.location!['longitude'],
              },
              'description': _model.textController9.text,
          });

        }
        else{
          await firestore.doc('event/$event_uid').update({
              'title': _model.textController1.text,
              'phone': _model.textController2.text,
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
          });
        }

        Alert(
            context: context,
            type: AlertType.success,
            title: "Update Event",
            desc: "Successfully updated event",
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
        print('Error saving event details: $error');
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

      _model.textController3.text = DateFormat('dd/MM/yyyy').format(picked!.toLocal());
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
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Update Event Detail',
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
                        'Update Event Detail',
                        style:
                            FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                   fontSize: 20.0,
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
                                                height: 200.0,
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
                                                        context, currentEvent, true);
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
