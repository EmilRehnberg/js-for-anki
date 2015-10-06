require(["_dom-writers"], function(writers){
  var letter = {
    from: "hirokawa@meaty.com",
    to: "emil.rehnberg@gmail.com",
    time: "2015年10月5日 8:03",
    topic: "【ミティー】電話面談ご連絡",
    origin: "meaty.com",
    contents: [
      "Emil様",
      "",
      "ミティー採用事務局廣川です。",
      "ご連絡ありがとうございます。",
      "",
      "今回のポジションは、日本語会話能力が必要です。",
      "私の時間というよりは、業務上、日本のお客様向けの",
      "日本語による説明や提案が発生します。",
      "Emil様がヒアリングが難しいということであれば",
      "今回の面談はキャンセルとさせていただきます。",
      "",
      "私どもの体制上、ご期待に添えず申し訳ございません。",
      "",
      "Emil様の今後のご活躍を祈念しております。",
      "失礼いたします。",
      ],
  };

  writers.writeLetter(letter);
});
