define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc defmulti)",
      ],
      o: [
  "-------------------------",
  "clojure.core/defmulti",
  "([name docstring? attr-map? dispatch-fn & options])
  "Macro",
  "- Creates a new multimethod with the associated dispatch function.",
  "- The docstring and attr-map are optional.",
  "",
  "- Options are key-value pairs and may be one of:",
  "",
  "  :default",
  "",
  "- The default dispatch value, defaults to :default",
  "",
  "  :hierarchy",
  "",
  "- The value used for hierarchical dispatch (e.g. ::square is-a ::shape)",
  "",
  "- Hierarchies are type-like relationships that do not depend upon type inheritance.",
  "- By default Clojure's multimethods dispatch off of a global hierarchy map.",
  "- However, a hierarchy relationship can be created with the derive function used to augment the root ancestor created with make-hierarchy.",
  "",
  "- Multimethods expect the value of the hierarchy option to be supplied as a reference type e.g. a var (i.e. via the Var-quote dispatch macro #' or the var special form).",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
