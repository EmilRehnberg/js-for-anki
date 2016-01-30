define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc case)",
      ],
      o: [
  "-------------------------",
  "clojure.core/case",
  "([e & clauses])",
  "Macro",
  "  Takes an expression, and a set of clauses.",
  "",
  "  Each clause can take the form of either:",
  "",
  "  test-constant result-expr",
  "  (test-constant1 ... test-constantN)  result-expr",
  "",
  "- The test-constants are not evaluated.",
  "- They must be compile-time literals, and need not be quoted.",
  "- If the expression is equal to a test-constant, the corresponding result-expr is returned.",
  "- A single default expression can follow the clauses, and its value will be returned if no clause matches.",
  "- If no default expression is provided and no clause matches, an IllegalArgumentException is thrown.",
  "",
  "- Unlike cond and condp, case does a constant-time dispatch, the clauses are not considered sequentially.",
  "- All manner of constant expressions are acceptable in case, including numbers, strings, symbols, keywords, and (Clojure) composites thereof.",
  "- Note that since lists are used to group multiple constants that map to the same expression, a vector can be used to match a list if needed.",
  "- The test-constants need not be all of the same type.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
