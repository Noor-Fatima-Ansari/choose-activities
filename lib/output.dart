import 'package:activity/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({
    super.key,
  });
  // List<String> male, female, kids;
  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedVenue = context.watch<Dataprovider>().selectedVenue;
    List<String> male = context.watch<Dataprovider>().maleData;
    List<String> female = context.watch<Dataprovider>().femaleData;
    List<String> kids = context.watch<Dataprovider>().kidsData;
    String? budget = context.watch<Dataprovider>().getFoodBudget;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE6EE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Male",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${male.join(', ')}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Female",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${female.join(', ')}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Kids",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${kids.join(', ')}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(budget!),
            SizedBox(
              height: 10,
            ),

// showing venues data

         Container(
          child: selectedVenue != null
    ? Column(
        children: [
          Row(
            children: [
              Text("Venue Name: "),
              Text("${selectedVenue['name']}"),
            ],
          ),
          Row(
            children: [
              Text("Address: "),
              Text("${selectedVenue['address']}"),
            ],
          ),
          Row(
            children: [
              Text("Venue Price: "),
              Text("${selectedVenue['price']}"),
            ],
          ),
          Row(
            children: [
              Text("Contact No: "),
              Text("${selectedVenue['phone']}"),
            ],
          ),
        ],
      )
    : Text("No venue selected"),

         )

          ],



        ),
      ),
    );
  }
}
