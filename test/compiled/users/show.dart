library shark.views.users.show;

String render({String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('Show user');
  _sb_.write('');
  return _sb_.toString();
}
