define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc reduce)",
      ],
      o: [
  "-------------------------",
  "clojure.core/reduce",
  "([f coll] [f val coll])",
  "- f should be a function of 2 arguments.",
  "- If val is not supplied, returns the result of applying f to the first 2 items in coll, then applying f to that result and the 3rd item, etc.",
  "- If coll contains no items, f must accept no arguments as well, and reduce returns the result of calling f with no arguments.",
  "- If coll has only 1 item, it is returned and f is not called.",
  "- If val is supplied, returns the result of applying f to val and the first item in coll, then applying f to that result and the 2nd item, etc.",
  "- If coll contains no items, returns val and f is not called.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
