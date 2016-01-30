define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc if)",
      ],
      o: [
  "-------------------------",
  "if",
  "  (if test then else?)",
  "Special Form",
  "- Evaluates test.",
  "- If not the singular values nil or false, evaluates and yields then, otherwise, evaluates and yields else.",
  "- If else is not supplied it defaults to nil.",
  "",
  "  Please see http://clojure.org/special_forms#if",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
