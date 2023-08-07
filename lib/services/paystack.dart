import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../repository/paystack.dart';
import '../utils/common.dart';

class PayStackChangeNotifier with ChangeNotifier {
  PayStackChangeNotifier(this.payStackPayment);

  final PayStackPayment payStackPayment;

  RequestStatus requestStatus = RequestStatus.initial;
  String error = "";

  //setters and getters
  set updateStatus(RequestStatus status) {
    requestStatus = status;
    notifyListeners();
  }

  //end

  Future<void> chargeCard({
    required String cardNumber,
    required String cvv,
    required String month,
    required String year,
    required String amount,
  }) async {
    try {
      updateStatus = RequestStatus.loading;

      final response = await payStackPayment.chargeCard(
        amount: amount,
        cardData: {
          "number": cardNumber,
          "cvv": cvv,
          "expiry_month": month,
          "expiry_year": year,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data is ${data}");
        updateStatus = RequestStatus.success;

      }else{
        debugPrint("non 200 error ${response.body}");
        error = "Unknown error,";
        updateStatus = RequestStatus.failure;
      }
    } on TimeoutException catch (e) {
      debugPrint("request timeout $e");
      error = "Request timed out";
      updateStatus = RequestStatus.failure;
    } on ClientException catch (e) {
      debugPrint("client exception  $e");
      error = "Please make sure you have an internet connection";
      updateStatus = RequestStatus.failure;
    } catch (e) {
      debugPrint("Could not charge card $e");
      error = "Could not charge card";
      updateStatus = RequestStatus.failure;
    }
  }
}
