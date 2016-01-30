define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc interpose)",
      ],
      o: [
  "-------------------------",
  "clojure.core/interpose",
  "([sep] [sep coll])",
  "- Returns a lazy seq of the elements of coll separated by sep.",
  "- Returns a stateful transducer when no collection is provided.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
