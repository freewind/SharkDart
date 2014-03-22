library shark.views.tags.extends1;

import './layout1.dart' as _shark_render_6;

String render({String user, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
        var user_7 = () {
          var _sb_ = new StringBuffer();
        _sb_.write(user);
          return _sb_.toString();
        }();
        _sb_.write(_shark_render_6.render(user: user_7, implicitBody_ : () {
          var _sb_ = new StringBuffer();
          _sb_.write('This is inner page with ');
          _sb_.write(user);
          _sb_.writeln('!');
_sb_.write('');
          return _sb_.toString();
        }));
  return _sb_.toString();
}
