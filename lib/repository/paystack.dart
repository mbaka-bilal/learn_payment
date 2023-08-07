import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/common.dart';
import '../utils/constants.dart';

class PayStackPayment {
  /// First its important we how it works
  /// So far what i have gathered is we have a list of customers and when
  /// we initialize a transaction if the customer does not exist paystack
  /// creates one for us with the email, and the email does not actually have
  /// to exist it can be anything it is just used to identify a customer and/or
  /// unique transaction, the main thing that is verified is the card, payment
  /// and shit like that.
  /// Now to see this list of customers you can log in to your paystack account
  /// go to the dashboard and you will see a list of customers/transactions and
  /// see the status of each and from there you will see your total balance.
  /// Note that the total balance does not update of test account (doodooi..)
  /// So those are the things i understand for basic accepting of payment
  /// 17 July 2023 (18:02) (Georgian calendar)
  ///
  ///Steps
  /// 1. Initialize transaction, no need to create a customer paystack automatically
  /// creates a customer with the corresponding email.
  /// 2. For the basic transaction where we don't use a backend but use the
  /// response from paystack. paystack responds with a url for verifiying the
  /// transaction and a reference code to verify the transaction.
  /// 3. open the url from the response from paystack, we have used
  /// urlLauncher package
  /// 4. Verify the transaction.

  //Step 1
  Future<http.Response> initializeTransaction(
      {required String email, required double amount}) async {
    //Amount should be in kobo (To do that multiply by 100)

      final url = Uri.parse(payStackInitializeTransactionUrl);

      final result = await http.post(url, headers: {
        HttpHeaders.authorizationHeader: "Bearer $payStackSecretKey",
      }, body: {
        "email": email,
        "amount": amount.toString(),
      });

      return result;


}

  Future<http.Response> chargeCard({

    required Map<String,dynamic> cardData,
    required String amount,
}) async {
    final url = Uri.parse(payStackCharge);

    final result = await http.post(url,headers: {
      HttpHeaders.authorizationHeader: "Bearer $payStackSecretKey",
    },body: jsonEncode(
        {
          "email": "dashbilalmoney@email.com",
          "amount": amount,
          "card": cardData,
        }
    )).timeout(const Duration(seconds: 30));

    return result;
  }

}
