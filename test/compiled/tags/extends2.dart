library shark.views.tags.extends2;

import 'layout1.dart' as _shark_render_0;

String render({String user, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
        var user_1 = () {
          var _sb_ = new StringBuffer();
        _sb_.write(user);
          return _sb_.toString();
        }();
        _sb_.write(_shark_render_0.render(user: user_1, implicitBody_ : () {
          var _sb_ = new StringBuffer();
          _sb_.write('This is inner page with ');
          _sb_.write(user);
          _sb_.writeln('!');
_sb_.write('');
          return _sb_.toString();
        }));
  return _sb_.toString();
}
