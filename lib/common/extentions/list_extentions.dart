part of 'extentions.dart';

extension IterableExtentions<T> on Iterable<T> {
  T? getElementAt(int index, { T? or }) {
    if(index < 0 || index >= length) return or;
    return elementAt(index);
  }
}

extension PaddingExtention on List<Widget> {
  List<Widget> wrapAll(Widget Function(Widget sourceItem) widgetBuilder) {
    return map(widgetBuilder).toList();
  }

  List<Widget> withPadding({required EdgeInsetsGeometry padding, Key? key}) {
    return wrapAll((item) => Padding(padding: padding, key: key, child: item));
  }

  List<Widget> withPaddingBottom({required double value, Key? key}) {
    return withPadding(padding: EdgeInsets.only(bottom: value), key: key);
  }
}