import 'package:flutter/material.dart';
import 'package:global_state_management/global_state.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyStatefulWidgetApp());
}

class MyStatefulWidgetApp extends StatefulWidget {
  @override
  _MyStatefulWidgetAppState createState() => _MyStatefulWidgetAppState();
}

class _MyStatefulWidgetAppState extends State<MyStatefulWidgetApp> {
  GlobalState globalState = GlobalState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Stateful Counter App')),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  globalState.addCounter(color: Colors.white);
                });
              },
              child: Text('Add Counter'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    _reorderCounters(oldIndex, newIndex);
                  });
                },
                children: List.generate(globalState.counters.length, (index) {
                  return ListTile(
                    key: ValueKey(index),
                    title: CounterWidget(
                      index: index,
                      globalState: globalState,
                      onRemove: () {
                        setState(() {
                          globalState.removeCounter(index);
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reorderCounters(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final counterToReorder = globalState.counters.removeAt(oldIndex);
    globalState.counters.insert(newIndex, counterToReorder);
  }
}

class CounterWidget extends StatefulWidget {
  final int index;
  final GlobalState globalState;
  final VoidCallback onRemove;

  CounterWidget({required this.index, required this.globalState, required this.onRemove});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.globalState.counterColors[widget.index]; // Get the color for this counter index from GlobalState

    return Card(
      key: Key('counter_${widget.index}'),
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Counter ${widget.index}: ${widget.globalState.counters[widget.index]}'), // Use counters from GlobalState
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                widget.globalState.incrementCounter(widget.index);
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (widget.globalState.counters[widget.index] > 0) {
                  widget.globalState.decrementCounter(widget.index);
                  setState(() {});
                }
              },
            ),
            // Color Picker Button
            ElevatedButton(
              onPressed: () {
                _openColorPicker(context, selectedColor); // Pass the selectedColor
              },
              child: Text('Change Color'),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onRemove();
              },
            ),
          ],
        ),
        tileColor: selectedColor,
      ),
    );
  }

  // Function to open the color picker
  void _openColorPicker(BuildContext context, Color selectedColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  widget.globalState.changeCounterColor(widget.index, color);
                });
              },
            ),
          ),
        );
      },
    );
  }
}