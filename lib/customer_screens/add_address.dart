import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:ms_customer_app/widgets/appbar_widgets.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phone;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const AppBarBackButton(),
            title: const AppBarTitle(
              title: 'Add Address',
            )),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 40, 30, 40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.width * 0.12,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your first name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                firstName = value!;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'First Name',
                                hintText: 'Enter your first Name',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.width * 0.12,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                lastName = value!;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Last Name',
                                hintText: 'Enter your last Name',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.width * 0.12,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your phone';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                phone = value!;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Phone',
                                hintText: 'Enter your phone',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SelectState(
                    // style: TextStyle(color: Colors.red),
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                  ),
                  Center(
                    child: YellowButton(
                        label: 'Add New Address',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (countryValue != 'Choose Country' &&
                                stateValue != 'Choose State' &&
                                cityValue != 'Choose City') {
                              formKey.currentState!.save();
                              CollectionReference addressRef = FirebaseFirestore
                                  .instance
                                  .collection('customers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('address');
                              var addressId = const Uuid().v4();
                              await addressRef.doc(addressId).set({
                                'addressid': addressId,
                                'firstname': firstName,
                                'lastname': lastName,
                                'phone': phone,
                                'country': countryValue,
                                'state': stateValue,
                                'city': cityValue,
                                'default': true
                              }).whenComplete(() => Navigator.pop(context));
                            } else {
                              MyMessageHandler.showSnackBar(
                                  scaffoldKey, 'please set your location');
                            }
                          } else {
                            MyMessageHandler.showSnackBar(
                                scaffoldKey, 'please fill all fields');
                          }
                        },
                        width: 0.8),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 1),
      borderRadius: BorderRadius.circular(25)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      borderRadius: BorderRadius.circular(25)),
);
