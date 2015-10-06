require(["_dom-writers"], function(writers){
  var letter = {
    from: "hirokawa@meaty.com",
    to: "emil.rehnberg@gmail.com",
    time: "2015年10月5日 8:03",
    topic: "【ミティー】電話面談ご連絡",
    origin: "meaty.com",
    contents: [
      "Emil　さん",
      "",
      "ミティー採用事務局です。",
      "先日ご応募を頂いてからご連絡が空いてしまい",
      "失礼をいたしました。",
      "",
      "1. 日本の採用ポジションのご案内",
      "2. 選考に関する希望ヒアリング",
      "上記を目的とした日本語による電話インタビューです。",
      "15分程度を予定しています。",
      "",
      "下記よりご都合の良い時間をお知らせください。",
      "",
      "10月7日17時まで　19時以降",
      "10月8日14時以降",
      "※すべて日本時間",
      "",
      "また日本にいらっしゃらない場合は、国番号含めて電話番号を教えてください。",
      "",
      "お願いいたします。",
      ],
  };

  writers.writeLetter(letter);
});
