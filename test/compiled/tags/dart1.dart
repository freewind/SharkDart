library shark.views.tags.dart1;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
    
  hello(who) => 'Hello, $who!';

    _sb_.writeln('');
    _sb_.writeln('');
_sb_.write('<div>');
    _sb_.write(hello('SharkDart'));
    _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
