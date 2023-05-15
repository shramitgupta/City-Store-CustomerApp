import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/models/product_model.dart';
import 'package:ms_customer_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ShoesGalleryScreen extends StatefulWidget {
  final bool fromOnBoarding;
  const ShoesGalleryScreen({Key? key, this.fromOnBoarding = false})
      : super(key: key);

  @override
  State<ShoesGalleryScreen> createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {
  final Stream<QuerySnapshot> _prodcutsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'shoes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromOnBoarding == true
          ? AppBar(
              title: const AppBarTitle(title: 'Shoes'),
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/customer_home');
                },
              ),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: _prodcutsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return SingleChildScrollView(
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
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
          );
        },
      ),
    );
  }
}
