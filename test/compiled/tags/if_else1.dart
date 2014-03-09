library shark.views.tags.if_else1;

String render({int num, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
      _sb_.writeln('Hello, the number is:');
_sb_.write('');
        if (num == 1) {
          _sb_.writeln('');
          _sb_.writeln('  ONE!');
_sb_.write('');
        }
          else {
            _sb_.writeln('');
            _sb_.writeln('  NOT ONE!');
_sb_.write('');
          }
          _sb_.writeln('');
_sb_.write('');
  return _sb_.toString();
}
