library shark.views.tags.for1;

String render({List<String> users, String implicitBody_()}) {
  if (implicitBody_ == null) {
     implicitBody_ = () => '';
  }
  var _sb_ = new StringBuffer();
        if (users != null) {
          int index_2 = 0;
          int total_3 = users.length;
          for (var user in users) {
            int user_index = index_2;
            bool user_isFirst = index_2 == 0;
            bool user_isLast = index_2 == total_3 - 1;
            bool user_isOdd = index_2 % 2 == 1;
            bool user_isEven = index_2 % 2 == 0;
            if(!user_isFirst) {
        _sb_.write('');
            }
            index_2++;
          _sb_.writeln('');
_sb_.write('  # index: ');
          _sb_.write(user_index);
          _sb_.writeln('');
_sb_.write('  # isFirst: ');
          _sb_.write(user_isFirst);
          _sb_.writeln('');
_sb_.write('  # isLast: ');
          _sb_.write(user_isLast);
          _sb_.writeln('');
_sb_.write('  # isOdd: ');
          _sb_.write(user_isOdd);
          _sb_.writeln('');
_sb_.write('  # isEven: ');
          _sb_.write(user_isEven);
          _sb_.writeln('');
_sb_.write('  Hello, ');
          _sb_.write(user);
          _sb_.writeln('');
          _sb_.writeln('  ------------');
_sb_.write('');
          }
        }
        _sb_.writeln('');
_sb_.write('');
  return _sb_.toString();
}
