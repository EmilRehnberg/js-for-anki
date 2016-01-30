define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc concat)",
      ],
      o: [
  "-------------------------",
  "clojure.core/concat",
  "([] [x] [x y] [x y & zs])",
  "- Returns a lazy seq representing the concatenation of the elements in the supplied colls.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
