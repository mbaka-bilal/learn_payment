import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/paystack.dart';
import '../../../utils/common.dart';

class PayStackChargeApi extends StatefulWidget {
  const PayStackChargeApi({super.key});

  @override
  State<PayStackChargeApi> createState() => _PayStackChargeApiState();
}

class _PayStackChargeApiState extends State<PayStackChargeApi> {
  final cardNumberController = TextEditingController();
  final cvvController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final amountController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<String> cardNumber(String data) {
    List<String> numbers = [];

    while (data.length >= 4) {
      numbers.add(data.substring(0, 4));
      data = data.replaceRange(0, 4, "");
    }
    if (data != "") {
      numbers.add(data);
    }

    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Enter your card details"),
              const SizedBox(height: 30),
              customForm(
                textEditingController: cardNumberController,
                hintText: "card number",
                validator: Validators.emptyValidator,
                onChanged: (str) {
                  if (str != null) {
                    final string = cardNumber(str.replaceAll(" ", "")).join(" ");

                    cardNumberController.text = string;

                    cardNumberController.selection = TextSelection.collapsed(
                        offset: cardNumberController.text.length);
                  }
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: customForm(
                    validator: Validators.emptyValidator,
                    textEditingController: cvvController,
                    hintText: "cvv",
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: customForm(
                          validator: Validators.emptyValidator,
                          textEditingController: monthController,
                          hintText: "month",
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: customForm(
                          validator: Validators.emptyValidator,
                          textEditingController: yearController,
                          hintText: "year",
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              customForm(
                validator: Validators.emptyValidator,
                textEditingController: amountController,
                hintText: "amount",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Consumer<PayStackChangeNotifier>(
                builder: (context, provider, child) {
                  if (provider.requestStatus == RequestStatus.loading) {
                    return const CupertinoActivityIndicator();
                  }

                  if (provider.requestStatus == RequestStatus.success) {
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("success"),
                        ));
                      });
                    }
                  }

                  if (provider.requestStatus == RequestStatus.failure) {
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("failed ${provider.error}"),
                        ));
                      });
                    }
                  }

                  return customButton(
                      function: () {
                        if (!formKey.currentState!.validate()){
                          return;
                        }


                        provider.chargeCard(
                            cardNumber: cardNumberController.text,
                            cvv: cvvController.text,
                            month: monthController.text,
                            year: yearController.text,
                            amount:
                                "${(int.tryParse(amountController.text)! * 100)}");
                      },
                      child: const Text("Give me money"));
                },
              )
            ]),
          ),
        ));
  }
}
