import 'package:flutter/material.dart';

class DhikrView extends StatelessWidget {
  const DhikrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zikirler'),
      ),
      body: const Center(
        child: Text('Zikirler Content'),
      ),
    );
  }
}
