library shark.views.tags.dart2;

String render({String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  hello() => print('Hello, world!');
  _sb_.writeln('');
  _sb_.write('');
  return _sb_.toString();
}
