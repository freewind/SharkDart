library shark.views.tags.dart2;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
    hello() => print('Hello, world!');
    _sb_.writeln('');
_sb_.write('');
  return _sb_.toString();
}
