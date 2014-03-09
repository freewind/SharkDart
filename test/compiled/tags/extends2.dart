library shark.views.tags.extends2;

import 'layout1.dart' as _shark_layout_0;

String render({String user, String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  var user_1 = () {
    var _sb_ = new StringBuffer();
    _sb_.write(user);
    return _sb_.toString();
  }();
  _sb_.write(_shark_layout_0.render(user: user_1, _body_ : () {
    var _sb_ = new StringBuffer();
    _sb_.writeln('This is inner page!');
    _sb_.write('');
    return _sb_.toString();
  }));
  return _sb_.toString();
}
