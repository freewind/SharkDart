library shark.views.tags.params1;

String render({String user}) {
  var sb = new StringBuffer();
  sb.writeln('');
  sb.write('  <div>hello, ');
  sb.write(user);
  sb.writeln('</div>');
  sb.write('');
  sb.writeln('');
  sb.write('');
  return sb.toString();
}
