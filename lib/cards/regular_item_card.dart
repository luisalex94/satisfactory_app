import 'package:flutter/material.dart';
import 'package:satisfactory_app/handlers/factories_handlers.dart';
import '../handlers/material_item.dart';

class RegularItemcard extends StatefulWidget {
  final MaterialItem? material;

  const RegularItemcard({super.key, this.material});

  @override
  State<RegularItemcard> createState() => _RegularItemcardState();
}

class _RegularItemcardState extends State<RegularItemcard> {
  bool ready = false;

  @override
  void didUpdateWidget(RegularItemcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.material != oldWidget.material) {
      setState(() {
        ready = false; // Restablecer el estado
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.material!.ore) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber[100],
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        child: Column(
          children: [
            Text(widget.material!.materialName),
            //Text(material.materialId.toString()),
            Text(widget.material!.fact),
            const Divider(),
            widget.material!.oreOutputPm != 0
                ? Text(
                    'InputPM: ${(widget.material!.oreOutputPm.toStringAsFixed(2))}',
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : Container(),
          ],
        ),
      );
    } else if (widget.material!.materialId != 0) {
      return GestureDetector(
        onTap: () {
          setState(() {
            ready = !ready;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ready ? Colors.green[100] : Colors.blue[100],
            border: Border.all(width: 1),
          ),
          height: 200,
          width: 200,
          child: Column(
            children: [
              Text(widget.material!.materialName),
              //Text(material.materialId.toString()),
              Text(
                  '${widget.material!.fact}: ${widget.material!.factQuantity}'),
              Text(
                  'Output: ${widget.material!.recipes['1']!.output.toString()}'),
              Text(
                  'Output PM: ${widget.material!.recipes['1']!.outputPm.toString()}'),
              Text(
                'Modified Output PM: ${(widget.material!.recipes['1']!.outputModifiedPm.toStringAsFixed(2))}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              widget.material!.recipes['1']!.materials['1']?.input != null
                  ? Text(
                      '1 - ${widget.material!.recipes['1']!.materials['1']?.materialName}: ${widget.material!.recipes['1']!.materials['1']?.inputPm} (${(widget.material!.recipes['1']!.materials['1']?.inputModifiedPm)!.toStringAsFixed(2)})')
                  : Container(),
              widget.material!.recipes['1']!.materials['2']?.input != null
                  ? Text(
                      '2 - ${widget.material!.recipes['1']!.materials['2']?.materialName}: ${widget.material!.recipes['1']!.materials['2']?.inputPm} (${(widget.material!.recipes['1']!.materials['2']?.inputModifiedPm.toStringAsFixed(2))})')
                  : Container(),
              widget.material!.recipes['1']!.materials['3']?.input != null
                  ? Text(
                      '3 - ${widget.material!.recipes['1']!.materials['3']?.materialName}: ${widget.material!.recipes['1']!.materials['3']?.inputPm} (${(widget.material!.recipes['1']!.materials['3']?.inputModifiedPm.toStringAsFixed(2))})')
                  : Container(),
              widget.material!.recipes['1']!.materials['4']?.input != null
                  ? Text(
                      '4 - ${widget.material!.recipes['1']!.materials['4']?.materialName}: ${widget.material!.recipes['1']!.materials['4']?.inputPm} (${(widget.material!.recipes['1']!.materials['4']?.inputModifiedPm.toStringAsFixed(2))})')
                  : Container(),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        //child: const Text('No item'),
      );
    }
  }
}

class CollectionItemcard extends StatefulWidget {
  const CollectionItemcard({
    required this.material,
    required this.collectionName,
    required this.materialName,
    required this.row,
    required this.column,
    super.key,
  });

  final MaterialItem? material;
  final String collectionName;
  final String materialName;
  final int row;
  final int column;

  @override
  State<CollectionItemcard> createState() => _CollectionItemcardState();
}

class _CollectionItemcardState extends State<CollectionItemcard> {
  bool ready = false;

  @override
  void didUpdateWidget(CollectionItemcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.material != oldWidget.material) {
      setState(
        () {
          ready = false; // Restablecer el estado
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ready = FactoriesHandlers().getReadyMaterialItem(
      factoryCollectionName: widget.collectionName,
      factoryConfigurationName: widget.materialName,
      materialName: widget.materialName,
      row: widget.row,
      column: widget.column,
    );
    if (widget.material!.ore) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber[100],
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        child: Column(
          children: [
            Text(widget.material!.materialName),
            //Text(material.materialId.toString()),
            Text(widget.material!.fact),
            const Divider(),
            widget.material!.oreOutputPm != 0
                ? Text(
                    'InputPM: ${(widget.material!.oreOutputPm.toStringAsFixed(2))}',
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : Container(),
          ],
        ),
      );
    } else if (widget.material!.materialId != 0) {
      return GestureDetector(
        onTap: () {
          setState(
            () {
              ready = !ready;
              FactoriesHandlers().setReadyMaterialItem(
                factoryCollectionName: widget.collectionName,
                factoryConfigurationName: widget.materialName,
                materialName: widget.materialName,
                row: widget.row,
                column: widget.column,
                ready: ready,
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ready ? Colors.green[100] : Colors.blue[100],
            border: Border.all(width: 1),
          ),
          height: 200,
          width: 200,
          child: Column(
            children: [
              Text(widget.material!.materialName),
              //Text(material.materialId.toString()),
              Text(
                  '${widget.material!.fact}: ${widget.material!.factQuantity}'),
              Text(
                  'Output: ${widget.material!.recipes['1']!.output.toString()}'),
              Text(
                  'Output PM: ${widget.material!.recipes['1']!.outputPm.toString()}'),
              Text(
                'Modified Output PM: ${(widget.material!.recipes['1']!.outputModifiedPm.toStringAsFixed(2))}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              widget.material!.recipes['1']!.materials['1']?.input != null
                  ? Text(
                      '1 - ${widget.material!.recipes['1']!.materials['1']?.materialName}: ${widget.material!.recipes['1']!.materials['1']?.inputPm} (${(widget.material!.recipes['1']!.materials['1']?.inputModifiedPm)!.toStringAsFixed(2)})')
                  : Container(),
              widget.material!.recipes['1']!.materials['2']?.input != null
                  ? Text(
                      '2 - ${widget.material!.recipes['1']!.materials['2']?.materialName}: ${widget.material!.recipes['1']!.materials['2']?.inputPm} (${(widget.material!.recipes['1']!.materials['2']?.inputModifiedPm.toStringAsFixed(2))})')
                  : Container(),
              widget.material!.recipes['1']!.materials['3']?.input != null
                  ? Text(
                      '3 - ${widget.material!.recipes['1']!.materials['3']?.materialName}: ${widget.material!.recipes['1']!.materials['3']?.inputPm} (${(widget.material!.recipes['1']!.materials['3']?.inputModifiedPm.toStringAsFixed(2))})')
                  : Container(),
              widget.material!.recipes['1']!.materials['4']?.input != null
                  ? Text(
                      '4 - ${widget.material!.recipes['1']!.materials['4']?.materialName}: ${widget.material!.recipes['1']!.materials['4']?.inputPm} (${(widget.material!.recipes['1']!.materials['4']?.inputModifiedPm.toStringAsFixed(2))})')
                  : Container(),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        //child: const Text('No item'),
      );
    }
  }
}
