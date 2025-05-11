import 'package:flutter/material.dart';

class BibDetailScreen extends StatelessWidget {
  final int bibNumber;

  const BibDetailScreen({super.key, required this.bibNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BIB #$bibNumber Details')),
      body: Center(
        child: Text('Details for BIB #$bibNumber'),
      ),
    );
  }
}
