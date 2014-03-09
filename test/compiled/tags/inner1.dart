library shark.views.tags.inner1;

String render({String title, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
      _sb_.write('<div>Inner1: ');
      _sb_.write(title);
      _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
