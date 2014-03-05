library shark.views.tags.params2;

String render({String user}) {
  var sb = new StringBuffer();
  sb.write('<div>hello, ');
  sb.write(user);
  sb.writeln('</div>');
  sb.write('');
  return sb.toString();
}
