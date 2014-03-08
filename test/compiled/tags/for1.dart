library shark.views.tags.for1;

String render({String _body_()}) {
  if (_body_ == null) {
    _body_ = () => '';
  }
  var _sb_ = new StringBuffer();
  if (users != null) {
    int index_0 = 0;
    int total_1 = 5;
    for (var user in users) {
      int user_index = index_0;
      bool user_isFirst = index_0 == 0;
      bool user_isLast = index_0 == total_1;
      bool user_isOdd = index_0 % 2 == 1;
      bool user_isEven = index_0 % 2 == 0;
      index_0++;
      _sb_.writeln('');
      _sb_.write('  Hello, ');
      _sb_.write(user);
      _sb_.writeln('');
      _sb_.write('');
    }
  }
  _sb_.writeln('');
  _sb_.write('');
  return _sb_.toString();
}
