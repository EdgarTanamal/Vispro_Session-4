import 'package:flutter/material.dart';

class GlobalState {
  List<int> counters = [];
  List<Color> counterColors = [];

  void addCounter({required Color color}) {
    counters.add(0);
    counterColors.add(Colors.blue); // Set a default color (e.g., blue) for the new counter
  }

  void incrementCounter(int index) {
    if (index >= 0 && index < counters.length) {
      counters[index]++;
    }
  }

  void decrementCounter(int index) {
    if (index >= 0 && index < counters.length && counters[index] > 0) {
      counters[index]--;
    }
  }

  void removeCounter(int index) {
    if (index >= 0 && index < counters.length) {
      counters.removeAt(index);
      counterColors.removeAt(index); // Remove the color for the removed counter
    }
  }

  void reorderCounter(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final counter = counters.removeAt(oldIndex);
    counters.insert(newIndex, counter);
    final color = counterColors.removeAt(oldIndex);
    counterColors.insert(newIndex, color);
  }

  void changeCounterColor(int index, Color color) {
    if (index >= 0 && index < counters.length) {
      counterColors[index] = color;
    }
  }
}
