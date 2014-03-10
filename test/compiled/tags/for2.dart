library shark.views.tags.for2;

String render({List<String> users, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
      _sb_.writeln('[');
_sb_.write('');
        if (users != null) {
          int index_6 = 0;
          int total_7 = users.length;
          for (var user in users) {
            int user_index = index_6;
            bool user_isFirst = index_6 == 0;
            bool user_isLast = index_6 == total_7 - 1;
            bool user_isOdd = index_6 % 2 == 1;
            bool user_isEven = index_6 % 2 == 0;
            if(!user_isFirst) {
        _sb_.write(',');
            }
            index_6++;
          _sb_.writeln('');
_sb_.write('  { \'name\' : \'');
          _sb_.write(user);
          _sb_.writeln('\' }');
_sb_.write('');
          }
        }
        _sb_.writeln('');
        _sb_.writeln(']');
_sb_.write('');
  return _sb_.toString();
}
