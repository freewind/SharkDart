library shark.views.tags.outer1;

import './inner1.dart' as _shark_render_8;
import './inner2.dart' as _shark_render_10;

String render({String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
  _sb_.writeln('<div>');
_sb_.write('');
    var title_9 = () {
    var _sb_ = new StringBuffer();
    _sb_.write('Top banner');
    return _sb_.toString();
    }();
    _sb_.write(_shark_render_8.render(title: title_9, implicitBody_ : () {
    var _sb_ = new StringBuffer();
    return _sb_.toString();
    }));
    _sb_.writeln('</div>');
    _sb_.writeln('<div>');
_sb_.write('');
      var title_11 = () {
      var _sb_ = new StringBuffer();
      _sb_.write('Main panel');
      return _sb_.toString();
      }();
      _sb_.write(_shark_render_10.render(title: title_11, implicitBody_ : () {
      var _sb_ = new StringBuffer();
      return _sb_.toString();
      }));
      _sb_.writeln('</div>');
_sb_.write('');
  return _sb_.toString();
}
