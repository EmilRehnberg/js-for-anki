define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
  "(doc vec)",
      ],
      o: [
  "-------------------------",
  "clojure.core/vec",
  "([coll])",
  "  Creates a new vector containing the contents of coll. Java arrays",
  "  will be aliased and should not be modified.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
