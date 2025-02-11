import 'package:activity/PictureDecore.dart';
import 'package:activity/Specify.dart';
import 'package:activity/dataProvider.dart';
import 'package:activity/output.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodEstimation extends StatefulWidget {
  @override
  createState() => _FoodEstimationScreenState();
}

class _FoodEstimationScreenState extends State<FoodEstimation> {
  TextEditingController budgetController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController totalController = TextEditingController();
  TextEditingController maleController = TextEditingController();
  TextEditingController femaleController = TextEditingController();
  TextEditingController kidsController = TextEditingController();

  // List<int> selectedItemPrices = context.watch<Dataprovider>().getSelectedPrices();
  List<String> Cpics = [
    "images/indian.png",
    "images/italian.png",
    "images/pakistani.png",
    "images/arabian.png"
  ];
  List<String> Ctitle = ["Indian", "Italian", "Pakistani", "Arabian"];

  String? _validateTotal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter total people';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid number of people';
    }
    return null;
  }

  String? _validateMale(String? value) {
    if (value == null || value.isEmpty) {
      return '0';
    }
    if (int.tryParse(value) == null || int.parse(value) < 0) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validateFemale(String? value) {
    if (value == null || value.isEmpty) {
      return '0';
    }
    if (int.tryParse(value) == null || int.parse(value) < 0) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validateKids(String? value) {
    if (value == null || value.isEmpty) {
      return '0';
    }
    if (int.tryParse(value) == null || int.parse(value) < 0) {
      return 'Please enter a valid number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var itemPrices = context.watch<Dataprovider>().getSelectedPrices();
    // final uid = FirebaseAuth.instance.currentUser?.uid;
    // final CollectionReference reference = FirebaseFirestore.instance
    //     .collection("User Data")
    //     .doc(uid)
    //     .collection("Profile Data");

    Specify specify = Specify();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double calculateTotalBudget(
      int numberOfMales,
      int numberOfFemales,
      int numberOfKids,
      List<int> selectedItemPrices,
    ) {
      // Step 1: Calculate total portions
      double totalPortions =
          (numberOfMales * 1) + (numberOfFemales * 0.75) + (numberOfKids * 0.5);

      // Step 2: Calculate portion per item
      int numberOfItems = selectedItemPrices.length;
      double portionPerItem = totalPortions / numberOfItems;

      // Step 3: Calculate total budget
      double totalBudget = 0;
      for (int price in selectedItemPrices) {
        totalBudget += price * portionPerItem;
      }

      return totalBudget;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Venue Vibes",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Food Estimation",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cuisine section with ListView.builder
                specify.buildCardListCuisine("Choose Cuisine", Cpics, Ctitle),
                const SizedBox(height: 20),

                // const Text(
                //   "Budget",
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // ),
                // const SizedBox(height: 8),
                // Container(
                //   height: screenHeight * 0.15,
                //   decoration: BoxDecoration(
                //     color: Colors.purple[50],
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.all(screenWidth * 0.02),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: TextFormField(
                //             validator: _validateBudget,
                //             controller: budgetController,
                //             decoration: InputDecoration(
                //               hintText: "Enter your budget for Food",
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //             ),
                //             keyboardType: TextInputType.number,
                //           ),
                //         ),
                //         const SizedBox(width: 8),
                //         ElevatedButton(
                //           onPressed: () {
                //             if (formKey.currentState!.validate()) {
                //               budget = int.parse(budgetController.text);
                //             }
                //           },
                //           style: ElevatedButton.styleFrom(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 16, horizontal: 24),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //           ),
                //           child: const Text("Set Budget"),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),

                // People input section
                const Text(
                  "People",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  height: screenHeight * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: _validateTotal,
                          controller: totalController,
                          decoration: InputDecoration(
                            hintText: "Enter Total Number of People",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: _validateMale,
                                controller: maleController,
                                decoration: InputDecoration(
                                  hintText: "Number of Males",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                validator: _validateFemale,
                                controller: femaleController,
                                decoration: InputDecoration(
                                  hintText: "Number of Females",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                validator: _validateKids,
                                controller: kidsController,
                                decoration: InputDecoration(
                                  hintText: "Number of Kids",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // double? totalBudget;
                      // if (formKey.currentState!.validate()) {
                      //   // Calculation
                      //   totalBudget = calculateTotalBudget(
                      //     int.parse(maleController.text),
                      //     int.parse(femaleController.text),
                      //     int.parse(kidsController.text),
                      //     itemPrices,
                      //   );

                      //   // Print the result
                      //   print(
                      //       "Total Budget: ${totalBudget.toStringAsFixed(2)} PKR");
                      // }

                      // context.read<Dataprovider>().setFoodBudget(
                      //     "Total Budget: ${totalBudget?.toStringAsFixed(2)} PKR");

                      // Print the result

                      if (formKey.currentState!.validate()) {
                        // Perform budget calculation
                        double totalBudget = calculateTotalBudget(
                          int.parse(maleController.text),
                          int.parse(femaleController.text),
                          int.parse(kidsController.text),
                          itemPrices,
                        );

                        context.read<Dataprovider>().setFoodBudget(
                            "Total Budget: ${totalBudget.toStringAsFixed(2)} PKR");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PictureDecor()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Generate"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
