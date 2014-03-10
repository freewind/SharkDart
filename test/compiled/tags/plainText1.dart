library shark.views.tags.plainText1;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('<div>');
_sb_.write('');
    _sb_.writeln('');
    _sb_.writeln('');
    _sb_.writeln('');
    _sb_.writeln('');
    _sb_.writeln('  @hello() {}');
    _sb_.writeln('');
    _sb_.writeln('');
    _sb_.writeln('');
_sb_.write('');
    _sb_.writeln('');
    _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
