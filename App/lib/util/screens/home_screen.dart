import 'dart:io';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:glass/glass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

import '../../constants.dart';
import 'details_screen.dart';

class LeafDeseaseDetectionApp extends StatefulWidget {
  const LeafDeseaseDetectionApp({Key? key}) : super(key: key);

  @override
  _LeafDeseaseDetectionAppState createState() =>
      _LeafDeseaseDetectionAppState();
}

class _LeafDeseaseDetectionAppState extends State<LeafDeseaseDetectionApp> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  bool _disSubmit = false;

  @override
  void initState() {
    super.initState();
    loadModelData().then((output) {
//after loading models, rebuild the UI.
      setState(() {});
    });
  }

  loadModelData() async {
//tensorflow lite plugin loads models and labels.
    await Tflite.loadModel(
        model: 'assets/leaf_model2.tflite', labels: 'assets/leaf_labels.txt');
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 221, 214),
      body: Container(
        height: _size.height,
        width: _size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.bottomCenter,
              image: AssetImage("assets/mango_tree.png"),
              fit: BoxFit.contain),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // _image != null ? testImage(_size, _image) : titleContent(_size),
              titleContent(_size),

              const SizedBox(
                height: 30,
              ),
              if (_image != null)
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Hero(
                        tag: "hero",
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          height: _size.width - 40,
                          width: _size.width - 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image!), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -15,
                        child: galleryOrCamera(Icons.arrow_forward, null, 70,
                            null, _disSubmit, 2)),
                  ],
                ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      )),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        galleryOrCamera(Icons.camera, ImageSource.camera, 50,
                            null, false, 1),
                        galleryOrCamera(Icons.photo_album, ImageSource.gallery,
                            50, null, false, 1),
                        galleryOrCamera(
                            Icons.delete, null, 50, Colors.amber, false, 3),
                      ]),
                ).asGlass(
                  tintColor: Colors.green,
                  clipBorderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 25),

              //'It\'s a ${_result![0]['label']}.',
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '1. Select or Capture the image. \n2. Tap the submit button.',
                  style: GoogleFonts.openSans(fontSize: 16),
                ),
              ).asGlass(
                tintColor: const Color.fromARGB(255, 204, 221, 214),
                clipBorderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Container titleContent(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
//contains 55% of the screen height.
      //height: size.height * 0.55,
      width: size.width,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/leaf.jpg"),
//           fit: BoxFit.cover,
// //black overlay filter
//           colorFilter: filter,
//         ),
//       ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            FittedBox(
              child: NeumorphicText(
                'Mango Leaf Desease Recognition',
                style: NeumorphicStyle(
                    color: const Color.fromARGB(255, 64, 102, 65)),
                textStyle: NeumorphicTextStyle(
                    fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MaterialButton galleryOrCamera(IconData icon, ImageSource? imageSource,
      double _bSize, Color? _color, bool dis, int func) {
    return MaterialButton(
      padding: const EdgeInsets.all(6), //14
      elevation: 5, //5
      disabledColor: Colors.grey,
      disabledTextColor: Colors.grey,
      disabledElevation: 0,
      color: Colors.white,
      onPressed: dis
          ? null
          : () async {
              switch (func) {
                case 1:
                  if (await Permission.camera.request().isGranted) {
                    _getImage(imageSource!);
                  } else {
                    Permission.camera.request();
                  }

                  break;
                case 2:
                  setState(() {
                    //make button disabled
                    _disSubmit = true;
                  });

                  List? _result = await detectDogOrCat();
                  setState(() {
                    //make button enabled
                    _disSubmit = false;
                  });
                  //navigate to next screen
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(result: _result, image: _image)));
                  break;
                case 3:
                  _removeImage();
                  break;
                default:
              }
            },
      child: Container(
        width: _bSize,
        height: _bSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _color ?? const Color.fromARGB(255, 180, 214, 169),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.grey[800],
        ),
      ),
      // Icon(
      //   icon,
      //   size: 20,
      //   color: Colors.grey[800],
      // ),
      shape: const CircleBorder(),
    );
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  _getImage(ImageSource imageSource) async {
//accessing image from Gallery or Camera.
    final XFile? _image = await _picker.pickImage(source: imageSource);
//image is null, then return
    if (_image == null) return;
    setState(() {
      this._image = File(_image.path);
    });
  }

  Widget testImage(size, image) {
    return Container(
      height: size.height * 0.55,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(
            image!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<List?> detectDogOrCat() async {
    List? _res;
    if (_image != null) {
      try {
        _res = await Tflite.runModelOnImage(
          path: _image!.path,
          numResults: 1, //2,
          threshold: 0.1, //0.6,
          imageMean: 0.0, //127.5,
          imageStd: 255.0, //51.71, //127.5,
        );
        return _res;
      } catch (e) {
        print(e);
      }
      setState(() {});
    }
    return _res;
  }
}
