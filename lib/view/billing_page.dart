import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/util.dart';
import 'package:question/widget/entry_column.dart';
import 'package:question/widget/submit_button.dart';

class BillingPage extends StatefulWidget {
  BillingPage({Key key, @required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final teName = TextEditingController();
  final teFirst = TextEditingController();
  final teSecond = TextEditingController();
  final teCode = TextEditingController();
  final teCity = TextEditingController();
  Country _selectedCountry = Country.FR;

  @override
  void initState() {
    super.initState();
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informations de facturation",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    EntryColumn(
                      title: "Nom Prénom*",
                      hint: "Nom Prénom*",
                      teController: teName,
                    ),
                    SizedBox(height: 16),
                    EntryColumn(
                      title: "Première ligne d'adresse*",
                      hint: "première ligne d'adresse*",
                      teController: teFirst,
                    ),
                    SizedBox(height: 16),
                    EntryColumn(
                      title: "Seconde ligne d'adresse",
                      hint: "Seconde ligne d'adresse",
                      teController: teSecond,
                    ),
                    SizedBox(height: 16),
                    EntryColumn(
                      title: "Code postal*",
                      hint: "Code postal*",
                      teController: teCode,
                    ),
                    SizedBox(height: 16),
                    EntryColumn(
                      title: "Ville*",
                      hint: "Ville*",
                      teController: teCity,
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pays*",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(232, 240, 254, 1.0),
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: COLOR.GRAY, width: 0.5)),
                          child: CountryPicker(
                            // showDialingCode: true,
                            onChanged: (Country country) {
                              setState(() {
                                _selectedCountry = country;
                              });
                            },
                            selectedCountry: _selectedCountry,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Align(
                      alignment: Alignment.center,
                      child: SubmitButton(
                        title: "Valider",
                        callback: () {
                          becomeCustomer();
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
                          style: TextStyle(fontSize: 18, color: COLOR.BLUE),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future becomeCustomer() async {
    FocusScope.of(context).unfocus();

    String name = teName.text.trim();
    String first = teFirst.text.trim();
    String second = teSecond.text.trim();
    String code = teCode.text.trim();
    String city = teCity.text.trim();

    if (name.isEmpty) {
      showToast(context, "Veuillez saisir votre nom");
      return;
    }

    if (first.isEmpty) {
      showToast(context, "Veuillez saisir votre première ligne d'adresse");
      return;
    }

    if (code.isEmpty) {
      showToast(context, "Veuillez saisir votre code postal");
      return;
    }

    if (city.isEmpty) {
      showToast(context, "Veuillez saisir votre ville");
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    String result = await Util.becomeCustomer(
        name, first, second, code, city, _selectedCountry.name);
    await progress.hide();

    if (result == "Success") {
      Navigator.of(context)
          .popAndPushNamed(ROUTE.PAYMENT, arguments: widget.data);
    } else {
      showToast(context, result);
    }
  }
}
