define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "airquality",
      ],
      o: [
        "   Ozone Solar.R Wind Temp Month Day",
        "1     41     190  7.4   67     5   1",
        "2     36     118  8.0   72     5   2",
        "3     12     149 12.6   74     5   3",
        "4     18     313 11.5   62     5   4",
        "5     NA      NA 14.3   56     5   5",
        "...",
      ]
    },
  ];

  return codes.buildCodeTagsSet(io);
});
