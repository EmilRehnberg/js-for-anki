define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc loop)",
      ],
      o: [
  "-------------------------",
  "clojure.core/loop",
  "  (loop [bindings*] exprs*)",
  "Special Form",
  "- Evaluates the exprs in a lexical context in which the symbols in the binding-forms are bound to their respective init-exprs or parts therein. ",
  "- Acts as a recur target.",
  "",
  "  Please see http://clojure.org/special_forms#loop",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
