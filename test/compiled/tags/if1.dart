library shark.views.tags.if1;

String render() {
  var sb = new StringBuffer();
  sb.writeln('Hello,');
  sb.write('');
  if (1 == 2) {
    sb.writeln('');
    sb.writeln('  world!');
    sb.write('');
  }
  sb.writeln('');
  sb.write('');
  return sb.toString();
}
