library shark.views.users.show;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('Show user');
_sb_.write('');
  return _sb_.toString();
}
