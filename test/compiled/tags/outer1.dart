library shark.views.tags.outer1;

import './inner1.dart' as _shark_render_6;
import './inner2.dart' as _shark_render_8;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('<div>');
_sb_.write('');
    var title_7 = () {
    var _sb_ = new StringBuffer();
    _sb_.write('Top banner');
    return _sb_.toString();
    }();
    _sb_.write(_shark_render_6.render(title: title_7, implicitBody_ : () {
    var _sb_ = new StringBuffer();
    return _sb_.toString();
    }));
    _sb_.writeln('</div>');
    _sb_.writeln('<div>');
_sb_.write('');
      var title_9 = () {
      var _sb_ = new StringBuffer();
      _sb_.write('Main panel');
      return _sb_.toString();
      }();
      _sb_.write(_shark_render_8.render(title: title_9, implicitBody_ : () {
      var _sb_ = new StringBuffer();
      return _sb_.toString();
      }));
      _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
