import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaypalPopup extends StatefulWidget {
  const PaypalPopup({super.key});

  @override
  State<PaypalPopup> createState() => _PaypalPopupState();
}

class _PaypalPopupState extends State<PaypalPopup> {
  final Uri _url = Uri.parse(
      'https://paypal.me/AppSatisfactory?country.x=MX&locale.x=es_XC');

  @override
  Widget build(BuildContext context) {
    return _paypal();
  }

  Widget _paypal() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //color: Colors.white,
        //border: Border.all(width: 1),
      ),
      //height: 380,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage('lib/assets/paypal_logo.png'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy the development team a coffee',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Or a beer, who cares?',
                        style: TextStyle(
                          fontSize: 14,
                          //color: Colors.white24
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            const Text(
              'The team that developed this application is very happy to provide you with this tool, if you can\'t donate, don\'t worry, this tool is so you can forget about tedious calculations and have more fun than ever in this beautiful game.',
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            const Text(
              'Entire days of work so that you can see the recipes with just one click.',
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            const Text(
              'Your donation helps us continue to improve the app and we\'ll be ready when the next version of Satisfactory is released.',
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _launchUrl();
              },
              child: const Text(
                'Donate (Thank you!)',
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
