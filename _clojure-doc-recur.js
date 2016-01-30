define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc recur)",
      ],
      o: [
  "-------------------------",
  "clojure.core/recur",
  "  (recur exprs*)",
  "Special Form",
  "- Evaluates the exprs in order, then, in parallel, rebinds the bindings of the recursion point to the values of the exprs.",
  "- Execution then jumps back to the recursion point, a loop or fn method.",
  "",
  "  Please see http://clojure.org/special_forms#recur",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
