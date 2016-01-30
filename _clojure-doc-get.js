define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc get)",
      ],
      o: [
  "-------------------------",
  "clojure.core/get",
  "([map key] [map key not-found])",
  "  Returns the value mapped to key, not-found or nil if key not present.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
