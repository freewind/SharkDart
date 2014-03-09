library shark.views.tags.layout1;

String render({String user, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
      _sb_.write('<div>Hello, ');
      _sb_.write(user);
      _sb_.writeln('!</div>');
_sb_.write('<div>');
        _sb_.write(implicitBody_());
        _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
