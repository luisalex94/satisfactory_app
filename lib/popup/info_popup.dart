import 'package:flutter/material.dart';

class InfoPopup extends StatefulWidget {
  const InfoPopup({super.key});

  @override
  State<InfoPopup> createState() => _InfoPopupState();
}

class _InfoPopupState extends State<InfoPopup> {
  @override
  Widget build(BuildContext context) {
    return _info();
  }

  Widget _info() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
        border: Border.all(width: 1),
      ),
      width: 500,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _mainInfo(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                _nextSteps(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                _quickRecipe(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                _factoryRecipe(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                _appIconCopyright(),
              ],
            ),
          )),
    );
  }

  Widget _nextSteps() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.code),
            SizedBox(
              width: 8,
            ),
            Text(
              'Next steps',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'First, listen to suggestions from you, the public.',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '1. Cache the factories and recipes so you can reopen everything as you left it.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '2. Add recipes that come with new updates.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '3. Add tutorials to get the most out of the application.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '4. Improve the interface and user experience.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ],
    );
  }

  Widget _mainInfo() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline),
            SizedBox(
              width: 8,
            ),
            Text(
              'About',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'Version 0.1.0',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          'July 2024',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          'Contact or issues: app.satisfactory@gmail.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _quickRecipe() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline),
            SizedBox(
              width: 8,
            ),
            Text(
              'Quick recipe',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'We can see the basic recipe for an item by selecting the item from the left list. We can enter how many items per minute we want per minute.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Row(
          children: [
            Text(
              'Example: Iron plate, 120 items per minute:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Row(
          children: [
            Text(
              'The blue ones are factories, it tells us the following:\n\n1. What it manufactures.\n2. Type of factory and how many are needed.\n3. Item output and total between factories (in bold).\n4. Item input and total between factories (in bold).',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Row(
          children: [
            Text(
              'The yellow ones indicate the raw material.\n\n1. What raw material.\n2. With which extractor it is obtained.\n3. Total item output required.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'So:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Row(
          children: [
            Text(
              'Box 1 (yellow):\nYou must extract 180 Iron Ore per minute.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Row(
          children: [
            Text(
              'Box 2 (blue):\nManufacture Iron ingot.\nRequires 6 Smelters.\n180 output per minute from all 6 smelters.\nRequires 180 Iron Ore per minute from all 6 smelters.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Row(
          children: [
            Text(
              'Box 3 (blue):\nManufacture Iron plate\nRequires 6 Builder\n120 output per minute from all 6 builders\nRequires 180 Iron ingot per minute from all 6 builders.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ],
    );
  }

  Widget _factoryRecipe() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.factory_outlined),
            SizedBox(
              width: 10,
            ),
            Text(
              'Factories',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        Text(
          'We now have factory collections, this is useful when we want to manufacture multiple items in one place on the map, for example, 100 iron plate and 100 wire.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'To do this, we can click on "Add factory" in the "Main factory" and add the items and the amount of items we want per minute.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'We can see the amount of resources we need per minute on the left side (when selecting an item from the factory collection).',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'We can even check off the resources we already brought, the factories we already built or the builders we already placed.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'If you tap on a blue box, it will turn green, so we can check off what we have already installed.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'If the recipe is changed, these will turn blue again, as the amount of factories needed changes.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'We can even add more factory collections by clicking on the factory icon, this will add independent factory collections to each other.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        Text(
          'Always be careful to have the resource list open that corresponds to each factory collection. At the top of the resource list is the name of the collection to which that resource list belongs.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
      ],
    );
  }

  Widget _appIconCopyright() {
    return const Text(
      'App icon copyright:\nGame boy advance iconos creados por Tru3 Art - Flaticon\nhttps://www.flaticon.es/iconos-gratis/game-boy-advance',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black45,
      ),
      textAlign: TextAlign.center,
    );
  }
}
