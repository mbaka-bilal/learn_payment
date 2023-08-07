import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../repository/paystack.dart';
import '../../../utils/common.dart';

class PaystackWithWeb extends StatefulWidget {
  const PaystackWithWeb({super.key});

  @override
  State<PaystackWithWeb> createState() => _PaystackWithWebState();
}

class _PaystackWithWebState extends State<PaystackWithWeb> {
  final email = TextEditingController();
  final amount = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(50),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        customForm(textEditingController: email, labelText: "email"),
        customForm(
            textEditingController: amount,
            keyboardType: TextInputType.number,
            labelText: "amount"),
        const SizedBox(height: 20),
        (isLoading)
            ? const CircularProgressIndicator()
            : customButton(
                function: () async {
                  try {
                    isLoading = true;
                    setState(() {});

                    final response =
                        await PayStackPayment().initializeTransaction(
                      email: email.text,
                      amount: double.tryParse(amount.text)! * 100,
                    );

                    if (response.statusCode == 200) {
                      print("data is ${response.body}");
                      final data = await jsonDecode(response.body);

                      final dataMap = data["data"];
                      final authorizationUrl = dataMap["authorization_url"];

                      final uri = Uri.parse(authorizationUrl);

                      await launchUrl(uri).then(
                          (_) {
                            isLoading = true;
                            setState(() {});
                          }
                      );

                    } else {
                      debugPrint(
                          "Error initializing payment non 200 ${response.body}");
                      if (mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("could not intialize transaction"),
                        ));
                      }
                    }
                    isLoading = true;
                    setState(() {});
                  } catch (e) {
                    debugPrint("Error initializeing payment $e");
                    isLoading = true;
                    setState(() {});

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("could not intialize transaction"),
                      ));
                    }
                  }
                },
                child: const Text("Pay"))
      ]),
    ));
  }
}
