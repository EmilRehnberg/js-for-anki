define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc def)",
      ],
      o: [
  "-------------------------",
  "def",
  "  (def symbol doc-string? init?)",
  "Special Form",
  "- Creates and interns a global var with the name of symbol in the current namespace (*ns*) or locates such a var if it already exists.",
  "- If init is supplied, it is evaluated, and the root binding of the var is set to the resulting value.
  "- If init is not supplied, the root binding of the var is unaffected.",
  "",
  "  Please see http://clojure.org/special_forms#def",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
