define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "SELECT depname, empno, salary, avg(salary)",
        "  OVER (PARTITION BY depname)",
        "  FROM empsalary;",
        ");",
      ],
      o: [
        "  depname  | empno | salary |  avg   ",
        "-----------+-------+--------+--------",
        " develop   |    11 |   5200 | 5020.00",
        " develop   |     7 |   4200 | 5020.00",
        " develop   |     9 |   4500 | 5020.00",
        " develop   |     8 |   6000 | 5020.00",
        " develop   |    10 |   5200 | 5020.00",
        " personnel |     5 |   3500 | 3700.00",
        " personnel |     2 |   3900 | 3700.00",
        " sales     |     3 |   4800 | 4866.67",
        " sales     |     1 |   5000 | 4866.67",
        " sales     |     4 |   4800 | 4866.67",
        "(10 rows)",
      ]
    },
  ];

  return codes.buildCodeTagsSet(io);
});
