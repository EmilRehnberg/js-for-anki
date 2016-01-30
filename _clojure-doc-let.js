define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc let)",
      ],
      o: [
  "-------------------------",
  "clojure.core/let",
  "  (let [bindings*] exprs*)",
  "Special Form",
  "  binding => binding-form init-expr",
  "",
  "- Evaluates the exprs in a lexical context in which the symbols in the binding-forms are bound to their respective init-exprs or parts therein.",
  "",
  "  Please see http://clojure.org/special_forms#let",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
