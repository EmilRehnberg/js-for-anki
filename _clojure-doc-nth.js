define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc nth)",
      ],
      o: [
  "-------------------------",
  "clojure.core/nth",
  "([coll index] [coll index not-found])",
  "  Returns the value at the index.",
  "  get returns nil if index out of bounds, nth throws an exception unless not-found is supplied.",
  "  nth also works for strings, Java arrays, regex Matchers and Lists, and in O(n) time, for sequences.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
