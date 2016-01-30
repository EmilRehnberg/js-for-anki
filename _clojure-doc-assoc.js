define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc assoc)",
      ],
      o: [
  "-------------------------",
  "clojure.core/assoc",
  "([map key val] [map key val & kvs])",
  "  assoc[iate]. ",
  "  When applied to a map, returns a new map of the same (hashed/sorted) type, that contains the mapping of key(s) to val(s). ",
  "  When applied to a vector, returns a new vector that contains val at index. ",
  "  Note - index must be <= (count vector).",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
