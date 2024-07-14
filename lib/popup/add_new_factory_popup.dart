import 'package:flutter/material.dart';

class AddNewFactoryPopup extends StatefulWidget {
  const AddNewFactoryPopup({
    required this.collectionName,
    super.key,
  });

  final String collectionName;

  @override
  State<AddNewFactoryPopup> createState() => _AddNewFactoryPopupState();
}

class _AddNewFactoryPopupState extends State<AddNewFactoryPopup> {
  @override
  Widget build(BuildContext context) {
    return const Text('first test');
  }
}
