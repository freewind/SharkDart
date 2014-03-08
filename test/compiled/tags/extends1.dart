library shark.views.tags.extends1;

import './layout1.dart' as _shark_layout_0;

String render({String user, String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  var user_1 =
  _sb_.write('user');
  _sb_.writeln('This is inner page!');
  _sb_.write('');
  return _shark_layout_0.render(user: user_1, _body_ : () => _sb_.toString());
}
