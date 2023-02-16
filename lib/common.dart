import 'package:flutter/material.dart';

const loading = <Widget>[
  SizedBox(
    width: 60,
    height: 60,
    child: CircularProgressIndicator(),
  ),
  Padding(
    padding: EdgeInsets.only(top: 16),
    child: Text('Loading...'),
  ),
];

List<Widget> showError(Object? err) {
  return <Widget>[
    const Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    ),
    Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text('Error: $err'),
    ),
  ];
}
