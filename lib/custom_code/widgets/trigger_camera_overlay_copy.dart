// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class TriggerCameraOverlayCopy extends StatefulWidget {
  const TriggerCameraOverlayCopy({
    super.key,
    this.width,
    this.height,
    this.cardType,
    this.infoText,
    this.labelText,
    this.buttonText,
    this.buttonColor,
    this.onCapture,
    this.borderRadius,
    this.padding,
    this.rotateCamera,
  });

  final double? width;
  final double? height;
  final int? cardType;
  final String? infoText;
  final String? labelText;
  final String? buttonText;
  final Color? buttonColor;
  final Future Function(FFUploadedFile? uploadedId)? onCapture;
  final double? borderRadius;
  final double? padding;
  final bool? rotateCamera;

  @override
  State<TriggerCameraOverlayCopy> createState() => _TriggerCameraOverlayState();
}

class _TriggerCameraOverlayState extends State<TriggerCameraOverlayCopy> {
  late OverlayFormat format;

  @override
  void initState() {
    super.initState();
    _setFormat();
  }

  void _setFormat() {
    switch (widget.cardType) {
      case 1:
        format = OverlayFormat.cardID3;
        break;
      case 2:
        format = OverlayFormat.simID000;
        break;
      case 0:
      default:
        format = OverlayFormat.cardID1;
    }
  }

  Future<void> _launchCameraOverlay() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera found')),
      );
      return;
    }

    if (widget.rotateCamera ?? false) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    final XFile? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraOverlay(
          cameras.first,
          CardOverlay.byFormat(format),
          (XFile file) {
            Navigator.pop(context, file);
          },
        ),
      ),
    );

    if (widget.rotateCamera ?? false) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    if (result != null) {
      try {
        final imagePath = result.path;
        // Update the FlutterFlow App State with the image path
        FFAppState().update(() {
          FFAppState().capturedImage = imagePath;
        });

        // Navigate to photoIDfront page
        if (context.mounted) {
          Navigator.pushNamed(context, 'photoIDfront');
        }
      } catch (e) {
        print('Error capturing image: $e');
      }
    } else {
      if (widget.onCapture != null) {
        widget.onCapture!(null);
      }
    }
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        // Title and instructions
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.infoText ?? 'Photo ID Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                widget.labelText ??
                    'Please point the camera at the ID card. Position it inside the frame. Make sure it is clear enough.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Preview frame
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Capture button
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _launchCameraOverlay,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchCameraOverlay,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor ?? Theme.of(context).primaryColor,
        minimumSize:
            Size(widget.width ?? double.infinity, widget.height ?? 50.0),
        padding: EdgeInsets.all(widget.padding ?? 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
        ),
      ),
      child: Text(widget.buttonText ?? 'Launch Camera'),
    );
  }
}
