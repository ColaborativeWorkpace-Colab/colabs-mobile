import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> popUpVerificationAlert(BuildContext context, bool isVerified) async {
  try {
    // ignore: avoid_dynamic_calls
    if (!isVerified) {
      await Future<void>.delayed(const Duration(seconds: 2), () async {
        await showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: AlertDialog(
                      elevation: 10,
                      title: const Text('Verification Incomplete'),
                      content: const Text(
                          'You are not verified yet as a freelancer'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'))
                      ]));
            });
      });
    }
  }
  // ignore: empty_catches
  on Exception {}
  // ignore: empty_catches
  on FlutterError {}
    
}