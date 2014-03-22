library shark.views.tags.for2;

String render({List<String> users, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
      _sb_.writeln('[');
_sb_.write('');
        if (users != null) {
          int index_8 = 0;
          int total_9 = users.length;
          for (var user in users) {
            int user_index = index_8;
            bool user_isFirst = index_8 == 0;
            bool user_isLast = index_8 == total_9 - 1;
            bool user_isOdd = index_8 % 2 == 1;
            bool user_isEven = index_8 % 2 == 0;
            if(!user_isFirst) {
        _sb_.write(',');
            }
            index_8++;
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
