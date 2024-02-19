import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ionicons/ionicons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'ui/flutter_flow/flutter_flow_theme.dart';
//import 'ui/flutter_flow/flutter_flow_util.dart';
//import 'ui/flutter_flow/flutter_flow_widgets.dart';
import 'package:location/location.dart' as loc;

class Test extends StatefulWidget {
  String userLocation;
  Test(this.userLocation);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  double a = 0;
  double b = 0;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controllerZ = TextEditingController();
  var latitude = 0.0;
  var longitude = 0.0;
  bool showMap = false;
  LatLng _center = const LatLng(0, 0);
  LatLng _lastMapPosition = const LatLng(0, 0);
  final Completer<GoogleMapController> _controller = Completer();
  var temLat = 0.0;
  var temLon = 0.0;    
  var newPosition;
  bool initEx = true;
  bool initEx2 = true;
  bool initEx3 = true;
  var newAddress;
  var _newAddress;
  final FocusNode _focusNode = FocusNode();
  var addresses;

  @override
  void initState() {
    getLocationCoordinates().then((updateAddress) {
      setState(() {
        _newAddress = updateAddress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _getUserLocation(lat, long) async {
    setState(() {
      _center = LatLng(lat, long);
    });
  }

  Future<void> _goToNewLocation(lat, long) async {

    CameraPosition _newPos = CameraPosition(
      target: LatLng(lat, long),
      zoom: 15);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_newPos));
  }

  checkString()async{
    return Alert(
  context: context,
  type: AlertType.warning,
  title: "Is this your location?",
  desc: "This location will be selected",
  buttons: [
    DialogButton(
      child: Text(
        "Confirm",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () async {

        var addresses = await Geocoder.local.findAddressesFromQuery(controllerZ.text);
        var first;
        if (addresses.isNotEmpty) {
          first = addresses.first;
          temLat = first.coordinates.latitude;
          temLon = first.coordinates.longitude;
        } else {
          print('No addresses found.');
        }

        setState(() {
          controller.text = "Address: ${first.featureName}";
          controller2.text = "Latitude: ${first.coordinates.latitude}";
          controller3.text = "Longitude: ${first.coordinates.longitude}";
          if (controllerZ.text.isEmpty) {
            controller.text = "";
            controller2.text = "";
            controller3.text = "";
          }
          latitude = temLat;
          longitude = temLon;
          _getUserLocation(latitude, longitude);
        });

        _goToNewLocation(latitude, longitude);

        initEx = true;
        Navigator.pop(context);
      },
      color: Color.fromRGBO(0, 179, 134, 1.0),
    ),
    DialogButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(context),
      gradient: LinearGradient(colors: const [
        Color.fromRGBO(116, 116, 191, 1.0),
        Color.fromRGBO(52, 138, 199, 1.0)
      ]),
    )
  ],
).show();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                'Search Location',
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
      body: SingleChildScrollView(
        
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              elevation: 10,
              child: ExpansionTile(
                key: UniqueKey(),
                initiallyExpanded: initEx3,
                leading: Text(
                  "Your current location save is",
                  style: TextStyle(
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                title: Text(
                  "",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <Widget>[
                  SizedBox(
                    height: 60, // Adjust the height as needed
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Text(
                              widget.userLocation,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              maxLines: 2, // Limit to two lines
                              overflow: TextOverflow.ellipsis, // Handle overflow
                              softWrap: true, // Enable wrapping
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              elevation: 10,
              child: ExpansionTile(
                key: UniqueKey(),
                initiallyExpanded: initEx2,
                leading: Text(
                  "Update location using GPS",
                  style: TextStyle(
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                title: Text(
                  "",
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <Widget>[
                  SizedBox(
                    height: 60, // Adjust the height as needed
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                          // title: Text(
                          //   "Use current location:",
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     color: FlutterFlowTheme.of(context).primaryText,
                          //   ),
                          // ),
                          title: Text(
                            _newAddress != null
                                ? _newAddress['PlaceName'] ?? 'Fetching..'
                                : 'Unable to load...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize:14.0,
                            ),
                          ),
                          leading: Icon(
                            Icons.location_searching_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          onTap: () async {
                            if (_newAddress == null) {
                              await getLocationCoordinates().then((updateAddress) {
                                print(updateAddress);
                                setState(() {
                                  _newAddress = updateAddress;
                                });
                              });
                            } else {
                              Navigator.pop(context, _newAddress);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 10,
                  child: ExpansionTile( // chevron-down
                    key: UniqueKey(),
                    initiallyExpanded: initEx,
                    leading: Text(
                      "Search Your location address",
                      style: TextStyle(
                        fontSize: 16,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    title: Text(
                      "",
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Card(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: controllerZ,
                                style: TextStyle( // Add this block for label text style
                                    color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                  ),
                                decoration: InputDecoration(
                                  labelText: 'Enter your address',
                                  labelStyle: TextStyle( // Add this block for label text style
                                    color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,

                                  ),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:FlutterFlowTheme.of(context).primaryBackground,
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
                                ),
                              ),
                            GFButton(
                              onPressed: checkString,
                              text: "Search Address",
                              color: FlutterFlowTheme.of(context).primaryText,
                              fullWidthButton: true,
                              textStyle: TextStyle(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,

                              ),
                            ),

                            ],
                          ),
                        ),
                      ),
                      latitude == 0 && longitude == 0 ? Container(child: Center(child:Text('', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : 
                      Container(
                        padding: new EdgeInsets.all(6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container(
                            //   color: Colors.red,
                            //   height:200,
                            //   width: 1000,
                            //   child: GoogleMap(
                            //     mapType: MapType.normal,
                            //     initialCameraPosition: CameraPosition(
                            //       target: _center,
                            //       zoom: 15,
                            //     ),  
                            //     onMapCreated: _onMapCreated,
                            //     zoomGesturesEnabled: true,
                            //     onCameraMove: _onCameraMove,
                            //     myLocationEnabled: true,
                            //     compassEnabled: true,
                            //     myLocationButtonEnabled: false,
                            //   )
                            // ),
                            TextField(
                              controller: controller,
                              readOnly: true,
                              style: TextStyle( // Add this block for label text style
                                    color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                  ),
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Address',
                                hintStyle: TextStyle(fontSize: 14.0, color: FlutterFlowTheme.of(context).primaryText),
                              ),
                            ),
                            TextField(
                              controller: controller2,
                              style: TextStyle( // Add this block for label text style
                                    color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                  ),
                              readOnly: true,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Latitude',
                                hintStyle: TextStyle(fontSize: 14.0, color: FlutterFlowTheme.of(context).primaryText),
                              ),
                            ),
                            TextField(
                              controller: controller3,
                              style: TextStyle( // Add this block for label text style
                                    color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                  ),
                              readOnly: true,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Longitude',
                                hintStyle: TextStyle(fontSize: 14.0, color: FlutterFlowTheme.of(context).primaryText),
                              ),
                            ),
                            GFButton(
                                onPressed: () async {
                                  _newAddress = await coordinatesToAddress(
                                    latitude: temLat,
                                    longitude: temLon,
                                  );
                                  Navigator.pop(context, _newAddress);
                                },
                                text: "Save Address",
                                color: FlutterFlowTheme.of(context).primaryText,
                                fullWidthButton: true,
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),  
          ],
        ),
      ),),
    );
  }
}

Future<Map> getLocationCoordinates() async {
    loc.Location location = loc.Location();
    try {
      await location.serviceEnabled().then((value) async {
        if (!value) {
          await location.requestService();
        }
      });
      final coordinates = await location.getLocation();
      return await coordinatesToAddress(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
    } catch (e) {
      print(e);
      return await coordinatesToAddress(
        latitude: 0,
        longitude: 0,
      );
    }
  }

  Future coordinatesToAddress({latitude, longitude}) async {
    try {
      Map<String, dynamic> obj = {};
      final coordinates = Coordinates(latitude, longitude);
      List<Address> result =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      //String currentAddress =
        // "${result.first.addressLine ?? ''}";
        // "${result.first.subLocality ?? ''} ,${result.first.locality ?? ''}  ${result.first.subAdminArea ?? ''} ${result.first.postalCode ?? ''} ,${result.first.countryName ?? ''} ";
        // "${result.first.subThoroughfare ?? ''},${result.first.subLocality ?? ''},${result.first.locality ?? ''},${result.first.adminArea ?? ''}";
        // "${result.first.subLocality ?? ''},${result.first.locality ?? ''},${result.first.adminArea ?? ''}";
      String currentAddress = "${result.first.subLocality ?? ''}"
          "${result.first.subLocality != null ? ',' : ''}"
          "${result.first.locality ?? ''}"
          "${result.first.locality != null ? ',' : ''}"
          "${result.first.adminArea ?? ''}";



      print(currentAddress);
      obj['PlaceName'] = currentAddress;
      obj['latitude'] = latitude;
      obj['longitude'] = longitude;

      return obj;
    } catch (_) {
      print(_);
      return null;
    }
  }