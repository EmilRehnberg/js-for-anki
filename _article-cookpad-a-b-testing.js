require(["_dom-writers"], function(writers){
  var letter = {
    from: "@a_bicky",
    time: "2015年05月08日",
    origin: "<a href='http://techlife.cookpad.com/entry/2015/05/08/114239'>cookpad blog</a>",
    contents: [
'<h4>A/B テストで施策の効果を検証！エンジニアのための R 入門</h4>',
'こんにちは、買物情報事業部でサーバサイドの開発を担当している荒引 (@a_bicky) です。',
'',
'今回のエントリでは R で A/B テストの結果検証を行う方法の一例について紹介します。 エンジニアでも自分の関わった施策の効果検証のために簡単な分析をすることがあるかと思いますが、そんな時にこのエントリが役立てば幸いです。',
'',
'なお、次のような方は対象外です。',
'<ul><li>A/B テストや KPI の設計に興味のある方<ul><li>この辺には全く触れません</li></ul></li><li>プログラミング初心者<ul><li>わからない単語が大量に出てくるでしょう</li></ul></li><li>R で統計学や機械学習の手法をバリバリ使いたい方<ul><li>世の中の "分析" の多くは集計処理がメインです</li></ul></li><li>Python, Julia など既に分析する上で使い慣れた言語・ツールがある方<ul><li>今回のエントリ程度の内容であればわざわざ乗り換える必要もないでしょう</li></ul></li></ul>',
'OS は Mac を前提として説明するので、Windows や Linux では一部動かないものもあるかもしれませんがご了承ください。 また、R のバージョンは現時点で最新バージョンの 3.2.0 であることを前提とします。',
'',
'<h4>何故 R か？</h4>',
'それは私の一番使える言語だからです！というのが一番の理由ですが、他にも次のような理由が挙げられます。',
'',
'<ul><li>無料で使える',
'<li>R 関連の書籍なども大量に存在していて情報が豊富',
'<li>RStudio や ESS のような素晴らしい IDE が存在する',
'<li>パッケージ（Ruby でいう gem）が豊富',
'<li>ggplot2 パッケージを使うことで複雑なグラフが手軽に描ける',
'<li>data.table, dplyr, stringi パッケージなどのおかげで数百万オーダーのデータでもストレスなく高速に処理できるようになった</ul>',
'ちなみに、R のコーディングスタイルのカオスっぷりに辟易する方もいるでしょうが、そこは耐えるしかないです。',
'',
'<h4>アジェンダ</h4>',
'<ul><li>R の環境構築<ul><li>最低限の設定<li>IDE の導入</ul><li>R の使い方についてさらっと<ul><li>コンソールの使い方<li>デバッグ方法<li>data.frame について</ul><li>A/B テストの結果検証<ul><li>コンバージョン率 (CVR) を出す<li>CVR の差の検定をする<li>ユーザの定着率（定着数）を出す</ul><li>番外編<ul><li>R でコホート分析</ul><li>最後に</ul>',
'<h4>R の環境構築</h4>',
'Mac の場合は Homebrew 経由でインストールするのが手軽です。Linux の場合もパッケージマネージャ経由で手軽にインストールできます。',
'<pre>% brew tap homebrew/science',
'% brew install r</pre>これでターミナルから R を起動できるようになったはずです。',
'<pre>% R',
'></pre>R を使う際には基本的にこのコンソール上で作業することになります。コマンドラインからスクリプトを実行するのはバッチなどを運用するケースぐらいです。',
'',
'R を終了するには q 関数を実行するか Ctrl-D を入力します。',
'<pre>> q()',
'Save workspace image? [y/n/c]: n</pre>"Save workspace image?" で y を入力すると現在のセッションの内容がワーキングディレクトリに .RData という名前で保存され、次回起動時に定義したオブジェクトなどが復元されます。',
      ],
  };

  writers.writeLetter(letter);
});


