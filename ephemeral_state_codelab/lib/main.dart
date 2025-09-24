import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

/// Model Counter: simpan nilai, warna, dan label
class CounterItem {
  int value;
  Color color;
  String label;

  CounterItem({this.value = 0, required this.color, required this.label});
}

/// GlobalState: atur semua counter
class GlobalState extends ChangeNotifier {
  List<CounterItem> _counters = [];

  List<CounterItem> get counters => _counters;

  /// tambah counter baru
  void addCounter() {
    final random = Random();
    _counters.add(
      CounterItem(
        value: 0,
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        label: "Counter ${_counters.length + 1}",
      ),
    );
    notifyListeners();
  }

  /// hapus counter
  void removeCounter(int index) {
    if (index >= 0 && index < _counters.length) {
      _counters.removeAt(index);
      notifyListeners();
    }
  }

  /// naikkan nilai
  void increment(int index) {
    _counters[index].value++;
    notifyListeners();
  }

  /// turunkan nilai (min 0)
  void decrement(int index) {
    if (_counters[index].value > 0) {
      _counters[index].value--;
      notifyListeners();
    }
  }

  /// ubah label dan warna
  void updateCounter(int index, String newLabel, Color newColor) {
    _counters[index].label = newLabel;
    _counters[index].color = newColor;
    notifyListeners();
  }

  /// urutkan ulang (drag and drop)
  void reorderCounters(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _counters.removeAt(oldIndex);
    _counters.insert(newIndex, item);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: MyApp(),
    ),
  );
}

/// Aplikasi utama
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Advanced State Management")),
        body: CounterList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<GlobalState>(context, listen: false).addCounter();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

/// List semua counter
class CounterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (context, state, child) {
        return ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            state.reorderCounters(oldIndex, newIndex);
          },
          children: [
            for (int index = 0; index < state.counters.length; index++)
              Card(
                key: ValueKey(index),
                color: state.counters[index].color.withOpacity(0.2),
                child: ListTile(
                  title: Text(
                    "${state.counters[index].label}:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      '${state.counters[index].value}',
                      key: ValueKey<int>(state.counters[index].value),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => state.decrement(index)),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => state.increment(index)),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, state, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => state.removeCounter(index),
                      ),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  /// popup edit label dan warna
  void _showEditDialog(BuildContext context, GlobalState state, int index) {
    final controller =
        TextEditingController(text: state.counters[index].label);
    Color selectedColor = state.counters[index].color;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Counter"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Label"),
            ),
            Wrap(
              spacing: 8,
              children: Colors.primaries.take(6).map((color) {
                return GestureDetector(
                  onTap: () {
                    selectedColor = color;
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: selectedColor == color ? Icon(Icons.check) : null,
                  ),
                );
              }).toList(),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              state.updateCounter(index, controller.text, selectedColor);
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }
}
