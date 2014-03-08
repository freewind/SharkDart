library shark.views.tags.if1;

String render({String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('Hello,');
  _sb_.write('');
  if (1 == 2) {
    _sb_.writeln('');
    _sb_.writeln('  world!');
    _sb_.write('');
  }
  _sb_.writeln('');
  _sb_.write('');
  return _sb_.toString();
}
