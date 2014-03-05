library shark.views.users.index;

String render() {
  var sb = new StringBuffer();
  sb.writeln('<h1>List all users</h1>');
  sb.writeln('<div>There is no users found.</div>');
  sb.write('');
  return sb.toString();
}
