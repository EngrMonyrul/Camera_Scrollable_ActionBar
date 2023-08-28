// ignore_for_file: file_names, unused_local_variable

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(viewportFraction: 0.3);
  String selectedAction = 'ID Card';
  late CameraController cameraController;
  var cameraLens = CameraLensDirection.back;
  String camera = '0';
  bool flash = false;
  bool exposer = false;
  bool isSelected = false;
  List<String> cameraActions = [
    'ID Card',
    'Documents',
    'QR Code',
    'Bar Code',
    'Area'
  ];
  Map<String, Map<String, double>> captureArea = {
    'ID Card': {
      'height': 0.28,
      'width': 0.88,
    },
    'Documents': {
      'height': 0.7,
      'width': 0.9,
    },
    'QR Code': {
      'height': 0.4,
      'width': 0.8,
    },
    'Bar Code': {
      'height': 0.4,
      'width': 0.8,
    },
  };

  setupCamera() {
    cameraController = CameraController(
      CameraDescription(
        lensDirection: cameraLens,
        name: camera,
        sensorOrientation: 90,
      ),
      ResolutionPreset.veryHigh,
    );
    setController();
  }

  setController() {
    setState(() {
      cameraController.initialize().then((value) {
        if (mounted) {
          setState(() {});
        }
      });

      if (flash) {
        cameraController.setFlashMode(FlashMode.torch);
      } else {
        cameraController.setFlashMode(FlashMode.off);
      }

      if (exposer) {
        cameraController.setExposureMode(ExposureMode.auto);
      } else {
        cameraController.setExposureMode(ExposureMode.locked);
      }
    });
  }

  setContainerArea(vheigh, vwidth) {
    return Container(
      height: MediaQuery.of(context).size.height * vheigh,
      width: MediaQuery.of(context).size.width * vwidth,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  setFocusArea() {
    switch (selectedAction) {
      case 'ID Card':
        return setContainerArea(captureArea[selectedAction]!['height'],
            captureArea[selectedAction]!['width']);
      case 'Documents':
        return setContainerArea(captureArea[selectedAction]!['height'],
            captureArea[selectedAction]!['width']);
      case 'QR Code':
        return setContainerArea(captureArea[selectedAction]!['height'],
            captureArea[selectedAction]!['width']);
      case 'Bar Code':
        return setContainerArea(captureArea[selectedAction]!['height'],
            captureArea[selectedAction]!['width']);
      case 'Area':
        return setContainerArea(1, 1);
    }
  }

  setPageAction(action) {
    setState(() {
      selectedAction = action;
    });

    pageController.animateToPage(cameraActions.indexOf(action),
        curve: Curves.linear, duration: const Duration(milliseconds: 100));
  }

  setPageController() {
    pageController.addListener(() {
      int currentIndex = pageController.page?.round() ?? 0;
      setState(() {
        selectedAction = cameraActions[currentIndex];
      });
    });
  }

  @override
  void initState() {
    setPageController();
    setupCamera();
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          flash = !flash;
                          setController();
                        });
                      },
                      child: flash
                          ? const Icon(Icons.flash_on,
                              size: 20, color: Colors.white)
                          : const Icon(Icons.flash_off,
                              size: 20, color: Colors.white),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          exposer = !exposer;
                          setController();
                        });
                      },
                      child: flash
                          ? const Icon(Icons.exposure_rounded,
                              size: 20, color: Colors.white)
                          : const Icon(Icons.exposure_rounded,
                              size: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: CameraPreview(cameraController)),
                    Container(
                      alignment: Alignment.center,
                      height: screenSize.height,
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: setFocusArea(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: pageController,
                        itemCount: cameraActions.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Buttons(
                            title: cameraActions[index],
                            isSelected: selectedAction==cameraActions[index],
                            onTap:(){
                              setPageAction(cameraActions[index]);
                            }
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const Buttons({super.key, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 25),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.amber.shade800 : Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
