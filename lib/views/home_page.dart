import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpensa/controller/master_card_controller.dart';

import '../utils/components/master_card.dart';
import '../utils/widgets/user_data_container.dart';
import '../utils/widgets/transaction_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(MasterCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async => controller.fetchCardData(),
        child: Stack(
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
      ),
    );
  }
}
