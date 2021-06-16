import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/util.dart';
import 'package:question/widget/submit_button.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key, @required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String invoice = "";
  String publicKey = "";
  String clientSecret = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      makePayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "images/wave.png",
              color: COLOR.BLUE,
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Paiement",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Payer 0.99 € pour 1 page(s) de cours.",
                      style: TextStyle(fontSize: 16),
                    ),
                    (invoice.isEmpty)
                        ? SizedBox(height: 8)
                        : CreditCardWidget(
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            showBackView: isCvvFocused,
                            obscureCardNumber: true,
                            obscureCardCvv: true,
                          ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            (invoice.isEmpty)
                                ? Container()
                                : CreditCardForm(
                                    formKey: formKey,
                                    obscureCvv: true,
                                    obscureNumber: true,
                                    cardNumberDecoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Number',
                                      hintText: 'XXXX XXXX XXXX XXXX',
                                    ),
                                    expiryDateDecoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Expired Date',
                                      hintText: 'XX/XX',
                                    ),
                                    cvvCodeDecoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'CVV',
                                      hintText: 'XXX',
                                    ),
                                    cardHolderDecoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Card Holder',
                                    ),
                                    onCreditCardModelChange:
                                        onCreditCardModelChange,
                                  ),
                            SizedBox(height: 16),
                            Text(
                              "Votre paiement est sécurisé et vos données ne sont pas enregistrées.",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 32),
                            Align(
                              alignment: Alignment.center,
                              child: SubmitButton(
                                title: "Payer 0.99 € et demander mon QCM",
                                callback: () {
                                  if (formKey.currentState.validate()) {
                                    makeStripePay();
                                  } else {
                                    showToast(context, "Invalid Card Info");
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 32),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(
                                      fontSize: 18, color: COLOR.BLUE),
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void makeStripePay() async {
    FocusScope.of(context).unfocus();

    String month = expiryDate.split("/")[0];
    String year = expiryDate.split("/")[1];

    CreditCard card = CreditCard(
      number: cardNumber,
      expMonth: int.tryParse(month),
      expYear: int.tryParse(year),
    );

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: card,
      ),
    ).then((paymentMethod) {
      print("payment method ===");
      StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: clientSecret,
          paymentMethodId: paymentMethod.id,
        ),
      ).then((paymentIntent) async {
        print('Received ${paymentIntent.paymentIntentId}');
        await progress.hide();
        makeRequest();
      }).catchError((e) async {
        await progress.hide();
        showToast(context, e.toString());
      });
    }).catchError((e) async {
      await progress.hide();
      showToast(context, e.toString());
    });
  }

  Future makePayment() async {
    // Map<String, dynamic> data = {
    //                           "type": isQCM ? "mcq" : "asmr",
    //                           "uploads": uploads,
    //                         };

    String type = widget.data["type"];
    List<Map<String, dynamic>> uploads = widget.data["uploads"];
    double price = uploads.length * 0.99;

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    dynamic result = await Util.makePayment(price, uploads.length, type);
    await progress.hide();

    if (result is Map) {
      setState(() {
        publicKey = result["public"];
        clientSecret = result["secret"];
        invoice = result["invoice"];

        StripePayment.setOptions(StripeOptions(publishableKey: publicKey));
      });
    } else {
      showToast(context, result);
    }
  }

  Future makeRequest() async {
    String type = widget.data["type"];
    List<Map<String, dynamic>> uploads = widget.data["uploads"];
    List<String> files = uploads.map((e) => e["uuid"].toString()).toList();

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    String result = await Util.makeRequest(type, files, invoice);
    await progress.hide();

    if (result == "Success") {
      showToast(context, "Félicitations !");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      showToast(context, result);
    }
  }
}
