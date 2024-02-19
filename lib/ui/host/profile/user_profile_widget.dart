//User editable profile mode

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Store image
import 'package:firebase_messaging/firebase_messaging.dart';

import '../profile_update/update_profile_user_widget.dart';
import '../edit_password/reset_password_screen_widget.dart';

import 'package:image/image.dart' as i;                 // Image
import 'package:image_cropper/image_cropper.dart';      // Image
import 'package:image_picker/image_picker.dart';        // Image
import 'package:path_provider/path_provider.dart';      // Image
import 'package:cached_network_image/cached_network_image.dart';
//import '../../editprofile.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/shared_pref.dart';
import 'user_profile_model.dart';
export 'user_profile_model.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({Key? key}) : super(key: key);
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> with TickerProviderStateMixin {
  late UserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Users currentUser;

  var uid;
  var bio;
  var email;
  var image = "Empty";
  var address;
  var name;
  var phone;
  var point;
  var tier;
  bool verification = false;
  ImagePicker picker = ImagePicker();
  SharedPref sharedPref = SharedPref();
  CollectionReference docUser = FirebaseFirestore.instance.collection('users'); //Helper
  //final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _model = createModel(context, () => UserProfileModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  _getCurrentUser() async {
    sharedPref.save("user", currentUser);
  }

  _initializeFirebase() async {
    //  FirebaseApp firebaseApp = await Firebase.initializeApp();

    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    FirebaseApp firebaseApp = Firebase.app();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email;
        uid = user.uid;
      });
    }
    
    return docUser.doc(uid).snapshots().listen((data) async {
       //print("Document Data: ${data.data()}");
      currentUser = Users.fromDocument(data);
      var list = data['image'];
      var stringList = list.join("");
      setState(() {
        currentUser = Users.fromDocument(data);
        email = currentUser.email;
        uid = currentUser.uid;
        image = stringList;
        name = currentUser.name;
        phone = currentUser.phone;
        point = currentUser.points ?? 0;
        tier = currentUser.tier ?? "Bronze";
        bio = currentUser.bio ?? "";
        //hashtag = currentUser.hashtag ?? [];
        address = currentUser.location!['address'];
        verification = currentUser.verification!;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future source(BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
                  "Update profile picture",
                  style: Theme.of(context).textTheme.headline6!.apply(fontFamily: 'Poppins'),
                  ),
          content: Text("Select source"),
          actions: [
            // Camera option
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    Text(
                      " Camera",
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(Duration.zero, () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        getImage(ImageSource.camera, context, currentUser, isProfilePicture);
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      },
                    );
                  });
                },

              ),
            ),
            // Gallery option
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_library,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    Text(
                      " Gallery",
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      getImage(ImageSource.gallery, context, currentUser, isProfilePicture);
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }


Future getImage(
    ImageSource imageSource, context, currentUser, isProfilePicture) async {
  print("Start getImage for $imageSource");
  var image = await picker.pickImage(source: imageSource);
  if (image != null) {
    print("Image picked successfully");
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    if (croppedFile != null) {
      print("Image cropped successfully");
      await uploadFile(
          await compressimage(croppedFile), currentUser, isProfilePicture);
    }
  } else {
    print("No image picked");
  }
  Navigator.pop(context);
}

  Future uploadFile(File image, Users currentUser, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${currentUser.uid}/${image.hashCode}.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
   
    if (await uploadTask != null) {
      storageReference.getDownloadURL().then((fileURL) async {
        Map<String, dynamic> updateObject = {
          "image": FieldValue.arrayUnion([
            fileURL,
          ])
        };
        try {
          if (isProfilePicture) {
            await currentUser.image!.removeAt(0);
            currentUser.image!.insert(0, fileURL);
            print("object");
            await FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .set({"image": currentUser.image!}, SetOptions(merge: true));
          } else {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .set(updateObject, SetOptions(merge: true));
            currentUser.image!.add(fileURL);
          }
          if (mounted) setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    }
  }

  Future compressimage(var image) async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image? imagefile = i.decodeImage(await image.readAsBytes());
    final compressedImagefile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));
    return compressedImagefile;
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
          iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem<String>(
                    value: 'changePassword',
                    child: Text('Change Password'),
                  ),
                ],
                onSelected: (String choice) async {
                  if (choice == 'edit') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileUserWidget(uid: uid),
                      ),
                    );
                    _initializeFirebase();
                  } else if (choice == 'changePassword') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreenWidget(),
                      ),
                    );
                  }
                },
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
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Profile Picture
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: "User Profile",
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 80,
                                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                        child: Material(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          child: Stack(
                                            children: <Widget>[
                                              image == "Empty" ? 
                                              // Network avatar as profile
                                              InkWell(
                                                onTap: () {},
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(80),
                                                    child: Container(
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 4,
                                                              color: Theme.of(context).scaffoldBackgroundColor),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 2,
                                                                blurRadius: 10,
                                                                color: Colors.black.withOpacity(0.1),
                                                                offset: Offset(0, 10))
                                                          ],
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                                              ),
                                                            ),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              :
                                              // Chosen image as profile
                                              InkWell(
                                                onTap: () {},
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(80,),
                                                    child: Container(
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 4,
                                                              color: Theme.of(context).scaffoldBackgroundColor),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 2,
                                                                blurRadius: 10,
                                                                color: Colors.black.withOpacity(0.1),
                                                                offset: Offset(0, 10))
                                                          ],
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(image ),
                                                            ),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Small icon button to allow image selection
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
                                                        var a = await source(
                                                            context, currentUser, true);
                                                            
                                                      }),
                                                ),
                                              ),
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

                        //Name
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  name ??'', // Add a null check here
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).customColor1,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                              verification == true ?
                              Icon(
                                Icons.verified_sharp,
                                color: FlutterFlowTheme.of(context).success,
                                size: 24.0,
                              )
                              :
                              Row(),
                            ],
                          ),
                        ),

                        //Address
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            address.toString(),
                            textAlign: TextAlign.center,
                            maxLines: null, // Set to null or a large number
                            overflow: TextOverflow.visible,
                            style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),

                      //Point + Tier
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Point Balance: ',
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: point.toString(),
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).customColor1,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ),
                                          Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Tier: ',
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: tier.toString(),
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).customColor1,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        //Detail
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            height: 427.0,
                            //height: MediaQuery.of(context).size.height, // Adjust the height as needed

                            decoration: BoxDecoration(),
                            child: Column(
                              children: [

                                // Tabs : Detail 
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
                                    labelColor: FlutterFlowTheme.of(context).primaryText,
                                    unselectedLabelColor:FlutterFlowTheme.of(context).customColor1,
                                    labelStyle: FlutterFlowTheme.of(context).titleMedium,
                                    unselectedLabelStyle: TextStyle(),
                                    indicatorColor: FlutterFlowTheme.of(context).accent3,
                                    padding: EdgeInsets.all(4.0),
                                    tabs: [
                                      Tab(text: 'Detail',
                                      ),
                                      // Tab(text: 'Management',
                                      // ),
                                    ],
                                    controller: _model.tabBarController,
                                  ),
                                ),

                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          //Title : Bio
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text('Bio',
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                          fontSize: 18.0,
                                                          fontWeight:FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //Bio Description
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                    bio.toString(),
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).customColor1,
                                                          fontSize: 16.0,
                                                          fontWeight:FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //Connect with me via
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:EdgeInsets.all(4.0),
                                                    child: Text('Connect with me via',
                                                      style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily:'Outfit',
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Phone
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:MainAxisSize.max,
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 10.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:MainAxisSize.max,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 8.0, 0.0),
                                                                child: Icon(
                                                                  Icons.phone,
                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                phone.toString(),
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'Outfit',
                                                                  color: FlutterFlowTheme.of(context).customColor1,
                                                                  fontSize: 16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Email

                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:EdgeInsetsDirectional.fromSTEB(4.0,0.0,8.0,0.0),
                                                        child: Icon(
                                                          Icons.email,
                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        email.toString(),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).customColor1,
                                                          fontSize: 16.0,
                                                          fontWeight:FontWeight.normal,
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

                                    ],
                                  ),
                                ),

                              ],
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

      ),
    );
  }
}
