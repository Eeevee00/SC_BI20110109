import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:getwidget/getwidget.dart';

class Tab1 extends StatefulWidget {
  final String? eventID;

  const Tab1({Key? key, required this.eventID}) : super(key: key);


  @override
  _Tab1State createState() {
    return _Tab1State();
  }
}

class _Tab1State extends State<Tab1> {
  final db = FirebaseFirestore.instance;
  late User _currentUser;
  late var uid;
  var paymentHistory;

  _initializeFirebase() async {
    paymentHistory = db.collection("event").doc(widget.eventID).collection('reviews').orderBy('timestamp', descending: true).snapshots();
  }

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: Align(
            alignment: Alignment.center,
            child: Column(
                  children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: paymentHistory,
                        builder: (context, AsyncSnapshot snapshot) {
                          if(!snapshot.hasData){
                            return CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    );
                          }
                          else if(snapshot.hasData && snapshot.data.docs.isEmpty) {
                            return  Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top: 32.0),
                                        child: Text(
                                            'No review have been made yet.',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                        ),
                                    )
                                ],
                              ),
                            );
          
                          }
                          else  {
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.only(top: 24),
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds = snapshot.data.docs[index];
                                  return Container(
                                    child: Column(
                                      children:<Widget>[
                                        ListTile(
                                          title: Text(
                                            ds["name"] + " " + ds["lastName"],
                                            style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                          ),
                                          leading: GFAvatar(
                                            backgroundImage:NetworkImage(ds["userImage"]),
                                          ),
                                          subtitle: Align(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: RatingBarIndicator(
                                                      unratedColor: Colors.grey.shade900,
                                                      itemSize: 12,
                                                      rating: ds["rating"].toDouble(),
                                                      itemBuilder: (context, index) => Icon(
                                                        Ionicons.star,
                                                        color: Colors.yellow,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 2.0),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      ds["title"],
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
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 12.0),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      ds["content"],
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                    )
                                  );
                                },
                            );
                          }
                        },
                      )    
                  ],
            )
        ),
      )
    );
  }
}
