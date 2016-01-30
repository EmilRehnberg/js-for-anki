define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc subs)",
      ],
      o: [
  "-------------------------",
  "clojure.core/subs",
  "([s start] [s start end])",
  "  Returns the substring of s beginning at start inclusive, and ending at end (defaults to length of string), exclusive.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
