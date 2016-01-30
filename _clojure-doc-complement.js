define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc complement)",
      ],
      o: [
  "-------------------------",
  "clojure.core/complement",
  "([f])",
  "- Takes a fn f and returns a fn that takes the same arguments as f, has the same effects, if any, and returns the opposite truth value.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
