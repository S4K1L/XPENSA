import 'package:flutter/material.dart';

import '../utils/components/master_card.dart';
import '../utils/widgets/first_container.dart';
import '../utils/widgets/transaction_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(flex: 1, child: UserDataContainer()),
                Expanded(flex: 2, child: TransactionList()),
              ],
            ),
          ),
          MasterCard(),
        ],
      ),
    );
  }
}
