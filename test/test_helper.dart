part of shark_tests;

test_helper() {
  test("CompressList", () {
    var compressList = new CompressList()
      ..add('a')
      ..add('b')
      ..add(1)
      ..add('c')
      ..add('d');
    expect(compressList.compress(), ['ab', 1, 'cd']);
  });
}
