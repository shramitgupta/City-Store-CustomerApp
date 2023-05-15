import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/models/product_model.dart';

import 'package:ms_customer_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HotDealsScreen extends StatefulWidget {
  final bool fromOnBoarding;
  final String maxDiscount;

  const HotDealsScreen(
      {Key? key, this.fromOnBoarding = false, required this.maxDiscount})
      : super(key: key);

  @override
  State<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends State<HotDealsScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> prodcutsStream = FirebaseFirestore.instance
        .collection('products')
        .where('discount', isNotEqualTo: 0)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: widget.fromOnBoarding == true
            ? IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/customer_home');
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.yellow,
                ))
            : const YellowBackButton(),
        title: SizedBox(
          height: 160,
          child: Stack(children: [
            Positioned(
              left: 0,
              top: 70,
              child: DefaultTextStyle(
                style: const TextStyle(
                    height: 1.2,
                    color: Colors.yellowAccent,
                    fontSize: 30,
                    fontFamily: 'PressStart2P'),
                child: AnimatedTextKit(
                  totalRepeatCount: 5,
                  animatedTexts: [
                    TypewriterAnimatedText('Hot Deals ',
                        speed: const Duration(milliseconds: 60), cursor: '|'),
                    TypewriterAnimatedText('up to ${widget.maxDiscount} % off ',
                        speed: const Duration(milliseconds: 60),
                        cursor: '|',
                        textStyle: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
      body: Stack(children: [
        Container(
          height: 60,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: StreamBuilder<QuerySnapshot>(
              stream: prodcutsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                    'This category \n\n has no items yet !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5),
                  ));
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    child: StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return ProductModel(
                            products: snapshot.data!.docs[index],
                          );
                        },
                        staggeredTileBuilder: (context) =>
                            const StaggeredTile.fit(1)),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
