import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({Key? key, required this.result, this.image}) : super(key: key);

  final List? result;
  final File? image;
  List<String>? details;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    details();
    super.initState();
  }

  void details() async {
    var my_data = json.decode(await getJson());
    widget.details = await my_data[widget.result![0]['label']].cast<String>();
    print(widget.details);
    setState(() {});
  }

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 17, fontWeight: FontWeight.bold);

  final _contentStyle = const TextStyle(
      color: Color.fromARGB(255, 59, 59, 59),
      fontSize: 16,
      fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 219, 241, 230),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Lottie.asset("assets/waving_leaf.json",
                    width: _size.width / 2),
              ),
            ),
            Container(
              height: _size.height,
              width: _size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.all(15),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: _size.width,
                      child: Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(top: 5, right: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color:
                                  "${widget.result![0]['label']}" == "Healthy"
                                      ? Color.fromARGB(255, 135, 236, 138)
                                      : Color.fromARGB(255, 236, 92, 82),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(19),
                                  bottomRight: Radius.circular(19)),
                            ),
                            child: Hero(
                              tag: "hero",
                              child: Container(
                                width: (_size.width / 2) - 5,
                                height: (_size.width / 2) - 5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(widget.image!),
                                      fit: BoxFit.cover),
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: (_size.width / 2),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Status"),
                                "${widget.result![0]['label']}" == "Healthy"
                                    ? const Icon(
                                        Icons.check_circle,
                                        size: 30,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.cancel_rounded,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                const SizedBox(height: 10),
                                "${widget.result![0]['label']}" == "Healthy"
                                    ? Text("Condition")
                                    : Text("Desease"),
                                SizedBox(
                                  width: (_size.width / 2) - 20,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "${widget.result![0]['label']}",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    PhysicalModel(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: _size.width,
                          child: Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "${widget.result![0]['label']}",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(),
                              Text(widget.details != null
                                  ? widget.details![0]
                                  : ""),
                              const Divider(),
                              Accordion(
                                  disableScrolling: true,
                                  maxOpenSections: 5,
                                  headerBackgroundColorOpened: Colors.black54,
                                  openAndCloseAnimation: false,
                                  headerPadding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 15),
                                  sectionOpeningHapticFeedback:
                                      SectionHapticFeedback.heavy,
                                  sectionClosingHapticFeedback:
                                      SectionHapticFeedback.light,
                                  paddingListBottom: 10,
                                  children: [
                                    AccordionSection(
                                      isOpen: false,
                                      leftIcon: const Icon(
                                          Icons.insights_rounded,
                                          color: Colors.white),
                                      headerBackgroundColor:
                                          Color.fromARGB(255, 23, 118, 196),
                                      headerBackgroundColorOpened: Colors.red,
                                      header:
                                          Text('Symptoms', style: _headerStyle),
                                      content: Text(
                                          widget.details != null
                                              ? widget.details![1]
                                              : "",
                                          style: _contentStyle),
                                      contentHorizontalPadding: 10,
                                      contentBorderWidth: 2,
                                    ),
                                    AccordionSection(
                                      isOpen: false,
                                      leftIcon: const Icon(
                                          Icons.insights_rounded,
                                          color: Colors.white),
                                      headerBackgroundColor:
                                          Color.fromARGB(255, 23, 118, 196),
                                      headerBackgroundColorOpened: Colors.red,
                                      header: Text('Spread and survival',
                                          style: _headerStyle),
                                      content: Text(
                                          widget.details != null
                                              ? widget.details![2]
                                              : "",
                                          style: _contentStyle),
                                      contentHorizontalPadding: 10,
                                      contentBorderWidth: 2,
                                    ),
                                    AccordionSection(
                                      isOpen: false,
                                      leftIcon: const Icon(
                                          Icons.insights_rounded,
                                          color: Colors.white),
                                      headerBackgroundColor:
                                          Color.fromARGB(255, 23, 118, 196),
                                      headerBackgroundColorOpened: Colors.red,
                                      header: Text('Management',
                                          style: _headerStyle),
                                      content: Text(
                                          widget.details != null
                                              ? widget.details![3]
                                              : "",
                                          style: _contentStyle),
                                      contentHorizontalPadding: 10,
                                      contentBorderWidth: 2,
                                    ),
                                  ])
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/details.json');
  }
}
