import 'package:flutter/material.dart';
import '../../layouts/BaseLayout.dart';
import './components/CategoryGrid.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: CategoryGrid(),
    );
  }
}
