define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc partial)",
      ],
      o: [
  "-------------------------",
  "clojure.core/partial",
  "([f] [f arg1] [f arg1 arg2] [f arg1 arg2 arg3] [f arg1 arg2 arg3 & more])",
  "- Takes a function f and fewer than the normal arguments to f, and returns a fn that takes a variable number of additional args.",
  "- When called, the returned function calls f with args + additional args.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
