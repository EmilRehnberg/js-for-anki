define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc for)",
      ],
      o: [
  "-------------------------",
  "clojure.core/for",
  "([seq-exprs body-expr])",
  "Macro",
  "- List comprehension. ,
  "- Takes a vector of one or more binding-form/collection-expr pairs, each followed by zero or more modifiers, and yields a lazy sequence of evaluations of expr.",
  "- Collections are iterated in a nested fashion, rightmost fastest, and nested coll-exprs can refer to bindings created in prior binding-forms.",
  "- Supported modifiers are: :let [binding-form expr ...], :while test, :when test.",
  "",
  " (take 100 (for [x (range 100000000) y (range 1000000) :while (< y x)] [x y]))",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
