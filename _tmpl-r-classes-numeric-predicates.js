require(["_code-builders"], function(codes){
  var ioSets=[
    {
      i: ["nums <- c(1, 2.5)",
          "class(nums) <span class='comment'># object class</span>"],
      o: ['[1] "numeric"'],
    },
    {
      i: ['typeof(nums) <span class="comment"># (R internal) type or storage mode of any object</span>'],
      o: ['[1] "double"'],
    },
    {
      i: ['is.double(nums)'],
      o: ['[1] TRUE'],
    },
    {
      i: ['is.integer(nums)'],
      o: ['[1] FALSE'],
    },
    {
      i: ['is.atomic(nums)'],
      o: ['[1] TRUE'],
    },
    {
      i: ['is.numeric(nums)'],
      o: ['[1] TRUE'],
    },
  ];
  codes.writeAdjacentCode(ioSets);
});
