library shark_render_tests;

import "dart:io";
import "dart:async";
import "package:unittest/unittest.dart";
import "package:petitparser/petitparser.dart";
import "package:path/path.dart" as path;
import "../lib/shark.dart";

import 'compiled/tags/dart1.dart' as tags$dart1;
import 'compiled/tags/for1.dart' as tags$for1;
import 'compiled/tags/if1.dart' as tags$if1;
import 'compiled/tags/if_else1.dart' as tags$if_else1;
import 'compiled/tags/if_elseif_else1.dart' as tags$if_elseif_else1;
import 'compiled/tags/params1.dart' as tags$params1;
import 'compiled/tags/params2.dart' as tags$params2;
import 'compiled/tags/layout1.dart' as tags$layout1;
import 'compiled/tags/extends1.dart' as tags$extends1;
import 'compiled/tags/extends2.dart' as tags$extends2;

import 'compiled/users/index.dart' as users$index;
import 'compiled/users/show.dart' as users$show;

main() {
  group('tags', () {
    test('@!dart', () {
      var result = tags$dart1.render();
      expectRendered(result, 'rendered/tags/dart1.txt');
    });
    test('@for', () {
      var users = ['AAA', 'BBB', 'CCC'];
      var result = tags$for1.render(users: users);
      expectRendered(result, 'rendered/tags/for1.txt');
    });
    test('@if', () {
      var result = tags$if1.render(num:1);
      expectRendered(result, 'rendered/tags/if1.txt');
    });
    test('@else', () {
      var result = tags$if_else1.render(num:2);
      expectRendered(result, 'rendered/tags/if_else1.txt');
    });
    test('@elseif', () {
      var result = tags$if_elseif_else1.render(num:2);
      expectRendered(result, 'rendered/tags/if_elseif_else1.txt');
    });
    test('@params1', () {
      var result = tags$params1.render(user:'Shark');
      expectRendered(result, 'rendered/tags/params1.txt');
    });
    test('@params2', () {
      var result = tags$params2.render(user:'Shark');
      expectRendered(result, 'rendered/tags/params2.txt');
    });
    test('@layout1', () {
      var result = tags$params2.render(user:'Shark');
      expectRendered(result, 'rendered/tags/params2.txt');
    });
    test('@extends1', () {
      var result = tags$extends1.render(user:'Shark');
      expectRendered(result, 'rendered/tags/extends1.txt');
    });
    test('@extends2', () {
      var result = tags$extends2.render(user:'Shark');
      expectRendered(result, 'rendered/tags/extends2.txt');
    });
  });
  group('sites', () {
    test('user.index', () {
      var result = users$index.render();
      expectRendered(result, 'rendered/users/index.txt');
    });
    test('user.show', () {
      var result = users$show.render();
      expectRendered(result, 'rendered/users/show.txt');
    });
  });
}

expectRendered(String result, String expectedFile) {
  var expected = new File(expectedFile).readAsStringSync();
  expectSameContent(result, expected, reason: expectedFile);
}

expectSameContent(String actual, String expected, {String reason}) {
  var lines1 = actual.trim().split('\n').map((line) => line.trim());
  var lines2 = expected.trim().split('\n').map((line) => line.trim());
  expect(lines1, orderedEquals(lines2), reason: reason);
}
