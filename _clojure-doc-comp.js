define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc comp)",
      ],
      o: [
  "-------------------------",
  "clojure.core/comp",
  "([] [f] [f g] [f g & fs])",
  "- Takes a set of functions and returns a fn that is the composition of those fns.",
  "- The returned fn takes a variable number of args, applies the rightmost of fns to the args, the next fn (right-to-left) to the result, etc.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
