library shark.views.tags.if_elseif_else1;

String render() {
  var sb = new StringBuffer();
  sb.writeln('Hello,');
  sb.write('');
  if (1 == 2) {
    sb.writeln('');
    sb.writeln('  air!');
    sb.write('');
  }
  else if (1 == 3) {
    sb.writeln('');
    sb.writeln('  sky!');
    sb.write('');
  }
  else {
    sb.writeln('');
    sb.writeln('  world!');
    sb.write('');
  }
  sb.writeln('');
  sb.write('');
  return sb.toString();
}
