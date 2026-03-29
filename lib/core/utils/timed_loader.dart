import 'dart:async';

Future<T> withMinDuration<T>(
  Future<T> future, {
  Duration minDuration = const Duration(milliseconds: 600),
}) async {
  final results = await Future.wait([future, Future.delayed(minDuration)]);
  return results[0] as T;
}
