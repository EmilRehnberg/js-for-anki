require(["_tables"], function(tables){
  var data = {
    header: ["元号開始"],
    caption:"現代の天皇",
    tableData: {
      孝明: ["<time>1846</time>"],
      明治: ["<time>1867</time>"],
      大正: ["<time>1912</time>"],
      昭和: ["<time>1926</time>"],
      平成: ["<time>1989</time>"],
  }
};

tables.writeAdjacentTable(data);
});
