library shark.views.users.index;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('<h1>List all users</h1>');
  _sb_.writeln('<div>There is no users found.</div>');
_sb_.write('');
  return _sb_.toString();
}
