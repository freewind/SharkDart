library shark;

import "dart:io";
import "dart:collection";
import "dart:async";
import "package:path/path.dart" as path;
import "package:petitparser/petitparser.dart";

part "src/parser.dart";
part "src/ast.dart";
part "src/helper.dart";
part "src/tags.dart";
part "src/compiler.dart";

var tagRepository = new TagRepository();

var _builtInTags = initializeBuiltInTags();

SharkDocument parse(String input) => new SharkParser().parse(input).value;

String compile(String input) => new Compiler().compileTemplateString(input);

Future<String> compileTemplateFile(Directory root, String relativeFilePath) => new Compiler().compileTemplateFile(root, relativeFilePath);

CompilableElement libraryStmt(String input) => new CompilableElement(CompilableElementType.LIBRARY, input);

CompilableElement importStmt(String input) => new CompilableElement(CompilableElementType.IMPORT, input);

CompilableElement importStmtFromTemplate(FromTemplate func) => new CompilableElement.fromTemplate(CompilableElementType.IMPORT, func);

CompilableElement functionParams(String input) => new CompilableElement(CompilableElementType.FUNCTION_PARAM, input);

CompilableElement stmt(String input) => new CompilableElement(CompilableElementType.FUNCTION_BODY_STATEMENT, input);

CompilableElement expr(String input) => new CompilableElement(CompilableElementType.FUNCTION_BODY_EXPRESSION, input);

CompilableElement text(String input) => new CompilableElement(CompilableElementType.FUNCTION_BODY_TEXT, input);

CompilableElement returnStmt(String input) => new CompilableElement(CompilableElementType.FUNCTION_RETURN, input);

initializeBuiltInTags() {
  tagRepository.register('params', new ParamsTagHandler());
  tagRepository.register('if', new IfTagHandler());
  tagRepository.register('else', new ElseTagHandler());
  tagRepository.register('elseif', new ElseIfTagHandler());
  tagRepository.register('for', new ForTagHandler());
  tagRepository.register('extends', new ExtendsTagHandler());
  tagRepository.register('renderBody', new RenderBodyTagHandler());
}
