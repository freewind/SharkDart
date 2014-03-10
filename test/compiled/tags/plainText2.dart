library shark.views.tags.plainText2;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('<div>');
_sb_.write('');
    _sb_.write('@hello() {}');
    _sb_.writeln('');
    _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
