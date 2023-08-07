
///Paystack
const payStackInitializeTransactionUrl = "https://api.paystack.co/transaction/initialize"; //Post
String payStackVerifyTransactionUrl(String referenceCode) {
  return "https://api.paystack.co/transaction/verify/$referenceCode";
}
const payStackCharge = "https://api.paystack.co/charge";
const payStackSecretKey = "sk_test_ae676f802f9650110b8c4d5036f3abb8410f0efc";



