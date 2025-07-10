import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/master_card_controller.dart';
import '../../views/card_details_page.dart';

class MasterCard extends StatelessWidget {
  MasterCard({super.key});

  final controller = Get.put(MasterCardController());

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Obx(
          () => PageView.builder(
            controller: PageController(viewportFraction: 0.88),
            itemCount: controller.cards.length,
            itemBuilder: (context, index) {
              final card = controller.cards[index];
              return BounceInRight(
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => CardDetailsPage(card: card, cardDocId: card.docId),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(card.imageAsset),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(card.icon, color: Colors.white, size: 28),
                            const SizedBox(width: 6),
                            Text(
                              "৳${card.amount.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              controller.uid.value,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/images/card.png',
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
