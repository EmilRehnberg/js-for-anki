define(["_code-builders"], function(codes){
  var io = [
    { c: [],
      i: [ "(doc conj)", ],
      o: [
  "-------------------------",
  "clojure.core/conj",
  "([coll x] [coll x & xs])",
  "- conj[oin].",
  "- Returns a new collection with the xs 'added'.",
  "- (conj nil item) returns (item).",
  "- The 'addition' may happen at different 'places' depending on the concrete type.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
