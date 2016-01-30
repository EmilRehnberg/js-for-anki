define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc apply)",
      ],
      o: [
  "-------------------------",
  "clojure.core/apply",
  "([f args] [f x args] [f x y args] [f x y z args] [f a b c d & args])",
  "- Applies fn f to the argument list formed by prepending intervening arguments to args.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
