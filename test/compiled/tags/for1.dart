library shark.views.tags.for1;

String render() {
  var sb = new StringBuffer();
  int index_0 = 0;
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
      sb.writeln('');
      sb.write('  Hello, ');
      sb.write(user);
      sb.writeln('');
      sb.write('');
    }
  }
  sb.writeln('');
  sb.write('');
  return sb.toString();
}
