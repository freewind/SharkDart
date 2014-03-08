library shark.views.tags.params1;

String render({String user, String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('');
  _sb_.write('  <div>hello, ');
  _sb_.write(user);
  _sb_.writeln('</div>');
  _sb_.write('');
  _sb_.writeln('');
  _sb_.write('');
  return _sb_.toString();
}
