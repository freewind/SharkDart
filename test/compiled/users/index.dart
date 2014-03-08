library shark.views.users.index;

String render({String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('<h1>List all users</h1>');
  _sb_.writeln('<div>There is no users found.</div>');
  _sb_.write('');
  return _sb_.toString();
}
