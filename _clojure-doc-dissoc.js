define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc dissoc)",
      ],
      o: [
  "-------------------------",
  "clojure.core/dissoc",
  "([map] [map key] [map key & ks])",
  "  dissoc[iate].",
  "  Returns a new map of the same (hashed/sorted) type, that does not contain a mapping for key(s).",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
