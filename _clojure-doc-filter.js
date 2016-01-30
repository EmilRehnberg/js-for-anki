define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc filter)",
      ],
      o: [
  "-------------------------",
  "clojure.core/filter",
  "([pred] [pred coll])",
  "- Returns a lazy sequence of the items in coll for which (pred item) returns true.",
  "- pred must be free of side-effects.",
  "- Returns a transducer when no collection is provided.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
