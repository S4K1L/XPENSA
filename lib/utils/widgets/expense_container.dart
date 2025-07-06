// import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:pie_chart/pie_chart.dart';
//
// import '../Theme/color_theme.dart';
//
// class BottomContainer extends StatelessWidget {
//   final Map<String, double> categoryExpenses;
//   final double totalBudget;
//   final double totalExpenses;
//
//   const BottomContainer({
//     super.key,
//     required this.categoryExpenses,
//     required this.totalBudget,
//     required this.totalExpenses,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           const Row(
//             children: [
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   'Top Categories',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Icon(
//                 Icons.swap_vert,
//                 size: 26,
//                 color: kPrimaryColor,
//               )
//             ],
//           ),
//           const SizedBox(height: 20),
//           ...categoryExpenses.entries.map((entry) {
//             double percentageOfBudget = (entry.value / totalBudget) * 100;
//             double percentageOfTotalExpenses = (entry.value / totalExpenses) * 100;
//
//             return Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     height: 45,
//                     width: 45,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(32),
//                       color: Colors.grey[300],
//                     ),
//                     child: Icon(_getCategoryIcon(entry.key), size: 30),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text(
//                           entry.key,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: kTextBlackColor,
//                           ),
//                         ),
//                       ),
//                       LinearPercentIndicator(
//                         width: MediaQuery.of(context).size.width / 1.9,
//                         animation: true,
//                         lineHeight: 15.0,
//                         animationDuration: 2500,
//                         percent: percentageOfBudget / 100,
//                         center: Text(
//                           "${percentageOfBudget.toStringAsFixed(1)}%",
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 1.5,
//                           ),
//                         ),
//                         linearStrokeCap: LinearStrokeCap.roundAll,
//                         progressColor: kPrimaryColor,
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Text(
//                     '-${entry.value.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         color: kTextBlackColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500),
//                   )
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   // Function to get the correct icon based on the category name
//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'transportation':
//         return Icons.directions_car;
//       case 'grocery':
//         return Icons.shopping_cart;
//       case 'payment and bill':
//         return Icons.payment;
//       case 'recharge':
//         return Icons.phone_android;
//       case 'others':
//         return Icons.more_horiz_sharp;
//       default:
//         return Icons.category;
//     }
//   }
// }
//
//
// class TopContainer extends StatelessWidget {
//   final Map<String, double> dataMap;
//   final double totalBudget;
//
//   const TopContainer({
//     super.key,
//     required this.dataMap,
//     required this.totalBudget,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Create a new map to hold the percentage of the budget used by each category
//     Map<String, double> budgetDataMap = {};
//
//     // Calculate the percentage of the budget used by each category
//     dataMap.forEach((category, amountSpent) {
//       double percentageOfBudget = (amountSpent / totalBudget) * 100;
//       budgetDataMap[category] = percentageOfBudget;
//     });
//
//     // Check if budgetDataMap is empty
//     if (budgetDataMap.isEmpty || totalBudget == 0) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Text(
//             'No data available to display.',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//         ),
//       );
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, bottom: 20),
//       child: PieChart(
//         animationDuration: const Duration(milliseconds: 2500),
//         dataMap: budgetDataMap,
//         chartValuesOptions: const ChartValuesOptions(
//           showChartValuesInPercentage: true,
//           decimalPlaces: 1,
//         ),
//         totalValue: 100, // Since we are showing percentages, total value should be 100
//       ),
//     );
//   }
// }
//
