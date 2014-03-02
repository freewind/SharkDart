SharkDart
=========

A small template engine built for dart.

Simple rules:
------------

The main symbol used in the SharkDart is `@`. There are several simple rules:

1. `@` escape: `@@` -> `@`
2. expression
    1. simple: `@name`, or `@{name}`
    2. complex: `@{name.toLowerCase()}`
3. tag
    1. param list: `@author(String name: 'Freewind', love: 'programming') { Thanks for PetitParserDart! }`
    2. expression: `@if(a==b) { <div>Hello</div> }`
    3. no-params: `@markdown { **hello** }`
    4. no-body: `@include(a.txt)`
4. plain-text tag

   Use `@!` instead of `@`, the content of block will be transformed, e.g.

        @!dart {{{{{{
           // here are some dart code
           String hello() {
               print('Hello, world!');
           }
        }}}}}}

   You can repeat `{` and `}`, to make unique start and end of the block.
   PS: The same to normal tags `@tag {{{ .. }}}`

Compiled to dart code
---------------------

SharkDart is flexible, we can use dart code in template, by:

    @!dart {
        // you dart code
    }

But since dart doesn't support `eval` code dynamically,
shark template have to be compiled to dart code,
and invoked as functions in our program.

Say there is a `hello.shark`, which will be compiled to `hello.dart`,
and we will invoke it like:

    // import generated hello.dart from somewhere
    import 'hello.dart' as hello;
    var data = { 'name': 'world' };
    String result = hello.render(data);

Built-in tags
-------------

TODO

Thanks
------

Thanks for the great parser [PetitParserDart](https://github.com/renggli/PetitParserDart),
and the author @renggli
