import 'package:flutter/material.dart';
class TreasureHuntPage extends StatefulWidget {
  const TreasureHuntPage({super.key});

  @override
  State<TreasureHuntPage> createState() => _TreasureHuntPageState();
}

class _TreasureHuntPageState extends State<TreasureHuntPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('T R E A S U R E   H U N T', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),),
    );
  }
}
