import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/user_model.dart';

class EditProfile extends StatefulWidget {
  final Users currentUser;
  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController aboutCtlr = new TextEditingController();
  final TextEditingController companyCtlr = new TextEditingController();
  final TextEditingController livingCtlr = new TextEditingController();
  final TextEditingController jobCtlr = new TextEditingController();
  final TextEditingController universityCtlr = new TextEditingController();
  bool visibleAge = false;
  bool visibleDistance = true;
  final picker = ImagePicker();
  CollectionReference docUser = FirebaseFirestore.instance.collection('users');

  var showMe;
  Map editInfo = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print(editInfo.length);
    if (editInfo.length > 0) {
      updateData();
    }
  }

  deletePicture(index) async {
    var temp = [];
    if (widget.currentUser.image![index] != null) {
      if(widget.currentUser.image![index] != "Empty"){
        try {
          Reference _ref = await FirebaseStorage.instance
              .refFromURL(widget.currentUser.image![index]);
          await _ref.delete();
        } catch (e) {
          print(e);
        }
      }
    }
    setState(() {
      widget.currentUser.image!.removeAt(index);
    });
    temp.add(widget.currentUser.image!);
    await docUser
        .doc("${widget.currentUser.uid}")
        .set({"image": temp[0]}, SetOptions(merge: true));
  }

  Future updateData() async {
  }

  Future source(
      BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(
                  isProfilePicture ? "Update profile picture" : "Add pictures", style: Theme.of(context).textTheme.headline6!.apply(fontFamily: 'Poppins')),
              content: Text(
                "Select source"
              ),
              insetAnimationCurve: Curves.decelerate,
              actions: currentUser.image!.length < 9
                  ? <Widget>[
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
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.camera, context,
                                      currentUser, isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
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
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.gallery, context,
                                      currentUser, isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                    ]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text(
                              "Can't uplaod more than 9 pictures",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        )),
                      )
                    ]);
        });
  }

  Future getImage(
      ImageSource imageSource, context, currentUser, isProfilePicture) async {
    var image = await picker.pickImage(source: imageSource);
    if (image != null) {
      var croppedFile = await ImageCropper().cropImage( 
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          
          );
      if (croppedFile != null) {
        await uploadFile(
            await compressimage(croppedFile), currentUser, isProfilePicture);
      }
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
            widget.currentUser.image!.add(fileURL);
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
    // Profile _profile = new Profile(widget.currentUser);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Theme.of(context).backgroundColor),
      body: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio:
                            MediaQuery.of(context).size.aspectRatio * 1.5,
                        crossAxisSpacing: 4,
                        padding: EdgeInsets.all(10),
                        children: List.generate(9, (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: widget.currentUser.image!.length >
                                        index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // image: DecorationImage(
                                        //     fit: BoxFit.cover,
                                        //     image: CachedNetworkImageProvider(
                                        //       widget.currentUser.image![index],
                                        //     )),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 1,
                                            color: Colors.red)),
                                child: Stack(
                                  children: <Widget>[
                                    widget.currentUser.image!.length > index
                                        ? CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.currentUser
                                                    .image![index] ??
                                                '',
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CupertinoActivityIndicator(
                                                radius: 10,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  Text(
                                                    "Enable to load",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    // Center(
                                    //     child:
                                    //         widget.currentUser.image!.length >
                                    //                 index
                                    //             ? CupertinoActivityIndicator(
                                    //                 radius: 10,
                                    //               )
                                    //             : Container()),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          // width: 12,
                                          // height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.currentUser.image!
                                                        .length >
                                                    index
                                                ? Colors.white
                                                : Theme.of(context).backgroundColor,
                                          ),
                                          child: widget.currentUser.image!
                                                      .length >
                                                  index
                                              ? InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Theme.of(context).backgroundColor,
                                                    size: 22,
                                                  ),
                                                  onTap: () async {
                                                    if (widget.currentUser
                                                            .image!.length >
                                                        1) {
                                                      _deletePicture(index);
                                                    } else {
                                                      source(
                                                          context,
                                                          widget.currentUser,
                                                          true);
                                                    }
                                                  },
                                                )
                                              : InkWell(
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () => source(
                                                      context,
                                                      widget.currentUser,
                                                      false),
                                                )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Theme.of(context).backgroundColor.withOpacity(.5),
                                  Theme.of(context).backgroundColor.withOpacity(.8),
                                  Theme.of(context).backgroundColor,
                                  Theme.of(context).backgroundColor,
                                ])),
                        height: 50,
                        width: 340,
                        child: Center(
                            child: Text(
                          "Add media",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      await source(context, widget.currentUser, false);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListBody(
                      mainAxis: Axis.vertical,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "About ${widget.currentUser.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: aboutCtlr,
                            cursorColor: Theme.of(context).backgroundColor,
                            maxLines: 10,
                            minLines: 3,
                            placeholder: "About you",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'about': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Job title",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: jobCtlr,
                            cursorColor: Theme.of(context).backgroundColor,
                            placeholder: "Add job title",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'job_title': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Company",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: companyCtlr,
                            cursorColor: Theme.of(context).backgroundColor,
                            placeholder: "Add company",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'company': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "University",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: universityCtlr,
                            cursorColor: Theme.of(context).backgroundColor,
                            placeholder: "Add university",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'university': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Living in",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: livingCtlr,
                            cursorColor: Theme.of(context).backgroundColor,
                            placeholder: "Add city",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'living_in': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "I am",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: Theme.of(context).backgroundColor,
                              iconDisabledColor: Colors.red,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Man"),
                                  value: "man",
                                ),
                                DropdownMenuItem(
                                    child: Text("Woman"), value: "woman"),
                                DropdownMenuItem(
                                    child: Text("Other"), value: "other"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'userGender': val});
                                setState(() {
                                  showMe = val;
                                });
                              },
                              value: showMe,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            title: Text(
                              "Control your profile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Don't Show My Age"),
                                      ),
                                      Switch(
                                          activeColor: Theme.of(context).backgroundColor,
                                          value: visibleAge,
                                          onChanged: (value) {
                                            editInfo
                                                .addAll({'showMyAge': value});
                                            setState(() {
                                              visibleAge = value;
                                            });
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Make My Distance Visible"),
                                      ),
                                      Switch(
                                          activeColor: Theme.of(context).backgroundColor,
                                          value: visibleDistance,
                                          onChanged: (value) {
                                            editInfo.addAll(
                                                {'DistanceVisible': value});
                                            setState(() {
                                              visibleDistance = value;
                                            });
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deletePicture(index) async {
    if (widget.currentUser.image![index] != null) {
      try {
        var _ref = await FirebaseStorage.instance
            .refFromURL(widget.currentUser.image![index]);
        //print(_ref.path);
        await _ref.delete();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      widget.currentUser.image!.removeAt(index);
    });
    var temp = [];
    temp.add(widget.currentUser.image);
    await FirebaseFirestore.instance
        .collection("users")
        .doc("${widget.currentUser.uid}")
        .set({"image": temp[0]},SetOptions(merge: true));
  }
}
