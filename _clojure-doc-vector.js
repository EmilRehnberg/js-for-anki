define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc vector)",
      ],
      o: [
  "-------------------------",
  "clojure.core/vector",
  "([] [a] [a b] [a b c] [a b c d] [a b c d & args])",
  "  Creates a new vector containing the args.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
