import 'package:get/get.dart';

class Count extends Rx<int> {
  Count(int initial) : super(initial);

  void increment() => value++;
  void reset() => value = 0;
  void setValue(int newValue) => value = newValue;

  @override
  String toString() => value.toString();
}
