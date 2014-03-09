part of shark_tests;

successParse(String input, String output) {
  var str = parse(input).toString();
  expect(str, output);
}

test_parser() {
  test('@@', () {
    successParse('@@', '[@]');
    successParse('@@@@', '[@@]');
  });
  test('@expr', () {
    successParse('@hello', '[SharkExpression(hello)]');
    successParse('@{hello}', '[SharkExpression(hello)]');
    successParse('@{hello.world()}', '[SharkExpression(hello.world())]');
    successParse('@{hello.world((){})}', '[SharkExpression(hello.world((){}))]');
  });
  group('@!code', () {
    test('no params', () {
      successParse('@!code { var a=1; }', '[SharkTag(code, <null>, {[ var a=1; ]})]');
      successParse('@!code {{ @var @@ }}', '[SharkTag(code, <null>, {[ @var @@ ]})]');
    });
    test('has empty param', () {
      successParse('@!code () {{ @var @@ }}', '[SharkTag(code, (), {[ @var @@ ]})]');
    });
    test('has non-empty param', () {
      successParse('@!code (abc) {{ @var @@ }}', '[SharkTag(code, (abc), {[ @var @@ ]})]');
      successParse('@!code (bool abc) {{ @var @@ }}', '[SharkTag(code, (bool abc), {[ @var @@ ]})]');
      successParse('@!code (bool abc : xyz) {{ @var @@ }}', '[SharkTag(code, (bool abc: xyz), {[ @var @@ ]})]');
      successParse('@!code (bool abc : xyz, ddd) {{ @var @@ }}', '[SharkTag(code, (bool abc: xyz, ddd), {[ @var @@ ]})]');
      successParse('@!code (bool abc : xyz, List<U> ddd: eee) {{ @var @@ }}', '[SharkTag(code, (bool abc: xyz, List<U> ddd: eee), {[ @var @@ ]})]');
    });
    test('param description', () {
      successParse('@!code (age: 123.4) {{ @var @@ }}', '[SharkTag(code, (age: 123.4), {[ @var @@ ]})]');
      successParse('@!code (List<User> users: default_users) {{ @var @@ }}', '[SharkTag(code, (List<User> users: default_users), {[ @var @@ ]})]');
      successParse(r'@!code (users: "a\"b\"c") {{ @var @@ }}', r'[SharkTag(code, (users: "a\"b\"c"), {[ @var @@ ]})]');
      successParse(r"@!code (users: 'a\'b\'c') {{ @var @@ }}", r"[SharkTag(code, (users: 'a\'b\'c'), {[ @var @@ ]})]");
      successParse(r"@!code (users: {@@}) {{ @var @@ }}", r"[SharkTag(code, (users: [@]), {[ @var @@ ]})]");
    });
    test('no block', () {
      successParse('@!code (user)', '[SharkTag(code, (user), <null>)]');
    });
    test('code param', () {
      successParse('@!if(a==b) {}', '[SharkTag(if, (a==b), {[]})]');
    });
  });
  group('@tag', () {
    test('no params', () {
      successParse('@mytag { var a=1; }', '[SharkTag(mytag, <null>, {[ var a=1; ]})]');
      successParse('@mytag {{ @var @@ }}', '[SharkTag(mytag, <null>, {[ , SharkExpression(var),  @ ]})]');
    });
    test('has params', () {
      successParse('@mytag () {{ @var @@ }}', '[SharkTag(mytag, (), {[ , SharkExpression(var),  @ ]})]');
      successParse('@mytag (abc) {{ @var @@ }}', '[SharkTag(mytag, (abc), {[ , SharkExpression(var),  @ ]})]');
      successParse('@mytag (bool abc) {{ @var @@ }}', '[SharkTag(mytag, (bool abc), {[ , SharkExpression(var),  @ ]})]');
      successParse('@mytag (bool abc : xyz) {{ @var @@ }}', '[SharkTag(mytag, (bool abc: xyz), {[ , SharkExpression(var),  @ ]})]');
      successParse('@mytag (bool abc : xyz, ddd) {{ @var @@ }}', '[SharkTag(mytag, (bool abc: xyz, ddd), {[ , SharkExpression(var),  @ ]})]');
      successParse('@mytag (bool abc : xyz, List<U> ddd: eee) {{ @var @@ }}', '[SharkTag(mytag, (bool abc: xyz, List<U> ddd: eee), {[ , SharkExpression(var),  @ ]})]');
    });
    test('param description', () {
      successParse('@mytag (age: 123.4) {{ @var @@ }}', '[SharkTag(mytag, (age: 123.4), {[ , SharkExpression(var),  @ ]})]');
      successParse('@mytag (List<User> users: default_users) {{ @var @@ }}', '[SharkTag(mytag, (List<User> users: default_users), {[ , SharkExpression(var),  @ ]})]');
      successParse(r'@mytag (users: "a\"b\"c") {{ @var @@ }}', r'[SharkTag(mytag, (users: "a\"b\"c"), {[ , SharkExpression(var),  @ ]})]');
      successParse(r"@mytag (users: 'a\'b\'c') {{ @var @@ }}", r"[SharkTag(mytag, (users: 'a\'b\'c'), {[ , SharkExpression(var),  @ ]})]");
      successParse(r"@mytag (users: {@@}) {{ @var @@ }}", r"[SharkTag(mytag, (users: [@]), {[ , SharkExpression(var),  @ ]})]");
    });
    test('path-like param variable', () {
      successParse('@mytag(./layout1,   user:user) {}', '[SharkTag(mytag, (./layout1, user: user), {[]})]');
    });
    test('no block', () {
      successParse('@mytag (user)', '[SharkTag(mytag, (user), <null>)]');
    });
    test('code param', () {
      successParse('@if(a==b) {}', '[SharkTag(if, (a==b), {[]})]');
    });
  });
  group('document', () {
    test('all', () {
      successParse('aaa @bbb(ccc){@@} @ddd @@ eee @!fff{@@} ggg',
      '[aaa , SharkTag(bbb, (ccc), {[@]}),  , SharkExpression(ddd),  @ eee , SharkTag(fff, <null>, {[@@]}),  ggg]');
    });
    test('nested', () {
      successParse('@aaa { @bbb { @user } ccc @!ddd { @@ } } eee',
      '[SharkTag(aaa, <null>, {[ , SharkTag(bbb, <null>, {[ , SharkExpression(user),  ]}),  ccc , SharkTag(ddd, <null>, {[ @@ ]}),  ]}),  eee]');
    });
    test('sibling tags', () {
      successParse('@aaa() @bbb() eee @ddd()',
      '[SharkTag(aaa, (), <null>), SharkTag(bbb, (), <null>), eee , SharkTag(ddd, (), <null>)]');
    });
  });
}
