define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc cond)",
      ],
      o: [
  "-------------------------",
  "clojure.core/cond",
  "([& clauses])",
  "Macro",
  "- Takes a set of test/expr pairs.",
  "- It evaluates each test one at a time.",
  "- If a test returns logical true, cond evaluates and returns the value of the corresponding expr and doesn't evaluate any of the other tests or exprs.",
  "- (cond) returns nil.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
