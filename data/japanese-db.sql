--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.0
-- Started on 2016-02-24 09:33:05 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2300 (class 1262 OID 16441)
-- Dependencies: 2299
-- Name: 日本語; Type: COMMENT; Schema: -; Owner: e
--

COMMENT ON DATABASE "日本語" IS 'DB for japanese language data.';


--
-- TOC entry 176 (class 3079 OID 12123)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2303 (class 0 OID 0)
-- Dependencies: 176
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 534 (class 1247 OID 16509)
-- Name: name_class; Type: TYPE; Schema: public; Owner: e
--

CREATE TYPE name_class AS ENUM (
    'person',
    'location',
    'entity',
    'character'
);


ALTER TYPE name_class OWNER TO e;

--
-- TOC entry 537 (class 1247 OID 16596)
-- Name: name_tag; Type: TYPE; Schema: public; Owner: e
--

CREATE TYPE name_tag AS ENUM (
    '悪党・重犯罪捜査班',
    '仏',
    '神々',
    'メタルギアソリッド',
    '対戦型格闘ゲーム『ストリートファイター』',
    '御茶',
    '映画',
    '事件',
    '食べ物',
    '時代区分の一つ',
    '柔道技',
    '雑多物',
    '日本の町',
    '日本の城',
    '中国地理',
    '世界の国',
    '雑多地域名',
    '日本の都道府県の一つ',
    '日本の令制国の一つ',
    '八地方区分',
    '御神社',
    '御寺',
    '東京都地域名',
    '東京都区部',
    '俳優',
    '武道家',
    'クライマー',
    'ゲーム作家',
    '格闘技',
    '源氏の人',
    '雑多人名',
    '国内研究がんセンター',
    '任天堂会社員',
    '政治家',
    '歴史の人',
    'サスケ',
    '日本天皇',
    '作家'
);


ALTER TYPE name_tag OWNER TO e;

--
-- TOC entry 531 (class 1247 OID 16495)
-- Name: word_tag; Type: TYPE; Schema: public; Owner: e
--

CREATE TYPE word_tag AS ENUM (
    '動物',
    '植物',
    '書体',
    '菌類',
    '形動',
    '名',
    'スル',
    '副',
    '格助',
    '接助',
    '助動'
);


ALTER TYPE word_tag OWNER TO e;

--
-- TOC entry 189 (class 1255 OID 16486)
-- Name: impute_missing_pronouncation(); Type: FUNCTION; Schema: public; Owner: e
--

CREATE FUNCTION impute_missing_pronouncation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.発音 = '' THEN
    NEW.発音 := NEW.単語;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.impute_missing_pronouncation() OWNER TO e;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 175 (class 1259 OID 16944)
-- Name: tmp_table; Type: TABLE; Schema: public; Owner: e; Tablespace: 
--

CREATE TABLE tmp_table (
    defs text[],
    tags word_tag[]
);


ALTER TABLE tmp_table OWNER TO e;

--
-- TOC entry 190 (class 1255 OID 16950)
-- Name: mix_definitions_and_tags(tmp_table); Type: FUNCTION; Schema: public; Owner: e
--

CREATE FUNCTION mix_definitions_and_tags(tmp_table) RETURNS SETOF text
    LANGUAGE sql
    AS $_$
  SELECT CASE WHEN $1.defs <> '{}' THEN
    COALESCE('［'||array_to_string($1.tags,'・')||'］', '') || UNNEST($1.defs)
  ELSE
    ''
  END
$_$;


ALTER FUNCTION public.mix_definitions_and_tags(tmp_table) OWNER TO e;

--
-- TOC entry 555 (class 1255 OID 16493)
-- Name: array_cat_agg(anyarray); Type: AGGREGATE; Schema: public; Owner: e
--

CREATE AGGREGATE array_cat_agg(anyarray) (
    SFUNC = array_cat,
    STYPE = anyarray
);


ALTER AGGREGATE public.array_cat_agg(anyarray) OWNER TO e;

--
-- TOC entry 172 (class 1259 OID 16478)
-- Name: goi; Type: TABLE; Schema: public; Owner: e; Tablespace: 
--

CREATE TABLE goi (
    "単語" character varying(20) NOT NULL,
    "発音" character varying(30) NOT NULL,
    "和" text[] DEFAULT ARRAY[]::text[],
    "英" text[] DEFAULT ARRAY[]::text[],
    tags word_tag[],
    alternate_writing character varying(30)[],
    alternate_reading character varying(30)[]
);


ALTER TABLE goi OWNER TO e;

--
-- TOC entry 2304 (class 0 OID 0)
-- Dependencies: 172
-- Name: TABLE goi; Type: COMMENT; Schema: public; Owner: e
--

COMMENT ON TABLE goi IS 'Table for Japanese words.
Includes word, pronounciation, and definitions in Japanese and English.
Uses array types for the definition columns.';


--
-- TOC entry 2305 (class 0 OID 0)
-- Dependencies: 172
-- Name: COLUMN goi."和"; Type: COMMENT; Schema: public; Owner: e
--

COMMENT ON COLUMN goi."和" IS '日本語定義達。';


--
-- TOC entry 2306 (class 0 OID 0)
-- Dependencies: 172
-- Name: COLUMN goi."英"; Type: COMMENT; Schema: public; Owner: e
--

COMMENT ON COLUMN goi."英" IS '英語定義達。';


--
-- TOC entry 174 (class 1259 OID 16722)
-- Name: names; Type: TABLE; Schema: public; Owner: e; Tablespace: 
--

CREATE TABLE names (
    name character varying(20) NOT NULL,
    reading text NOT NULL,
    description text,
    origin character varying(30) NOT NULL
);


ALTER TABLE names OWNER TO e;

--
-- TOC entry 173 (class 1259 OID 16688)
-- Name: names_metadata; Type: TABLE; Schema: public; Owner: e; Tablespace: 
--

CREATE TABLE names_metadata (
    table_name character varying(30) NOT NULL,
    tag character varying(20) NOT NULL,
    class character varying(20) NOT NULL
);


ALTER TABLE names_metadata OWNER TO e;

--
-- TOC entry 2291 (class 0 OID 16478)
-- Dependencies: 172
-- Data for Name: goi; Type: TABLE DATA; Schema: public; Owner: e
--

COPY goi ("単語", "発音", "和", "英", tags, alternate_writing, alternate_reading) FROM stdin;
類語	るいご	{語形は異なっているが、意味の似かよっている二つ以上の語。「家」と「住宅」、「言う」と「話す」などの類。}	{synonym}	\N	\N	\N
類似	るいじ	{}	{analogous}	\N	\N	\N
類推	るいすい	{}	{analogy}	\N	\N	\N
累積	るいせき	{}	{accumulation}	\N	\N	\N
嗚呼	ああ	{}	{"Ah!; Oh!; Alas!"}	\N	\N	\N
相	あい	{}	{"together; mutually; fellow"}	\N	\N	\N
愛	あい	{}	{love}	\N	\N	\N
相変わらず	あいかわらず	{}	{"as ever; as usual; the same"}	\N	\N	\N
愛嬌	あいきょう	{}	{"charm; attrictiveness"}	\N	\N	\N
頁	ぺーじ	{"本や新聞など印刷物の構成要素。 ページを参照。"}	{page}	\N	\N	\N
ぺろぺろ	ぺろぺろ	{舌で物をなめまわすさま。}	{"the sound of licking"}	\N	\N	\N
留守番	るすばん	{}	{care-taking;caretaker;house-watching}	\N	\N	\N
留守	るす	{}	{"being away; be out (of one´s home or office)"}	\N	\N	\N
愛情	あいじょう	{}	{"love; affection"}	\N	\N	\N
合図	あいず	{}	{"sign; signal"}	\N	\N	\N
愛する	あいする	{}	{"to love"}	\N	\N	\N
愛想	あいそ	{}	{"civility; courtesy; compliments; sociability; graces"}	\N	\N	\N
相対	あいたい	{}	{"confrontation; facing; between ourselves; no third party; tete-a-tete"}	\N	\N	\N
間柄	あいだがら	{}	{relation(ship)}	\N	\N	\N
相手	あいて	{}	{"companion; partner; company; other party; addressee"}	\N	\N	\N
愛憎	あいにく	{}	{"likes and dislikes"}	\N	\N	\N
合間	あいま	{}	{interval}	\N	\N	\N
合う	あう	{}	{"fit; suit; be correct"}	\N	\N	\N
会う	あう	{}	{"to meet; to interview"}	\N	\N	\N
遭う	あう	{}	{"meet; encounter (often something unpleasant)"}	\N	\N	\N
敢えて	あえて	{}	{"dare (to do); challenge (to do)"}	\N	\N	\N
青	あお	{}	{"the color blue; the color green (noun); green light"}	\N	\N	\N
青い	あおい	{}	{"blue; pale; green; unripe; inexperienced"}	\N	\N	\N
扇ぐ	あおぐ	{}	{"to fan; to flap"}	\N	\N	\N
仰ぐ	あおぐ	{}	{"to look up (to); to respect; to depend on; to ask for; to seek; to revere; to drink; to take"}	\N	\N	\N
青白い	あおじろい	{}	{pale}	\N	\N	\N
亜科	あか	{}	{"suborder; subfamily"}	\N	\N	\N
赤	あか	{}	{"the color red (noun)"}	\N	\N	\N
赤い	あかい	{}	{red}	\N	\N	\N
証	あかし	{}	{"proof; evidence"}	\N	\N	\N
赤字	あかじ	{}	{"deficit; go in the red"}	\N	\N	\N
明かす	あかす	{}	{"to pass; spend; to reveal; to divulge"}	\N	\N	\N
赤ちゃん	あかちゃん	{}	{"baby; infant"}	\N	\N	\N
赤らむ	あからむ	{}	{"to become red; to redden; to blush"}	\N	\N	\N
明かり	あかり	{}	{"lamplight; brightness"}	\N	\N	\N
上がり	あがり	{}	{"slope; advance income; crop yield; ascent; rise; advance; death; spinning; completion; stop; finish; after (rain); ex (official etc.); freshly-drawn green tea (esp. in sushi shops)"}	\N	\N	\N
上がる	あがる	{}	{"go up; rise"}	\N	\N	\N
明るい	あかるい	{}	{"bright; cheerful"}	\N	\N	\N
明い	あかるい	{}	{"bright; light; cheerful; sunny"}	\N	\N	\N
赤ん坊	あかんぼう	{}	{baby}	\N	\N	\N
秋	あき	{}	{"autumn; fall"}	\N	\N	\N
空き家	あきや	{人の住んでいない家。あきいえ。}	{"an unoccupied [a vacant; an uninhabited; an empty] house; a house for rent"}	\N	\N	\N
明らか	あきらか	{}	{"obvious; clear"}	\N	\N	\N
諦め	あきらめ	{}	{"resignation; acceptance; consolation"}	\N	\N	\N
諦める	あきらめる	{}	{"give up; abandon"}	\N	\N	\N
飽きる	あきる	{}	{"get tired of; lose interest in"}	\N	\N	\N
赤色	あかいろ	{}	{red}	\N	\N	\N
銅	あかがね	{}	{copper}	\N	\N	\N
明白	あからさま	{}	{"obvious; overt; plainly; frankly"}	\N	\N	\N
商人	あきうど	{}	{"trader; shopkeeper; merchant"}	\N	\N	\N
空き	あき	{}	{"room; time to spare; emptiness; vacant"}	\N	{明き}	\N
曖昧	あいまい	{}	{"な 〔不明瞭な〕unclear; 〔明確につかめない〕vague; 〔どっちつかずの〕noncommittal; 〔多義・両義にとれる〕ambiguous; 〔いかようにもとれる〕equivocal"}	\N	\N	\N
挨拶	あいさつ	{}	{greeting}	{名,スル}	\N	\N
握手	あくしゅ	{}	{handshake}	\N	\N	\N
欠伸	あくび	{眠いとき、疲れたときなどに思わず口が大きく開いて息を深く吸い込み、やや短く吐き出す呼吸運動。}	{yawn}	\N	\N	\N
悪日	あくび	{}	{"unlucky day"}	\N	\N	\N
悪党	あくとう	{一般に悪人を意味する語。この場合の悪とは、概ね人道に外れた行いや、それに関連する有害なものを指す概念である。悪人、悪漢、ならず者、ごろつき。}	{⇒あくにん(悪人)}	\N	\N	\N
飽くなき	あくなき	{}	{"ravenous; insatiable; gluttonous"}	\N	\N	\N
悪魔	あくま	{}	{"evil spirit; devil; demon"}	\N	\N	\N
悪魔城	あくまじょう	{}	{"demon castle"}	\N	\N	\N
飽くまで	あくまで	{}	{"to the end; stubbornly; persistently"}	\N	\N	\N
悪夢	あくむ	{いやな恐ろしい夢。また、不吉な夢。「ーにうなされる」}	{"〔悪い夢〕a bad dream; 〔恐ろしい夢〕a nightmare; 〔不吉な夢〕an ominous dream"}	\N	\N	\N
明くる	あくる	{}	{"next; following"}	\N	\N	\N
朱	あけ	{}	{vermillion}	\N	\N	\N
明け方	あけがた	{}	{dawn}	\N	\N	\N
明ける	あける	{}	{"to dawn; become daylight"}	\N	\N	\N
開ける	あける	{}	{"become opened up; be up-to-date; become civilized"}	\N	\N	\N
揚げる	あげる	{揚げ物を作る。「てんぷらを―・げる」}	{"fry (tempura)"}	\N	\N	\N
顎	あご	{}	{chin}	\N	\N	\N
憧れ	あこがれ	{}	{"yearning; longing; aspiration"}	\N	\N	\N
憧れる	あこがれる	{}	{"long for; yearn after; admire; be attracted by"}	\N	\N	\N
朝	あさ	{}	{morning}	\N	\N	\N
麻	あさ	{}	{"flax; linen; hemp"}	\N	\N	\N
浅い	あさい	{}	{"shallow; superficial"}	\N	\N	\N
朝御飯	あさごはん	{}	{breakfast}	\N	\N	\N
朝寝坊	あさねぼう	{}	{"over sleep"}	\N	\N	\N
浅ましい	あさましい	{}	{"wretched; miserable; shameful; mean; despicable; abject"}	\N	\N	\N
あざ笑う	あざわらう	{}	{"to sneer at; to ridicule"}	\N	\N	\N
足	あし	{人・動物のあし。特に、くるぶしから先の部分。}	{"foot; pace; gait; leg"}	\N	\N	\N
脚	あし	{あし。本来は、ひざからくるぶしまでの部分。}	{"(すね) shins"}	\N	\N	\N
肢	あし	{"手と足。 胴体から分かれ出た部分。　あしを指すなら「下肢」。"}	{limb}	\N	\N	\N
味	あじ	{}	{taste}	\N	\N	\N
足跡	あしあと	{}	{footprints}	\N	\N	\N
足指	あしゆび	{足のゆび。そくし。}	{toes}	\N	\N	\N
味わい	あじわい	{}	{"flavour; meaning; significance"}	\N	\N	\N
味わう	あじわう	{}	{"to taste; savor; relish"}	\N	\N	\N
預かる	あずかる	{}	{"take charge of; receive deposit"}	\N	\N	\N
預ける	あずける	{}	{"put in charge of; to deposit"}	\N	\N	\N
汗	あせ	{}	{sweat}	\N	\N	\N
焦る	あせる	{}	{"to be in a hurry; to be impatient"}	\N	\N	\N
彼処	あそこ	{}	{"(uk) there; over there; that place; (X) (col) genitals"}	\N	\N	\N
遊び	あそび	{}	{play}	\N	\N	\N
遊ぶ	あそぶ	{}	{"play; make a visit (esp. for pleasure); be idle; do nothing"}	\N	\N	\N
字	あざ	{}	{"section of village"}	\N	\N	\N
明後日	あさって	{}	{"day after tomorrow"}	\N	\N	\N
明日	あした	{}	{tomorrow}	\N	\N	\N
明日	あす	{}	{tomorrow}	\N	\N	\N
東	あずま	{}	{"east; Eastern Japan"}	\N	\N	\N
値	あたい	{}	{"value; price; cost; worth; merit"}	\N	\N	\N
悪	あく	{}	{"evil; wickedness"}	\N	\N	\N
欺く	あざむく	{言葉巧みにうそを言って、相手に本当だと思わせる。言いくるめる。だます。「敵を―・く」「まんまと―・く」}	{"to deceive"}	\N	\N	\N
値する	あたいする	{}	{"to be worth; to deserve; to merit"}	\N	\N	\N
与える	あたえる	{}	{"give; to award"}	\N	\N	\N
暖かい	あたたかい	{"寒すぎもせず、暑すぎもせず、程よい気温である。あったかい。「―・い部屋」「―・い地方」《季 春》「―・きドアの出入となりにけり／万太郎」"}	{"warm; mild; genial"}	\N	\N	\N
温かい	あたたかい	{物が冷たくなく、また熱すぎもせず、程よい状態である。「―・い御飯」}	{〔熱さがちょうどいい〕hot}	\N	\N	\N
暖まる	あたたまる	{}	{"to warm oneself; to sun oneself; to warm up; to get warm"}	\N	\N	\N
頭	あたま	{}	{head}	\N	\N	\N
新しい	あたらしい	{}	{new}	\N	\N	\N
当たり	あたり	{}	{"hit; success; reaching the mark; per ...; vicinity; neighborhood"}	\N	\N	\N
当たり前	あたりまえ	{}	{"usual; common; ordinary; natural; reasonable; obvious"}	\N	\N	\N
彼方	あちら	{}	{"there; yonder; that"}	\N	\N	\N
厚い	あつい	{}	{"thick; deep; cordial; kind; warm(hearted)"}	\N	\N	\N
篤い	あつい	{病気が重い。容体が悪い。「師の病の―・いことを知った」}	{"seriously (ill); critical (condition); fervent (religous beliefs)"}	\N	\N	\N
暑い	あつい	{}	{"hot; warm"}	\N	\N	\N
熱い	あつい	{}	{"hot (thing)"}	\N	\N	\N
悪化	あっか	{}	{"deterioration; growing worse; aggravation; degeneration; corruption"}	\N	\N	\N
扱い	あつかい	{}	{"treatment; service"}	\N	\N	\N
扱う	あつかう	{}	{"to handle; deal with"}	\N	\N	\N
厚かましい	あつかましい	{}	{"impudent; shameless; brazen"}	\N	\N	\N
呆気ない	あっけない	{}	{"not enough; too quick (short long etc.)"}	\N	\N	\N
篤	あつし	{病気で弱っているさま。病気がちである。}	{"sickly-ness; easily become sick;"}	\N	\N	\N
圧縮	あっしゅく	{}	{"compression; condensation; pressure"}	\N	\N	\N
圧倒的	あっとうてき	{他より非常に勝っているさま。「―に強い」「―な支持を得る」}	{overwhelming}	\N	\N	\N
圧迫	あっぱく	{}	{"pressure; coercion; oppression"}	\N	\N	\N
集まり	あつまり	{}	{"gathering; meeting; assembly; collection"}	\N	\N	\N
集まる	あつまる	{}	{gather}	\N	\N	\N
集める	あつめる	{多くの人や物を一つところにまとめる。「聴衆を―・める」「切手を―・める」}	{"〔集合させる〕gather; get ((people; things)) together〔集金する，収集する〕collect〔集中する，引きつける〕attract; draw"}	\N	\N	\N
圧力	あつりょく	{}	{"stress; pressure"}	\N	\N	\N
当て	あて	{}	{"object; aim; end; hopes; expectations"}	\N	\N	\N
宛	あて	{}	{"addressed to"}	\N	\N	\N
当て字	あてじ	{}	{"phonetic-equivalent character; substitute character"}	\N	\N	\N
宛名	あてな	{}	{"address; direction"}	\N	\N	\N
当てはまる	あてはまる	{}	{"to apply (a rule)"}	\N	\N	\N
当てはめる	あてはめる	{}	{"to apply; to adapt"}	\N	\N	\N
当てる	あてる	{}	{"to hit"}	\N	\N	\N
宛てる	あてる	{}	{"to address"}	\N	\N	\N
跡継ぎ	あとつぎ	{}	{"heir; successor"}	\N	\N	\N
後回し	あとまわし	{}	{"putting off; postponing"}	\N	\N	\N
穴	あな	{}	{hole}	\N	\N	\N
貴女	あなた	{}	{"you; lady"}	\N	\N	\N
私	あたし	{}	{"I (fem)"}	\N	\N	\N
他人	あだびと	{}	{"another person; unrelated person; outsider; stranger"}	\N	\N	\N
辺り	あたり	{}	{"neighbourhood; vicinity; nearby"}	\N	\N	\N
彼方此方	あちこち	{}	{"here and there"}	\N	\N	\N
当たる	あたる	{物事や人が直面、接触する。「ボールが顔に―・る」「家族に―・る」「強敵に―・る」,物事がふさわしい状態になる。ねらいや希望などに当てはまる。「賞品としてテレビが―・る」「天気予報が―・る」「山が―・る」}	{"〔ぶつかる〕hit ((on; against))，strike; 〔軽くぶつかる〕touch; 〔光・風などを受ける〕","〔うまくいく，成功する〕be a hit/success〔くじなどで〕win〔的中する〕hit"}	\N	{当る,中る}	\N
あだ名	あだな	{本名とは別に、その人の容姿や性質などの特徴から、他人がつける名。ニックネーム。}	{nickname}	\N	{綽名,渾名}	\N
跡	あと	{}	{"trace; tracks; mark; sign; remains; ruins; scar"}	\N	{痕,迹,址}	\N
貴方	あなた	{対等または目下の者に対して、丁寧に、または親しみをこめていう。「―の考えを教えてください」}	{"〔主格〕you; 〔所有格〕your; yours; 〔目的格〕you ((単複同形)); 〔夫婦，親しい間の呼び掛け〕(my) dear; darling"}	\N	\N	\N
兄	あに	{}	{"older brother"}	\N	\N	\N
姉	あね	{}	{"older sister"}	\N	\N	\N
暴れる	あばれる	{}	{"act violently; struggle"}	\N	\N	\N
浴びる	あびる	{}	{"bathe; take a shower; bask in the sun"}	\N	\N	\N
危ない	あぶない	{}	{"dangerous; critical; grave; uncertain; unreliable; limping; narrow; close; watch out!"}	\N	\N	\N
脂	あぶら	{}	{"fat; lard"}	\N	\N	\N
油	あぶら	{}	{oil}	\N	\N	\N
油絵	あぶらえ	{}	{"oil painting"}	\N	\N	\N
溢れる	あふれる	{水などがいっぱいになって外にこぼれる。「コップに―・れるほど注ぐ」「川が―・れる」「涙が―・れる」}	{"水がいっぱいになってこぼれる〕overflow; 〔氾濫する〕flood; be inundated"}	\N	\N	\N
尼	あま	{}	{nun}	\N	\N	\N
雨傘	あまがさ	{雨降りの際にさす傘。}	{"an umbrella⇒かさ(傘)"}	\N	\N	\N
雨具	あまぐ	{}	{"rain gear"}	\N	\N	\N
甘口	あまくち	{比較的甘みの強い、または塩分や辛みをおさえた味加減。また、そのもの。「―の酒」⇔辛口。}	{"sweet flavour; mildness; flattery; stupidity"}	\N	\N	\N
天	あまつ	{}	{"heavenly; imperial"}	\N	\N	\N
雨戸	あまど	{}	{"(sliding) storm door"}	\N	\N	\N
甘やかす	あまやかす	{}	{"pamper; spoil"}	\N	\N	\N
余る	あまる	{}	{"remain; be left over; be too many"}	\N	\N	\N
網	あみ	{}	{"net; network"}	\N	\N	\N
網棚	あみだな	{電車・バスなどの座席の上方に、乗客の携帯品をのせるために設けた網張りの棚。}	{"〔客車内などの〕a rack"}	\N	\N	\N
編物	あみもの	{}	{"knitting; web"}	\N	\N	\N
編む	あむ	{}	{"to knit; to braid; compile (anthology; dictionary; etc.); edit"}	\N	\N	\N
雨	あめ	{}	{rain}	\N	\N	\N
天地	あめつち	{}	{"heaven and earth; the universe; nature; top and bottom; realm; sphere; world"}	\N	\N	\N
危うい	あやうい	{}	{"dangerous; watch out!"}	\N	\N	\N
怪しい	あやしい	{不思議な力がある。神秘的な感じがする。変な。「ー・い魅力」「宝石がー・く光る」}	{"suspicious; doubtful"}	\N	\N	\N
操る	あやつる	{}	{"to manipulate; to operate; to pull strings"}	\N	\N	\N
危ぶむ	あやぶむ	{}	{"to fear; to have misgivings; to be doubtful; to mistrust"}	\N	\N	\N
過ち	あやまち	{}	{"fault; error; indiscretion"}	\N	\N	\N
誤り	あやまり	{}	{error}	\N	\N	\N
謝る	あやまる	{}	{apologize}	\N	\N	\N
誤る	あやまる	{}	{"to make a mistake"}	\N	\N	\N
歩み	あゆみ	{}	{walking}	\N	\N	\N
歩む	あゆむ	{}	{"to walk; to go on foot"}	\N	\N	\N
荒い	あらい	{}	{"rough; rude; wild"}	\N	\N	\N
粗い	あらい	{}	{"coarse; rough"}	\N	\N	\N
洗う	あらう	{}	{"to wash"}	\N	\N	\N
予め	あらかじめ	{}	{"beforehand; in advance; previously"}	\N	\N	\N
荒さ	あらさ	{}	{"roughness; coarseness; abrasiveness"}	\N	\N	\N
嵐	あらし	{}	{storm}	\N	\N	\N
荒らす	あらす	{}	{"to lay waste; to devastate; to damage; to invade; to break into"}	\N	\N	\N
粗筋	あらすじ	{}	{"outline; summary"}	\N	\N	\N
争い	あらそい	{}	{"dispute; strife; quarrel; dissension; conflict; rivalry; contest"}	\N	\N	\N
争う	あらそう	{}	{"argue; dispute"}	\N	\N	\N
新た	あらた	{}	{new}	\N	\N	\N
改まる	あらたまる	{}	{"to be renewed"}	\N	\N	\N
甘い	あまい	{}	{delicious}	\N	\N	\N
暴く	あばく	{}	{"〔他人の秘密などをばらす〕expose; disclose; reveal; bring to light"}	\N	{発く}	\N
貴方方	あなたがた	{「あなた」の複数形。「あなたたち」よりも、やや敬意が高い。「―はどちらからおいでになりましたか」}	{"you (plural)"}	\N	\N	\N
甘える	あまえる	{かわいがってもらおうとして、まとわりついたり物をねだったりする。甘ったれる。「子供が親に―・える」,相手の好意に遠慮なくよりかかる。また、なれ親しんでわがままに振る舞う。甘ったれる。「お言葉に―・えてお借りします」}	{"〔甘ったれる〕behave like a baby [spoiled child]; demand attention","〔好意を利用する〕depend on;"}	\N	\N	\N
改めて	あらためて	{}	{again}	\N	\N	\N
荒っぽい	あらっぽい	{}	{"rough; rude"}	\N	\N	\N
あらゆる	あらゆる	{あるかぎりの。すべての。「ー角度から検討する」}	{"all; every"}	\N	\N	\N
現す	あらわす	{}	{"indicate; show; display"}	\N	\N	\N
著す	あらわす	{}	{"write; publish"}	\N	\N	\N
表す	あらわす	{}	{"express; show; reveal"}	\N	\N	\N
現われ	あらわれ	{}	{"embodiment; materialization"}	\N	\N	\N
現れ	あらわれ	{}	{embodiment}	\N	\N	\N
現われる	あらわれる	{}	{"to appear; to come in sight; to become visible; to come out; to embody; to materialize; to express oneself"}	\N	\N	\N
現れる	あらわれる	{}	{"appear; embody; express oneself"}	\N	\N	\N
有り得ない	ありえない	{あるはずがない。ありそうもない。そうなる可能性がない。「時間が逆に進むことは―◦ない」}	{"i can't believe it!"}	\N	\N	\N
有難い	ありがたい	{}	{"grateful; thankful; welcome; appreciated"}	\N	\N	\N
有難う	ありがとう	{}	{thanks}	\N	\N	\N
有様	ありさま	{}	{"state; condition; circumstances; the way things are or should be; truth"}	\N	\N	\N
有りのまま	ありのまま	{}	{"the truth; fact; as it is; frankly"}	\N	\N	\N
或る	ある	{}	{"a certain; one; some; ある場合には: in some cases"}	\N	\N	\N
有る	ある	{}	{"to be; to have"}	\N	\N	\N
在る	ある	{}	{"to live; to be"}	\N	\N	\N
主	あるじ	{}	{leader}	\N	\N	\N
彼此	あれこれ	{}	{"one thing or another; this and that; this or that"}	\N	\N	\N
泡	あわ	{}	{"bubble; foam; froth"}	\N	\N	\N
合わす	あわす	{}	{"to join together; to face; to unite; to be opposite; to combine; to connect; to add up; to mix; to match; to overlap; to compare; to check with"}	\N	\N	\N
合わせ	あわせ	{}	{"joint together; opposite; facing"}	\N	\N	\N
合わせる	あわせる	{}	{"join together; connect; unite; combine; add up; mix; match; overlap; be opposite; face; compare; check with"}	\N	\N	\N
慌ただしい	あわただしい	{}	{"busy; hurried; confused; flurried"}	\N	\N	\N
慌てる	あわてる	{}	{"to become confused (disconcerted disorganized)"}	\N	\N	\N
哀れ	あわれ	{}	{"helpless; pathos; pity; sorrow; grief; misery; compassion"}	\N	\N	\N
案	あん	{考え。計画。「―を練る」}	{"plan; suffix meaning draft"}	\N	\N	\N
安易	あんい	{}	{easygoing}	\N	\N	\N
暗雲	あんうん	{真っ黒な雲。今にも雨や雪が降りだしそうな気配のある暗い雲。「―が垂れ込める」}	{"〔暗い雲〕dark clouds"}	\N	\N	\N
案外	あんがい	{}	{unexpectedly}	\N	\N	\N
暗記	あんき	{}	{memorization}	\N	\N	\N
暗殺	あんさつ	{}	{assassination}	\N	\N	\N
暗算	あんざん	{}	{"mental arithmetic"}	\N	\N	\N
暗示	あんじ	{}	{"hint; suggestion"}	\N	\N	\N
案じる	あんじる	{}	{"to be anxious; to ponder"}	\N	\N	\N
安心	あんしん	{}	{"peace of mind; relief"}	\N	\N	\N
安静	あんせい	{}	{rest}	\N	\N	\N
安全	あんぜん	{}	{safety}	\N	\N	\N
案ずる	あんずる	{心配する。思い煩う。気遣う。「―・ずるには及ばない」「将来を―・ずる」}	{"worry; fear"}	\N	\N	\N
安定	あんてい	{}	{"stability; equilibrium"}	\N	\N	\N
案内	あんない	{}	{"information; guidance"}	\N	\N	\N
案の定	あんのじょう	{}	{"sure enough; as usual"}	\N	\N	\N
蚊	か	{}	{mosquito}	{動物}	\N	\N
歩く	あるく	{}	{"to walk"}	\N	{步く}	\N
罰	ばち	{}	{"(divine) punishment; curse; retribution"}	\N	\N	\N
兎	う	{}	{rabbit}	{動物}	\N	\N
鰻	うなぎ	{}	{eel}	{動物}	\N	\N
馬	うま	{}	{horse}	{動物}	\N	\N
狼	おおかみ	{}	{wolf}	{動物}	\N	\N
亀	かめ	{}	{"tortoise; turtle"}	{動物}	\N	\N
孔雀	くじゃく	{キジ目キジ科クジャク属の鳥の総称。}	{"〔雄〕a peacock; 〔雌〕a peahen; 〔通称〕a peafowl; 〔ひな〕a peachick"}	{動物}	\N	\N
熊	くま	{}	{bear}	{動物}	\N	\N
鯉	こい	{}	{carp}	{動物}	\N	\N
駒	こま	{}	{pony}	{動物}	\N	\N
兔	うさぎ	{}	{rabbit}	{動物}	{兎}	\N
蛙	かえる	{}	{frog}	{動物}	{カエル}	\N
場	ば	{}	{"place; (physics) field"}	\N	\N	\N
ば	ば	{口語では活用語の仮定形、文語では活用語の未然形に付く。未成立の事柄を成立したものと仮定する条件を表す。もし…ならば。「暇ができれ―行く」「雨天なら―中止する」}	{if}	\N	\N	\N
場合	ばあい	{物事が行われているときの状態・事情。局面。「―が―だけに慎重な判断が必要だ」「時と―による」「遊んでいる―ではない」}	{"case; occasion"}	\N	\N	\N
倍	ばい	{}	{"double; two times"}	\N	\N	\N
売却	ばいきゃく	{売りはらうこと。「土地を―する」}	{"sale; disposal by sale"}	\N	\N	\N
黴菌	ばいきん	{}	{"bacteria; germ(s)"}	\N	\N	\N
売春	ばいしゅん	{女性が報酬を得ることを目的として不特定の相手と性交すること。売淫。売色。売笑。}	{prostitution}	\N	\N	\N
賠償	ばいしょう	{}	{"reparations; indemnity; compensation"}	\N	\N	\N
陪食	ばいしょく	{}	{"Dining with one's superior"}	\N	\N	\N
媒体	ばいたい	{}	{"media (e.g. social)"}	\N	\N	\N
売店	ばいてん	{}	{"shop; stand"}	\N	\N	\N
売買	ばいばい	{}	{"trade; buying and selling"}	\N	\N	\N
倍率	ばいりつ	{}	{"diameter; magnification"}	\N	\N	\N
馬鹿	ばか	{}	{"fool; idiot; trivial matter; folly"}	\N	\N	\N
馬鹿馬鹿しい	ばかばかしい	{}	{stupid}	\N	\N	\N
馬鹿らしい	ばからしい	{}	{absurd}	\N	\N	\N
漠然	ばくぜん	{}	{"obscure; vague; equivocal"}	\N	\N	\N
莫大	ばくだい	{}	{"enormous; vast"}	\N	\N	\N
爆弾	ばくだん	{}	{bomb}	\N	\N	\N
爆破	ばくは	{}	{"blast; explosion; blow up"}	\N	\N	\N
爆発	ばくはつ	{}	{"explosion; detonation; eruption"}	\N	\N	\N
幕府	ばくふ	{日本の中世及び近世における征夷大将軍を首長とする武家政権のことをいう。あるいはその武家政権の政庁、征夷大将軍の居館・居城を指す名称としても用いられる。}	{"shogunate; tokugawa government"}	\N	\N	\N
爆裂	ばくれつ	{爆発して破裂すること。「砲弾が―する」}	{"an explosion⇒ばくはつ(爆発)"}	\N	\N	\N
暴露	ばくろ	{}	{"disclosure; exposure; revelation"}	\N	\N	\N
化ける	ばける	{}	{"to appear in disguise; to take the form of; to change for the worse"}	\N	\N	\N
化け物	ばけもの	{動植物や無生物が人の姿をとって現れるもの。キツネ・タヌキなどの化けたものや、柳の精・桜の精・雪女郎など。また、一つ目小僧・大入道・ろくろ首などあやしい姿をしたもの。お化け。妖怪。}	{"〔怪物〕a monster; 〔幽霊〕a ghost，(口) a spook，(文) a phantom"}	\N	\N	\N
場所	ばしょ	{}	{"place; location"}	\N	\N	\N
猫	ねこ	{}	{cat}	{動物}	\N	\N
鼠	ねずみ	{}	{"〔大型のねずみ〕a rat; 〔小型のねずみ，二十日鼠〕a mouse ((複mice))"}	{動物}	\N	\N
鳩	はと	{}	{"pigeon; dove"}	{動物}	\N	\N
羊	ひつじ	{}	{sheep}	{動物}	\N	\N
伐	ばつ	{}	{"strike; attack; punish"}	\N	\N	\N
罰ゲーム	ばつげーむ	{ゲームや勝負事で負けた人が罰としてやらされる行為。}	{"penatly game"}	\N	\N	\N
伐採	ばっさい	{}	{"felling; deforestation; lumbering"}	\N	\N	\N
罰する	ばっする	{}	{"punish; penalize"}	\N	\N	\N
発条	ばね	{}	{"spring (e.g. coil leaf)"}	\N	\N	\N
婆	ばば	{老女。また、老女をののしっていう語。⇔爺 (じじい) 。}	{"a hag"}	\N	\N	\N
婆あ	ばばあ	{老女。また、老女をののしっていう語。⇔爺 (じじい) 。}	{"a hag"}	\N	\N	\N
場面	ばめん	{}	{"scene; setting (e.g. of novel)"}	\N	\N	\N
散蒔く	ばらまく	{}	{"to disseminate; to scatter; to give money freely"}	\N	\N	\N
晩	ばん	{}	{evening}	\N	\N	\N
番組	ばんぐみ	{}	{"TV program"}	\N	\N	\N
番号	ばんごう	{}	{"number; series of digits"}	\N	\N	\N
番号札	ばんごうふだ	{}	{"number tag"}	\N	\N	\N
晩御飯	ばんごはん	{}	{"dinner; evening meal"}	\N	\N	\N
万歳	ばんざい	{}	{"strolling comic dancer"}	\N	\N	\N
万人	ばんじん	{}	{"all people; everybody; 10000 people"}	\N	\N	\N
万全	ばんぜん	{少しも手落ちのないこと。きわめて完全なこと。}	{"perfection; (to be) absolutely (sure)"}	\N	\N	\N
番地	ばんち	{}	{"house number; address"}	\N	\N	\N
万能	ばんのう	{}	{"all-purpose; almighty; omnipotent"}	\N	\N	\N
番目	ばんめ	{}	{"cardinal number suffix"}	\N	\N	\N
べき	べき	{当然の意を表す。〜して当然だ。〜のはずだ。〜しなければならない}	{"must; should"}	\N	\N	\N
べし	べし	{当然の意を表す。〜して当然だ。〜のはずだ。〜しなければならない}	{"must; should"}	\N	\N	\N
別	べつ	{}	{"distinction; difference; different; another; particular; separate; extra; exception"}	\N	\N	\N
別荘	べっそう	{}	{"holiday house; villa"}	\N	\N	\N
弁解	べんかい	{}	{"explanation; justification; defence; excuse"}	\N	\N	\N
便宜	べんぎ	{}	{"convenience; accommodation; advantage; expedience"}	\N	\N	\N
勉強	べんきょう	{}	{"study; diligence; discount; reduction"}	\N	\N	\N
弁護	べんご	{}	{"defense; pleading; advocacy"}	\N	\N	\N
弁護士	べんごし	{当事者その他の関係人の依頼または官公署の委嘱によって、訴訟に関する行為その他一般の法律事務を行うことを職務とする者。一定の資格を持ち、日本弁護士連合会に備えた弁護士名簿に登録されなければならない。}	{"a lawyer，((米)) an attorney (at law); 〔法律顧問〕counsel"}	\N	\N	\N
便所	べんじょ	{}	{"toilet; lavatory; rest room; latrine"}	\N	\N	\N
弁償	べんしょう	{}	{"next word; compensation; reparation; indemnity; reimbursement"}	\N	\N	\N
弁当	べんとう	{}	{"lunch box"}	\N	\N	\N
便利	べんり	{}	{"convenient; handy; useful"}	\N	\N	\N
弁論	べんろん	{}	{"discussion; debate; argument"}	\N	\N	\N
美	び	{}	{beauty}	\N	\N	\N
微行	びこう	{}	{"traveling incognito"}	\N	\N	\N
美術	びじゅつ	{視覚的、空間的な美を表現する造形芸術。絵画・彫刻・建築・工芸など。明治時代は、広く文学・音楽なども含めていった。「古ー」「仏教ー」}	{"art; fine arts"}	\N	\N	\N
美術館	びじゅつかん	{}	{"art gallery"}	\N	\N	\N
微笑	びしょう	{}	{smile}	\N	\N	\N
美人	びじん	{}	{"beautiful person (woman)"}	\N	\N	\N
窒息	ちっそく	{}	{suffocation}	\N	\N	\N
罰	ばつ	{罪や過ちに対するこらしめ。仕置き。「一週間外出禁止の―を受ける」「―として廊下に立たされる」⇔賞。}	{"punishment; 日本語の「罰」のほか，「刑」にも相当することがある); (a) penalty"}	\N	\N	\N
薔薇	ばら	{}	{rose,"male homosexual-manga genre; aka. Men's Love (ML メンズラブ); is a Japanese technical term for a genre of art and fictional media that focuses on male same-sex love; usually created by gay men for a gay audience. The bara genre began in the 1950s with fetish magazines featuring gay art and content."}	\N	\N	\N
万	ばん	{}	{"many; all"}	\N	\N	\N
糞	ばば	{大便、また、汚いものをいう幼児語。}	{"(child speak) poop; something dirty"}	\N	{屎}	\N
別に	べつに	{取り立てて言うほどではないさま。これと言って特別に。別段。「―たいした用事ではない」}	{"(not) particularly. nothing"}	\N	\N	\N
別々	べつべつ	{}	{"separately; individually"}	\N	{別別}	\N
吃驚	びっくり	{}	{"be surprised; be amazed; be frightened; astonishment"}	\N	\N	\N
微妙	びみょう	{}	{"delicate; subtle"}	\N	\N	\N
白虎	びゃっこ	{}	{"white tiger"}	\N	\N	\N
白虎隊	びゃっこたい	{}	{"white tiger squad"}	\N	\N	\N
秒	びょう	{}	{"second (time)"}	\N	\N	\N
美容	びよう	{}	{"beauty of figure or form"}	\N	\N	\N
病院	びょういん	{}	{hospital}	\N	\N	\N
病気	びょうき	{}	{"illness; disease; sickness"}	\N	\N	\N
描写	びょうしゃ	{}	{"depiction; description; portrayal"}	\N	\N	\N
平等	びょうどう	{}	{"equality; impartiality; evenness"}	\N	\N	\N
微量	びりょう	{}	{"minuscule amount; extremely small quantity"}	\N	\N	\N
便	びん	{}	{"mail; post; flight (e.g. airline flight); service; opportunity; chance; letter"}	\N	\N	\N
敏感	びんかん	{}	{"sensibility; susceptibility; sensitive (to); well attuned to"}	\N	\N	\N
便箋	びんせん	{}	{"writing paper; stationery"}	\N	\N	\N
瓶詰	びんづめ	{}	{"bottling; bottled"}	\N	\N	\N
貧乏	びんぼう	{}	{"poverty; destitute; poor"}	\N	\N	\N
棒	ぼう	{}	{"pole; rod; stick"}	\N	\N	\N
防衛	ぼうえい	{他からの攻撃に対して、防ぎ守ること。「祖国をーする」「タイトルをーする」「正当ー」}	{"defense; protection; self-defense"}	\N	\N	\N
貿易	ぼうえき	{}	{trade}	\N	\N	\N
望遠鏡	ぼうえんきょう	{}	{telescope}	\N	\N	\N
防火	ぼうか	{}	{"fire prevention; fire fighting; fire proof"}	\N	\N	\N
妨害	ぼうがい	{}	{"disturbance; obstruction; hindrance; jamming; interference"}	\N	\N	\N
防御	ぼうぎょ	{敵の攻撃などを防ぎ守ること。「攻撃は最大のー」「敵の猛攻をーする」}	{defense}	\N	\N	\N
冒険	ぼうけん	{}	{"risk; venture; adventure"}	\N	\N	\N
坊さん	ぼうさん	{}	{"Buddhist priest; monk"}	\N	\N	\N
帽子	ぼうし	{}	{hat}	\N	\N	\N
防止	ぼうし	{}	{"prevention; check"}	\N	\N	\N
紡錘	ぼうすい	{}	{"a spindle"}	\N	\N	\N
紡績	ぼうせき	{}	{spinning}	\N	\N	\N
呆然	ぼうぜん	{}	{"dumbfounded; overcome with surprise; in blank amazement"}	\N	\N	\N
膨大	ぼうだい	{}	{"huge; bulky; enormous; extensive; swelling; expansion"}	\N	\N	\N
膨脹	ぼうちょう	{}	{"expansion; swelling; increase; growth"}	\N	\N	\N
傍聴	ぼうちょう	{}	{"hearing; attendence"}	\N	\N	\N
冒頭	ぼうとう	{}	{"beginning; start; outset"}	\N	\N	\N
暴動	ぼうどう	{}	{"insurrection; rebellion; revolt; riot; uprising"}	\N	\N	\N
某日	ぼうにち	{ある日。どの日か不明な場合や日付を伏せる場合などに用いる。「某月ー」}	{"a certain day"}	\N	\N	\N
防犯	ぼうはん	{}	{"prevention of crime"}	\N	\N	\N
暴風	ぼうふう	{}	{"storm; windstorm; gale"}	\N	\N	\N
暴風雨	ぼうふうう	{激しい風を伴った雨。台風や発達した低気圧によって起こる。あらし。}	{"a rainstorm; 〔台風〕a typhoon; 〔特に西インド諸島付近の〕a hurricane"}	\N	\N	\N
坊や	ぼうや	{}	{boy}	\N	\N	\N
暴力	ぼうりょく	{}	{violence}	\N	\N	\N
暴力的	ぼうりょくてき	{}	{violent}	\N	\N	\N
募金	ぼきん	{}	{"fund-raising; collection of funds"}	\N	\N	\N
牧師	ぼくし	{}	{"pastor; minister; clergyman"}	\N	\N	\N
牧場	ぼくじょう	{}	{"farm (livestock); pasture land; meadow; grazing land"}	\N	\N	\N
牧畜	ぼくちく	{}	{stock-farming}	\N	\N	\N
母語	ぼご	{人が生まれて最初に習い覚えた言語。母国語。}	{"mother tongue"}	\N	\N	\N
母校	ぼこう	{}	{"alma mater"}	\N	\N	\N
募集	ぼしゅう	{}	{"recruiting; taking applications"}	\N	\N	\N
没収	ぼっしゅう	{}	{forfeited}	\N	\N	\N
坊ちゃん	ぼっちゃん	{}	{"son (of others)"}	\N	\N	\N
勃発	ぼっぱつ	{事件などが突然に起こること。「内乱がーする」}	{"outbreak; sudden occurance"}	\N	\N	\N
没落	ぼつらく	{}	{"ruin; fall; collapse"}	\N	\N	\N
藍褸	ぼろ	{}	{"rag; scrap; tattered clothes; fault (esp. in a pretense); defect; run-down or junky"}	\N	\N	\N
盆	ぼん	{}	{"Lantern Festival; Festival of the Dead; tray"}	\N	\N	\N
盆地	ぼんち	{}	{"basin (e.g. between mountains)"}	\N	\N	\N
知的	ちてき	{}	{intellectual}	\N	\N	\N
分	ぶ	{}	{"rate; part; percentage; one percent; thickness; odds; chance of winning; one-hundredth of a shaku; one-quarter of a ryou"}	\N	\N	\N
僕	ぼく	{}	{"I (used by men with close acquaintances)"}	\N	\N	\N
部	ぶ	{}	{"department; part; category; counter for copies of a newspaper or magazine"}	\N	\N	\N
部下	ぶか	{組織などで、ある人の下に属し、その指示・命令で行動する人。配下。手下。}	{"subordinate person"}	\N	\N	\N
武器	ぶき	{}	{"weapon; arms; ordinance"}	\N	\N	\N
不気味	ぶきみ	{気味が悪いこと。また、そのさま。「―な笑い声」}	{"〜な weird; 〔幽霊などを暗示させる〕eerie; 〔不吉な〕ominous; 〔不可解な〕uncanny; 〔この世のものでない〕unearthly"}	\N	\N	\N
無沙汰	ぶさた	{}	{"neglecting to stay in contact"}	\N	\N	\N
武士	ぶし	{}	{"warrior; samurai"}	\N	\N	\N
無事	ぶじ	{}	{"safety; peace; quietness"}	\N	\N	\N
武士道	ぶしどう	{}	{bushido}	\N	\N	\N
部首	ぶしゅ	{}	{"radical of a kanji"}	\N	\N	\N
部署	ぶしょ	{それぞれに役割や分担を決めること。また、その役割や担当した場所。持ち場。「ーを移る」}	{"one's post; one's station"}	\N	\N	\N
侮辱	ぶじょく	{}	{"insult; contempt; slight"}	\N	\N	\N
武装	ぶそう	{}	{"arms; armament; armed"}	\N	\N	\N
舞台	ぶたい	{}	{"stage (theatre); scene or setting (e.g. of novel; play; etc.)"}	\N	\N	\N
部隊	ぶたい	{}	{forces}	\N	\N	\N
豚肉	ぶたにく	{}	{pork}	\N	\N	\N
斑	ぶち	{}	{"spots; speckles; mottles"}	\N	\N	\N
物価	ぶっか	{}	{"prices of commodities; prices (in general); cost-of-living"}	\N	\N	\N
物議	ぶつぎ	{}	{"public discussion (criticism)"}	\N	\N	\N
打付ける	ぶつける	{}	{"to knock; to run into; to nail on; to strike hard; to hit and attack"}	\N	\N	\N
物資	ぶっし	{}	{"goods; materials"}	\N	\N	\N
物質	ぶっしつ	{}	{"material; substance"}	\N	\N	\N
物騒	ぶっそう	{}	{"dangerous; disturbed; insecure"}	\N	\N	\N
仏像	ぶつぞう	{}	{"Buddhist image (statue)"}	\N	\N	\N
物体	ぶったい	{}	{"body; object"}	\N	\N	\N
仏壇	ぶつだん	{}	{"buddhist altar"}	\N	\N	\N
物理	ぶつり	{}	{physics}	\N	\N	\N
武道	ぶどう	{}	{budo}	\N	\N	\N
無難	ぶなん	{}	{"safety; security"}	\N	\N	\N
部品	ぶひん	{}	{"parts; accessories"}	\N	\N	\N
部門	ぶもん	{}	{"class; group; category; department; field; branch"}	\N	\N	\N
ぶら下げる	ぶらさげる	{}	{"to hang; to suspend; to dangle; to swing"}	\N	\N	\N
武力	ぶりょく	{}	{"armed might; military power; the sword; force"}	\N	\N	\N
無礼	ぶれい	{}	{"impolite; rude"}	\N	\N	\N
文化	ぶんか	{}	{culture}	\N	\N	\N
分解	ぶんかい	{}	{"analysis; disassembly"}	\N	\N	\N
文学	ぶんがく	{}	{literature}	\N	\N	\N
文化財	ぶんかざい	{}	{"cultural assets; cultural property"}	\N	\N	\N
分割	ぶんかつ	{いくつかに分けること。「土地を―して分け与える」}	{"division; partition"}	\N	\N	\N
分業	ぶんぎょう	{}	{"division of labor; specialization; assembly-line production"}	\N	\N	\N
文芸	ぶんげい	{}	{"literature; art and literature"}	\N	\N	\N
文献	ぶんけん	{}	{"literature; books (reference)"}	\N	\N	\N
分権	ぶんけん	{権力を1か所に集中しないで、分散すること。「地方ー」反：集権。}	{splitting}	\N	\N	\N
文語	ぶんご	{}	{"written language; literary language"}	\N	\N	\N
分散	ぶんさん	{}	{"dispersion; decentralization; variance (statistics)"}	\N	\N	\N
分子	ぶんし	{}	{"numerator; molecule"}	\N	\N	\N
文書	ぶんしょ	{}	{"document; writing; letter; note; records; archives"}	\N	\N	\N
文章	ぶんしょう	{}	{"sentence; article"}	\N	\N	\N
分数	ぶんすう	{}	{"(mathematics) fraction"}	\N	\N	\N
分析	ぶんせき	{複雑な事柄を一つ一つの要素や成分に分け、その構成などを明らかにすること。「情勢の―があまい」「事故の原因を―する」}	{analysis}	\N	\N	\N
文体	ぶんたい	{}	{"literary style"}	\N	\N	\N
分担	ぶんたん	{}	{"apportionment; sharing"}	\N	\N	\N
不粋	ぶすい	{世態・人情、特に男女の間の微妙な情のやりとりに通じていないこと。また、そのさま。遊びのわからないさま、面白味のないさまなどにもいう。やぼ。「―なことを言う」「―な客」⇔粋。}	{"〜な 〔粗野な〕boorish; 〔洗練されない〕unrefined; unpolished"}	\N	{無粋}	\N
分配	ぶんぱい	{}	{"division; sharing"}	\N	\N	\N
分布	ぶんぷ	{}	{distribution}	\N	\N	\N
分泌	ぶんぴつ	{}	{secretion}	\N	\N	\N
分母	ぶんぼ	{}	{denominator}	\N	\N	\N
文法	ぶんぽう	{}	{grammar}	\N	\N	\N
文房具	ぶんぼうぐ	{}	{stationery}	\N	\N	\N
文脈	ぶんみゃく	{}	{context}	\N	\N	\N
文明	ぶんめい	{人知が進んで世の中が開け、精神的、物質的に生活が豊かになった状態。特に、宗教・道徳・学問・芸術などの精神的な文化に対して、技術・機械の発達や社会制度の整備などによる経済的・物質的文化をさす。；シビリゼーション}	{civilization}	\N	\N	\N
分野	ぶんや	{}	{"field; sphere; realm; division; branch"}	\N	\N	\N
分離	ぶんり	{}	{"separation; detachment; segregation; isolation"}	\N	\N	\N
分量	ぶんりょう	{}	{"amount; quantity"}	\N	\N	\N
分類	ぶんるい	{}	{classification}	\N	\N	\N
分裂	ぶんれつ	{一つのまとまりが、いくつかのものに分かれること。「会がーする」}	{"split; division; break up"}	\N	\N	\N
地	ち	{}	{earth}	\N	\N	\N
血	ち	{}	{blood}	\N	\N	\N
地位	ちい	{}	{"(social) position; status"}	\N	\N	\N
地域	ちいき	{}	{"area; region"}	\N	\N	\N
小さい	ちいさい	{}	{"small; little; tiny"}	\N	\N	\N
小さな	ちいさな	{}	{small}	\N	\N	\N
知恵	ちえ	{}	{"wisdom; wit; sagacity; sense; intelligence; advice"}	\N	\N	\N
遅延	ちえん	{予定された期日や時間におくれること。また、長引くこと。「雪のために列車がーした」「ー証明」}	{"delay; being late; overdue"}	\N	\N	\N
地下	ちか	{}	{"basement; underground"}	\N	\N	\N
近い	ちかい	{}	{"near; close by; short"}	\N	\N	\N
違い	ちがい	{}	{"difference; discrepancy"}	\N	\N	\N
違いない	ちがいない	{}	{"sure; no mistaking it; for certain"}	\N	\N	\N
誓う	ちかう	{}	{"swear; vow; take an oath; pledge"}	\N	\N	\N
違う	ちがう	{}	{"differ (from)"}	\N	\N	\N
違える	ちがえる	{}	{"to change"}	\N	\N	\N
近く	ちかく	{}	{"near; neighbourhood; vicinity"}	\N	\N	\N
近頃	ちかごろ	{}	{"lately; recently; nowadays"}	\N	\N	\N
地下水	ちかすい	{}	{"underground water"}	\N	\N	\N
近付ける	ちかづける	{}	{"bring near; put close; let come near; associate with"}	\N	\N	\N
地下鉄	ちかてつ	{}	{"underground train; subway"}	\N	\N	\N
近寄る	ちかよる	{}	{"approach; draw near"}	\N	\N	\N
力	ちから	{}	{"strength; power"}	\N	\N	\N
力強い	ちからづよい	{}	{"reassuring; emboldened"}	\N	\N	\N
地球	ちきゅう	{}	{"the earth"}	\N	\N	\N
契る	ちぎる	{}	{"to pledge; to promise; to swear"}	\N	\N	\N
地区	ちく	{}	{"district; section; sector"}	\N	\N	\N
逐一	ちくいち	{順を追って、一つ残らず取り上げていくこと。何から何まで全部。いちいち。副詞的にも用いる。一つ一つ。詳しく。「事のーはあとで話そう」}	{"one by one; in detail"}	\N	\N	\N
畜産	ちくさん	{}	{"animal husbandry"}	\N	\N	\N
蓄積	ちくせき	{}	{"accumulation; accumulate; store"}	\N	\N	\N
遅刻	ちこく	{決められた時刻に遅れること。「待ち合わせにーする」}	{"be late; late for"}	\N	\N	\N
知事	ちじ	{各都道府県を統轄し、代表する首長。}	{"a (prefectural) governor"}	\N	\N	\N
知識	ちしき	{}	{"knowledge; information"}	\N	\N	\N
地質	ちしつ	{}	{"geological features"}	\N	\N	\N
知人	ちじん	{}	{"friend; acquaintance"}	\N	\N	\N
地図	ちず	{}	{map}	\N	\N	\N
知性	ちせい	{}	{intelligence}	\N	\N	\N
地帯	ちたい	{}	{"area; zone"}	\N	\N	\N
乳	ちち	{}	{"milk; breast; loop"}	\N	\N	\N
父	ちち	{}	{father}	\N	\N	\N
父親	ちちおや	{}	{father}	\N	\N	\N
縮まる	ちぢまる	{}	{"to be shortened; to be contracted; to shrink"}	\N	\N	\N
縮む	ちぢむ	{}	{"shrink; be contracted"}	\N	\N	\N
縮める	ちぢめる	{}	{"shorten; reduce; boil down; shrink"}	\N	\N	\N
縮れる	ちぢれる	{}	{"be wavy; be curled"}	\N	\N	\N
秩序	ちつじょ	{物事を行う場合の正しい順序・筋道。順番。「ーを立てて考える」}	{"order; systematically"}	\N	\N	\N
畜生	ちくしょう	{鳥・獣・虫魚の総称。人間以外の動物。,人を憎んだり、ののしったりしていう語。感動詞的に、怒りや失望などの気持ちを表すときにも用いる。「―め、おぼえてろ」「―、うまくいかないなあ」}	{"beast; brute","〔ののしり〕damn it; damn you; dang it"}	\N	\N	\N
地点	ちてん	{}	{"site; point on a map"}	\N	\N	\N
因み	ちなみ	{関係があること。ゆかり。因縁。「籍もあちらへ送った事ゆえ、余 (おれ) にはさっぱり―はない」}	{"to be associated (with); to be connected (with)"}	\N	\N	\N
因みに	ちなみに	{前に述べた事柄に、あとから簡単な補足などを付け加えるときに用いる。ついでに言うと。「―、新郎と新婦は幼いころからのお知り合いです」}	{"by the way"}	\N	\N	\N
知能	ちのう	{}	{"intelligence; brains"}	\N	\N	\N
地平線	ちへいせん	{}	{horizon}	\N	\N	\N
痴呆	ちほう	{}	{dementia}	\N	\N	\N
地方	ちほう	{広い地域；中央に対して}	{"district; the country; the provinces"}	\N	\N	\N
地方分権	ちほうぶんけん	{中央集権を排し、統治権力を地方に分散させること。日本国憲法は地方自治を保障し、地方分権主義を採っている。反：中央集権。}	{"decentralization of power"}	\N	\N	\N
地名	ちめい	{}	{"place name"}	\N	\N	\N
茶	ちゃ	{}	{tea}	\N	\N	\N
茶色	ちゃいろ	{}	{"light brown; tawny"}	\N	\N	\N
茶色い	ちゃいろい	{}	{"brown (adjective)"}	\N	\N	\N
着	ちゃく	{}	{"counter for suits of clothing; arriving at .."}	\N	\N	\N
着手	ちゃくしゅ	{}	{"embarkation; launch"}	\N	\N	\N
着色	ちゃくしょく	{}	{"colouring; coloring"}	\N	\N	\N
茶水	ちゃすい	{}	{"tea water"}	\N	\N	\N
嫡出	ちゃくしゅつ	{}	{legitimacy}	\N	\N	\N
着席	ちゃくせき	{}	{"sit down; seat"}	\N	\N	\N
着地	ちゃくち	{空中から地面に降り着くこと。着陸。「滑走路に無事―する」}	{"(a) touchdown; 〔軟着陸〕a soft landing"}	\N	\N	\N
着々	ちゃくちゃく	{}	{steadily}	\N	\N	\N
着目	ちゃくもく	{}	{attention}	\N	\N	\N
着陸	ちゃくりく	{}	{"landing; alighting; touch down"}	\N	\N	\N
着工	ちゃっこう	{}	{"start of (construction) work"}	\N	\N	\N
茶葉	ちゃば	{}	{"tea leaves"}	\N	\N	\N
茶の間	ちゃのま	{}	{"living room (Japanese style)"}	\N	\N	\N
茶の湯	ちゃのゆ	{}	{"tea ceremony"}	\N	\N	\N
茶碗	ちゃわん	{}	{"tea cup; rice bowl"}	\N	\N	\N
ちゃんと	ちゃんと	{少しも乱れがなく、よく整っているさま。}	{"regularly; neatly"}	\N	\N	\N
注	ちゅう	{}	{"annotation; explanatory note"}	\N	\N	\N
注意	ちゅうい	{気をつけること。気をくばること。留意。用心。警告。「よくーして観察する」}	{"advise; pay attention; care"}	\N	\N	\N
中央	ちゅうおう	{ある物や場所などのまんなかの位置。「町のーにある公園」}	{"center; middle; central"}	\N	\N	\N
宙返り	ちゅうがえり	{}	{"somersault; looping-the-loop"}	\N	\N	\N
中学	ちゅうがく	{}	{"middle school; junior high school"}	\N	\N	\N
中学校	ちゅうがっこう	{}	{"junior high school"}	\N	\N	\N
中間	ちゅうかん	{}	{"middle; midway; interim"}	\N	\N	\N
中継	ちゅうけい	{「中継放送」の略。競技場・野球場・劇場・国会・事件現場などの実況を、ある放送局がなかつぎして放送すること。「事故現場からーする」}	{"broadcast; relay; hook-up"}	\N	\N	\N
中古	ちゅうこ	{}	{"used; second-hand; old; Middle Ages"}	\N	\N	\N
忠告	ちゅうこく	{}	{"advice; warning"}	\N	\N	\N
中国人	ちゅうごくじん	{}	{"chinese (person)"}	\N	\N	\N
中止	ちゅうし	{}	{"suspension; stoppage; discontinuance; interruption"}	\N	\N	\N
忠実	ちゅうじつ	{}	{"fidelity; faithfulness"}	\N	\N	\N
駐車	ちゅうしゃ	{}	{"parking (e.g. car)"}	\N	\N	\N
注射	ちゅうしゃ	{注射器を使って薬液などを体内に注入すること。注入する部位によって皮下注射・筋肉注射・静脈注射などという。}	{injection}	\N	\N	\N
注釈	ちゅうしゃく	{}	{"annotation; notes; comments"}	\N	\N	\N
駐車場	ちゅうしゃじょう	{}	{"parking lot"}	\N	\N	\N
抽出	ちゅうしゅつ	{}	{extraction}	\N	\N	\N
中旬	ちゅうじゅん	{月の11日から20日までの10日間}	{"second third of a month"}	\N	\N	\N
中傷	ちゅうしょう	{}	{"slander; libel; defamation"}	\N	\N	\N
抽象	ちゅうしょう	{}	{abstract}	\N	\N	\N
抽象的	ちゅうしょうてき	{頭の中だけで考えていて、具体性に欠けるさま。反：具体的}	{abstract}	\N	\N	\N
昼食	ちゅうしょく	{}	{"lunch; midday meal"}	\N	\N	\N
大豆	だいず	{}	{"soy bean"}	\N	\N	\N
中心	ちゅうしん	{まんなか。中央。「町の―に公民館がある」「地域の―」}	{"center; core; heart; pivot; emphasis; balance"}	\N	\N	\N
注水	ちゅうすい	{}	{"pouring water; flooding"}	\N	\N	\N
中枢	ちゅうすう	{}	{"centre; pivot; mainstay; nucleus; backbone; central figure; pillar; key man"}	\N	\N	\N
中世	ちゅうせい	{}	{"Middle Ages; mediaeval times"}	\N	\N	\N
中性	ちゅうせい	{}	{"neuter gender; neutral (chem.); indifference; sterility"}	\N	\N	\N
抽選	ちゅうせん	{}	{"lottery; raffle; drawing (of lots)"}	\N	\N	\N
鋳造	ちゅうぞう	{}	{"casting (e.g. a statue)"}	\N	\N	\N
中断	ちゅうだん	{}	{"interruption; suspension; break"}	\N	\N	\N
中腹	ちゅうっぱら	{}	{"irritated; offended"}	\N	\N	\N
中途	ちゅうと	{}	{"in the middle; half-way"}	\N	\N	\N
中毒	ちゅうどく	{}	{poisoning}	\N	\N	\N
駐屯	ちゅうとん	{}	{"stationing; occupancy"}	\N	\N	\N
注入	ちゅうにゅう	{液体などをそそぎ入れること。つぎこむこと。「ライターにガスを―する」}	{injection}	\N	\N	\N
仲人	ちゅうにん	{}	{"go-between; matchmaker"}	\N	\N	\N
中年	ちゅうねん	{}	{middle-aged}	\N	\N	\N
昼飯	ちゅうはん	{}	{"lunch; midday meal"}	\N	\N	\N
注目	ちゅうもく	{}	{"notice; attention; observation"}	\N	\N	\N
注文	ちゅうもん	{}	{"order; request"}	\N	\N	\N
中立	ちゅうりつ	{}	{neutrality}	\N	\N	\N
駐輪場	ちゅうりんじょう	{}	{bike-parking}	\N	\N	\N
中和	ちゅうわ	{}	{"neutralize; counteract"}	\N	\N	\N
超	ちょう	{}	{"super-; ultra-; hyper-"}	\N	\N	\N
蝶	ちょう	{}	{butterfly}	\N	\N	\N
腸	ちょう	{}	{"guts; bowels; intestines"}	\N	\N	\N
庁	ちょう	{}	{"government office"}	\N	\N	\N
兢	ちょう	{}	{"cautious [hanzi]"}	\N	\N	\N
調印	ちょういん	{}	{"signature; sign; sealing"}	\N	\N	\N
懲役	ちょうえき	{自由刑の一。刑事施設に拘置して一定の労役に服させる刑罰。無期と有期の2種がある。}	{"penal servitude; imprisonment ((with hard labor))"}	\N	\N	\N
兆円	ちょうえん	{}	{"10^12 yen"}	\N	\N	\N
超過	ちょうか	{}	{"excess; being more than"}	\N	\N	\N
聴覚	ちょうかく	{}	{"the sense of hearing"}	\N	\N	\N
長官	ちょうかん	{}	{"chief; (government) secretary"}	\N	\N	\N
朝刊	ちょうかん	{日刊新聞で、朝に発行されるもの。<>夕刊。}	{"a morning edition [paper]"}	\N	\N	\N
長期	ちょうき	{}	{"long time period"}	\N	\N	\N
超級	ちょうきゅう	{スーパークラス}	{"super class"}	\N	\N	\N
聴講	ちょうこう	{}	{"lecture attendance; auditing"}	\N	\N	\N
彫刻	ちょうこく	{}	{"carving; engraving; sculpture"}	\N	\N	\N
調査	ちょうさ	{}	{"investigation; examination; inquiry; survey"}	\N	\N	\N
徴収	ちょうしゅう	{}	{"collection; levy"}	\N	\N	\N
聴衆	ちょうしゅう	{}	{"an audience"}	\N	\N	\N
長所	ちょうしょ	{}	{"strong point; merit; advantage"}	\N	\N	\N
長女	ちょうじょ	{}	{"eldest daughter"}	\N	\N	\N
頂上	ちょうじょう	{}	{"top; summit; peak"}	\N	\N	\N
聴診器	ちょうしんき	{}	{stethoscope}	\N	\N	\N
調整	ちょうせい	{}	{"regulation; adjustment; tuning"}	\N	\N	\N
潮汐	ちょうせき	{}	{tide}	\N	\N	\N
調節	ちょうせつ	{}	{"regulation; adjustment; control"}	\N	\N	\N
挑戦	ちょうせん	{}	{"challenge; defiance"}	\N	\N	\N
朝鮮	ちょうせん	{}	{"〔地域〕Korea; 〔朝鮮民主主義人民共和国〕the Democratic People's Republic of Korea"}	\N	\N	\N
彫塑	ちょうそ	{}	{sculpture}	\N	\N	\N
長大	ちょうだい	{}	{"very long; great length"}	\N	\N	\N
長短	ちょうたん	{}	{"length; long and short; advantages and disadvantages; pluses and minuses; strong and weak points; merits and demerits"}	\N	\N	\N
調停	ちょうてい	{}	{"arbitration; conciliation; mediation"}	\N	\N	\N
朝廷	ちょうてい	{天子が政治を行う所。廟堂 (びょうどう) 。朝堂。また、天子が政治を行う機関。}	{"the Imperial Court"}	\N	\N	\N
頂点	ちょうてん	{}	{"top; summit"}	\N	\N	\N
恰度	ちょうど	{}	{"just; right; exactly"}	\N	\N	\N
調子	ちょうし	{"1 活動するものの状態・ぐあい。「からだの―をくずす」「エンジンの―を見る」",音の高低のぐあい。また、音の速さのぐあい。リズム。拍子。「カラオケの―が合わない」「足で―をとる」}	{"〔具合〕condition; state of health","tune; tone; key; pitch; time; rhythm; vein; mood; way; manner; style; knack; strain; impetus; spur of the moment; trend"}	\N	\N	\N
丁度	ちょうど	{ある基準に、過不足なく一致するさま。きっかり。ぴったり。きっちり。}	{"exactly; precisely"}	\N	\N	\N
長男	ちょうなん	{}	{"eldest son"}	\N	\N	\N
長編	ちょうへん	{}	{"long (e.g. novel film)"}	\N	\N	\N
長方形	ちょうほうけい	{}	{"rectangle; oblong"}	\N	\N	\N
調味料	ちょうみりょう	{}	{"condiment; seasoning"}	\N	\N	\N
丁目	ちょうめ	{}	{"district of a town; city block (of irregular size)"}	\N	\N	\N
調理	ちょうり	{}	{cooking}	\N	\N	\N
長老	ちょうろう	{}	{elder}	\N	\N	\N
調和	ちょうわ	{}	{harmony}	\N	\N	\N
貯金	ちょきん	{}	{"(bank) savings"}	\N	\N	\N
直後	ちょくご	{}	{"immediately following"}	\N	\N	\N
直接	ちょくせつ	{}	{"direct; immediate; personal; firsthand"}	\N	\N	\N
直線	ちょくせん	{}	{"straight line"}	\N	\N	\N
直前	ちょくぜん	{}	{"just before"}	\N	\N	\N
直通	ちょくつう	{}	{"direct communication"}	\N	\N	\N
勅命	ちょくめい	{天皇の命令。勅諚 (ちょくじょう) 。みことのり。}	{"Imperial order"}	\N	\N	\N
直面	ちょくめん	{}	{confrontation}	\N	\N	\N
直流	ちょくりゅう	{}	{"direct current"}	\N	\N	\N
著作権	ちょさくけん	{著作者が自己の著作物の複製発刊翻訳興行上映放送などに関し，独占的に支配し利益をうける排他的な権利。}	{"a copyright; literary property"}	\N	\N	\N
著者	ちょしゃ	{}	{"author; writer"}	\N	\N	\N
著書	ちょしょ	{}	{"literary work; book"}	\N	\N	\N
貯蔵	ちょぞう	{}	{"storage; preservation"}	\N	\N	\N
貯蓄	ちょちく	{}	{savings}	\N	\N	\N
直角	ちょっかく	{}	{"right angle"}	\N	\N	\N
直感	ちょっかん	{}	{intuition}	\N	\N	\N
直径	ちょっけい	{}	{diameter}	\N	\N	\N
長寿	ちょうじゅ	{寿命の長いこと。長命。「―を保つ」}	{"a long life; longevity"}	\N	\N	\N
一寸	ちょっと	{}	{"(ateji) (adv int) (uk) just a minute; a short time; a while; just a little; somewhat; easily; readily; rather"}	\N	\N	\N
弔問	ちょうもん	{}	{"condolence call"}	\N	\N	\N
著名	ちょめい	{世間に名が知られていること。また、そのさま。有名。「―な芸術家」}	{"well-known; noted; celebrated"}	\N	\N	\N
散らかす	ちらかす	{}	{"scatter around; leave untidy"}	\N	\N	\N
散らかる	ちらかる	{}	{"be in disorder; lie scattered around"}	\N	\N	\N
散らす	ちらす	{}	{"scatter; disperse; distribute"}	\N	\N	\N
地理	ちり	{}	{"geography; geographical features"}	\N	\N	\N
塵紙	ちりがみ	{}	{"tissue paper; toilet paper"}	\N	\N	\N
塵取り	ちりとり	{}	{dustpan}	\N	\N	\N
治療	ちりょう	{}	{"medical treatment"}	\N	\N	\N
散る	ちる	{花や葉が、茎や枝から離れて落ちる。「花が―・る」}	{"〔ばらばらに落ちる〕to fall; scatter"}	\N	\N	\N
賃金	ちんぎん	{}	{wages}	\N	\N	\N
賃貸	ちんたい	{賃料を取り、物を相手方に貸すこと。賃貸し。「駐車場を―する」「―価格」「―マンション」⇔賃借。}	{"〜する 〔土地・建物・機械などを〕lease; 〔土地・建物などを〕rent; 〔家・部屋などを〕rent"}	\N	\N	\N
沈殿	ちんでん	{}	{"precipitation; settlement"}	\N	\N	\N
チンピラ	チンピラ	{不良少年少女。また、やくざなどの下っ端。「町の―」}	{"a hooligan; ((米)) a punk"}	\N	\N	\N
沈没	ちんぼつ	{}	{"sinking; foundering"}	\N	\N	\N
沈黙	ちんもく	{}	{"silence; reticence"}	\N	\N	\N
賃料	ちんりょう	{}	{rent}	\N	\N	\N
陳列	ちんれつ	{}	{"exhibition; display; show"}	\N	\N	\N
段々	だんだん	{いくつかの段のあるもの。また特に、階段。「石のーを上る」}	{"gradually; more and more; little by little; step by step"}	\N	\N	\N
大	だい	{}	{"great; large"}	\N	\N	\N
題	だい	{}	{"title; subject; theme; topic"}	\N	\N	\N
台	だい	{}	{"stand; rack; table; support"}	\N	\N	\N
第	だい	{}	{ordinal}	\N	\N	\N
第一	だいいち	{}	{"first; foremost; # 1"}	\N	\N	\N
大学	だいがく	{}	{university}	\N	\N	\N
大学院	だいがくいん	{}	{"graduate school"}	\N	\N	\N
大学生	だいがくせい	{}	{"university student"}	\N	\N	\N
代金	だいきん	{}	{"price; payment; cost; charge; the money; the bill"}	\N	\N	\N
大工	だいく	{}	{carpenter}	\N	\N	\N
大小	だいしょう	{}	{size}	\N	\N	\N
大丈夫	だいじょうぶ	{}	{"safe; all right; O.K."}	\N	\N	\N
大臣	だいじん	{}	{"cabinet minister"}	\N	\N	\N
大好き	だいすき	{}	{"very likeable; like very much"}	\N	\N	\N
大体	だいたい	{}	{"general; substantially; outline; main point"}	\N	\N	\N
代替	だいたい	{それに見合う他のもので代えること。かわり。「路面電車を廃止しバスで―する」「―地」}	{substitution}	\N	\N	\N
大胆	だいたん	{}	{"bold; daring; audacious"}	\N	\N	\N
大統領	だいとうりょう	{}	{"president; chief executive"}	\N	\N	\N
台所	だいどころ	{}	{kitchen}	\N	\N	\N
台無し	だいなし	{}	{"mess; spoiled; (come to) nothing"}	\N	\N	\N
代表	だいひょう	{}	{"representative; representation; delegation; type; example; model"}	\N	\N	\N
代表取締役	だいひょうとりしまりやく	{株式会社の取締役会の決議によって選任され、業務を執行し、かつ会社を代表する権限をもつ取締役。}	{"the representative director; the chief executive officer(略CEO); (英)the managing director"}	\N	\N	\N
大部分	だいぶぶん	{}	{"most part; greater part; majority"}	\N	\N	\N
大便	だいべん	{}	{"feces; excrement; shit"}	\N	\N	\N
代弁	だいべん	{}	{"pay by proxy; act for another; speak for another"}	\N	\N	\N
台本	だいほん	{}	{"libretto; scenario"}	\N	\N	\N
代目	だいめ	{助数詞。世代を数えるのに用いる。「二―」「六―菊五郎」}	{"(ordanilization) (2)nd; (3)rd; (4)th"}	\N	\N	\N
題名	だいめい	{}	{title}	\N	\N	\N
代名詞	だいめいし	{}	{pronoun}	\N	\N	\N
代用	だいよう	{}	{substitution}	\N	\N	\N
代理	だいり	{}	{"representation; agency; proxy; deputy; agent; attorney; substitute; alternate; acting (principal; etc.)"}	\N	\N	\N
楕円	だえん	{}	{ellipse}	\N	\N	\N
打開	だかい	{}	{"break in the deadlock"}	\N	\N	\N
駄菓子屋	だがしや	{}	{"old-style candy store"}	\N	\N	\N
妥協	だきょう	{}	{"compromise; giving in"}	\N	\N	\N
打撃	だげき	{}	{"blow; shock; strike; damage; batting (baseball)"}	\N	\N	\N
妥結	だけつ	{}	{agreement}	\N	\N	\N
駄作	ださく	{}	{"poor work; rubbish"}	\N	\N	\N
出汁	だし	{}	{buillion}	\N	\N	\N
出す	だす	{}	{"take out; put out; send"}	\N	\N	\N
惰性	だせい	{}	{"inertia; momentum; habit"}	\N	\N	\N
脱	だつ	{［語素］名詞に付いて、その境遇から抜け出す、の意を表す。「―サラリーマン」}	{datsu}	\N	\N	\N
脱出	だっしゅつ	{危険な場所や好ましくない状態から抜け出すこと。}	{"an escape"}	\N	\N	\N
脱する	だっする	{}	{"to escape from; to get out"}	\N	\N	\N
脱線	だっせん	{}	{"derailment; digression"}	\N	\N	\N
脱退	だったい	{}	{secession}	\N	\N	\N
妥当	だとう	{}	{"valid; proper; right; appropriate"}	\N	\N	\N
黙る	だまる	{}	{"be silent"}	\N	\N	\N
駄目	だめ	{}	{"no; no good; hopeless"}	\N	\N	\N
堕落	だらく	{賄賂など「政治の―」}	{"corruption; depravity"}	\N	\N	\N
だらけ	だらけ	{それのために汚れたり、それが一面に広がったりしているさまを表す。「血―」「どろ―」}	{"all over; full; smeared; riddled; everything (has gone wrong)"}	\N	\N	\N
怠い	だるい	{}	{"sluggish; feel heavy; languid; dull"}	\N	\N	\N
誰か	だれか	{}	{"someone; somebody"}	\N	\N	\N
壇	だん	{}	{"platform; podium; rostrum; (arch) mandala"}	\N	\N	\N
段	だん	{}	{"step; stair; flight of steps; grade; rank; level"}	\N	\N	\N
段階	だんかい	{}	{"gradation; grade; stage"}	\N	\N	\N
弾劾	だんがい	{}	{"impeachment (accusation of an official for unlawful activity)"}	\N	\N	\N
断崖	だんがい	{垂直に切り立ったがけ。きりぎし。「ー絶壁」}	{"cliff; pricipace"}	\N	\N	\N
断崖絶壁	だんがいぜっぺき	{切り立ったがけ。非常に危機的な状況のたとえとして用いられることもある。}	{"a precipitous cliff"}	\N	\N	\N
団結	だんけつ	{}	{"unity; union; combination"}	\N	\N	\N
断言	だんげん	{}	{"declaration; affirmation"}	\N	\N	\N
男子	だんし	{}	{"youth; young man"}	\N	\N	\N
断水	だんすい	{}	{"water outage"}	\N	\N	\N
男性	だんせい	{}	{male}	\N	\N	\N
断然	だんぜん	{}	{"firmly; absolutely; definitely"}	\N	\N	\N
同	どう	{}	{"the same; the said; ibid."}	\N	\N	\N
胴	どう	{}	{"trunk; body; frame"}	\N	\N	\N
大分	だいぶ	{}	{"very; many; a lot"}	\N	\N	\N
大分	だいぶん	{}	{"considerably; greatly; a lot"}	\N	\N	\N
丈	だけ	{}	{"only; just; as"}	\N	\N	\N
団体	だんたい	{ある目的のために、人々が集まって一つのまとまりとなったもの。「―で見学する」「―旅行」「―割引」}	{"〔人の集まり〕a group; 〔一行〕a party; 〔一団〕a body"}	\N	\N	\N
団地	だんち	{}	{"multi-unit apartments"}	\N	\N	\N
断定	だんてい	{}	{"conclusion; decision"}	\N	\N	\N
旦那	だんな	{}	{"master (of house); husband (informal)"}	\N	\N	\N
暖房	だんぼう	{}	{heating}	\N	\N	\N
断面	だんめん	{}	{"cross section"}	\N	\N	\N
弾力	だんりょく	{}	{"elasticity; flexibility"}	\N	\N	\N
出合い	であい	{}	{"an encounter"}	\N	\N	\N
出会い	であい	{思いがけなくあうこと。めぐりあい。「師との運命的な＿」「一冊の本との＿」}	{"meeting; rendezvous; encounter"}	\N	\N	\N
出会う	であう	{ある場所でいっしょになる。「本流と支流が―・う地点」}	{"to hold a rendezvous; to have a date"}	\N	\N	\N
出合う	であう	{}	{"to meet by chance; to come across; to happen to encounter; to hold a rendezvous; to have a date"}	\N	\N	\N
出逢う	であう	{人・事件などに偶然に行きあう。「街角で旧友と―・う」「帰宅途中に事故に―・う」}	{"to meet by chance; happen to encounter"}	\N	\N	\N
出入り	でいり	{}	{"in and out; coming and going; free association; income and expenditure; debits and credit"}	\N	\N	\N
出入り口	でいりぐち	{}	{"exit and entrance"}	\N	\N	\N
出来る	できる	{}	{"〔可能である〕can [be able to](do); (事が主語で) be possible"}	\N	\N	\N
出来上がり	できあがり	{}	{"finish; completion; ready; made for; cut out"}	\N	\N	\N
出来上がる	できあがる	{}	{"be finished; be ready; by definition; be very drunk"}	\N	\N	\N
出来事	できごと	{}	{"incident; affair; happening; event"}	\N	\N	\N
出来物	できもの	{}	{"able man; tumour; growth; boil; ulcer; abcess; rash; pimple"}	\N	\N	\N
出切る	できる	{}	{"to be out of; to have no more at hand"}	\N	\N	\N
出来るだけ	できるだけ	{}	{"if at all possible"}	\N	\N	\N
出口	でぐち	{}	{"exit; gateway; way out; outlet; leak; vent"}	\N	\N	\N
出くわす	でくわす	{}	{"to happen to meet; to come across"}	\N	\N	\N
凸凹	でこぼこ	{}	{"unevenness; roughness; ruggedness"}	\N	\N	\N
出鱈目	でたらめ	{}	{"irresponsible utterance; nonsense; nonsensical; random; haphazard; unsystematic"}	\N	\N	\N
出直し	でなおし	{}	{"adjustment; touch up"}	\N	\N	\N
出迎え	でむかえ	{}	{"meeting; reception"}	\N	\N	\N
出迎える	でむかえる	{}	{"to meet; to greet"}	\N	\N	\N
出る	でる	{}	{"appear; come forth; leave"}	\N	\N	\N
田園	でんえん	{}	{"country; rural districts"}	\N	\N	\N
伝記	でんき	{}	{"biography; life story"}	\N	\N	\N
電気	でんき	{}	{"electricity; (electric) light"}	\N	\N	\N
電球	でんきゅう	{}	{"light bulb"}	\N	\N	\N
電源	でんげん	{}	{"source of electricity; power (button on TV etc.)"}	\N	\N	\N
伝言	でんごん	{人に頼んで、相手に用件を伝えること。また、その言葉。ことづて。ことづけ。「彼には妹からーしてもらう」}	{"a message; word"}	\N	\N	\N
電子	でんし	{}	{"electron; (as a prefix) electronic; electronics"}	\N	\N	\N
電子工学	でんしこうがく	{電子伝導、およびその現象を応用する装置・技術についての学問。エレクトロニクス。}	{"electrical engineering; electronics"}	\N	\N	\N
電車	でんしゃ	{}	{"electric train"}	\N	\N	\N
伝承	でんしょう	{伝え聞くこと。人づてに聞くこと。}	{"transmission; 〔物〕folklore; 〔口伝〕(an) oral tradition; a tradition"}	\N	\N	\N
伝説	でんせつ	{}	{"tradition; legend; folklore"}	\N	\N	\N
伝染	でんせん	{}	{contagion}	\N	\N	\N
電線	でんせん	{}	{"electric line"}	\N	\N	\N
電卓	でんたく	{}	{calculator}	\N	\N	\N
伝達	でんたつ	{}	{"transmission (e.g. news); communication; delivery"}	\N	\N	\N
電池	でんち	{}	{battery}	\N	\N	\N
電柱	でんちゅう	{}	{"telephone pole; telegraph pole; lightpole"}	\N	\N	\N
点滴	てんてき	{}	{"hospital drip"}	\N	\N	\N
電灯	でんとう	{}	{light}	\N	\N	\N
伝統	でんとう	{}	{"tradition; convention"}	\N	\N	\N
電波	でんぱ	{}	{"electro-magnetic wave"}	\N	\N	\N
電報	でんぽう	{}	{telegram}	\N	\N	\N
伝来	でんらい	{}	{"ancestral; hereditary; imported; transmitted; handed down"}	\N	\N	\N
電流	でんりゅう	{}	{"electric current"}	\N	\N	\N
電力	でんりょく	{}	{"electric power"}	\N	\N	\N
電話	でんわ	{}	{telephone}	\N	\N	\N
出掛ける	でかける	{}	{"depart; go out (e.g. on an excursion or outing); set out; start"}	\N	{出かける}	\N
働	どう	{}	{"work; labor"}	\N	\N	\N
同意	どうい	{}	{"agreement; consent; same meaning; same opinion; approval"}	\N	\N	\N
同一	どういつ	{}	{"identity; sameness; similarity; equality; fairness"}	\N	\N	\N
動員	どういん	{}	{mobilization}	\N	\N	\N
同格	どうかく	{}	{"the same rank; equality; apposition"}	\N	\N	\N
同感	どうかん	{}	{"agreement; same opinion; same feeling; sympathy; concurrence"}	\N	\N	\N
動機	どうき	{}	{"motive; incentive"}	\N	\N	\N
同期	どうき	{}	{"sync (on a computer)"}	\N	\N	\N
同級	どうきゅう	{}	{"the same grade; same class"}	\N	\N	\N
同居	どうきょ	{}	{"living together"}	\N	\N	\N
道具	どうぐ	{}	{tool}	\N	\N	\N
洞窟	どうくつ	{}	{"cave; cavern"}	\N	\N	\N
動向	どうこう	{}	{"trend; tendency; movement; attitude"}	\N	\N	\N
同行	どうこう	{一緒に連れ立って行くこと。主たる人に付き従って行くこと。また、その人。同道。「警察へ―を求める」「社長に―する」}	{"accompany; go with; party (of three);"}	\N	\N	\N
動作	どうさ	{}	{"action; movements; motions; bearing; behaviour; manners"}	\N	\N	\N
洞察	どうさつ	{}	{"insight; discernment"}	\N	\N	\N
同志	どうし	{}	{"same mind; comrade; kindred soul"}	\N	\N	\N
同士	どうし	{}	{"fellow; companion; comrade"}	\N	\N	\N
動詞	どうし	{}	{verb}	\N	\N	\N
同時	どうじ	{}	{"simultaneous(ly); concurrent; same time; synchronous"}	\N	\N	\N
如何しても	どうしても	{}	{"by all means; at any cost; no matter what; after all; in the long run; cravingly; at any rate; surely"}	\N	\N	\N
同情	どうじょう	{}	{"sympathy; compassion; sympathize; pity; feel for"}	\N	\N	\N
道場	どうじょう	{}	{"dojo; hall used for martial arts training; mandala"}	\N	\N	\N
同じる	どうじる	{「どう（同）ずる」（サ変）の上一段化。「政府案には―・じない意向だ」}	{"concede; admit; allow"}	\N	\N	\N
どうせ	どうせ	{経過がどうであろうと、結果は明らかだと認める気持ちを表す語。いずれにせよ。結局は。}	{"anyhow; after all"}	\N	\N	\N
同級生	どうきゅうせい	{同性を性愛の対象とすること。また、そのような関係。}	{homosexuality}	\N	\N	\N
銅線	どうせん	{}	{"copper cable"}	\N	\N	\N
どうぞ宜しく	どうぞよろしく	{}	{"pleased to meet you"}	\N	\N	\N
胴体	どうたい	{}	{"body; torso"}	\N	\N	\N
撞着語法	どうちゃくごほう	{つじつまが合わないこと。矛盾。「話の前後が―する」「自家―」}	{"oxymoron; contradictional expression"}	\N	\N	\N
同調	どうちょう	{}	{"sympathy; agree with; alignment; tuning"}	\N	\N	\N
動的	どうてき	{}	{"dynamic; kinetic"}	\N	\N	\N
同等	どうとう	{}	{"equality; equal; same rights; same rank"}	\N	\N	\N
道徳	どうとく	{}	{morals}	\N	\N	\N
導入	どうにゅう	{}	{"introduction; bringing in; leading in"}	\N	\N	\N
同伴	どうはん	{}	{companion}	\N	\N	\N
同封	どうふう	{}	{"enclosure (e.g. in a letter)"}	\N	\N	\N
動物	どうぶつ	{}	{animal}	\N	\N	\N
動物園	どうぶつえん	{}	{zoo}	\N	\N	\N
同盟	どうめい	{}	{"alliance; union; league"}	\N	\N	\N
動揺	どうよう	{}	{"disturbance; unrest; shaking; trembling; pitching; rolling; oscillation; agitation; excitement; commotion"}	\N	\N	\N
童謡	どうよう	{}	{"nursery rhyme; children's song"}	\N	\N	\N
同様	どうよう	{同じであること}	{"same; like"}	\N	\N	\N
同僚	どうりょう	{}	{"coworker; colleague; associate"}	\N	\N	\N
動力	どうりょく	{}	{"power; motive power; dynamic force"}	\N	\N	\N
道路	どうろ	{}	{"road; highway"}	\N	\N	\N
童話	どうわ	{}	{fairy-tale}	\N	\N	\N
退かす	どかす	{物や人を他の場所へ移して場所をあける。のかせる。「障害物を―・す」}	{"to move (e.g. a heavy stone/car)"}	\N	\N	\N
毒	どく	{}	{poison}	\N	\N	\N
独裁	どくさい	{}	{"dictatorship; despotism"}	\N	\N	\N
毒死	どくし	{毒薬によって死ぬこと。}	{"poisoning death"}	\N	\N	\N
読者	どくしゃ	{}	{reader}	\N	\N	\N
読書	どくしょ	{本を読むこと。}	{reading}	\N	\N	\N
独身	どくしん	{}	{"bachelorhood; single; unmarried; celibate"}	\N	\N	\N
独占	どくせん	{}	{monopoly}	\N	\N	\N
独創	どくそう	{}	{originality}	\N	\N	\N
原典	げんてん	{}	{"original (text)"}	\N	\N	\N
独自	どくじ	{他とは関係なく自分ひとりであること。また、そのさま。「―に開発した技術」}	{"original; peculiar; characteristic"}	\N	\N	\N
独房	どくぼう	{刑務所や拘置所で、収容者を一人だけ入れておく居室。}	{"a (solitary) cell"}	\N	\N	\N
独立	どくりつ	{}	{"independence; self-support"}	\N	\N	\N
髑髏	どくろ	{風雨にさらされて肉が落ち、むきだしになった頭蓋骨。されこうべ。しゃれこうべ。}	{"a skull"}	\N	\N	\N
土壌	どじょう	{地殻の最上部にある、岩石の風化物に動植物の遺体あるいはその分解物が加わったもの。地表からの深さはせいぜい1、2メートルまで。つち。}	{soil⇒つち(土)}	\N	\N	\N
何方	どちら	{}	{"which; who"}	\N	\N	\N
土手	どて	{}	{"embankment; bank"}	\N	\N	\N
怒鳴る	どなる	{}	{"to shout; to yell"}	\N	\N	\N
何の	どの	{}	{"which; what"}	\N	\N	\N
土俵	どひょう	{}	{arena}	\N	\N	\N
土木	どぼく	{}	{"public works"}	\N	\N	\N
土曜	どよう	{}	{Saturday}	\N	\N	\N
土曜日	どようび	{}	{Saturday}	\N	\N	\N
泥	どろ	{}	{mud}	\N	\N	\N
努力	どりょく	{ある目的のために力を尽くして励むこと。「ーが実る」「たゆまずーする」「ー家」}	{"great effort; exertion; endeavour; effort"}	\N	\N	\N
何れ位	どれくらい	{}	{"to what degree; (nobody knows) how (sad I am); how (tall he is)"}	\N	\N	\N
どれだけ	どれだけ	{⇒どれくらい(何れ位)}	{"to what degree; (nobody knows) how (sad I am); how (tall he is)"}	\N	\N	\N
泥沼	どろぬま	{}	{"quagmire; march"}	\N	\N	\N
泥棒	どろぼう	{}	{robber}	\N	\N	\N
度忘れ	どわすれ	{}	{"lapse of memory; forget for a moment"}	\N	\N	\N
鈍感	どんかん	{}	{"thickheadedness; stolidity"}	\N	\N	\N
丼	どんぶり	{}	{"porcelain bowl; bowl of rice with food on top"}	\N	\N	\N
貪欲	どんよく	{}	{"gluttonous; ravenous; insatiable"}	\N	\N	\N
永遠	えいえん	{いつまでも果てしなく続くこと。時間を超えて存在すること。永久。「＿に残る名曲」「＿のスター」}	{"〔永久〕eternity; permanence; 〔不滅〕immortality"}	\N	\N	\N
永久	えいきゅう	{いつまでも限りなく続くこと。永遠。「ーに平和を守る」「ー不変」}	{"eternity; permanence"}	\N	\N	\N
襟を正す	えりをただす	{自己の乱れた衣服や姿勢を整える}	{"straighten up; shape up"}	\N	\N	\N
援交	えんこう	{金銭の援助を伴う交際。主に未成年の女子が行う売春をいう俗語。}	{"compensated dating; prostitute"}	\N	\N	\N
絵	え	{}	{"picture; drawing; painting; sketch"}	\N	\N	\N
重	え	{}	{"-fold; -ply"}	\N	\N	\N
映画	えいが	{}	{"movie; film"}	\N	\N	\N
映画館	えいがかん	{}	{"movie theatre (theater); cinema"}	\N	\N	\N
影響	えいきょう	{}	{"influence; effect"}	\N	\N	\N
営業	えいぎょう	{}	{"business; trade; sales; operations"}	\N	\N	\N
英語	えいご	{}	{"the English language"}	\N	\N	\N
英字	えいじ	{}	{"English letter (character)"}	\N	\N	\N
映写	えいしゃ	{}	{projection}	\N	\N	\N
衛生	えいせい	{}	{"health; hygiene; sanitation; medical"}	\N	\N	\N
衛星	えいせい	{}	{satellite}	\N	\N	\N
映像	えいぞう	{}	{"reflection; image"}	\N	\N	\N
英文	えいぶん	{}	{"sentence in English"}	\N	\N	\N
英雄	えいゆう	{}	{"hero; great man"}	\N	\N	\N
栄養	えいよう	{}	{"nutrition; nourishment"}	\N	\N	\N
英和	えいわ	{}	{"English-Japanese (e.g. dictionary)"}	\N	\N	\N
笑顔	えがお	{}	{"smiling face"}	\N	\N	\N
会	え	{}	{understanding}	\N	\N	\N
柄	え	{}	{"handle; grip"}	\N	\N	\N
退ける	どける	{}	{"remove; take away; dislodge; put something out of the way"}	\N	\N	\N
土産	どさん	{}	{"product of the land"}	\N	\N	\N
何れ	どれ	{}	{"well; now; let me see; which (of three or more)"}	\N	\N	\N
独特	どくとく	{そのものだけが特別にもっていること。また、そのさま。「―な（の）雰囲気」}	{"peculiarity; uniqueness; characteristic"}	\N	{独得}	\N
何々	どれどれ	{}	{"which (emphatic)"}	\N	{何何}	\N
液	えき	{}	{"liquid; fluid"}	\N	\N	\N
駅	えき	{}	{station}	\N	\N	\N
液体	えきたい	{}	{"liquid; fluid"}	\N	\N	\N
餌	えさ	{}	{"bait; feed"}	\N	\N	\N
枝	えだ	{}	{branch}	\N	\N	\N
枝豆	えだまめ	{大豆を未熟なうちに茎ごと取ったもの。さやのままゆでて食べる。月見豆。}	{"green soybeans"}	\N	\N	\N
謁見	えっけん	{}	{audience}	\N	\N	\N
閲覧	えつらん	{}	{"inspection; reading"}	\N	\N	\N
夷	えびす	{}	{"barbarian; savage"}	\N	\N	\N
絵の具	えのぐ	{}	{"colors; paints"}	\N	\N	\N
絵巻	えまき	{}	{"picture scroll"}	\N	\N	\N
獲物	えもの	{}	{"game; spoils; trophy"}	\N	\N	\N
偉い	えらい	{}	{"great; celebrated; eminent; terrible; awful; famous; remarkable; excellent"}	\N	\N	\N
選ぶ	えらぶ	{}	{choose}	\N	\N	\N
襟	えり	{}	{"neck; collar; lapel; neckband"}	\N	\N	\N
宴会	えんかい	{}	{"party; banquet"}	\N	\N	\N
円滑	えんかつ	{}	{"harmony; smoothness"}	\N	\N	\N
縁側	えんがわ	{}	{"veranda; porch; balcony; open corridor"}	\N	\N	\N
沿岸	えんがん	{}	{"coast; shore"}	\N	\N	\N
延期	えんき	{}	{"postponement; adjournment"}	\N	\N	\N
演技	えんぎ	{}	{"acting; performance"}	\N	\N	\N
婉曲	えんきょく	{}	{"euphemistic; circumlocution; roundabout; indirect; insinuating"}	\N	\N	\N
円空	えんくう	{［1632?～1695］江戸初期の臨済宗の僧。美濃の人。生涯に12万体の造像を発願し、諸国を遍歴、布教しながら、円空仏とよばれる仏像を多数制作した。}	{enkuu}	\N	\N	\N
園芸	えんげい	{}	{"horticulture; gardening"}	\N	\N	\N
演劇	えんげき	{}	{"theatre play"}	\N	\N	\N
円周	えんしゅう	{}	{circumference}	\N	\N	\N
演習	えんしゅう	{}	{"practice; exercises; manoeuvers"}	\N	\N	\N
演出	えんしゅつ	{}	{"production (e.g. play); direction"}	\N	\N	\N
援助	えんじょ	{}	{"assistance; aid; support"}	\N	\N	\N
炎症	えんしょう	{}	{"inflammation (e.g. in a finger)"}	\N	\N	\N
演じる	えんじる	{}	{"to perform (a play); to play (a part); to act (a part); to commit (a blunder)"}	\N	\N	\N
円錐	えんすい	{コーン。円の平面の外にある一定点から円周上に伸ばした線分が円周上を1周してつくる曲面と、もとの円とによって囲まれる立体。直円錐と斜円錐がある。円錐体。}	{"a (circular) cone"}	\N	\N	\N
演ずる	えんずる	{}	{"to perform; to play"}	\N	\N	\N
演説	えんぜつ	{}	{"speech; address"}	\N	\N	\N
沿線	えんせん	{}	{"along railway line"}	\N	\N	\N
演奏	えんそう	{}	{"musical performance"}	\N	\N	\N
遠足	えんそく	{}	{"trip; hike; picnic"}	\N	\N	\N
縁談	えんだん	{}	{"marriage proposal; engagement"}	\N	\N	\N
延長	えんちょう	{}	{"extension; elongation; prolongation; lengthening"}	\N	\N	\N
煙突	えんとつ	{}	{chimney}	\N	\N	\N
鉛筆	えんぴつ	{}	{pencil}	\N	\N	\N
遠方	えんぽう	{}	{"long way; distant place"}	\N	\N	\N
円満	えんまん	{}	{"perfection; harmony; peace; smoothness; completeness; satisfaction; integrity"}	\N	\N	\N
遠慮	えんりょ	{}	{"diffidence; restraint; reserve"}	\N	\N	\N
害	がい	{}	{"injury; harm; damage; evil influence"}	\N	\N	\N
外貨	がいか	{}	{"imported goods; foreign money"}	\N	\N	\N
外郭団体	がいかくだんたい	{}	{"an affiliated organization"}	\N	\N	\N
外観	がいかん	{}	{"appearance; exterior; facade"}	\N	\N	\N
外交	がいこう	{外国との交渉・交際。国家相互の関係。ディプロマシー。}	{diplomacy}	\N	\N	\N
外国	がいこく	{}	{"foreign country"}	\N	\N	\N
外国人	がいこくじん	{}	{foreigner}	\N	\N	\N
語彙	ごい	{}	{"vocabulary; glossary"}	\N	\N	\N
街	がい	{}	{"~street; ~quarters"}	\N	\N	\N
園地	えんち	{自然公園で、公園施設を設けた区域。}	{"set (nature) park (in a designated area)"}	\N	{苑地}	\N
外出	がいしゅつ	{自宅や勤め先などから、よそへ出かけること。「急用でーする」}	{"go outside;"}	\N	\N	\N
外相	がいしょう	{}	{"Foreign Minister"}	\N	\N	\N
外国人登録証	がいこくじんとうろくしょう	{外国人登録法に基づいて、日本に在留する外国人に交付された証明書。市区町村が発行し、常時携帯が義務づけられていた。平成24年（2012）同法廃止に伴い、法務省が交付する在留カードと特別永住者証明書に切り替わった。}	{"alien registration"}	\N	\N	\N
害する	がいする	{}	{"to injure; to damage; to harm; to kill; to hinder"}	\N	\N	\N
概説	がいせつ	{}	{"general statement; outline"}	\N	\N	\N
街頭	がいとう	{}	{"in the street"}	\N	\N	\N
該当	がいとう	{}	{"corresponding; answering to; coming under"}	\N	\N	\N
概念	がいねん	{}	{"general idea; concept; notion"}	\N	\N	\N
外部	がいぶ	{}	{"the outside; external"}	\N	\N	\N
概要	がいよう	{全体の要点をとりまとめたもの。大要。あらまし。「事件の―」}	{"an outline; a summary ((of))⇒がいりゃく(概略)"}	\N	\N	\N
外来	がいらい	{}	{"imported; outpatient clinic"}	\N	\N	\N
概略	がいりゃく	{}	{"outline; summary; gist; in brief"}	\N	\N	\N
概論	がいろん	{}	{"introduction; outline; general remarks"}	\N	\N	\N
画家	がか	{}	{"painter; artist"}	\N	\N	\N
学	がく	{}	{"learning; scholarship; erudition; knowledge"}	\N	\N	\N
学芸	がくげい	{}	{"arts and sciences; liberal arts"}	\N	\N	\N
学士	がくし	{}	{"university graduate"}	\N	\N	\N
学者	がくしゃ	{}	{scholar}	\N	\N	\N
学習	がくしゅう	{}	{"study; learning"}	\N	\N	\N
学術	がくじゅつ	{}	{"science; learning; scholarship"}	\N	\N	\N
学生	がくせい	{}	{student}	\N	\N	\N
学説	がくせつ	{}	{theory}	\N	\N	\N
学年	がくねん	{}	{"year in school; grade in school"}	\N	\N	\N
楽譜	がくふ	{}	{"score (music)"}	\N	\N	\N
学部	がくぶ	{}	{"department of a university; undergraduate"}	\N	\N	\N
額縁	がくぶち	{}	{frame}	\N	\N	\N
学問	がくもん	{}	{"scholarship; study; learning"}	\N	\N	\N
学力	がくりょく	{}	{"scholarship; knowledge; literary ability"}	\N	\N	\N
学歴	がくれき	{}	{"academic background"}	\N	\N	\N
崖	がけ	{}	{cliff}	\N	\N	\N
雅致	がち	{}	{"artistry; good taste; elegance; grace"}	\N	\N	\N
学科	がっか	{科目。課程。}	{department}	\N	\N	\N
学会	がっかい	{}	{"scientific society; academic meeting"}	\N	\N	\N
がっかり	がっかり	{元気を出せ・失望する様子}	{disappointed}	\N	\N	\N
楽器	がっき	{}	{"musical instrument"}	\N	\N	\N
学期	がっき	{}	{"school term"}	\N	\N	\N
学級	がっきゅう	{}	{"grade in school"}	\N	\N	\N
学校	がっこう	{}	{school}	\N	\N	\N
合唱	がっしょう	{}	{"chorus; singing in a chorus"}	\N	\N	\N
合致	がっち	{}	{"agreement; concurrence; conforming to"}	\N	\N	\N
合併	がっぺい	{}	{"combination; union; amalgamation; consolidation; merger; coalition; fusion; annexation; affiliation; incorporation"}	\N	\N	\N
我慢	がまん	{}	{"patience; endurance; perseverance; tolerance; self-control; self-denial"}	\N	\N	\N
画面	がめん	{描かれている絵の表面。}	{"〔映画・テレビなどの〕a screen"}	\N	\N	\N
硝子	がらす	{}	{glass}	\N	\N	\N
眼科	がんか	{}	{ophthalmology}	\N	\N	\N
眼球	がんきゅう	{}	{eyeball}	\N	\N	\N
頑固	がんこ	{}	{"stubbornness; obstinacy"}	\N	\N	\N
願書	がんしょ	{}	{"written application or petition"}	\N	\N	\N
頑丈	がんじょう	{}	{"solid; firm; stout; burly; strong; sturdy"}	\N	\N	\N
岩石	がんせき	{}	{rock}	\N	\N	\N
元年	がんねん	{}	{"first year (of a specific reign)"}	\N	\N	\N
原点	げんてん	{}	{"origin (coordinates); starting point"}	\N	\N	\N
額	がく	{}	{"picture (framed); amount (of money)"}	\N	\N	\N
月日	がっぴ	{}	{"(the) date"}	\N	\N	\N
柄	がら	{}	{"pattern; design"}	\N	\N	\N
側	がわ	{}	{"side; row; surroundings; part; (watch) case"}	\N	\N	\N
眼鏡	がんきょう	{}	{"spectacles; glasses"}	\N	\N	\N
絡み	がらみ	{密接に関連していること。また、入り組んだ関係。「予算との―があって実現は難しい」→がらみ}	{"about / concerning / related to;"}	\N	{搦,搦み}	\N
頑張る	がんばる	{困難にめげないで我慢してやり抜く。「一致団結して―・る」}	{"〔踏ん張る〕hold out; hang on"}	\N	\N	\N
贋物	がんぶつ	{}	{"imitation; counterfeit; forgery; sham"}	\N	\N	\N
元来	がんらい	{}	{"originally; primarily; essentially; logically; naturally"}	\N	\N	\N
芸術	げいじゅつ	{}	{"fine art; the arts"}	\N	\N	\N
芸能	げいのう	{}	{"public entertainment; accomplishments; attainments"}	\N	\N	\N
迎賓館	げいひんかん	{}	{"reception hall"}	\N	\N	\N
外科	げか	{}	{"surgical department"}	\N	\N	\N
劇	げき	{}	{"performance; play"}	\N	\N	\N
激辛	げきから	{}	{"spicy; hot (spice)"}	\N	\N	\N
劇作	げきさく	{演劇の脚本をつくること。また、その脚本。}	{"play writing"}	\N	\N	\N
劇作家	げきさく	{演劇の脚本や戯曲を書くことを職業とする人。}	{"a playwright; a dramatist"}	\N	\N	\N
劇場	げきじょう	{}	{theatre}	\N	\N	\N
激増	げきぞう	{}	{"sudden increase"}	\N	\N	\N
劇団	げきだん	{}	{"troupe; theatrical company"}	\N	\N	\N
激励	げきれい	{}	{encouragement}	\N	\N	\N
下車	げしゃ	{}	{"alighting; getting off"}	\N	\N	\N
下宿	げしゅく	{}	{lodge}	\N	\N	\N
下旬	げじゅん	{月の21日から末日までの間}	{"last third of month"}	\N	\N	\N
下水	げすい	{}	{"drainage; sewage; ditch; gutter"}	\N	\N	\N
下駄	げた	{}	{"wooden clogs"}	\N	\N	\N
月下	げっか	{}	{"late; under the moon; in the moonlight"}	\N	\N	\N
月給	げっきゅう	{}	{"monthly salary"}	\N	\N	\N
月謝	げっしゃ	{}	{"monthly tuition fee"}	\N	\N	\N
月賦	げっぷ	{}	{"monthly installment"}	\N	\N	\N
月末	げつまつ	{}	{"end of the month"}	\N	\N	\N
月曜	げつよう	{}	{Monday}	\N	\N	\N
月曜日	げつようび	{}	{Monday}	\N	\N	\N
下痢	げり	{}	{diarrhoea}	\N	\N	\N
原因	げんいん	{ある物事や、ある状態・変化を引き起こすもとになること。また、その事柄。「失敗の―をつきとめる」「不注意に―する事故」「―不明の病気」⇔結果。}	{cause}	\N	\N	\N
限界	げんかい	{}	{"limit; bound"}	\N	\N	\N
弦楽	げんがく	{}	{"(musical instrument) string"}	\N	\N	\N
玄関	げんかん	{}	{"entranceway; entry hall"}	\N	\N	\N
元気	げんき	{}	{"health(y); robust; vigor; energy; vitality; vim; stamina; spirit; courage; pep"}	\N	\N	\N
現金	げんきん	{}	{"cash; ready money; mercenary; self-interested"}	\N	\N	\N
原形	げんけい	{}	{"original form; base form"}	\N	\N	\N
言語	げんご	{}	{language}	\N	\N	\N
原稿	げんこう	{}	{"manuscript; copy"}	\N	\N	\N
現行	げんこう	{}	{"present; current; in operation"}	\N	\N	\N
元号	げんごう	{}	{"period (of e.g. power)"}	\N	\N	\N
現在	げんざい	{}	{"present; up to now; nowadays; modern times; current"}	\N	\N	\N
原作	げんさく	{}	{"original work"}	\N	\N	\N
原産	げんさん	{最初に産出したこと。また、したもの。「ヒマラヤ―の品種」}	{"place of origin; habitat"}	\N	\N	\N
原子	げんし	{}	{atom}	\N	\N	\N
原始	げんし	{}	{"origin; primeval"}	\N	\N	\N
現実	げんじつ	{}	{reality}	\N	\N	\N
現時点	げんじてん	{現在の時点。今 (いま) 現在。「―でははっきりしたことは言えない」}	{"〜で at present; at this time [stage]"}	\N	\N	\N
元首	げんしゅ	{}	{"ruler; sovereign"}	\N	\N	\N
厳重	げんじゅう	{}	{"strict; severe; firm; strong; secure; rigour"}	\N	\N	\N
原書	げんしょ	{}	{"original document"}	\N	\N	\N
減少	げんしょう	{}	{"decrease; reduction; decline"}	\N	\N	\N
現象	げんしょう	{}	{phenomenon}	\N	\N	\N
現状	げんじょう	{}	{"present condition; existing state; status quo"}	\N	\N	\N
現職者	げんしょくしゃ	{}	{"an incumbent (the holder of an office or post.)"}	\N	\N	\N
元帥	げんすい	{}	{"marshal; admiral"}	\N	\N	\N
元素	げんそ	{}	{"chemical element"}	\N	\N	\N
現像	げんぞう	{}	{"developing (film)"}	\N	\N	\N
原則	げんそく	{}	{"principle; general rule"}	\N	\N	\N
現代	げんだい	{}	{"nowadays; modern times; present-day"}	\N	\N	\N
現地	げんち	{}	{"actual place; local"}	\N	\N	\N
限定	げんてい	{}	{"limit; restriction"}	\N	\N	\N
現職	げんしょく	{現在、ある職務に就いていること。また、その職業や職務。「―の警官」}	{"one's (present) post [office]"}	\N	\N	\N
減点	げんてん	{}	{"subtract; give a demerit"}	\N	\N	\N
限度	げんど	{}	{"limit; bounds"}	\N	\N	\N
現に	げんに	{}	{"actually; really"}	\N	\N	\N
原爆	げんばく	{}	{"atomic bomb"}	\N	\N	\N
原発	げんぱつ	{原子炉で発生した熱エネルギーで蒸気をつくり、タービン発電機を運転して発電する方法。原発 (げんぱつ) 。}	{"「原子力発電」「原子力発電所」の略。nuclear power"}	\N	\N	\N
原文	げんぶん	{}	{"the text; original"}	\N	\N	\N
玄米	げんまい	{}	{"brown rice"}	\N	\N	\N
厳密	げんみつ	{}	{"strict; close"}	\N	\N	\N
原油	げんゆ	{}	{"crude oil"}	\N	\N	\N
原理	げんり	{}	{"principle; theory; fundamental truth"}	\N	\N	\N
原料	げんりょう	{}	{"raw materials"}	\N	\N	\N
言論	げんろん	{}	{discussion}	\N	\N	\N
疑惑	ぎわく	{本当かどうか、不正があるのではないかなどと疑いをもつこと。また、その気持ち。疑い。ダウト「ーの目で見る」}	{doubt}	\N	\N	\N
議案	ぎあん	{}	{"legislative bill"}	\N	\N	\N
議員	ぎいん	{}	{"member of the Diet; congress or parliament"}	\N	\N	\N
議会	ぎかい	{}	{"Diet; congress; parliament"}	\N	\N	\N
戯曲	ぎきょく	{}	{"play; drama"}	\N	\N	\N
議決	ぎけつ	{}	{"resolution; decision; vote"}	\N	\N	\N
技師	ぎし	{}	{"engineer; technician"}	\N	\N	\N
儀式	ぎしき	{}	{"ceremony; rite; ritual; service"}	\N	\N	\N
議事堂	ぎじどう	{}	{"Diet building"}	\N	\N	\N
技術	ぎじゅつ	{}	{technique}	\N	\N	\N
犠牲	ぎせい	{}	{sacrifice}	\N	\N	\N
偽造	ぎぞう	{}	{"forgery; falsification; fabrication; counterfeiting"}	\N	\N	\N
議題	ぎだい	{}	{"topic of discussion; agenda"}	\N	\N	\N
議長	ぎちょう	{}	{chairman}	\N	\N	\N
技能	ぎのう	{}	{"technical skill; ability; capacity"}	\N	\N	\N
義務	ぎむ	{}	{"duty; obligation; responsibility"}	\N	\N	\N
疑問	ぎもん	{本当かどうか、正しいかどうか、疑わしいこと。また、その事柄。「学説にーをいだく」「本物であるかどうかはーだ」}	{"question; problem; doubt; guess"}	\N	\N	\N
逆	ぎゃく	{}	{"reverse; opposite"}	\N	\N	\N
虐殺	ぎゃくさつ	{}	{"slaughter; massacre"}	\N	\N	\N
逆算	ぎゃくさん	{逆の順序で、さかのぼって計算すること。「年齢から生年をーする」}	{"count [calculate/reckon] backward(s)"}	\N	\N	\N
逆境	ぎゃっきょう	{苦労の多い境遇。不運な境遇。「―にめげない」⇔順境。}	{"adverse circumstances; adversity"}	\N	\N	\N
牛耳る	ぎゅうじる	{団体や組織を支配し、思いのままに動かす。牛耳を執る。「党内を―・る」}	{"lead; control; take the lead (in)"}	\N	\N	\N
逆転	ぎゃくてん	{}	{"(sudden) change; reversal; turn-around; coming from behind (baseball)"}	\N	\N	\N
牛肉	ぎゅうにく	{}	{beef}	\N	\N	\N
牛乳	ぎゅうにゅう	{}	{"cow´s milk"}	\N	\N	\N
行	ぎょう	{}	{"line; row; verse"}	\N	\N	\N
行儀	ぎょうぎ	{}	{manners}	\N	\N	\N
行事	ぎょうじ	{}	{"event; function"}	\N	\N	\N
業者	ぎょうしゃ	{}	{"trader; merchant"}	\N	\N	\N
行政	ぎょうせい	{}	{administration}	\N	\N	\N
業績	ぎょうせき	{}	{"achievement; performance; results; work; contribution"}	\N	\N	\N
業務	ぎょうむ	{}	{"business; affairs; duties; work"}	\N	\N	\N
業務上	ぎょうむじょう	{}	{"from a business/professional point of view"}	\N	\N	\N
行列	ぎょうれつ	{}	{"line; procession; matrix (mathematics)"}	\N	\N	\N
御苑	ぎょえん	{}	{"imperial garden"}	\N	\N	\N
漁業	ぎょぎょう	{}	{"fishing (industry)"}	\N	\N	\N
漁船	ぎょせん	{}	{"fishing boat"}	\N	\N	\N
漁村	ぎょそん	{}	{"fishing village"}	\N	\N	\N
魚肉	ぎょにく	{}	{"fish meat"}	\N	\N	\N
義理	ぎり	{}	{"duty; sense of duty; honor; decency; courtesy; debt of gratitude; social obligation"}	\N	\N	\N
議論	ぎろん	{}	{"argument; discussion; dispute"}	\N	\N	\N
銀	ぎん	{}	{silver}	\N	\N	\N
銀行	ぎんこう	{}	{bank}	\N	\N	\N
吟味	ぎんみ	{}	{"testing; scrutiny; careful investigation"}	\N	\N	\N
五	ご	{}	{five}	\N	\N	\N
伍	ご	{}	{"V; roman five"}	\N	\N	\N
語	ご	{}	{"language; word"}	\N	\N	\N
碁	ご	{}	{"go (board game)"}	\N	\N	\N
現場	げんば	{}	{"actual spot; scene; scene of the crime"}	\N	\N	\N
後	ご	{}	{after}	\N	\N	\N
御	ご	{}	{"go-; honourable"}	\N	\N	\N
牛	ぎゅう	{}	{cow}	{動物}	\N	\N
号	ごう	{}	{"number; issue"}	\N	\N	\N
業	ごう	{}	{"Buddhist karma; actions committed in a former life"}	\N	\N	\N
合意	ごうい	{}	{"agreement; consent; mutual understanding"}	\N	\N	\N
強引	ごういん	{}	{"overbearing; coercive; pushy; high-handed"}	\N	\N	\N
豪華	ごうか	{}	{"wonderful; gorgeous; splendor; pomp; extravagance"}	\N	\N	\N
合格	ごうかく	{}	{"success; passing (e.g. exam); eligibility"}	\N	\N	\N
合議	ごうぎ	{}	{"consultation; conference"}	\N	\N	\N
合計	ごうけい	{二つ以上の数値を合わせまとめること。}	{"the sum total; a total"}	\N	\N	\N
剛健	ごうけん	{男性的で、心身が強くたくましいこと。また、そのさま。「勤勉で―な気風」「質実―」}	{"sturdiness; 〜な strong and sturdy"}	\N	\N	\N
合成	ごうせい	{}	{"synthesis; composition; synthetic; composite; mixed; combined; compound"}	\N	\N	\N
強奪	ごうだつ	{暴力や脅迫などで、強引に奪い取ること。きょうだつ。「現金を―する」}	{robbery}	\N	\N	\N
強盗	ごうとう	{}	{"robbery; burglary"}	\N	\N	\N
合同	ごうどう	{}	{"combination; incorporation; union; amalgamation; fusion; congruence"}	\N	\N	\N
合法	ごうほう	{法規にかなっていること。適法。⇔不法。}	{"合法的: lawful; legal"}	\N	\N	\N
傲慢	ごうまん	{}	{arrogant}	\N	\N	\N
拷問	ごうもん	{}	{torture}	\N	\N	\N
合理	ごうり	{}	{rational}	\N	\N	\N
合流	ごうりゅう	{}	{"confluence; union; linking up; merge"}	\N	\N	\N
護衛	ごえい	{}	{"guard; convoy; escort"}	\N	\N	\N
呉音	ごおん	{古く日本に入った漢字音の一。もと、和音とよばれていたが、平安中期以後、呉音ともよばれるようになった。北方系の漢音に対して南方系であるといわれる。仏教関係の語などに多く用いられる。}	{"first import of kanji (5-600 Southern and Northern Dynasties)"}	\N	\N	\N
誤解	ごかい	{ある事実について、まちがった理解や解釈をすること。相手の言葉などの意味を取り違えること。思い違い。「ーを招く」「ーを解く」}	{misunderstanding}	\N	\N	\N
語学	ごがく	{}	{"language study"}	\N	\N	\N
五月	ごがつ	{}	{May}	\N	\N	\N
ご期待に添えず	ごきたいにそえず	{}	{"not live up to expectations"}	\N	\N	\N
語句	ごく	{}	{"words; phrases"}	\N	\N	\N
ごく	極	{普通の程度をはるかに越えているさま。きわめて。非常に。「―親しい間柄」}	{"most; extremely; quite (natural); very (first)"}	\N	\N	\N
極秘裏	ごくひり	{他人に知られないようにして。人に知られないうちに。}	{secretly}	\N	\N	\N
極楽	ごくらく	{}	{paradise}	\N	\N	\N
語源	ごげん	{}	{"word root; word derivation; etymology"}	\N	\N	\N
午後	ごご	{}	{"afternoon; P.M."}	\N	\N	\N
誤差	ごさ	{}	{error}	\N	\N	\N
誤算	ごさん	{}	{miscalculation}	\N	\N	\N
御神体	ごしんたい	{}	{"the object of worship in a Shinto shrine"}	\N	\N	\N
ご存知	ごぞんじ	{}	{acquaintance}	\N	\N	\N
五十音	ごじゅうおん	{}	{"the Japanese syllabary"}	\N	\N	\N
御愁傷様	ごしゅうしょうさま	{身内を失った人に対するお悔やみの語。}	{"My condolences"}	\N	\N	\N
午前	ごぜん	{}	{"morning; A.M."}	\N	\N	\N
ご存じ	ごぞんじ	{}	{know}	\N	\N	\N
御馳走	ごちそう	{}	{"feast; treating (someone)"}	\N	\N	\N
ご馳走さま	ごちそうさま	{}	{feast}	\N	\N	\N
毎	ごと	{（「ごとに」の形で用いられることが多い）名詞や動詞の連体形などに付いて、その事をするたびに、そのいずれもが、などの意を表す。…のたびに。どの…もみな。「年―に」「会う人―に」}	{"each respectively"}	\N	\N	\N
五人	ごにん	{}	{"5 people"}	\N	\N	\N
御飯	ごはん	{}	{"rice (cooked); meal"}	\N	\N	\N
碁盤	ごばん	{}	{"Go board"}	\N	\N	\N
極普通	ごくふつう	{}	{"very common; quite usual; very (interesting)"}	\N	{ごく普通}	\N
御座います	ございます	{}	{"to be (polite); to exist"}	\N	{ご座います}	\N
御主人	ごしゅじん	{}	{"(polite) your husband; her husband"}	\N	{ご主人}	\N
極	ごく	{"1 普通の程度をはるかに越えているさま。きわめて。非常に。「―親しい間柄」",2（多く「の」を伴って）程度が甚だしいこと。「この和尚様と大の仲よしで、…―の懇意であったから」}	{"pole; climax; extreme; extremity; culmination; height; zenith; nadir","to a very large extent"}	\N	\N	\N
御苦労様	ごくろうさま	{「ご苦労様」は目上の人から目下の人に使うのに対し、「お疲れ様」は同僚、目上の人に対して使う。}	{"Keep up the good work; Thank you very much for your...."}	\N	{ご苦労様,ご苦労さま}	\N
御飯粒	ごはんつぶ	{めし粒を丁寧にいう語。飯のつぶ。ごはんつぶ。}	{"a grain of cooked rice"}	\N	\N	\N
ご無沙汰	ごぶさた	{}	{"not writing or contacting for a while"}	\N	\N	\N
誤魔化す	ごまかす	{}	{"to deceive; to falsify; to misrepresent"}	\N	\N	\N
御免	ごめん	{}	{"your pardon; declining (something); dismissal; permission"}	\N	\N	\N
御免ください	ごめんください	{}	{"May I come in?"}	\N	\N	\N
御免なさい	ごめんなさい	{}	{"I beg your pardon; excuse me"}	\N	\N	\N
娯楽	ごらく	{}	{"pleasure; amusement"}	\N	\N	\N
御覧	ごらん	{}	{"look; inspection; try"}	\N	\N	\N
御覧なさい	ごらんなさい	{}	{"(please) look; (please) try to do"}	\N	\N	\N
五輪	ごりん	{}	{olympics}	\N	\N	\N
愚	ぐ	{おろかなこと。ばかげたこと。}	{"folly; foolishness"}	\N	\N	\N
具体的	ぐたいてき	{はっきりとした実体を備えているさま。個々の事物に即しているさま。反：抽象的。}	{concrete(ly)}	\N	\N	\N
具合	ぐあい	{}	{condition}	\N	\N	\N
偶数	ぐうすう	{}	{"even number"}	\N	\N	\N
偶然	ぐうぜん	{}	{"chance; accident; fortuity; unexpectedly; suddenly"}	\N	\N	\N
愚図愚図	ぐずぐず	{のろのろといたずらに時間を費やすさま。「借金の返済を―（と）引き延ばす」}	{"~と slowly; tardily; 〔ためらって〕hesitantly; hesitatingly"}	\N	\N	\N
具体	ぐたい	{}	{"concrete; tangible; material"}	\N	\N	\N
愚痴	ぐち	{}	{"idle complaint; grumble"}	\N	\N	\N
紅蓮	ぐれん	{}	{"red lotus"}	\N	\N	\N
群	ぐん	{}	{"group (math)"}	\N	\N	\N
郡	ぐん	{}	{"country; district"}	\N	\N	\N
軍艦	ぐんかん	{}	{"warship; battleship"}	\N	\N	\N
軍事	ぐんじ	{}	{"military affairs"}	\N	\N	\N
群集	ぐんしゅう	{}	{"(social) group; crowd; throng; mob; multitude"}	\N	\N	\N
群衆	ぐんしゅう	{群がり集まった人々。群集。}	{"a crowd (of people) (▼集合体を指すときは単数，個々の構成員を指すときは複数扱い)"}	\N	\N	\N
軍縮	ぐんしゅく	{}	{disarmament}	\N	\N	\N
軍曹	ぐんそう	{}	{cadet}	\N	\N	\N
軍隊	ぐんたい	{}	{"army; troops"}	\N	\N	\N
群島	ぐんとう	{}	{archipalego}	\N	\N	\N
軍備	ぐんび	{}	{"armaments; military preparations"}	\N	\N	\N
軍服	ぐんぷく	{}	{"military or naval uniform"}	\N	\N	\N
葉	は	{}	{leaf}	\N	\N	\N
歯	は	{}	{tooth}	\N	\N	\N
派	は	{}	{"clique; faction; school"}	\N	\N	\N
肺	はい	{}	{lung}	\N	\N	\N
灰色	はいいろ	{}	{"grey; ashen"}	\N	\N	\N
拝謁	はいえつ	{}	{audience；}	\N	\N	\N
胚芽	はいが	{}	{"an embryo; a germ"}	\N	\N	\N
廃棄	はいき	{}	{"annullment; disposal; abandon; scrap; discarding; repeal"}	\N	\N	\N
廃棄所	はいきしょ	{}	{"disposal facility"}	\N	\N	\N
配給	はいきゅう	{}	{"distribution (eg. films rice)"}	\N	\N	\N
俳句	はいく	{}	{"17-syllable poem"}	\N	\N	\N
配偶者	はいぐうしゃ	{}	{"spouse; wife; husband"}	\N	\N	\N
背景	はいけい	{}	{"background; scenery; setting; circumstance"}	\N	\N	\N
拝啓	はいけい	{}	{"Dear (so and so)"}	\N	\N	\N
拝見	はいけん	{見ることをへりくだっていう語。謹んで見ること。}	{"have a look at; see"}	\N	\N	\N
拝観	はいかん	{}	{admission}	\N	\N	\N
背後	はいご	{}	{"back; rear"}	\N	\N	\N
排斥	はいせき	{}	{exclussion}	\N	\N	\N
廃止	はいし	{}	{"abolition; repeal"}	\N	\N	\N
歯医者	はいしゃ	{}	{dentist}	\N	\N	\N
拝借	はいしゃく	{}	{borrowing}	\N	\N	\N
排除	はいじょ	{望ましくないとして除去する}	{"exclusion; removal; rejection"}	\N	\N	\N
灰皿	はいざら	{}	{ashtray}	\N	\N	\N
軍	ぐん	{}	{"army; force; troops"}	\N	\N	\N
刃	は	{刃物のふちの薄くて鋭い、物を切ったり削ったりする部分。「刀の―がこぼれる」}	{"an edge; 〔刀などの〕a blade"}	\N	\N	\N
灰	はい	{}	{ash}	\N	\N	\N
御明察	ごめいさつ	{相手を敬って、その推察をいう語。「―恐れ入ります」}	{"〔はっきり見極めること〕discernment; 〔洞察〕perception; insight"}	\N	{ご明察,明察}	\N
排水	はいすい	{}	{drainage}	\N	\N	\N
排水溝	はいすいこう	{耕地や道路などの水を排除するためのみぞ。}	{"a drain; a drainage ditch; 〔機械などの水口〕a waterway"}	\N	\N	\N
敗戦	はいせん	{}	{"defeat; losing a war"}	\N	\N	\N
配達	はいたつ	{}	{"delivery; distribution"}	\N	\N	\N
配置	はいち	{人や物をそれぞれの位置・持ち場に割り当てて置くこと。また、その位置・持ち場。「全員―に就く」「席の―を決める」「要員を―する」}	{"arrangement (of resources); disposition"}	\N	\N	\N
配布	はいふ	{配って広く行き渡らせること。配る。配付。渡す。「駅前でちらしをーする」}	{distribution}	\N	\N	\N
配分	はいぶん	{}	{"distribution; allotment"}	\N	\N	\N
俳優	はいゆう	{}	{"actor; actress; player; performer"}	\N	\N	\N
配慮	はいりょ	{}	{"consideration; concern; forethought"}	\N	\N	\N
配列	はいれつ	{}	{"arrangement; array (programming)"}	\N	\N	\N
生える	はえる	{}	{"grow; spring up"}	\N	\N	\N
映える	はえる	{}	{"to shine; to look attractive; to look pretty"}	\N	\N	\N
墓	はか	{}	{"gravesite; tomb"}	\N	\N	\N
破壊	はかい	{}	{destruction}	\N	\N	\N
葉書	はがき	{}	{postcard}	\N	\N	\N
剥がす	はがす	{}	{"to tear off; to peel off; to rip off; to strip off; to skin; to flay; to disrobe; to deprive of; to detach; to disconnect"}	\N	\N	\N
剥す	はがす	{}	{"tear off; peel off; rip off; strip off; skin; flay; disrobe; deprive of; detach; disconnect"}	\N	\N	\N
博士	はかせ	{}	{"doctorate; PhD"}	\N	\N	\N
墓地	はかち	{}	{"cemetery; graveyard"}	\N	\N	\N
捗る	はかどる	{}	{"to make progress; to move right ahead (with the work); to advance"}	\N	\N	\N
果ない	はかない	{}	{"fleeting; transient; short-lived; momentary; vain; fickle; miserable; empty; ephemeral"}	\N	\N	\N
鋼	はがね	{}	{steel}	\N	\N	\N
墓参り	はかまいり	{"墓に参って拝むこと。特に、盂蘭盆 (うらぼん) に先祖の墓にお参りすること。墓詣で。ぼさん。《季 秋》"}	{"a visit to a grave"}	\N	\N	\N
諮る	はかる	{}	{"to consult with; to confer"}	\N	\N	\N
図る	はかる	{}	{"to plot; to attempt; to plan; to take in; to deceive; to devise; to design; to refer A to B"}	\N	\N	\N
測る	はかる	{ある基準をもとにして物の度合いを調べる。「体温を―・る」「距離を―・る」}	{"measure; fathom"}	\N	\N	\N
破棄	はき	{}	{"revocation; annulment; breaking (e.g. treaty)"}	\N	\N	\N
吐き気	はきけ	{}	{"nausea; sickness in the stomach"}	\N	\N	\N
泊	はく	{}	{"counter for nights of a stay"}	\N	\N	\N
履く	はく	{}	{"to wear; to put on (lower body)"}	\N	\N	\N
掃く	はく	{}	{"to brush; sweep; gather up"}	\N	\N	\N
剥ぐ	はぐ	{}	{"to tear off; to peel off; to rip off; to strip off; to skin; to flay; to disrobe; to deprive of"}	\N	\N	\N
白衣	はくい	{}	{"white lab coat"}	\N	\N	\N
迫害	はくがい	{}	{persecution}	\N	\N	\N
伯爵	はくしゃく	{}	{count}	\N	\N	\N
薄弱	はくじゃく	{}	{"feebleness; weakness; weak"}	\N	\N	\N
拍手	はくしゅ	{}	{"clapping hands; applause"}	\N	\N	\N
白状	はくじょう	{}	{confession}	\N	\N	\N
博物館	はくぶつかん	{}	{museum}	\N	\N	\N
歯車	はぐるま	{}	{"gear; cog-wheel"}	\N	\N	\N
禿	はげ	{毛髪が抜け落ちている部分。また、抜け落ちている状態。}	{baldness}	\N	\N	\N
ハゲ	禿	{毛髪が抜け落ちている部分。また、抜け落ちている状態。}	{baldness}	\N	\N	\N
激しい	はげしい	{}	{"violent; vehement; intense; furious; tempestuous"}	\N	\N	\N
励ます	はげます	{}	{"to encourage; to cheer; to raise (the voice)"}	\N	\N	\N
励む	はげむ	{}	{"to be zealous; to brace oneself; to endeavour; to strive; to make an effort"}	\N	\N	\N
剥げる	はげる	{}	{"to come off; to be worn off; to fade; to discolor"}	\N	\N	\N
派遣	はけん	{}	{"dispatch; send"}	\N	\N	\N
箱	はこ	{}	{box}	\N	\N	\N
運ぶ	はこぶ	{}	{bring}	\N	\N	\N
挟まる	はさまる	{}	{"get between; be caught in"}	\N	\N	\N
挟む	はさむ	{}	{"interpose; hold between; insert"}	\N	\N	\N
破産	はさん	{}	{"(personal) bankruptcy"}	\N	\N	\N
橋	はし	{}	{bridge}	\N	\N	\N
端	はし	{}	{"edge; tip; margin; point; end (e.g. of street)"}	\N	\N	\N
箸	はし	{}	{chopsticks}	\N	\N	\N
計る	はかる	{}	{"to measure; to weigh; to survey; to time (sound gauge estimate)"}	\N	{量る}	\N
恥	はじ	{}	{"shame; embarrassment"}	\N	\N	\N
始まり	はじまり	{}	{"origin; beginning"}	\N	\N	\N
始まる	はじまる	{}	{begin}	\N	\N	\N
始め	はじめ	{物事を行う最も早い時期。最初のころ。副詞的にも用いる。「五月の―」「何をするにも―が肝心だ」「―から終わりまで読み通す」「―君だとは気づかなかった」}	{"start; origin"}	\N	\N	\N
初めて	はじめて	{}	{"for the first time"}	\N	\N	\N
初めに	はじめに	{}	{"in the beginning; at first"}	\N	\N	\N
始めに	はじめに	{}	{"in the beginning; to begin with; first of all"}	\N	\N	\N
始めまして	はじめまして	{}	{"How do you do?; I am glad to meet you"}	\N	\N	\N
始める	はじめる	{物事を行っていない状態から行う状態にする。行いだす。「早朝から作業を―・める」「戦争を―・める」⇔終える／終わる。}	{begin}	\N	\N	\N
柱	はしら	{}	{"pillar; post"}	\N	\N	\N
恥じらう	はじらう	{}	{"to feel shy; to be bashful; to blush"}	\N	\N	\N
恥じる	はじる	{}	{"to feel ashamed"}	\N	\N	\N
橋渡し	はしわたし	{}	{"bridge building; mediation"}	\N	\N	\N
斜	はす	{}	{"aslant; oblique; diagonal"}	\N	\N	\N
筈	はず	{当然そうなるべき道理であることを示す。また、その確信をもっていることを示す。〜べき「君はそれを知っているーだ」}	{"must; should; ought; supposed to;"}	\N	\N	\N
恥ずかしい	はずかしい	{}	{"shameful; be ashamed"}	\N	\N	\N
外す	はずす	{}	{"unfasten; remove"}	\N	\N	\N
弾む	はずむ	{}	{"to spring; to bound; to bounce; to be stimulated; to be encouraged; to get lively; to treat oneself to; to splurge on"}	\N	\N	\N
外れ値	はずれち	{統計学の用語で、データの全体的な傾向から大きく離れた値のこと。}	{outlier}	\N	\N	\N
破損	はそん	{}	{damage}	\N	\N	\N
機	はた	{}	{loom}	\N	\N	\N
旗	はた	{}	{flag}	\N	\N	\N
肌	はだ	{}	{"skin; body; grain; texture; disposition"}	\N	\N	\N
裸	はだか	{}	{"naked; nude; bare"}	\N	\N	\N
肌着	はだぎ	{}	{"underwear; lingerie; singlet; chemise"}	\N	\N	\N
畑	はたけ	{}	{field}	\N	\N	\N
裸足	はだし	{}	{barefoot}	\N	\N	\N
果たして	はたして	{}	{"as was expected; really"}	\N	\N	\N
果たす	はたす	{"１ 物事を成し遂げる。「約束をー・す」「望みをー・す」２ その立場としての仕事をみごとにやってのける。"}	{"to accomplish; to fulfill; to carry out; to achieve"}	\N	\N	\N
二十歳	はたち	{}	{"20 years old; 20th year"}	\N	\N	\N
働き	はたらき	{}	{"work; workings; activity; ability; talent; function; labor; action; operation; movement; motion; conjugation; inflection; achievement"}	\N	\N	\N
働く	はたらく	{}	{"work; to labor; do; to act; commit; practise; work on; come into play; be conjugated; reduce the price"}	\N	\N	\N
八	はち	{}	{eight}	\N	\N	\N
鉢	はち	{}	{"bowl; pot; basin"}	\N	\N	\N
八月	はちがつ	{}	{Aug}	\N	\N	\N
蜂蜜	はちみつ	{}	{honey}	\N	\N	\N
初	はつ	{}	{"first; new"}	\N	\N	\N
発	はつ	{}	{"departure; beginning; counter for gunshots"}	\N	\N	\N
発育	はついく	{}	{"(physical) growth; development"}	\N	\N	\N
発音	はつおん	{音声を出すこと。言語音を出すこと。また、その音声の出し方。動物では発音器官によるもののほか、魚が浮き袋を用いたりキツツキが木をたたいたりして音をたてることにもいう。「正しくーする」}	{pronunciation}	\N	\N	\N
二十日	はつか	{}	{"twenty days; twentieth day of the month"}	\N	\N	\N
発芽	はつが	{}	{burgeoning}	\N	\N	\N
発揮	はっき	{}	{"exhibition; demonstration; utilization; display"}	\N	\N	\N
発掘	はっくつ	{}	{"excavation; exhumation"}	\N	\N	\N
発見	はっけん	{まだ知られていなかったものを見つけ出すこと。また、わからなかった存在を見いだすこと。「新大陸の―」「犯人のアジトを―する」}	{discovery}	\N	\N	\N
発言	はつげん	{言葉を出すこと。口頭で意見を述べること。また、その言葉。はつごん。「―を求める」「会議で―する」}	{"utterance; speech; proposal"}	\N	\N	\N
八個	はっこ	{}	{"8 pieces"}	\N	\N	\N
発行	はっこう	{}	{"issue (publications)"}	\N	\N	\N
弾く	はじく	{}	{"to flip; to snap"}	\N	\N	\N
梯子	はしご	{}	{"ladder; stairs"}	\N	\N	\N
発車	はっしゃ	{}	{"departure of a vehicle"}	\N	\N	\N
発射	はっしゃ	{}	{"firing; shooting; discharge; catapult"}	\N	\N	\N
発信	はっしん	{電信や電波を発すること。「SOSを―する」⇔受信。}	{transmission}	\N	\N	\N
発信機	はっしんき	{通信信号を発する装置の総称。}	{"a transmitter"}	\N	\N	\N
発信機用	はっしんきよう	{}	{transmitter-using}	\N	\N	\N
発生	はっせい	{物事が起こること。生じること。「熱が―する」「事件が―する」}	{"outbreak; spring forth; occurrence; incidence; origin"}	\N	\N	\N
発想	はっそう	{}	{"expression (music); conceptualization"}	\N	\N	\N
発足	はっそく	{}	{"starting; inauguration"}	\N	\N	\N
発達	はったつ	{}	{"development; growth"}	\N	\N	\N
発展	はってん	{}	{"development; growth"}	\N	\N	\N
発電	はつでん	{}	{"generation (e.g. power)"}	\N	\N	\N
発売	はつばい	{}	{sale}	\N	\N	\N
発病	はつびょう	{}	{"attack (disease)"}	\N	\N	\N
発表	はっぴょう	{}	{"announcement; publication"}	\N	\N	\N
初耳	はつみみ	{}	{"something heard for the first time"}	\N	\N	\N
発明	はつめい	{}	{invention}	\N	\N	\N
派手	はで	{}	{"showy; loud; gay; flashy; gaudy"}	\N	\N	\N
果てる	はてる	{}	{"to end; to be finished; to be exhausted; to die; to perish"}	\N	\N	\N
鼻	はな	{}	{nose}	\N	\N	\N
花	はな	{}	{flower}	\N	\N	\N
花盛り	はなざかり	{花が咲きそろっていること。また、その季節。}	{"full bloom"}	\N	\N	\N
話	はなし	{}	{"talk; speech; chat; story; conversation"}	\N	\N	\N
話し合い	はなしあい	{}	{"discussion; conference"}	\N	\N	\N
話し合う	はなしあう	{}	{"discuss; talk together"}	\N	\N	\N
話し掛ける	はなしかける	{}	{"accost a person; talk (to someone)"}	\N	\N	\N
話中	はなしちゅう	{}	{"while talking; the line is busy"}	\N	\N	\N
話す	はなす	{}	{speak}	\N	\N	\N
放す	はなす	{}	{"separate; set free; turn loose"}	\N	\N	\N
離す	はなす	{}	{"part; divide; separate"}	\N	\N	\N
甚だ	はなはだ	{}	{"very; greatly; exceedingly"}	\N	\N	\N
甚だしい	はなはだしい	{}	{"extreme; excessive; terrible; intense; severe; serious; tremendous"}	\N	\N	\N
華々しい	はなばなしい	{}	{"brilliant; magnificent; spectacular"}	\N	\N	\N
花火	はなび	{}	{fireworks}	\N	\N	\N
花びら	はなびら	{}	{"(flower) petal"}	\N	\N	\N
花見	はなみ	{}	{"cherry blossom viewing; flower viewing"}	\N	\N	\N
華やか	はなやか	{}	{"gay; showy; brilliant; gorgeous; florid"}	\N	\N	\N
花嫁	はなよめ	{}	{bride}	\N	\N	\N
放れる	はなれる	{}	{"leave; get free; cut oneself off"}	\N	\N	\N
離れる	はなれる	{}	{"be separated from; leave; go away; be a long way off"}	\N	\N	\N
羽	はね	{}	{"feather; wing"}	\N	\N	\N
羽根	はね	{}	{shuttlecock}	\N	\N	\N
跳ねる	はねる	{}	{"jump; leap; prance; spring up; bound; hop"}	\N	\N	\N
母	はは	{親のうち、女性のほう。実母・義母・継母の総称。母親。おんなおや。⇔父。}	{"〔母親〕one's mother"}	\N	\N	\N
幅	はば	{}	{"width; breadth"}	\N	\N	\N
母親	ははおや	{}	{mother}	\N	\N	\N
派閥	はばつ	{一党}	{"faction; political faction"}	\N	\N	\N
阻む	はばむ	{}	{"to keep someone from doing; to stop; to prevent; to check; to hinder; to obstruct; to oppose; to thwart"}	\N	\N	\N
省く	はぶく	{}	{"omit; eliminate; curtail; economize"}	\N	\N	\N
破片	はへん	{}	{"fragment; splinter; broken piece"}	\N	\N	\N
浜	はま	{}	{"beach; seashore"}	\N	\N	\N
浜辺	はまべ	{}	{"beach; foreshore"}	\N	\N	\N
填まる	はまる	{}	{"to get into; to go into; to fit; to be fit for; to suit; to fall into; to plunge into; to be deceived; to be taken in; to fall into a trap; to be addicted to; to be deep into"}	\N	\N	\N
歯磨き	はみがき	{}	{"dentifrice; toothpaste"}	\N	\N	\N
歯磨き粉	はみがきこ	{}	{"dentifrice; toothpaste"}	\N	\N	\N
刃物	はもの	{切り物}	{cutlery}	\N	\N	\N
早い	はやい	{}	{early}	\N	\N	\N
醗酵	はっこう	{}	{"fermentation; ferment"}	\N	{発酵}	\N
果て	はて	{果てること。終わること。また、物事の終わり。しまい。限り。すえ。「―もない議論」「旅路の―」,広い地域の極まるところ。いちばん端の所。「地の―」「海の―」}	{"〔終わり〕the end","〔一番端の所〕the end (of the earth)"}	\N	\N	\N
速い	はやい	{}	{"quick; fast; swift"}	\N	\N	\N
早口	はやくち	{}	{fast-talking}	\N	\N	\N
林	はやし	{}	{"woods; forest"}	\N	\N	\N
生やす	はやす	{}	{"to grow; to cultivate; to wear beard"}	\N	\N	\N
早める	はやめる	{}	{"to hasten; to quicken; to expedite; to precipitate; to accelerate"}	\N	\N	\N
流行る	はやる	{}	{"flourish; thrive; be popular; come into fashion"}	\N	\N	\N
腹	はら	{}	{"abdomen; belly; stomach"}	\N	\N	\N
払い込む	はらいこむ	{}	{"deposit; pay in"}	\N	\N	\N
払い戻す	はらいもどす	{}	{"repay; pay back"}	\N	\N	\N
払う	はらう	{}	{pay}	\N	\N	\N
腹立ち	はらだち	{}	{anger}	\N	\N	\N
原っぱ	はらっぱ	{}	{"open field; empty lot; plain"}	\N	\N	\N
波乱	はらん	{大小の波。波濤 (はとう) 。}	{eventful}	\N	\N	\N
針	はり	{}	{"needle; fish hook; pointer; hand (clock)"}	\N	\N	\N
針金	はりがね	{}	{wire}	\N	\N	\N
張り紙	はりがみ	{}	{"paper patch; paper backing; poster"}	\N	\N	\N
張り切る	はりきる	{}	{"be in high spirits; be full of vigor; be enthusiastic; be eager; stretch to breaking point"}	\N	\N	\N
貼り付け	はりつけ	{}	{paste}	\N	\N	\N
春	はる	{}	{spring}	\N	\N	\N
張る	はる	{}	{"to stick; paste; put; affix; stretch; spread; strain; stick out; slap; be expensive; tighten"}	\N	\N	\N
貼る	はる	{}	{"to stick; paste"}	\N	\N	\N
晴れ	はれ	{}	{"clear weather"}	\N	\N	\N
破裂	はれつ	{}	{"explosion; rupture; break off"}	\N	\N	\N
晴れる	はれる	{}	{"be sunny; clear away; stop raining"}	\N	\N	\N
腫れる	はれる	{}	{"to swell (from inflammation); to become swollen"}	\N	\N	\N
半	はん	{}	{half}	\N	\N	\N
版	はん	{}	{edition}	\N	\N	\N
班	はん	{}	{"group; party; section (mil)"}	\N	\N	\N
藩	はん	{}	{"a han; a feudal clan; 〔領地〕a feudal domain"}	\N	\N	\N
犯	はん	{}	{~crime}	\N	\N	\N
範囲	はんい	{ある一定の限られた広がり「できる―で協力する」}	{"scope (of influence); range (of possibility); sphere (of contacts); extent"}	\N	\N	\N
繁栄	はんえい	{}	{"prospering; prosperity; thriving; flourishing"}	\N	\N	\N
版画	はんが	{}	{"art print"}	\N	\N	\N
反感	はんかん	{}	{"antipathy; revolt; animosity"}	\N	\N	\N
反響	はんきょう	{}	{"echo; reverberation; repercussion; reaction; influence"}	\N	\N	\N
半径	はんけい	{}	{radius}	\N	\N	\N
反撃	はんげき	{}	{"counterattack; counteroffensive; counterblow"}	\N	\N	\N
判決	はんけつ	{}	{"judicial decision; judgement; sentence; decree"}	\N	\N	\N
判子	はんこ	{}	{"seal (used for signature)"}	\N	\N	\N
反抗	はんこう	{}	{"opposition; resistance; insubordination; defiance; hostility; rebellion"}	\N	\N	\N
犯罪	はんざい	{}	{crime}	\N	\N	\N
判事	はんじ	{}	{"judge; judiciary"}	\N	\N	\N
反射	はんしゃ	{媒質中を進む光・音などの波動が、媒質の境界面に当たって向きを変え、もとの媒質に戻って進むこと。「声が山に―してこだまする」}	{reflection}	\N	\N	\N
反射神経	はんしゃしんけい	{}	{reflexes}	\N	\N	\N
繁盛	はんじょう	{}	{"prosperity; flourishing; thriving"}	\N	\N	\N
繁殖	はんしょく	{}	{"breed; multiply; increase; propagation"}	\N	\N	\N
半身	はんしん	{}	{"half body"}	\N	\N	\N
半身浴	はんしんよく	{みぞおち辺りまでの下半身を、ぬるめの湯につける温浴法。水圧から上半身を解放して心臓の負担を軽減したり、血行をよくしたりする。}	{"bathe the lower part of the body"}	\N	\N	\N
反する	はんする	{}	{"to be inconsistent with; to oppose; to contradict; to transgress; to rebel"}	\N	\N	\N
反省	はんせい	{自分のしてきた言動をかえりみて、その可否を改めて考えること。「常に―を怠らない」「一日の行動を―してみる」}	{"reflection; reconsideration; introspection; meditation; contemplation"}	\N	\N	\N
反対	はんたい	{ある意見などに対して逆らい、同意しないこと。否定的であること。「君の意見には―だ」「法案に―する」「党内の―派」⇔賛成。}	{oppose}	\N	\N	\N
変異	へんい	{}	{mutation}	\N	\N	\N
流行	はやり	{}	{"fashionable; fad; in vogue; prevailing"}	\N	\N	\N
原	はら	{}	{"field; plain; prairie; tundra; moor; wilderness"}	\N	\N	\N
判	はん	{}	{"seal; stamp; monogram signature; judgment"}	\N	\N	\N
犯行	はんこう	{犯罪となる行為。犯罪行為。「―を認める」「過激派の―声明」}	{"a crime; an offense，((英)) an offence (▼offenseのほうが意味が広く，ごく軽い犯罪も含む)"}	\N	\N	\N
反対派	はんたいは	{ある意見などに対して逆らい、同意しないの派。}	{"demostration opponents; an opposition faction"}	\N	\N	\N
繁体字	はんたいじ	{}	{"traditional character (of kanji in China)"}	\N	\N	\N
判断	はんだん	{}	{"judgement; decision; adjudication; conclusion; decipherment; divination"}	\N	\N	\N
判定	はんてい	{}	{"judgement; decision; award; verdict"}	\N	\N	\N
半島	はんとう	{}	{peninsula}	\N	\N	\N
犯人	はんにん	{}	{"offender; criminal"}	\N	\N	\N
反応	はんのう	{}	{"reaction; response"}	\N	\N	\N
販売	はんばい	{}	{"sale; selling; marketing"}	\N	\N	\N
反発	はんぱつ	{}	{"repelling; rebound; recover; oppose"}	\N	\N	\N
半発酵	はんはっこう	{}	{semi-oxidation}	\N	\N	\N
半端	はんぱ	{あるまとまった量・数がそろっていないこと。また、そのさまや、そのもの。「―が出る」「―な布」}	{"〔数量がそろわないこと〕〜物 〔そろわない物〕an odd piece [article]; 〔総称〕odds and ends; remnant; fragment; incomplete set; fraction; odd sum; incompleteness"}	\N	\N	\N
半端無い	はんぱない	{俗に、中途半端ではなく、徹底しているさま。程度がはなはだしいさま。ものすごい。すごく。「あの店のラーメンは量が―・い」}	{"extensive; a lot"}	\N	\N	\N
半分	はんぶん	{}	{half}	\N	\N	\N
反乱	はんらん	{}	{"insurrection; mutiny; rebellion; revolt; uprising"}	\N	\N	\N
氾濫	はんらん	{}	{"overflowing; flood"}	\N	\N	\N
販路	はんろ	{}	{"sales channels"}	\N	\N	\N
塀	へい	{}	{"wall; fence"}	\N	\N	\N
兵	へい	{戦闘に従事する者。軍人。兵士。「―を集める」}	{"a soldier"}	\N	\N	\N
陛下	へいか	{天皇・皇后・皇太后}	{"(your) highness"}	\N	\N	\N
閉会	へいかい	{}	{closure}	\N	\N	\N
兵器	へいき	{}	{"arms; weapons; ordinance"}	\N	\N	\N
平気	へいき	{}	{"coolness; calmness; composure; unconcern"}	\N	\N	\N
閉口	へいこう	{}	{"shut mouth"}	\N	\N	\N
平衡	へいこう	{物のつりあいがとれていること。均衡。「からだのーを失う」}	{"balance; equilibrium"}	\N	\N	\N
閉鎖	へいさ	{}	{"closing; closure; shutdown; lockout; unsociable"}	\N	\N	\N
兵士	へいし	{}	{soldier}	\N	\N	\N
平日	へいじつ	{}	{"weekday; ordinary days"}	\N	\N	\N
平常	へいじょう	{}	{"normal; usual"}	\N	\N	\N
兵隊	へいたい	{}	{"soldier; sailor"}	\N	\N	\N
平坦	へいたん	{}	{"flat (landscape)"}	\N	\N	\N
閉店	へいてん	{商売をやめて店を閉じること。⇔開店。}	{"close (e.g. a store) 〔廃業する〕「close down [wind up] business; give up one's business"}	\N	\N	\N
閉店時間	へいてんじかん	{}	{"closing time (e.g. for a store)"}	\N	\N	\N
閉店時刻	へいてんじこく	{}	{"closing time"}	\N	\N	\N
閉腹	へいふく	{}	{"close stomach (operation)"}	\N	\N	\N
平方	へいほう	{}	{"square (e.g. metre); square"}	\N	\N	\N
平凡	へいぼん	{}	{"common; commonplace; ordinary; mediocre"}	\N	\N	\N
平野	へいや	{}	{"plain; open field"}	\N	\N	\N
並列	へいれつ	{}	{"arrangement; parallel; abreast"}	\N	\N	\N
平和	へいわ	{}	{"peace; harmony"}	\N	\N	\N
辟易	へきえき	{}	{"wince; shrink back; succumbing to; being frightened; disconcerted"}	\N	\N	\N
凹む	へこむ	{}	{"be dented; be indented; yield to; to give; sink; collapse; cave in; be snubbed"}	\N	\N	\N
隔たり	へだたり	{へだたること。また、その度合い。「十年のー」間隔。距離。差。}	{"distance; difference"}	\N	\N	\N
隔たる	へだたる	{}	{"to be distant"}	\N	\N	\N
隔てる	へだてる	{}	{"be shut out; separate; isolate"}	\N	\N	\N
減らす	へらす	{}	{"abate; decrease; diminish; shorten"}	\N	\N	\N
謙る	へりくだる	{}	{"to deprecate oneself and praise the listener"}	\N	\N	\N
減る	へる	{}	{"decrease (in size or number); diminish; abate"}	\N	\N	\N
経る	へる	{}	{"to pass; to elapse; to experience"}	\N	\N	\N
辺	へん	{}	{"side; part; area; vicinity"}	\N	\N	\N
変	へん	{}	{strange}	\N	\N	\N
偏	へん	{}	{"side; left radical of a character; inclining; inclining toward; biased"}	\N	\N	\N
編	へん	{}	{"compilation; editing; completed poem; book; part of book"}	\N	\N	\N
平行	へいこう	{}	{"(going) side by side; concurrent; abreast; at the same time; occurring together; parallel; parallelism"}	\N	{並行}	\N
下手	へた	{物事のやり方が巧みでなく、手際が悪いこと。また、そのさまや、その人。「泳ぎが―な人」「字をわざと―に書く」「人の使い方が―だ」⇔上手 (じょうず) 。}	{"unskillful; poor; awkward"}	\N	\N	\N
変化	へんか	{変わり}	{change}	\N	\N	\N
変革	へんかく	{}	{"change; reform; revolution; upheaval; (the) Reformation"}	\N	\N	\N
返還	へんかん	{}	{"return; restoration"}	\N	\N	\N
偏屈	へんくつ	{性質がかたくなで、素直でないこと。ひねくれていること。また、そのさま。「ーな人」}	{"〔頑固な〕stubborn; 〔風変わりな〕eccentric"}	\N	\N	\N
偏見	へんけん	{かたよった見方・考え方。ある集団や個人に対して、客観的な根拠なしにいだかれる非好意的な先入観や判断。「―を持つ」「人種的―」}	{"prejudice; narrow view"}	\N	\N	\N
変更	へんこう	{決められた物事などを変えること。「計画を―する」}	{"change; modification; alteration"}	\N	\N	\N
返済	へんさい	{}	{repayment}	\N	\N	\N
遍在	へんざい	{広くあちこちにゆきわたって存在すること。「全国にーする民話」}	{"omnipresent; ubiquitous"}	\N	\N	\N
偏在	へんざい	{}	{maldistribution}	\N	\N	\N
返事	へんじ	{}	{"reply; answer"}	\N	\N	\N
変質	へんしつ	{ふつうとは違う病的な性質や性格。}	{"〔病的な性質〕an abnormal nature 〜的 abnormal 〜者 〔倒錯者〕a pervert"}	\N	\N	\N
変質者	へんしつしゃ	{性格・性質に異常があって、正常の人とは異なっている人。特に、性的に異常な人。性格異常者。}	{"〔倒錯者〕a pervert"}	\N	\N	\N
編集	へんしゅう	{}	{"editing; compilation; editorial (e.g. committee)"}	\N	\N	\N
返信	へんしん	{返事の手紙や電子メールを送ること。また、その手紙やメール。返書。「友人からのメールに―する」⇔往信。}	{"an answer; a reply ((to))"}	\N	\N	\N
変遷	へんせん	{}	{"change; transition; vicissitudes"}	\N	\N	\N
変装	へんそう	{別人にみせかけるために、風貌 (ふうぼう) や服装などを変えること。また、その変えた姿。「かつらとサングラスでーする」}	{"a disguise"}	\N	\N	\N
編注	へんちゅう	{}	{"Editor's Note"}	\N	\N	\N
返答	へんとう	{}	{reply}	\N	\N	\N
変動	へんどう	{}	{"change; fluctuation"}	\N	\N	\N
火	ひ	{}	{fire}	\N	\N	\N
費	ひ	{}	{"cost; expense"}	\N	\N	\N
非	ひ	{}	{"faulty-; non-"}	\N	\N	\N
悲哀	ひあい	{悲しくあわれなこと。「人生のーを感じる」}	{"sorrow; grief"}	\N	\N	\N
日当たり	ひあたり	{}	{"exposure to the sun; sunny place"}	\N	\N	\N
延いては	ひいては	{}	{"not only...but also; in addition to; consequently"}	\N	\N	\N
冷える	ひえる	{}	{"get cold"}	\N	\N	\N
被害	ひがい	{}	{damage}	\N	\N	\N
控室	ひかえしつ	{}	{"waiting room"}	\N	\N	\N
日帰り	ひがえり	{}	{"day trip"}	\N	\N	\N
控える	ひかえる	{}	{"to draw in; to hold back; to make notes; to be temperate in"}	\N	\N	\N
比較	ひかく	{}	{comparison}	\N	\N	\N
比較的	ひかくてき	{}	{"comparatively; relatively"}	\N	\N	\N
日陰	ひかげ	{}	{shadow}	\N	\N	\N
光	ひかり	{}	{light}	\N	\N	\N
光る	ひかる	{}	{"shine; glitter; be bright"}	\N	\N	\N
悲観	ひかん	{}	{"pessimism; disappointment"}	\N	\N	\N
匹	ひき	{助数詞。動物・鳥・昆虫・魚などを数えるのに用いる。上に来る語によっては「びき」「ぴき」となる。「二―の猫」}	{"head; small animal counter; roll of cloth"}	\N	\N	\N
引き上げる	ひきあげる	{}	{"to withdraw; to leave; to pull out; to retire"}	\N	\N	\N
引き揚げる	ひきあげる	{}	{"withdraw; retire"}	\N	\N	\N
率いる	ひきいる	{}	{"to lead; to spearhead (a group); to command (troops)"}	\N	\N	\N
引き受ける	ひきうける	{}	{"to undertake; to take up; to take over; to be responsible for; to guarantee; to contract (disease)"}	\N	\N	\N
引受る	ひきうける	{}	{"undertake; take charge of; take; accept; be responsible for; guarantee"}	\N	\N	\N
引き起こす	ひきおこす	{}	{"to cause"}	\N	\N	\N
引返す	ひきかえす	{}	{"repeat; send back; bring back; retrace one´s steps"}	\N	\N	\N
引き下げる	ひきさげる	{}	{"to pull down; to lower; to reduce; to withdraw"}	\N	\N	\N
引算	ひきざん	{}	{subtraction}	\N	\N	\N
引き締め	ひきしめ	{引き締めること。ゆるみやむだをなくすること。「財政の―」}	{"tightning up; restraint"}	\N	\N	\N
被疑者	ひぎしゃ	{犯罪の嫌疑を受けて捜査の対象となっているが、起訴されていない者}	{suspect}	\N	\N	\N
引きずる	ひきずる	{}	{"to seduce; to drag along; to pull; to prolong; to support"}	\N	\N	\N
日	ひ	{}	{day}	\N	\N	\N
灯	ひ	{}	{light}	\N	\N	\N
東	ひがし	{}	{east}	\N	\N	\N
引き出し	ひきだし	{}	{drawer}	\N	\N	\N
引き出す	ひきだす	{}	{"to pull out; to take out; to draw out; to withdraw"}	\N	\N	\N
引出す	ひきだす	{}	{"pull out; take out; draw out; withdraw"}	\N	\N	\N
引き止める	ひきとめる	{}	{"detain; restrain"}	\N	\N	\N
引き離す	ひきはなす	{分ける・引っ張って離す。無理に離れさせる}	{"pull from (someone or something)"}	\N	\N	\N
卑怯	ひきょう	{}	{"cowardice; meanness; unfairness"}	\N	\N	\N
引き分け	ひきわけ	{勝負事で、決着がつかず、双方勝ち負けなしとして終えること。「試合をーに持ち込む」}	{"a draw (in competition); tie game"}	\N	\N	\N
引分け	ひきわけ	{}	{"tie game; draw"}	\N	\N	\N
低い	ひくい	{⇔高い。}	{"short; low; humble; low (voice)"}	\N	\N	\N
悲劇	ひげき	{}	{tragedy}	\N	\N	\N
否決	ひけつ	{}	{"rejection; negation; voting down"}	\N	\N	\N
非行	ひこう	{}	{"delinquency; misconduct"}	\N	\N	\N
飛行	ひこう	{}	{"flying; flight; aviation"}	\N	\N	\N
飛行機	ひこうき	{}	{airplane}	\N	\N	\N
飛行場	ひこうじょう	{}	{"airfield; airport"}	\N	\N	\N
日頃	ひごろ	{}	{"normally; habitually"}	\N	\N	\N
膝	ひざ	{}	{"knee; lap"}	\N	\N	\N
陽射	ひざし	{}	{sunlight}	\N	\N	\N
久しい	ひさしい	{}	{"long; long-continued; old (story)"}	\N	\N	\N
久し振り	ひさしぶり	{}	{"after a long time"}	\N	\N	\N
久しぶり	ひさしぶり	{}	{"after a long time; long time (no see)"}	\N	\N	\N
悲惨	ひさん	{}	{misery}	\N	\N	\N
肘	ひじ	{}	{elbow}	\N	\N	\N
匕首	ひしゅ	{}	{"dagger; dirk"}	\N	\N	\N
比重	ひじゅう	{}	{"specific gravity"}	\N	\N	\N
批准	ひじゅん	{日本では内閣が行うが、国会の承認を必要とする。「通商条約をーする」}	{"ratification; official way to confirm something; usually by vote"}	\N	\N	\N
秘書	ひしょ	{}	{"(private) secretary"}	\N	\N	\N
非常	ひじょう	{普通でない差し迫った状態。また、思いがけない変事。緊急事態。「―を告げる電話の声」「―持ち出しの荷物」}	{"emergency; extraordinary; unusual"}	\N	\N	\N
非常に	ひじょうに	{並の程度でないさま。はなはだしいさま。「―悲しい」「それが―好きだ」「―驚いた」}	{"very; greatly"}	\N	\N	\N
密か	ひそか	{}	{"secret; private; surreptitious"}	\N	\N	\N
潜む	ひそむ	{}	{"to hide"}	\N	\N	\N
浸す	ひたす	{}	{"to soak; to dip; to drench"}	\N	\N	\N
一向	ひたすら	{}	{earnestly}	\N	\N	\N
左	ひだり	{}	{"left hand side"}	\N	\N	\N
左利き	ひだりきき	{}	{"left-handedness; sake drinker; left-hander"}	\N	\N	\N
引っ掛かる	ひっかかる	{}	{"be caught in; be stuck in; be cheated"}	\N	\N	\N
引っ掻く	ひっかく	{}	{"to scratch"}	\N	\N	\N
引っ掛ける	ひっかける	{}	{"to hang (something) on (something); to throw on (clothes); to hook; to catch; to trap; to ensnare; to cheat; to evade payment; to jump a bill; to drink (alcohol); to spit at (a person); to hit the ball off the end of the bat (baseball)"}	\N	\N	\N
筆記	ひっき	{}	{"(taking) notes; copying"}	\N	\N	\N
引っ繰り返す	ひっくりかえす	{}	{"turn over; overturn; knock over; upset; turn inside out"}	\N	\N	\N
引っ繰り返る	ひっくりかえる	{}	{"be overturned; be upset; topple over; be reversed"}	\N	\N	\N
必見	ひっけん	{必ず見なければならないこと。見る価値のあること。また、そのもの。「ファン―の映画」「―の資料」}	{"must see; must (e.g. read book)"}	\N	\N	\N
引越し	ひっこし	{}	{"moving (dwelling; office; etc.); changing residence"}	\N	\N	\N
引っ越す	ひっこす	{}	{"move to (house)"}	\N	\N	\N
引っ込む	ひっこむ	{}	{"draw back; sink; cave in"}	\N	\N	\N
必死	ひっし	{}	{"inevitable death; desperation; frantic; inevitable result"}	\N	\N	\N
必至	ひっし	{}	{inevitable}	\N	\N	\N
筆者	ひっしゃ	{}	{"writer; author"}	\N	\N	\N
髭	ひげ	{人、特に男性の口の上やあご・ほおのあたりに生える毛。}	{"facial hair"}	\N	{髯,鬚}	\N
久々	ひさびさ	{長い間とだえていたさま。前のときから、長い時間が経過したさま。久しぶり。「―に訪れたチャンス」「―のヒット曲」}	{"after a long time"}	\N	{久久}	\N
引く	ひく	{"",（ふつう「碾く」と書く）ひき臼 (うす) を回して穀類をすり砕く。「豆を―・く」}	{"minus; pull; draw; play (string instr.)","grind (beans)"}	\N	{曳く,牽く}	\N
必修	ひっしゅう	{}	{"required (subject)"}	\N	\N	\N
必需品	ひつじゅひん	{なくてはならない品物。「田舎では車は―だ」「生活―」}	{"necessities; necessary article; requisite; essential"}	\N	\N	\N
必然	ひつぜん	{}	{"inevitable; necessary"}	\N	\N	\N
匹敵	ひってき	{}	{"comparing with; match; rival; equal"}	\N	\N	\N
引っ張る	ひっぱる	{}	{"pull; draw; stretch; drag"}	\N	\N	\N
必要	ひつよう	{}	{necessary}	\N	\N	\N
否定	ひてい	{}	{"negation; denial; repudiation"}	\N	\N	\N
酷い	ひどい	{}	{"cruel; awful; severe; very bad; serious; terrible; heavy; violent"}	\N	\N	\N
一息	ひといき	{}	{"puffy; a breath; a pause; an effort"}	\N	\N	\N
単	ひとえ	{}	{"one layer; single"}	\N	\N	\N
人柄	ひとがら	{}	{"personality; character; personal appearance; gentility"}	\N	\N	\N
人込み	ひとごみ	{}	{"crowd of people"}	\N	\N	\N
一頃	ひところ	{}	{"once; some time ago"}	\N	\N	\N
人差指	ひとさしゆび	{}	{"index finger"}	\N	\N	\N
等しい	ひとしい	{}	{"equal; similar; like; equivalent"}	\N	\N	\N
人質	ひとじち	{交渉を有利にするために、特定の人の身柄を拘束すること。また、拘束された人。}	{hostage}	\N	\N	\N
一筋	ひとすき	{}	{"a line; earnestly; blindly; straightforwardly"}	\N	\N	\N
一つ	ひとつ	{}	{one}	\N	\N	\N
一月	ひとつき	{}	{"one month"}	\N	\N	\N
一通り	ひととおり	{}	{"ordinary; usual; in general; briefly"}	\N	\N	\N
人通り	ひとどおり	{}	{"pedestrian traffic"}	\N	\N	\N
一まず	ひとまず	{}	{"for the present; once; in outline"}	\N	\N	\N
瞳	ひとみ	{}	{"eye; pupil (of eye)"}	\N	\N	\N
一休み	ひとやすみ	{}	{rest}	\N	\N	\N
独り	ひとり	{}	{"alone; unmarried"}	\N	\N	\N
日取り	ひどり	{}	{"fixed date; appointed day"}	\N	\N	\N
独り言	ひとりごと	{}	{"soliloquy; monologue; speaking to oneself"}	\N	\N	\N
一人でに	ひとりでに	{}	{"by itself; automatically; naturally"}	\N	\N	\N
一人一人	ひとりひとり	{}	{"one by one; each; one at a time"}	\N	\N	\N
日向	ひなた	{}	{"sunny place; in the sun"}	\N	\N	\N
避難	ひなん	{}	{"taking refuge; finding shelter"}	\N	\N	\N
非難	ひなん	{}	{"blame; attack; criticism"}	\N	\N	\N
皮肉	ひにく	{}	{"cynicism; sarcasm; irony; satire"}	\N	\N	\N
日日	ひにち	{}	{"every day; daily; day after day"}	\N	\N	\N
捻る	ひねる	{}	{"turn (a switch) on or off; twist; puzzle over"}	\N	\N	\N
日の入り	ひのいり	{}	{sunset}	\N	\N	\N
日の出	ひので	{}	{sunrise}	\N	\N	\N
日の丸	ひのまる	{}	{"the Japanese flag"}	\N	\N	\N
火花	ひばな	{}	{spark}	\N	\N	\N
批判	ひはん	{物事に検討を加えて、判定・評価すること。「ー力を養う」}	{"criticism; comment"}	\N	\N	\N
日々	ひび	{}	{"every day; daily; day after day"}	\N	\N	\N
響き	ひびき	{}	{"echo; sound; reverberation; noise"}	\N	\N	\N
響く	ひびく	{}	{"to sound; echo; reverberate"}	\N	\N	\N
批評	ひひょう	{}	{"criticism; review; commentary"}	\N	\N	\N
皮膚	ひふ	{}	{skin}	\N	\N	\N
隙	ひま	{}	{"chance; opportunity; chink (on an armor)"}	\N	\N	\N
肥満	ひまん	{からだが普通以上にふとること。「ーしないように運動する」「ー体」}	{obese}	\N	\N	\N
秘密	ひみつ	{}	{"secret; secrecy"}	\N	\N	\N
姫	ひめ	{}	{princess}	\N	\N	\N
悲鳴	ひめい	{}	{"shriek; scream"}	\N	\N	\N
冷やかす	ひやかす	{}	{"to banter; to make fun of; to jeer at; to cool; to refrigerate"}	\N	\N	\N
百	ひゃく	{}	{"100; hundred"}	\N	\N	\N
百姓	ひゃくしょう	{農業に従事する人。農民。}	{"farming; peasant"}	\N	\N	\N
日焼け	ひやけ	{}	{sunburn}	\N	\N	\N
冷やす	ひやす	{}	{"cool; refrigerate"}	\N	\N	\N
票	ひょう	{}	{"label; ballot; ticket; sign"}	\N	\N	\N
費用	ひよう	{}	{"cost; expense"}	\N	\N	\N
評価	ひょうか	{}	{"valuation; estimation; assessment; evaluation"}	\N	\N	\N
補給	ほきゅう	{}	{"supply; supplying; replenishment"}	\N	\N	\N
百科辞典	ひゃっかじてん	{}	{encyclopedia}	\N	{百科事典}	\N
表記	ひょうき	{文字や記号を用いて書き表すこと。「現代仮名遣いで―する」}	{"referring to"}	\N	\N	\N
表現	ひょうげん	{}	{"expression; presentation; (mathematics) representation"}	\N	\N	\N
標語	ひょうご	{}	{"motto; slogan; catchword"}	\N	\N	\N
表紙	ひょうし	{}	{"front cover; binding"}	\N	\N	\N
標識	ひょうしき	{}	{"sign; mark"}	\N	\N	\N
表彰	ひょうしょう	{善行・功績などを人々の前に明らかにし、ほめたたえること。}	{"commendation; 表彰する：to award"}	\N	\N	\N
表示	ひょうじ	{はっきりと表し示すこと。「原料をラベルにーする」}	{"〔指示〕(an) indication; 〔表明〕(an) expression"}	\N	\N	\N
標準	ひょうじゅん	{}	{"standard; level"}	\N	\N	\N
表情	ひょうじょう	{}	{"facial expression"}	\N	\N	\N
評判	ひょうばん	{}	{"fame; reputation; popularity; arrant"}	\N	\N	\N
標本	ひょうほん	{}	{"example; specimen"}	\N	\N	\N
表面	ひょうめん	{}	{"surface; outside; face; appearance"}	\N	\N	\N
漂流	ひょうりゅう	{風や潮のままに海上をただよい流れること。「ボートで―する」}	{drifting}	\N	\N	\N
評論	ひょうろん	{}	{"criticism; critique"}	\N	\N	\N
評論家	ひょうろんか	{評論を仕事にしている人。批評家。「政治ー」}	{"critic; pundit"}	\N	\N	\N
平仮名	ひらがな	{}	{"hiragana; 47 syllables; the cursive syllabary"}	\N	\N	\N
啓く	ひらく	{知識を授ける。啓発する。「蒙 (もう) を―・く」}	{"edify; enlighten; disclose;"}	\N	\N	\N
拓く	ひらく	{未開拓の場所・土地などに手を入れて利用できるようにする。開拓する。開墾する。「山林を―・く」}	{pioneering}	\N	\N	\N
平たい	ひらたい	{}	{"flat; even; level; simple; plain"}	\N	\N	\N
比率	ひりつ	{}	{"ratio; proportion; percentage"}	\N	\N	\N
肥料	ひりょう	{}	{"manure; fertilizer"}	\N	\N	\N
昼	ひる	{}	{"noon; daytime"}	\N	\N	\N
昼御飯	ひるごはん	{}	{"lunch; midday meal"}	\N	\N	\N
昼寝	ひるね	{}	{"nap (at home); siesta"}	\N	\N	\N
昼休み	ひるやすみ	{}	{"lunch break"}	\N	\N	\N
比例	ひれい	{}	{proportion}	\N	\N	\N
広い	ひろい	{}	{"spacious; vast; wide"}	\N	\N	\N
拾う	ひろう	{}	{"pick up"}	\N	\N	\N
披露	ひろう	{手紙・文書などを開いて人に見せること。広く人に知らせること}	{"showcase; exhibition"}	\N	\N	\N
疲労	ひろう	{筋肉・神経などが、使いすぎのためにその機能を低下し、本来の働きをなしえなくなる状態。つかれ。「―が重なる」「心身ともに―する」}	{"fatigue; 〔極度の〕exhaustion"}	\N	\N	\N
広がる	ひろがる	{}	{"spread (out); extend; stretch; reach to; get around"}	\N	\N	\N
広げる	ひろげる	{}	{"spread; extend; expand; enlarge; widen; broaden; unfold; open; unroll"}	\N	\N	\N
広さ	ひろさ	{}	{extent}	\N	\N	\N
広場	ひろば	{}	{plaza}	\N	\N	\N
広まる	ひろまる	{}	{"to spread; to be propagated"}	\N	\N	\N
広める	ひろめる	{}	{"broaden; propagate"}	\N	\N	\N
貧困	ひんこん	{}	{"poverty; lack"}	\N	\N	\N
品質	ひんしつ	{}	{quality}	\N	\N	\N
貧弱	ひんじゃく	{}	{"poor; meagre; insubstantial"}	\N	\N	\N
品種	ひんしゅ	{}	{"brand; kind; description"}	\N	\N	\N
頻繁	ひんぱん	{しきりに行われること。しばしばであること。また、そのさま。「―に手紙をよこす」「車の往来が―な通り」}	{frequency}	\N	\N	\N
穂	ほ	{}	{"ear (of plant); head (of plant)"}	\N	\N	\N
保育	ほいく	{}	{"nursing; nurturing; rearing; lactation; suckling"}	\N	\N	\N
法	ほう	{}	{law}	\N	\N	\N
倣	ほう	{}	{"imitate; follow; emulate"}	\N	\N	\N
法案	ほうあん	{}	{"bill (law)"}	\N	\N	\N
崩壊	ほうかい	{}	{"collapse; decay (physics); crumbling; breaking down; caving in"}	\N	\N	\N
法学	ほうがく	{}	{"law; jurisprudence"}	\N	\N	\N
方角	ほうがく	{}	{"direction; way; compass point"}	\N	\N	\N
補強	ほきょう	{}	{"compensation; reinforcement"}	\N	\N	\N
方	ほう	{}	{side}	\N	\N	\N
飛龍	ひりゅう	{空を飛ぶという竜。}	{"flying dragon"}	\N	{飛竜}	\N
披く	ひらく	{畳んであるもの、閉じてあるものなどを広げる。「本を―・く」}	{"open (e.g. a book)"}	\N	{展く}	\N
広々	ひろびろ	{}	{"extensive; spacious"}	\N	{広広}	\N
放課後	ほうかご	{学校でその日の授業が終わったあと}	{"after school"}	\N	\N	\N
包括	ほうかつ	{}	{inclusion}	\N	\N	\N
宝器	ほうき	{}	{"treasured article or vessel; outstanding individual"}	\N	\N	\N
放棄	ほうき	{}	{"abandonment; renunciation; abdication (responsibility right)"}	\N	\N	\N
封建	ほうけん	{}	{feudalistic}	\N	\N	\N
方言	ほうげん	{}	{dialect}	\N	\N	\N
方向	ほうこう	{}	{"direction; course; way"}	\N	\N	\N
芳香	ほうこう	{かぐわしい香り。「ーを放つ」}	{"aroma; fragrance"}	\N	\N	\N
縫合	ほうごう	{縫い合わせること。特に、外科手術で外傷などで切断された患部を縫い合わせること。「切開した傷口を―する」}	{"a suture"}	\N	\N	\N
報告	ほうこく	{告げ知らせること。レポート。情報。}	{report}	\N	\N	\N
方策	ほうさく	{}	{"plan; policy"}	\N	\N	\N
豊作	ほうさく	{}	{"abundant harvest; bumper crop"}	\N	\N	\N
奉仕	ほうし	{}	{"attendance; service"}	\N	\N	\N
方式	ほうしき	{}	{"form; method; system"}	\N	\N	\N
放射	ほうしゃ	{}	{"radiation; emission"}	\N	\N	\N
放射能	ほうしゃのう	{}	{radioactivity}	\N	\N	\N
報酬	ほうしゅう	{労務または物の使用の対価として給付される金銭・物品など。報奨。給料。医師・弁護士などの}	{"reward; pay; compensation; (doctor or lawyer) fee"}	\N	\N	\N
放出	ほうしゅつ	{}	{"release; emit"}	\N	\N	\N
報じる	ほうじる	{}	{"to inform; to report"}	\N	\N	\N
方針	ほうしん	{方向；方策；計画；方位を示す磁石の針。磁針。}	{"course; policy; plan"}	\N	\N	\N
報ずる	ほうずる	{}	{"to inform; to report"}	\N	\N	\N
宝石	ほうせき	{}	{"gem; jewel"}	\N	\N	\N
包装	ほうそう	{}	{"packing; wrapping"}	\N	\N	\N
放送	ほうそう	{}	{broadcasting}	\N	\N	\N
法則	ほうそく	{}	{"law; rule"}	\N	\N	\N
包帯	ほうたい	{}	{"bandage; dressing"}	\N	\N	\N
砲台	ほうだい	{}	{cannon}	\N	\N	\N
放題	ほうだい	{常軌を逸していること。自由勝手にふるまうこと。}	{"without reserve; as much as one likes; all-you-can-..."}	\N	\N	\N
放置	ほうち	{}	{"leave as is; leave to chance; leave alone; neglect"}	\N	\N	\N
法廷	ほうてい	{}	{courtroom}	\N	\N	\N
方程式	ほうていしき	{}	{equation}	\N	\N	\N
報道	ほうどう	{}	{"information; report"}	\N	\N	\N
奉納	ほうのう	{神仏に喜んで納めてもらうために物品を供えたり、その前で芸能・競技などを行ったりすること。「絵馬をーする」「神楽 (かぐら) をーする」}	{"dedication; offering ((of))"}	\N	\N	\N
褒美	ほうび	{}	{"reward; prize"}	\N	\N	\N
豊富	ほうふ	{豊かであること。ふんだんにあること。また、そのさま。「―な天然資源」「―な知識」}	{"abundance; wealth; plenty; bounty"}	\N	\N	\N
報復	ほうふく	{復讐・仕返しをすること。返報。「敵にーする」}	{retaliation}	\N	\N	\N
方法	ほうほう	{}	{"method; process; manner; way; means; technique"}	\N	\N	\N
葬る	ほうむる	{}	{"to bury; to inter; to entomb; to consign to oblivion; to shelve"}	\N	\N	\N
方面	ほうめん	{}	{"direction; district; field (of study)"}	\N	\N	\N
訪問	ほうもん	{}	{"call; visit"}	\N	\N	\N
放り込む	ほうりこむ	{}	{"to throw into"}	\N	\N	\N
放り出す	ほうりだす	{}	{"to throw out; to fire; to expel; to give up; to abandon; to neglect"}	\N	\N	\N
法律	ほうりつ	{社会秩序を維持するために強制される規範。国会の議決を経て制定される法の一形式。法。}	{"law; jurisdiction"}	\N	\N	\N
放流	ほうりゅう	{せき止めた水を放出すること。「貯水池の水を―する」}	{"〔水の〕(a) discharge; released"}	\N	\N	\N
放る	ほうる	{}	{"let go; abandon; leave undone; throw; toss; fling"}	\N	\N	\N
法蓮草	ほうれんそう	{}	{spinach}	\N	\N	\N
飽和	ほうわ	{}	{saturation}	\N	\N	\N
頬	ほお	{}	{"cheek (of face)"}	\N	\N	\N
保温	ほおん	{}	{"retaining warmth; keeping heat in; heat insulation"}	\N	\N	\N
zほか	zほか	{に添えて}	{"in addition"}	\N	\N	\N
捕獲	ほかく	{}	{"capture; seizure"}	\N	\N	\N
朗らか	ほがらか	{}	{"brightness; cheerfulness; melodious"}	\N	\N	\N
保管	ほかん	{}	{"charge; custody; safekeeping; deposit; storage"}	\N	\N	\N
包丁	ほうちょう	{}	{"kitchen knife; carving knife"}	\N	{庖丁}	\N
北西	ほくせい	{}	{north-west}	\N	\N	\N
北斗	ほくと	{「北斗七星」の略。「泰山 (たいざん) ー」}	{"((米)) the Big Dipper，((英)) the Plough"}	\N	\N	\N
捕鯨	ほげい	{}	{"whaling; whale fishing"}	\N	\N	\N
保健	ほけん	{}	{"health preservation; hygiene; sanitation"}	\N	\N	\N
保険	ほけん	{}	{"insurance; guarantee"}	\N	\N	\N
矛	ほこ	{}	{halbard}	\N	\N	\N
誇り	ほこり	{}	{pride}	\N	\N	\N
誇る	ほこる	{}	{"to boast of; to be proud of"}	\N	\N	\N
綻びる	ほころびる	{}	{"to come apart at the seams; to begin to open; to smile broadly"}	\N	\N	\N
星	ほし	{}	{star}	\N	\N	\N
欲しい	ほしい	{}	{"wanted; wished for; in need of; desired"}	\N	\N	\N
干し葡萄	ほしぶどう	{ブドウの実を干したもの。レーズン。}	{raisin}	\N	\N	\N
干し物	ほしもの	{}	{"dried washing (clothes)"}	\N	\N	\N
保守	ほしゅ	{}	{"conservative; maintaining"}	\N	\N	\N
補充	ほじゅう	{}	{"supplementation; supplement; replenishment; replenishing"}	\N	\N	\N
補助	ほじょ	{不足しているところを補い助けること。また、その助けとなるもの。「生活費を―する」}	{"assistance; support; aid; auxiliary"}	\N	\N	\N
補償	ほしょう	{損失を補って、つぐなうこと。特に、損害賠償として、財産や健康上の損失を金銭でつぐなうこと。「労働災害を―する」「公害―裁判」「―金」}	{"compensation; reparation"}	\N	\N	\N
干す	ほす	{}	{"to air; dry; desiccate; drain (off); drink up"}	\N	\N	\N
細い	ほそい	{}	{"thin; slender; fine"}	\N	\N	\N
舗装	ほそう	{}	{"pavement; road surface"}	\N	\N	\N
補足	ほそく	{}	{"supplement; complement"}	\N	\N	\N
保存	ほぞん	{}	{"preservation; conservation; storage; maintenance"}	\N	\N	\N
北極	ほっきょく	{}	{"North Pole"}	\N	\N	\N
発作	ほっさ	{}	{"fit; spasm"}	\N	\N	\N
頬っぺた	ほっぺた	{}	{cheek}	\N	\N	\N
程	ほど	{}	{"limit; the more ~ the more"}	\N	\N	\N
歩道	ほどう	{}	{"footpath; walkway; sidewalk"}	\N	\N	\N
施し	ほどこし	{恵み与えること。また、そのもの。布施 (ふせ) 。施与。「―を受ける」「―を乞う」}	{"〔行為〕almsgiving; charity; 〔物〕alms ((単複同形))，((口)) a handout"}	\N	\N	\N
殆ど	ほとんど	{}	{"mostly; almost"}	\N	\N	\N
炎	ほのお	{}	{"flame; blaze"}	\N	\N	\N
保母	ほぼ	{}	{"day care worker in a kindergarten nursery school etc."}	\N	\N	\N
微笑む	ほほえむ	{}	{"to smile"}	\N	\N	\N
褒める	ほめる	{}	{"to praise"}	\N	\N	\N
保養	ほよう	{}	{"health preservation; recuperation; recreation"}	\N	\N	\N
捕吏	ほり	{}	{constable}	\N	\N	\N
堀	ほり	{}	{"moat; canal"}	\N	\N	\N
捕虜	ほりょ	{}	{"prisoner (of war)"}	\N	\N	\N
掘る	ほる	{}	{"dig; excavate"}	\N	\N	\N
彫る	ほる	{}	{"carve; engrave; sculpture; chisel"}	\N	\N	\N
幌	ほろ	{}	{hood}	\N	\N	\N
滅びる	ほろびる	{}	{"to be ruined; to go under; to perish; to be destroyed"}	\N	\N	\N
滅ぼす	ほろぼす	{}	{"to destroy; to overthrow; to wreck; to ruin"}	\N	\N	\N
本	ほん	{}	{book}	\N	\N	\N
本格	ほんかく	{}	{"propriety; fundamental rules"}	\N	\N	\N
本館	ほんかん	{}	{"main building"}	\N	\N	\N
本気	ほんき	{}	{"seriousness; truth; sanctity"}	\N	\N	\N
本質	ほんしつ	{}	{"essence; true nature; reality"}	\N	\N	\N
奔走	ほんそう	{忙しく走り回ること。物事が順調に運ぶようにあちこちかけまわって努力すること。「募金集めにーする」}	{"make every effort (to); busies himself with; played an active part (in)"}	\N	\N	\N
乾	ほし	{}	{"dried; cured"}	\N	\N	\N
解く	ほどく	{結んだり、縫ったり、もつれたりしたものをときはなす。とく。「荷物を―・く」}	{"to unfasten"}	\N	\N	\N
仏	ほとけ	{}	{"Buddha; merciful person; Buddhist image; the dead"}	\N	\N	\N
辺り	ほとり	{}	{"(in the) neighbourhood; vicinity; nearby"}	\N	\N	\N
保証	ほしょう	{}	{"guarantee; security; assurance; pledge; warranty"}	\N	{保障}	\N
捕捉	ほそく	{とらえること。つかまえること。「賊を―する」「意図を―する」}	{"capture; seizure"}	\N	\N	\N
保護	ほご	{"1 外からの危険・脅威・破壊などからかばい守ること。「傷口を―する」「森林を―する」","2 応急の救護を要する理由のあるとき、警察署などに留め置くこと。「迷子を―する」"}	{"〔守ること〕protection; 〔警察による〕protective custody; 〜する protect; 〔主に教会が庇護する〕give sanctuary ((to)); 〔面倒をみる〕take care of","〔保存，維持〕preservation; conservation (▼国家などによる自然保護に使われることが多い) ⇒ほぞん(保存)"}	\N	\N	\N
本体	ほんたい	{}	{"substance; real form; object of worship"}	\N	\N	\N
本棚	ほんだな	{}	{bookshelves}	\N	\N	\N
本当	ほんとう	{偽りや見せかけでなく、実際にそうであること。「一見難しそうだが―は易しい」「うわさは―だ」}	{"truth; reality"}	\N	\N	\N
本人	ほんにん	{}	{"the person himself"}	\N	\N	\N
本音	ほんね	{}	{"real intention; motive"}	\N	\N	\N
本の	ほんの	{}	{"mere; only; just"}	\N	\N	\N
本能	ほんのう	{}	{instinct}	\N	\N	\N
本場	ほんば	{}	{"home; habitat; center; best place; genuine"}	\N	\N	\N
本部	ほんぶ	{}	{HQ}	\N	\N	\N
本文	ほんぶん	{}	{"text (of document); body (of letter)"}	\N	\N	\N
本名	ほんみょう	{}	{"real name"}	\N	\N	\N
本物	ほんもの	{}	{"genuine article"}	\N	\N	\N
翻訳	ほんやく	{}	{translate}	\N	\N	\N
本来	ほんらい	{}	{"essentially; naturally; by nature; in (and of) itself; originally"}	\N	\N	\N
本塁打	ほんるいだ	{}	{"home run"}	\N	\N	\N
不正	ふせい	{正しくないこと。正義に反する。道義に反する。法律に反する。}	{"injustice; unjust; dishonest; unlawful; illegal"}	\N	\N	\N
普通	ふつう	{特に変わっていないこと。；通常}	{"usual; common"}	\N	\N	\N
不凍液	ふとうえき	{"不凍剤。 アンチフリーズ"}	{antifreeze}	\N	\N	\N
歩	ふ	{}	{"pawn (in chess or shogi)"}	\N	\N	\N
不意	ふい	{}	{"sudden; abrupt; unexpected; unforeseen"}	\N	\N	\N
封	ふう	{}	{seal}	\N	\N	\N
風景	ふうけい	{}	{scenery}	\N	\N	\N
封鎖	ふうさ	{}	{"blockade; freezing (funds)"}	\N	\N	\N
封じる	ふうじる	{}	{"to seal (letter) (2) to prevent; to forbid; to block"}	\N	\N	\N
風習	ふうしゅう	{}	{custom}	\N	\N	\N
風速	ふうそく	{}	{"wind speed"}	\N	\N	\N
風船	ふうせん	{}	{balloon}	\N	\N	\N
風俗	ふうぞく	{}	{"manners; customs; sex service; sex industry"}	\N	\N	\N
風土	ふうど	{}	{"natural features; topography; climate; spiritual features"}	\N	\N	\N
封筒	ふうとう	{}	{envelope}	\N	\N	\N
夫婦	ふうふ	{}	{"married couple; spouses; husband and wife; couple; pair"}	\N	\N	\N
不運	ふうん	{}	{"unlucky; misfortune; bad luck; fate"}	\N	\N	\N
笛	ふえ	{}	{flute}	\N	\N	\N
増える	ふえる	{}	{increase}	\N	\N	\N
殖える	ふえる	{}	{"increase; multiply"}	\N	\N	\N
不可	ふか	{}	{"wrong; bad; improper; unjustifiable; inadvisable"}	\N	\N	\N
不快感	ふかいかん	{不愉快に思う気持ち。「―をあらわにする」「―をつのらせる」「―が軽減される」}	{discomfort}	\N	\N	\N
不可欠	ふかけつ	{}	{"indispensable; essential"}	\N	\N	\N
深さ	ふかさ	{ふかいこと。また、その度合い。}	{〔穴などの〕depth}	\N	\N	\N
更かす	ふかす	{夜遅くまで起きている。夜ふかしをする。「議論で夜をー・す」}	{"stay up 「till late [at night]"}	\N	\N	\N
不可能	ふかのう	{}	{impossible}	\N	\N	\N
深まる	ふかまる	{}	{"deepen; heighten; intensify"}	\N	\N	\N
不規則	ふきそく	{}	{"irregularity; unsteadiness; disorderly"}	\N	\N	\N
不吉	ふきつ	{縁起が悪いこと。不運の兆しがあること。また、そのさま。不祥。「―な予感がする」「―な夢」}	{"ominous; sinister; bad luck; ill omen; inauspiciousness"}	\N	\N	\N
普及	ふきゅう	{}	{"diffusion; spread"}	\N	\N	\N
不況	ふきょう	{}	{"recession; depression; slump"}	\N	\N	\N
布巾	ふきん	{}	{"tea-towel; dish cloth"}	\N	\N	\N
付近	ふきん	{}	{"neighbourhood; vicinity; environs"}	\N	\N	\N
吹く	ふく	{}	{"blow (wind; etc.); emit"}	\N	\N	\N
福	ふく	{}	{"good fortune"}	\N	\N	\N
服	ふく	{}	{clothes}	\N	\N	\N
拭く	ふく	{}	{"wipe; dry"}	\N	\N	\N
復旧	ふくきゅう	{}	{"restoration; restitution; rehabilitation"}	\N	\N	\N
複合	ふくごう	{}	{"composite; complex"}	\N	\N	\N
不当	ふとう	{正当・適当でないこと。道理に合わないこと。「―な手段」「―解雇」}	{unjust}	\N	\N	\N
不安	ふあん	{気がかりで落ち着かないこと。心配なこと。また、そのさま。気がかり。「―を抱く」「―に襲われる」「―な毎日」「夜道は―だ」}	{"〔心配〕uneasiness (about); anxiety (about); worry (about/over)〔不安定〕insecurity〔社会的動揺〕unrest"}	{名,形動}	\N	\N
深める	ふかめる	{物事の程度を深くする。「親睦 (しんぼく) を―・める」「改めて認識を―・める」}	{"to deepen; to heighten; to intensify"}	\N	\N	\N
複雑	ふくざつ	{}	{complicated}	\N	\N	\N
副詞	ふくし	{}	{adverb}	\N	\N	\N
福祉	ふくし	{公的配慮によって社会の成員が等しく受けることのできる安定した生活環境。「公共ー」「ー事業」}	{"welfare; well-being"}	\N	\N	\N
複写	ふくしゃ	{}	{"copy; duplicate"}	\N	\N	\N
復習	ふくしゅう	{}	{review}	\N	\N	\N
復讐	ふくしゅう	{かたきうちをする。仕返しをする。報復。「―する機会を待つ」}	{"revenge; 〔激しい復しゅう〕vengeance"}	\N	\N	\N
腹心	ふくしん	{どんなことでも打ち明けて相談できること。また、その人。「―の部下」}	{"〔信頼している人〕one's confidant; 〔女性の〕one's confidante"}	\N	\N	\N
複数	ふくすう	{}	{"plural; multiple"}	\N	\N	\N
服装	ふくそう	{}	{garments}	\N	\N	\N
含む	ふくむ	{}	{"hold in the mouth; bear in mind; understand; cherish; harbor; contain; comprise; have; hold; include; embrace; be full of"}	\N	\N	\N
含める	ふくめる	{}	{"include; instruct; make one understand; put in one´s mouth"}	\N	\N	\N
覆面	ふくめん	{}	{"mask; veil; disguise"}	\N	\N	\N
膨らます	ふくらます	{}	{"swell; expand; inflate; bulge"}	\N	\N	\N
膨らむ	ふくらむ	{}	{"expand; get big; become inflated"}	\N	\N	\N
膨れる	ふくれる	{}	{"to get cross; to get sulky; to swell (out); to expand; to be inflated; to distend; to bulge"}	\N	\N	\N
袋	ふくろ	{}	{"bag; sack"}	\N	\N	\N
不景気	ふけいき	{}	{"business recession; hard times; depression; gloom; sullenness; cheerlessness"}	\N	\N	\N
不潔	ふけつ	{}	{"unclean; dirty; filthy; impure"}	\N	\N	\N
更ける	ふける	{}	{"get late; advance; wear on;"}	\N	\N	\N
老ける	ふける	{}	{"to age"}	\N	\N	\N
不幸	ふこう	{}	{"unhappiness; sorrow; misfortune; disaster; accident; death"}	\N	\N	\N
富豪	ふごう	{}	{"wealthy person; millionaire"}	\N	\N	\N
符号	ふごう	{}	{"sign; mark; symbol"}	\N	\N	\N
布告	ふこく	{}	{"edict; ordinance; proclamation"}	\N	\N	\N
負債	ふさい	{}	{"debt; liabilities"}	\N	\N	\N
夫妻	ふさい	{}	{"man and wife; married couple"}	\N	\N	\N
不在	ふざい	{}	{absence}	\N	\N	\N
塞がる	ふさがる	{}	{"be plugged up; be shut up"}	\N	\N	\N
塞ぐ	ふさぐ	{}	{"stop up; close up; block (up); occupy; fill up; take up; stand in another´s way; plug up; shut up"}	\N	\N	\N
不山戯る	ふざける	{}	{"to romp; to gambol; to frolic; to joke; to make fun of; to flirt"}	\N	\N	\N
巫山戯る	ふざける	{}	{"〔戯れる〕play (with); 〔子供や動物がはね回って〕frisk; frolic"}	\N	\N	\N
不思議	ふしぎ	{}	{"wonder; miracle; strange; mystery; marvel; curiosity"}	\N	\N	\N
不死鳥	ふしちょう	{}	{phoenix}	\N	\N	\N
不自由	ふじゆう	{}	{"discomfort; disability; inconvenience; destitution"}	\N	\N	\N
不順	ふじゅん	{}	{"irregularity; unseasonableness"}	\N	\N	\N
負傷	ふしょう	{}	{"injury; wound"}	\N	\N	\N
不祥事	ふしょうじ	{関係者にとって不都合な事件、事柄。類語：凶事・弔事「社員がーを起こす」}	{"scandal; a disgraceful [deplorable] affair"}	\N	\N	\N
不振	ふしん	{}	{"dullness; depression; slump; stagnation"}	\N	\N	\N
夫人	ふじん	{}	{"wife; Mrs.; madam"}	\N	\N	\N
婦人	ふじん	{}	{"woman; female"}	\N	\N	\N
伏す	ふす	{腹ばいになる。また、地面にひざをつくなどして頭を深く下げる。「地にー・す」}	{"bow down; bend down"}	\N	\N	\N
防ぐ	ふせぐ	{}	{"defend (against); protect; prevent"}	\N	\N	\N
不足	ふそく	{}	{"insufficiency; shortage; deficiency; lack"}	\N	\N	\N
双子	ふたご	{}	{"twins; a twin"}	\N	\N	\N
怒り	いかり	{}	{"anger; hatred"}	\N	\N	\N
節	ふし	{}	{"node; section; occasion; time"}	\N	\N	\N
脹れ	ふくれ	{ふくれること。また、ふくれたところや、もの。「水―」「火―」}	{"bulge; bump"}	\N	{膨れ}	\N
附属	ふぞく	{}	{"attached; belonging; affiliated; annexed; associated; subordinate; incidental; dependent; auxiliary"}	\N	{付属}	\N
相応しい	ふさわしい	{似つかわしい。つり合っている。「収入に―・い生活」「子供に―・くない遊び」「あの男性なら彼女に―・い」}	{"〔適している〕be suitable ((for)); be fit ((for a thing; to do)); 〔よく似合う〕become; 〔値する〕deserve; be worthy ((of))"}	\N	\N	\N
蓋	ふた	{}	{"〔箱・器などの〕a lid ((of a pot","a jar)); 〔びんなどの〕the cap ((of a bottle)); 〔覆い〕a cover; 〔さざえ・たにし類の甲〕an operculum"}	\N	\N	\N
不審	ふしん	{疑わしく思うこと。疑わしく思えること。また、そのさま。疑い。疑問。疑惑。疑念。疑心。「証言に―な点が多い」「お吉の居ぬを―して何所へと問えば」}	{"incomplete understanding; doubt; question; distrust; suspicion; strangeness; infidelity"}	\N	\N	\N
再び	ふたたび	{}	{"again; once more; a second time"}	\N	\N	\N
二つ	ふたつ	{}	{two}	\N	\N	\N
負担	ふたん	{荷物を肩や背にかつぐこと。また、その荷物。義務・責任などを引き受けること。また、その義務・責任など。「費用は全員でーする」}	{"burden; charge; responsibility"}	\N	\N	\N
普段	ふだん	{}	{"usually; habitually; ordinarily; always"}	\N	\N	\N
不調	ふちょう	{}	{"bad condition; not to work out (ie a deal); disagreement; break-off; disorder; slump; out of form"}	\N	\N	\N
不通	ふつう	{}	{"suspension; interruption; stoppage; tie-up; cessation"}	\N	\N	\N
二日	ふつか	{}	{"second day of the month; two days"}	\N	\N	\N
復活	ふっかつ	{}	{"revival (e.g. musical); restoration"}	\N	\N	\N
復興	ふっこう	{}	{"revival; renaissance; reconstruction"}	\N	\N	\N
払拭	ふっしょく	{はらいぬぐい去ること。すっかり取り除くこと。一掃。ふっしき。「因習をーする」「保守色をーする」}	{"wiping; sweeping away"}	\N	\N	\N
沸騰	ふっとう	{}	{"boiling; seething"}	\N	\N	\N
筆	ふで	{}	{"writing brush"}	\N	\N	\N
太い	ふとい	{}	{"fat; thick"}	\N	\N	\N
不動産	ふどうさん	{}	{"real estate"}	\N	\N	\N
不透明	ふとうめい	{透明でないこと。事の成り行きや実状などが、はっきり示されないこと。また、そのさま。「金の流れがーだ」}	{opaque}	\N	\N	\N
太る	ふとる	{}	{"grow fat"}	\N	\N	\N
布団	ふとん	{}	{futon}	\N	\N	\N
船便	ふなびん	{}	{"surface mail (ship)"}	\N	\N	\N
赴任	ふにん	{}	{"(proceeding to) new appointment"}	\N	\N	\N
腐敗	ふはい	{}	{"decay; depravity"}	\N	\N	\N
不評	ふひょう	{}	{"bad reputation; disgrace; unpopularity"}	\N	\N	\N
吹雪	ふぶき	{}	{"snow storm"}	\N	\N	\N
不服	ふふく	{}	{"dissatisfaction; discontent; disapproval; objection; complaint; protest; disagreement"}	\N	\N	\N
不平	ふへい	{}	{"complaint; discontent; dissatisfaction"}	\N	\N	\N
普遍	ふへん	{}	{"universality; ubiquity; omnipresence"}	\N	\N	\N
不法	ふほう	{法律従わない}	{illegal}	\N	\N	\N
不法滞在	ふほうたいざい	{一般に人が出入国関係法令に違反した状態で外国に滞在している状態をさす。不法滞留。}	{"illegal stay"}	\N	\N	\N
不法滞留	ふほうたいりゅう一	{般に人が出入国関係法令に違反した状態で外国に滞在している状態をさす。不法滞在。}	{"illegal stay"}	\N	\N	\N
不法滞在者	ふほうたいざいしゃ	{}	{"illegal immigrant"}	\N	\N	\N
踏まえる	ふまえる	{}	{"to be based on; to have origin in"}	\N	\N	\N
不満	ふまん	{もの足りなく、満足しないこと。また、そのさまやそう思う気持ち。不満足。「―を口にする」「―な点が残る」「欲求―」}	{"dissatisfaction; displeasure; discontent; complaints; unhappiness"}	\N	\N	\N
不満気	ふまんげ	{不満お様子}	{discontent;}	\N	\N	\N
不味	ふみ	{}	{distaste}	\N	\N	\N
踏切	ふみきり	{}	{"railway crossing; level crossing; starting line; scratch; crossover"}	\N	\N	\N
踏む	ふむ	{}	{"step on"}	\N	\N	\N
不明	ふめい	{}	{"unknown; obscure; indistinct; uncertain; ambiguous; ignorant; lack of wisdom; anonymous; unidentified"}	\N	\N	\N
麓	ふもと	{}	{"foot; the bottom; base (of a mountain)"}	\N	\N	\N
冬	ふゆ	{}	{winter}	\N	\N	\N
富裕	ふゆう	{財産が多くあって、生活が豊かなこと。また、そのさま。裕福。「―な生活」}	{"wealth; ⇒ゆうふく(裕福)　affluence [ǽfluns]; wealth"}	\N	\N	\N
扶養	ふよう	{}	{"support; maintenance"}	\N	\N	\N
不利	ふり	{}	{"disadvantage; handicap; unfavorable; drawback"}	\N	\N	\N
振り	ふり	{}	{"pretence; show; appearance"}	\N	\N	\N
会議	かいぎ	{}	{meeting}	\N	\N	\N
不便	ふべん	{}	{inconvenience}	\N	\N	\N
縁	ふち	{}	{"(surrounding) edge"}	\N	\N	\N
増やす	ふやす	{}	{"to increase; to add to; to augment"}	\N	{殖やす}	\N
船	ふね	{}	{"ship; boat; watercraft; shipping; vessel; steamship"}	\N	{舟}	\N
振り返る	ふりかえる	{後方へ顔を向ける。振り向く。「背後の物音に―・る」}	{"〔振り向く〕turn around [round]; look back"}	\N	\N	\N
振り仮名	ふりがな	{}	{"hiragana over kanji; pronunciation key"}	\N	\N	\N
振り込む	ふりこむ	{}	{"Make a payment via bank deposit transfer"}	\N	\N	\N
振り出し	ふりだし	{}	{"outset; starting point; drawing or issuing (draft)"}	\N	\N	\N
浮力	ふりょく	{}	{"buoyancy; floating power"}	\N	\N	\N
降る	ふる	{}	{"to precipitate; to fall (e.g. rain)"}	\N	\N	\N
振る	ふる	{}	{"wave; shake; swing; sprinkle; cast (actor); allocate (work)"}	\N	\N	\N
古い	ふるい	{}	{"old (not person); aged; ancient; antiquated; stale; threadbare; outmoded; obsolete article"}	\N	\N	\N
震える	ふるえる	{}	{"shiver; shake; quake"}	\N	\N	\N
故郷	ふるさと	{}	{"hometown; old town"}	\N	\N	\N
振舞う	ふるまう	{}	{"behave; conduct oneself; entertain"}	\N	\N	\N
震わせる	ふるわせる	{}	{"to be shaking; to be trembling"}	\N	\N	\N
触れる	ふれる	{}	{"touch; be touched; touch on a subject; feel; violate (law; copyright; etc.); perceive; be moved (emotionally)"}	\N	\N	\N
風呂	ふろ	{}	{bath}	\N	\N	\N
付録	ふろく	{}	{"appendix; supplement"}	\N	\N	\N
風呂敷	ふろしき	{}	{"wrapping cloth; cloth wrapper"}	\N	\N	\N
雰囲気	ふんいき	{}	{"atmosphere (e.g. musical); mood; ambience"}	\N	\N	\N
噴火	ふんか	{}	{eruption}	\N	\N	\N
憤慨	ふんがい	{}	{"indignation; resentment"}	\N	\N	\N
紛失	ふんしつ	{}	{"losing something"}	\N	\N	\N
噴出	ふんしゅつ	{}	{"spewing; gushing; spouting; eruption; effusion"}	\N	\N	\N
噴水	ふんすい	{}	{"water fountain"}	\N	\N	\N
紛争	ふんそう	{}	{"dispute; trouble; strife"}	\N	\N	\N
奮闘	ふんとう	{}	{"hard struggle; strenuous effort"}	\N	\N	\N
粉末	ふんまつ	{}	{"fine powder"}	\N	\N	\N
噴霧	ふんむ	{}	{spray}	\N	\N	\N
噴霧器	ふんむき	{液体を霧状にしてふき出させて散布する器具。スプレー。}	{sprayer}	\N	\N	\N
胃	い	{}	{stomach}	\N	\N	\N
依	い	{}	{"depending on"}	\N	\N	\N
慰安	いあん	{心をなぐさめ、労をねぎらうこと。また、そのような事柄。「従業員を―する」「―旅行」}	{"consolation; comfort; recreation"}	\N	\N	\N
言う通り	いうどおり	{言葉による指示に沿う・従うさまを意味する表現。}	{"as (you) said; according to said (thing)"}	\N	\N	\N
伊井	いい	{}	{"that one; Italy"}	\N	\N	\N
良い	いい	{}	{good}	\N	\N	\N
言い方	いいかた	{話のしかた。言葉づかい。言いよう。「持って回ったー」「もう少し何とかーがあったろうに」}	{"expression; saying; way of speech"}	\N	\N	\N
言い出す	いいだす	{}	{"start talking; propose; suggest; break the ice"}	\N	\N	\N
言い付ける	いいつける	{}	{"tell; tell on (someone); to order; to charge; to direct"}	\N	\N	\N
言い訳	いいわけ	{}	{"excuse; explanation"}	\N	\N	\N
委員	いいん	{}	{"committee member"}	\N	\N	\N
委員会	いいんかい	{上位の合議体のために作業する、委員によって構成される組織体。また、その会議。}	{"a committee ((on)); 〔特に政府任命の〕a commission on; a board; 〔会議〕a committee meeting"}	\N	\N	\N
言う	いう	{}	{"to say"}	\N	\N	\N
家	いえ	{}	{"house; family"}	\N	\N	\N
家出	いえで	{}	{"running away from home; leaving home"}	\N	\N	\N
硫黄	いおう	{}	{"sulfur，(英) sulphur (記号S)"}	\N	\N	\N
以下	いか	{}	{"~ or less than?not more than"}	\N	\N	\N
如何	いかが	{}	{"how; in what way"}	\N	\N	\N
威嚇	いかく	{}	{"threat; malice"}	\N	\N	\N
医学	いがく	{}	{"medical science"}	\N	\N	\N
生かす	いかす	{生き返らせる}	{"spare a person's life; bring ((a person)) back to life; revive ((a person)); make use of; utilize"}	\N	\N	\N
如何に	いかに	{}	{"how?; in what way?; how much?; however; whatever"}	\N	\N	\N
分	ふん	{}	{minute}	\N	\N	\N
意外	いがい	{考えていた状態と非常に違っていること。また、そのさま。思いのほか。案外。思いがけない。「事件は―な展開を見せた」「―に背が高い」}	{"unexpected; surprising 〜な unexpected; surprising"}	{名,形動}	\N	\N
以外	いがい	{}	{"except for; other than"}	\N	\N	\N
紛糾	ふんきゅう	{意見や主張などが対立してもつれること。ごたごた。紛乱。紛擾。「予算委員会が―する」}	{"（複雑化）complication; confusion; a tangle"}	{名,スル}	\N	\N
遺憾	いかん	{反省}	{resentment}	\N	\N	\N
胃癌	いがん	{胃に発生する悪性腫瘍 (しゅよう) 。初期には自覚症状がないが、進行するにつれ食欲不振や胃の不快感から、しだいに吐血・下血などの症状がみられるようになる。}	{"stomach cancer"}	\N	\N	\N
息	いき	{}	{"breath; tone"}	\N	\N	\N
行き	いき	{}	{going}	\N	\N	\N
粋	いき	{}	{"chic; style; purity; essence"}	\N	\N	\N
遺棄	いき	{捨てて顧みないこと。置き去りにすること。委棄。「死体を―する」}	{"desertation; abandoning"}	\N	\N	\N
意義	いぎ	{}	{"meaning; significance"}	\N	\N	\N
異議	いぎ	{}	{"objection; dissent; protest"}	\N	\N	\N
生き生き	いきいき	{}	{"vividly; lively"}	\N	\N	\N
勢い	いきおい	{}	{"force; vigor; energy; spirit; life; authority; influence; power; might; tendency; necessarily"}	\N	\N	\N
域外	いきがい	{}	{"outside the area"}	\N	\N	\N
意気込む	いきごむ	{}	{"to be enthusiastic about"}	\N	\N	\N
経緯	いきさつ	{}	{"details; whole story; sequence of events; particulars; how it started; how things got this way; complications; position"}	\N	\N	\N
行き違い	いきちがい	{}	{"misunderstanding; estrangement; disagreement; crossing without meeting; going astray"}	\N	\N	\N
憤り	いきどおり	{立腹。憤慨。「―を覚える」}	{"indignation; resentment; anger"}	\N	\N	\N
憤る	いきどおる	{気持ちがすっきりしないで苦しむ。「―・る心の内を思ひ延べ」}	{"be angry ((at; with; about; that)); be enraged ((by; at))⇒おこる(怒る)"}	\N	\N	\N
行き成り	いきなり	{何の前触れもなく急に事が起きるさま。突然。知らせなしに。}	{"suddenly; all of a sudden; without (any) warning"}	\N	\N	\N
息抜き	いきぬき	{緊張を解いて、気分転換のためにしばらく休むこと。休息。「―にテレビを見る」「屋上に出て―する」}	{"〔休息〕(a) rest; 〔一休み〕a breather; a break; a breathing spell; 〔気晴らし〕relaxation"}	\N	\N	\N
生き物	いきもの	{}	{animal}	\N	\N	\N
生きる	いきる	{}	{"live; exist"}	\N	\N	\N
行く	いく	{}	{"to go"}	\N	\N	\N
逝く	いく	{}	{"die; pass away"}	\N	\N	\N
育児	いくじ	{}	{"childcare; nursing; upbringing"}	\N	\N	\N
育成	いくせい	{}	{"rearing; training; nurture; cultivation; promotion"}	\N	\N	\N
幾多	いくた	{}	{"many; numerous"}	\N	\N	\N
幾つ	いくつ	{}	{"how many?; how old?"}	\N	\N	\N
幾分	いくぶん	{}	{somewhat}	\N	\N	\N
幾ら	いくら	{}	{"how much?; how many?"}	\N	\N	\N
池	いけ	{}	{pond}	\N	\N	\N
いけない	いけない	{「悪い」の遠回しな言い方。人のしたことなどに対して非難するさま。感心できない。よくない。「いたずらばかりして、―◦ない子だ」「定刻に遅れたのが―◦ない」}	{"〔よくない〕bad; wrong⇒だめ(駄目)"}	\N	\N	\N
生け花	いけばな	{}	{"flower arrangement"}	\N	\N	\N
活ける	いける	{}	{"to arrange (flowers)"}	\N	\N	\N
異見	いけん	{}	{"different opinion; objection"}	\N	\N	\N
意見	いけん	{}	{opinion}	\N	\N	\N
以後	いご	{}	{"from now on; thereafter"}	\N	\N	\N
意向	いこう	{}	{"intention; idea; inclination"}	\N	\N	\N
移行	いこう	{}	{"switching over to"}	\N	\N	\N
以降	いこう	{}	{"on and after; hereafter; thereafter"}	\N	\N	\N
些か	いささか	{数量・程度の少ないさま。ほんの少し。わずか。ついちょっと。「ーなりともお役に立ちたい」「この問題はー難しい」}	{"a little; a bit; slightly"}	\N	\N	\N
勇ましい	いさましい	{}	{"brave; valiant; gallant; courageous"}	\N	\N	\N
石	いし	{}	{stone}	\N	\N	\N
意志	いし	{}	{"will; volition"}	\N	\N	\N
意思	いし	{}	{"intention; purpose"}	\N	\N	\N
医師	いし	{}	{doctor}	\N	\N	\N
意地	いじ	{}	{"disposition; spirit; willpower; obstinacy; backbone; appetite"}	\N	\N	\N
維持	いじ	{}	{"maintenance; preservation"}	\N	\N	\N
石垣	いしがき	{石壁}	{"stone [rock] wall [fence]"}	\N	\N	\N
意識	いしき	{心が知覚を有しているときの状態。「ーを取り戻す」}	{consciousness;}	\N	\N	\N
碑	いしぶみ	{}	{"stone monument bearing an inscription"}	\N	\N	\N
医者	いしゃ	{}	{"doctor (medical)"}	\N	\N	\N
移住	いじゅう	{}	{"migration; immigration"}	\N	\N	\N
萎縮	いしゅく	{しぼんでちぢむこと。また、元気がなくなること。「寒くて手足が―する」「聴衆を前にして―してしまう」}	{"〔しなびて縮むこと〕withering; 〔栄養不良などによる〕atrophy"}	\N	\N	\N
戦	いくさ	{}	{"war; battle; campaign; fight"}	\N	{軍}	\N
衣装	いしょう	{}	{"clothing; costume; outfit; garment; dress"}	\N	\N	\N
衣裳	いしょう	{}	{"costume; outfit"}	\N	\N	\N
以上	いじょう	{}	{"more than; over"}	\N	\N	\N
異常	いじょう	{普通と違っていること。正常でないこと。また、そのさま。「この夏は―に暑かった」「―な執着心」「害虫の―発生」⇔正常。}	{"strangeness; abnormality; disorder"}	\N	\N	\N
衣食住	いしょくじゅう	{}	{"necessities of life (food; clothing; etc.)"}	\N	\N	\N
弄る	いじる	{}	{"to touch; to tamper with"}	\N	\N	\N
意地悪	いじわる	{}	{"malicious; ill-tempered; unkind"}	\N	\N	\N
維新	いしん	{}	{restoration}	\N	\N	\N
椅子	いす	{}	{chair}	\N	\N	\N
泉	いずみ	{}	{"spring; fountain"}	\N	\N	\N
何れ	いずれ	{いろいろな過程を経たうえでの結果をいう。いずれにしても。結局。どのみち}	{"anyhow; in any case;"}	\N	\N	\N
何れにしても	いずれにしても	{どちらを選ぶにしても。事情がどうであろうとも。どっちみち。いずれにせよ。}	{whichever}	\N	\N	\N
何れにせよ	いずれにせよ	{経過がどうであろうと、結果は明らかだと認める気持ちを表す語。どうせ。結局は。}	{"at any rate; anyhow"}	\N	\N	\N
異性	いせい	{}	{"the opposite sex"}	\N	\N	\N
遺跡	いせき	{}	{"historic ruins (remains relics)"}	\N	\N	\N
依然	いぜん	{}	{"still; as yet"}	\N	\N	\N
以前	いぜん	{}	{"ago; since; before; previous"}	\N	\N	\N
忙しい	いそがしい	{}	{"busy; irritated"}	\N	\N	\N
急ぐ	いそぐ	{}	{"hurry (up)"}	\N	\N	\N
遺族	いぞく	{}	{"bereaved family (frantagen)"}	\N	\N	\N
依存	いそん	{}	{"dependence; dependent; reliance"}	\N	\N	\N
板	いた	{}	{"board; plank"}	\N	\N	\N
痛い	いたい	{}	{painful}	\N	\N	\N
遺体	いたい	{}	{死人}	\N	\N	\N
偉大	いだい	{すぐれて大きいさま。りっぱであるさま。「ーな業績」「ーな人物」}	{greatness}	\N	\N	\N
委託	いたく	{}	{"consign (goods (for sale) to a firm); entrust (person with something); commit"}	\N	\N	\N
致す	いたす	{}	{do}	\N	\N	\N
悪戯	いたずら	{}	{"tease; prank; trick; practical joke; mischief"}	\N	\N	\N
頂	いただき	{}	{"(top of) head; summit; spire"}	\N	\N	\N
至って	いたって	{}	{"very much; exceedingly; extremely"}	\N	\N	\N
痛み	いたみ	{}	{"pain; ache; sore; grief; distress"}	\N	\N	\N
悼む	いたむ	{}	{mourn}	\N	\N	\N
痛む	いたむ	{}	{"to hurt; to feel a pain; to be injured"}	\N	\N	\N
痛める	いためる	{}	{"to hurt; to injure; to cause pain; to worry; to bother; to afflict; to be grieved over"}	\N	\N	\N
至る	いたる	{}	{"come; arrive"}	\N	\N	\N
労る	いたわる	{}	{"to pity; to sympathize with; to console; to care for; to be kind to"}	\N	\N	\N
一	いち	{}	{one}	\N	\N	\N
壱	いち	{}	{"I (roman 1)"}	\N	\N	\N
位地	いち	{}	{"place; situation; position; location"}	\N	\N	\N
位置	いち	{}	{"location; position"}	\N	\N	\N
一応	いちおう	{}	{"once; tentatively; in outline; for the time being"}	\N	\N	\N
一概に	いちがいに	{}	{"unconditionally; as a rule"}	\N	\N	\N
一月	いちがつ	{}	{January}	\N	\N	\N
一見	いちげん	{}	{"unfamiliar; never before met"}	\N	\N	\N
一時	いちじ	{}	{"one hour; short time; once; temporarily; at one time"}	\N	\N	\N
市	いち	{}	{"market; fair"}	\N	\N	\N
一言	いちげん	{}	{"single word"}	\N	\N	\N
一日	いちじつ	{}	{"one day; first of month"}	\N	\N	\N
一々	いちいち	{}	{"one by one; separately"}	\N	{一一}	\N
著しい	いちじるしい	{}	{"remarkable; considerable"}	\N	\N	\N
一段と	いちだんと	{}	{"greater; more; further; still more"}	\N	\N	\N
一度	いちど	{}	{"once; one time"}	\N	\N	\N
一同	いちどう	{}	{"all present; all concerned; all of us"}	\N	\N	\N
一度に	いちどに	{}	{"all at once"}	\N	\N	\N
一宮	いちのみや	{ある地域の中で最も社格の高いとされる神社のことである。}	{"historical term referring to the Japanese Shinto shrines with the highest shrine rank (ja:社格) in a province or prefecture."}	\N	\N	\N
市場	いちば	{一定の商品を大量に卸売りする所。「魚―」「青物―」}	{"town market; the marketplace (economics)"}	\N	\N	\N
一番	いちばん	{}	{"best; first; number one; a game; a round; a bout; a fall; an event (in a meet)"}	\N	\N	\N
一部	いちぶ	{}	{"one copy e.g. of a document; a part; partly; some"}	\N	\N	\N
一部分	いちぶぶん	{}	{"a part"}	\N	\N	\N
一別	いちべつ	{}	{parting}	\N	\N	\N
一面	いちめん	{}	{"one side; one phase; front page; the other hand; the whole surface"}	\N	\N	\N
一目	いちもく	{}	{"a glance; a look; a glimpse"}	\N	\N	\N
一様	いちよう	{}	{"uniformity; evenness; similarity; equality; impartiality"}	\N	\N	\N
一律	いちりつ	{}	{"evenness; uniformity; monotony; equality"}	\N	\N	\N
一流	いちりゅう	{}	{"foremost; top-notch; unique"}	\N	\N	\N
一例	いちれい	{一つの例。「―を挙げる」}	{"an example; an instance⇒れい(例)4"}	\N	\N	\N
一連	いちれん	{}	{"a series; a chain; a ream (of paper)"}	\N	\N	\N
何時	いつ	{}	{"when; how soon"}	\N	\N	\N
一家	いっか	{}	{"house; home; a family; a household; one´s family; one´s folks; a style"}	\N	\N	\N
五日	いつか	{}	{"five days; the fifth day (of the month)"}	\N	\N	\N
何時か	いつか	{}	{"sometime; some day"}	\N	\N	\N
一階	いっかい	{}	{"first floor"}	\N	\N	\N
一括	いっかつ	{}	{"all together; batch; one lump; one bundle; summing up"}	\N	\N	\N
一貫	いっかん	{}	{"consistency; coherence"}	\N	\N	\N
一気	いっき	{}	{"drink!(said repeatedly as a party cheer)"}	\N	\N	\N
一挙に	いっきょに	{}	{"at a stroke; with a single swoop"}	\N	\N	\N
慈しみ	いつくしみ	{}	{affection}	\N	\N	\N
一刻	いっこく	{わずかな時間。瞬時。「―を争う」「―も早く」}	{"〔わずかな時間〕a moment"}	\N	\N	\N
一種	いっしゅ	{}	{"species; kind; variety"}	\N	\N	\N
一瞬	いっしゅん	{}	{"moment; instant"}	\N	\N	\N
一緒	いっしょ	{}	{"together; meeting; company"}	\N	\N	\N
一生	いっしょう	{}	{"lifetime; all through life; generation; age; era; the whole world"}	\N	\N	\N
一生懸命	いっしょうけんめい	{}	{"as well as one can; as hard as one can"}	\N	\N	\N
一生に一度	いっしょういちど	{}	{"once in a lifetime"}	\N	\N	\N
一心	いっしん	{}	{"one mind; wholeheartedness; the whole heart"}	\N	\N	\N
一心不乱	いっしんふらん	{心を一つの事に集中して、他の事に気をとられないこと。また、そのさま。「―に祈る」「―に研究する」}	{"be completely absorbed (by drawing a picture)"}	\N	\N	\N
一斉	いっせい	{同時。いちどき。「―に立ち上がる」}	{simultaneous}	\N	\N	\N
一層	いっそう	{}	{"much more; still more; all the more"}	\N	\N	\N
一帯	いったい	{}	{"a region; a zone; the whole place"}	\N	\N	\N
逸脱	いつだつ	{本筋や決められた枠から外れること。「任務を―する行為」}	{"〔本筋からそれること〕(a) deviation; (a) departure"}	\N	\N	\N
一旦	いったん	{}	{"once; for a moment; one morning; temporarily"}	\N	\N	\N
一致	いっち	{}	{"coincidence; agreement; union; match; conformity; consistency; cooperation"}	\N	\N	\N
五つ	いつつ	{}	{five}	\N	\N	\N
一箇	いっか	{}	{"1 piece (inanimate objects)"}	\N	\N	\N
一箇	いっこ	{}	{"1 piece (inanimate objects)"}	\N	\N	\N
一個	いっこ	{}	{"1 piece (article)"}	\N	\N	\N
一日	いちにち	{}	{"first of month"}	\N	\N	\N
一刻者	いっこくもの	{頑固で自分を曲げない人。一徹者。}	{"「an obstinate [a stubborn] person"}	\N	{一国者}	\N
何時でも	いつでも	{}	{"(at) any time; always; at all times; never (neg); whenever"}	\N	\N	\N
何時の間に	いつのまに	{いつ。いつかわからないうちに。「ー仕上げたのだろう」}	{"all too soon; without our noticing it; before (we) know it; not sure since when"}	\N	\N	\N
一敗	いっぱい	{}	{"one defeat"}	\N	\N	\N
一般	いっぱん	{}	{"general; universal; ordinary; average; liberal"}	\N	\N	\N
一匹	いっぴき	{魚・虫・獣など一つ。→匹 (ひき) }	{"one (small) animal"}	\N	\N	\N
一変	いっぺん	{}	{"complete change; about-face"}	\N	\N	\N
一方	いっぽう	{}	{"one side; one way; one direction; one party; the other party; on the other hand; meanwhile; only; simple; in turn"}	\N	\N	\N
何時までも	いつまでも	{ある事柄が終わるときの限度がないさま。末長く。「―お幸せに」}	{"forever; as long as you like"}	\N	\N	\N
何時も	いつも	{}	{"always; usually; every time; never (with neg. verb)"}	\N	\N	\N
何時もながら	いつもながら	{常と変わらないさま。いつものことではあるが。「ー元気だね」「ーの親切」}	{"perennially; as always"}	\N	\N	\N
いつもながら	何時もながら	{常と変わらないさま。いつものことではあるが。「ー元気だね」「ーの親切」}	{"perennially; as always"}	\N	\N	\N
移転	いてん	{}	{"moving; transfer; demise"}	\N	\N	\N
遺伝子	いでんし	{}	{gene}	\N	\N	\N
意図	いと	{}	{"intention; aim; design"}	\N	\N	\N
糸	いと	{}	{thread}	\N	\N	\N
井戸	いど	{}	{"water well"}	\N	\N	\N
緯度	いど	{}	{"latitude (geography)"}	\N	\N	\N
移動	いどう	{}	{"removal; migration; movement"}	\N	\N	\N
異動	いどう	{}	{"a change"}	\N	\N	\N
従兄弟	いとこ	{}	{"male cousin"}	\N	\N	\N
従姉妹	いとこ	{}	{"female cousin"}	\N	\N	\N
営む	いとなむ	{}	{"to carry on (e.g. in ceremony); to run a business"}	\N	\N	\N
挑む	いどむ	{}	{"to challenge; to contend for; to make love to"}	\N	\N	\N
以内	いない	{}	{within}	\N	\N	\N
田舎	いなか	{}	{"the country; country side"}	\N	\N	\N
稲光	いなびかり	{}	{"(flash of) lightning"}	\N	\N	\N
古	いにしえ	{}	{"antiquity; ancient times"}	\N	\N	\N
稲	いね	{}	{"rice plant"}	\N	\N	\N
居眠り	いねむり	{}	{"dozing; nodding off"}	\N	\N	\N
命	いのち	{}	{"(mortal) life"}	\N	\N	\N
祈り	いのり	{}	{"prayer; supplication"}	\N	\N	\N
祈る	いのる	{}	{pray}	\N	\N	\N
尿	いばり	{}	{urine}	\N	\N	\N
威張る	いばる	{}	{"swagger; be proud"}	\N	\N	\N
違反	いはん	{}	{"violation (of law); transgression"}	\N	\N	\N
衣服	いふく	{}	{clothes}	\N	\N	\N
居間	いま	{}	{"living room (Western style)"}	\N	\N	\N
今	いま	{}	{"this; now"}	\N	\N	\N
今更	いまさら	{}	{"now; at this late hour"}	\N	\N	\N
今に	いまに	{}	{"before long; even now"}	\N	\N	\N
今にも	いまにも	{}	{"at any time; soon"}	\N	\N	\N
意味	いみ	{}	{"meaning; significance"}	\N	\N	\N
忌み	いみ	{}	{lourning}	\N	\N	\N
移民	いみん	{}	{"emigration; immigration; emigrant; immigrant"}	\N	\N	\N
忌む	いむ	{}	{hate}	\N	\N	\N
芋	いも	{}	{"〔じゃがいも〕a potato; 〔さつまいも〕a sweet potato; a yam;"}	\N	\N	\N
妹	いもうと	{}	{"younger sister"}	\N	\N	\N
否	いや	{}	{"no; nay; yes; well"}	\N	\N	\N
嫌	いや	{}	{"disagreeable; detestable; unpleasant; reluctant"}	\N	\N	\N
嫌がる	いやがる	{}	{"hate; dislike"}	\N	\N	\N
卑しい	いやしい	{}	{"greedy; vulgar; shabby; humble; base; mean; vile"}	\N	\N	\N
意欲	いよく	{}	{"will; desire; ambition"}	\N	\N	\N
一定	いってい	{一つに定まって変わらないこと。「―の分量」「―の収入」}	{"fixed; settled; definite; uniform; regularized; standardized; prescribed"}	\N	\N	\N
暇	いとま	{}	{"free time; leisure; leave; spare time; farewell"}	\N	\N	\N
未だ	いまだ	{}	{"as yet; hitherto; not yet (neg)"}	\N	\N	\N
今道心	いまどうしん	{仏門に入ったばかりの者。青道心。新発意 (しんぼち) 。}	{"neophyte (a person who is new to a subject or activity)"}	\N	\N	\N
違法	いほう	{法律・規定などにそむくこと。また、その行為。不法。非合法。違反。「―駐車」⇔適法。}	{"illegality; unlawfulness"}	\N	\N	\N
依頼	いらい	{}	{"request; commission; dispatch; dependence; trust"}	\N	\N	\N
以来	いらい	{}	{"since; henceforth"}	\N	\N	\N
衣料	いりょう	{}	{clothing}	\N	\N	\N
医療	いりょう	{}	{"medical care; medical treatment"}	\N	\N	\N
威力	いりょく	{}	{"power; might; authority; influence"}	\N	\N	\N
要る	いる	{}	{need}	\N	\N	\N
煎る	いる	{}	{"to parch; to fry; to fire; to broil; to roast; to boil down (in oil)"}	\N	\N	\N
射る	いる	{矢を弓につがえて放つ。「弓をいる」}	{"shot (e.g. an arrow)"}	\N	\N	\N
衣類	いるい	{}	{"clothes; clothing; garments"}	\N	\N	\N
入れ物	いれもの	{}	{"container; case; receptacle"}	\N	\N	\N
容れる	いれる	{認めて受け入れる。認めてやる。聞きいれる。「要求を―・れる」「人を―・れる度量がない」}	{"to grant (a request); accept (an opinion); comply (to a request); to take (advice)"}	\N	\N	\N
挿れる	いれる	{挿入すること。慣用的な読み方。}	{"to insert (sexual context; same as 入れる)"}	\N	\N	\N
色	いろ	{}	{"color; sensuality; lust"}	\N	\N	\N
色々	いろいろ	{}	{various}	\N	\N	\N
彩り	いろどり	{色をつけること。彩色。}	{"〔彩色〕coloring，((英)) colouring"}	\N	\N	\N
異論	いろん	{}	{"different opinion; objection"}	\N	\N	\N
岩	いわ	{}	{"rock; crag"}	\N	\N	\N
祝い	いわい	{}	{"celebration; festival"}	\N	\N	\N
祝う	いわう	{}	{"congratulate; celebrate"}	\N	\N	\N
曰く	いわく	{}	{"to say; to reason"}	\N	\N	\N
言わば	いわば	{}	{"so to speak; so to call it; as it were"}	\N	\N	\N
所謂	いわゆる	{}	{"the so-called; so to speak"}	\N	\N	\N
員	いん	{}	{member}	\N	\N	\N
印鑑	いんかん	{}	{"stamp; seal"}	\N	\N	\N
陰気	いんき	{}	{"gloom; melancholy"}	\N	\N	\N
隠居	いんきょ	{}	{"retirement; retired person"}	\N	\N	\N
印刷	いんさつ	{}	{printing}	\N	\N	\N
印象	いんしょう	{}	{impression}	\N	\N	\N
引退	いんたい	{役職や地位から身を退くこと。スポーツなどで現役から退くこと。「ー興行」}	{retire}	\N	\N	\N
引用	いんよう	{}	{"quotation; citation"}	\N	\N	\N
淫乱	いんらん	{色欲をほしいままにしてみだらなこと。また、そのさま。「―な性向」}	{"excessive indulgence in sex; alcohol; or drugs; debauchery; lechery; lasciviousness;"}	\N	\N	\N
飲料	いんりょう	{飲むためのもの。飲み物。「清涼―」「―水」}	{"a drink; a beverage"}	\N	\N	\N
引力	いんりょく	{}	{gravity}	\N	\N	\N
寺院	じいん	{仏寺とそれに付属する別舎をあわせた称。また、広くイスラム教・キリスト教の礼拝堂にもいう。てら。}	{temple}	\N	\N	\N
自衛	じえい	{}	{self-defense}	\N	\N	\N
自衛隊	じえいたい	{防衛省に属し、日本の平和と独立を守り、国の安全を保つことを主な任務とする防衛組織。陸上・海上・航空の三自衛隊からなり、内閣総理大臣の統率のもとに防衛大臣が隊務を統括する。昭和29年（1954）防衛庁設置法（現、防衛省設置法）に基づき、保安隊（警察予備隊の後身）・警備隊（海上警備隊の後身）を改組・改称し、新たに航空自衛隊を創設して発足。}	{"self-defense force"}	\N	\N	\N
字音	じおん	{ある文字の発音。}	{"the Japanized pronunciation of a Chinese character"}	\N	\N	\N
自我	じが	{}	{"self; the ego"}	\N	\N	\N
自覚	じかく	{}	{self-conscious}	\N	\N	\N
直に	じかに	{}	{"directly; in person; headlong"}	\N	\N	\N
時間	じかん	{}	{time}	\N	\N	\N
入口	いりぐち	{}	{"entrance; gate; approach; mouth"}	\N	\N	\N
入口	いりくち	{}	{"entrance; gate; approach; mouth"}	\N	\N	\N
入る	いる	{}	{"to get in; to go in; to come in; to flow into; to set; to set in"}	\N	\N	\N
居る	いる	{人や動物が、ある場所に存在する。「ペンギンは北極にはーない」「そこにー・るのは誰ですか」}	{"to be (animate); to exist"}	\N	\N	\N
印	いん	{}	{"seal; stamp; mark; print"}	\N	\N	\N
字	じ	{}	{character}	\N	\N	\N
地方	じかた	{}	{"area; locality; district; region; the coast"}	\N	\N	\N
入れる	いれる	{"",湯を差して、茶などを出す。「コーヒーを―・れる」}	{"put in; take in; bring in; let in; admit; introduce; usher in; insert; employ; listen to; tolerate; comprehend; include; pay (interest); cast (votes)","〔茶やコーヒーを〕make (coffee/tea)"}	\N	\N	\N
隠蔽	いんぺい	{人の所在、事の真相などを故意に覆い隠すこと。隠匿。秘匿。隠し立て。「証拠をーする」「ー工作」}	{"hiding; concealment"}	{名,スル}	\N	\N
時間帯	じかんたい	{1日のうちの、ある時刻とある時刻との間の一定の時間}	{"time zone"}	\N	\N	\N
時間割	じかんわり	{}	{"timetable; schedule"}	\N	\N	\N
直	じき	{}	{"direct; in person; soon; at once; just; near by; honesty; frankness; simplicity; cheerfulness; correctness"}	\N	\N	\N
磁器	じき	{}	{"porcelain; china"}	\N	\N	\N
時期	じき	{}	{"time; season; period"}	\N	\N	\N
磁気	じき	{}	{magnetism}	\N	\N	\N
自供	じきょう	{警察官などの取り調べに対し、容疑者・犯人が自己の犯罪事実などを申し述べること}	{confession}	\N	\N	\N
地形	じぎょう	{}	{"terrain; geographical features; topography"}	\N	\N	\N
事業	じぎょう	{}	{"project; enterprise; business; industry; operations"}	\N	\N	\N
軸	じく	{}	{"axis; stem; shaft; axle"}	\N	\N	\N
事件	じけん	{世間が話題にするような出来事。問題となる出来事。「奇妙な―が起こる」}	{"event; affair; incident; case; plot; trouble; scandal"}	\N	\N	\N
自己	じこ	{}	{"self; oneself"}	\N	\N	\N
事故	じこ	{}	{accident}	\N	\N	\N
事項	じこう	{}	{"matter; item; facts"}	\N	\N	\N
時刻	じこく	{}	{"instant; time; moment"}	\N	\N	\N
地獄	じごく	{}	{hell}	\N	\N	\N
時刻表	じこくひょう	{}	{"table; diagram; chart; timetable; schedule"}	\N	\N	\N
時差	じさ	{}	{"time difference"}	\N	\N	\N
自在	じざい	{}	{"freely; at will"}	\N	\N	\N
自殺	じさつ	{}	{suicide}	\N	\N	\N
持参	じさん	{}	{"bringing; taking; carrying"}	\N	\N	\N
自粛	じしゅく	{自分から進んで、行いや態度を慎むこと。「露骨な広告を業界が―する」}	{self-restraint}	\N	\N	\N
事実	じじつ	{}	{"fact; truth; reality"}	\N	\N	\N
磁石	じしゃく	{}	{magnet}	\N	\N	\N
自主	じしゅ	{}	{"independence; autonomy"}	\N	\N	\N
自首	じしゅ	{}	{"surrender; give oneself up"}	\N	\N	\N
自習	じしゅう	{}	{self-study}	\N	\N	\N
辞書	じしょ	{}	{"dictionary; lexicon"}	\N	\N	\N
事情	じじょう	{}	{"circumstances; consideration; conditions; situation; reasons"}	\N	\N	\N
耳小骨	じしょうこつ	{}	{"ear drum"}	\N	\N	\N
辞職	じしょく	{}	{resignation}	\N	\N	\N
自信	じしん	{}	{self-confidence}	\N	\N	\N
自身	じしん	{}	{"by oneself; personally"}	\N	\N	\N
自信過剰	じしんかじょう	{自分と信じていることが過ぎる}	{"overconfident (self-faith-too-much-excess)"}	\N	\N	\N
地震	じしん	{}	{earthquake}	\N	\N	\N
事前	じぜん	{}	{"prior; beforehand; in advance"}	\N	\N	\N
時速	じそく	{}	{"speed (per hour)"}	\N	\N	\N
持続	じぞく	{}	{continuation}	\N	\N	\N
自尊心	じそんしん	{}	{"self-respect; conceit"}	\N	\N	\N
字体	じたい	{}	{"type; font; lettering"}	\N	\N	\N
辞退	じたい	{}	{refusal}	\N	\N	\N
事態	じたい	{物事の状態、成り行き。「容易ならないーを収拾する」}	{"the situation; the state of affairs"}	\N	\N	\N
時代	じだい	{}	{"age; period; generation"}	\N	\N	\N
次代	じだい	{}	{"next era"}	\N	\N	\N
自宅	じたく	{}	{"own house"}	\N	\N	\N
自治	じち	{}	{"self-government; autonomy"}	\N	\N	\N
実感	じっかん	{}	{"feelings (actual; true)"}	\N	\N	\N
実業家	じつぎょうか	{}	{"industrialist; businessman"}	\N	\N	\N
実験	じっけん	{事柄の当否などを確かめるために、実際にやってみること。また、ある理論や仮説で考えられていることが、正しいかどうかなどを実際にためしてみること。「化学のー」「ーを繰り返す」}	{experiment}	\N	\N	\N
実現	じつげん	{}	{"implementation; materialization; realization"}	\N	\N	\N
実行	じっこう	{実際に行うこと。「計画をーに移す」「予定どおりにーする」}	{"practice; performance; realization; execution (e.g. program)"}	\N	\N	\N
実際	じっさい	{}	{"practical; actual condition; status quo"}	\N	\N	\N
実施	じっし	{}	{"enforcement; enact; put into practice; carry out; operation"}	\N	\N	\N
実質	じっしつ	{}	{"substance; essence"}	\N	\N	\N
実習	じっしゅう	{}	{"practice; training"}	\N	\N	\N
実情	じつじょう	{}	{"real condition; actual circumstances; actual state of affairs"}	\N	\N	\N
実績	じっせき	{}	{"achievements; actual results"}	\N	\N	\N
実践	じっせん	{}	{"practice; put into practice"}	\N	\N	\N
実線	じっせん	{幾何や製図などで、切れ目なく連続して引かれる線。}	{"a solid line"}	\N	\N	\N
実に	じつに	{}	{"indeed; truly; surely"}	\N	\N	\N
実は	じつは	{}	{"as a matter of fact; by the way"}	\N	\N	\N
実費	じっぴ	{}	{"actual expense; cost price"}	\N	\N	\N
実物	じつぶつ	{}	{"real thing; original"}	\N	\N	\N
実用	じつよう	{}	{"practical use; utility"}	\N	\N	\N
実力	じつりょく	{}	{"merit; efficiency; arms; force"}	\N	\N	\N
実例	じつれい	{}	{"example; illustration"}	\N	\N	\N
自転	じてん	{}	{"rotation; spin"}	\N	\N	\N
辞典	じてん	{}	{dictionary}	\N	\N	\N
自転車	じてんしゃ	{}	{bicycle}	\N	\N	\N
自動	じどう	{}	{automatic}	\N	\N	\N
児童	じどう	{}	{"children; juvenile"}	\N	\N	\N
自動詞	じどうし	{}	{"intransitive verb (no direct obj)"}	\N	\N	\N
自動車	じどうしゃ	{}	{automobile}	\N	\N	\N
辞任	じにん	{就いていた任務・職務を、自分から申し出て辞めること。「議長を―する」}	{"resignation (from a post)"}	\N	\N	\N
地主	じぬし	{}	{landlord}	\N	\N	\N
自白	じはく	{自分の秘密や犯した罪などを包み隠さずに言うこと。自供。自首「カンニングをーする」}	{confession}	\N	\N	\N
地盤	じばん	{}	{"the ground"}	\N	\N	\N
耳鼻科	じびか	{}	{otolaryngology}	\N	\N	\N
字引	じびき	{}	{dictionary}	\N	\N	\N
自分	じぶん	{}	{"myself; oneself"}	\N	\N	\N
字幕	じまく	{}	{subtitles}	\N	\N	\N
自慢	じまん	{}	{"pride; boast"}	\N	\N	\N
地味	じみ	{}	{"plain; simple"}	\N	\N	\N
地道	じみち	{手堅く着実に物事をすること。地味でまじめなこと。また、そのさま。「―な努力をする」「―に働く」}	{"〜な steady"}	\N	\N	\N
事務	じむ	{}	{"business; office work"}	\N	\N	\N
事務所	じむしょ	{}	{office}	\N	\N	\N
事務局	じむきょく	{議会や団体などの、事務を取り扱う部局。}	{"a secretariat"}	\N	\N	\N
地元	じもと	{}	{local}	\N	\N	\N
邪教	じゃきょう	{}	{heresy}	\N	\N	\N
弱	じゃく	{}	{"weakness; the weak; little less then"}	\N	\N	\N
弱体化	じゃくたいか	{組織などの力が衰えること。「チームが―する」}	{weakening}	\N	\N	\N
蛇口	じゃぐち	{}	{"faucet; tap"}	\N	\N	\N
弱点	じゃくてん	{}	{"weak point; weakness"}	\N	\N	\N
若干	じゃっかん	{}	{"some; few; number of"}	\N	\N	\N
邪魔	じゃま	{}	{"obstacle; intrusion"}	\N	\N	\N
邪悪	じゃあく	{}	{heinous}	\N	\N	\N
砂利	じゃり	{}	{"gravel; ballast; pebbles"}	\N	\N	\N
住	じゅう	{}	{"dwelling; living"}	\N	\N	\N
自由	じゆう	{自分の意のままに振る舞うことができること。「＿な時間をもつ」「車を＿にあやつる」}	{freedom}	\N	\N	\N
住居	じゅうきょ	{}	{"dwelling; house; residence; address"}	\N	\N	\N
住居表示	じゅきょひょうじ	{日本の住居表示に関する法律に基づく住所の表し方である。地番とは異なる。}	{"address sign (showing ward and block information)"}	\N	\N	\N
従業員	じゅうぎょういん	{}	{"employee; worker"}	\N	\N	\N
重視	じゅうし	{}	{"importance; stress; serious consideration"}	\N	\N	\N
従事	じゅうじ	{}	{"engaging; pursuing; following"}	\N	\N	\N
充実	じゅうじつ	{}	{"fullness; completion; perfection; substantiality; enrichment"}	\N	\N	\N
柔術	じゅうじゅつ	{徒手で打つ・突く・蹴る・投げる・組み伏せるなどの方法によって相手を攻撃し、また防御する日本古来の武術。やわら。→柔道}	{ju-jutsu}	\N	\N	\N
住所	じゅうしょ	{}	{address}	\N	\N	\N
十字路	じゅうじろ	{}	{crossroads}	\N	\N	\N
渋滞	じゅうたい	{}	{"congestion (e.g. traffic); delay; stagnation"}	\N	\N	\N
重体	じゅうたい	{}	{"seriously ill; serious condition; critical state"}	\N	\N	\N
重大	じゅうだい	{}	{"serious; important; grave; weighty"}	\N	\N	\N
銃	じゅう	{}	{gun}	\N	\N	\N
従順	じゅうじゅん	{性質・態度などがすなおで、人に逆らわないこと。おとなしくて人の言うことをよく聞くこと。また、そのさま。「権力には―である」「―な部下」}	{"obedience ((to)); 〔服従〕submission ((to))"}	\N	{柔順}	\N
住宅	じゅうたく	{}	{"resident; housing"}	\N	\N	\N
重点	じゅうてん	{}	{"important point; lay stress on; emphasis; colon"}	\N	\N	\N
充電器	じゅうでんき	{}	{charge}	\N	\N	\N
柔道	じゅうどう	{}	{judo}	\N	\N	\N
柔軟	じゅうなん	{}	{"flexible; lithe"}	\N	\N	\N
十二支	じゅうにし	{暦法で、子 (し) ・丑 (ちゅう) ・寅 (いん) ・卯 (ぼう) ・辰 (しん) ・巳 (し) ・午 (ご) ・未 (び) ・申 (しん) ・酉 (ゆう) ・戌 (じゅつ) ・亥 (がい) の称。これらを12の動物にあてはめて、日本では、ね（鼠）・うし（牛）・とら（虎）・う（兎）・たつ（竜）・み（蛇）・うま（馬）・ひつじ（羊）・さる（猿）・とり（鶏）・いぬ（犬）・い（猪）とよぶ。時刻や方角を表すのに用い、また、十干 (じっかん) と組み合わせて年や日を表す。→十干}	{"the twelve (animal) signs of the (Chinese and Japanese) zodiac"}	\N	\N	\N
重複	じゅうふく	{}	{"duplication; repetition; overlapping; redundancy; restoration"}	\N	\N	\N
重宝	じゅうほう	{}	{"priceless treasure; convenience; usefulness"}	\N	\N	\N
住民	じゅうみん	{}	{"citizens; inhabitants; residents; population"}	\N	\N	\N
重要	じゅうよう	{物事の根本・本質・成否などに大きくかかわること。きわめて大切であること。また、そのさま。「戦略上―な地域」「―性」}	{"important; momentous; essential; principal; major"}	\N	\N	\N
従来	じゅうらい	{}	{"up to now; so far; traditional"}	\N	\N	\N
重量	じゅうりょう	{}	{"weight; heavyweight boxer"}	\N	\N	\N
重力	じゅうりょく	{}	{gravity}	\N	\N	\N
儒教	じゅきょう	{}	{confucianism}	\N	\N	\N
授業	じゅぎょう	{}	{"lesson; class work"}	\N	\N	\N
塾	じゅく	{}	{"coaching school; lessons"}	\N	\N	\N
熟語	じゅくご	{}	{"idiom; idiomatic phrase; kanji compound"}	\N	\N	\N
熟練	じゅくれん	{物事に慣れて、手際よくじょうずにできること。また、そのさま。「―を要する仕事」「―した技能」}	{"〔すぐれた腕前〕skill (in gardening; with a saw); (文) dexterity; 〔習熟〕mastery (of)"}	\N	\N	\N
熟練度	じゅくれんど	{}	{"level of skill"}	\N	\N	\N
受験	じゅけん	{}	{"taking an examination"}	\N	\N	\N
受諾	じゅだく	{}	{acceptance}	\N	\N	\N
述語	じゅつご	{}	{predicate}	\N	\N	\N
十つ	じゅっつ	{}	{"10 (of something)"}	\N	\N	\N
寿命	じゅみょう	{}	{"life span"}	\N	\N	\N
樹木	じゅもく	{}	{"trees and shrubs; arbour"}	\N	\N	\N
需要	じゅよう	{}	{"demand; request"}	\N	\N	\N
受理	じゅり	{}	{acceptance}	\N	\N	\N
樹立	じゅりつ	{}	{"establish; create"}	\N	\N	\N
受話器	じゅわき	{}	{"telephone receiver"}	\N	\N	\N
順	じゅん	{}	{"order; turn"}	\N	\N	\N
純	じゅん	{}	{〔混じりけがないこと〕purity}	\N	\N	\N
順位	じゅんい	{一定の基準によって上下あるいはあとさきの関係で順に並べられるときの、それぞれの位置。「―をつける」「―が下がる」「優先―」}	{"order; ranking"}	\N	\N	\N
循環	じゅんかん	{}	{"circulation; rotation; cycle"}	\N	\N	\N
準急	じゅんきゅう	{}	{"local express (train slower than an express)"}	\N	\N	\N
準拠	じゅんきょ	{あるものをよりどころとしてそれに従うこと。また、そのよりどころ。「史実に―した小説」}	{"〜する be based upon; follow"}	\N	\N	\N
巡査	じゅんさ	{}	{"police; policeman"}	\N	\N	\N
順々	じゅんじゅん	{}	{"in order; in turn"}	\N	\N	\N
順序	じゅんじょ	{}	{"order; sequence; procedure"}	\N	\N	\N
純情	じゅんじょう	{}	{"pure heart; naivete; self-sacrificing devotion"}	\N	\N	\N
殉職	じゅんしょく	{}	{"dying at one's post"}	\N	\N	\N
準じる	じゅんじる	{}	{"to follow; to conform; to apply to"}	\N	\N	\N
純粋	じゅんすい	{}	{"pure; true; genuine; unmixed"}	\N	\N	\N
準ずる	じゅんずる	{}	{"to apply correspondingly; to correspond to; to be proportionate to; to conform to"}	\N	\N	\N
順調	じゅんちょう	{}	{"favourable; doing well; O.K.; all right"}	\N	\N	\N
街道	かいどう	{}	{highway}	\N	\N	\N
順応	じゅんおう	{環境や境遇の変化に従って性質や行動がそれに合うように変わること。「新しい生活に―する」「―性」}	{"adapt (oneself); adjust (oneself); conform;"}	\N	\N	\N
十分	じゅうぶん	{}	{enough}	\N	\N	\N
重役	じゅうやく	{}	{"heavy responsibilities; director"}	\N	\N	\N
順守	じゅんしゅ	{法律や道徳・習慣を守り、従うこと。循守。「古い伝統を―する」}	{"obey [observe／follow] (the law)"}	\N	{遵守}	\N
順番	じゅんばん	{順序に従って代わる代わるそのことに当たること。順序。秩序。「ーを待つ」}	{order}	\N	\N	\N
準備	じゅんび	{}	{prepare}	\N	\N	\N
純和風式	じゅんわふうしき	{}	{"genuine japanese style"}	\N	\N	\N
助	じょ	{}	{"help; rescue; assistant"}	\N	\N	\N
状	じょう	{}	{shape}	\N	\N	\N
尉	じょう	{}	{"jailer; old man; rank; company officer"}	\N	\N	\N
嬢	じょう	{}	{"young woman"}	\N	\N	\N
情	じょう	{}	{"feelings; emotion; passion"}	\N	\N	\N
上位	じょうい	{}	{"superior (rank not class); higher order (e.g. byte); host computer (of connected device)"}	\N	\N	\N
攘夷	じょうい	{外敵を追い払って国内に入れないこと。}	{"the exclusion of foreigners (from Japan); 攘夷論 exclusionism; the principle of excluding foreigners"}	\N	\N	\N
上演	じょうえん	{}	{"performance (e.g. music)"}	\N	\N	\N
城下	じょうか	{}	{"land near the castle"}	\N	\N	\N
蒸気	じょうき	{}	{"steam; vapour"}	\N	\N	\N
上記	じょうき	{ある記事の上、または前に書いてあること。また、その文句。「集合時間は―のとおり」⇔下記。}	{"上述の above-mentioned [-stated]"}	\N	\N	\N
定規	じょうぎ	{}	{"(measuring) ruler"}	\N	\N	\N
上級	じょうきゅう	{}	{"advanced level; high grade; senior"}	\N	\N	\N
上京	じょうきょう	{}	{"proceeding to the capital (Tokyo)"}	\N	\N	\N
上空	じょうくう	{}	{"sky; the skies; high-altitude sky; upper air"}	\N	\N	\N
条件	じょうけん	{}	{"conditions; terms"}	\N	\N	\N
上司	じょうし	{}	{"superior authorities; boss"}	\N	\N	\N
乗車	じょうしゃ	{}	{"taking a train"}	\N	\N	\N
乗車券	じょうしゃけん	{}	{"a (railway; streetcar) ticket; 割引乗車券a discount ticket"}	\N	\N	\N
上旬	じょうじゅん	{月の1日から10日までの10日間。初旬}	{"first 10 days of month"}	\N	\N	\N
情緒	じょうしょ	{}	{"emotion; feeling"}	\N	\N	\N
上昇	じょうしょう	{}	{"rising; ascending; climbing"}	\N	\N	\N
浄水	じょうすい	{清らかな水。けがれのない水。}	{"clean water"}	\N	\N	\N
情勢	じょうせい	{}	{"state of things; condition; situation"}	\N	\N	\N
醸造	じょうぞう	{}	{brewing}	\N	\N	\N
状態	じょうたい	{人や物事の、ある時点でのありさま。状況。}	{"state; condition"}	\N	\N	\N
上達	じょうたつ	{}	{"improvement; advance; progress"}	\N	\N	\N
冗談	じょうだん	{}	{"jest; joke"}	\N	\N	\N
上等	じょうとう	{}	{"superiority; first-class; very good"}	\N	\N	\N
情熱	じょうねつ	{}	{"passion; enthusiasm; zeal"}	\N	\N	\N
蒸発	じょうはつ	{}	{"evaporation; unexplained disappearance"}	\N	\N	\N
譲歩	じょうほ	{}	{"concession; conciliation; compromise"}	\N	\N	\N
情報	じょうほう	{}	{"information; news; (military) intelligence; gossip"}	\N	\N	\N
情報屋	じょうほうや	{}	{"police informant"}	\N	\N	\N
常用	じょうよう	{日常使用すること。「―している万年筆」}	{"〔日常一般に用いること〕common use"}	\N	\N	\N
上陸	じょうりく	{}	{"landing; disembarkation"}	\N	\N	\N
蒸留	じょうりゅう	{}	{distillation}	\N	\N	\N
女王	じょおう	{}	{queen}	\N	\N	\N
除外	じょがい	{}	{"exception; exclusion"}	\N	\N	\N
助教授	じょきょうじゅ	{}	{"assistant professor"}	\N	\N	\N
叙勲	じょくん	{}	{"conferment; to consult together; compare opinions; carry on a discussion or deliberationw"}	\N	\N	\N
丈夫	じょうぶ	{}	{"good health; robustness; strong; solid; durable; hero; gentleman; warrior; manly person"}	\N	\N	\N
上	じょう	{}	{"first volume; superior quality; top; best; high class; going up"}	\N	\N	\N
畳	じょう	{}	{"counter for tatami mats; measure of room size (in mat units)"}	\N	\N	\N
乗客	じょうかく	{}	{passenger}	\N	\N	\N
乗客	じょうきゃく	{}	{passenger}	\N	\N	\N
上手	じょうず	{物事のやり方が巧みで、手際のよいこと。また、そのさまやその人。「字を―に書く」「テニスの―な人」「時間の使い方が―だ」「聞き―」「三国一の舞いの―」⇔下手 (へた) 。}	{"skill; skillful; dexterity"}	\N	\N	\N
条約	じょうやく	{国家間または国家と国際機関との間の文書による合意。協定。}	{"a treaty; a pact"}	\N	\N	\N
状況	じょうきょう	{移り変わる物事の、その時々のありさま。状態。環境。}	{"situation; circumstances"}	\N	\N	\N
常識	じょうしき	{一般の社会人が共通にもつ、またもつべき普通の知識・意見や判断力。知識。良識。「―がない人」「―で考えればわかる」「―に欠けた振る舞い」「―外れ」}	{"〔思慮分別〕common sense〔周知のこと〕common knowledge"}	\N	\N	\N
助言	じょげん	{}	{"advice; suggestion"}	\N	\N	\N
徐行	じょこう	{}	{"going slowly"}	\N	\N	\N
女史	じょし	{}	{Ms.}	\N	\N	\N
助詞	じょし	{}	{"particle; postposition"}	\N	\N	\N
除湿	じょしつ	{湿気を取り除くこと。「室内を―する」「―器」}	{dehumidification}	\N	\N	\N
助手	じょしゅ	{}	{"helper; assistant; tutor"}	\N	\N	\N
徐々に	じょじょに	{}	{"slowly; little by little; gradually; steadily; quietly"}	\N	\N	\N
女性	じょせい	{}	{female}	\N	\N	\N
除染	じょせん	{施設や機器・着衣などが放射性物質や有害化学物質などによって汚染された際に、薬品などを使ってそれを取り除くこと。「―剤の噴霧」「―シャワーを浴びる」}	{Decontamination}	\N	\N	\N
助長	じょちょう	{}	{"promotion/fostering; help+long; じょうga * your body＋ちょう"}	\N	\N	\N
助動詞	じょどうし	{}	{"auxiliary verb"}	\N	\N	\N
女優	じょゆう	{}	{actress}	\N	\N	\N
自立	じりつ	{}	{"independence; self-reliance"}	\N	\N	\N
人格	じんかく	{}	{"personality; character; individuality"}	\N	\N	\N
神宮	じんぐう	{}	{"shinto shrine"}	\N	\N	\N
人口	じんこう	{}	{population}	\N	\N	\N
人工	じんこう	{}	{"artificial; man-made; human work; human skill; artificiality"}	\N	\N	\N
人材	じんざい	{}	{"man of talent"}	\N	\N	\N
人事	じんじ	{社会などの中で、個人の身分の決定などに関する事柄}	{"personnel matters [affairs]"}	\N	\N	\N
神社	じんじゃ	{}	{"Shinto shrine"}	\N	\N	\N
人種	じんしゅ	{人類を骨格・皮膚・毛髪などの形質的特徴によって分けた区分。一般的には皮膚の色により、コーカソイド（白色人種）・モンゴロイド（黄色人種）・ニグロイド（黒色人種）に大別するが、この三大別に入らない集団も多い。}	{"race (of people)"}	\N	\N	\N
人生	じんせい	{}	{"(human) life (i.e. conception to death)"}	\N	\N	\N
人造	じんぞう	{}	{"man-made; synthetic; artificial"}	\N	\N	\N
迅速	じんそく	{}	{"quick; fast; rapid; swift; prompt"}	\N	\N	\N
人体	じんたい	{}	{"human body"}	\N	\N	\N
甚大	じんだい	{程度のきわめて大きいさま。「―な被害」}	{"enormous; tremendous"}	\N	\N	\N
人物	じんぶつ	{}	{"character; personality; person; man; personage; talented man"}	\N	\N	\N
人文科学	じんぶんかがく	{}	{"social sciences; humanities"}	\N	\N	\N
人民	じんみん	{}	{"people; public"}	\N	\N	\N
人命	じんめい	{}	{"(human) life"}	\N	\N	\N
尋問	じんもん	{問いただすこと。取り調べとして口頭で質問すること。}	{"questioning; interrogation; (cross-) examination"}	\N	\N	\N
人目	じんもく	{}	{"glimpse; public gaze"}	\N	\N	\N
迅雷	じんらい	{}	{"thunderclap; åskskräll"}	\N	\N	\N
人類	じんるい	{人間。ひと。動物学上は、脊索動物門哺乳綱霊長目ヒト科ヒト属に分類される。}	{"mankind; humanity"}	\N	\N	\N
可	か	{}	{passable}	\N	\N	\N
仮	か	{}	{"tentative; provisional"}	\N	\N	\N
個	か	{}	{"article counter"}	\N	\N	\N
課	か	{}	{"counter for chapters (of a book)"}	\N	\N	\N
科	か	{}	{"department; section"}	\N	\N	\N
下位	かい	{}	{"low rank; subordinate; lower order (e.g. byte)"}	\N	\N	\N
貝	かい	{}	{"shell; shellfish"}	\N	\N	\N
回	かい	{}	{"counter for occurrences"}	\N	\N	\N
階	かい	{}	{"-floor (counter); stories"}	\N	\N	\N
咼	かい	{}	{[jawbone]}	\N	\N	\N
改悪	かいあく	{}	{"deterioration; changing for the worse"}	\N	\N	\N
会員	かいいん	{}	{"member; the membership"}	\N	\N	\N
海運	かいうん	{}	{"maritime; marine transportation"}	\N	\N	\N
絵画	かいが	{}	{picture}	\N	\N	\N
開会	かいかい	{}	{"opening of a meeting"}	\N	\N	\N
海外	かいがい	{}	{"foreign; abroad; overseas"}	\N	\N	\N
改革	かいかく	{}	{"reform; reformation; innovation"}	\N	\N	\N
貝殻	かいがら	{}	{shell}	\N	\N	\N
会館	かいかん	{}	{"meeting hall; assembly hall"}	\N	\N	\N
海岸	かいがん	{}	{"sea shore"}	\N	\N	\N
女子	じょし	{}	{"woman; girl"}	\N	\N	\N
人	じん	{}	{"man; person; people"}	\N	\N	\N
階級	かいきゅう	{}	{"class; rank; grade"}	\N	\N	\N
海峡	かいきょう	{}	{channel}	\N	\N	\N
快挙	かいきょ	{胸のすくような、すばらしい行為。痛快な行動。}	{"a splendid [heroic] achievement"}	\N	\N	\N
解禁	かいきん	{法律などで禁止していたことを解くこと。「アユ漁がーされる」}	{"lifting of ban; unlocking"}	\N	\N	\N
海軍	かいぐん	{}	{navy}	\N	\N	\N
会計	かいけい	{}	{"account; finance; accountant; treasurer; paymaster; reckoning; bill"}	\N	\N	\N
解決	かいけつ	{}	{"settlement; solution; resolution"}	\N	\N	\N
会見	かいけん	{}	{"interview; audience"}	\N	\N	\N
介護	かいご	{}	{nursing}	\N	\N	\N
会合	かいごう	{}	{"meeting; assembly"}	\N	\N	\N
海賊	かいぞく	{海上を横行し、往来の船などを襲い、財貨を脅し取る盗賊。}	{pirate}	\N	\N	\N
海賊版	かいぞくばん	{"《pirated edition》外国の著作物を著者・出版社の許可を受けずに複製したもの。同一国内のものについてもいう。"}	{"a pirated edition"}	\N	\N	\N
買い込む	かいこむ	{物をたくさん買い入れる。特に、品物の値上がりや欠乏を見越して、多く買い入れる。「値上がりを見越して―・む」}	{"bulk up〔蓄える目的で〕lay in; 〔買う〕buy; purchase"}	\N	\N	\N
開墾	かいこん	{}	{"reclamation; cultivating new land"}	\N	\N	\N
開催	かいさい	{集会や催し物を開き行うこと}	{"holding (of an event opening)"}	\N	\N	\N
改札	かいさつ	{}	{"examination of tickets"}	\N	\N	\N
解散	かいさん	{}	{"breakup; dissolution"}	\N	\N	\N
開始	かいし	{}	{"start; commencement; beginning"}	\N	\N	\N
会社	かいしゃ	{}	{"company; corporation"}	\N	\N	\N
解釈	かいしゃく	{}	{"explanation; interpretation"}	\N	\N	\N
介錯	かいしゃく	{切腹に際し、本人を即死させてその負担と苦痛を軽減するため、介助者が背後から切腹人の首を刀で斬る行為。}	{"hara-kiri assistant (2nd in command)"}	\N	\N	\N
介錯人	かいしゃくにん	{切腹する人のそばに付き添っていて、その人が刀を腹に突き刺すと同時に、その首を斬って死を助けてやること。また、その人。}	{"a person assisting an act of hara-kiri"}	\N	\N	\N
改修	かいしゅう	{}	{"repair; improvement"}	\N	\N	\N
回収	かいしゅう	{}	{"collection; recovery"}	\N	\N	\N
怪獣	かいじゅう	{}	{monster}	\N	\N	\N
解除	かいじょ	{今まであった制限・禁止、あるいは特別の状態などをなくして、もとの状態に戻すこと。「規制を―する」}	{"cancellation; rescinding; release; calling off"}	\N	\N	\N
会場	かいじょう	{}	{"the place of meeting"}	\N	\N	\N
海水浴	かいすいよく	{}	{"sea bathing; seawater bath"}	\N	\N	\N
回数	かいすう	{}	{"number of times; frequency"}	\N	\N	\N
回数券	かいすうけん	{}	{"book of tickets"}	\N	\N	\N
改正	かいせい	{}	{"revision; amendment; alteration"}	\N	\N	\N
快晴	かいせい	{}	{"good weather"}	\N	\N	\N
解析	かいせき	{事物の構成要素を細かく理論的に調べることによって、その本質を明らかにすること。「調査資料を―する」}	{analysis}	\N	\N	\N
解説	かいせつ	{}	{"explanation; commentary"}	\N	\N	\N
回線	かいせん	{電信・電話をつなぐ線。「通信ー」}	{"circuit; (communication) line"}	\N	\N	\N
改善	かいぜん	{}	{"betterment; improvement; incremental and continuous improvement"}	\N	\N	\N
回送	かいそう	{}	{forwarding}	\N	\N	\N
階層	かいそう	{}	{"class; level; stratum; hierarchy"}	\N	\N	\N
快速	かいそく	{気持ちがよいほど速いこと。また、そのさま。「快速電車」の略。「通勤ー」}	{"high speed"}	\N	\N	\N
改造	かいぞう	{改装}	{"remodeling; reshuffle"}	\N	\N	\N
開拓	かいたく	{新しい分野などを切り開くこと}	{"reclamation (of wasteland); cultivation; pioneer"}	\N	\N	\N
会談	かいだん	{}	{"conversation; conference; discussion; interview"}	\N	\N	\N
階段	かいだん	{}	{stairs}	\N	\N	\N
懐中電灯	かいちゅうでんとう	{}	{flashlight}	\N	\N	\N
開通	かいつう	{}	{"opening; open"}	\N	\N	\N
貝塚	かいづか	{}	{"midden (old dump)"}	\N	\N	\N
改訂	かいてい	{}	{revision}	\N	\N	\N
改定	かいてい	{}	{reform}	\N	\N	\N
海底	かいてい	{海の底。}	{"sea bottom"}	\N	\N	\N
快適	かいてき	{}	{"pleasant; agreeable; comfortable"}	\N	\N	\N
回転	かいてん	{}	{"rotation; revolution; turning"}	\N	\N	\N
回答	かいとう	{}	{"reply; answer"}	\N	\N	\N
解答	かいとう	{}	{"answer; solution"}	\N	\N	\N
解読	かいどく	{}	{"deciphering; decoding"}	\N	\N	\N
開発	かいはつ	{}	{"development; exploitation"}	\N	\N	\N
海抜	かいばつ	{}	{"height above sea level"}	\N	\N	\N
回避	かいひ	{物事を避けてぶつからないようにすること。また、不都合な事態にならないようにすること。「責任を―する」}	{"〔責任などの〕evasion; 〔危険などの〕avoidance"}	\N	\N	\N
開封	かいふう	{郵便物などの封を切ること。「無断でーする」}	{"open (a letter)"}	\N	\N	\N
回復	かいふく	{}	{"recovery (from illness); improvement; rehabilitation; restoration"}	\N	\N	\N
介抱	かいほう	{}	{"nursing; looking after"}	\N	\N	\N
解放	かいほう	{}	{"release; liberation; emancipation"}	\N	\N	\N
開放	かいほう	{}	{"open; throw open; liberalization"}	\N	\N	\N
解剖	かいぼう	{}	{"dissection; autopsy"}	\N	\N	\N
買い物	かいもの	{}	{shopping}	\N	\N	\N
海洋	かいよう	{}	{ocean}	\N	\N	\N
回覧	かいらん	{}	{circulation}	\N	\N	\N
海流	かいりゅう	{}	{"ocean current"}	\N	\N	\N
改良	かいりょう	{}	{"improvement; reform"}	\N	\N	\N
回路	かいろ	{}	{"circuit (electric)"}	\N	\N	\N
会話	かいわ	{複数の人が互いに話すこと。また、その話。「―を交わす」「親しそうに―する」「英―」}	{"〔会談〕(a) conversation; a talk ((with)); 〔対話〕a dialogue"}	\N	\N	\N
買う	かう	{}	{buy}	\N	\N	\N
飼う	かう	{}	{"keep; raise; feed"}	\N	\N	\N
返す	かえす	{}	{"return (something)"}	\N	\N	\N
帰す	かえす	{}	{"to send back"}	\N	\N	\N
却って	かえって	{}	{"on the contrary; rather; all the more; instead"}	\N	\N	\N
帰り	かえり	{}	{"return (noun)"}	\N	\N	\N
省みる	かえりみる	{}	{"to reflect"}	\N	\N	\N
顧みる	かえりみる	{}	{"to look back; to turn around; to review"}	\N	\N	\N
変える	かえる	{変化する}	{change}	\N	\N	\N
反る	かえる	{}	{"change; turn over; turn upside down"}	\N	\N	\N
返る	かえる	{}	{"to return; to come back; to go back"}	\N	\N	\N
帰る	かえる	{}	{"go back; go home; come home; return"}	\N	\N	\N
顔	かお	{頭部の前面。目・口・鼻などのある部分。つら。おもて。「毎朝―を洗う」}	{face}	\N	\N	\N
家屋	かおく	{}	{"house; building"}	\N	\N	\N
顔付き	かおつき	{}	{"(outward) looks; features; face; countenance; expression"}	\N	\N	\N
課外	かがい	{}	{extracurricular}	\N	\N	\N
抱える	かかえる	{}	{"hold or carry under or in the arms"}	\N	\N	\N
化学	かがく	{}	{chemistry}	\N	\N	\N
科学	かがく	{}	{science}	\N	\N	\N
掲げる	かかげる	{}	{"to publish; to print; to carry (an article); to put up; to hang out; to hoist; to fly (a sail); to float (a flag)"}	\N	\N	\N
鏡	かがみ	{}	{mirror}	\N	\N	\N
輝く	かがやく	{}	{"shine; glitter; sparkle"}	\N	\N	\N
係り	かかり	{}	{"official; duty; person in charge"}	\N	\N	\N
係長	かかりちょう	{官庁・会社などでの役職の一。その部署の係員の長で、普通は課長の下の地位。}	{"a subsection chief"}	\N	\N	\N
掛かる	かかる	{}	{"take (time); need; cost"}	\N	\N	\N
係わる	かかわる	{重大なつながりをもつ。影響が及ぶ。「命に―・る問題」}	{"concern oneself in; have to do with; affect; influence"}	\N	\N	\N
関わる	かかわる	{関係をもつ。関係する。関する。「研究に―・った人々」}	{"have to do ((with))⇒かんけい(関係)"}	\N	\N	\N
拘る	かかわる	{こだわる。「つまらぬことに―・っている場合ではない」}	{"fixate; fuss over; be concerned"}	\N	\N	\N
下記	かき	{ある記事や文章のあとに書きしるすこと。また、その文章。「詳細は―のとおり」⇔上記。}	{"the following"}	\N	\N	\N
鍵	かぎ	{}	{key}	\N	\N	\N
書留	かきとめ	{}	{"writing down; putting on record"}	\N	\N	\N
書き取り	かきとり	{}	{dictation}	\N	\N	\N
香る	かおる	{よいにおいがする。芳香を放つ。「梅が―・る」}	{"be fragrant; smell well"}	\N	{薫る}	\N
代える	かえる	{}	{"to exchange; to interchange; to substitute; to replace"}	\N	{換える,替える}	\N
価格	かかく	{商品の価値を貨幣で表したもの。値段。}	{"〔売り手が要求する〕(a) price; 〔代価・原価としての〕(a) cost; 〔価値〕(a) value"}	\N	\N	\N
介入	かいにゅう	{当事者以外の者が入り込むこと。争いやもめごとなどの間に入って干渉すること。「国際紛争に―する」}	{"intervention 〜する intervene ((in; between)); 〔お節介で〕meddle ((in; with))"}	\N	\N	\N
書き取る	かきとる	{}	{"to write down; to take dictation; to take notes"}	\N	\N	\N
垣根	かきね	{}	{hedge}	\N	\N	\N
掻き回す	かきまわす	{}	{"to stir up; to churn; to ransack; to disturb"}	\N	\N	\N
限る	かぎる	{}	{"to limit; restrict; confine"}	\N	\N	\N
家禽	かきん	{}	{fowl}	\N	\N	\N
格	かく	{}	{"status; character; case"}	\N	\N	\N
書く	かく	{文字や符号をしるす。「持ち物に名前を―・く」}	{write}	\N	\N	\N
欠く	かく	{}	{"to lack; to break; to crack; to chip"}	\N	\N	\N
画	かく	{}	{stroke}	\N	\N	\N
核	かく	{}	{"nucleus; kernel"}	\N	\N	\N
各	かく	{主に漢語名詞に付いて、多くのものの一つ一つ、一つ一つのどれもがみな、の意を表す。「―教室」「―大学」「―クラス別々に行う」}	{each}	\N	\N	\N
家具	かぐ	{}	{furniture}	\N	\N	\N
架空	かくう	{}	{"aerial; overhead; fiction; fanciful"}	\N	\N	\N
閣議	かくぎ	{}	{"cabinet meeting"}	\N	\N	\N
覚悟	かくご	{}	{"resolution; resignation; readiness; preparedness"}	\N	\N	\N
格差	かくさ	{資格・等級・価格などの違い。差。「賃金のーを是正する」}	{"〔相違〕a difference; 〔隔たり〕a gap"}	\N	\N	\N
拡散	かくさん	{}	{"scattering; diffusion"}	\N	\N	\N
各自	かくじ	{}	{"individual; each"}	\N	\N	\N
確実	かくじつ	{}	{"certainty; reliability; soundness"}	\N	\N	\N
各種	かくしゅ	{}	{"every kind; all sorts"}	\N	\N	\N
隔週	かくしゅう	{}	{"every other week"}	\N	\N	\N
拡充	かくじゅう	{}	{expansion}	\N	\N	\N
確信	かくしん	{}	{"conviction; confidence"}	\N	\N	\N
革新	かくしん	{}	{"reform; innovation"}	\N	\N	\N
核心部	かくしんぶ	{}	{crux}	\N	\N	\N
隠す	かくす	{}	{"to hide; to conceal"}	\N	\N	\N
覚醒剤	かくせいざい	{例えばアンフェタミン}	{"Awakening Drug; stimulant (e.g. meth-; ampetamine)"}	\N	\N	\N
拡大	かくだい	{}	{"magnification; enlargement"}	\N	\N	\N
核弾頭	かくだんとう	{ミサイル・魚雷などの先端に取り付ける核爆発装置。}	{"a nuclear warhead"}	\N	\N	\N
各地	かくち	{}	{"every place; various places"}	\N	\N	\N
拡張	かくちょう	{}	{"expansion; extension; enlargement; escape"}	\N	\N	\N
確定	かくてい	{}	{"definition (math); decision; settlement"}	\N	\N	\N
角度	かくど	{}	{angle}	\N	\N	\N
各年	かくとし	{}	{"each year"}	\N	\N	\N
獲得	かくとく	{}	{"acquisition; possession"}	\N	\N	\N
確認	かくにん	{}	{"affirmation; confirmation"}	\N	\N	\N
格納庫	かくのうこ	{航空機などを入れ置いたり整備を行ったりするための建物。}	{"a hangar"}	\N	\N	\N
格別	かくべつ	{}	{exceptional}	\N	\N	\N
確保	かくほ	{}	{"guarantee; ensure; maintain; insure; secure"}	\N	\N	\N
革命	かくめい	{}	{revolution}	\N	\N	\N
隔離	かくり	{へだたること。へだて離すこと。「小さい私と広い世の中とを―している此硝子戸の中へ、時々人が入って来る」}	{"isolation; quarantine"}	\N	\N	\N
確立	かくりつ	{}	{establishment}	\N	\N	\N
確率	かくりつ	{}	{probability}	\N	\N	\N
閣僚	かくりょう	{ミニスター}	{minister}	\N	\N	\N
隠れる	かくれる	{}	{"hide; be hidden; conceal oneself; disappear"}	\N	\N	\N
寡欲	かよく	{欲が少ないこと。また、そのさま。「―な（の）人」}	{unselfishness}	\N	\N	\N
寡君	かくん	{他国の人に対して自分の主君をへりくだっていう語。}	{"(humble word for lord towards other countries?)"}	\N	\N	\N
掛け	かけ	{}	{credit}	\N	\N	\N
賭け	かけ	{}	{"betting; gambling; a gamble"}	\N	\N	\N
掛け合う	かけあう	{互いに掛ける。「声を―・う」}	{"(apply) to each other"}	\N	\N	\N
駆け足	かけあし	{}	{"running fast; double time"}	\N	\N	\N
家計	かけい	{}	{"household economy; family finances"}	\N	\N	\N
掛け算	かけざん	{}	{multiplication}	\N	\N	\N
可決	かけつ	{会議で、提出議案の承認を決定すること。反：否決。「賛成多数でーする」}	{"approval; adoption; passing"}	\N	\N	\N
角	かく	{}	{"angle; bishop (shogi)"}	\N	\N	\N
影	かげ	{}	{"shade; shadow; other side"}	\N	{陰}	\N
佳句	かく	{}	{"beautiful passage of literature"}	\N	{画く}	\N
ヶ月	かげつ	{}	{"(number of) months"}	\N	\N	\N
駆けっこ	かけっこ	{}	{"(foot) race"}	\N	\N	\N
欠片	かけら	{物の欠けた一片。断片。「せんべいの―」}	{"〔欠けた一片〕a fragment; a broken piece"}	\N	\N	\N
欠ける	かける	{}	{"be lacking"}	\N	\N	\N
賭ける	かける	{}	{"to wager; to bet; to risk; to stake; to gamble"}	\N	\N	\N
駆ける	かける	{}	{"to run (race esp. horse); to gallop; to canter"}	\N	\N	\N
加減	かげん	{}	{"addition and subtraction; degree; extent; measure; chance"}	\N	\N	\N
過去	かこ	{前のこと}	{past}	\N	\N	\N
火口	かこう	{}	{crater}	\N	\N	\N
下降	かこう	{}	{"downward; descent; fall; drop"}	\N	\N	\N
加工	かこう	{}	{"manufacturing; processing; treatment"}	\N	\N	\N
化合	かごう	{}	{"chemical combination"}	\N	\N	\N
囲む	かこむ	{}	{surround}	\N	\N	\N
傘	かさ	{}	{umbrella}	\N	\N	\N
笠	かさ	{}	{"shade; bamboo hat"}	\N	\N	\N
火災	かさい	{}	{"conflagration; fire"}	\N	\N	\N
火砕流	かさいりゅう	{}	{"(volcanic) eruption"}	\N	\N	\N
佳作	かさく	{}	{"fine work; good piece of work"}	\N	\N	\N
風車	かざぐるま	{}	{"windmill; pinwheel"}	\N	\N	\N
重ねる	かさねる	{}	{"pile up; add; repeat"}	\N	\N	\N
嵩張る	かさばる	{}	{"to be bulky; to be unwieldy; to grow voluminous"}	\N	\N	\N
飾り	かざり	{}	{decoration}	\N	\N	\N
飾る	かざる	{他の物を添えたり、手を加えたりするなどして、美しく見せるようにする。装飾する。「食卓を花で―・る」}	{decorate}	\N	\N	\N
火山	かざん	{}	{volcano}	\N	\N	\N
火山灰	かざんばい	{}	{"volcanic ashes"}	\N	\N	\N
菓子	かし	{}	{pastry}	\N	\N	\N
貸し	かし	{}	{"loan; lending"}	\N	\N	\N
華氏	かし	{}	{fahrenheit}	\N	\N	\N
火事	かじ	{}	{fire}	\N	\N	\N
家事	かじ	{}	{"housework; domestic chores"}	\N	\N	\N
賢い	かしこい	{}	{"wise; clever; smart"}	\N	\N	\N
畏まりました	かしこまりました	{}	{certainly!}	\N	\N	\N
貸し出し	かしだし	{}	{"lending; loaning"}	\N	\N	\N
過失	かしつ	{}	{"error; blunder; accident"}	\N	\N	\N
加湿器	かしつき	{}	{humidifier}	\N	\N	\N
果実	かじつ	{}	{"fruit; nut; berry"}	\N	\N	\N
貸間	かしま	{}	{"room to let"}	\N	\N	\N
貸家	かしや	{}	{"house for rent"}	\N	\N	\N
歌手	かしゅ	{}	{singer}	\N	\N	\N
仮称	かしょう	{}	{"temporary name"}	\N	\N	\N
過剰	かじょう	{}	{excess}	\N	\N	\N
箇条書き	かじょうがき	{}	{"itemized form; itemization"}	\N	\N	\N
貸す	かす	{}	{lend}	\N	\N	\N
課す	かす	{}	{"〔負わせる〕impose ((a task on [upon] a person)); 〔割り当てる〕assign ((a task to a person))"}	\N	\N	\N
微か	かすか	{}	{"faint; dim; weak; indistinct; hazy; poor; wretched"}	\N	\N	\N
霞	かすみ	{}	{"〔薄い霧〕a haze; a mist (hazeは煙や塵を思わせるが水分を感じさせない．mistは水分を含む)"}	\N	\N	\N
化する	かする	{}	{"to change into; to convert into; to transform; to be reduced; to influence; to improve (someone)"}	\N	\N	\N
風邪	かぜ	{}	{"common cold"}	\N	\N	\N
風	かぜ	{}	{"wind; cold"}	\N	\N	\N
火星	かせい	{}	{"Mars (planet)"}	\N	\N	\N
課税	かぜい	{}	{taxation}	\N	\N	\N
化石	かせき	{}	{"fossil; petrifaction; fossilization"}	\N	\N	\N
稼ぐ	かせぐ	{}	{"earn income; to labor"}	\N	\N	\N
下線	かせん	{}	{underline}	\N	\N	\N
河川	かせん	{}	{rivers}	\N	\N	\N
化繊	かせん	{}	{"synthetic fibres"}	\N	\N	\N
過疎	かそ	{}	{depopulation}	\N	\N	\N
数える	かぞえる	{}	{count}	\N	\N	\N
加速	かそく	{}	{acceleration}	\N	\N	\N
個所	かしょ	{}	{"passage; place; point; part"}	\N	{箇所}	\N
畏まる	かしこまる	{謹みの気持ちを表し堅苦しく姿勢を正して座る。正座する。「―・っていないで、ひざをお崩しなさい」,命令・依頼などを謹んで承る意を表す。承りました。「はい、―・りました」}	{"〔正座する〕sit upright; 〔堅苦しい態度を取る〕stand on ceremony",〔承る〕certainly!}	\N	{畏る}	\N
家族	かぞく	{}	{"family; members of a family"}	\N	\N	\N
加速度	かそくど	{}	{acceleration}	\N	\N	\N
過多	かた	{}	{"excess; superabundance"}	\N	\N	\N
型	かた	{}	{"mold; model; style; shape; data type"}	\N	\N	\N
肩	かた	{}	{shoulder}	\N	\N	\N
固い	かたい	{}	{"firm (not viscous or easily moved); stubborn; certain; solemn"}	\N	\N	\N
硬い	かたい	{}	{"solid; hard (especially metal; stone); unpolished writing"}	\N	\N	\N
堅い	かたい	{}	{"hard (especially wood); steadfast; honorable; stuffy writing"}	\N	\N	\N
難い	かたい	{}	{"difficult; hard"}	\N	\N	\N
課題	かだい	{}	{"subject; theme; task"}	\N	\N	\N
片思い	かたおもい	{}	{"unrequited love"}	\N	\N	\N
片仮名	かたかな	{}	{katakana}	\N	\N	\N
気質	かたぎ	{}	{"spirit; character; trait; temperament; disposition"}	\N	\N	\N
片言	かたこと	{}	{"a smattering; talk like a baby; speak haltingly"}	\N	\N	\N
形	かたち	{}	{"form; shape"}	\N	\N	\N
片付く	かたづく	{}	{"be put in order; be put to rights; be disposed of; be solved; be finished; be married (off)"}	\N	\N	\N
片付け	かたづけ	{}	{"tidying up; finishing"}	\N	\N	\N
片付ける	かたづける	{}	{"tidy up"}	\N	\N	\N
刀	かたな	{}	{"sword; blade"}	\N	\N	\N
堅物	かたぶつ	{きまじめで、融通の利かない人。かたじん。かたぞう。}	{"a strait-laced person; (口)a square;(米口)a straight arrow"}	\N	\N	\N
塊	かたまり	{}	{"lump; mass; clod; cluster"}	\N	\N	\N
固まる	かたまる	{}	{"harden; solidify; become firm; become certain"}	\N	\N	\N
片道	かたみち	{}	{"one-way (trip)"}	\N	\N	\N
傾ける	かたむける	{}	{"to incline; to list; to bend; to lean; to tip; to tilt; to slant; to concentrate on; to ruin (a country); to squander; to empty"}	\N	\N	\N
固める	かためる	{}	{"to harden; to freeze; to fortify"}	\N	\N	\N
片寄る	かたよる	{}	{"be one-sided; partial; prejudiced; biased; lean; be inclined"}	\N	\N	\N
偏る	かたよる	{}	{"to be one-sided; to incline; to be partial; to be prejudiced; to lean; to be biased"}	\N	\N	\N
語る	かたる	{話す。特に、まとまった内容を順序だてて話して聞かせる。「目撃者の―・るところによれば」「決意の程を―・る」}	{"talk; tell; recite"}	\N	\N	\N
傍ら	かたわら	{}	{"beside(s); while; nearby"}	\N	\N	\N
花壇	かだん	{}	{"flower bed"}	\N	\N	\N
価値	かち	{}	{"value; worth; merit"}	\N	\N	\N
勝ち	かち	{}	{"win; victory"}	\N	\N	\N
家畜	かちく	{}	{"domestic animals; livestock; cattle"}	\N	\N	\N
勝ち誇る	かちほこる	{}	{"bragging after a win"}	\N	\N	\N
割	かつ	{}	{"divide; cut; halve; separate; split; rip; break; crack; smash; dilute"}	\N	\N	\N
且つ	かつ	{}	{"yet; and"}	\N	\N	\N
活気	かっき	{}	{"energy; liveliness"}	\N	\N	\N
画期	かっき	{}	{epoch-making}	\N	\N	\N
担ぐ	かつぐ	{}	{"carry on shoulder"}	\N	\N	\N
括弧	かっこ	{}	{"parenthesis; brackets"}	\N	\N	\N
格好	かっこう	{}	{"shape; form; appearance; manner"}	\N	\N	\N
各国	かっこく	{それぞれの国。「―首脳」}	{"every [each] country [nation]; 〔諸国〕various countries [states]; 〔万国〕all states [countries]"}	\N	\N	\N
活字	かつじ	{}	{"printing type"}	\N	\N	\N
褐色	かっしょく	{}	{brown}	\N	\N	\N
曽て	かつて	{過去のある一時期を表す語。以前。昔。}	{"once; formerly"}	\N	\N	\N
葛藤	かっとう	{人と人が互いに譲らず対立し、いがみ合うこと。「親子の―」}	{"(a) conflict ((between)); trouble; difficulties; complications"}	\N	\N	\N
活動	かつどう	{}	{"action; activity"}	\N	\N	\N
活発	かっぱつ	{}	{"vigor; active"}	\N	\N	\N
割賦	かっぷ	{}	{"allotment; quota"}	\N	\N	\N
活躍	かつやく	{めざましく活動すること。「社会の第一線で―する」}	{activity}	\N	\N	\N
活用	かつよう	{}	{"conjugation; practical use"}	\N	\N	\N
活力	かつりょく	{}	{"vitality; energy"}	\N	\N	\N
傾く	かたむく	{}	{"incline toward; slant; lurch; be disposed to; go down (sun); wane; sink; decline"}	\N	\N	\N
方	かた	{}	{"polite way of indicating person"}	\N	\N	\N
敵	かたき	{}	{"enemy; rival"}	\N	\N	\N
勝つ	かつ	{}	{"〔勝利を得る〕win; 〔負かす〕defeat; beat",〔勝る〕surpass;}	\N	\N	\N
勝手	かって	{"1 他人のことはかまわないで、自分だけに都合がよいように振る舞うこと。「そんな-は許さない」",台所。キッチン。「―仕事」}	{"selfishness; own convenience",kitchen}	\N	\N	\N
仮定	かてい	{}	{"assumption; supposition; hypothesis"}	\N	\N	\N
課程	かてい	{}	{"course; curriculum"}	\N	\N	\N
過程	かてい	{}	{"a process"}	\N	\N	\N
仮名	かな	{}	{"kana; alias; pseudonym; pen name"}	\N	\N	\N
悲しむ	かなしむ	{}	{"be sad; mourn for; regret"}	\N	\N	\N
仮名遣い	かなづかい	{}	{"kana orthography; syllabary spelling"}	\N	\N	\N
金槌	かなづち	{}	{"(iron) hammer; punishment"}	\N	\N	\N
鉄棒	かなぼう	{}	{"iron rod; crowbar; horizontal bar (gymnastics)"}	\N	\N	\N
必ずしも	かならずしも	{}	{"(not) always; (not) necessarily; (not) all; (not) entirely"}	\N	\N	\N
可成	かなり	{}	{"considerably; fairly; quite"}	\N	\N	\N
加入	かにゅう	{}	{"becoming a member; joining; entry; admission; subscription; affiliation; adherence; signing"}	\N	\N	\N
鐘	かね	{}	{"bell; chime"}	\N	\N	\N
予言	かねごと	{}	{"prediction; promise; prognostication"}	\N	\N	\N
加熱	かねつ	{}	{heating}	\N	\N	\N
兼ねて	かねて	{}	{simultaneously}	\N	\N	\N
鐘紡	かねぼう	{（会社の名前）}	{"KaneBou (company name)"}	\N	\N	\N
金持ち	かねもち	{}	{"rich man"}	\N	\N	\N
兼ねる	かねる	{一つの物が二つ以上の働きを合わせもつ。一つの物が二つ以上の用をする。「大は小を―・ねる」「書斎と応接間とを―・ねた部屋」}	{"hold (position); serve; be unable; be beyond one´s ability; cannot; hesitate to; combine with; use with; be impatient"}	\N	\N	\N
可能	かのう	{}	{"possible; practicable; feasible"}	\N	\N	\N
可能性	かのうせい	{物事が実現できる見込み。}	{possibility}	\N	\N	\N
彼女	かのじょ	{}	{she}	\N	\N	\N
下番	かばん	{}	{"going off duty"}	\N	\N	\N
鞄	かばん	{}	{briefcase}	\N	\N	\N
過半数	かはんすう	{}	{majority}	\N	\N	\N
華美	かび	{}	{"pomp; splendor; gaudiness"}	\N	\N	\N
花瓶	かびん	{}	{"(flower) vase"}	\N	\N	\N
株	かぶ	{}	{"share; stock; stump (of tree)"}	\N	\N	\N
株式	かぶしき	{}	{"stock (company)"}	\N	\N	\N
被せる	かぶせる	{}	{"cover (with something); plate something (with a metal); pour or dash a liquid (on something)"}	\N	\N	\N
被る	かぶる	{}	{"wear; put on (head); pour or dash water (on oneself)"}	\N	\N	\N
気触れる	かぶれる	{}	{"to react to; to be influenced by; to go overboard for"}	\N	\N	\N
花粉	かふん	{}	{pollen}	\N	\N	\N
花粉症	かふんしょう	{}	{"hay fever; pollen allergy"}	\N	\N	\N
壁	かべ	{}	{wall}	\N	\N	\N
貨幣	かへい	{}	{"money; currency; coinage"}	\N	\N	\N
釜	かま	{}	{"iron pot; kettle"}	\N	\N	\N
窯	かま	{}	{kiln}	\N	\N	\N
構う	かまう	{}	{"mind; care about; be concerned about"}	\N	\N	\N
構え	かまえ	{}	{"posture; pose; style"}	\N	\N	\N
構える	かまえる	{}	{"to set up"}	\N	\N	\N
加味	かみ	{}	{"seasoning; flavoring"}	\N	\N	\N
神	かみ	{}	{god}	\N	\N	\N
紙	かみ	{}	{paper}	\N	\N	\N
髪	かみ	{}	{hair}	\N	\N	\N
神々	かみがみ	{}	{gods}	\N	\N	\N
噛み切る	かみきる	{}	{"to bite off; to gnaw through"}	\N	\N	\N
紙屑	かみくず	{}	{wastepaper}	\N	\N	\N
神様	かみさま	{}	{god}	\N	\N	\N
剃刀	かみそり	{}	{razor}	\N	\N	\N
過密	かみつ	{}	{crowded}	\N	\N	\N
髪の毛	かみのけ	{}	{"hair (on head)"}	\N	\N	\N
加盟	かめい	{盟約に加入すること。団体や組織に一員として加わること。「国連に―する」}	{"affiliation ((with))"}	\N	\N	\N
仮面	かめん	{}	{mask}	\N	\N	\N
哀しい	かなしい	{心が痛んで泣けてくるような気持ちである。嘆いても嘆ききれぬ気持ちだ。「友が死んで―・い」⇔うれしい。}	{"sad; miserable; ((やや文)) sorrowful"}	\N	{悲しい}	\N
家内	かない	{妻。ふつう、他人に対して自分の妻をいうときに用いる。ワイフ。「―も喜んでおります」}	{"(my) wife"}	\N	\N	\N
必ず	かならず	{確実な推量、または強い意志・要請を表す。まちがいなく。絶対に。きっと。「いつかそういう日が―来る」「―勝ってみせる」「印鑑を―持参すること」「―成功するとは限らない」,例外のないさま。きまって。いつでも。「毎朝―散歩する」「会えば―論争になる」}	{"〔間違いなく〕certainly; surely",〔いつも〕always}	\N	\N	\N
家庭	かてい	{夫婦・親子などの関係にある者が生活をともにする、小さな集団。また、その生活する所。家。ホーム。「明るい―を作る」}	{"a home; a family〔世帯〕a household"}	\N	\N	\N
科目	かもく	{}	{"(school) subject; curriculum; course"}	\N	\N	\N
かも知れない	かもしれない	{断定はできないが、その可能性があることを表す。「あの建物は学校ーない」}	{"may; perhaps; might"}	\N	\N	\N
貨物	かもつ	{}	{"cargo; freight; money or assets"}	\N	\N	\N
火曜	かよう	{}	{Tuesday}	\N	\N	\N
歌謡	かよう	{}	{"song; ballad"}	\N	\N	\N
火曜日	かようび	{}	{Tuesday}	\N	\N	\N
殻	から	{}	{"shell; husk; hull; chaff"}	\N	\N	\N
体付き	からだつき	{筋肉のつき方や骨格など、外部に現れた身体の状況・形。「ひょろっとした―」}	{"body build; figure"}	\N	\N	\N
空っぽ	からっぽ	{}	{"empty; vacant; hollow"}	\N	\N	\N
絡む	からむ	{}	{"to entangle; to entwine"}	\N	\N	\N
下吏	かり	{}	{"lower official"}	\N	\N	\N
借り	かり	{}	{"borrowing; debt; loan"}	\N	\N	\N
狩り	かり	{"山野で鳥獣を追いかけて捕らえること。猟 (りょう) 。狩猟。《季 冬》「弓張や―に出る子のかげぼふし／嘯山」"}	{hunting}	\N	\N	\N
借りる	かりる	{}	{"borrow; hire; rent; buy on credit"}	\N	\N	\N
刈る	かる	{}	{"cut (hair); mow (grass); clip; shear; trim; prune; harvest; reap"}	\N	\N	\N
軽い	かるい	{}	{"light; non-serious; minor"}	\N	\N	\N
加留多	かるた	{}	{"(pt:) (n) playing cards (pt: carta)"}	\N	\N	\N
彼	かれ	{}	{he}	\N	\N	\N
彼等	かれら	{}	{"they (usually male)"}	\N	\N	\N
彼ら	かれら	{}	{they}	\N	\N	\N
枯れる	かれる	{}	{"wither; die (plant)"}	\N	\N	\N
過労	かろう	{}	{"overwork; strain"}	\N	\N	\N
辛うじて	かろうじて	{}	{"barely; narrowly; just manage to do st"}	\N	\N	\N
川	かわ	{}	{river}	\N	\N	\N
河	かわ	{}	{"river; stream"}	\N	\N	\N
皮	かわ	{}	{"skin; hide; leather; fur; pelt; bark; shell"}	\N	\N	\N
革	かわ	{}	{leather}	\N	\N	\N
可愛い	かわいい	{}	{"pretty; cute; lovely; charming; dear; darling; pet"}	\N	\N	\N
可愛がる	かわいがる	{}	{"to love; to be affectionate"}	\N	\N	\N
可哀想	かわいそう	{}	{"poor; pitiable; pathetic"}	\N	\N	\N
可愛らしい	かわいらしい	{"１ 子供らしい無邪気さや見た目の好ましさで、人をほほえませるようなさま。「ー・い口もと」２ 小さくて愛らしい。「指先ほどのー・い魚」"}	{"lovely; adorable; sweet"}	\N	\N	\N
乾かす	かわかす	{}	{"to dry"}	\N	\N	\N
渇き	かわき	{のどに潤いがなくなって、水分が欲しくなること。「ビールで―をいやす」}	{〔のどの〕thirst}	\N	\N	\N
渇く	かわく	{}	{"be thirsty"}	\N	\N	\N
乾く	かわく	{}	{"get dry"}	\N	\N	\N
交わす	かわす	{}	{"to exchange (messages); to dodge; to parry; to avoid; to turn aside"}	\N	\N	\N
為替	かわせ	{}	{"money order; exchange"}	\N	\N	\N
瓦	かわら	{}	{"roof tile"}	\N	\N	\N
代わり	かわり	{}	{"instead of"}	\N	\N	\N
代わる	かわる	{}	{"to take the place of; to relieve; to be substituted for; to be exchanged; to change places with; to take turns; to be replaced"}	\N	\N	\N
代る	かわる	{}	{"take the place of; relieve; be substituted for; be exchanged; change places with; take turns; be replaced"}	\N	\N	\N
代わる代わる	かわるがわる	{}	{alternately}	\N	\N	\N
観	かん	{}	{"look; appearance; spectacle"}	\N	\N	\N
幹	かん	{}	{"(tree) trunk"}	\N	\N	\N
勘	かん	{}	{"perception; intuition"}	\N	\N	\N
缶	かん	{}	{"can; tin"}	\N	\N	\N
簡易	かんい	{}	{"simplicity; easiness; quasi-"}	\N	\N	\N
間隔	かんかく	{物と物とのあいだの距離。「ーを置いて並ぶ」}	{"interval; space (spacial; or in text)"}	\N	\N	\N
感慨	かんがい	{}	{"strong feelings; deep emotion"}	\N	\N	\N
管外	かんがい	{権限の及ぶ区域の外。管轄区域の外。⇔管内。}	{"outside jurisdiction (of a police station)"}	\N	\N	\N
空	から	{}	{emptiness}	\N	\N	\N
辛い	からい	{}	{"painful; heart-breaking"}	\N	\N	\N
通う	かよう	{一定の区間を定期的に、何度も行き来する。「自転車で学校に―・う」「病院に―・う」}	{"〔往来する〕go to and from ((a place)); 〔通勤・通学する〕commute ((from, to)); 〔しばしば行く〕frequent ((a place)); go to (school; work)"}	\N	\N	\N
考え	かんがえ	{}	{"thinking; thought; ideas; intention"}	\N	\N	\N
考える	かんがえる	{}	{think}	\N	\N	\N
感覚	かんかく	{}	{"sense; sensation"}	\N	\N	\N
管轄	かんかつ	{}	{"jurisdiction; control"}	\N	\N	\N
換気	かんき	{}	{ventilation}	\N	\N	\N
寒気	かんき	{}	{"cold; frost; chill"}	\N	\N	\N
換気扇	かんきせん	{家屋の壁や窓などに取り付け、モーターで羽根を回転させて室内の空気を排出する電気器具。}	{"a ventilation fan; ((英)) an extractor fan"}	\N	\N	\N
観客	かんきゃく	{}	{"audience; spectator(s)"}	\N	\N	\N
環境	かんきょう	{}	{"environment; circumstance"}	\N	\N	\N
関係	かんけい	{二つ以上の物事が互いにかかわり合うこと。また、そのかかわり合い。「前後のーから判断する」「事件にーする」}	{"relation; relationship"}	\N	\N	\N
歓迎	かんげい	{}	{"welcome; reception"}	\N	\N	\N
感激	かんげき	{}	{"deep emotion; impression; inspiration"}	\N	\N	\N
簡潔	かんけつ	{}	{"brevity; conciseness; simplicity"}	\N	\N	\N
還元	かんげん	{}	{"resolution; reduction; return to origins"}	\N	\N	\N
漢語	かんご	{}	{"Chinese word; Sino-Japanese word"}	\N	\N	\N
看護	かんご	{}	{"nursing; (army) nurse"}	\N	\N	\N
看護師	かんごし	{傷病者の看護および療養上の世話、医師の診療の補助を職業とする者。国家試験に合格し、厚生労働大臣の免許を受けた者。}	{nurse}	\N	\N	\N
観光	かんこう	{}	{sightseeing}	\N	\N	\N
慣行	かんこう	{}	{"customary practice; habit; traditional event"}	\N	\N	\N
刊行	かんこう	{}	{"publication; issue"}	\N	\N	\N
勧告	かんこく	{}	{"advice; counsel; remonstrance; recommendation"}	\N	\N	\N
監獄	かんごく	{}	{prison}	\N	\N	\N
看護婦	かんごふ	{}	{nurse}	\N	\N	\N
関西	かんさい	{}	{"Kansai (SW half of Japan; including Osaka)"}	\N	\N	\N
観察	かんさつ	{}	{"observation; survey"}	\N	\N	\N
換算	かんさん	{}	{"conversion; change; exchange"}	\N	\N	\N
閑散	かんさん	{}	{"quiet; leisure; inactivity"}	\N	\N	\N
監視	かんし	{}	{"observation; guarding; inspection; surveillance"}	\N	\N	\N
漢字	かんじ	{}	{"Chinese characters; kanji"}	\N	\N	\N
感じ	かんじ	{}	{"feeling; sense; impression"}	\N	\N	\N
感謝	かんしゃ	{}	{"thanks; gratitude"}	\N	\N	\N
患者	かんじゃ	{}	{"a patient"}	\N	\N	\N
観衆	かんしゅう	{}	{"spectators; onlookers; members of the audience"}	\N	\N	\N
慣習	かんしゅう	{}	{"usual (historical) custom"}	\N	\N	\N
干渉	かんしょう	{}	{"interference; intervention"}	\N	\N	\N
鑑賞	かんしょう	{}	{appreciation}	\N	\N	\N
勘定	かんじょう	{代金を支払うこと。また、その代金。「―を済まして店を出る」}	{"〔支払い〕payment; 〔決算〕settlement (of accounts); 〔会計〕accounts; 〔勘定書〕a bill [((米)) check]"}	\N	\N	\N
感情	かんじょう	{}	{"emotion(s); feeling(s); sentiment"}	\N	\N	\N
感触	かんしょく	{}	{"sense of touch; feeling; sensation"}	\N	\N	\N
感じる	かんじる	{}	{"feel; sense; experience"}	\N	\N	\N
感心	かんしん	{}	{"admiration; Well done!"}	\N	\N	\N
関心	かんしん	{}	{"concern; interest"}	\N	\N	\N
肝心	かんじん	{}	{"essential; fundamental; crucial; vital; main"}	\N	\N	\N
関する	かんする	{関係がある。かかわる。「将来に―・する問題」「映画に―・しては、ちょっとうるさい」「我―・せず」}	{"concern; be related"}	\N	\N	\N
感ずる	かんずる	{}	{"feel; sense"}	\N	\N	\N
完成	かんせい	{完全に出来上がること。すっかり仕上げること。「―を見る」「ビルが―する」「大作を―する」}	{"complete; completion; perfection; accomplishment"}	\N	\N	\N
歓声	かんせい	{}	{"cheer; shout of joy"}	\N	\N	\N
関税	かんぜい	{}	{"customs; duty; tariff"}	\N	\N	\N
間接	かんせつ	{}	{indirectness}	\N	\N	\N
感染	かんせん	{}	{"infection; contagion"}	\N	\N	\N
幹線	かんせん	{}	{"main line; trunk line"}	\N	\N	\N
完全	かんぜん	{}	{"perfection; completeness"}	\N	\N	\N
勧善懲悪	かんぜんちょうあく	{善事を勧め、悪事を懲らすこと。特に、小説・芝居などで、善玉が最後には栄え、悪玉は滅びるという筋書きによって示される、道徳的な見解にいう。勧懲。}	{"rewarding good and punishing evil; 〔文学で〕poetic justice"}	\N	\N	\N
簡素	かんそ	{}	{"simplicity; plain"}	\N	\N	\N
乾燥	かんそう	{}	{"dry; arid; dehydrated; insipid"}	\N	\N	\N
感想	かんそう	{}	{"impressions; thoughts"}	\N	\N	\N
観測	かんそく	{}	{observation}	\N	\N	\N
寒帯	かんたい	{}	{"frigid zone"}	\N	\N	\N
簡単	かんたん	{}	{"easy; simple"}	\N	\N	\N
勘違い	かんちがい	{}	{"misunderstanding; wrong guess"}	\N	\N	\N
官庁	かんちょう	{}	{"government office; authorities"}	\N	\N	\N
艦長	かんちょう	{1隻の軍艦の乗組員を指揮統率する最高責任者。}	{"(e.g. submarine) captain"}	\N	\N	\N
缶詰	かんづめ	{}	{"canning; canned goods; tin can"}	\N	\N	\N
官邸	かんてい	{大臣や長官など高級官吏の在任中に、住居として政府が提供する邸宅。「首相―」}	{"an official residence"}	\N	\N	\N
観点	かんてん	{}	{"point of view"}	\N	\N	\N
乾電池	かんでんち	{}	{"dry cell; battery"}	\N	\N	\N
感度	かんど	{}	{"sensitivity; severity (quake)"}	\N	\N	\N
関東	かんとう	{}	{"Kantou (eastern half of Japan; including Tokyo)"}	\N	\N	\N
感動	かんどう	{}	{"being deeply moved; deep emotion; excitement; impression"}	\N	\N	\N
監督	かんとく	{}	{"supervision; control; superintendence"}	\N	\N	\N
管内	かんない	{その役所が管轄する区域の内。⇔管外。}	{"within jurisdiction (of this police station)"}	\N	\N	\N
観念	かんねん	{}	{"idea; notion; conception; sense (e.g. of duty); resignation; preparedness; acceptance"}	\N	\N	\N
乾杯	かんぱい	{}	{"toast (drink)"}	\N	\N	\N
看板	かんばん	{}	{"sign; signboard; doorplate; poster; billboard; appearance; figurehead; policy; attraction; closing time"}	\N	\N	\N
看病	かんびょう	{}	{"nursing (a patient)"}	\N	\N	\N
幹部	かんぶ	{}	{"management; (executive) staff; leaders"}	\N	\N	\N
完璧	かんぺき	{}	{"perfection; completeness; flawless"}	\N	\N	\N
勘弁	かんべん	{}	{"pardon; forgiveness; forbearance"}	\N	\N	\N
感無量	かんむりょう	{}	{"deep feeling; inexpressible feeling; filled with emotion"}	\N	\N	\N
艦名	かんめい	{}	{"ship's name"}	\N	\N	\N
勧誘	かんゆう	{}	{"invitation; solicitation; canvassing; inducement; persuasion; encouragement"}	\N	\N	\N
関与	かんよ	{}	{"participation; taking part in; participating in; being concerned in"}	\N	\N	\N
寛容	かんよう	{}	{"forbearance; tolerance; generosity"}	\N	\N	\N
慣用	かんよう	{}	{"common; customary"}	\N	\N	\N
慣用音	かんようおん	{}	{"accustomed-use sound"}	\N	\N	\N
観覧	かんらん	{}	{viewing}	\N	\N	\N
管理	かんり	{}	{"control; management (e.g. of a business)"}	\N	\N	\N
官吏	かんり	{国家公務員のこと。役人。官員}	{"government official"}	\N	\N	\N
完了	かんりょう	{}	{"completion; conclusion"}	\N	\N	\N
官僚	かんりょう	{}	{"bureaucrat; bureaucracy"}	\N	\N	\N
慣例	かんれい	{}	{"custom; precedent; of convention"}	\N	\N	\N
還暦	かんれき	{}	{"60th birthday"}	\N	\N	\N
関連	かんれん	{ある事柄と他の事柄との間につながりがあること。連関。「―が深い」「―する事柄」「―性」「―質問」}	{"relation; connection; relevance"}	\N	\N	\N
貫禄	かんろく	{}	{"presence; dignity"}	\N	\N	\N
緩和	かんわ	{}	{"relief; mitigation"}	\N	\N	\N
漢和	かんわ	{}	{"Chinese-Japanese (e.g. dictionary)"}	\N	\N	\N
毛	け	{}	{"fur; hair; wool"}	\N	\N	\N
計	けい	{}	{plan}	\N	\N	\N
刑	けい	{}	{"penalty; sentence; punishment"}	\N	\N	\N
傾	けい	{}	{"lean; incline"}	\N	\N	\N
系	けい	{ある関係のもとにつながった統一体。体系。}	{"system; lineage; group"}	\N	\N	\N
軽	けい	{「軽自動車」の略。}	{"abbreviation for light car"}	\N	\N	\N
輕	けい	{「軽」の古い版}	{"old version of 軽 kanji"}	\N	\N	\N
敬意	けいい	{}	{"respect; honour"}	\N	\N	\N
経営	けいえい	{}	{"management; administration"}	\N	\N	\N
経営者	けいえいしゃ	{企業を経営する人。経営方針や経営計画を決め、基本的・全般的管理を担当する。広義には、経営管理者の総称。}	{"a manager; 〔総称〕the top management"}	\N	\N	\N
慶応	けいおう	{日本の元号の一つ。}	{"Keiou was a Japanese era name after Genji and before Meiji."}	\N	\N	\N
経過	けいか	{}	{"passage; expiration; progress"}	\N	\N	\N
警戒	けいかい	{}	{"warning; admonition; vigilance"}	\N	\N	\N
軽快	けいかい	{}	{"rhythmical (e.g. melody); casual (e.g. dress); light; nimble"}	\N	\N	\N
計画	けいかく	{ある事を行うために、あらかじめ方法や順序などを考えること。また、その考えの内容。もくろみ。プラン。予定。つもり。「―を立てる」「―を練る」「工場移転を―する」}	{plan}	\N	\N	\N
警官	けいかん	{}	{policeman}	\N	\N	\N
計器	けいき	{}	{"meter; gauge"}	\N	\N	\N
景気	けいき	{}	{"condition; state; business conditions; the times"}	\N	\N	\N
頃	けい	{}	{"time; about; toward; approximately (time)"}	\N	\N	\N
契機	けいき	{}	{"opportunity; chance"}	\N	\N	\N
敬具	けいぐ	{}	{"Sincerely yours"}	\N	\N	\N
経験	けいけん	{実際に見たり、聞いたり、行ったりすること。また、それによって得られた知識や技能など。「―を積む」「―が浅い」「いろいろな部署を―する」}	{experience}	\N	\N	\N
軽減	けいげん	{}	{abatement}	\N	\N	\N
敬語	けいご	{}	{"honorific; term of respect"}	\N	\N	\N
傾向	けいこう	{}	{"tendency; trend; inclination"}	\N	\N	\N
蛍光灯	けいこうとう	{}	{"fluorescent lamp; person who is slow to react"}	\N	\N	\N
警告	けいこく	{よくない事態が生じそうなので気をつけるよう、告げ知らせること。「再三の―を無視する」「事前に―する」}	{"warning; advice"}	\N	\N	\N
渓谷	けいこく	{}	{valley}	\N	\N	\N
掲載	けいさい	{}	{"appearance (e.g. article in paper)"}	\N	\N	\N
経済	けいざい	{}	{economy}	\N	\N	\N
警察	けいさつ	{社会公共の秩序と安全を維持するため、国家の統治権に基づき、国民に命令・強制する作用。行政・・。}	{"the police"}	\N	\N	\N
警察官	けいさつかん	{}	{"a policeman"}	\N	\N	\N
計算	けいさん	{}	{"calculation; reckoning"}	\N	\N	\N
掲示	けいじ	{}	{"notice; bulletin"}	\N	\N	\N
刑事	けいじ	{}	{"criminal case; (police) detective"}	\N	\N	\N
形式	けいしき	{}	{"form; formality; format; mathematics expression"}	\N	\N	\N
傾斜	けいしゃ	{}	{"inclination; slant; slope; bevel; list; dip"}	\N	\N	\N
形成	けいせい	{}	{formation}	\N	\N	\N
形勢	けいせい	{}	{"condition; situation; prospects"}	\N	\N	\N
軽率	けいそつ	{}	{"rash; thoughtless; careless; hasty"}	\N	\N	\N
携帯	けいたい	{}	{"carrying something"}	\N	\N	\N
形態	けいたい	{}	{"form; shape; figure"}	\N	\N	\N
毛糸	けいと	{}	{"knitting wool"}	\N	\N	\N
経度	けいど	{}	{longitude}	\N	\N	\N
系統	けいとう	{}	{"system; family line; lineage; ancestry; geological formation"}	\N	\N	\N
競馬	けいば	{}	{"horse racing"}	\N	\N	\N
刑罰	けいばつ	{}	{"judgement; penalty; punishment"}	\N	\N	\N
経費	けいひ	{}	{"expenses; cost; outlay"}	\N	\N	\N
警備	けいび	{}	{"defense; guard; policing; security"}	\N	\N	\N
警部	けいぶ	{}	{"police inspector"}	\N	\N	\N
軽蔑	けいべつ	{}	{"scorn; disdain"}	\N	\N	\N
契約	けいやく	{"二人以上の当事者の意思表示の合致によって成立する法律行為。売買・交換・贈与・貸借・雇用・請負・委任・寄託など。「―を結ぶ」「三年間の貸借を―する」→単独行為 →合同行為"}	{"contract; compact; agreement"}	\N	\N	\N
経由	けいゆ	{}	{"go by the way; via"}	\N	\N	\N
形容詞	けいようし	{}	{"(true) adjective"}	\N	\N	\N
形容動詞	けいようどうし	{}	{"adjectival noun; quasi-adjective"}	\N	\N	\N
経歴	けいれき	{}	{"personal history; career"}	\N	\N	\N
経路	けいろ	{}	{"course; route; channel"}	\N	\N	\N
怪我	けが	{}	{"injury; get hurt; be injured"}	\N	\N	\N
汚らわしい	けがらわしい	{}	{"filthy; unfair"}	\N	\N	\N
汚れ	けがれ	{}	{"uncleanness; impurity; disgrace"}	\N	\N	\N
毛皮	けがわ	{}	{"fur; skin; pelt"}	\N	\N	\N
今朝	けさ	{}	{"this morning"}	\N	\N	\N
景色	けしき	{}	{scenery}	\N	\N	\N
消しゴム	けしゴム	{}	{"eraser; India rubber"}	\N	\N	\N
化粧	けしょう	{}	{"make-up (cosmetic)"}	\N	\N	\N
化粧室	けしょうしつ	{化粧や身づくろいをするための部屋。洗面所。便所。}	{"bath room"}	\N	\N	\N
消す	けす	{}	{"erase; delete; turn off power"}	\N	\N	\N
削る	けずる	{}	{"shave (wood or leather); sharpen; plane; whittle; scrape off; reduce; remove; erase"}	\N	\N	\N
桁	けた	{}	{"column; beam; digit"}	\N	\N	\N
獣	けだもの	{}	{"beast; brute"}	\N	\N	\N
傑	けつ	{}	{excellence}	\N	\N	\N
血圧	けつあつ	{}	{"blood pressure"}	\N	\N	\N
決意	けつい	{}	{"decision; determination"}	\N	\N	\N
血液	けつえき	{}	{blood}	\N	\N	\N
結果	けっか	{}	{"result; consequence; outcome"}	\N	\N	\N
結核	けっかく	{}	{"tuberculosis; tubercule"}	\N	\N	\N
欠陥	けっかん	{}	{"defect; fault; deficiency"}	\N	\N	\N
汚す	けがす	{}	{"to disgrace; to dishonour"}	\N	\N	\N
汚れる	けがれる	{}	{"to get dirty; to become dirty"}	\N	\N	\N
稽古	けいこ	{芸能・武術・技術などを習うこと。また、練習。訓練。「―に励む」「―をつける」「毎日―して上達する」}	{"practice; training; study"}	{名,スル}	\N	\N
血管	けっかん	{}	{"blood vessel"}	\N	\N	\N
決議	けつぎ	{}	{"resolution; vote; decision"}	\N	\N	\N
結局	けっきょく	{}	{"after all; eventually"}	\N	\N	\N
決行	けっこう	{}	{"doing (with resolve); carrying out (i.e. a plan)"}	\N	\N	\N
結構	けっこう	{}	{"splendid; nice; wonderful; delicious; sweet; construction; architecture; well enough; tolerably"}	\N	\N	\N
結合	けつごう	{}	{"combination; union"}	\N	\N	\N
結婚	けっこん	{}	{marriage}	\N	\N	\N
傑作	けっさく	{作品が非常にすぐれたできばえであること。また、その作品。「数々のーを残す」}	{"a masterpiece; a fine piece of work"}	\N	\N	\N
決算	けっさん	{}	{"balance sheet; settlement of accounts"}	\N	\N	\N
決して	けっして	{}	{"definitely; by no means; not at all"}	\N	\N	\N
結晶	けっしょう	{}	{"crystal; crystallization"}	\N	\N	\N
決勝	けっしょう	{}	{"decision of a contest; finals (in sports)"}	\N	\N	\N
決心	けっしん	{}	{"determination; resolution"}	\N	\N	\N
結成	けっせい	{}	{formation}	\N	\N	\N
欠席	けっせき	{}	{"absence; non-attendance"}	\N	\N	\N
結束	けっそく	{}	{"union; unity"}	\N	\N	\N
欠損	けっそん	{物の一部が欠けてなくなること}	{"a deficit; loss"}	\N	\N	\N
決断	けつだん	{}	{"decision; determination"}	\N	\N	\N
決定	けってい	{}	{"decision; determination"}	\N	\N	\N
欠点	けってん	{}	{"faults; defect; weakness"}	\N	\N	\N
欠乏	けつぼう	{}	{"want; shortage; famine"}	\N	\N	\N
結末	けつまつ	{最後の締めくくり。最後に到達した結果。「連載小説に―をつける」「悲惨な―」}	{"the ending"}	\N	\N	\N
結論	けつろん	{}	{"reason; sum up; conclude"}	\N	\N	\N
蹴飛ばす	けとばす	{}	{"to kick away; to kick off; to kick (someone); to refuse; to reject"}	\N	\N	\N
煙い	けむい	{}	{smoky}	\N	\N	\N
煙たい	けむたい	{}	{"smoky; feeling awkward"}	\N	\N	\N
煙	けむり	{}	{"smoke; fumes"}	\N	\N	\N
煙る	けむる	{}	{"to smoke (e.g. fire)"}	\N	\N	\N
家来	けらい	{}	{"retainer; retinue; servant"}	\N	\N	\N
蹴る	ける	{}	{kick}	\N	\N	\N
険しい	けわしい	{}	{"inaccessible place; impregnable position; steep place; sharp eyes"}	\N	\N	\N
県	けん	{}	{prefecture}	\N	\N	\N
権	けん	{}	{"authority; the right (to do something)"}	\N	\N	\N
券	けん	{}	{"ticket; coupon; bond; certificate"}	\N	\N	\N
圏	けん	{}	{"sphere; circle; range"}	\N	\N	\N
権威	けんい	{}	{"authority; power; influence"}	\N	\N	\N
検閲	けんえつ	{査察}	{inspection}	\N	\N	\N
喧嘩	けんか	{}	{quarrel/brawl/fight}	\N	\N	\N
見学	けんがく	{}	{"inspection; study by observation; field trip"}	\N	\N	\N
研究	けんきゅう	{}	{"study; research"}	\N	\N	\N
研究室	けんきゅうしつ	{}	{"study (room)"}	\N	\N	\N
謙虚	けんきょ	{}	{"modesty; humility"}	\N	\N	\N
検挙	けんきょ	{検察官・司法警察職員などが認知した犯罪行為について被疑者を取り調べること。容疑者を関係官署に引致する場合をさすこともある。「収賄容疑で―する」}	{arrest}	\N	\N	\N
兼業	けんぎょう	{}	{"side line; second business"}	\N	\N	\N
県警	けんけい	{県の警察}	{"prefecture police"}	\N	\N	\N
権限	けんげん	{}	{"power; authority; jurisdiction"}	\N	\N	\N
健康	けんこう	{異状があるかないかという面からみた、からだの状態。「ーがすぐれない」}	{health}	\N	\N	\N
検査	けんさ	{}	{"inspection (e.g. customs; factory); examination"}	\N	\N	\N
健在	けんざい	{}	{"in good health; well"}	\N	\N	\N
検索	けんさく	{調べて探しだすこと。特に、文献・カード・ファイル・データベース・インターネットなどの中から必要な情報を探すこと。「―の便を図る」「索引で関係事項を―する」}	{"a search"}	\N	\N	\N
検事	けんじ	{}	{"public prosecutor"}	\N	\N	\N
研修	けんしゅう	{}	{training}	\N	\N	\N
懸賞	けんしょう	{}	{"offering prizes; winning; reward"}	\N	\N	\N
聞き取り	ききとり	{}	{"listening comprehension"}	\N	\N	\N
効き目	ききめ	{}	{"effect; virtue; efficacy; impression"}	\N	\N	\N
気配	けはい	{}	{"indication; market trend; worry"}	\N	\N	\N
見解	けんかい	{物事に対する考え方や価値判断。「―の相違」「―を明らかにする」}	{"opinion; point of view"}	\N	\N	\N
謙譲	けんじょう	{へりくだりゆずること。自分を低めることにより相手を高めること。また、控えめであるさま。謙遜 (けんそん) 。「ーの美徳」}	{"modesty; humility"}	\N	\N	\N
謙譲語	けんじょうご	{敬語の一。話し手が、自分または自分の側にあると判断されるものに関して、へりくだった表現をすることにより、相対的に相手や話中の人に対して敬意を表すもの。特別の語を用いる場合（「わたくし」「うかがう」「いただく」など）、接辞を付加する場合（「てまえども」など）、補助動詞などの敬語的成分を添える場合（「お..する」など）がある。}	{"modest speak"}	\N	\N	\N
建設	けんせつ	{}	{"construction; establishment"}	\N	\N	\N
健全	けんぜん	{}	{"health; soundness; wholesome"}	\N	\N	\N
謙遜	けんそん	{}	{"humble; humility; modesty"}	\N	\N	\N
見地	けんち	{}	{"point of view"}	\N	\N	\N
検知	けんち	{}	{experience}	\N	\N	\N
建築	けんちく	{}	{"construction; architecture"}	\N	\N	\N
県庁	けんちょう	{}	{"prefectural office"}	\N	\N	\N
県庁所在地	けんちょうしょざいち	{}	{"prefecture capital"}	\N	\N	\N
見当	けんとう	{}	{"be found; aim; mark; estimate; guess; approximation; direction;"}	\N	\N	\N
検討	けんとう	{よく調べ考えること。種々の面から調べて、良いか悪いかを考えること。「ーを重ねる」「問題点をーする」}	{"consideration; examination; investigation; study; scrutiny"}	\N	\N	\N
顕微鏡	けんびきょう	{}	{microscope}	\N	\N	\N
見物	けんぶつ	{}	{"sightseeing; see; look at"}	\N	\N	\N
憲法	けんぽう	{"国家の統治権・統治作用に関する根本原則を定める基礎法。他の法律や命令で変更することのできない国の最高法規。近代諸国では多く成文法の形をとる。→日本国憲法 →大日本帝国憲法"}	{constitution}	\N	\N	\N
拳法	けんぽう	{こぶしによる突きや打ち、あるいは足による蹴りを主とした格闘術。中国で古代から発達し、日本には江戸時代初め陳元贇 (ちんげんぴん) らによって伝えられた。「少林寺―」}	{"a Chinese martial art; 〔広い意味で〕kung fu"}	\N	\N	\N
賢明	けんめい	{}	{"wisdom; intelligence; prudence"}	\N	\N	\N
懸命	けんめい	{力のかぎり努めるさま。全力をつくすさま。精一杯。「―な努力」「―にこらえる」「一生―」}	{"hard; eagerness; strenuous"}	\N	\N	\N
倹約	けんやく	{}	{"thrift; economy; frugality"}	\N	\N	\N
兼用	けんよう	{}	{"multi-use; combined use; combination; serving two purposes"}	\N	\N	\N
権利	けんり	{一定の利益を自分のために主張し、また、これを享受することができる法律上の能力。私権と公権とに分かれる。「店のーを譲る」<->義務。->ライツ（rights）}	{"right; privilege"}	\N	\N	\N
権力	けんりょく	{}	{"power; authority; influence"}	\N	\N	\N
木	き	{}	{"tree; wood; timber"}	\N	\N	\N
期	き	{}	{"period; time"}	\N	\N	\N
気	き	{}	{"spirit; mind"}	\N	\N	\N
気圧	きあつ	{}	{"atmospheric pressure"}	\N	\N	\N
黄色い	きいろい	{}	{yellow}	\N	\N	\N
消える	きえる	{}	{"go out; vanish; disappear"}	\N	\N	\N
記憶	きおく	{}	{"memory; recollection; remembrance"}	\N	\N	\N
気温	きおん	{}	{temperature}	\N	\N	\N
飢餓	きが	{}	{hunger}	\N	\N	\N
器械	きかい	{}	{instrument}	\N	\N	\N
機械	きかい	{}	{"machine; mechanism"}	\N	\N	\N
機械学習	きかいがくしゅう	{}	{"machine learning"}	\N	\N	\N
機会	きかい	{事をするのに最も都合のよい時機。ちょうどよい折。チャンス。}	{"a chance; an opportunity"}	\N	\N	\N
危害	きがい	{}	{"injury; harm; danger"}	\N	\N	\N
着替え	きがえ	{}	{"changing clothes; change of clothes"}	\N	\N	\N
規格	きかく	{}	{"standard; norm"}	\N	\N	\N
企画	きかく	{}	{"planning; project"}	\N	\N	\N
着飾る	きかざる	{}	{"to dress up"}	\N	\N	\N
気兼ね	きがね	{}	{"hesitance; diffidence; feeling constraint; fear of troubling someone; having scruples about doing something"}	\N	\N	\N
気が紛れる	きがまぎれる	{}	{"be distracted"}	\N	\N	\N
気軽	きがる	{}	{"cheerful; buoyant; lighthearted"}	\N	\N	\N
器官	きかん	{}	{"organ (of body); instrument"}	\N	\N	\N
季刊	きかん	{}	{"quarterly (e.g. magazine)"}	\N	\N	\N
機関	きかん	{}	{"organ; mechanism; facility; engine"}	\N	\N	\N
期間	きかん	{}	{"period; term"}	\N	\N	\N
機関車	きかんしゃ	{}	{"locomotive; engine"}	\N	\N	\N
危機	きき	{}	{crisis}	\N	\N	\N
生	き	{}	{"pure; undiluted; raw; crude"}	\N	\N	\N
黄色	きいろ	{}	{"the color yellow (noun)"}	\N	\N	\N
帰京	ききょう	{}	{"returning to Tokyo"}	\N	\N	\N
起業家	きぎょうか	{新しく事業をおこして運営する人}	{"entrepreneur (business-starting-guy)"}	\N	\N	\N
基金	ききん	{}	{"fund; foundation"}	\N	\N	\N
飢饉	ききん	{}	{famine}	\N	\N	\N
効く	きく	{}	{"be effective"}	\N	\N	\N
聞く	きく	{音・声を耳に受ける。耳に感じ取る。「物音を―・く」「見るもの―・くものすべてが珍しい」「鳥の声も―・かれない」}	{hear}	\N	\N	\N
聴く	きく	{注意して耳にとめる。耳を傾ける。「名曲を―・く」「有権者の声を―・く」}	{listen}	\N	\N	\N
訊く	きく	{尋ねる。問う。「道を―・く」「自分の胸に―・け」「彼の都合を―・いてみる」}	{"ask; inquire"}	\N	\N	\N
器具	きぐ	{}	{utensil}	\N	\N	\N
喜劇	きげき	{}	{"comedy; funny show"}	\N	\N	\N
棄権	きけん	{}	{"abstain from voting; renunciation of a right"}	\N	\N	\N
危険	きけん	{}	{danger}	\N	\N	\N
起源	きげん	{}	{"origin; beginning; rise"}	\N	\N	\N
機嫌	きげん	{}	{"humour; temper; mood"}	\N	\N	\N
期限	きげん	{}	{"term; period"}	\N	\N	\N
機構	きこう	{}	{"mechanism; organization"}	\N	\N	\N
気候	きこう	{}	{climate}	\N	\N	\N
記号	きごう	{}	{"symbol; code"}	\N	\N	\N
聞こえる	きこえる	{}	{"audible; can hear"}	\N	\N	\N
帰国	きこく	{}	{"return to country / home"}	\N	\N	\N
既婚	きこん	{}	{"marriage; married"}	\N	\N	\N
気障	きざ	{}	{"affectation; conceit; snobbery"}	\N	\N	\N
記載	きさい	{書類・書物などに書いて記すこと。「詳細は説明書に―されている」「―事項」}	{"mention; entry"}	\N	\N	\N
兆し	きざし	{}	{"signs; omen; symptoms"}	\N	\N	\N
貴様	きさま	{男性が、親しい対等の者または目下の者に対して用いる。また、相手をののしる場合にも用いる。おまえ。「―とおれ」「―の顔なんか二度と見たくない」}	{"YOU (bastard)"}	\N	\N	\N
刻む	きざむ	{}	{"mince; chop up; carve; engrave; cut fine; hash; chisel; notch"}	\N	\N	\N
岸	きし	{}	{"bank; shore; coast"}	\N	\N	\N
生地	きじ	{}	{"cloth; material; texture; one´s true character; unglazed pottery"}	\N	\N	\N
記事	きじ	{}	{"article; news story; report; account"}	\N	\N	\N
期日	きじつ	{}	{"fixed date; settlement date"}	\N	\N	\N
汽車	きしゃ	{}	{"train (locomotive)"}	\N	\N	\N
記者	きしゃ	{}	{reporter}	\N	\N	\N
騎手	きしゅ	{}	{ryttare}	\N	\N	\N
機銃	きじゅう	{機の銃}	{"machine gun"}	\N	\N	\N
記述	きじゅつ	{}	{"describing; descriptor"}	\N	\N	\N
希少	きしょう	{}	{"scarcity; rarity"}	\N	\N	\N
起床	きしょう	{}	{"rising; getting out of bed"}	\N	\N	\N
気象	きしょう	{}	{"weather; climate"}	\N	\N	\N
奇数	きすう	{}	{"odd number"}	\N	\N	\N
築く	きずく	{}	{"to build; to pile up; to amass"}	\N	\N	\N
規制	きせい	{従うべききまり。規定。}	{regulation}	\N	\N	\N
寄生	きせい	{生物の寄生。(スル)人に頼って暮らすこと}	{"parasitism; (スル) be parasitic"}	\N	\N	\N
奇跡	きせき	{}	{miracle}	\N	\N	\N
季節	きせつ	{}	{season}	\N	\N	\N
着せる	きせる	{}	{"put on clothes"}	\N	\N	\N
汽船	きせん	{}	{steamship}	\N	\N	\N
気絶	きぜつ	{一時的に意識を失うこと。失神。「ショックのあまりーする」}	{"a faint; loss of consciousness"}	\N	\N	\N
基礎	きそ	{}	{"foundation; basis"}	\N	\N	\N
起訴	きそ	{}	{"objection (裁判所で)"}	\N	\N	\N
寄贈	きそう	{}	{"donation; presentation"}	\N	\N	\N
規則	きそく	{}	{regulations}	\N	\N	\N
規則的	きそくてき	{一定のきまりに従っているさま。規則正しいさま。「―な変化」}	{regular(ly)}	\N	\N	\N
貴族	きぞく	{}	{"noble; aristocrat"}	\N	\N	\N
既存	きぞん	{以前から存在すること。「―の施設を活用する」}	{existing}	\N	\N	\N
北	きた	{}	{north}	\N	\N	\N
期待	きたい	{あることが実現するだろうと望みをかけて待ち受けること。当てにして心待ちにすること。「―に添うよう努力する」「活躍を―している」「―薄」}	{"expectation; anticipation; hope"}	\N	\N	\N
規準	きじゅん	{}	{"standard; basis; criteria; norm"}	\N	{基準}	\N
傷付く	きずつく	{負傷する。けがをする。「―・いた足が痛む」}	{"〔けがをする〕be [get] hurt / wounded / injured"}	\N	{疵付く,傷つく,疵つく}	\N
気体	きたい	{}	{"vapour; gas"}	\N	\N	\N
鍛える	きたえる	{}	{"to forge; to drill; to temper; to train; to discipline"}	\N	\N	\N
帰宅	きたく	{}	{"returning home"}	\N	\N	\N
北口	きたぐち	{}	{"north exit"}	\N	\N	\N
木太刀	きだち	{木で作ったかたな。木刀。木剣。}	{"wooden sword"}	\N	\N	\N
気立て	きだて	{}	{"disposition; nature"}	\N	\N	\N
汚い	きたない	{}	{"dirty; unclean; filthy"}	\N	\N	\N
基地	きち	{}	{base}	\N	\N	\N
貴重	きちょう	{}	{"precious; valuable"}	\N	\N	\N
几帳面	きちょうめん	{}	{"methodical; punctual; steady"}	\N	\N	\N
喫煙	きつえん	{}	{smoking}	\N	\N	\N
切っ掛け	きっかけ	{物事を始めるための手がかりや機会。また，物事が始まる原因や動機。「話のーをさがす」「ひょんなーで友人となる」}	{"〔初め〕a start; 〔機会〕a chance; an opportunity; 〔手掛かり〕a clue; a lead"}	\N	\N	\N
狐	きつね	{}	{fox}	\N	\N	\N
喫茶	きっさ	{}	{"tea drinking; tea house"}	\N	\N	\N
喫茶店	きっさてん	{}	{"coffee shop"}	\N	\N	\N
切手	きって	{}	{stamp}	\N	\N	\N
屹度	きっと	{}	{"(uk) surely; undoubtedly; certainly; without fail; sternly; severely"}	\N	\N	\N
切符	きっぷ	{}	{ticket}	\N	\N	\N
規定	きてい	{}	{"regulation; provisions"}	\N	\N	\N
起点	きてん	{}	{"starting point"}	\N	\N	\N
軌道	きどう	{}	{"orbit; railroad track"}	\N	\N	\N
気に入る	きにいる	{}	{"be pleased with; to suit"}	\N	\N	\N
気にする	きにする	{心にとめて不安に思う。心配する。「人がなんと言おうと―◦するな」}	{"mind; care; worry (about)"}	\N	\N	\N
記入	きにゅう	{}	{"entry; filling in of forms"}	\N	\N	\N
絹	きぬ	{}	{silk}	\N	\N	\N
記念	きねん	{}	{"commemoration; memory"}	\N	\N	\N
祈念	きねん	{神仏に、願いがかなうように祈ること。「世界の平和を―する」}	{"a prayer"}	\N	\N	\N
昨日	きのう	{}	{yesterday}	\N	\N	\N
機能	きのう	{}	{"function; faculty"}	\N	\N	\N
甲	きのえ	{}	{"1st in rank; first sign of the Chinese calendar; shell; instep; grade A"}	\N	\N	\N
気の毒	きのどく	{}	{"pitiful; a pity"}	\N	\N	\N
気迫	きはく	{力強く立ち向かってゆく精神力。「―がこもる」「―に満ちた演技」}	{"〔気概〕spirit; 〔決意〕determination; 〔積極性〕drive"}	\N	\N	\N
木肌	きはだ	{}	{bark}	\N	\N	\N
規範	きはん	{}	{"model; standard; pattern; norm; criterion; example"}	\N	\N	\N
基盤	きばん	{}	{"foundation; basis"}	\N	\N	\N
厳しい	きびしい	{}	{strict}	\N	\N	\N
気品	きひん	{}	{aroma}	\N	\N	\N
寄付	きふ	{公共事業や社寺などに、金品を贈ること。「―を募る」「被災者に衣類を―する」「―金」}	{"contribution; donation"}	\N	\N	\N
気風	きふう	{}	{"character; traits; ethos"}	\N	\N	\N
起伏	きふく	{}	{undulation}	\N	\N	\N
気分	きぶん	{}	{mood}	\N	\N	\N
規模	きぼ	{}	{"scale; scope; plan; structure"}	\N	\N	\N
希望	きぼう	{あることの実現をのぞみ願うこと。また、その願い。「みんなの―を入れる」「入社を―する」}	{"hope; wish; aspiration"}	\N	\N	\N
基本	きほん	{}	{"foundation; basis; standard"}	\N	\N	\N
気まぐれ	きまぐれ	{}	{"whim; caprice; whimsy; fickle; moody; uneven temper"}	\N	\N	\N
生真面目	きまじめ	{}	{"too serious; person who is too serious; honesty; sincerity"}	\N	\N	\N
期末	きまつ	{}	{"end of term"}	\N	\N	\N
決まり	きまり	{}	{"settlement; conclusion; regulation; rule; custom"}	\N	\N	\N
決まり悪い	きまりわるい	{}	{"feeling awkward; being ashamed"}	\N	\N	\N
気味	きみ	{}	{"sensation; feeling"}	\N	\N	\N
奇妙	きみょう	{}	{"strange; queer; curious"}	\N	\N	\N
記名	きめい	{}	{"signature; register"}	\N	\N	\N
気持ち	きもち	{}	{feelings}	\N	\N	\N
着物	きもの	{}	{"Japanese traditional dress"}	\N	\N	\N
規約	きやく	{団体内で協議して決めた規則。「組合ー」「連盟ー」}	{"an agreement; the articles (of an association); the bylaws (of a corporation); rules"}	\N	\N	\N
決める	きめる	{}	{"decide; determine"}	\N	{極める}	\N
客様	きゃくさま	{}	{"mr guest"}	\N	\N	\N
脚色	きゃくしょく	{}	{"dramatization (e.g. film)"}	\N	\N	\N
客席	きゃくせき	{}	{"guest seating"}	\N	\N	\N
脚本	きゃくほん	{}	{scenario}	\N	\N	\N
客間	きゃくま	{}	{"parlor; guest room"}	\N	\N	\N
客観	きゃっかん	{}	{objective}	\N	\N	\N
旧	きゅう	{}	{ex-}	\N	\N	\N
急	きゅう	{}	{urgent}	\N	\N	\N
級	きゅう	{}	{"class; grade; rank"}	\N	\N	\N
救援	きゅうえん	{}	{"relief; rescue; reinforcement"}	\N	\N	\N
休暇	きゅうか	{}	{"holiday; day off; furlough"}	\N	\N	\N
休学	きゅうがく	{}	{"temporary absence from school; suspension"}	\N	\N	\N
休業	きゅうぎょう	{}	{"closed (e.g. store); business suspended; shutdown; holiday"}	\N	\N	\N
究極	きゅうきょく	{}	{"ultimate; final; eventual"}	\N	\N	\N
窮屈	きゅうくつ	{}	{"narrow; tight; stiff; rigid; uneasy; formal; constrained"}	\N	\N	\N
休憩	きゅうけい	{}	{"rest; break; recess; intermission"}	\N	\N	\N
急激	きゅうげき	{}	{"sudden; precipitous; radical"}	\N	\N	\N
急行	きゅうこう	{}	{"express train"}	\N	\N	\N
休講	きゅうこう	{}	{"lecture cancelled"}	\N	\N	\N
球根	きゅうこん	{}	{"(plant) bulb"}	\N	\N	\N
救済	きゅうさい	{}	{"relief; aid; rescue; salvation; help"}	\N	\N	\N
給仕	きゅうじ	{}	{"office boy (girl); page; waiter"}	\N	\N	\N
吸収	きゅうしゅう	{}	{"absorption; suction; attraction"}	\N	\N	\N
救出	きゅうしゅつ	{危険な状態から救い出すこと。}	{rescue}	\N	\N	\N
救助	きゅうじょ	{}	{"relief; aid; rescue"}	\N	\N	\N
給食	きゅうしょく	{}	{"school lunch; providing a meal"}	\N	\N	\N
急須	きゅうす	{}	{"teapot (漢字：hurry + ought)"}	\N	\N	\N
休戦	きゅうせん	{}	{"truce; armistice"}	\N	\N	\N
休息	きゅうそく	{}	{"rest; relief; relaxation"}	\N	\N	\N
急速	きゅうそく	{}	{"rapid (e.g. progress)"}	\N	\N	\N
旧知	きゅうち	{}	{"old friend; old friendship"}	\N	\N	\N
窮地	きゅうち	{追い詰められて逃げ場のない苦しい状態や立ち場。「ーに陥る」}	{"a difficult situation; a predicament; 「ーに陥った」caught in a dilemma."}	\N	\N	\N
宮殿	きゅうでん	{}	{palace}	\N	\N	\N
急に	きゅうに	{}	{suddenly}	\N	\N	\N
窮乏	きゅうぼう	{}	{poverty}	\N	\N	\N
救命いかだ	きゅうめいいかだ	{}	{"life raft"}	\N	\N	\N
旧友	きゅうゆう	{}	{"old friend"}	\N	\N	\N
給与	きゅうよ	{}	{"allowance; grant; supply"}	\N	\N	\N
休養	きゅうよう	{}	{"rest; break; recreation"}	\N	\N	\N
給料	きゅうりょう	{}	{"salary; wages"}	\N	\N	\N
丘陵	きゅうりょう	{}	{hill}	\N	\N	\N
寄与	きよ	{}	{"contribution; service"}	\N	\N	\N
清い	きよい	{}	{"clear; pure; noble"}	\N	\N	\N
共	きょう	{}	{"both; neither (neg); all; and; as well as; including; with; together with; plural ending"}	\N	\N	\N
供	きょう	{}	{"offer; present; submit; serve (a meal); supply"}	\N	\N	\N
器用	きよう	{}	{"skillful; handy"}	\N	\N	\N
凶悪	きょうあく	{}	{"Heinous; vidrig; avskyvärd"}	\N	\N	\N
驚異	きょうい	{}	{"wonder; miracle"}	\N	\N	\N
教育	きょういく	{訓練；教えること}	{education}	\N	\N	\N
教員	きょういん	{}	{"teaching staff"}	\N	\N	\N
強化	きょうか	{}	{"strengthen; intensify; reinforce; solidify"}	\N	\N	\N
教科	きょうか	{}	{"subject; curriculum"}	\N	\N	\N
境界	きょうかい	{}	{boundary}	\N	\N	\N
協会	きょうかい	{}	{"association; society; organization"}	\N	\N	\N
教会	きょうかい	{}	{church}	\N	\N	\N
共学	きょうがく	{}	{coeducation}	\N	\N	\N
教科書	きょうかしょ	{}	{"text book"}	\N	\N	\N
恐喝	きょうかつ	{相手の弱みなどにつけこみおどすこと。また、おどして金品をゆすりとること。「収賄をねたにーする」}	{"〔脅し〕a threat; a menace; intimidation; 〔ゆすり〕blackmail; extortion"}	\N	\N	\N
共感	きょうかん	{}	{"sympathy; response"}	\N	\N	\N
九	きゅう	{}	{nine}	\N	\N	\N
凶器	きょうき	{人を殺傷するために用いられる道具}	{"a (lethal) weapon"}	\N	\N	\N
虚偽	きょぎ	{真実ではないのに、真実のように見せかけること。うそ。いつわり。「ーの申し立て」}	{"falsehood; untruth; fictionhood"}	\N	\N	\N
競技	きょうぎ	{}	{"game; match; contest"}	\N	\N	\N
協議	きょうぎ	{}	{"conference; consultation; discussion; negotiation"}	\N	\N	\N
供給	きょうきゅう	{}	{"supply; provisions"}	\N	\N	\N
境遇	きょうぐう	{}	{"environment; circumstances"}	\N	\N	\N
教訓	きょうくん	{}	{"lesson; precept; moral instruction"}	\N	\N	\N
狂言	きょうげん	{}	{"〔能狂言〕a farce presented between Noh plays〔芝居の出し物〕a play〔偽り〕a sham"}	\N	\N	\N
強硬	きょうこう	{}	{"firm; vigorous; unbending; unyielding; strong; stubborn; hard-line"}	\N	\N	\N
強行	きょうこう	{}	{"forcing; enforcement"}	\N	\N	\N
胸骨	きょうこつ	{}	{sternum}	\N	\N	\N
教材	きょうざい	{}	{"teaching materials"}	\N	\N	\N
凶作	きょうさく	{}	{"bad harvest; poor crop"}	\N	\N	\N
共産	きょうさん	{}	{communism}	\N	\N	\N
教師	きょうし	{}	{"classroom teacher"}	\N	\N	\N
教旨	きょうし	{}	{"dogma; doctrine"}	\N	\N	\N
教室	きょうしつ	{}	{classroom}	\N	\N	\N
享受	きょうじゅ	{}	{"reception; acceptance; enjoyment; being given"}	\N	\N	\N
教授	きょうじゅ	{}	{"teaching; instruction; professor"}	\N	\N	\N
教習	きょうしゅう	{}	{"training; instruction"}	\N	\N	\N
郷愁	きょうしゅう	{}	{"nostalgia; homesickness"}	\N	\N	\N
恐縮	きょうしゅく	{}	{"shame; very kind of you; sorry to trouble"}	\N	\N	\N
教職	きょうしょく	{}	{"teaching certificate; the teaching profession"}	\N	\N	\N
興じる	きょうじる	{}	{"to amuse oneself; to make merry"}	\N	\N	\N
強靭	きょうじん	{しなやかで強いこと。柔軟でねばり強いこと。また、そのさま。「―な肉体」「―な意志」}	{"〜な tough; strong"}	\N	\N	\N
強制	きょうせい	{}	{"obligation; coercion; compulsion; enforcement"}	\N	\N	\N
矯正	きょうせい	{}	{"〔行いなどを改めさせること〕reform; 〔誤りを正すこと〕correction"}	\N	\N	\N
競争	きょうそう	{}	{compete}	\N	\N	\N
共存	きょうそん	{}	{coexistence}	\N	\N	\N
兄弟	きょうだい	{}	{siblings}	\N	\N	\N
強大	きょうだい	{強くて大きいこと。また、そのさま。「―な勢力を誇る」⇔弱小。}	{"〜な mighty"}	\N	\N	\N
協調	きょうちょう	{}	{"co-operation; conciliation; harmony; firm (market) tone"}	\N	\N	\N
強調	きょうちょう	{}	{"emphasis; stress; stressed point"}	\N	\N	\N
共通	きょうつう	{}	{"commonness; community"}	\N	\N	\N
協定	きょうてい	{}	{"arrangement; pact; agreement"}	\N	\N	\N
共同	きょうどう	{}	{"cooperation; association; collaboration; joint"}	\N	\N	\N
脅迫	きょうはく	{}	{"threat; menace; coercion; terrorism"}	\N	\N	\N
恐怖	きょうふ	{}	{"be afraid; dread; dismay; terror"}	\N	\N	\N
共鳴	きょうめい	{}	{"resonance; sympathy"}	\N	\N	\N
教諭	きょうゆ	{先生。教師。}	{"a teacher"}	\N	\N	\N
教養	きょうよう	{}	{"culture; education; refinement; cultivation"}	\N	\N	\N
強要	きょうよう	{無理に要求すること。無理やりさせようとすること。}	{"extortion; coercion; strong persuation"}	\N	\N	\N
郷里	きょうり	{}	{"birth-place; home town"}	\N	\N	\N
強力	きょうりょく	{}	{"powerful; strong"}	\N	\N	\N
協力	きょうりょく	{}	{"cooperation; collaboration"}	\N	\N	\N
強烈	きょうれつ	{力・作用・刺激が強く激しいこと。また、そのさま。「―なパンチ」「―な個性」「―なにおい」}	{"strong; intense; severe"}	\N	\N	\N
共和	きょうわ	{}	{"republicanism; cooperation"}	\N	\N	\N
許可	きょか	{}	{"permission; approval"}	\N	\N	\N
局	きょく	{}	{"channel (i.e. TV or radio); department; affair; situation"}	\N	\N	\N
曲	きょく	{}	{"tune; piece of music"}	\N	\N	\N
局限	きょくげん	{}	{"limit; localize"}	\N	\N	\N
曲線	きょくせん	{}	{curve}	\N	\N	\N
極端	きょくたん	{}	{"extreme; extremity"}	\N	\N	\N
局長	きょくちょう	{局と名のつく組織の最高責任者。}	{"the chief of a bureau; a bureau chief"}	\N	\N	\N
居住	きょじゅう	{}	{residence}	\N	\N	\N
拒絶	きょぜつ	{}	{"refusal; rejection"}	\N	\N	\N
巨大	きょだい	{}	{"huge; gigantic; enormous"}	\N	\N	\N
近代	きんだい	{}	{"present day"}	\N	\N	\N
拠点	きょてん	{活動の足場となる重要な地点・~基地拠点「販売の―を築く」「軍事―」}	{"base; foothold"}	\N	\N	\N
去年	きょねん	{}	{"last year"}	\N	\N	\N
拒否	きょひ	{}	{"denial; veto; rejection; refusal"}	\N	\N	\N
許容	きょよう	{}	{"permission; pardon"}	\N	\N	\N
清らか	きよらか	{}	{"clean; pure; chaste"}	\N	\N	\N
距離	きょり	{}	{"distance; range"}	\N	\N	\N
嫌い	きらい	{}	{"dislike; hate"}	\N	\N	\N
嫌う	きらう	{}	{"hate; dislike; loathe"}	\N	\N	\N
気楽	きらく	{}	{"at ease; comfortable"}	\N	\N	\N
切り	きり	{}	{"limits; end; bounds; period; place to leave off; closing sentence; all there is; only; since"}	\N	\N	\N
霧	きり	{}	{"fog; mist"}	\N	\N	\N
切り替える	きりかえる	{}	{"to change; to exchange; to convert; to renew; to throw a switch; to replace; to switch over"}	\N	\N	\N
規律	きりつ	{}	{"order; rules; law"}	\N	\N	\N
気流	きりゅう	{}	{"atmospheric current"}	\N	\N	\N
斬る	きる	{}	{"murder; behead"}	\N	\N	\N
切れ	きれ	{}	{"cloth; piece; cut; chop; strip; slice; scrap"}	\N	\N	\N
亀裂	きれつ	{}	{"cracking (e.g. the road; ground; earth)"}	\N	\N	\N
切れ目	きれめ	{}	{"break; pause; gap; end; rift; interruption; cut; section; notch; incision; end (of a task)"}	\N	\N	\N
切れる	きれる	{}	{"be sharp (blade); break (off); snap; wear out; burst; collapse; be injured; be disconnected; be out of; expire; be shrewd; have a sharp mind"}	\N	\N	\N
記録	きろく	{}	{"record; minutes; document"}	\N	\N	\N
極み	きわみ	{きわまるところ。物事の行きつくところ。極限。限り。「天地のー」「無礼のー」}	{"pinnacle; height; extremety"}	\N	\N	\N
極めて	きわめて	{}	{"exceedingly; extremely"}	\N	\N	\N
窮める	きわめる	{極点に達した状態になる。この上もない程度までそうなる。「ぜいたくを―・める」「困難を―・める」}	{"〔高い所に行き着く〕reach (e.g. a summit)〔この上もなく…である〕extreme; no higher"}	\N	\N	\N
究める	きわめる	{深く研究して、すっかり明らかにする。「真理を―・める」「道を―・める」}	{"arrived at the end (of a road/research)"}	\N	\N	\N
気を付ける	きをつける	{}	{"be careful; pay attention"}	\N	\N	\N
僅	きん	{}	{"a little; small quantity"}	\N	\N	\N
斤	きん	{}	{"catty (chinese unit)"}	\N	\N	\N
禁煙	きんえん	{}	{"No Smoking!"}	\N	\N	\N
金額	きんがく	{}	{"amount of money"}	\N	\N	\N
近眼	きんがん	{}	{"nearsightedness; shortsightedness; myopia"}	\N	\N	\N
緊急	きんきゅう	{}	{"urgent; pressing; emergency"}	\N	\N	\N
金魚	きんぎょ	{}	{goldfish}	\N	\N	\N
均衡	きんこう	{}	{"equilibrium; balance"}	\N	\N	\N
近郊	きんこう	{}	{"suburbs; outskirts"}	\N	\N	\N
禁止	きんし	{ある行為を行わないように命令すること。「通行を―する」「外出―」}	{"prohibition; ban"}	\N	\N	\N
近視	きんし	{}	{shortsightedness}	\N	\N	\N
近所	きんじょ	{}	{"neighbor hood"}	\N	\N	\N
禁じる	きんじる	{}	{"to prohibit"}	\N	\N	\N
謹慎	きんしん	{}	{"penitence; discipline; house arrest"}	\N	\N	\N
謹慎処分	きんしんしょぶん	{discipline罰}	{"disciplinary punishment"}	\N	\N	\N
禁ずる	きんずる	{}	{"to forbid; to suppress"}	\N	\N	\N
禁制	きんせい	{ある行為を禁じること。また、その法規。「男子―」}	{"〜の forbidden; prohibited"}	\N	\N	\N
金銭	きんせん	{}	{"money; cash"}	\N	\N	\N
金属	きんぞく	{}	{metal}	\N	\N	\N
綺麗	きれい	{色・形などが華やかな美しさをもっているさま。「ーな花」「ーに着飾る」}	{"pretty; clean; nice; tidy; beautiful; fair"}	\N	{奇麗}	\N
極める	きわめる	{極点に達した状態になる。この上もない程度までそうなる。「ぜいたくを―・める」「困難を―・める」,これより先はないというところまで行き着く。「富士山頂を―・める」「頂点を―・める」}	{"〔この上もなく…である〕extreme; no higher","〔高い所に行き着く〕reach (e.g. a summit)"}	\N	{窮める,究める}	\N
切る	きる	{つながっているものを断ったり、付いているものを離したりする。特に、刃物などでものを分け離す。「枝を―・る」「爪 (つめ) を―・る」「二センチ角に―・る」,際立った、または、思いきった行為・動作をする。威勢のいい、または、わざと目立つような口ぶり・態度をする。「たんかを―・る」「札びらを―・る」}	{"cut; chop; hash; carve; saw; clip; shear; slice; strip; cut down; punch; sever (connections); pause; break off; disconnect; turn off; hang up; cross (a street); finish; be through; complete","〔思い切って手放す〕spend freely; spend lavishly"}	\N	\N	\N
金玉	きんだま	{男性の精子をつくる器官。精巣 (せいそう) のこと。}	{"the testicles; the testes"}	\N	\N	\N
緊張	きんちょう	{}	{"tension; mental strain; nervousness"}	\N	\N	\N
筋肉	きんにく	{}	{"muscle; sinew"}	\N	\N	\N
金髪	きんぱつ	{}	{"blond; golden hair"}	\N	\N	\N
勤勉	きんべん	{}	{"industry; diligence"}	\N	\N	\N
勤務	きんむ	{}	{"service; duty; work"}	\N	\N	\N
禁物	きんもつ	{}	{"taboo; forbidden thing"}	\N	\N	\N
金融	きんゆう	{金銭の融通。特に、資金の借り手と貸し手のあいだで行われる貨幣の信用取引。}	{"monetary circulation; credit situation〔資金の貸し借り〕finance; financing"}	\N	\N	\N
金曜	きんよう	{}	{Friday}	\N	\N	\N
金曜日	きんようび	{}	{Friday}	\N	\N	\N
勤労	きんろう	{}	{"labor; exertion; diligent service"}	\N	\N	\N
児	こ	{}	{"child; the young of animals"}	\N	\N	\N
故	こ	{}	{"the late (deceased)"}	\N	\N	\N
巨	こ	{}	{"big; large; great"}	\N	\N	\N
弧	こ	{弓なりに湾曲した線。}	{arc}	\N	\N	\N
恋	こい	{}	{"love; tender passion"}	\N	\N	\N
濃い	こい	{}	{"thick (as of color; liquid); dense; strong"}	\N	\N	\N
故意	こい	{わざとすること。また、その気持ち。「ーに取り違える」}	{intention}	\N	\N	\N
恋しい	こいしい	{}	{"dear; beloved; darling;yearned for"}	\N	\N	\N
恋する	こいする	{}	{"to fall in love with; to love"}	\N	\N	\N
恋人	こいびと	{}	{"lover; sweetheart"}	\N	\N	\N
校	こう	{}	{"-school; proof"}	\N	\N	\N
溝	こう	{}	{"10^38; hundred undecillion (American); hundred sextillion (British)"}	\N	\N	\N
好意	こうい	{}	{"good will; favor; courtesy"}	\N	\N	\N
行為	こうい	{}	{"act; deed; conduct"}	\N	\N	\N
行員	こういん	{}	{"bank clerk"}	\N	\N	\N
工員	こういん	{}	{"factory worker"}	\N	\N	\N
幸運	こううん	{}	{"good luck; fortune"}	\N	\N	\N
光栄	こうえい	{業績や行動を褒められたり、重要な役目を任されたりして、名誉に思うこと。栄えること。「ーの至り」「身に過ぎてーなこと」}	{"honor; privilage; glory"}	\N	\N	\N
交易	こうえき	{}	{"trade; commerce"}	\N	\N	\N
公園	こうえん	{}	{"(public) park"}	\N	\N	\N
公演	こうえん	{}	{"public performance"}	\N	\N	\N
講演	こうえん	{}	{"lecture; address"}	\N	\N	\N
高価	こうか	{}	{"high price"}	\N	\N	\N
硬貨	こうか	{}	{coin}	\N	\N	\N
硬化	こうか	{}	{curing}	\N	\N	\N
効果	こうか	{}	{"effect; effectiveness; efficacy; result"}	\N	\N	\N
航海	こうかい	{}	{"sail; voyage"}	\N	\N	\N
子	こ	{}	{child}	{動物}	\N	\N
椎茸	しいたけ	{}	{"Shiitake; Lentinula edodes"}	{菌類}	\N	\N
請う	こう	{他人に、物を与えてくれるよう求める。訊く}	{"ask; inquire"}	\N	{乞う}	\N
後悔	こうかい	{}	{"regret; repentance"}	\N	\N	\N
公開	こうかい	{}	{"presenting to the public"}	\N	\N	\N
郊外	こうがい	{}	{suburbs}	\N	\N	\N
公害	こうがい	{}	{"public nuisance; pollution"}	\N	\N	\N
工学	こうがく	{}	{engineering}	\N	\N	\N
工学部	こうがくぶ	{}	{"department of engineering"}	\N	\N	\N
交換	こうかん	{}	{"exchange; interchange; reciprocity; barter; substitution"}	\N	\N	\N
講義	こうぎ	{}	{lecture}	\N	\N	\N
抗議	こうぎ	{}	{"protest; objection"}	\N	\N	\N
高級	こうきゅう	{}	{"high class; high grade"}	\N	\N	\N
皇居	こうきょ	{}	{"Imperial Palace"}	\N	\N	\N
好況	こうきょう	{}	{"prosperous conditions; healthy economy"}	\N	\N	\N
公共	こうきょう	{社会一般。おおやけ。また、社会全体あるいは国や公共団体がそれにかかわること。「―の建物」}	{"public; community; public service; society; communal"}	\N	\N	\N
工業	こうぎょう	{}	{industry}	\N	\N	\N
鉱業	こうぎょう	{}	{"mining industry"}	\N	\N	\N
興業	こうぎょう	{}	{"industrial enterprise"}	\N	\N	\N
高血圧	こうけつあつ	{血圧が持続的に異常に高くなっている状態。一般に、最大血圧140ミリメートル水銀柱、最小血圧90ミリメートル水銀柱以上をいう。高血圧症。血圧亢進症。→低血圧}	{"high blood pressure; hypertension"}	\N	\N	\N
公共交通	こうきょうこうつう	{一般の人々が共同で使用する交通機関。鉄道・バス・航空路・フェリーなど。}	{"public transport"}	\N	\N	\N
航空	こうくう	{}	{"aviation; flying"}	\N	\N	\N
航空券	こうくうけん	{}	{"flight ticket"}	\N	\N	\N
皇宮	こうぐう	{}	{"imperial palace"}	\N	\N	\N
航空機	こうくうき	{人が乗って空中を航行する機器の総称。飛行船・気球・グライダー・飛行機・ヘリコプターなど。現在では主に飛行機をさす。}	{"a plane，((米)) an airplane，((英)) an aeroplane; 〔総称〕aircraft"}	\N	\N	\N
光景	こうけい	{}	{"scene; spectacle"}	\N	\N	\N
工芸	こうげい	{}	{"industrial arts"}	\N	\N	\N
後継者	こうけいしゃ	{}	{successor}	\N	\N	\N
攻撃	こうげき	{}	{"attack; strike; offensive; criticism; censure"}	\N	\N	\N
貢献	こうけん	{ある物事や社会のために役立つように尽力すること。貢ぎ物を奉ること。また、その品物。「学界の発展にーする」「ー度」}	{"contribution; services"}	\N	\N	\N
高原	こうげん	{}	{"tableland; plateau"}	\N	\N	\N
交互	こうご	{}	{"mutual; reciprocal; alternate"}	\N	\N	\N
高校	こうこう	{}	{"high school"}	\N	\N	\N
孝行	こうこう	{}	{"filial piety"}	\N	\N	\N
皇后	こうごう	{}	{"empress; queen"}	\N	\N	\N
高校生	こうこうせい	{}	{"high school student"}	\N	\N	\N
考古学	こうこがく	{}	{archaeology}	\N	\N	\N
広告	こうこく	{}	{advertisement}	\N	\N	\N
広告欄	こうこくらん	{}	{"an advertising column [section]; 〔新聞の三行広告欄〕the classified ads"}	\N	\N	\N
交差	こうさ	{}	{cross}	\N	\N	\N
交際	こうさい	{}	{"company; friendship; association; society; acquaintance"}	\N	\N	\N
工作	こうさく	{}	{"work; construction; handicraft; maneuvering"}	\N	\N	\N
耕作	こうさく	{}	{"cultivation; farming"}	\N	\N	\N
交錯	こうさく	{いくつかのものが入りまじること。「夢と現実がーする」}	{"mix; intertwine"}	\N	\N	\N
交差点	こうさてん	{}	{"crossing; intersection"}	\N	\N	\N
鉱山	こうざん	{}	{"mine (ore)"}	\N	\N	\N
講師	こうし	{}	{lecturer}	\N	\N	\N
皇嗣	こうし	{天子（皇帝や天皇）の跡継ぎのことである。}	{"emperor's oldest son? tronarvinge?"}	\N	\N	\N
工事	こうじ	{}	{"construction work"}	\N	\N	\N
公式	こうしき	{}	{"formula; formality; official"}	\N	\N	\N
口実	こうじつ	{}	{excuse}	\N	\N	\N
校舎	こうしゃ	{}	{"school building"}	\N	\N	\N
後者	こうしゃ	{}	{"the latter"}	\N	\N	\N
侯爵	こうしゃく	{もと五等爵の第二位。伯爵の上。公爵の下。爵}	{marquis}	\N	\N	\N
講習	こうしゅう	{}	{"short course; training"}	\N	\N	\N
公衆	こうしゅう	{}	{"the public"}	\N	\N	\N
口述	こうじゅつ	{}	{"verbal statement"}	\N	\N	\N
控除	こうじょ	{}	{"subsidy; deduction"}	\N	\N	\N
高尚	こうしょう	{}	{"high; noble; refined; advanced"}	\N	\N	\N
交渉	こうしょう	{}	{"negotiations; discussions; connection"}	\N	\N	\N
向上	こうじょう	{}	{"elevation; rise; improvement; advancement; progress"}	\N	\N	\N
講じる	こうじる	{手段を取る。「講ずる」の上一段化。}	{"take (an action; the right step); try (a possibiliy)"}	\N	\N	\N
行進	こうしん	{}	{"march; parade"}	\N	\N	\N
更新	こうしん	{}	{update}	\N	\N	\N
香辛料	こうしんりょう	{}	{spices}	\N	\N	\N
降水	こうすい	{}	{"rainfall; precipitation"}	\N	\N	\N
香水	こうすい	{}	{perfume}	\N	\N	\N
洪水	こうずい	{}	{flood}	\N	\N	\N
構成	こうせい	{文芸・音楽・造形芸術などで、表現上の諸要素を独自の手法で組み立てて作品にすること。「番組を―する」}	{"organization; composition"}	\N	\N	\N
公正	こうせい	{}	{"justice; fairness; impartiality"}	\N	\N	\N
功績	こうせき	{}	{"achievements; merit; meritorious service; meritorious deed"}	\N	\N	\N
光線	こうせん	{}	{"beam; light ray"}	\N	\N	\N
公然	こうぜん	{}	{"open (e.g. secret); public; official"}	\N	\N	\N
酵素	こうそ	{}	{enzyme}	\N	\N	\N
高層	こうそう	{}	{upper}	\N	\N	\N
構想	こうそう	{}	{"plan; plot; idea; conception"}	\N	\N	\N
抗争	こうそう	{}	{"dispute; resistance"}	\N	\N	\N
構造	こうぞう	{}	{"structure; construction"}	\N	\N	\N
高速	こうそく	{}	{"high speed; high gear"}	\N	\N	\N
拘束	こうそく	{思想・行動などの自由を制限すること。「時間に―される」}	{"restriction; restraint〔監禁〕confinement〔拘留〕custody"}	\N	\N	\N
後退	こうたい	{}	{"retreat; backspace (BS)"}	\N	\N	\N
光沢	こうたく	{}	{"brilliance; polish; lustre; glossy finish (of photographs)"}	\N	\N	\N
公団	こうだん	{}	{"public corporation"}	\N	\N	\N
耕地	こうち	{}	{"arable land"}	\N	\N	\N
巧遅	こうち	{出来ばえはすぐれているが、仕上がりまでの時間がかかること。⇔拙速。}	{"slow craft"}	\N	\N	\N
好調	こうちょう	{}	{"favourable; promising; satisfactory; in good shape"}	\N	\N	\N
校長	こうちょう	{}	{principal}	\N	\N	\N
交通	こうつう	{人・乗り物などが行き来すること。通行。「―のさまたげになる」「―止め」}	{traffic}	\N	\N	\N
交通機関	こうつうきかん	{}	{"transportation facilities"}	\N	\N	\N
交通規制	こうつうきせい	{}	{"regulation of traffic"}	\N	\N	\N
校庭	こうてい	{}	{campus}	\N	\N	\N
高弟	こうてい	{}	{"best pupil"}	\N	\N	\N
皇帝	こうてい	{おもに中国で、天子または国王の尊称。秦の始皇帝が初めて称した。}	{"an emperor; sovereign"}	\N	\N	\N
光点	こうてん	{テレビやレーダーなどの受信画像をブラウン管面に表示する場合、画素に相当する走査線ビーム。輝点。}	{"a luminous point; 〔天体〕a radiant"}	\N	\N	\N
更迭	こうてつ	{}	{"recall; change; shake-up"}	\N	\N	\N
高度	こうど	{}	{"altitude; height; advanced"}	\N	\N	\N
口頭	こうとう	{}	{oral}	\N	\N	\N
高等	こうとう	{}	{"high class; high grade"}	\N	\N	\N
講堂	こうどう	{}	{"lecture hall"}	\N	\N	\N
行動	こうどう	{}	{"action; conduct; behaviour; mobilization"}	\N	\N	\N
高等学校	こうとうがっこう	{}	{"senior high school"}	\N	\N	\N
購読	こうどく	{}	{"subscription (e.g. magazine)"}	\N	\N	\N
講読	こうどく	{}	{"reading; translation"}	\N	\N	\N
坑内	こうない	{}	{"underground; within a pit/shaft"}	\N	\N	\N
購入	こうにゅう	{}	{"purchase; buy"}	\N	\N	\N
公認	こうにん	{}	{"official recognition; authorization; licence; accreditation"}	\N	\N	\N
光熱費	こうねつひ	{}	{"cost of fuel and light"}	\N	\N	\N
荒廃	こうはい	{}	{ruin}	\N	\N	\N
後輩	こうはい	{}	{"junior (at work or school)"}	\N	\N	\N
購買	こうばい	{}	{"purchase; buy"}	\N	\N	\N
交番	こうばん	{}	{"police box"}	\N	\N	\N
好評	こうひょう	{}	{"popularity; favorable reputation"}	\N	\N	\N
公表	こうひょう	{}	{"official announcement; proclamation"}	\N	\N	\N
交付	こうふ	{}	{"delivering; furnishing (with copies)"}	\N	\N	\N
降伏	こうふく	{}	{"capitulation; surrender; submission"}	\N	\N	\N
幸福	こうふく	{}	{"happiness; blessedness"}	\N	\N	\N
鉱物	こうぶつ	{}	{mineral}	\N	\N	\N
興奮	こうふん	{}	{"excitement; stimulation; agitation; arousal"}	\N	\N	\N
公平	こうへい	{}	{"fairness; impartial; justice"}	\N	\N	\N
候補	こうほ	{}	{candidacy}	\N	\N	\N
凝らす	こごらす	{}	{"to freeze; to congeal"}	\N	\N	\N
交替	こうたい	{}	{"alternation; change; shift; relief; relay"}	\N	{交代}	\N
航法	こうほう	{船舶または航空機が、所定の二地点間を、所定の時間内に正確かつ安全に航行するための技術・方法。地文 (ちもん) 航法・天文航法・電波航法などがある。}	{navigation}	\N	\N	\N
公募	こうぼ	{}	{"public appeal; public contribution"}	\N	\N	\N
巧妙	こうみょう	{}	{"ingenious; skillful; clever; deft"}	\N	\N	\N
公務	こうむ	{}	{"official business; public business"}	\N	\N	\N
公務員	こうむいん	{}	{"public servant"}	\N	\N	\N
項目	こうもく	{物事を、ある基準で区分けしたときの一つ一つ。「資料を―別に整理する」}	{"item; 〔題目〕a head(ing); 〔表や計算書などの細目〕an item; 〔条項〕a clause; a provision (in a will)"}	\N	\N	\N
公用	こうよう	{}	{"government business; public use; public expense"}	\N	\N	\N
甲羅	こうら	{}	{shell}	\N	\N	\N
小売	こうり	{}	{retail}	\N	\N	\N
公立	こうりつ	{}	{"public (institution)"}	\N	\N	\N
効率	こうりつ	{}	{efficiency}	\N	\N	\N
攻略	こうりゃく	{}	{capture}	\N	\N	\N
交流	こうりゅう	{}	{"alternating current; intercourse; (cultural) exchange; intermingling"}	\N	\N	\N
考慮	こうりょ	{}	{"consideration; taking into account"}	\N	\N	\N
香料	こうりょう	{}	{spice}	\N	\N	\N
効力	こうりょく	{}	{"effect; efficacy; validity; potency"}	\N	\N	\N
恒例	こうれい	{いつもきまって行われること。多く、儀式や行事にいう。また、その儀式や行事。「新春―の歌会」「―によって一言御挨拶申し上げます」}	{"an established custom 〜の〔しきたりの〕customary; 〔例年の〕annual"}	\N	\N	\N
声	こえ	{}	{voice}	\N	\N	\N
氷	こおり	{}	{ice}	\N	\N	\N
凍り付く	こおりつく	{硬く凍る}	{"be frozen；freeze to"}	\N	\N	\N
凍る	こおる	{}	{"freeze; be frozen over; congeal"}	\N	\N	\N
焦がす	こがす	{}	{"burn; scorch; singe; char"}	\N	\N	\N
小柄	こがら	{}	{"short (build)"}	\N	\N	\N
扱き下ろす	こきおろす	{欠点などを殊更に指摘して、ひどくけなす。「上役を―・して溜飲 (りゅういん) を下げる」}	{"criticize severely; ((口)) pan; run down; put down"}	\N	\N	\N
小切手	こぎって	{}	{"cheque; check"}	\N	\N	\N
顧客	こきゃく	{ひいきにしてくれる客。得意客。}	{"a customer; a patron; clientele"}	\N	\N	\N
呼吸	こきゅう	{}	{"breath; respiration; knack; trick; secret (of doing something)"}	\N	\N	\N
故郷	こきょう	{}	{"home town; birthplace; old or historic village"}	\N	\N	\N
漕ぐ	こぐ	{}	{"to row; to scull; to pedal"}	\N	\N	\N
国王	こくおう	{}	{king}	\N	\N	\N
国語	こくご	{}	{"national language"}	\N	\N	\N
国際	こくさい	{}	{international}	\N	\N	\N
国産	こくさん	{}	{"domestic manifacturing"}	\N	\N	\N
黒人	こくじん	{}	{"black person"}	\N	\N	\N
国籍	こくせき	{}	{nationality}	\N	\N	\N
国定	こくてい	{}	{"state-sponsored; national"}	\N	\N	\N
国土	こくど	{}	{realm}	\N	\N	\N
告白	こくはく	{}	{"confession; acknowledgement"}	\N	\N	\N
告発	こくはつ	{悪事や不正を明らかにして、世間に知らせること。告訴。訴え}	{"a formal charge [accusation]((against))"}	\N	\N	\N
黒板	こくばん	{}	{blackboard}	\N	\N	\N
克服	こくふく	{努力して困難にうちかつこと。「病を―する」}	{"subjugation; conquest"}	\N	\N	\N
国防	こくぼう	{}	{"national defence"}	\N	\N	\N
国民	こくみん	{国家を構成し、その国の国籍を有する者。国政に参与する地位では公民または市民ともよばれる。}	{"people; citizen"}	\N	\N	\N
穀物	こくもつ	{}	{"grain; cereal; corn"}	\N	\N	\N
国有	こくゆう	{}	{"national ownership"}	\N	\N	\N
国立	こくりつ	{}	{national}	\N	\N	\N
国連	こくれん	{}	{"U.N.; United Nations"}	\N	\N	\N
固形	こけい	{}	{"solid (固形茶から)"}	\N	\N	\N
焦げ茶	こげちゃ	{}	{"black tea"}	\N	\N	\N
焦げる	こげる	{}	{"burn; be burned"}	\N	\N	\N
箇箇	ここ	{}	{"individual; separate"}	\N	\N	\N
此処	ここ	{話し手が現にいる場所をさす。}	{here}	\N	\N	\N
凍える	こごえる	{}	{"freeze; be chilled; be frozen"}	\N	\N	\N
心地	ここち	{}	{"feeling; sensation; mood"}	\N	\N	\N
九日	ここのか	{}	{"nine days; the ninth day (of the month)"}	\N	\N	\N
九つ	ここのつ	{}	{nine}	\N	\N	\N
越える	こえる	{}	{"to cross over; to cross; to pass through; to pass over (out of)"}	\N	{超える}	\N
個々	ここ	{}	{"individual; one by one"}	\N	{個個}	\N
心	こころ	{}	{"mind; heart"}	\N	\N	\N
心得	こころえ	{}	{"knowledge; information"}	\N	\N	\N
心得る	こころえる	{}	{"be informed; have thorough knowledge"}	\N	\N	\N
心掛け	こころがけ	{}	{"readiness; intention; aim"}	\N	\N	\N
心掛ける	こころがける	{}	{"to bear in mind; to aim to do"}	\N	\N	\N
志	こころざし	{}	{"will; intention; motive"}	\N	\N	\N
志す	こころざす	{}	{"to plan; to intend; to aspire to; to set aims (sights on)"}	\N	\N	\N
心強い	こころづよい	{}	{"heartening; reassuring"}	\N	\N	\N
心細い	こころぼそい	{}	{"helpless; forlorn; hopeless; unpromising; lonely; discouraging; disheartening"}	\N	\N	\N
試み	こころみ	{}	{"trial; experiment"}	\N	\N	\N
試みる	こころみる	{}	{"to try; to test"}	\N	\N	\N
快い	こころよい	{}	{"pleasant; agreeable"}	\N	\N	\N
腰	こし	{}	{hip}	\N	\N	\N
孤児	こじ	{}	{orphan}	\N	\N	\N
腰掛け	こしかけ	{}	{"seat; bench"}	\N	\N	\N
腰掛ける	こしかける	{}	{"sit (down)"}	\N	\N	\N
乞食	こじき	{}	{beggar}	\N	\N	\N
故障	こしょう	{}	{breakdown}	\N	\N	\N
個人	こじん	{}	{"individual; personal; private"}	\N	\N	\N
超す	こす	{}	{"cross; pass; tide over"}	\N	\N	\N
梢	こずえ	{}	{treetop}	\N	\N	\N
個性	こせい	{}	{"individuality; personality; idiosyncrasy"}	\N	\N	\N
戸籍	こせき	{}	{"census; family register"}	\N	\N	\N
小銭	こぜに	{}	{"coins; small change"}	\N	\N	\N
固体	こたい	{}	{"solid (body)"}	\N	\N	\N
個体	こたい	{}	{"an individual"}	\N	\N	\N
古代	こだい	{}	{"ancient times"}	\N	\N	\N
答	こたえ	{}	{"answer; response"}	\N	\N	\N
答え	こたえ	{}	{"answer (noun)"}	\N	\N	\N
応え	こたえ	{他からの作用・刺激に対する反応。ききめ。効果。「大衆に呼びかけても―がない」}	{result}	\N	\N	\N
答える	こたえる	{}	{"to answer; to reply"}	\N	\N	\N
火燵	こたつ	{}	{"table with heater; (orig) charcoal brazier in a floor well"}	\N	\N	\N
誇張	こちょう	{}	{exaggeration}	\N	\N	\N
国家	こっか	{}	{"state; country; nation"}	\N	\N	\N
国会	こっかい	{}	{"National Diet; parliament; congress"}	\N	\N	\N
小遣い	こづかい	{}	{"personal expenses; pocket money; spending money; incidental expenses; allowance"}	\N	\N	\N
滑稽	こっけい	{笑いの対象となる、おもしろいこと。おどけたこと。また、そのさま。「―なしぐさ」}	{"funny; humorous; comical; laughable; ridiculous; joking"}	\N	\N	\N
滑稽さ	こっけいさ	{}	{"humor; funniness"}	\N	\N	\N
国交	こっこう	{}	{"diplomatic relations"}	\N	\N	\N
骨折	こっせつ	{}	{"bone fracture"}	\N	\N	\N
骨頂	こっちょう	{程度がこれ以上ないこと。}	{pinnacle}	\N	\N	\N
小包	こづつみ	{}	{"parcel; package"}	\N	\N	\N
骨董品	こっとうひん	{}	{curio}	\N	\N	\N
骨盤	こつばん	{}	{"hip bone; pelvis"}	\N	\N	\N
固定	こてい	{}	{fixation}	\N	\N	\N
古典	こてん	{}	{"old book; classic; classics"}	\N	\N	\N
事	こと	{}	{"thing; matter; fact; circumstances; business; reason; experience"}	\N	\N	\N
琴	こと	{}	{"koto (Japanese harp)"}	\N	\N	\N
負かす	まかす	{}	{"to defeat"}	\N	\N	\N
凝る	こごる	{液体状のものが、冷えたり凍ったりして凝固する。「魚の煮汁が―・る」「食うものはなくなった。水筒の水は―・ってしまった」}	{"to congeal; to freeze"}	\N	\N	\N
擦る	こする	{}	{"rub; scrub"}	\N	\N	\N
骨	こつ	{}	{"knack; skill"}	\N	\N	\N
骨格	こっかく	{}	{"〔骨組み〕a framework; 〔動物学上の〕a skeleton; 〔体付き〕a build"}	\N	{骨骼}	\N
心当たり	こころあたり	{心に思い当たること。また、見当をつけた場所。「就職口なら―がある」「―を探してみる」}	{"having some knowledge of; happening to know; 〜がある have in mind; know of"}	\N	\N	\N
故人	こじん	{死んだ人。死者。死人。「―を弔う」「―となる」}	{"the deceased; old friend; the departed〔亡くなった人たち〕the dead"}	\N	\N	\N
事柄	ことがら	{物事の内容・ようす。また、物事そのもの。「調べた―を発表する」「新企画に関する極秘の―」「重大な―」}	{"matter; thing; affair; circumstance"}	\N	\N	\N
孤独	こどく	{}	{"isolation; loneliness; solitude"}	\N	\N	\N
今年	ことし	{}	{"this year"}	\N	\N	\N
言付ける	ことづける	{}	{"send word; send a message"}	\N	\N	\N
言伝	ことづて	{}	{"declaration; hearsay"}	\N	\N	\N
異なる	ことなる	{}	{"differ; vary; disagree"}	\N	\N	\N
殊に	ことに	{}	{"especially; above all"}	\N	\N	\N
事によると	ことによると	{}	{"depending on the circumstances"}	\N	\N	\N
言葉遣い	ことばづかい	{}	{"speech; expression; wording"}	\N	\N	\N
子供	こども	{}	{"children; kids"}	\N	\N	\N
小鳥	ことり	{}	{"(small) bird"}	\N	\N	\N
断る	ことわる	{}	{"refuse; reject; dismiss; turn down; decline; inform; give notice; ask leave; excuse oneself (from)"}	\N	\N	\N
粉	こな	{}	{"flour; meal; powder"}	\N	\N	\N
粉々	こなごな	{}	{"in very small pieces"}	\N	\N	\N
この頃	このごろ	{}	{recently}	\N	\N	\N
好ましい	このましい	{}	{"nice; likeable; desirable"}	\N	\N	\N
好み	このみ	{}	{"liking; taste; choice"}	\N	\N	\N
好む	このむ	{}	{"like; prefer"}	\N	\N	\N
拒む	こばむ	{}	{reject}	\N	\N	\N
個別	こべつ	{}	{"particular case"}	\N	\N	\N
零す	こぼす	{}	{"to spill"}	\N	\N	\N
零れる	こぼれる	{}	{"to overflow; to spill"}	\N	\N	\N
細かい	こまかい	{}	{"small; detailed"}	\N	\N	\N
細やか	こまやか	{}	{friendly}	\N	\N	\N
困る	こまる	{}	{"be troubled; be worried; be bothered"}	\N	\N	\N
混む	こむ	{}	{"to be crowded"}	\N	\N	\N
込む	こむ	{}	{"be crowded"}	\N	\N	\N
小麦	こむぎ	{}	{wheat}	\N	\N	\N
米	こめ	{}	{rice}	\N	\N	\N
込める	こめる	{}	{"to include; to put into"}	\N	\N	\N
篭る	こもる	{}	{"to seclude oneself; to be confined in; to be implied; to be stuffy"}	\N	\N	\N
顧問	こもん	{会社、団体などで、相談を受けて意見を述べる役。また、その人。}	{"an adviser; an advisor ((to)); a counselor，((英)) a counsellor; 〔コンサルタント〕a consultant"}	\N	\N	\N
顧問料	こもんりょう	{}	{"lawyer fees"}	\N	\N	\N
小屋	こや	{}	{"hut; cabin; shed; (animal) pen"}	\N	\N	\N
固有	こゆう	{}	{"characteristic; tradition; peculiar; inherent; eigen-"}	\N	\N	\N
小指	こゆび	{}	{"little finger"}	\N	\N	\N
暦	こよみ	{}	{"calendar; almanac"}	\N	\N	\N
懲らす	こらす	{こらしめる。「悪を―・す」}	{chastise}	\N	\N	\N
孤立	こりつ	{}	{"isolation; helplessness"}	\N	\N	\N
懲りる	こりる	{}	{"to learn by experience; to be disgusted with"}	\N	\N	\N
転がす	ころがす	{}	{"roll (transitive)"}	\N	\N	\N
転がる	ころがる	{}	{"roll; tumble"}	\N	\N	\N
殺す	ころす	{}	{kill}	\N	\N	\N
転ぶ	ころぶ	{}	{"fall down; fall over"}	\N	\N	\N
怖い	こわい	{それに近づくと危害を加えられそうで不安である。自分にとってよくないことが起こりそうで、近づきたくない。「夜道がー・い」「地震がー・い」「ー・いおやじ」}	{frightening}	\N	\N	\N
恐い	こわい	{悪い結果がでるのではないかと不安で避けたい気持ちである。「かけ事はー・いからしない」「あとがー・い」}	{"〔恐ろしい〕fearful; frightening; horrible; dreadful"}	\N	\N	\N
壊す	こわす	{}	{"break; destroy"}	\N	\N	\N
壊れる	こわれる	{}	{"be broken"}	\N	\N	\N
紺	こん	{}	{"navy blue; deep blue"}	\N	\N	\N
婚姻	こんいん	{結婚すること}	{marriage}	\N	\N	\N
今夏	こんか	{}	{"this summer"}	\N	\N	\N
今回	こんかい	{}	{"now; this time; lately"}	\N	\N	\N
根気	こんき	{}	{"patience; perseverance; energy"}	\N	\N	\N
根拠	こんきょ	{}	{"basis; foundation"}	\N	\N	\N
雇用	こよう	{人をやとい入れること。「実務経験者を―する」「終身―」}	{"employment (long term); hire"}	\N	{雇傭}	\N
混血	こんけつ	{}	{"mixed race; mixed parentage"}	\N	\N	\N
今月	こんげつ	{}	{"this month"}	\N	\N	\N
今後	こんご	{今からのち。こののち。以後。「―もよろしく願います」「―いっさい関知しない」}	{"〔これから〕after this; from now on; 〔将来〕in (the) future (▼((英))ではtheはつけない)"}	\N	\N	\N
混合	こんごう	{}	{"mixing; mixture"}	\N	\N	\N
混雑	こんざつ	{}	{"confusion; congestion"}	\N	\N	\N
今週	こんしゅう	{}	{"this week"}	\N	\N	\N
献立	こんだて	{}	{"menu; program; schedule"}	\N	\N	\N
懇談	こんだん	{}	{"informal talk"}	\N	\N	\N
懇談会	こんだんかい	{リラックスしました会議や集まりなど}	{"round-table meeting (informal)"}	\N	\N	\N
昆虫	こんちゅう	{}	{"insect; bug"}	\N	\N	\N
根底	こんてい	{}	{"root; basis; foundation"}	\N	\N	\N
今度	こんど	{}	{"next time"}	\N	\N	\N
混同	こんどう	{}	{"confusion; mixing; merger"}	\N	\N	\N
困難	こんなん	{物事をするのが非常にむずかしいこと。また、そのさま。難儀。苦しみ悩むこと。苦労すること。「―に立ち向かう」「予期しない―な問題にぶつかる」}	{"difficulty; distress"}	\N	\N	\N
今日は	こんにちは	{}	{"hello; good day (daytime greeting id)"}	\N	\N	\N
今晩	こんばん	{}	{"tonight; this evening"}	\N	\N	\N
根本	こんぽん	{}	{"origin; source; foundation; root; base; principle"}	\N	\N	\N
今夜	こんや	{}	{tonight}	\N	\N	\N
婚約	こんやく	{}	{"engagement; betrothal"}	\N	\N	\N
混乱	こんらん	{}	{"disorder; chaos; confusion; mayhem"}	\N	\N	\N
句	く	{}	{"phrase; clause; sentence; passage; paragraph; expression; line; verse; stanza; 17-syllable poem"}	\N	\N	\N
区	く	{}	{"ward; district; section"}	\N	\N	\N
悔い改める	くいあらためる	{過去の過ちを反省して心がけを変える。}	{"repent; is sorry for"}	\N	\N	\N
区域	くいき	{}	{"limits; boundary; domain; zone; sphere; territory"}	\N	\N	\N
食い違う	くいちがう	{}	{"to cross each other; to run counter to; to differ; to clash; to go awry"}	\N	\N	\N
悔いる	くいる	{}	{regret}	\N	\N	\N
空気	くうき	{}	{air}	\N	\N	\N
空港	くうこう	{}	{"air port"}	\N	\N	\N
空想	くうそう	{}	{"daydream; fantasy; fancy; vision"}	\N	\N	\N
空中	くうちゅう	{}	{"sky; air"}	\N	\N	\N
空白	くうはく	{}	{"vacuum :: empty space"}	\N	\N	\N
空腹	くうふく	{}	{hunger}	\N	\N	\N
区画	くかく	{}	{"division; section; compartment; boundary; area; block"}	\N	\N	\N
区間	くかん	{}	{"section (of track etc)"}	\N	\N	\N
茎	くき	{}	{stalk}	\N	\N	\N
茎茶	くきちゃ	{}	{"stalk tea"}	\N	\N	\N
区切り	くぎり	{}	{"an end; a stop; punctuation"}	\N	\N	\N
苦境	くきょう	{苦しい境遇。苦しい立場。「―を乗りこえる」「―に立つ」「―に陥る」「―に直面する」}	{"predicament;〔難局〕difficulties; 〔逆境〕adversity"}	\N	\N	\N
区切る	くぎる	{}	{"punctuate; cut off; mark off; stop; put an end to"}	\N	\N	\N
草	くさ	{}	{grass}	\N	\N	\N
種々	くさぐさ	{}	{variety}	\N	\N	\N
鎖	くさり	{}	{chain}	\N	\N	\N
腐る	くさる	{}	{"rot; go bad"}	\N	\N	\N
串	くし	{魚貝・獣肉・野菜などを刺し通して焼いたり干したりするのに用いる、先のとがった竹や鉄などの細長い棒。「―を打つ」「―を刺す」}	{"〔焼きぐし〕a skewer; 〔丸焼き用の大型の〕a spit; 〔焼肉用金ぐし〕a broach"}	\N	\N	\N
櫛	くし	{}	{comb}	\N	\N	\N
旧事	くじ	{}	{"past events; bygones"}	\N	\N	\N
籤引	くじびき	{}	{"lottery; drawn lot"}	\N	\N	\N
串焼き	くしやき	{魚貝・肉・野菜などを串に刺して焼くこと。また、焼いたもの。}	{"fish; meat; shellfish; or vegetables grilled on skewers"}	\N	\N	\N
苦笑	くしょう	{他人または自分の行動やおかれた状況の愚かしさ・こっけいさに、不快感やとまどいの気持ちをもちながら、しかたなく笑うこと。にが笑い。「―をもらす」「相手の詭弁 (きべん) に―する」}	{"(give) a wry [bitter] smile"}	\N	\N	\N
苦情	くじょう	{}	{"complaint; troubles; objection"}	\N	\N	\N
苦心	くしん	{}	{"pain; trouble; anxiety; diligence; hard work"}	\N	\N	\N
金色	こんじき	{黄金の色。きんいろ。}	{"golden; golden-colored"}	\N	\N	\N
今日	こんにち	{}	{today}	\N	\N	\N
懇々	こんこん	{}	{earnestly}	\N	{懇懇}	\N
食う	くう	{}	{"（食べる）eat; have"}	\N	\N	\N
崩す	くずす	{}	{"destroy; pull down; make change (money)"}	\N	\N	\N
薬	くすり	{}	{medicine}	\N	\N	\N
薬指	くすりゆび	{}	{"ring finger"}	\N	\N	\N
崩れる	くずれる	{}	{"collapse; crumble"}	\N	\N	\N
癖	くせ	{}	{"a habit (often a bad habit; i.e. vice); peculiarity"}	\N	\N	\N
砕く	くだく	{}	{"break; smash"}	\N	\N	\N
砕ける	くだける	{}	{"break; be broken"}	\N	\N	\N
下さい	ください	{「くれ」の尊敬語。相手に物や何かを請求する意を表す。ちょうだいしたい。「手紙を―」「しばらく時間を―」}	{"please; (I) would like"}	\N	\N	\N
下さる	くださる	{}	{"give (polite)"}	\N	\N	\N
草臥れる	くたびれる	{}	{"to get tired; to wear out"}	\N	\N	\N
果物	くだもの	{}	{fruit}	\N	\N	\N
下り	くだり	{}	{"down-train (going away from Tokyo)"}	\N	\N	\N
件	くだん	{}	{"example; precedent; the usual; the said; the above-mentioned; (man) in question"}	\N	\N	\N
口	くち	{}	{"mouth; orifice; opening"}	\N	\N	\N
口裏	くちうら	{言葉や話し方に隠されているもの。また、その人の心の中がうかがえるような、言葉や話し方。「その―から大体のところはわかる」}	{"(a person's) feelings; inner thoughts"}	\N	\N	\N
口占	くちうら	{人の言葉を聞いて吉凶を占うこと。}	{"inner thoughts"}	\N	\N	\N
口裏を合わせる	くちうらをあわせる	{あらかじめ相談して話の内容が食い違わないようにする。}	{"to arrange beforehand to tell the same story"}	\N	\N	\N
口ずさむ	くちずさむ	{}	{"to hum something; to sing to oneself"}	\N	\N	\N
唇	くちびる	{}	{lips}	\N	\N	\N
口紅	くちべに	{}	{lipstick}	\N	\N	\N
朽ちる	くちる	{}	{"to rot"}	\N	\N	\N
靴	くつ	{}	{"shoes; footwear"}	\N	\N	\N
苦痛	くつう	{}	{"pain; agony"}	\N	\N	\N
覆す	くつがえす	{}	{"to overturn; to upset; to overthrow; to undermine"}	\N	\N	\N
靴下	くつした	{}	{socks}	\N	\N	\N
屈折	くっせつ	{}	{"bending; indentation; refraction"}	\N	\N	\N
くっ付く	くっつく	{}	{"to adhere to; to keep close to"}	\N	\N	\N
くっ付ける	くっつける	{}	{"to attach"}	\N	\N	\N
句読点	くとうてん	{}	{"punctuation marks"}	\N	\N	\N
口説く	くどく	{異性に対して、自分の思いを受け入れるよう説得する。言い寄る。「言葉巧みに―・く」}	{"advances (flirt) [persuade; talk some on into doing]"}	\N	\N	\N
国	くに	{}	{country}	\N	\N	\N
国番号	くにばんごう	{}	{"〔国際電話の〕the country code ((for the U.S.))"}	\N	\N	\N
配る	くばる	{}	{"deliver; distribute"}	\N	\N	\N
首	くび	{}	{neck}	\N	\N	\N
首飾り	くびかざり	{}	{necklace}	\N	\N	\N
首輪	くびわ	{}	{"necklace; choker"}	\N	\N	\N
工夫	くふう	{}	{"device; scheme"}	\N	\N	\N
区分	くぶん	{}	{"division; section; compartment; demarcation; (traffic) lane; classification; sorting"}	\N	\N	\N
区別	くべつ	{}	{"distinction; differentiation; classification"}	\N	\N	\N
組	くみ	{}	{"class; group; team; set"}	\N	\N	\N
組合	くみあい	{}	{"association; union"}	\N	\N	\N
組み合わせ	くみあわせ	{}	{combination}	\N	\N	\N
組み合わせる	くみあわせる	{}	{"to join together; to combine; to join up"}	\N	\N	\N
組み込み	くみこみ	{}	{"embedded; built-in; inserted"}	\N	\N	\N
組み込む	くみこむ	{}	{"to insert; to include; to cut in (printing)"}	\N	\N	\N
組み立てる	くみたてる	{}	{"assemble; set up; construct"}	\N	\N	\N
酌む	くむ	{}	{"serve sake"}	\N	\N	\N
組む	くむ	{}	{"put together"}	\N	\N	\N
雲	くも	{}	{"the clouds"}	\N	\N	\N
曇り	くもり	{}	{"cloudiness; cloudy weather; shadow"}	\N	\N	\N
曇る	くもる	{}	{"become cloudy; become dim"}	\N	\N	\N
悔しい	くやしい	{}	{"regrettable; mortifying; vexing"}	\N	\N	\N
悔やむ	くやむ	{}	{mourn}	\N	\N	\N
蔵	くら	{}	{"warehouse; cellar; magazine; granary; godown; depository; treasury; elevator"}	\N	\N	\N
暗い	くらい	{}	{"dark; gloomy"}	\N	\N	\N
前もって	まえもって	{}	{"in advance; beforehand; previously"}	\N	\N	\N
暮らし	くらし	{}	{"living; livelihood; subsistence; circumstances"}	\N	\N	\N
暮らす	くらす	{}	{"live; get along"}	\N	\N	\N
比べる	くらべる	{}	{compare}	\N	\N	\N
栗	くり	{}	{chestnut}	\N	\N	\N
繰り返す	くりかえす	{}	{repeat}	\N	\N	\N
狂う	くるう	{}	{"go mad; get out of order"}	\N	\N	\N
苦しい	くるしい	{}	{"painful; difficult"}	\N	\N	\N
苦しむ	くるしむ	{}	{"suffer; groan; be worried"}	\N	\N	\N
苦しめる	くるしめる	{}	{"to torment; to harass; to inflict pain"}	\N	\N	\N
車	くるま	{}	{"car; vehicle; wheel"}	\N	\N	\N
暮れ	くれ	{}	{"year end; sunset; nightfall; end"}	\N	\N	\N
くれぐれも	呉々も	{何度も心をこめて依頼・懇願したり、忠告したりするさま。「―お大事に」}	{"very best (wishes); upmost"}	\N	\N	\N
暮れる	くれる	{}	{"get dark"}	\N	\N	\N
呉れる	くれる	{}	{"to give; to let one have; to do for one; to be given"}	\N	\N	\N
黒	くろ	{}	{"the color black (noun)"}	\N	\N	\N
黒い	くろい	{}	{"black; dark"}	\N	\N	\N
玄人	くろうと	{}	{"expert; professional; geisha; prostitute"}	\N	\N	\N
黒帯	くろおび	{}	{"black belt"}	\N	\N	\N
黒字	くろじ	{}	{"balance (figure) in the black"}	\N	\N	\N
黒幕	くろまく	{}	{"black curtains (polical meaning)"}	\N	\N	\N
加える	くわえる	{}	{"append; sum up; include; increase; inflict"}	\N	\N	\N
詳しい	くわしい	{}	{"knowing very well; detailed; full; accurate"}	\N	\N	\N
加わる	くわわる	{}	{"join in; accede to; increase; gain in (influence)"}	\N	\N	\N
訓	くん	{}	{"native Japanese reading of a Chinese character"}	\N	\N	\N
勲	くん	{勲位。勲等。勲等の等級を表す。「―三等」}	{"a decoration; an order"}	\N	\N	\N
君主	くんしゅ	{}	{"ruler; monarch"}	\N	\N	\N
訓練	くんれん	{}	{"practice; training"}	\N	\N	\N
貧しさ	まずしさ	{財産や金銭がとぼしく、生活が苦しい；乏しい；必要量に足りない}	{poverty}	\N	\N	\N
真に受ける	まにうける	{言葉どおりに受け取る。「冗談をー・ける」}	{"take seriously"}	\N	\N	\N
満場一致	まんじょういっち	{その場にいるすべての人の意見が一致すること。「ーで可決」}	{unanimous}	\N	\N	\N
枚	まい	{}	{"counter for flat objects (e.g. sheets of paper)"}	\N	\N	\N
毎朝	まいあさ	{}	{"every morning"}	\N	\N	\N
毎月	まいげつ	{}	{"every month; each month; monthly"}	\N	\N	\N
迷子	まいご	{}	{"lost (stray) child"}	\N	\N	\N
毎週	まいしゅう	{}	{"every week"}	\N	\N	\N
枚数	まいすう	{}	{"the number of flat things"}	\N	\N	\N
埋蔵	まいぞう	{}	{"buried property; treasure trove"}	\N	\N	\N
毎度	まいど	{}	{"each time; common service-sector greeting"}	\N	\N	\N
毎日	まいにち	{}	{"every day"}	\N	\N	\N
毎晩	まいばん	{}	{"every night"}	\N	\N	\N
参る	まいる	{}	{"come (polite )"}	\N	\N	\N
舞う	まう	{}	{"to dance; to flutter about; to revolve"}	\N	\N	\N
真上	まうえ	{}	{"just above; right overhead"}	\N	\N	\N
前売り	まえうり	{}	{"advance sale; booking"}	\N	\N	\N
前置き	まえおき	{}	{"preface; introduction"}	\N	\N	\N
来る	くる	{}	{"come; come to hand; arrive; approach; call on; set in; be due; become; grow; get; come from; be caused by; derive from"}	\N	\N	\N
君	くん	{}	{"Mr (junior); master; boy"}	\N	\N	\N
前	まえ	{}	{front}	\N	\N	\N
燻製	くんせい	{魚や獣の肉を塩漬けにし、ナラ・カシ・桜など樹脂の少ない木くずをたいた煙でいぶし、乾燥させた食品。特殊の香味をもち、保存性がある。「サケの―」}	{"smoking; 〜の smoked (salmon)"}	\N	{薫製}	\N
呉々も	くれぐれも	{何度も心をこめて依頼・懇願したり、忠告したりするさま。「―お大事に」}	{"very best (wishes); upmost"}	\N	{呉呉も}	\N
苦労	くろう	{}	{"〔辛苦〕hardship(s); 〔骨折り〕trouble; pains; 〔心配〕anxiety; worry ((over))"}	\N	\N	\N
位	くらい	{"","",おおよその分量・程度を表す。ほど。ばかり。「一〇歳―の男の子」「その―で十分だ」}	{"grade; rank; court order; dignity; nobility; situation; throne; crown; occupying a position","〔大体の数や量〕about; around; .. or so; roughly","〔軽く見る気持ちで，その程度の〕at least (answer me); enough (money)"}	\N	\N	\N
任す	まかす	{}	{"to entrust; to leave to a person"}	\N	\N	\N
任せる	まかせる	{}	{"entrust to another; leave to; do something at one´s leisure"}	\N	\N	\N
賄う	まかなう	{}	{"to give board to; to provide meals; to pay"}	\N	\N	\N
曲がる	まがる	{}	{"to turn; to bend"}	\N	\N	\N
曲る	まがる	{}	{"curve; be bent; be crooked; turn"}	\N	\N	\N
巻	まき	{}	{volume}	\N	\N	\N
薪	まき	{}	{"fire wood"}	\N	\N	\N
紛らわしい	まぎらわしい	{}	{"confusing; misleading; equivocal; ambiguous"}	\N	\N	\N
紛れる	まぎれる	{}	{"to be diverted; to slip into"}	\N	\N	\N
膜	まく	{}	{"membrane; film"}	\N	\N	\N
巻く	まく	{}	{"wind; coil; roll"}	\N	\N	\N
枕	まくら	{}	{"pillow; bolster"}	\N	\N	\N
負け	まけ	{}	{"defeat; loss; losing (a game)"}	\N	\N	\N
曲げる	まげる	{}	{"bend; lean; be crooked"}	\N	\N	\N
孫	まご	{}	{grandchild}	\N	\N	\N
真心	まこころ	{}	{"sincerity; devotion"}	\N	\N	\N
誠	まこと	{}	{"truth; faith; fidelity; sincerity; trust; confidence; reliance; devotion"}	\N	\N	\N
正しく	まさしく	{}	{"surely; no doubt; evidently"}	\N	\N	\N
摩擦	まさつ	{}	{"friction; rubbing; rubdown; chafe"}	\N	\N	\N
正に	まさに	{}	{"correctly; surely"}	\N	\N	\N
勝る	まさる	{}	{"to excel; to surpass; to outrival"}	\N	\N	\N
増し	まし	{}	{"extra; additional; less objectionable; better; preferable"}	\N	\N	\N
交える	まじえる	{}	{"to mix; to converse with; to cross (swords)"}	\N	\N	\N
真下	ました	{}	{"right under; directly below"}	\N	\N	\N
況して	まして	{}	{"still more; still less (with neg. verb); to say nothing of; not to mention"}	\N	\N	\N
真面目	まじめ	{}	{"diligent; serious; honest"}	\N	\N	\N
魔女	まじょ	{}	{witch}	\N	\N	\N
交わる	まじわる	{}	{"to cross; to intersect; to associate with; to mingle with; to interest; to join"}	\N	\N	\N
増す	ます	{}	{"increase; grow"}	\N	\N	\N
先ず	まず	{}	{"at first"}	\N	\N	\N
麻酔	ますい	{}	{anaesthesia}	\N	\N	\N
不味い	まずい	{}	{"unappetising; unpleasant (taste appearance situation); ugly; unskilful; awkward; bungling; unwise; untimely"}	\N	\N	\N
貧しい	まずしい	{}	{"poor; needy"}	\N	\N	\N
益々	ますます	{}	{"increasingly; more and more"}	\N	\N	\N
混ぜる	まぜる	{}	{"mix; stir"}	\N	\N	\N
交ぜる	まぜる	{}	{"be mixed; be blended with"}	\N	\N	\N
股	また	{}	{"groin; crotch; thigh"}	\N	\N	\N
瞬き	またたき	{}	{"wink; twinkling (of stars); flicker (of light)"}	\N	\N	\N
又は	または	{}	{"or; the other"}	\N	\N	\N
町	まち	{}	{"town; street; road"}	\N	\N	\N
待合室	まちあいしつ	{}	{"waiting room"}	\N	\N	\N
待ち合わせ	まちあわせ	{}	{appointment}	\N	\N	\N
待ち合わせる	まちあわせる	{}	{"rendezvous; meet at a prearranged place and time"}	\N	\N	\N
間違い	まちがい	{}	{mistake}	\N	\N	\N
間違う	まちがう	{あるべき状態や結果と異なる。違う。「―・った考え方」「この手紙は住所が―・っている」}	{"to make a mistake; to be incorrect; to be mistaken"}	\N	\N	\N
間違える	まちがえる	{}	{"make a mistake"}	\N	\N	\N
混ざる	まざる	{}	{"to be mixed; to be blended with; to associate with; to mingle with; to join"}	\N	{交ざる}	\N
誠に	まことに	{まちがいなくある事態であるさま。じつに。本当に。「―彼女は美しい」「―ありがとうございます」}	{"really (good news); truly (sorry); exactly/just (as you say)"}	\N	{真に,実に}	\N
混じる	まじる	{}	{"to be mixed; to be blended with; to associate with; to mingle with; to interest; to join"}	\N	{交じる}	\N
又	また	{}	{"again; and"}	\N	{亦,復}	\N
負ける	まける	{相手と戦ったり争ったりした結果、力の劣った立場になる。敗れる。「試合に―・ける」「賭けに―・ける」⇔勝つ。,値段を安くする。また、おまけとして付ける。「売れ残りを―・けて売る」「一個―・けてもらう」}	{"〔敗北する〕be defeated ((in battle)); be beaten; lose (((in) a game))","〔値引きする〕reduce ((the price)); give a discount ((on tickets))"}	\N	\N	\N
街角	まちかど	{}	{"street corner"}	\N	\N	\N
満ち足りる	みちたりる	{不足がなく十分である。十分に満足する。「―・りた生活」}	{"get satisfied; find contemption"}	\N	\N	\N
待ち遠しい	まちどおしい	{}	{"looking forward to"}	\N	\N	\N
待ち望む	まちのぞむ	{}	{"to look anxiously for; to wait eagerly for"}	\N	\N	\N
松	まつ	{}	{"pine tree; highest (of a three-tier ranking system)"}	\N	\N	\N
待つ	まつ	{}	{wait}	\N	\N	\N
真っ赤	まっか	{}	{"deep red; flushed (of face)"}	\N	\N	\N
末期	まっき	{}	{"closing years (period days); last stage"}	\N	\N	\N
真っ暗	まっくら	{}	{"total darkness; pitch dark; shortsightedness"}	\N	\N	\N
真っ黒	まっくろ	{}	{"pitch black"}	\N	\N	\N
真っ青	まっさお	{}	{"deep blue; ghastly pale"}	\N	\N	\N
真っ先	まっさき	{}	{"the head; the foremost; beginning"}	\N	\N	\N
末梢	まっしょう	{塗りつぶして消すこと。「登録を―する」}	{"erasure; obliteration"}	\N	\N	\N
真っ白	まっしろ	{}	{"pure white"}	\N	\N	\N
まったり	まったり	{味わいがおだやかで、こくのあるさま。「―（と）した味」}	{"chillin (taste)"}	\N	\N	\N
真っ直ぐ	まっすぐ	{}	{"straight (ahead); direct; upright; erect; honest; frank"}	\N	\N	\N
全く	まったく	{完全にその状態になっているさま。すっかり。決して。全然。「―新しい企画」「回復の希望は―絶たれた」}	{"really; truly; entirely; completely; wholly; perfectly; indeed"}	\N	\N	\N
抹茶	まっちゃ	{}	{matcha}	\N	\N	\N
真っ二つ	まっぷたつ	{}	{"in two equal parts"}	\N	\N	\N
祭る	まつる	{}	{"deify; enshrine"}	\N	\N	\N
祀る	まつる	{儀式をととのえて神霊をなぐさめ、また、祈願する。「先祖のみ霊 (たま) を―・る」「死者を―・る」}	{worship}	\N	\N	\N
窓	まど	{}	{window}	\N	\N	\N
惑う	まどう	{どうしたらよいか判断に苦しむ。}	{"be perplexed"}	\N	\N	\N
窓口	まどぐち	{}	{"ticket window"}	\N	\N	\N
まとめ	纏め	{まとめること。また、まとめたもの。「―の段階に入る」}	{"〔集める〕collect; gather together〔整える〕put in order; arrange; 〔統一する〕unify"}	\N	\N	\N
学ぶ	まなぶ	{}	{"learn; study (in depth)"}	\N	\N	\N
間に合う	まにあう	{}	{"to be in time (for)"}	\N	\N	\N
免れる	まぬかれる	{}	{"to escape from; to be rescued from; to avoid; to evade; to avert; to elude; to be exempted; to be relieved from pain; to get rid of"}	\N	\N	\N
招き	まねき	{}	{invitation}	\N	\N	\N
真似る	まねる	{}	{"mimic; imitate"}	\N	\N	\N
疎ら	まばら	{物が少なくて、間がすいているさま。すきまのあいているさま。「人通りも―な住宅街」}	{sparse}	\N	\N	\N
麻痺	まひ	{}	{"paralysis; palsy; numbness; stupor"}	\N	\N	\N
目蓋	まぶた	{}	{eyelid}	\N	\N	\N
眩しい	まぶしい	{}	{"blinding (light)"}	\N	\N	\N
幻	まぼろし	{}	{visionary}	\N	\N	\N
間々	まま	{}	{"occasionally; frequently"}	\N	\N	\N
豆	まめ	{}	{"beans; peas; (as a prefix) miniature; tiny"}	\N	\N	\N
間もなく	まもなく	{}	{"soon; before long; in a short time"}	\N	\N	\N
守る	まもる	{}	{"protect; obey; guard; abide (by the rules)"}	\N	\N	\N
眉	まゆ	{}	{eyebrow}	\N	\N	\N
眉毛	まゆげ	{}	{eyebrows}	\N	\N	\N
丸	まる	{}	{circle}	\N	\N	\N
丸ごと	まるごと	{}	{"in its entirety; whole; wholly"}	\N	\N	\N
丸で	まるで	{（下に否定的な意味の語を伴って）まさしくその状態であるさま。すっかり。まったく。「―だめだ」「兄弟だが―違う」}	{"〔通例，否定語を伴って，全く…ない〕⇒まったく(全く) no(not) at ALL; entirely (out of question); (don't have the) slightest (idea)"}	\N	\N	\N
丸っきり	まるっきり	{}	{"completely; perfectly; just as if"}	\N	\N	\N
末	まつ	{}	{extremity}	\N	\N	\N
的	まと	{}	{"mark; target"}	\N	\N	\N
円	まる	{}	{"circle; money"}	\N	\N	\N
丸い	まるい	{}	{"round; circular; spherical"}	\N	{円い}	\N
真似	まね	{}	{"mimicry; imitation; behavior; pretense"}	\N	{マネ}	\N
丸々	まるまる	{}	{completely}	\N	{丸丸}	\N
区々	まちまち	{}	{"several; various; divergent; conflicting; different; diverse; trivial"}	\N	{区区}	\N
祭	まつり	{}	{"festival; feast"}	\N	{祭り}	\N
丸める	まるめる	{}	{"to make round; to round off; to roll up; to curl up; to seduce; to cajole; to explain away"}	\N	\N	\N
回す	まわす	{}	{"turn; revolve"}	\N	\N	\N
周り	まわり	{}	{surroundings}	\N	\N	\N
回り	まわり	{}	{"circumference; surroundings; circulation"}	\N	\N	\N
回り道	まわりみち	{}	{"detour; diversion"}	\N	\N	\N
回る	まわる	{}	{"go round"}	\N	\N	\N
萬	まん	{}	{"10;000; ten thousand"}	\N	\N	\N
万一	まんいち	{}	{"by some chance; by some possibility; if by any chance; 10;000:1 odds"}	\N	\N	\N
満員	まんいん	{}	{"full house; no vacancy; sold out; standing room only; full (of people); crowded"}	\N	\N	\N
漫画	まんが	{}	{cartoon}	\N	\N	\N
満月	まんげつ	{}	{"full moon"}	\N	\N	\N
満場	まんじょう	{}	{"unanimous; whole audience"}	\N	\N	\N
満足	まんぞく	{心にかなって不平不満のないこと。心が満ち足りること。また、そのさま。「―な（の）ようす」「今の生活に―している」}	{"〔満ち足りること〕satisfaction; 〔不満でないこと〕content(ment); 〔自己満足〕complacency; complacence"}	\N	\N	\N
満点	まんてん	{}	{"perfect score"}	\N	\N	\N
真ん中	まんなか	{}	{"middle; center; half way"}	\N	\N	\N
万年筆	まんねんひつ	{}	{"fountain pen"}	\N	\N	\N
真ん前	まんまえ	{}	{"right in front; under the nose"}	\N	\N	\N
満喫	まんきつ	{}	{"fully enjoy"}	\N	\N	\N
真ん丸い	まんまるい	{}	{"perfectly circular"}	\N	\N	\N
目	め	{}	{"eye; eyeball"}	\N	\N	\N
芽	め	{}	{sprout}	\N	\N	\N
明確	めいかく	{}	{"clear up; clarify; define"}	\N	\N	\N
銘柄	めいがら	{}	{"brand; name; stock"}	\N	\N	\N
迷彩	めいさい	{敵の目をごまかすために、航空機・戦車・大砲・建築物・軍服などに不規則な彩色をし、他の物と区別がつきにくいようにすること。「車両に―を施す」「―服」}	{camouflage}	\N	\N	\N
名作	めいさく	{}	{masterpiece}	\N	\N	\N
名産	めいさん	{}	{"noted product"}	\N	\N	\N
名刺	めいし	{}	{"business card"}	\N	\N	\N
名詞	めいし	{}	{noun}	\N	\N	\N
名所	めいしょ	{}	{"famous place"}	\N	\N	\N
名称	めいしょう	{}	{name}	\N	\N	\N
命じる	めいじる	{}	{"to order; command; appoint"}	\N	\N	\N
迷信	めいしん	{}	{superstition}	\N	\N	\N
名人	めいじん	{}	{"master; expert"}	\N	\N	\N
命ずる	めいずる	{}	{"to command; appoint"}	\N	\N	\N
命中	めいちゅう	{}	{"a hit"}	\N	\N	\N
名物	めいぶつ	{}	{"famous product; speciality"}	\N	\N	\N
名簿	めいぼ	{}	{"register of names"}	\N	\N	\N
銘々	めいめい	{}	{"each; individual"}	\N	\N	\N
名誉	めいよ	{}	{"honor; credit; prestige"}	\N	\N	\N
明瞭	めいりょう	{}	{clarity}	\N	\N	\N
命令	めいれい	{}	{"order; command; decree; directive; (software) instruction"}	\N	\N	\N
明朗	めいろう	{}	{"bright; clear; cheerful"}	\N	\N	\N
迷惑	めいわく	{ある行為がもとで、他の人が不利益を受けたり、不快を感じたりすること。「人にーをかける」}	{"trouble; a nuisance; (an) annoyance"}	\N	\N	\N
迷惑メール	めいわくめーる	{受信者の同意を得ず、広告や勧誘などの目的で不特定多数に大量に配信される電子メール。スパムメール。スパム。ジャンクメール。}	{"junk email; spam"}	\N	\N	\N
メーンストリーム	メーンストリーム	{本流。主流。また、主傾向。}	{mainstream}	\N	\N	\N
目上	めうえ	{}	{"superior(s); senior"}	\N	\N	\N
目方	めかた	{}	{weight}	\N	\N	\N
芽キャベツ	めきゃべつ	{}	{"brussel sprouts"}	\N	\N	\N
恵まれる	めぐまれる	{}	{"be blessed with; be rich in"}	\N	\N	\N
恵み	めぐみ	{}	{blessing}	\N	\N	\N
恵む	めぐむ	{}	{"to bless; to show mercy to"}	\N	\N	\N
巡る	めぐる	{}	{"go around"}	\N	\N	\N
目指す	めざす	{}	{"aim at; have an eye on"}	\N	\N	\N
値段	ねだん	{}	{"price; cost"}	\N	\N	\N
明白	めいはく	{あきらかで疑う余地のないこと。また、そのさま。「―な証拠」}	{obvious}	\N	\N	\N
眼鏡	めがね	{}	{"spectacles; glasses"}	\N	\N	\N
目覚しい	めざましい	{}	{"brilliant; splendid; striking; remarkable"}	\N	\N	\N
目覚める	めざめる	{}	{"to wake up"}	\N	\N	\N
飯	めし	{}	{"meal(s); food"}	\N	\N	\N
召し上がる	めしあがる	{}	{"eat (polite)"}	\N	\N	\N
目下	めした	{}	{"subordinate(s); inferior(s); junior"}	\N	\N	\N
目印	めじるし	{}	{"mark; sign; landmark"}	\N	\N	\N
召す	めす	{}	{"to call; to send for; to put on; to wear; to take (a bath); to ride in; to buy; to eat; to drink; to catch (a cold)"}	\N	\N	\N
雌	めす	{}	{"female (animal)"}	\N	\N	\N
目立つ	めだつ	{}	{"be conspicuous; stand out"}	\N	\N	\N
滅茶苦茶	めちゃくちゃ	{}	{"absurd; unreasonable; excessive; messed up; spoiled; wreaked"}	\N	\N	\N
滅	めつ	{滅びること。消え失せること。消滅。}	{"destroying (of something)"}	\N	\N	\N
目付き	めつき	{}	{"look; expression of the eyes; eyes"}	\N	\N	\N
めっきり	めっきり	{状態の変化がはっきり感じられるさま。著しい。明白な}	{"remarkably; noticeably; _quite_ (a few)"}	\N	\N	\N
滅多に	めったに	{}	{"rarely (with negative verb); seldom"}	\N	\N	\N
滅亡	めつぼう	{}	{"downfall; ruin; collapse; destruction"}	\N	\N	\N
愛でたい	めでたい	{}	{auspicious}	\N	\N	\N
目に遭う	めにあう	{直接に経験する。体験する。多く、好ましくないことにいう。目を見る。「つらいー・う」「今度ばかりはひどいー・ったよ」}	{"(bad) experience"}	\N	\N	\N
目眩	めまい	{}	{"dizziness; giddiness"}	\N	\N	\N
目盛	めもり	{}	{"scale; gradations"}	\N	\N	\N
目安	めやす	{}	{"criterion; aim"}	\N	\N	\N
麺	めん	{小麦粉に水と塩などを加えた生地を細く長くしたものである。}	{noodle}	\N	\N	\N
免疫	めんえき	{}	{immunity}	\N	\N	\N
面会	めんかい	{}	{interview}	\N	\N	\N
免許	めんきょ	{}	{"license; permit; certificate"}	\N	\N	\N
免除	めんじょ	{義務・役目などを免じること。「実地試験を―する」}	{"exemption; exoneration; discharge"}	\N	\N	\N
面する	めんする	{}	{"to face on; to look out on to"}	\N	\N	\N
免税	めんぜい	{}	{"tax exemption"}	\N	\N	\N
面積	めんせき	{}	{area}	\N	\N	\N
面接	めんせつ	{}	{interview}	\N	\N	\N
面談	めんだん	{面会して直接話をすること。「来客と―する」「委細―」}	{"an interview; talk; conversation"}	\N	\N	\N
面倒	めんどう	{手間がかかったり、解決が容易でなかったりして、わずらわしいこと。また、そのさま。世話。「―な手続き」「―なことにならなければよいが」「断るのも―だ」「―を起こす」}	{"trouble; difficulty; care; attention"}	\N	\N	\N
面倒臭い	めんどうくさい	{}	{"bother to do; tiresome"}	\N	\N	\N
面目	めんぼく	{}	{"face; honour; reputation; prestige; dignity; credit"}	\N	\N	\N
魅する	みする	{不思議な力で人の心をひきつける。「歌声にー・せられる」}	{charm}	\N	\N	\N
民族	みんぞく	{言語・人種・文化・歴史的運命を共有し、同族意識によって結ばれた人々の集団}	{nationality}	\N	\N	\N
身	み	{}	{"body; main part; oneself; sword"}	\N	\N	\N
見合い	みあい	{}	{"formal marriage interview"}	\N	\N	\N
見合わせる	みあわせる	{}	{"to exchange glances; to postpone; to suspend operations; to refrain from performing an action"}	\N	\N	\N
見える	みえる	{}	{"see; can be seen"}	\N	\N	\N
見送り	みおくり	{}	{"seeing one off; farewell; escort"}	\N	\N	\N
見送る	みおくる	{}	{"see off; escort; let pass; wait and see"}	\N	\N	\N
見落とす	みおとす	{}	{"to overlook; to fail to notice"}	\N	\N	\N
見下ろす	みおろす	{}	{"overlook; command a view of"}	\N	\N	\N
未開	みかい	{}	{"savage land; backward region; uncivilized"}	\N	\N	\N
味覚	みかく	{}	{"taste; palate; sense of taste"}	\N	\N	\N
磨く	みがく	{}	{"to polish; shine; brush; refine; improve"}	\N	\N	\N
見掛け	みかけ	{}	{"outward appearance"}	\N	\N	\N
見方	みかた	{}	{viewpoint}	\N	\N	\N
熱	ねつ	{}	{"heat; fever"}	\N	\N	\N
三	み	{}	{"(num) three"}	\N	\N	\N
実	み	{}	{"fruit; nut; seed; content; good result"}	\N	\N	\N
綿	めん	{}	{"raw cotton"}	\N	\N	\N
面	めん	{}	{"face; surface; facial features; mask; side or facet; corner; page"}	\N	\N	\N
目覚し	めざまし	{}	{"alarm clock (abbreviation)"}	\N	{目覚まし,目覚}	\N
珍しい	めずらしい	{}	{"〔まれな〕rare〔変わった〕uncommon, out of the ordinary ((文)) singular〔常でない〕unusual","〔目新しい〕new; novel","〔結構な〕splendid; 〔貴重な〕precious"}	\N	\N	\N
右	みぎ	{}	{"right hand side"}	\N	\N	\N
右腕	みぎうで	{}	{"right arm"}	\N	\N	\N
右手	みぎて	{}	{"right hand"}	\N	\N	\N
見切る	みきる	{ものをすっかり見てしまう。見終わる。「広いので一日で―・るのはむずかしい」}	{"〔見限る〕give up (on); be obsolete; abandon; (文) forsake; (口) ditch"}	\N	\N	\N
見苦しい	みぐるしい	{}	{"unsightly; ugly"}	\N	\N	\N
見込み	みこみ	{}	{"hope; prospects; expectation"}	\N	\N	\N
未婚	みこん	{}	{unmarried}	\N	\N	\N
岬	みさき	{}	{"cape (on coast)"}	\N	\N	\N
短い	みじかい	{}	{short}	\N	\N	\N
惨め	みじめ	{}	{miserable}	\N	\N	\N
未熟	みじゅく	{}	{"inexperience; unripeness; raw; unskilled; immature; inexperienced"}	\N	\N	\N
微塵	みじん	{}	{"particle; atom"}	\N	\N	\N
水	みず	{}	{water}	\N	\N	\N
未遂	みすい	{"犯罪の実行に着手したが、まだ成し遂げていないこと。⇔既遂。→障害未遂 →中止未遂"}	{attempt}	\N	\N	\N
湖	みずうみ	{}	{lake}	\N	\N	\N
見すぼらしい	みすぼらしい	{}	{"shabby; seedy"}	\N	\N	\N
見せびらかす	みせびらかす	{}	{"to show off; to flaunt"}	\N	\N	\N
見せ物	みせもの	{}	{"show; exhibition"}	\N	\N	\N
店屋	みせや	{}	{"store; shop"}	\N	\N	\N
見せる	みせる	{}	{"to show; to display"}	\N	\N	\N
味噌	みそ	{}	{"miso (bean paste); key (main) point"}	\N	\N	\N
みたい	みたい	{ある事物のようすや内容が他の事物に似ている意を表す。「お寺みたいな建物」}	{"〔類似・具体例を表す〕like〔推測を表す〕look; seem"}	\N	\N	\N
みたいだ	みたいだ	{ある事物のようすや内容が他の事物に似ている意を表す。「お寺みたいな建物」}	{"〔類似・具体例を表す〕like〔推測を表す〕look; seem"}	\N	\N	\N
見出し	みだし	{}	{"heading; caption; subtitle; index"}	\N	\N	\N
満たす	みたす	{}	{"to satisfy; to ingratiate; to fill; to fulfill"}	\N	\N	\N
乱す	みだす	{}	{"to throw out of order; to disarrange; to disturb"}	\N	\N	\N
乱れる	みだれる	{}	{"to get confused; to be disordered; to be disturbed"}	\N	\N	\N
未知	みち	{}	{"not yet known"}	\N	\N	\N
道	みち	{}	{"road; street; way; method"}	\N	\N	\N
身近	みぢか	{}	{"near oneself; close to one; familiar"}	\N	\N	\N
道順	みちじゅん	{}	{"itinerary; route"}	\N	\N	\N
導く	みちびく	{}	{"to be guided; to be shown"}	\N	\N	\N
密	みつ	{}	{mystery}	\N	\N	\N
蜜	みつ	{}	{"nectar; honey"}	\N	\N	\N
三日	みっか	{}	{"three days; the third day (of the month)"}	\N	\N	\N
見付かる	みつかる	{}	{"be found; be discovered"}	\N	\N	\N
見つかる	みつかる	{}	{"be found"}	\N	\N	\N
見付ける	みつける	{}	{"discover; find fault; detect; find out; locate; be familiar"}	\N	\N	\N
見つける	みつける	{}	{"find out"}	\N	\N	\N
密集	みっしゅう	{}	{"crowd; close formation; dense"}	\N	\N	\N
密接	みっせつ	{}	{"related; connected; close; intimate"}	\N	\N	\N
三つ	みっつ	{}	{three}	\N	\N	\N
密度	みつど	{}	{density}	\N	\N	\N
見積り	みつもり	{}	{"estimation; quotation"}	\N	\N	\N
密輸	みつゆ	{法を犯してひそかに輸出入すること。「麻薬をーする」}	{smuggling}	\N	\N	\N
未定	みてい	{}	{"not yet fixed; undecided; pending"}	\N	\N	\N
見通し	みとおし	{}	{"perspective; unobstructed view; outlook; forecast; prospect; insight"}	\N	\N	\N
緑	みどり	{}	{green}	\N	\N	\N
皆	みな	{}	{"all; everything"}	\N	\N	\N
見直す	みなおす	{}	{"look again; form a better opinion of"}	\N	\N	\N
皆さん	みなさん	{}	{everyone}	\N	\N	\N
港	みなと	{}	{"seaport; harbor"}	\N	\N	\N
港町	みなとまち	{港を中心として発達した町。港のある町。}	{"a port town"}	\N	\N	\N
店	みせ	{}	{"store; shop; establishment"}	\N	\N	\N
認める	みとめる	{}	{"recognize; appreciate; approve; admit; notice"}	\N	\N	\N
水脹れ	みずぶくれ	{水をたくさん含んでふくれていること。また、そのもの。「ぶよぶよと―のようなふとり方」}	{"〔皮膚の下の〕a (water) blister"}	\N	{水膨れ}	\N
味方	みかた	{対立するものの中で、自分が属しているほう。また、自分を支持・応援してくれる人。「心強い―」⇔敵。}	{"〔友人〕a friend; 〔支持者〕a supporter; 〔同盟〕an ally"}	\N	\N	\N
満ちる	みちる	{}	{"〔あふれるばかりになる〕be filled (with); full of (water/hope/vitality)",〔満潮になる〕,〔期限になる〕expire⇒まんき(満期)}	\N	\N	\N
源	みなもと	{}	{"source; origin"}	\N	\N	\N
身なり	みなり	{}	{"personal appearance"}	\N	\N	\N
醜い	みにくい	{}	{ugly}	\N	\N	\N
峰	みね	{}	{"peak; ridge"}	\N	\N	\N
実る	みのる	{}	{"bear fruit; ripen"}	\N	\N	\N
見晴らし	みはらし	{}	{view}	\N	\N	\N
身振り	みぶり	{}	{gesture}	\N	\N	\N
身分	みぶん	{}	{"social position; social status"}	\N	\N	\N
見本	みほん	{}	{sample}	\N	\N	\N
見舞	みまい	{}	{"enquiry; expression of sympathy; expression of concern"}	\N	\N	\N
見舞い	みまい	{}	{"enquiry; expression of sympathy or concern"}	\N	\N	\N
見間違い	みまちがい	{見て他のものとまちがえること。見あやまり。見ちがい。誤認。みまちがえ。「時刻表の―をする」}	{"misjudgment; mistake in vision"}	\N	\N	\N
見守る	みまもる	{}	{"watch over"}	\N	\N	\N
未満	みまん	{}	{"less than; insufficient"}	\N	\N	\N
耳	みみ	{}	{ear}	\N	\N	\N
脈	みゃく	{}	{pulse}	\N	\N	\N
脈拍	みゃくはく	{}	{pulse}	\N	\N	\N
雅び	みやび	{上品で優美なこと。また、そのさま。風雅。優雅。「衣装にーを競う」「ーな祭事」⇔俚 (さと) び。}	{"〔優美さ〕elegance; 〔しとやかな上品さ〕grace"}	\N	\N	\N
妙	みょう	{}	{"strange; unusual"}	\N	\N	\N
名字	みょうじ	{}	{"surname; family name"}	\N	\N	\N
明星	みょうじょう	{}	{"Venus / MorningStar"}	\N	\N	\N
未来	みらい	{}	{"future tense; the future (usually distant); the world to come"}	\N	\N	\N
魅力	みりょく	{}	{"charm; fascination; glamour"}	\N	\N	\N
味醂	みりん	{}	{"wine extract"}	\N	\N	\N
見る	みる	{}	{"to see; to watch"}	\N	\N	\N
診る	みる	{診断する。「脈をみる」}	{"(medicine) examine"}	\N	\N	\N
看る	みる	{そのことに当たる。取り扱う。世話をする。「事務をみる」「子供のめんどうをみる」}	{"look after; take care of;"}	\N	\N	\N
試る	みる	{こころみる。ためす。「切れ味をみる」}	{"see (what he goes for); test"}	\N	\N	\N
観る	みる	{"観察・観光・占う・（遠くから）見物する … 実際をよくミル。"}	{"observe; see (as a tourist)"}	\N	\N	\N
視る	みる	{"正視・監視・調査 … 注意してよくミル。"}	{investigate}	\N	\N	\N
未練	みれん	{}	{"lingering affection; attachment; regret(s); reluctance"}	\N	\N	\N
見渡す	みわたす	{}	{"to look out over; to survey (scene); to take an extensive view of"}	\N	\N	\N
民営化	みんえいか	{国や地方公共団体が経営する企業・特殊法人などを民間会社や特殊会社にすること。}	{Privatization}	\N	\N	\N
民間	みんかん	{}	{"private; civilian; civil; popular; folk; unofficial"}	\N	\N	\N
民主	みんしゅ	{}	{"democratic; the head of the nation"}	\N	\N	\N
民宿	みんしゅく	{}	{"private home providing lodging for travelers"}	\N	\N	\N
民俗	みんぞく	{}	{"people; race; nation; racial customs; folk customs"}	\N	\N	\N
民族別	みんぞくべつ	{}	{ethnicity}	\N	\N	\N
民族主義	みんぞくしゅぎ	{民族の存在・独立や利益また優越性を、確保または増進しようとする思想および運動。その極端な形は国家主義とよばれる。ナショナリズム。}	{nationalism}	\N	\N	\N
民族主義者	みんぞくしゅぎしゃ	{}	{nationalist}	\N	\N	\N
民謡	みんよう	{}	{"folk song; popular song"}	\N	\N	\N
もう	もう	{現に、ある事態に立ち至っているさま。また、ある動作が終わっているさま。もはや。既に。「―手遅れだ」「―子供ではない」「今泣いた烏が―笑った」}	{"〔すでに〕already; 〔今や〕now"}	\N	\N	\N
南	みなみ	{}	{"South; proceeding south"}	\N	\N	\N
土産	みやげ	{}	{"product of the land"}	\N	\N	\N
都	みやこ	{}	{capital}	\N	\N	\N
明後日	みょうごにち	{}	{"day after tomorrow"}	\N	\N	\N
見逃す	みのがす	{見ていながら気づかないでそのままにする。見落とす。「わずかな失敗も―・さない」}	{"to miss; to overlook; to leave at large"}	\N	{見遁す}	\N
見慣れる	みなれる	{何度も見てよく知っている。「ラッシュアワーの―・れた光景」「―・れない顔」}	{"((人が主語で)) get [be] used [accustomed] to seeing; ((物が主語で)) be familiar ((to))"}	\N	{見馴れる,見なれる}	\N
申し上げる	もうしあげる	{}	{"say (polite)"}	\N	\N	\N
申し入れる	もうしいれる	{}	{"to propose; to suggest"}	\N	\N	\N
申し込み	もうしこみ	{}	{"application; entry; request; subscription; offer; proposal; overture; challenge"}	\N	\N	\N
申し込む	もうしこむ	{}	{"apply for; propose; offer; challenge; request"}	\N	\N	\N
申出	もうしで	{}	{"proposal; request; claim; report; notice"}	\N	\N	\N
申し出る	もうしでる	{}	{"to report to; to tell; to suggest; to submit; to request; to make an offer; to come forward with information"}	\N	\N	\N
申し分	もうしぶん	{}	{"objection; shortcomings"}	\N	\N	\N
申し訳	もうしわけ	{申し開き。言いわけ。弁解。「―が立つ」「―がない」「出席できず―ありません」}	{"〔弁解〕an excuse 〔わび〕an apology (複-gies)"}	\N	\N	\N
申し訳ない	もうしわけない	{言い訳のしようがない。弁解の余地がない。相手にわびるときに言う語。「世間に対し―・い気持ちで一杯だ」「不始末をしでかして―・い」}	{inexcusable}	\N	\N	\N
申す	もうす	{}	{"say (polite)"}	\N	\N	\N
妄想	もうそう	{}	{"delusion; wild idea"}	\N	\N	\N
盲点	もうてん	{}	{"blind spot"}	\N	\N	\N
盲導犬	もうどうけん	{}	{"guide dog"}	\N	\N	\N
毛布	もうふ	{}	{blanket}	\N	\N	\N
網羅	もうら	{そのことに関するすべてを残らず集めること。「必要な資料を－する」}	{cover}	\N	\N	\N
猛烈	もうれつ	{}	{"violent; vehement; rage"}	\N	\N	\N
萌黄色	もえぎいろ	{鮮やかな黄緑色系統の色。春に萌え出る草の芽をあらわす色で、英語色名の春野の緑を意味するスプリンググリーンに意味的にも色的にも近い。}	{"light green; yellowish-green"}	\N	\N	\N
燃える	もえる	{}	{"to burn"}	\N	\N	\N
藻掻く	もがく	{}	{"to struggle; to wriggle; to be impatient"}	\N	\N	\N
模擬	もぎ	{本物や実際の場合と同じようにすること。「―実験」}	{"imitation; sham; moot (court); mock"}	\N	\N	\N
捥ぎ取る	もぎとる	{もいで取る。}	{"pluck off (e.g. an apple); tear off (a dolls arm)"}	\N	\N	\N
目撃	もくげき	{現場に居合わせて実際に見ること。「交通事故を―する」}	{"〜する to witness (a happening)"}	\N	\N	\N
目撃者	もくげきしゃ	{ある事柄が起こった場所に居合わせて、それを実際に見た人。「事件の―」}	{"a witness; an eyewitness"}	\N	\N	\N
木材	もくざい	{}	{"lumber; timber; wood"}	\N	\N	\N
目次	もくじ	{}	{"table of contents"}	\N	\N	\N
黙想	もくそう	{黙って考えにふけること。黙思。「―にふける」}	{"meditation; contemplation"}	\N	\N	\N
目的	もくてき	{}	{"purpose; goal; aim; objective; intention"}	\N	\N	\N
目標	もくひょう	{}	{"mark; objective; target"}	\N	\N	\N
木曜	もくよう	{}	{Thursday}	\N	\N	\N
木曜日	もくようび	{}	{Thursday}	\N	\N	\N
目録	もくろく	{}	{"catalogue; catalog; list"}	\N	\N	\N
目論見	もくろみ	{}	{"a plan; a scheme; a project; a program; intention; goal"}	\N	\N	\N
模型	もけい	{}	{"model; dummy; maquette"}	\N	\N	\N
模索	もさく	{}	{"groping (for)"}	\N	\N	\N
若し	もし	{まだ現実になっていないことを仮に想定するさま。もしか。万一。「―彼が来たら、知らせてください」}	{"if; provided; in case (of emergency)"}	\N	\N	\N
文字	もじ	{}	{"letter (of alphabet); character"}	\N	\N	\N
若しかして	もしかして	{}	{"perhaps; possibly"}	\N	\N	\N
若しくは	もしくは	{}	{"or; otherwise"}	\N	\N	\N
若しも	もしも	{}	{if}	\N	\N	\N
喪主	もしゅ	{}	{"Chief mourner"}	\N	\N	\N
持ち	もち	{}	{"hold; charge; keep possession; in charge; wear; durability; life; draw; usage (suff)"}	\N	\N	\N
餅	もち	{}	{"sticky rice cake"}	\N	\N	\N
持ち上げる	もちあげる	{}	{"raise; lift up; flatter"}	\N	\N	\N
持ち歩く	もちあるく	{手に持ったり身に付けたりして歩く。「多額の現金をー・く」}	{"walking and carrying around"}	\N	\N	\N
持ち込む	もちこむ	{物を持って中にはいる。「車内に危険物を―・まないこと」}	{"〔運び入れる〕bring (e.g. food) in (e.g. a hotel); take into"}	\N	\N	\N
用いる	もちいる	{}	{"use; make use of"}	\N	\N	\N
持ち切り	もちきり	{}	{"hot topic; talk of the town"}	\N	\N	\N
潜る	もぐる	{}	{"drive; pass through; evade; hide; dive (into or under water); go underground"}	\N	\N	\N
勿論	もちろん	{}	{"of course; certainly; naturally"}	\N	\N	\N
以て	もって	{}	{"with; by; by means of; because; in view of"}	\N	\N	\N
最も	もっとも	{}	{"most; extremely"}	\N	\N	\N
専ら	もっぱら	{}	{"wholly; solely; entirely"}	\N	\N	\N
持て成す	もてなす	{}	{"to entertain; to make welcome"}	\N	\N	\N
持てる	もてる	{}	{"to be well liked; to be popular"}	\N	\N	\N
元	もと	{}	{"origin; original; former"}	\N	\N	\N
素	もと	{原料。材料。たね。「たれの―」「料理の―を仕込む」}	{"Raw materials; Material; Species"}	\N	\N	\N
戻す	もどす	{}	{"restore; put back; return"}	\N	\N	\N
基づく	もとづく	{}	{"be grounded on; be based on; be due to; originate from"}	\N	\N	\N
求める	もとめる	{}	{"seek; request; demand; want; wish for; search for"}	\N	\N	\N
戻る	もどる	{}	{return}	\N	\N	\N
物	もの	{}	{"thing; object"}	\N	\N	\N
者	もの	{}	{person}	\N	\N	\N
物置き	ものおき	{}	{storeroom}	\N	\N	\N
物置	ものおき	{}	{"storage room"}	\N	\N	\N
物音	ものおと	{}	{sounds}	\N	\N	\N
物語	ものがたり	{}	{"tale; story; legend"}	\N	\N	\N
物語る	ものがたる	{}	{"tell; indicate"}	\N	\N	\N
物事	ものごと	{}	{"things; everything"}	\N	\N	\N
物差し	ものさし	{}	{"ruler; measure"}	\N	\N	\N
物好き	ものずき	{}	{curiosity}	\N	\N	\N
物凄い	ものすごい	{}	{"earth-shattering; staggering; to a very great extent"}	\N	\N	\N
物足りない	ものたりない	{}	{"unsatisfied; unsatisfactory"}	\N	\N	\N
ものの	ものの	{活用語の連体形に付く。逆接の確定条件を表す。…けれども。…とはいえ。「習いはした―、すっかり忘れてしまった」「新機軸を打ち出した―、採用はされなかった」}	{nevertheless}	\N	\N	\N
物真似	ものまね	{人や動物などの身ぶり・しぐさ・声音などをまねること。また、その芸。}	{mimicry}	\N	\N	\N
模範	もはん	{}	{"exemplar; exemplification; exemplum; model; example"}	\N	\N	\N
模倣	もほう	{}	{"imitation; copying"}	\N	\N	\N
靄	もや	{}	{"a haze; a thin mist"}	\N	\N	\N
燃やす	もやす	{}	{"to burn"}	\N	\N	\N
模様	もよう	{}	{"pattern; figure; design"}	\N	\N	\N
催し	もよおし	{人を集めて興行・会合などをすること。「歓迎のーを開く」}	{"event; festivities; function; social gathering; auspices; opening; holding (a meeting)"}	\N	\N	\N
催す	もよおす	{}	{"to hold (a meeting); to give (a dinner); to feel; to show signs of; to develop symptoms of; to feel (sick)"}	\N	\N	\N
貰う	もらう	{}	{"〔物を受け取る〕get; be given〔家に迎える〕〔買う〕〔自分のものにする〕〔うつされる〕〔自分で引き受ける〕〔「…してもらう」の形で〕"}	\N	\N	\N
漏らす	もらす	{}	{"to let leak; to reveal"}	\N	\N	\N
森	もり	{}	{forest}	\N	\N	\N
盛り上がる	もりあがる	{盛ったように高くなる。「水面が―・る」「―・った筋肉」}	{"to rouse; to swell; to rise"}	\N	\N	\N
盛り込む	もりこむ	{盛って中に入れる。「重箱に料理を―・む」}	{"incorporate; include"}	\N	\N	\N
漏る	もる	{}	{"to leak; to run out"}	\N	\N	\N
漏れる	もれる	{}	{"to leak out; to escape; to come through; to shine through; to filter out; to be omitted"}	\N	\N	\N
問	もん	{}	{"problem; question"}	\N	\N	\N
文句	もんく	{}	{"phrase; complaint"}	\N	\N	\N
問題	もんだい	{}	{"problem; question"}	\N	\N	\N
問答	もんどう	{}	{"questions and answers; dialogue"}	\N	\N	\N
匁	もんめ	{}	{1mom＝3.75g}	\N	\N	\N
息子	むすこ	{}	{son}	\N	\N	\N
紅葉	もみじ	{}	{"autumn colours; (Japanese) maple"}	\N	\N	\N
盛る	もる	{物を容器に入れて満たす。「飯を茶碗に―・る」}	{"prosper; flourish; copulate (animals)"}	\N	\N	\N
木綿	もめん	{}	{cotton}	\N	\N	\N
門	もん	{}	{gate}	\N	\N	\N
基	もと	{}	{basis}	\N	\N	\N
基	もとい	{}	{basis}	\N	\N	\N
双手	もろて	{左右の手。両手。「―突き」}	{"both hands"}	\N	{諸手,両手}	\N
元々	もともと	{}	{"originally; by nature; from the start"}	\N	{元元}	\N
持つ	もつ	{手にとる。手の中ににぎる。「重たい荷物を―・つ」「右手にペンを―・つ」,長くそのままの状態を保ち続ける。もちこたえる。「夏場でも―・つ食品」「これじゃとてもからだが―・たない」}	{"〔手の中にある〕have; hold","〔持ちこたえる〕hold out","last; 〔衣類などが〕wear (well); 〔食物が〕keep"}	\N	\N	\N
無	む	{}	{"nothing; nil; zero"}	\N	\N	\N
六日	むいか	{}	{"six days; sixth (day of month)"}	\N	\N	\N
無意味	むいみ	{}	{"nonsense; no meaning"}	\N	\N	\N
向かい	むかい	{}	{"facing; opposite; across the street; other side"}	\N	\N	\N
向かう	むかう	{}	{"to face; to go towards"}	\N	\N	\N
向う	むかう	{}	{"to face; go towards"}	\N	\N	\N
迎え	むかえ	{}	{"meeting; person sent to pick up an arrival"}	\N	\N	\N
迎え入れる	むかえいれる	{来る人を迎えて中に入れる。「客間にー・れる」}	{"receive; to usher in"}	\N	\N	\N
迎える	むかえる	{}	{"meet; welcome; greet"}	\N	\N	\N
昔	むかし	{時間的にさかのぼった過去の一時期・一時点。時間の隔たりの多少は問わずに用いるが、多く、遠い過去をいう。「―の話」「―のままの姿」「とっくの―」}	{"old time; before; ago"}	\N	\N	\N
向き	むき	{}	{"direction; situation; exposure; aspect; suitability"}	\N	\N	\N
麦	むぎ	{}	{barley}	\N	\N	\N
向く	むく	{}	{"to face"}	\N	\N	\N
剥く	むく	{}	{"peel; skin; pare; hull"}	\N	\N	\N
報う	むくう	{}	{"to reward / recompensate / repay (むch くうstomers is * by having good service)"}	\N	\N	\N
無口	むくち	{}	{reticence}	\N	\N	\N
向け	むけ	{}	{"for ~; oriented towards ~"}	\N	\N	\N
無限	むげん	{}	{infinite}	\N	\N	\N
婿	むこ	{}	{son-in-law}	\N	\N	\N
無効	むこう	{}	{"invalid; no effect; unavailable"}	\N	\N	\N
無言	むごん	{}	{silence}	\N	\N	\N
虫	むし	{}	{insect}	\N	\N	\N
無視	むし	{}	{"disregard; ignore"}	\N	\N	\N
無地	むじ	{}	{"plain; unfigured"}	\N	\N	\N
蒸し暑い	むしあつい	{}	{"humid; sultry"}	\N	\N	\N
虫歯	むしば	{}	{"cavity; tooth decay; decayed tooth"}	\N	\N	\N
無邪気	むじゃき	{}	{"innocence; simple-mindedness"}	\N	\N	\N
武者修行	むしゃしゅぎょう	{武士が武芸の修行のために諸国を巡って歩くこと。}	{"a journey around the country to learn from the great masters of the martial arts; acquire greater skill (in music)"}	\N	\N	\N
矛盾	むじゅん	{}	{"contradiction; inconsistency"}	\N	\N	\N
矛盾した表現	むじゅんしたひょうげん	{}	{oxomoron}	\N	\N	\N
寧ろ	むしろ	{}	{"rather; better; instead"}	\N	\N	\N
蒸す	むす	{}	{"to steam; poultice; be sultry"}	\N	\N	\N
無数	むすう	{}	{"countless number; infinite number"}	\N	\N	\N
難しい	むずかしい	{理解や習得がしにくい。複雑でわかりにくい。難解である。「説明が―・い」「―・い文章」⇔易しい。}	{difficult}	\N	\N	\N
結び	むすび	{}	{"ending; conclusion; union"}	\N	\N	\N
結び付き	むすびつき	{}	{"connection; relation"}	\N	\N	\N
結び付く	むすびつく	{}	{"to be connected or related; to join together"}	\N	\N	\N
結び付ける	むすびつける	{}	{"to combine; to join; to tie on; to attach with a knot"}	\N	\N	\N
結ぶ	むすぶ	{"1 ひも帯などの両端をからませてつなぎ合わせる。2 他人と関係をもつ。約束をする。「条約をーぶ」「靴のひもをーぶ」「ネクタイをーぶ」"}	{"tie; bind; link"}	\N	\N	\N
娘	むすめ	{}	{daughter}	\N	\N	\N
無制限	むせいげん	{制限がないこと。制限しないこと。また、そのさま。「―な人間の欲望」「人員を―に増やす」}	{"infinity (stage); 〜の unrestricted; unlimited"}	\N	\N	\N
無線	むせん	{}	{"wireless; radio"}	\N	\N	\N
無駄遣い	むだづかい	{}	{"waste money on; squander money on; flog a dead horse"}	\N	\N	\N
無断	むだん	{}	{"without permission; without notice"}	\N	\N	\N
無知	むち	{}	{ignorance}	\N	\N	\N
無茶	むちゃ	{}	{"absurd; unreasonable; excessive; rash; absurdity; nonsense"}	\N	\N	\N
無茶苦茶	むちゃくちゃ	{}	{"confused; jumbled; mixed up; unreasonable"}	\N	\N	\N
夢中	むちゅう	{}	{"daze; (in a) trance; ecstasy; delirium; engrossment"}	\N	\N	\N
六つ	むっつ	{}	{six}	\N	\N	\N
無敵	むてき	{非常に強くて敵対するものがないこと。対抗できるものがないこと。また、そのさま。「―な（の）猛将」「天下―」}	{"invincible; unrivaled; can not be matched"}	\N	\N	\N
空しい	むなしい	{}	{"vacant; futile; vain; void; empty; ineffective; lifeless"}	\N	\N	\N
胸	むね	{}	{"breast; chest"}	\N	\N	\N
無念	むねん	{}	{"chagrin; regret"}	\N	\N	\N
六	む	{}	{"(num) six"}	\N	\N	\N
向こう	むこう	{}	{"beyond; opposite direction; the other party","over there"}	\N	\N	\N
向ける	むける	{その方向に正面が位置するようにする。ある方向を向かせる。「視線を―・ける」「背を―・ける」「マイクを―・ける」「怒りを他人に―・ける」}	{"〔向かせる〕turn towards; point (your gun); head (for)"}	\N	\N	\N
無能	むのう	{}	{"inefficiency; incompetence"}	\N	\N	\N
謀反	むほん	{時の為政者に反逆すること。国家・朝廷・君主にそむいて兵を挙げること。律の八虐の規定では国家に対する反逆をいい、「謀叛」の字を用い、謀反 (むへん) 、謀大逆 (ぼうたいぎゃく) に次いで3番目の重罪とされる。}	{rebellion}	\N	\N	\N
無闇に	むやみに	{}	{"unreasonably; absurdly; recklessly; indiscreetly; at random"}	\N	\N	\N
無用	むよう	{}	{"useless; futility; needlessness; unnecessariness"}	\N	\N	\N
村	むら	{}	{village}	\N	\N	\N
群がる	むらがる	{}	{"to swarm; to gather"}	\N	\N	\N
紫	むらさき	{}	{"purple; violet (color)"}	\N	\N	\N
無料	むりょう	{}	{"free; no charge"}	\N	\N	\N
群れ	むれ	{}	{"group; crowd; flock; herd; bevy; school; swarm; cluster (of stars); clump"}	\N	\N	\N
無論	むろん	{}	{"of course; naturally"}	\N	\N	\N
名	な	{}	{"name; reputation"}	\N	\N	\N
内科	ないか	{}	{"internist clinic; internal medicine"}	\N	\N	\N
内閣	ないかく	{カビネット}	{cabinet}	\N	\N	\N
乃至	ないし	{}	{"from...to; between...and; or"}	\N	\N	\N
内線	ないせん	{}	{"phone extension; indoor wiring; inner line"}	\N	\N	\N
内臓	ないぞう	{}	{"internal organs; intestines; viscera"}	\N	\N	\N
内部	ないぶ	{}	{"interior; inside; internal"}	\N	\N	\N
内容	ないよう	{}	{"subject; contents; matter; substance; detail; import"}	\N	\N	\N
内乱	ないらん	{}	{"civil war; insurrection; rebellion; domestic conflict"}	\N	\N	\N
内陸	ないりく	{}	{inland}	\N	\N	\N
苗	なえ	{種から芽を出して間のない草や木。定植前の草木。}	{"rice seedling"}	\N	\N	\N
尚	なお	{}	{"furthermore; still; yet; more; still more; greater; further; less"}	\N	\N	\N
尚更	なおさら	{}	{"all the more; still less"}	\N	\N	\N
直す	なおす	{}	{repair}	\N	\N	\N
治す	なおす	{}	{"cure; heal; fix; correct; repair"}	\N	\N	\N
直る	なおる	{}	{"be repaired"}	\N	\N	\N
治る	なおる	{}	{"get well"}	\N	\N	\N
仲	なか	{}	{"relation; relationship"}	\N	\N	\N
永い	ながい	{}	{"long; lengthy"}	\N	\N	\N
長い	ながい	{}	{long}	\N	\N	\N
流し	ながし	{}	{sink}	\N	\N	\N
仲直り	なかなおり	{}	{"reconciliation; make peace with"}	\N	\N	\N
長々	ながなが	{}	{"long; drawn-out; very long"}	\N	\N	\N
長引く	ながびく	{}	{"be prolonged; drag on"}	\N	\N	\N
中程	なかほど	{}	{"middle; midway"}	\N	\N	\N
仲間	なかま	{}	{"company; fellow; colleague; associate; comrade; mate; group; circle of friends; partner"}	\N	\N	\N
眺め	ながめ	{}	{"scene; view; prospect; outlook"}	\N	\N	\N
仲良し	なかよし	{}	{"intimate friend; close friend"}	\N	\N	\N
ながら	ながら	{二つの動作・状態が並行して行われる意を表す。「ラジオを聞きー勉強する」}	{"as; while; although"}	\N	\N	\N
流れる	ながれる	{}	{"stream; flow; be washed away; run (ink)"}	\N	\N	\N
亡き後	なきあと	{}	{"after the passing"}	\N	\N	\N
泣く	なく	{}	{cry}	\N	\N	\N
鳴く	なく	{}	{"bark; purr; chirp; make sound (animal)"}	\N	\N	\N
慰める	なぐさめる	{}	{"comfort; console; amuse"}	\N	\N	\N
亡くす	なくす	{死なれて失う。死なせる。亡くする。「一人息子を―・す」}	{"lose something or someone; get rid of"}	\N	\N	\N
無くす	なくす	{今まであったもの、持っていたものを失う。無くする。「財布を―・す」「やる気を―・す」}	{lose}	\N	\N	\N
亡くなる	なくなる	{}	{die}	\N	\N	\N
無くなる	なくなる	{}	{"be lost"}	\N	\N	\N
殴る	なぐる	{相手を乱暴に強く打つ。乱暴に物事をする。「ー・る蹴るの暴行」}	{"to strike; to hit"}	\N	\N	\N
嘆かわしい	なげかわしい	{}	{"sad; wretched"}	\N	\N	\N
中指	なかゆび	{}	{"middle finger"}	\N	\N	\N
中身	なかみ	{}	{"contents; interior; substance; filling; (sword) blade"}	\N	{中味}	\N
中々	なかなか	{}	{"very; considerably; easily; readily; by no means (neg); fairly; quite; highly; rather"}	\N	{中中}	\N
流す	ながす	{"1 液体が流れるようにする。「トイレの水を―・す」「シャワーで汗を―・す」",物を動かして移らせる。「ムード音楽を―・す」「情報を―・す」}	{"drain; float; shed (blood; tears)","〔広める〕spread (a rumor); broadcast"}	\N	\N	\N
無理	むり	{実現するのが難しいこと。行い難いこと。また、そのさま。「―を承知で、引き受ける」「―な要求をする」}	{"〔不可能〕too much; impossible"}	\N	\N	\N
嘆く	なげく	{}	{"to sigh; to lament; to grieve"}	\N	\N	\N
投げ出す	なげだす	{}	{"to throw down; to abandon; to sacrifice; to throw out"}	\N	\N	\N
投げる	なげる	{}	{throw}	\N	\N	\N
和やか	なごやか	{}	{"mild; calm; gentle; quiet; harmonious"}	\N	\N	\N
名残	なごり	{}	{"remains; traces; memory"}	\N	\N	\N
情け	なさけ	{}	{"sympathy; compassion"}	\N	\N	\N
情け深い	なさけぶかい	{}	{"tender-hearted; compassionate"}	\N	\N	\N
為さる	なさる	{}	{"to do"}	\N	\N	\N
無し	なし	{}	{without}	\N	\N	\N
詰る	なじる	{}	{"to rebuke; to scold; to tell off"}	\N	\N	\N
為す	なす	{}	{"accomplish; do"}	\N	\N	\N
何故	なぜ	{}	{"why; how"}	\N	\N	\N
謎	なぞ	{}	{"riddle; puzzle; enigma"}	\N	\N	\N
名高い	なだかい	{}	{"famous; celebrated; well-known"}	\N	\N	\N
菜種油	なたねあぶら	{}	{"rape seed oil"}	\N	\N	\N
傾らか	なだらか	{}	{"gently-sloping; gentle; easy"}	\N	\N	\N
雪崩	なだれ	{}	{avalanche}	\N	\N	\N
夏	なつ	{}	{summer}	\N	\N	\N
納豆	なっとう	{"よく蒸した大豆に納豆菌を加え、適温の中で発酵させた食品。粘って糸を引くので糸引き納豆ともいい、関東以北でよく用いる。《季 冬》「ーの糸引張って遊びけり／一茶」"}	{"fermented soybeans"}	\N	\N	\N
懐かしい	なつかしい	{}	{"dear; desired; missed"}	\N	\N	\N
懐く	なつく	{}	{"to become emotionally attached"}	\N	\N	\N
名付ける	なづける	{}	{"to name (someone)"}	\N	\N	\N
夏休み	なつやすみ	{}	{"summer vacation; summer holiday"}	\N	\N	\N
七歳	ななさい	{}	{"7-years old"}	\N	\N	\N
七つ	ななつ	{}	{seven}	\N	\N	\N
斜め	ななめ	{}	{obliqueness}	\N	\N	\N
何	なに	{}	{what}	\N	\N	\N
何か	なにか	{}	{something}	\N	\N	\N
何気ない	なにげない	{}	{"casual; unconcerned"}	\N	\N	\N
何しろ	なにしろ	{}	{"at any rate; anyhow; anyway; in any case"}	\N	\N	\N
何卒	なにとぞ	{}	{please}	\N	\N	\N
何分	なにぶん	{}	{"anyway; please"}	\N	\N	\N
何も	なにも	{}	{nothing}	\N	\N	\N
何やら	なにやら	{実体がはっきりわからないさま。なにかしら。「ー物音がする」}	{"somewhat; some; something of a"}	\N	\N	\N
名札	なふだ	{}	{"name plate; name tag"}	\N	\N	\N
鍋	なべ	{}	{"saucepan; pot"}	\N	\N	\N
生意気	なまいき	{}	{"impertinent; saucy; cheeky; conceit; audacious; brazen"}	\N	\N	\N
名前	なまえ	{}	{name}	\N	\N	\N
怠ける	なまける	{}	{"be idle; neglect"}	\N	\N	\N
生茶	なまちゃ	{}	{"raw tea"}	\N	\N	\N
生温い	なまぬるい	{}	{"lukewarm; halfhearted"}	\N	\N	\N
生身	なまみ	{}	{"living flesh; flesh and blood; the quick"}	\N	\N	\N
鉛	なまり	{}	{"lead (the metal)"}	\N	\N	\N
鈍る	なまる	{}	{"to become less capable; to grow dull; to become blunt; to weaken"}	\N	\N	\N
波	なみ	{}	{wave}	\N	\N	\N
浪	なみ	{風や震動によって起こる海や川の水面の高低運動。波浪。「ーが寄せてくる」「ーが砕ける」「逆巻くー」}	{waves}	\N	\N	\N
並み	なみ	{}	{"average; medium; common; ordinary"}	\N	\N	\N
並木	なみき	{}	{"roadside tree; row of trees"}	\N	\N	\N
滑らか	なめらか	{}	{"smoothness; glassiness"}	\N	\N	\N
悩ましい	なやましい	{}	{"seductive; melancholy; languid"}	\N	\N	\N
悩ます	なやます	{}	{"to afflict; to torment; to harass; to molest"}	\N	\N	\N
悩み	なやみ	{}	{"trouble(s); worry; distress; anguish; agony; problem"}	\N	\N	\N
悩む	なやむ	{}	{"be worried; be troubled"}	\N	\N	\N
七日	なのか	{}	{"seven days; the seventh day (of the month)"}	\N	\N	\N
等	など	{一例を挙げ、あるいは、いくつか並べたものを総括して示し、それに限らず、ほかにも同種類のものがあるという意を表す。...なんか。「赤や黄―の落ち葉」「寒くなったのでこたつを出し―する」}	{"〔同類〕and so on; and [or] the like; 〔その他〕etc.〔たとえば...など〕such as; for example"}	\N	\N	\N
何より	なにより	{抜きんでていること。それよりほかにないこと。副詞的にも用いる。「お目にかかれて―うれしい」「ここにいるのが―の証拠」,最上・最良であること。「贈り物として―の品」「お元気で―です」}	{"most (decisive evidence)",best}	\N	\N	\N
涙	なみだ	{}	{tear}	\N	{涕}	\N
納得	なっとく	{他人の考えや行動などを十分に理解して得心すること。得心。合点。「―のいかない話」「説明を聞いて―する」}	{"（同意）assent; consent（理解・了解）understanding"}	{名,スル}	\N	\N
なら	なら	{}	{"Attach 「＿」 to the context in which the conditional would occur; [Assumed Context] + ＿ + [Result]; You must not attach the declarative 「だ」."}	\N	\N	\N
習う	ならう	{}	{learn}	\N	\N	\N
倣う	ならう	{}	{"imitate; follow; emulate"}	\N	\N	\N
慣らす	ならす	{}	{"to accustom"}	\N	\N	\N
鳴らす	ならす	{}	{"ring; sound; chime; beat"}	\N	\N	\N
ならでは	ならでは	{ただ＿だけ。「日本―の習慣だ」}	{"only (he is capable); (eat) only (in Japan)"}	\N	\N	\N
並びに	ならびに	{}	{and}	\N	\N	\N
並ぶ	ならぶ	{}	{"line up; stand in a line"}	\N	\N	\N
並べる	ならべる	{}	{"line up; set up"}	\N	\N	\N
成り立つ	なりたつ	{}	{"to conclude; to consist of; to be practical (logical feasible viable); to hold true"}	\N	\N	\N
並び替え	ならびかえ	{}	{sort}	\N	\N	\N
成る	なる	{}	{become}	\N	\N	\N
生る	なる	{}	{"bear fruit"}	\N	\N	\N
鳴る	なる	{}	{"sound; ring"}	\N	\N	\N
成る丈	なるたけ	{}	{"as much as possible; if possible"}	\N	\N	\N
成るべく	なるべく	{}	{"as much as possible"}	\N	\N	\N
成程	なるほど	{他人の言葉を受け入れて、自分も同意見であることを示す。たしかに。まことに。「ーそれはいい」}	{"indeed; really"}	\N	\N	\N
慣れ	なれ	{}	{"practice; experience"}	\N	\N	\N
慣れる	なれる	{}	{"get used to"}	\N	\N	\N
縄	なわ	{}	{"rope; hemp"}	\N	\N	\N
難	なん	{}	{"difficulty; hardships; defect"}	\N	\N	\N
難易度	なんいど	{}	{difficulty}	\N	\N	\N
南極	なんきょく	{}	{"south pole; Antarctic"}	\N	\N	\N
南京豆	なんきんまめ	{マメ科の一年草。茎は横にはい、葉は二対の小葉からなる複葉で、互生する。}	{peanut.}	\N	\N	\N
何だか	なんだか	{}	{"a little; somewhat; somehow"}	\N	\N	\N
何て	なんて	{驚いたり、あきれたり、感心したりする気持ちを表す。なんという。->何と「ーだらしないんだ」「ーすばらしい絵だ」}	{"how...!; what...!"}	\N	\N	\N
何で	なんで	{}	{"Why? What for?"}	\N	\N	\N
何と	なんと	{どんなふうに。どのように。驚いたり、あきれたり、感心したりする気持ちを表す。}	{"what; how; whatever"}	\N	\N	\N
何となく	なんとなく	{}	{"somehow or other; for some reason or another"}	\N	\N	\N
何とも	なんとも	{}	{"nothing (with neg. verb); quite; not a bit"}	\N	\N	\N
何度	なんど	{どれほどの回数。また、多くの回数。何回。「―やってもできない」「―でも挑戦するつもりだ」}	{"〔回数を尋ねて〕how many times; how often〔度数を尋ねて〕how many degrees"}	\N	\N	\N
何度も	なんども	{}	{"any number of times"}	\N	\N	\N
南西	なんせい	{}	{south-west}	\N	\N	\N
何なり	なんなり	{}	{"any; anything; whatever"}	\N	\N	\N
南蛮	なんばん	{}	{"spanish pirates; barbarian"}	\N	\N	\N
南米	なんべい	{}	{"South America"}	\N	\N	\N
南北	なんぼく	{}	{"south and north"}	\N	\N	\N
妬む	ねたむ	{他人が自分よりすぐれている状態をうらやましく思って憎む。ねたましく思う。そねむ。}	{"to be jealous/envious"}	\N	\N	\N
熱心	ねっしん	{ある物事に深く心を打ち込むこと。}	{"eagerness; enthusiasm; 〜な eager (about)/ enthusiastic (about); 〜に enthusiastically/ eagerly/ zealously;"}	\N	\N	\N
狙い	ねらい	{弓や鉄砲などで、目標に当てようとねらうこと。}	{aim}	\N	\N	\N
年度	ねんど	{暦年とは別に、事務などの便宜のために区分した1年の期間。}	{"year; school year"}	\N	\N	\N
根	ね	{}	{root}	\N	\N	\N
値打ち	ねうち	{}	{"value; worth; price; dignity"}	\N	\N	\N
願い	ねがい	{}	{"desire; wish; request; prayer; petition; application"}	\N	\N	\N
願う	ねがう	{}	{"to desire; wish; request; beg; hope; implore"}	\N	\N	\N
寝かせる	ねかせる	{}	{"to put to bed; to lay down; to ferment"}	\N	\N	\N
猫背	ねこぜ	{首をやや前に出し、背を丸めた姿勢。また、そのようなからだつき。}	{"stoop (hunched posture)"}	\N	\N	\N
捻子	ねじ	{}	{"screw; helix; spiral"}	\N	\N	\N
ねじ回し	ねじまわし	{}	{screwdriver}	\N	\N	\N
捻じれる	ねじれる	{}	{"to twist; to wrench; to screw"}	\N	\N	\N
強請る	ねだる	{}	{"to tease; to coax; to solicit; to demand"}	\N	\N	\N
音	ね	{}	{"sound; note"}	\N	\N	\N
値	ね	{}	{"value; price; cost; worth; merit; (computer programming) variable"}	\N	\N	\N
何とか	なんとか	{}	{"〔どうにか〕somehow; one way or another","〔なんでもよいからなにか〕(do) something; (give) sOme (advice)","〔名前をはっきり言わないとき〕Mr. so-n-so; (his name's Kimura) something"}	\N	\N	\N
熱意	ねつい	{}	{"zeal; enthusiasm"}	\N	\N	\N
熱狂	ねっきょう	{非常に興奮し熱中すること「ファンがライブに―する」}	{excitement}	\N	\N	\N
熱血	ねっけつ	{}	{hot-blooded}	\N	\N	\N
熱する	ねっする	{}	{"to heat"}	\N	\N	\N
熱帯	ねったい	{}	{tropics}	\N	\N	\N
熱中	ねっちゅう	{}	{"enthusiasm; zeal; mania"}	\N	\N	\N
熱湯	ねっとう	{}	{"boiling water"}	\N	\N	\N
熱量	ねつりょう	{}	{temperature}	\N	\N	\N
寝床	ねどこ	{寝るための床。寝るために敷かれた敷物・布団など。「―に入る」}	{"〔ベッド〕a bed; 〔汽車・汽船などの〕a berth"}	\N	\N	\N
粘り	ねばり	{}	{"stickyness; viscosity"}	\N	\N	\N
粘る	ねばる	{}	{"to be sticky; to be adhesive; to persevere; to persist; to stick to"}	\N	\N	\N
値引き	ねびき	{}	{"price reduction; discount"}	\N	\N	\N
寝坊	ねぼう	{}	{"sleeping in late"}	\N	\N	\N
寝巻	ねまき	{}	{"sleep-wear; nightclothes; pyjamas; nightgown; nightdress"}	\N	\N	\N
根回し	ねまわし	{}	{"making necessary arrangements"}	\N	\N	\N
眠い	ねむい	{}	{sleepy}	\N	\N	\N
眠たい	ねむたい	{}	{sleepy}	\N	\N	\N
眠る	ねむる	{}	{sleep}	\N	\N	\N
狙う	ねらう	{}	{"to aim at"}	\N	\N	\N
寝る	ねる	{}	{"go to bed; lie down; sleep"}	\N	\N	\N
練る	ねる	{}	{"to knead; to work over; to polish up"}	\N	\N	\N
寝技	ねわざ	{柔道やレスリングで、からだを倒した姿勢で掛ける技。「―にもち込む」⇔立ち技。}	{"〔柔道で〕groundwork techniques〔レスリングで〕pinning techniques"}	\N	\N	\N
念	ねん	{}	{"sense; idea; thought; feeling; desire; concern; attention; care"}	\N	\N	\N
念入り	ねんいり	{}	{polite}	\N	\N	\N
年鑑	ねんかん	{}	{yearbook}	\N	\N	\N
年間	ねんかん	{}	{"year (interval of time)"}	\N	\N	\N
年号	ねんごう	{}	{"name of an era; year number"}	\N	\N	\N
懇ろ	ねんごろ	{}	{"friendly; kind; intimate"}	\N	\N	\N
年中	ねんじゅう	{}	{"whole year; always; everyday"}	\N	\N	\N
燃焼	ねんしょう	{}	{"burning; combustion"}	\N	\N	\N
年生	ねんせい	{}	{"pupil in .... year; student in .... year"}	\N	\N	\N
年代	ねんだい	{}	{"age; era; period; date"}	\N	\N	\N
年長	ねんちょう	{}	{seniority}	\N	\N	\N
粘土	ねんど	{}	{clay}	\N	\N	\N
年俸	ねんぽう	{1年を単位として定めた俸給。また、1年分の俸給。年給。「―制で契約する」}	{"annual salary"}	\N	\N	\N
燃料	ねんりょう	{}	{fuel}	\N	\N	\N
年輪	ねんりん	{}	{"annual tree ring"}	\N	\N	\N
年齢	ねんれい	{}	{"age; years"}	\N	\N	\N
二	に	{}	{two}	\N	\N	\N
荷	に	{}	{"load; baggage; cargo"}	\N	\N	\N
似合う	にあう	{}	{"suit; match; become; be like"}	\N	\N	\N
煮える	にえる	{}	{"boil; cook; be cooked"}	\N	\N	\N
匂い	におい	{}	{"odour; scent; smell; stench; fragrance; aroma; perfume"}	\N	\N	\N
匂う	におう	{}	{"be fragrant; smell; to stink; glow; be bright"}	\N	\N	\N
苦い	にがい	{}	{bitter}	\N	\N	\N
逃がす	にがす	{}	{"let loose; set free; let escape"}	\N	\N	\N
二月	にがつ	{}	{February}	\N	\N	\N
苦手	にがて	{}	{"poor (at); weak (in); dislike (of)"}	\N	\N	\N
荼	にがな	{}	{"weed: Too many flowers and weeds will start to appear."}	\N	\N	\N
似通う	にかよう	{}	{"to resemble closely"}	\N	\N	\N
面皰	にきび	{}	{"pimple; acne"}	\N	\N	\N
握る	にぎる	{}	{"grasp; seize; mould (sushi)"}	\N	\N	\N
肉	にく	{}	{meat}	\N	\N	\N
憎い	にくい	{}	{"hateful; abominable; poor-looking; detestable; (with irony) lovely; lovable; wonderful"}	\N	\N	\N
憎しみ	にくしみ	{}	{hatred}	\N	\N	\N
肉親	にくしん	{}	{"blood relationship; blood relative"}	\N	\N	\N
肉体	にくたい	{}	{"the body; the flesh"}	\N	\N	\N
憎む	にくむ	{}	{"hate; detest"}	\N	\N	\N
憎らしい	にくらしい	{}	{"odious; hateful"}	\N	\N	\N
逃げ出す	にげだす	{}	{"to run away; to escape from"}	\N	\N	\N
逃げる	にげる	{}	{"run away"}	\N	\N	\N
二軒	けん	{}	{"two flats"}	\N	\N	\N
濁る	にごる	{}	{"become muddy or impure"}	\N	\N	\N
西	にし	{}	{west}	\N	\N	\N
虹	にじ	{}	{rainbow}	\N	\N	\N
人形	にんぎょう	{}	{doll}	\N	\N	\N
年月	ねんげつ	{}	{"months and years"}	\N	\N	\N
にしても	にしても	{...であることを考えても。...する場合でも。とはいえ。...でも「負けるー最善を尽くせ」}	{"even so; even though; even if"}	\N	\N	\N
西日	にしび	{}	{"westering sun"}	\N	\N	\N
日時	にちじ	{}	{"date and time"}	\N	\N	\N
日常	にちじょう	{}	{"ordinary; regular; everyday; usual"}	\N	\N	\N
日没	にちぼつ	{太陽の上端が地平線下に沈むこと。また、その時刻。日の入り。⇔日出 (にっしゅつ) 。}	{"((at)) sunset; ((at)) sundown"}	\N	\N	\N
日没時	にちぼつじ	{日の入りの時刻。太陽の上端が地平線に隠れて見えなくなる瞬間の時刻をいう。}	{"time of sunset"}	\N	\N	\N
日夜	にちや	{}	{"day and night; always"}	\N	\N	\N
日曜日	にちようび	{}	{Sunday}	\N	\N	\N
日用品	にちようひん	{}	{"daily necessities"}	\N	\N	\N
日蓮	にちれん	{［1222～1282］鎌倉時代の僧。日蓮宗の開祖。安房 (あわ) の人。12歳で清澄寺に入り天台宗などを学び、出家して蓮長と称した。比叡山などで修学ののち、建長5年（1253）「南無妙法蓮華経」の題目を唱え、法華経の信仰を説いた。辻説法で他宗を攻撃したため圧迫を受け、「立正安国論」の筆禍で伊豆の伊東に配流。許されたのちも他宗への攻撃は激しく、佐渡に流され、赦免後、身延山に隠栖。武蔵の池上で入寂。著「開目鈔」「観心本尊鈔」など。勅諡号 (ちょくしごう) は立正大師。}	{nichiren}	\N	\N	\N
日蓮宗	にちれんしゅう	{仏教の一宗派。鎌倉時代に日蓮が開いた。法華経を所依 (しょえ) とし、南無妙法蓮華経の題目を唱える実践を重んじ、折伏 (しゃくぶく) ・摂受 (しょうじゅ) の二門を立て、現実における仏国土建設をめざす。のち、分派を形成。法華宗。}	{"the Nichiren sect of Buddhism"}	\N	\N	\N
に就いて	について	{ある事柄に関して、その範囲をそれと限定する。「右の問題―解答せよ」「日時―は後日連絡する」}	{"about; regarding"}	\N	\N	\N
について	に就いて	{ある事柄に関して、その範囲をそれと限定する。「右の問題―解答せよ」「日時―は後日連絡する」}	{"about; regarding"}	\N	\N	\N
日課	にっか	{}	{"daily lesson; daily work; daily routine"}	\N	\N	\N
日記	にっき	{}	{diary}	\N	\N	\N
荷造り	にづくり	{}	{"packing; baling; crating"}	\N	\N	\N
二個	にこ	{}	{"2 pieces (articles)"}	\N	\N	\N
日光	にっこう	{}	{sunlight}	\N	\N	\N
日出	にっしゅつ	{太陽の上端が地平線上に現れること。また、その時刻。ひので。「―時」⇔日没。}	{sunrise}	\N	\N	\N
日中	にっちゅう	{}	{"daytime; during the day; Sino-Japanese"}	\N	\N	\N
日程	にってい	{}	{agenda}	\N	\N	\N
日当	にっとう	{}	{"daily allowance"}	\N	\N	\N
担う	になう	{}	{"to carry on shoulder; to bear (burden); to shoulder (gun)"}	\N	\N	\N
二年間	にねんかん	{}	{"two-year period"}	\N	\N	\N
日本製	にほんせい	{}	{"japan made/manifactured"}	\N	\N	\N
二枚貝	にまいがい	{}	{"[musslor]; Bivalvia; mussles"}	\N	\N	\N
にも拘らず	にもかかわらず	{}	{"in spite of; nevertheless"}	\N	\N	\N
荷物	にもつ	{}	{"baggage; luggage"}	\N	\N	\N
煮物	にもの	{材料に調味した汁を加えて煮ること。また、煮たもの。}	{"〔料理すること〕cooking; 〔煮た食物〕food boiled and seasoned"}	\N	\N	\N
入院	にゅういん	{}	{"enter hospital"}	\N	\N	\N
入学	にゅうがく	{}	{"enter a school"}	\N	\N	\N
入社	にゅうしゃ	{}	{"entry to a company"}	\N	\N	\N
入手	にゅうしゅ	{}	{"obtaining; coming to hand"}	\N	\N	\N
入賞	にゅうしょう	{}	{"winning a prize or place (in a contest)"}	\N	\N	\N
入場	にゅうじょう	{}	{"entrance; admission; entering"}	\N	\N	\N
入門	にゅうもん	{学問・技芸などを学びはじめること。「パソコンの―書」}	{"beginner; under tutorship; pupil; disciple"}	\N	\N	\N
入浴	にゅうよく	{}	{"bathe; bathing"}	\N	\N	\N
入力	にゅうりょく	{コンピューターで、処理させる情報を入れること。インプット。「パソコンにデータを―する」⇔出力。}	{"〔コンピュータの〕input〔電気の〕power input"}	\N	\N	\N
尿	にょう	{}	{urine}	\N	\N	\N
によって	によって	{原因・理由を表す。..ので。..ために。「踏切事故ー電車が遅れる」}	{"depending on (school year (sales) (changes))"}	\N	\N	\N
似る	にる	{}	{"look like"}	\N	\N	\N
煮る	にる	{}	{"boil; cook"}	\N	\N	\N
庭	にわ	{}	{garden}	\N	\N	\N
任意	にんい	{自由意志にまかせること。「ーに選ぶ」}	{"optional; voluntary"}	\N	\N	\N
人気	にんき	{}	{"popular; business conditions; popular feeling"}	\N	\N	\N
任侠	にんきょう	{}	{"chivalrous spirit; heroism"}	\N	\N	\N
日	にち	{}	{"Japan-; Japanese-"}	\N	\N	\N
人間	にんげん	{ひと。人類。「―の歴史」}	{"human being; man; person"}	\N	\N	\N
認識	にんしき	{}	{"recognition; cognizance"}	\N	\N	\N
忍者	にんじゃ	{}	{"a ninja; a Japanese secret agent in feudal times (with almost magical powers of stealth and concealment)"}	\N	\N	\N
認証	にんしょう	{}	{authorization}	\N	\N	\N
人情	にんじょう	{}	{"humanity; empathy; kindness; sympathy; human nature; common sense; customs and manners"}	\N	\N	\N
忍耐	にんたい	{苦難などをこらえること。辛抱。我慢。「―のいる仕事」「食糧の不足を―する」}	{"〔耐え忍ぶこと〕patience; 〔耐久力〕endurance; 〔ねばり強さ〕perseverance"}	\N	\N	\N
忍耐力	にんたいりょく	{つらいことや苦しみなどをたえしのぶ力。辛抱する力。がまん強さ}	{"perserverance; fortitude; staying power"}	\N	\N	\N
妊婦	にんぷ	{}	{"pregnant woman"}	\N	\N	\N
任命	にんめい	{}	{"appointment; nomination; ordination; commission; designation"}	\N	\N	\N
任務	にんむ	{ミッション}	{"mission; task"}	\N	\N	\N
之	の	{}	{of}	\N	\N	\N
野	の	{}	{field}	\N	\N	\N
脳	のう	{}	{"brain; memory"}	\N	\N	\N
能	のう	{}	{"talent; gift; function; Noh play"}	\N	\N	\N
農家	のうか	{}	{"farmer; farm family"}	\N	\N	\N
農業	のうぎょう	{}	{agriculture}	\N	\N	\N
農耕	のうこう	{}	{"farming; agriculture"}	\N	\N	\N
納采	のうさい	{結納 (ゆいのう) をとりかわすこと。現在では皇族の場合にだけいう。「―の儀」}	{"part of some ritual?"}	\N	\N	\N
農産物	のうさんぶつ	{}	{"agricultural produce"}	\N	\N	\N
農場	のうじょう	{}	{"farm (agriculture)"}	\N	\N	\N
農村	のうそん	{}	{"agricultural community; farm village; rural"}	\N	\N	\N
農地	のうち	{}	{"agricultural land"}	\N	\N	\N
濃度	のうど	{}	{"concentration; brightness"}	\N	\N	\N
納入	のうにゅう	{}	{"payment; supply"}	\N	\N	\N
農民	のうみん	{}	{"farmers; peasants"}	\N	\N	\N
農薬	のうやく	{}	{"agricultural chemicals"}	\N	\N	\N
能率	のうりつ	{}	{efficiency}	\N	\N	\N
能力	のうりょく	{物事を成し遂げることのできる力。「―を備える」「―を発揮する」「予知―」}	{"ability; faculty"}	\N	\N	\N
逃す	のがす	{}	{"to let loose; to set free; to let escape"}	\N	\N	\N
逃れる	のがれる	{}	{"to escape"}	\N	\N	\N
軒	のき	{}	{"eaves; house"}	\N	\N	\N
軒並み	のきなみ	{}	{"row of houses"}	\N	\N	\N
残す	のこす	{}	{"leave (behind; over); bequeath; save; reserve"}	\N	\N	\N
残らず	のこらず	{}	{"all; entirely; completely; without exception"}	\N	\N	\N
残り	のこり	{}	{"remnant; residue; remaining; left-over"}	\N	\N	\N
残る	のこる	{}	{remain}	\N	\N	\N
除く	のぞく	{}	{"remove; exclude"}	\N	\N	\N
望ましい	のぞましい	{}	{"desirable; hoped for"}	\N	\N	\N
望み	のぞみ	{}	{"wish; desire; hope"}	\N	\N	\N
臨む	のぞむ	{向かい対する}	{"to look out on; to face; to deal with; to attend (function)"}	\N	\N	\N
野垂れ死にする	のたれしにする	{"die a dog's death"}	{"die a dog's death"}	\N	\N	\N
乗っ取る	のっとる	{}	{"to capture; to occupy; to usurp"}	\N	\N	\N
ので	ので	{活用語の連体形に付く。あとの叙述の原因・理由・根拠・動機などを表す。「辛い物を食べた―、のどが渇いた」「朝が早かった―、ついうとうとする」「盆地な―、夏は暑い」}	{"（接続助詞）because of; owing to; on account of; as; since; because; so... that"}	\N	\N	\N
喉	のど	{}	{throat}	\N	\N	\N
長閑	のどか	{}	{"tranquil; calm; quiet"}	\N	\N	\N
のに	のに	{活用語の連体形に付く。不平・不満・恨み・非難などの気持ちを表す。「これで幸せになれると思った―」「いいかげんにすればいい―」}	{"〔…と反対に〕though; although; in spite of〔…と比べ〕while; when"}	\N	\N	\N
罵る	ののしる	{}	{"to speak ill of; to abuse"}	\N	\N	\N
押し入れ	おしいれ	{}	{closet}	\N	\N	\N
後	のち	{}	{"afterwards; since then; in the future"}	\N	\N	\N
載せる	のせる	{}	{"to place on (something); to take on board; to give a ride; to let (one) take part; to impose on; to record; to mention; to load (luggage); to publish; to run (an ad)"}	\N	{乗せる}	\N
妊娠	にんしん	{}	{"pregnancy〔受胎〕conception 〜する become pregnant; 〔医学，または文〕conceive"}	{名,スル}	\N	\N
延びる	のびる	{}	{"to be prolonged"}	\N	\N	\N
伸びる	のびる	{}	{"to stretch; to extend; to make progress; to grow (beard body height); to grow stale (soba); to lengthen; to spread; to be postponed; to be straightened; to be flattened; to be smoothed; to be exhausted"}	\N	\N	\N
延べ	のべ	{}	{"futures; credit (buying); stretching; total"}	\N	\N	\N
述べる	のべる	{}	{"state; express; mention"}	\N	\N	\N
上り	のぼり	{}	{"ascent; climbing; up-train (i.e. going to Tokyo)"}	\N	\N	\N
昇る	のぼる	{}	{"to arise; to ascend; to go up"}	\N	\N	\N
上る	のぼる	{}	{"to rise; to ascend; to be promoted; to go up; to climb; to go to (the capital); to add up to; to advance (in price); to sail up; to come up (on the agenda)"}	\N	\N	\N
登る	のぼる	{}	{climb}	\N	\N	\N
飲み込む	のみこむ	{}	{"to gulp down; to swallow deeply; to understand; to take in; to catch on to; to learn; to digest"}	\N	\N	\N
飲み物	のみもの	{}	{"drink; beverage"}	\N	\N	\N
飲む	のむ	{}	{"to drink"}	\N	\N	\N
乗り換え	のりかえ	{}	{"transfer (trains buses etc.)"}	\N	\N	\N
乗換	のりかえ	{}	{"transfer (trains; buses; etc.)"}	\N	\N	\N
乗り換える	のりかえる	{乗っていた乗り物を降りて、別の乗り物に乗る。乗り物をかえる。「各駅停車から急行に―・える」}	{transfer}	\N	\N	\N
乗り物	のりもの	{}	{"vehicle; vessel"}	\N	\N	\N
載る	のる	{}	{"get on; ride in; board; mount; get up on; be taken in; share in; join; be found in (a dictionary); feel like doing; be mentioned in; be in harmony with; appear (in print); be recorded"}	\N	\N	\N
乗る	のる	{}	{"get on; get up on; ride in; be taken in; share in; join; feel like doing; be mentioned in; be in harmony with"}	\N	\N	\N
呑気	のんき	{}	{"carefree; optimistic; careless; reckless; heedless; happy-go-lucky; easygoing"}	\N	\N	\N
抜く	ぬく	{攻め落とす。}	{"take out; take down"}	\N	\N	\N
縫う	ぬう	{}	{sew}	\N	\N	\N
抜かす	ぬかす	{}	{"to omit; to leave out"}	\N	\N	\N
脱ぐ	ぬぐ	{}	{"take off clothes"}	\N	\N	\N
抜け出す	ぬけだす	{}	{"to slip out; to sneak away; to excel"}	\N	\N	\N
抜ける	ぬける	{}	{"come out; fall out; be omitted; be missing; escape"}	\N	\N	\N
盗み	ぬすみ	{}	{stealing}	\N	\N	\N
盗む	ぬすむ	{}	{steal}	\N	\N	\N
布	ぬの	{}	{cloth}	\N	\N	\N
沼	ぬま	{}	{"swamp; bog; pond; lake"}	\N	\N	\N
塗る	ぬる	{}	{paint}	\N	\N	\N
温い	ぬるい	{}	{"lukewarm; tepid"}	\N	\N	\N
尾	お	{}	{"tail; ridge"}	\N	\N	\N
甥	おい	{自分の兄弟・姉妹が生んだ男の子。}	{nephew}	\N	\N	\N
追い掛ける	おいかける	{}	{"pursue; chase"}	\N	\N	\N
追い越す	おいこす	{}	{"to pass (e.g. car); outdistance"}	\N	\N	\N
追い込む	おいこむ	{}	{"to herd; to corner; to drive"}	\N	\N	\N
美味しい	おいしい	{}	{delicious}	\N	\N	\N
追い焚き	おいだき	{}	{reheating}	\N	\N	\N
追い出す	おいだす	{}	{"to expel; to drive out"}	\N	\N	\N
追い付く	おいつく	{}	{"overtake; catch up (with)"}	\N	\N	\N
お出でになる	おいでになる	{}	{"to be"}	\N	\N	\N
老いる	おいる	{}	{"to age; to grow old"}	\N	\N	\N
お祝い	おいわい	{}	{celebration}	\N	\N	\N
負う	おう	{}	{"to bear; to owe"}	\N	\N	\N
王	おう	{}	{king}	\N	\N	\N
追う	おう	{}	{chase}	\N	\N	\N
応援	おうえん	{}	{"aid; assistance; help; reinforcement; support; cheering"}	\N	\N	\N
鈍い	のろい	{}	{"dull (e.g. a knife); thickheaded; slow; stupid"}	\N	\N	\N
御	お	{}	{"honorific prefix"}	\N	\N	\N
主	ぬし	{}	{"〔主人〕a master〔持ち主〕〔古くから住み着いたもの，特に霊〕"}	\N	\N	\N
呪い	のろい	{のろうこと。呪詛 (じゅそ) 。「―をかける」「―をとく」}	{"a curse; (break) a spell; (place) a curse (on a person)"}	\N	{詛い}	\N
伸ばす	のばす	{}	{"to lengthen; to stretch; to reach out; to postpone; to prolong; to extend; to grow (beard)"}	\N	{延ばす}	\N
縫い包み	ぬいぐるみ	{}	{"stuffed (e.g. doll)"}	\N	{縫いぐるみ}	\N
乗り込む	のりこむ	{"1 乗り物に乗ってその中へはいる。「車で現地に―・む」","2 敵の領分などに、勇んで入り込む。「大挙して談判に―・む」"}	{"（車に）get into; get in; （電車に）get onto; get on; （船舶・航空機に）go on board; board","〔勢いよく入り込む〕(people) pour into (the town); march into (enemy territory)"}	\N	{乗込む}	\N
応急	おうきゅう	{}	{emergency}	\N	\N	\N
王国	おうこく	{}	{kingdom}	\N	\N	\N
黄金	おうごん	{}	{gold}	\N	\N	\N
王様	おうさま	{}	{king}	\N	\N	\N
王子	おうじ	{}	{prince}	\N	\N	\N
王女	おうじょ	{}	{princess}	\N	\N	\N
欧州	おうしゅう	{}	{europe}	\N	\N	\N
応ずる	おうずる	{}	{"answer; respond; meet; satisfy; accept"}	\N	\N	\N
応接	おうせつ	{}	{reception}	\N	\N	\N
応対	おうたい	{}	{"receiving; dealing with"}	\N	\N	\N
横断	おうだん	{}	{crossing}	\N	\N	\N
応答	おうとう	{}	{"reply; comply (compatible)"}	\N	\N	\N
往復	おうふく	{}	{"round trip; coming and going; return ticket"}	\N	\N	\N
欧米	おうべい	{}	{"Europe and America; the West"}	\N	\N	\N
応募	おうぼ	{}	{"subscription; application"}	\N	\N	\N
応用	おうよう	{}	{"application; put to practical use"}	\N	\N	\N
終える	おえる	{}	{"to finish"}	\N	\N	\N
多い	おおい	{}	{"have a lot of"}	\N	\N	\N
大いに	おおいに	{}	{"very; much; greatly"}	\N	\N	\N
覆う	おおう	{}	{"cover; hide; conceal; wrap; disguise"}	\N	\N	\N
大方	おおかた	{}	{"perhaps; almost all; majority"}	\N	\N	\N
大型	おおがた	{物事の内容・規模、また、人物などが他のものより大きいこと。また、そのさま。「―の台風」「―の新人」「―バス」⇔小型。}	{"large; large-sized"}	\N	\N	\N
大柄	おおがら	{}	{"large build; large pattern"}	\N	\N	\N
大きい	おおきい	{}	{"big; large; great"}	\N	\N	\N
大きな	おおきな	{}	{"big; large"}	\N	\N	\N
大げさ	おおげさ	{}	{"grandiose; exaggerated"}	\N	\N	\N
大ざっぱ	おおざっぱ	{}	{"rough (as in not precise); broad; sketchy"}	\N	\N	\N
大筋	おおすじ	{}	{"outline; summary"}	\N	\N	\N
大空	おおぞら	{}	{"heaven; firmament; the sky"}	\N	\N	\N
大通り	おおどおり	{}	{"main street"}	\N	\N	\N
大幅	おおはば	{普通より幅の広いこと。また、そのさま。⇔小幅。}	{"full width; large scale; drastic"}	\N	\N	\N
大水	おおみず	{}	{flood}	\N	\N	\N
大晦日	おおみそか	{1年の最終の日。12月31日。おおつごもり。}	{"the last day of the year; 〔その晩〕New Year's Eve"}	\N	\N	\N
大家	おおや	{}	{"landlord; landlady"}	\N	\N	\N
公	おおやけ	{}	{"official; public; formal; open; governmental"}	\N	\N	\N
大凡	おおよそ	{}	{"about; roughly; approximately; as a rule"}	\N	\N	\N
お母さん	おかあさん	{}	{"(polite) mother"}	\N	\N	\N
お帰り	おかえり	{　帰る人を敬って、その帰ることをいう語。「―にお寄りください」}	{"〔旅行や外国から帰った人に〕Welcome home [back]!"}	\N	\N	\N
お蔭様で	おかげさまで	{}	{"Thanks to god; thanks to you"}	\N	\N	\N
お菓子	おかし	{}	{"confections; sweets; candy"}	\N	\N	\N
可笑しい	おかしい	{}	{"strange; funny; amusing; ridiculous"}	\N	\N	\N
侵す	おかす	{}	{"to invade; to raid; to trespass; to violate; to intrude on"}	\N	\N	\N
犯す	おかす	{}	{"to commit; to perpetrate; to violate; to rape"}	\N	\N	\N
お菜	おかず	{}	{"side dish; accompaniment for rice dishes"}	\N	\N	\N
拝む	おがむ	{}	{"worship; beg"}	\N	\N	\N
お代わり	おかわり	{}	{"second helping; another cup"}	\N	\N	\N
沖	おき	{}	{"open sea"}	\N	\N	\N
置き換える	おきかえる	{物をどかして他の物をそのあとに置く。「床の間の置物を生け花にー・える」「ここはもう少し的確な表現にー・えたい」}	{"〔置く場所を変える〕change the location ((of))，change [shift; move]((a thing from A to B)); 〔配列し直す〕rearrange〔他の物と取り替える〕replace ((A with B)); substitute ((B for A))"}	\N	\N	\N
置き去り	おきざり	{あとに残したまま、行ってしまうこと。置き捨て。「子供をーにする」「絶海の孤島にーにされる」}	{"leave; 〔見捨てる〕desert ((one's family))"}	\N	\N	\N
黄色	おうしょく	{}	{yellow}	\N	\N	\N
大事	おおごと	{}	{"important; valuable; serious matter"}	\N	\N	\N
丘	おか	{}	{hill}	\N	{岡}	\N
大勢	おおぜい	{多くの人。多人数。副詞的にも用いる。多勢。大人数。「―の出席者」「―で見学する」⇔小勢 (こぜい) 。}	{"many; a great number (of people)"}	\N	\N	\N
御金	おかね	{貨幣。金銭。また、財産。「―持ち」}	{money}	\N	{お金}	\N
起き攻め	おきぜめ	{}	{"wake-up attack"}	\N	\N	\N
お気遣いなく	おきづかいなく	{気をつかわないように相手に丁寧に述べる表現。気遣い無用。}	{"no worries!"}	\N	\N	\N
翁	おきな	{}	{"an old man"}	\N	\N	\N
補う	おぎなう	{}	{"compensate for"}	\N	\N	\N
起きる	おきる	{}	{"get up; rise"}	\N	\N	\N
奥	おく	{}	{interior}	\N	\N	\N
億	おく	{}	{"a hundred million"}	\N	\N	\N
屋外	おくがい	{}	{outdoors}	\N	\N	\N
奥さん	おくさん	{}	{"(polite) wife; your wife; his wife; married lady; madam"}	\N	\N	\N
屋上	おくじょう	{}	{"the roof top"}	\N	\N	\N
臆病	おくびょう	{}	{"cowardice; timidity"}	\N	\N	\N
遅らす	おくらす	{}	{"to retard; to delay"}	\N	\N	\N
送り仮名	おくりがな	{}	{"kana written after a kanji to complete the full (usually kun) reading of the word"}	\N	\N	\N
贈り物	おくりもの	{}	{gift}	\N	\N	\N
贈る	おくる	{}	{"send; give to; award to; confer on"}	\N	\N	\N
送る	おくる	{}	{"send (a thing); take or escort (a person somewhere); see off (a person); spend a period of time; live a life"}	\N	\N	\N
遅れ	おくれ	{}	{"delay; lag"}	\N	\N	\N
遅れる	おくれる	{}	{"to be late"}	\N	\N	\N
於ける	おける	{作用・動作の行われる場所・時間を表す。…の中の。…での。…にあっての。「日本にー生活」「過去にー経験」}	{"in (a field); within (a country)"}	\N	\N	\N
起す	おこす	{}	{"raise; cause; wake someone"}	\N	\N	\N
厳か	おごそか	{}	{"austere; majestic; dignified; stately; awful; impressive"}	\N	\N	\N
怠る	おこたる	{すべきことをしないでおく。なまける。また、気をゆるめる。油断する。無視する。「学業を―・る」「注意を―・る」}	{"neglect; be off guard; be feeling better"}	\N	\N	\N
行い	おこない	{}	{"deed; conduct; behavior; action; asceticism"}	\N	\N	\N
行う	おこなう	{物事をする。なす。やる。実施する。「儀式を―・う」「合同演習を―・う」「四月五日に入学式が―・われる」}	{"to perform; to do; to conduct oneself; to carry out"}	\N	\N	\N
起こる	おこる	{今までなかったものが新たに生じる。おきる。「静電気が―・る」「さざ波が―・る」}	{"occur; happen"}	\N	\N	\N
長	おさ	{}	{"chief; head"}	\N	\N	\N
押さえる	おさえる	{}	{"to stop; to restrain; to seize; to repress; to suppress; to press down"}	\N	\N	\N
押える	おさえる	{}	{"stop; restrain; seize; repress; suppress; press down"}	\N	\N	\N
抑える	おさえる	{感情・欲望などが高ぶるのをとどめる。抑制する。スポーツで、相手の勢いをとどめる。}	{"surpress; restrain; control"}	\N	\N	\N
お先に	おさきに	{}	{"before; ahead; previously"}	\N	\N	\N
お酒	おさけ	{}	{"(polite) wine; sake"}	\N	\N	\N
幼い	おさない	{年齢が若い。幼少である。いとけない。「息子はまだー・い」}	{"very young; childish"}	\N	\N	\N
治まる	おさまる	{}	{"to be at peace; to clamp down; to lessen (storm terror anger)"}	\N	\N	\N
治める	おさめる	{}	{"govern; manage; subdue"}	\N	\N	\N
お皿	おさら	{}	{"(polite) dish; plate"}	\N	\N	\N
お産	おさん	{}	{"(giving) birth"}	\N	\N	\N
叔父	おじ	{}	{"uncle (younger than one´s parent)"}	\N	\N	\N
惜しい	おしい	{}	{"regrettable; disappointing; precious"}	\N	\N	\N
お祖父さん	おじいさん	{}	{"grandfather; male senior-citizen"}	\N	\N	\N
怒る	おこる	{}	{"get angry"}	\N	\N	\N
収める	おさめる	{}	{"to obtain; to reap; to pay; to supply; to accept"}	\N	{納める}	\N
収まる	おさまる	{}	{"to be obtained; to end; to settle into; to fit into; to be settled; to be paid; to be delivered"}	\N	{納まる}	\N
御客様	おきゃくさま	{}	{"venerable mr guest"}	\N	{お客様}	\N
押上げ	おしあげ	{}	{push-up}	\N	{押し上げ,押しあげ}	\N
置く	おく	{人や物をある位置・場所にとどめる。そこに位置させる。「要所に見張りを―・く」「手をひざに―・く」,今後の用意のために、あらかじめ…する。「話だけは聞いて―・こう」「この程度のことは勉強して―・くべきだ」「名前は仮にAとして―・こう」}	{"〔物を据える〕put; place","do something in advance for future convenience"}	\N	\N	\N
教え	おしえ	{}	{"teachings; precept; lesson; doctrine"}	\N	\N	\N
教える	おしえる	{}	{"teach; inform; instruct"}	\N	\N	\N
押し固める	おしかためる	{}	{"to press together"}	\N	\N	\N
御辞儀	おじぎ	{}	{bow}	\N	\N	\N
押し込む	おしこむ	{}	{"to push into; to crowd into"}	\N	\N	\N
惜しむ	おしむ	{}	{"to be frugal; to value; to regret"}	\N	\N	\N
お邪魔します	おじゃまします	{}	{"Excuse me for disturbing (interrupting) you"}	\N	\N	\N
お嬢さん	おじょうさん	{}	{"daughter (polite)"}	\N	\N	\N
押し寄せる	おしよせる	{}	{"to push aside; to advance on"}	\N	\N	\N
雄	おす	{}	{"male (animal)"}	\N	\N	\N
押す	おす	{}	{"push; press; stamp (e.g. a passport)"}	\N	\N	\N
お薦め	おすすめ	{}	{recommendation}	\N	\N	\N
汚染	おせん	{}	{"pollution; contamination"}	\N	\N	\N
遅い	おそい	{}	{"late; slow"}	\N	\N	\N
襲う	おそう	{}	{"to attack"}	\N	\N	\N
遅くとも	おそくとも	{}	{"at the latest"}	\N	\N	\N
恐るべき	おそるべき	{恐れなければならない。恐れるのが当然の。ひどく恐ろしい「ー自然破壊」}	{"terrifying; terrible; dreadful"}	\N	\N	\N
恐れ	おそれ	{}	{"fear; horror"}	\N	\N	\N
虞	おそれ	{よくないことが起こるかもしれないという心配。懸念。「自殺の―がある」}	{"〔懸念〕fear ((of))，apprehension ((about)); 〔危険〕danger"}	\N	\N	\N
恐れ入る	おそれいる	{}	{"to be filled with awe; to feel small; to be amazed; to be surprised; to be disconcerted; to be sorry; to be grateful; to be defeated; to confess guilt"}	\N	\N	\N
恐ろしい	おそろしい	{}	{"terrible; dreadful"}	\N	\N	\N
教わる	おそわる	{}	{"be taught"}	\N	\N	\N
お互い	おたがい	{相対する関係にある二者。双方、または、そのひとつひとつ。「お互い」の形でも用いる。「―の意思を尊重する」「―が譲り合う」}	{"mutual; reciprocal; each other"}	\N	\N	\N
お宅	おたく	{}	{"your house (polite)"}	\N	\N	\N
汚濁	おだく	{}	{"pollution; dirty; corruption. bribery"}	\N	\N	\N
お玉	おたま	{}	{ladle}	\N	\N	\N
穏やか	おだやか	{}	{"calm; gentle; quiet"}	\N	\N	\N
落ち込む	おちこむ	{}	{"to fall into; to feel down (sad)"}	\N	\N	\N
落ち着き	おちつき	{}	{"calm; composure"}	\N	\N	\N
陥る	おちいる	{望ましくない状態になる。よくない状態になる}	{"fall into (critical position/predicament);"}	\N	\N	\N
落ち葉	おちば	{}	{"fallen leaves; leaf litter; defoliation; shedding leaves"}	\N	\N	\N
落ちる	おちる	{}	{"fall; drop; come down"}	\N	\N	\N
乙	おつ	{}	{"strange; quaint; stylish; chic; spicy; queer; witty; tasty; romantic; 2nd in rank; second sign of the Chinese calendar"}	\N	\N	\N
お使い	おつかい	{}	{errand}	\N	\N	\N
御疲れ様	おつかれさま	{相手の労苦をねぎらう意で用いる言葉。また、職場で、先に帰る人へのあいさつにも使う。「ご苦労様」は目上の人から目下の人に使うのに対し、「お疲れ様」は同僚、目上の人に対して使う。}	{"Cheers for good work"}	\N	\N	\N
仰っしゃる	おっしゃる	{}	{"to say; to speak; to tell; to talk"}	\N	\N	\N
追っ手	おって	{逃げていく者をつかまえるために追いかける人}	{pursuer}	\N	\N	\N
夫	おっと	{}	{"(humble) (my) husband"}	\N	\N	\N
お手上げ	おてあげ	{}	{"all over; given in; given up hope; bring to knees"}	\N	\N	\N
お手洗い	おてあらい	{}	{"toilet; restroom; lavatory; bathroom (US)"}	\N	\N	\N
御手数	おてすう	{}	{trouble}	\N	\N	\N
お手伝いさん	おてつだいさん	{}	{maid}	\N	\N	\N
お手並み拝見	おてなみはいけん	{相手の腕前や能力がどれくらいあるか拝見しよう。腕前を見せる}	{"showing of skill"}	\N	\N	\N
音	おと	{}	{sound}	\N	\N	\N
小父さん	おじさん	{}	{"middle-aged gentleman; uncle"}	\N	{伯父さん}	\N
御茶	おちゃ	{}	{tea}	\N	{お茶}	\N
お出掛け	おでかけ	{}	{"about to start out; just about to leave or go out"}	\N	{お出かけ}	\N
お世辞	おせじ	{}	{"flattery; compliment"}	\N	{御世辞}	\N
恐らく	おそらく	{}	{"probably; perhaps; maybe; possibly; （残念ながら…だ）I'm afraid ..."}	\N	\N	\N
落着く	おちつく	{}	{"calm down; settle in; be steady"}	\N	{落ち着く}	\N
お洒落	おしゃれ	{}	{"smartly dressed; someone smartly dressed; fashion-conscious"}	\N	{オシャレ}	\N
御大事に	おだいじに	{相手の体をいたわる心持ちを表すあいさつの言葉。「どうぞ、―」}	{"Take care of yourself"}	\N	{お大事に}	\N
お父さん	おとうさん	{}	{"(polite) father"}	\N	\N	\N
弟神	おとうとがみ	{}	{"younger god brother"}	\N	\N	\N
男	おとこ	{}	{man}	\N	\N	\N
男の子	おとこのこ	{}	{boy}	\N	\N	\N
男の人	おとこのひと	{}	{man}	\N	\N	\N
落し物	おとしもの	{}	{"lost property"}	\N	\N	\N
落とす	おとす	{}	{"drop; let fall"}	\N	\N	\N
訪れる	おとずれる	{}	{"to visit"}	\N	\N	\N
大人	おとな	{}	{adult}	\N	\N	\N
お供	おとも	{}	{"attendant; companion"}	\N	\N	\N
踊り	おどり	{}	{dancing}	\N	\N	\N
踊り狂う	おどりくるう	{夢中になって激しく踊る。「若者たちが―・う」}	{"dance like mad [like crazy／in a frenzy] (all night long)"}	\N	\N	\N
劣る	おとる	{}	{"fall behind; be inferior to"}	\N	\N	\N
踊る	おどる	{}	{"to dance"}	\N	\N	\N
衰える	おとろえる	{}	{"to become weak; to decline; to wear; to abate; to decay; to wither; to waste away"}	\N	\N	\N
驚かす	おどろかす	{}	{"surprise; frighten; create a stir"}	\N	\N	\N
驚き	おどろき	{}	{"surprise; astonishment; wonder"}	\N	\N	\N
驚く	おどろく	{}	{"to surprise"}	\N	\N	\N
同い年	おないどし	{}	{"of the same age"}	\N	\N	\N
お腹	おなか	{}	{stomach}	\N	\N	\N
同じ	おなじ	{同様。一緒}	{same}	\N	\N	\N
同じ穴のムジナ	おなじあなのもじな	{普通、悪事を働く同類の意味で使われる}	{"fellow rule-breaker (badger of the same hole)"}	\N	\N	\N
鬼	おに	{}	{"ogre; demon"}	\N	\N	\N
お兄さん	おにいさん	{}	{"(polite) older brother; (vocative) 'Mister?'"}	\N	\N	\N
お姉さん	おねえさん	{}	{"(polite) older sister; (vocative) 'Miss?'"}	\N	\N	\N
お願いします	おねがいします	{}	{please}	\N	\N	\N
自ずから	おのずから	{}	{"naturally; as a matter of course"}	\N	\N	\N
己	おのれ	{}	{yourself}	\N	\N	\N
叔母	おば	{}	{aunt}	\N	\N	\N
お祖母さん	おばあさん	{}	{"grandmother; female senior-citizen"}	\N	\N	\N
お化け	おばけ	{}	{ghost}	\N	\N	\N
伯母さん	おばさん	{}	{aunt}	\N	\N	\N
お早う	おはよう	{}	{"Good morning"}	\N	\N	\N
帯	おび	{}	{"kimono sash"}	\N	\N	\N
お昼	おひる	{}	{"lunch; noon"}	\N	\N	\N
帯びる	おびる	{}	{"to wear; to carry; to be entrusted; to have; to take on; to have a trace of; to be tinged with"}	\N	\N	\N
お弁当	おべんとう	{}	{"lunch box"}	\N	\N	\N
覚え	おぼえ	{}	{"memory; sense; experience"}	\N	\N	\N
憶える	おぼえる	{見聞きした事柄を心にとどめる。記憶する。「子供のころのことはー・えていない」}	{"learn; remember; bear ((a thing)) in mind; memorize"}	\N	\N	\N
溺れる	おぼれる	{}	{"be drowned; indulge in"}	\N	\N	\N
お参り	おまいり	{}	{"worship; shrine visit"}	\N	\N	\N
御負け	おまけ	{}	{"a discount; a prize; something additional; bonus; an extra; an exaggeration"}	\N	\N	\N
お巡りさん	おまわりさん	{}	{"policeman (friendly term)"}	\N	\N	\N
お見舞い	おみまい	{}	{"asking after (a person´s health)"}	\N	\N	\N
お宮	おみや	{}	{"Shinto shrine"}	\N	\N	\N
お土産	おみやげ	{}	{souvenir}	\N	\N	\N
弟	おと	{}	{"younger brother"}	\N	\N	\N
弟	おとうと	{}	{"younger brother; faithful service to those older; brotherly affection"}	\N	\N	\N
一昨日	おととい	{}	{"day before yesterday"}	\N	\N	\N
一昨年	おととし	{}	{"year before last"}	\N	\N	\N
御任せ	おまかせ	{物事の判断や処理などを他人に任せること。特に、料理屋で料理の内容を店に一任すること。「―コース」「荷造りからすべて―でやってくれる引っ越しサービス」}	{"rely; leave it up to (e.g. the chef; washing machine)"}	\N	{お任せ}	\N
御祭	おまつり	{}	{festival}	\N	{御祭り,お祭り,お祭}	\N
脅す	おどす	{相手を恐れさせる。脅迫する。おどかす。}	{threaten}	\N	{威す,嚇す}	\N
脅かす	おどかす	{"1 怖がらせる。脅迫する。おどす。「有り金全部置いていけと―・す」",びっくりさせる。驚かす。「隠れていて―・してやろう」}	{"（怖がらせる）terrify; threaten","〔びっくりさせる〕startle; frighten"}	\N	{嚇かす,威かす}	\N
汚名	おめい	{}	{"stigma; dishonour; dishonor; infamy"}	\N	\N	\N
お目出度う	おめでとう	{}	{"(ateji) (int) (uk) Congratulations!; an auspicious occasion!"}	\N	\N	\N
お目に掛かる	おめにかかる	{}	{"to see or meet someone"}	\N	\N	\N
重い	おもい	{}	{"heavy; massive; serious; important; severe; oppressed"}	\N	\N	\N
思い掛けない	おもいがけない	{}	{"unexpected; casual"}	\N	\N	\N
思い込む	おもいこむ	{}	{"be under impression that; be convinced that; imagine that; set one´s heart on; be bent on"}	\N	\N	\N
思い切り	おもいきり	{あきらめ。満足できるまでするさま。思う存分。「―遊びたい」「―がいい」}	{"〔思う存分〕to one's heart's content; 〔力一杯〕to the best of one's ability; with all one's might"}	\N	\N	\N
思い出す	おもいだす	{}	{"recall; remember"}	\N	\N	\N
思い付き	おもいつき	{}	{"plan; idea; suggestion"}	\N	\N	\N
思い出	おもいで	{}	{"memories; recollections; reminiscence"}	\N	\N	\N
思う	おもう	{ある物事について考えをもつ。考える。}	{think}	\N	\N	\N
想う	おもう	{眼前にない物事について、心を働かせる。想像する。「―・ったほどおもしろくない」「夢にも―・わなかった」}	{"think; conceptulize; make up ideas"}	\N	\N	\N
憶う	おもう	{}	{"think; remember; recollect"}	\N	\N	\N
念う	おもう	{願う。希望する。「―・うようにいかない」「背が高くなりたいと―・う」}	{"think; wish; feel; disire"}	\N	\N	\N
思う存分	おもうぞんぶん	{満足がいくまで。思いきり。「―（に）遊びたい」「―の働き」}	{"all (I) want; as hard as one (can); (eat) to one's fill; (cry one) heart out"}	\N	\N	\N
面白い	おもしろい	{}	{"interesting; amusing"}	\N	\N	\N
重たい	おもたい	{}	{"heavy; massive; serious; important; severe; oppressed"}	\N	\N	\N
玩具	おもちゃ	{}	{"〔子供の〕a toy; a plaything"}	\N	\N	\N
主な	おもな	{}	{"main; leading"}	\N	\N	\N
主に	おもに	{}	{"mainly; primarily"}	\N	\N	\N
趣	おもむき	{}	{"meaning; tenor; gist; effect; appearance; taste; grace; charm; refinement"}	\N	\N	\N
赴く	おもむく	{}	{"to go; to proceed; to repair to; to become"}	\N	\N	\N
思わず	おもわず	{そのつもりではないのに。考えもなく。無意識に。気が付かずに。本能的に}	{"unintentionally; spontanuously"}	\N	\N	\N
重んじる	おもんじる	{}	{"to respect; to honor; to esteem; to prize"}	\N	\N	\N
重んずる	おもんずる	{}	{"to honor; to respect; to esteem; to prize"}	\N	\N	\N
親	おや	{}	{parents}	\N	\N	\N
おやおや	おやおや	{意外なことに対して、軽く驚いたり、失望したり、あきれたりしたときに発する語。「―、おかしいぞ」}	{"〔困って〕uh-oh; oh no; oh dear"}	\N	\N	\N
お休み	おやすみ	{}	{"holiday; absence; rest; Good night"}	\N	\N	\N
親父	おやじ	{}	{father}	\N	\N	\N
お八	おやつ	{}	{"(uk) between meal snack; afternoon refreshment; afternoon tea; mid-day snack"}	\N	\N	\N
親指	おやゆび	{}	{thumb}	\N	\N	\N
泳ぎ	およぎ	{}	{swimming}	\N	\N	\N
泳ぐ	およぐ	{}	{swim}	\N	\N	\N
凡そ	およそ	{}	{"about; roughly; as a rule; approximately"}	\N	\N	\N
及び	および	{}	{"and; as well as"}	\N	\N	\N
及ぶ	およぶ	{}	{"to reach; to come up to; to amount to; to befall; to happen to; to extend; to match; to equal"}	\N	\N	\N
及ぼす	およぼす	{}	{"exert; cause; exercise"}	\N	\N	\N
織	おり	{}	{"weave; weaving; woven item"}	\N	\N	\N
折り合い	おりあい	{譲り合って解決すること。妥協・折衷「大筋でのーがつく」}	{compromise}	\N	\N	\N
折り返す	おりかえす	{}	{"to turn up; to fold back"}	\N	\N	\N
折紙	おりがみ	{紙を折って種々の物の形を作る遊び。また、それに使う紙。ふつう、正方形の色紙 (いろがみ) を使う。}	{origami}	\N	\N	\N
織物	おりもの	{}	{"textile; fabric"}	\N	\N	\N
下りる	おりる	{}	{"come down"}	\N	\N	\N
折る	おる	{}	{"break; fold; pick (flower)"}	\N	\N	\N
織る	おる	{}	{"to weave"}	\N	\N	\N
俺	おれ	{}	{"I (ego) (boastful first-person pronoun)"}	\N	\N	\N
面	おも	{}	{face}	\N	\N	\N
表	おもて	{}	{"the front"}	\N	\N	\N
重なる	おもなる	{}	{"main; principal; important"}	\N	\N	\N
重役	おもやく	{}	{"heavy responsibilities; director"}	\N	\N	\N
思い付く	おもいつく	{ある考えがふと心に浮かぶ。考えつく。「いいアイデアを―・く」}	{"to think up (an idea); think of; hit upon; come into one´s mind"}	\N	{思いつく}	\N
お礼	おれい	{}	{courtesy}	\N	\N	\N
折れる	おれる	{}	{"break; snap"}	\N	\N	\N
愚か	おろか	{頭の働きが鈍いさま。考えが足りないさま。}	{"foolish; silly; stupid"}	\N	\N	\N
愚かしい	おろかしい	{愚かである。ばかげている。「―・い行為」}	{"foolish; stupid"}	\N	\N	\N
愚かしさ	おろかしさ	{}	{"foolishness; stupidity"}	\N	\N	\N
卸売り	おろしうり	{生産者や輸入業者から大量の商品を仕入れ、小売商に売り渡すこと。また、その業種や業者。}	{wholesale}	\N	\N	\N
下す	おろす	{}	{"take down; launch; drop; lower; let (a person) off; unload; discharge"}	\N	\N	\N
降ろす	おろす	{}	{"to take down; to launch; to drop; to lower; to let (a person) off; to unload; to discharge"}	\N	\N	\N
卸す	おろす	{}	{"sell wholesale; grated (vegetables)"}	\N	\N	\N
疎か	おろそか	{}	{"neglect; negligence; carelessness"}	\N	\N	\N
終わり	おわり	{}	{"the end"}	\N	\N	\N
終わる	おわる	{続いていた物事が、そこでなくなる。しまいになる。済む。「授業が―・る」「一生が―・る」⇔始まる。}	{"〔おしまいになる〕end; be over; finish; be finished; 〔おしまいにする〕finish; end"}	\N	\N	\N
終る	おわる	{}	{"finish; close"}	\N	\N	\N
恩	おん	{}	{"favour; obligation; debt of gratitude"}	\N	\N	\N
音色	おんいろ	{}	{"tone color; tone quality; timbre; synthesizer patch"}	\N	\N	\N
音楽	おんがく	{}	{music}	\N	\N	\N
恩恵	おんけい	{}	{"grace; favor; blessing; benefit"}	\N	\N	\N
温室	おんしつ	{}	{greenhouse}	\N	\N	\N
恩赦	おんしゃ	{}	{"pardon; amnesty"}	\N	\N	\N
暗礁	あんしょう	{}	{"reef; sunken rock"}	\N	\N	\N
音声	おんせい	{テレビなどの音}	{"sound; a voice; speech"}	\N	\N	\N
温泉	おんせん	{}	{"spa; hot spring"}	\N	\N	\N
温帯	おんたい	{}	{"temperate zone"}	\N	\N	\N
温暖	おんだん	{}	{warmth}	\N	\N	\N
御中	おんちゅう	{}	{"and Company; Messrs."}	\N	\N	\N
温度	おんど	{}	{temperature}	\N	\N	\N
音符	おんぷ	{}	{"phonetic component (of a kanji); The part of a character that tells us how that character sounds."}	\N	\N	\N
女	おんな	{}	{"woman; girl; daughter"}	\N	\N	\N
女癖	おんなぐせ	{男がすぐ、女性関係を持つこと。多く「ーが悪い」の形で用いる。}	{"philanderer; womanizer"}	\N	\N	\N
女の子	おんなのこ	{}	{girl}	\N	\N	\N
女の人	おんなのひと	{}	{woman}	\N	\N	\N
怨念	おんねん	{}	{"grudge; hatred"}	\N	\N	\N
御柱	おんばしら	{}	{このページは「御柱祭」へ転送します。}	\N	\N	\N
音量	おんりょう	{}	{volume}	\N	\N	\N
温和	おんわ	{}	{"gentle; mild; moderate"}	\N	\N	\N
生麺	ラーメン	{麺類を成形したままの状態で、未加熱・未乾燥のものをいう。}	{ramen}	\N	\N	\N
来	らい	{}	{"since (last month); for (10 days); next (year)"}	\N	\N	\N
雷雨	らいう	{}	{thunderstrom}	\N	\N	\N
来月	らいげつ	{次の月}	{"next month"}	\N	\N	\N
来週	らいしゅう	{}	{"next week"}	\N	\N	\N
来場	らいじょう	{}	{attendance}	\N	\N	\N
来日	らいにち	{}	{"arrival in Japan; coming to Japan; visit to Japan"}	\N	\N	\N
来年	らいねん	{}	{"next year"}	\N	\N	\N
楽	らく	{}	{"comfort; ease"}	\N	\N	\N
落第	らくだい	{}	{"failure; dropping out of a class"}	\N	\N	\N
酪農	らくのう	{}	{"dairy (farm)"}	\N	\N	\N
落下	らっか	{}	{"fall; drop; come down"}	\N	\N	\N
落花生	らっかせい	{マメ科の一年草。茎は横にはい、葉は二対の小葉からなる複葉で、互生する。}	{peanut}	\N	\N	\N
楽観	らっかん	{}	{optimism}	\N	\N	\N
欄	らん	{}	{"column of text (as in a newspaper)"}	\N	\N	\N
乱交	らんこう	{}	{promiscuous}	\N	\N	\N
乱取り	らんどおり	{柔道で、互いに自由に技をかけ合って練習すること。}	{"〔柔道で〕free exercises (in judo)"}	\N	\N	\N
乱暴	らんぼう	{}	{"rude; violent; rough; lawless; unreasonable; reckless"}	\N	\N	\N
濫用	らんよう	{}	{"abuse; misuse; misappropriation; using to excess"}	\N	\N	\N
例外	れいがい	{}	{exception}	\N	\N	\N
礼儀	れいぎ	{}	{"manners; courtesy; etiquette"}	\N	\N	\N
略奪	りゃくだつ	{}	{"pillage; plunder; looting; robbery"}	\N	\N	\N
廊下	ろうか	{}	{corridor}	\N	\N	\N
零	れい	{}	{"zero; nought"}	\N	\N	\N
礼金	れいきん	{部屋や家を借りるとき、謝礼金という名目で家主に支払う一時金。「―と敷金」}	{"〔専門職に対する〕a fee; 〔家主に払う〕key money"}	\N	\N	\N
冷酷	れいこく	{}	{"cruelty; coldheartedness; relentless; ruthless"}	\N	\N	\N
冷静	れいせい	{}	{"calm; composure; coolness; serenity"}	\N	\N	\N
冷蔵	れいぞう	{}	{"cold storage; refrigeration"}	\N	\N	\N
冷蔵庫	れいぞうこ	{}	{refrigerator}	\N	\N	\N
冷淡	れいたん	{}	{"coolness; indifference"}	\N	\N	\N
零点	れいてん	{}	{"zero; no marks"}	\N	\N	\N
冷凍	れいとう	{}	{"freezing; cold storage; refrigeration"}	\N	\N	\N
冷房	れいぼう	{}	{"cooling; air-conditioning"}	\N	\N	\N
歴史	れきし	{人間社会が経てきた変遷・発展の経過。また、その記録。「日本の―」「―上の事件」「―に残る」「―をひもとく」}	{history}	\N	\N	\N
歴代	れきだい	{何代も経てきていること。また、それぞれの代。歴世。「―の首相」}	{"successive generations"}	\N	\N	\N
列	れつ	{}	{"line; row"}	\N	\N	\N
列車	れっしゃ	{}	{"train (ordinary)"}	\N	\N	\N
列島	れっとう	{}	{"chain of islands"}	\N	\N	\N
恋愛	れんあい	{特定の異性に特別の愛情を感じて恋い慕うこと。また、男女が互いにそのような感情をもつこと。「熱烈にーする」}	{love}	\N	\N	\N
冷却	れいきゃく	{温度を下げること。また、温度が下がること。「機関をーする」「ー水」}	{"cooling; refrigeration"}	\N	\N	\N
連休	れんきゅう	{}	{"consecutive holidays"}	\N	\N	\N
錬金術	れんきんじゅつ	{}	{alchemy}	\N	\N	\N
連合	れんごう	{}	{"union; alliance"}	\N	\N	\N
連日	れんじつ	{}	{"every day; prolonged"}	\N	\N	\N
連射	れんしゃ	{}	{rapid-fire}	\N	\N	\N
練習	れんしゅう	{}	{practice}	\N	\N	\N
連勝	れんしょう	{続けて勝つこと。「連勝式」の略。「連戦ー」}	{"((three)) victories in a row; ((three)) straight wins"}	\N	\N	\N
連想	れんそう	{}	{"association (of ideas); suggestion"}	\N	\N	\N
連続	れんぞく	{}	{"serial; consecutive; continuity; occurring in succession; continuing"}	\N	\N	\N
連帯	れんたい	{}	{solidarity}	\N	\N	\N
連中	れんちゅう	{仲間である者たち。また、同じようなことをする者たちをひとまとめにしていう語。親しみ、あるいは軽蔑 (けいべつ) を込めていう。「クラスのーを誘ってみる」「こういうーは度し難い」}	{"colleagues; company; a lot"}	\N	\N	\N
廉売	れんばい	{商品を安い値段で売ること。安売り。「傷物を―する」「特価大―」}	{"a (bargain) sale⇒やすうり(安売り)"}	\N	\N	\N
連邦	れんぽう	{アメリカ・スイス・ドイツなど。連合国家。}	{"commonwealth; federation of states"}	\N	\N	\N
連盟	れんめい	{}	{"league; union; alliance"}	\N	\N	\N
連絡	れんらく	{}	{"junction; communication; connection; coordination"}	\N	\N	\N
連絡先	れんらくさき	{}	{contacts}	\N	\N	\N
利益	りえき	{}	{"profits; gains; (political; economic) interest"}	\N	\N	\N
理科	りか	{}	{science}	\N	\N	\N
理解	りかい	{物事の道理や筋道が正しくわかること。「―が早い」}	{"understanding; comprehension"}	\N	\N	\N
利害	りがい	{}	{"advantages and disadvantages; interest"}	\N	\N	\N
力士	りきし	{}	{sumo-wrestler}	\N	\N	\N
陸	りく	{}	{"land; shore"}	\N	\N	\N
陸軍	りくぐん	{}	{army}	\N	\N	\N
理屈	りくつ	{}	{"theory; reason"}	\N	\N	\N
利口	りこう	{}	{"clever; shrewd; bright; sharp; wise; intelligent"}	\N	\N	\N
利根	りこん	{}	{intelligence}	\N	\N	\N
離婚	りこん	{}	{divorce}	\N	\N	\N
利子	りし	{}	{"interest (bank)"}	\N	\N	\N
理事	りじ	{団体を代表し、担当事務を処理する特定の役職。}	{"a director; 〔大学などの〕a trustee"}	\N	\N	\N
利潤	りじゅん	{}	{"profit; returns"}	\N	\N	\N
理性	りせい	{}	{"reason; sense"}	\N	\N	\N
理想	りそう	{}	{ideal}	\N	\N	\N
利息	りそく	{}	{"interest (bank)"}	\N	\N	\N
利他	りた	{}	{"〜的 altruistic; unselfish"}	\N	\N	\N
率	りつ	{}	{"rate; ratio; proportion; percentage"}	\N	\N	\N
立秋	りっしゅう	{}	{"first day of autumn"}	\N	\N	\N
立体	りったい	{}	{"solid body"}	\N	\N	\N
立派	りっぱ	{}	{"splendid; fine; handsome; elegant; imposing; prominent; legal; legitimate"}	\N	\N	\N
立法	りっぽう	{}	{"legislation; lawmaking"}	\N	\N	\N
利点	りてん	{}	{"advantage; point in favor"}	\N	\N	\N
略語	りゃくご	{}	{"abbreviation; acronym"}	\N	\N	\N
略す	りゃくす	{}	{abbreviate}	\N	\N	\N
流	りゅう	{}	{"styleof; method of; manner of"}	\N	\N	\N
理由	りゆう	{}	{reason}	\N	\N	\N
留意	りゅうい	{ある物事に心をとどめて、気をつけること。「健康に―する」「―点」}	{"pay attention to; give thought to; keep in mind"}	\N	\N	\N
流域	りゅういき	{}	{"(river) basin"}	\N	\N	\N
留学	りゅうがく	{}	{"studying abroad"}	\N	\N	\N
留学生	りゅうがくせい	{}	{"overseas student"}	\N	\N	\N
粒子	りゅうし	{}	{"particle (of light); grain (of sand)"}	\N	\N	\N
流暢	りゅうちょう	{言葉が滑らかに出てよどみないこと。また、そのさま。「ーな英語で話す」}	{fluency}	\N	\N	\N
流通	りゅうつう	{}	{"circulation of money or goods; flow of water or air; distribution"}	\N	\N	\N
了	りょう	{}	{"finish; completion; understanding"}	\N	\N	\N
量	りょう	{}	{"quantity; amount; volume; portion (of food)"}	\N	\N	\N
料	りょう	{}	{"material; charge; rate; fee"}	\N	\N	\N
寮	りょう	{}	{"hostel; dormitory"}	\N	\N	\N
利用	りよう	{}	{use}	\N	\N	\N
領域	りょういき	{}	{"area; domain; territory; field; region; regime"}	\N	\N	\N
了解	りょうかい	{}	{"comprehension; consent; understanding; roger (on the radio)"}	\N	\N	\N
領海	りょうかい	{}	{"territorial waters"}	\N	\N	\N
両替	りょうがえ	{}	{"change; money exchange"}	\N	\N	\N
両側	りょうがわ	{}	{"both sides"}	\N	\N	\N
利用規約	りようきやく	{}	{"terms of use (規約 agreement; code)"}	\N	\N	\N
両極	りょうきょく	{}	{"both extremities; north and south poles; positive and negative poles"}	\N	\N	\N
料金	りょうきん	{}	{"fee; charge; fare"}	\N	\N	\N
利用権	りようけん	{}	{"right to use"}	\N	\N	\N
両国	りょうこく	{両方の国。ある物事にかかわる二つの国。「―の首脳」}	{"the two countries"}	\N	\N	\N
量産	りょうさん	{}	{"mass production"}	\N	\N	\N
漁師	りょうし	{}	{fisherman}	\N	\N	\N
領事	りょうじ	{}	{consul}	\N	\N	\N
良識	りょうしき	{}	{"good sense"}	\N	\N	\N
良質	りょうしつ	{}	{"good quality; superior quality"}	\N	\N	\N
領収	りょうしゅう	{}	{"receipt; voucher"}	\N	\N	\N
領袖	りょうしゅう	{}	{"leader (e.g. president; prime minister; CEO)"}	\N	\N	\N
領収書	りょうしゅうしょ	{金銭を受け取ったしるしに書いて渡す書き付け。受取 (うけとり) 。受領証。領収証。レシート。}	{receipt}	\N	\N	\N
了承	りょうしょう	{}	{"acknowledgement; understanding (e.g. 'please be understanding of the mess during our renovation')"}	\N	\N	\N
良心	りょうしん	{}	{conscience}	\N	\N	\N
両親	りょうしん	{}	{"parents; both parents"}	\N	\N	\N
領地	りょうち	{}	{"territory; dominion"}	\N	\N	\N
両手	りょうて	{左右両方の手。もろて。「―利き」}	{"both hands"}	\N	\N	\N
料亭	りょうてい	{主として日本料理を出す高級な料理屋。}	{"a first-class Japanese restaurant"}	\N	\N	\N
領土	りょうど	{}	{"dominion; territory; possession"}	\N	\N	\N
両方	りょうほう	{}	{both}	\N	\N	\N
料理	りょうり	{}	{"cooking; cookery; cuisine"}	\N	\N	\N
両立	りょうりつ	{}	{"compatibility; coexistence; standing together"}	\N	\N	\N
旅客	りょかく	{}	{"passenger (transport)"}	\N	\N	\N
旅館	りょかん	{}	{"Japanese inn"}	\N	\N	\N
旅券	りょけん	{}	{passport}	\N	\N	\N
旅行	りょこう	{}	{"travel; trip"}	\N	\N	\N
履歴	りれき	{}	{"personal history; background; career; log"}	\N	\N	\N
理論	りろん	{}	{theory}	\N	\N	\N
林業	りんぎょう	{}	{forestry}	\N	\N	\N
臨時	りんじ	{特別「ー急行」「ー休業」「ー休館」}	{"temporary; special; extraordinary"}	\N	\N	\N
隣人	りんじん	{となりに住む人。となり近所の人。また、自分のまわりにいる人。「―愛」}	{"a neighbor，((英)) a neighbour; 〔総称〕the neighborhood"}	\N	\N	\N
倫理	りんり	{人として守り行うべき道。善悪・正邪の判断において普遍的な規準となるもの。道徳。モラル。「ーにもとる行為」「ー観」「政治ー」}	{"ethics; morals"}	\N	\N	\N
炉	ろ	{}	{"〔囲炉裏〕a sunken hearth (cut in the middle of the floor); 〔暖炉〕a fireplace; 〔かまど〕a furnace⇒いろり(囲炉裏)"}	\N	\N	\N
流行	りゅうこう	{}	{"fashionable; fad; in vogue; prevailing"}	\N	\N	\N
輪	りん	{}	{"counter for wheels and flowers"}	\N	\N	\N
良好	りょうこう	{よいこと。好ましい状態であること。また、そのさま。「受信状態は―だ」「―な成績」}	{"favorable; satisfactory"}	\N	\N	\N
楼閣	ろうかく	{}	{"multistoried building"}	\N	\N	\N
老人	ろうじん	{}	{"the aged; old person"}	\N	\N	\N
老衰	ろうすい	{}	{"senility; senile decay"}	\N	\N	\N
労働	ろうどう	{}	{"manual labor; toil; work"}	\N	\N	\N
朗読	ろうどく	{}	{"reading aloud; recitation"}	\N	\N	\N
浪人	ろうにん	{古代、本籍地を離れ、他国を流浪している者。浮浪人。}	{"a person out of work; an unemployed person"}	\N	\N	\N
老婆	ろうば	{年とった女性。老女。老媼 (ろうおう) 。}	{"an old woman"}	\N	\N	\N
浪費	ろうひ	{}	{"waste; extravagance"}	\N	\N	\N
浪費癖	ろうひぐせ	{金銭をむだに使うくせ}	{"Extravagant spending habits"}	\N	\N	\N
労力	ろうりょく	{}	{"labour; effort; toil; trouble"}	\N	\N	\N
録音	ろくおん	{}	{"(audio) recording"}	\N	\N	\N
六十代	ろくじゅうだい	{}	{sixties}	\N	\N	\N
露骨	ろこつ	{}	{"frank; blunt; plain; outspoken; conspicuous; open; broad; suggestive"}	\N	\N	\N
路線	ろせん	{}	{route}	\N	\N	\N
論議	ろんぎ	{}	{discussion}	\N	\N	\N
論じる	ろんじる	{}	{"argue; discuss; debate"}	\N	\N	\N
論ずる	ろんずる	{}	{"argue; discuss; debate"}	\N	\N	\N
論争	ろんそう	{}	{"controversy; dispute"}	\N	\N	\N
論文	ろんぶん	{}	{"thesis; essay; treatise; paper"}	\N	\N	\N
論理	ろんり	{}	{logic}	\N	\N	\N
差	さ	{}	{"difference; variation"}	\N	\N	\N
佐	さ	{}	{help}	\N	\N	\N
歳	さい	{}	{-years-old}	\N	\N	\N
差異	さい	{}	{"difference; disparity"}	\N	\N	\N
再	さい	{}	{"re-; again; repeated"}	\N	\N	\N
再会	さいかい	{}	{"another meeting; meeting again; reunion"}	\N	\N	\N
災害	さいがい	{地震・台風などの自然現象や事故・火事・伝染病などによって受ける思わぬわざわい。また、それによる被害。「不慮の―」「―に見舞われる」}	{"calamity; disaster; misfortune"}	\N	\N	\N
再起動	さいきどう	{コンピューターや周辺機器の使用を中止し、起動しなおすこと。リブート。リスタート。→ブート}	{"〔コンピュータで〕restart; reboot"}	\N	\N	\N
最強	さいきょう	{}	{strongest}	\N	\N	\N
最近	さいきん	{}	{recently}	\N	\N	\N
細菌	さいきん	{}	{"bacillus; bacterium; germ"}	\N	\N	\N
細工	さいく	{}	{"work; craftsmanship; tactics; trick"}	\N	\N	\N
採掘	さいくつ	{}	{mining}	\N	\N	\N
採決	さいけつ	{}	{"vote; roll call"}	\N	\N	\N
再建	さいけん	{}	{"rebuilding; reconstruction; rehabilitation"}	\N	\N	\N
再現	さいげん	{}	{"reappearance; reproduction; return; revival"}	\N	\N	\N
最後	さいご	{}	{"last time"}	\N	\N	\N
最高	さいこう	{}	{"highest; supreme; the most"}	\N	\N	\N
再三	さいさん	{}	{"again and again; repeatedly"}	\N	\N	\N
採算	さいさん	{}	{profit}	\N	\N	\N
祭司	さいし	{1.祭儀を執り行う者。2.ユダヤ教で、神殿に奉仕して儀式をつかさどる者。}	{"a [an officiating] priest"}	\N	\N	\N
妻子	さいし	{}	{"mother & child"}	\N	\N	\N
祭日	さいじつ	{}	{"national holiday; festival day"}	\N	\N	\N
採集	さいしゅう	{}	{"collecting; gathering"}	\N	\N	\N
最終	さいしゅう	{}	{"last; final; closing"}	\N	\N	\N
最初	さいしょ	{}	{"first time"}	\N	\N	\N
斎場	さいじょう	{神社、寺院などのある清浄な場所}	{"holy precincts"}	\N	\N	\N
再生	さいせい	{}	{"playback; regeneration; resuscitation; return to life; rebirth; reincarnation; narrow escape; reclamation; regrowth"}	\N	\N	\N
最善	さいぜん	{}	{"the very best"}	\N	\N	\N
催促	さいそく	{}	{"request; demand; claim; urge (action); press for"}	\N	\N	\N
最多	さいた	{一番大きい}	{most}	\N	\N	\N
採択	さいたく	{}	{"adoption; selection; choice"}	\N	\N	\N
最中	さいちゅう	{進行中のとき}	{"midst; in the middle of"}	\N	\N	\N
最低	さいてい	{}	{"least; lowest; worst; nasty; disgusting; horrible; yuck!"}	\N	\N	\N
最適	さいてき	{いちばん適していること。また、そのさま。「会計には彼が―だ」「スキーに―な雪質」}	{"optimum (most suitible)"}	\N	\N	\N
覚ます	さます	{}	{"awaken; disabuse; sober up"}	\N	\N	\N
清掃	せいそう	{}	{cleaning}	\N	\N	\N
際	さい	{}	{"edge; brink; verge; side"}	\N	\N	\N
六	ろく	{}	{six}	\N	\N	\N
再稼動	さいかどう	{}	{"a restart; restarting"}	\N	{再稼働}	\N
最適化	さいてきか	{《optimization》システム工学などで、特定の目的に最適の計画・システムを設計すること。コンピューターでは、プログラムを特定の目的に最も効率的なように書き換えること。オプティマイズ。オプティマイゼーション。}	{optimization}	\N	\N	\N
採点	さいてん	{}	{"marking; grading; looking over"}	\N	\N	\N
災難	さいなん	{}	{"calamity; misfortune"}	\N	\N	\N
才能	さいのう	{}	{"talent; ability"}	\N	\N	\N
栽培	さいばい	{}	{cultivation}	\N	\N	\N
再発	さいはつ	{}	{"return; relapse; reoccurrence"}	\N	\N	\N
裁判	さいばん	{}	{"trial; judgement"}	\N	\N	\N
裁判所	さいばんしょ	{司法権を行使する国家機関。具体的事件について公権的な判断を下す権限をもつ。最高裁判所、および下級裁判所の高等・地方・家庭・簡易の各裁判所がある。}	{"a court (of law; of justice); a law court"}	\N	\N	\N
財布	さいふ	{}	{"purse; wallet"}	\N	\N	\N
裁縫	さいほう	{}	{sewing}	\N	\N	\N
細胞	さいぼう	{}	{"cell (biology)"}	\N	\N	\N
債務	さいむ	{}	{debt}	\N	\N	\N
採用	さいよう	{適当であると思われる人物・意見・方法などを、とり上げて用いること。}	{"adoption; employment"}	\N	\N	\N
幸い	さいわい	{その人にとって望ましく、ありがたいこと。また、そのさま。しあわせ。幸福。「不幸中の―」「君たちの未来に―あれと祈る」「御笑納いただければ―です」}	{"happiness; blessedness"}	\N	\N	\N
遮る	さえぎる	{}	{"to interrupt; to intercept; to obstruct"}	\N	\N	\N
坂	さか	{}	{"slope; hill"}	\N	\N	\N
境	さかい	{}	{"border; boundary; mental state"}	\N	\N	\N
栄える	さかえる	{}	{"to prosper; to flourish"}	\N	\N	\N
差額	さがく	{}	{"balance; difference; margin"}	\N	\N	\N
逆さ	さかさ	{}	{"reverse; inversion; upside down"}	\N	\N	\N
逆様	さかさま	{}	{"inversion; upside down"}	\N	\N	\N
捜す	さがす	{}	{"search; seek; look for"}	\N	\N	\N
探す	さがす	{}	{"search for; look for"}	\N	\N	\N
杯	さかずき	{}	{"wine cups"}	\N	\N	\N
逆立ち	さかだち	{}	{"handstand; headstand"}	\N	\N	\N
逆上る	さかのぼる	{}	{"to go back; to go upstream; to make retroactive"}	\N	\N	\N
遡る	さかのぼる	{}	{"go back; go upstream; make retroactive"}	\N	\N	\N
酒場	さかば	{}	{"bar; bar-room"}	\N	\N	\N
盛り	さかり	{}	{"summit; peak; prime"}	\N	\N	\N
下がる	さがる	{}	{down}	\N	\N	\N
盛ん	さかん	{}	{prosperous}	\N	\N	\N
先	さき	{}	{"the future; forward; priority; precedence; former; previous; old; late"}	\N	\N	\N
詐欺	さぎ	{}	{"fraud; swindle"}	\N	\N	\N
一昨昨日	さきおととい	{}	{"two days before yesterday"}	\N	\N	\N
先に	さきに	{}	{"before; earlier than; ahead; beyond; away; previously; recently"}	\N	\N	\N
先程	さきほど	{}	{"some time ago"}	\N	\N	\N
作業	さぎょう	{}	{"work; operation; manufacturing; fatigue duty"}	\N	\N	\N
裂く	さく	{}	{"to tear; split"}	\N	\N	\N
策	さく	{}	{"plan; policy"}	\N	\N	\N
昨	さく	{}	{"last (year); yesterday"}	\N	\N	\N
作	さく	{}	{"a work; a harvest"}	\N	\N	\N
咲く	さく	{}	{"to bloom"}	\N	\N	\N
柵	さく	{}	{"fence; paling"}	\N	\N	\N
索引	さくいん	{}	{"index; indices"}	\N	\N	\N
削減	さくげん	{}	{"cut; reduction; curtailment"}	\N	\N	\N
錯誤	さくご	{}	{mistake}	\N	\N	\N
作者	さくしゃ	{}	{author}	\N	\N	\N
削除	さくじょ	{}	{"elimination; cancellation; deletion; erasure"}	\N	\N	\N
作成	さくせい	{}	{"frame; draw up; make; producing; creating; preparing; writing;"}	\N	\N	\N
作製	さくせい	{}	{manufacture}	\N	\N	\N
作戦	さくせん	{}	{"military or naval operations; tactics; strategy"}	\N	\N	\N
昨年	さくねん	{}	{"last year"}	\N	\N	\N
昨晩	さくばん	{きのうの晩。ゆうべ。昨夜。}	{"last night; yesterday evening"}	\N	\N	\N
作品	さくひん	{}	{"work; opus; performance; production"}	\N	\N	\N
作文	さくぶん	{}	{"composition; writing"}	\N	\N	\N
昨夜	さくや	{}	{"last night"}	\N	\N	\N
探る	さぐる	{}	{"search; look for; sound out"}	\N	\N	\N
作物	さくぶつ	{}	{"literary work"}	\N	\N	\N
下る	さがる	{}	{"hang down; abate; retire; fall; step back"}	\N	\N	\N
逆らう	さからう	{物事の自然の勢いに従わないで、その逆の方向に進もうとする。「風に―・って進む」「運命に―・って生きる」「時流に―・う」}	{"〔逆行する〕go against〔反抗する〕defy; rebel ((against))⇒はんこう(反抗)"}	\N	\N	\N
炸裂	さくれつ	{着弾した砲弾などがはげしく爆発すること。「榴弾(りゅうだん)が―する」}	{"(an) explosion; 炸裂する explode; go off"}	\N	\N	\N
酒	さけ	{}	{"alcohol; sake"}	\N	\N	\N
叫び	さけび	{}	{"shout; scream; outcry"}	\N	\N	\N
叫ぶ	さけぶ	{}	{"shout; cry out"}	\N	\N	\N
裂ける	さける	{}	{"to split; to tear; to burst"}	\N	\N	\N
避ける	さける	{}	{"avoid (situation); ward off; to avert"}	\N	\N	\N
下げる	さげる	{}	{"hang; let down"}	\N	\N	\N
些細	ささい	{あまり重要ではないさま。取るに足らないさま。「ーなことを気にする」}	{"〜な trifling; trivial"}	\N	\N	\N
支える	ささえる	{}	{"support; prop up"}	\N	\N	\N
査察	ささつ	{状況を視察すること。物事が規定どおり行われているかどうかを調べること。「上空から両国の緩衝地帯を―する」}	{"(an) inspection (e.g. of a factory)"}	\N	\N	\N
刺さる	ささる	{}	{"stick; be stuck"}	\N	\N	\N
些事	さじ	{}	{"something small or petty; trifle"}	\N	\N	\N
差し上げる	さしあげる	{}	{give}	\N	\N	\N
差し掛かる	さしかかる	{}	{"to come near to; to approach"}	\N	\N	\N
指図	さしず	{}	{"instruction; mandate"}	\N	\N	\N
差し出す	さしだす	{}	{"to present; to submit; to tender; to hold out"}	\N	\N	\N
差し支え	さしつかえ	{}	{"hindrance; impediment"}	\N	\N	\N
差し支える	さしつかえる	{}	{"to interfere; to hinder; to become impeded"}	\N	\N	\N
差し引き	さしひき	{}	{"deduction; subtraction; balance; ebb and flow; rise and fall"}	\N	\N	\N
差し引く	さしひく	{}	{"to deduct"}	\N	\N	\N
刺身	さしみ	{}	{"sliced raw fish"}	\N	\N	\N
注す	さす	{}	{"pour or serve (drinks)"}	\N	\N	\N
刺す	さす	{}	{"pierce; stab; prick; thrust; bite; sting; pin down"}	\N	\N	\N
差す	さす	{}	{"raise (stretch out) hands; to raise umbrella"}	\N	\N	\N
指す	さす	{}	{"to point; put up umbrella; to play"}	\N	\N	\N
挿す	さす	{}	{"to insert; put in; graft"}	\N	\N	\N
射す	さす	{}	{"to shine; to strike"}	\N	\N	\N
授ける	さずける	{}	{"to grant; to award; to teach"}	\N	\N	\N
させていただく	させていただく	{相手に許しを請うことによって、ある動作を遠慮しながら行う意を表す。「私が司会を―・きます」}	{"will do (on partners permission)"}	\N	\N	\N
誘う	さそう	{}	{"invite; call out"}	\N	\N	\N
定まる	さだまる	{}	{"to become settled; to be fixed"}	\N	\N	\N
定める	さだめる	{}	{"to decide; to establish; to determine"}	\N	\N	\N
札	さつ	{}	{"paper money"}	\N	\N	\N
冊	さつ	{}	{"counter for books"}	\N	\N	\N
撮影	さつえい	{}	{photographing}	\N	\N	\N
作家	さっか	{}	{"author; writer; novelist; artist"}	\N	\N	\N
錯覚	さっかく	{}	{"optical illusion; hallucination"}	\N	\N	\N
擦過傷	さっかしょう	{}	{abrasion}	\N	\N	\N
早急	さっきゅう	{}	{urgent}	\N	\N	\N
作曲	さっきょく	{}	{"composition; setting (of music)"}	\N	\N	\N
殺人	さつじん	{}	{murder}	\N	\N	\N
察する	さっする	{}	{"to guess; to sense; to presume; to judge; to sympathize with"}	\N	\N	\N
早速	さっそく	{}	{"at once; immediately; without delay; promptly"}	\N	\N	\N
砂糖	さとう	{}	{sugar}	\N	\N	\N
悟る	さとる	{}	{"to attain enlightenment; to perceive; to understand; to discern"}	\N	\N	\N
真実	さな	{}	{"truth; reality"}	\N	\N	\N
砂漠	さばく	{}	{desert}	\N	\N	\N
裁く	さばく	{}	{"to judge"}	\N	\N	\N
寂しい	さびしい	{}	{lonely}	\N	\N	\N
差別	さべつ	{}	{"discrimination; distinction; differentiation"}	\N	\N	\N
作法	さほう	{}	{"manners; etiquette; propriety"}	\N	\N	\N
左程	さほど	{}	{"(not) very; (not) much"}	\N	\N	\N
様々	さまざま	{}	{"varied; various"}	\N	\N	\N
差出人	さしだしにん	{郵便物などの発送者。}	{"the sender; 〔為替の〕the remitter"}	\N	{差し出し人,差し出人,差出し人}	\N
冷ます	さます	{}	{"cool; dampen; let cool; throw a damper on; spoil"}	\N	\N	\N
妨げる	さまたげる	{}	{"disturb; prevent"}	\N	\N	\N
三味線	さみせん	{}	{"three-stringed Japanese guitar; shamisen"}	\N	\N	\N
寒い	さむい	{}	{"cold (e.g. weather)"}	\N	\N	\N
侍	さむらい	{}	{"Samurai; warrior"}	\N	\N	\N
覚める	さめる	{}	{"wake; wake up"}	\N	\N	\N
冷める	さめる	{}	{"become cool; wear off; abate; subside; dampen"}	\N	\N	\N
然も	さも	{}	{"with gusto; with satisfaction"}	\N	\N	\N
左右	さゆう	{}	{"left and right; influence; control; domination"}	\N	\N	\N
作用	さよう	{}	{"action; operation; effect; function"}	\N	\N	\N
左様なら	さようなら	{}	{good-bye}	\N	\N	\N
皿	さら	{}	{"plate; dish"}	\N	\N	\N
再来月	さらいげつ	{}	{"month after next"}	\N	\N	\N
さ来月	さらいげつ	{}	{"the month after next"}	\N	\N	\N
再来週	さらいしゅう	{}	{"week after next"}	\N	\N	\N
さ来週	さらいしゅう	{}	{"the week after next"}	\N	\N	\N
再来年	さらいねん	{}	{"year after next"}	\N	\N	\N
拐う	さらう	{}	{"to carry off; to run away with; to kidnap; to abduct"}	\N	\N	\N
更紗	さらさ	{インド起源の木綿地の文様染め製品、及び、その影響を受けてアジア、ヨーロッパなどで製作された類似の文様染め製品を指す染織工芸用語。}	{"Chintz; glazed calico textiles; designs featuring flowers and other patterns in different colours"}	\N	\N	\N
更に	さらに	{}	{"furthermore; again; after all; more and more; moreover"}	\N	\N	\N
去る	さる	{}	{"leave; go away"}	\N	\N	\N
沢	さわ	{浅く水がたまり、草が生えている湿地。}	{"a swamp"}	\N	\N	\N
騒がしい	さわがしい	{}	{noisy}	\N	\N	\N
騒ぐ	さわぐ	{}	{"make a noise"}	\N	\N	\N
爽やか	さわやか	{}	{"fresh; refreshing; invigorating; clear; fluent; eloquent"}	\N	\N	\N
障る	さわる	{}	{"to hinder; to interfere with; to affect; to do one harm; to be harmful to"}	\N	\N	\N
触る	さわる	{}	{touch}	\N	\N	\N
酸	さん	{}	{acid}	\N	\N	\N
酸化	さんか	{}	{oxidation}	\N	\N	\N
参加	さんか	{ある目的をもつ集まりに一員として加わり、行動をともにすること。}	{participation}	\N	\N	\N
三角	さんかく	{}	{"triangle; triangular"}	\N	\N	\N
山岳	さんがく	{}	{mountains}	\N	\N	\N
三月	さんがつ	{}	{March}	\N	\N	\N
参観	さんかん	{その場所に行って、見ること。「授業を―する」}	{"a visit"}	\N	\N	\N
参議院	さんぎいん	{}	{"House of Councillors"}	\N	\N	\N
産休	さんきゅう	{}	{"maternity leave"}	\N	\N	\N
産業	さんぎょう	{}	{industry}	\N	\N	\N
産後	さんご	{}	{"postpartum; after childbirth"}	\N	\N	\N
参考	さんこう	{}	{"reference; consultation"}	\N	\N	\N
参考書	さんこうしょ	{調査・研究・教授・学習などの際に参考とする書物。「受験―」}	{"reference book"}	\N	\N	\N
散在	さんざい	{あちこちに散らばってあること。点在。「湖畔に―する別荘」}	{scattered}	\N	\N	\N
産出	さんしゅつ	{}	{"yield; produce"}	\N	\N	\N
算出	さんしゅつ	{計算して数値を出すこと。「必要経費を―する」}	{"calculation; computation"}	\N	\N	\N
参照	さんしょう	{}	{"reference; consultation; consultation"}	\N	\N	\N
参上	さんじょう	{}	{"calling on; visiting"}	\N	\N	\N
算数	さんすう	{}	{arithmetic}	\N	\N	\N
賛成	さんせい	{人の意見や行動をよいと認めて、それに同意すること。「原案に―する」⇔反対。}	{"approval; agreement; support; favour"}	\N	\N	\N
酸性	さんせい	{}	{acidity}	\N	\N	\N
酸素	さんそ	{}	{oxygen}	\N	\N	\N
産地	さんち	{}	{"producing area"}	\N	\N	\N
賛美	さんび	{}	{"praise; adoration; glorification"}	\N	\N	\N
山腹	さんぷく	{}	{"hillside; mountainside"}	\N	\N	\N
産婦人科	さんふじんか	{}	{"maternity and gynecology department"}	\N	\N	\N
産物	さんぶつ	{}	{"product; result; fruit"}	\N	\N	\N
散歩	さんぽ	{}	{"walk; stroll"}	\N	\N	\N
三	さん	{}	{three}	\N	\N	\N
桟橋	さんきょう	{}	{"wharf; bridge; jetty; pier"}	\N	\N	\N
騒ぎ	さわぎ	{人々が騒ぐような出来事。ごたごた。騒動。「―を起こす」「―になる」}	{"uproar; disturbance"}	\N	\N	\N
山脈	さんみゃく	{}	{"mountain range"}	\N	\N	\N
山林	さんりん	{}	{"mountain forest; mountains and forest"}	\N	\N	\N
三塁	さんるい	{}	{"third base"}	\N	\N	\N
瀬	せ	{}	{rapids}	\N	\N	\N
正	せい	{}	{"(logical) true; regular"}	\N	\N	\N
制	せい	{}	{"system; organization; imperial command; laws; regulation; control; government; suppression; restraint; holding back; establishment"}	\N	\N	\N
製	せい	{}	{"-made; make"}	\N	\N	\N
姓	せい	{}	{"surname; family name"}	\N	\N	\N
性	せい	{}	{"sex; gender"}	\N	\N	\N
生育	せいいく	{}	{"growth; development; breeding"}	\N	\N	\N
征夷大将軍	せいいたいしょうぐん	{}	{shogun}	\N	\N	\N
精液	せいえき	{}	{semen}	\N	\N	\N
成果	せいか	{あることをして得られたよい結果。}	{Achievement}	\N	\N	\N
正解	せいかい	{}	{"correct; right; correct interpretation (answer solution)"}	\N	\N	\N
制海権	せいかいけん	{}	{"control of the seas"}	\N	\N	\N
性格	せいかく	{}	{"character; personality"}	\N	\N	\N
正確	せいかく	{}	{"accurate; punctual; exact; authentic; veracious"}	\N	\N	\N
生活	せいかつ	{}	{"living; life (one´s daily existence); livelihood"}	\N	\N	\N
生活必需品	せいかつひつじゅひん	{生活していくうえで欠かすことのできない品。食品・衣類・洗剤・燃料など。}	{"necessities of life; daily necessities [essentials]"}	\N	\N	\N
世紀	せいき	{}	{"century; era"}	\N	\N	\N
正規	せいき	{}	{"regular; legal; formal; established; legitimate"}	\N	\N	\N
請求	せいきゅう	{}	{"claim; demand; application; request"}	\N	\N	\N
請求書	せいきゅうしょ	{物品や代金の支払いなどを請求するために出す文書。}	{invoice}	\N	\N	\N
生計	せいけい	{}	{"livelihood; living"}	\N	\N	\N
清潔	せいけつ	{}	{clean}	\N	\N	\N
政権	せいけん	{}	{"administration; political power"}	\N	\N	\N
制限	せいげん	{}	{"restriction; restraint; limitation"}	\N	\N	\N
成功	せいこう	{物事を目的どおりに成し遂げること。「失敗はーの母」「新規事業がーをおさめる」「実験にーする」}	{"success; hit"}	\N	\N	\N
精巧	せいこう	{}	{"elaborate; delicate; exquisite"}	\N	\N	\N
星座	せいざ	{}	{constellation}	\N	\N	\N
制裁	せいさい	{}	{"restraint; sanctions; punishment"}	\N	\N	\N
政策	せいさく	{}	{"political measures; policy"}	\N	\N	\N
制作	せいさく	{}	{"work (film; book)"}	\N	\N	\N
製作	せいさく	{}	{"manufacture; production"}	\N	\N	\N
清算	せいさん	{}	{"liquidation; settlement"}	\N	\N	\N
生産	せいさん	{}	{"production; manufacture"}	\N	\N	\N
静止	せいし	{}	{"stillness; repose; standing still"}	\N	\N	\N
生死	せいし	{}	{"life and death"}	\N	\N	\N
政治	せいじ	{}	{politic}	\N	\N	\N
政治家	せいじか	{}	{politician}	\N	\N	\N
正式	せいしき	{}	{"due form; official; formality"}	\N	\N	\N
制式	せいしき	{きめられた様式。きまり。}	{formality}	\N	\N	\N
性質	せいしつ	{}	{"nature; property; disposition"}	\N	\N	\N
誠実	せいじつ	{}	{"sincere; honest; faithful"}	\N	\N	\N
成熟	せいじゅく	{}	{"maturity; ripeness"}	\N	\N	\N
青春	せいしゅん	{}	{"youth; springtime of life; adolescent"}	\N	\N	\N
清純	せいじゅん	{}	{"purity; innocence"}	\N	\N	\N
聖書	せいしょ	{}	{"Bible; scriptures"}	\N	\N	\N
清書	せいしょ	{}	{"clean copy"}	\N	\N	\N
正常	せいじょう	{}	{"normalcy; normality; normal"}	\N	\N	\N
青少年	せいしょうねん	{}	{"youth; young person"}	\N	\N	\N
精神	せいしん	{}	{"mind; soul; heart; spirit; intention"}	\N	\N	\N
成人	せいじん	{}	{adult}	\N	\N	\N
整数	せいすう	{}	{integer}	\N	\N	\N
制する	せいする	{}	{"to control; to command; to get the better of"}	\N	\N	\N
精々	せいぜい	{}	{"at the most; at best; to the utmost; as much (far) as possible"}	\N	\N	\N
成績	せいせき	{}	{"results; record"}	\N	\N	\N
整然	せいぜん	{}	{"orderly; regular; well-organized; trim; accurate"}	\N	\N	\N
盛装	せいそう	{}	{"be dressed up; wear rich clothes"}	\N	\N	\N
背	せい	{}	{"height; stature"}	\N	\N	\N
背	せ	{}	{"height; stature"}	\N	\N	\N
正義	せいぎ	{人の道にかなっていて正しいこと。「―を貫く」「―の味方」}	{"justice; right; righteousness; correct meaning"}	\N	\N	\N
精巣	せいそう	{}	{testicle}	\N	\N	\N
生存	せいぞん	{}	{"existence; being; survival"}	\N	\N	\N
盛大	せいだい	{}	{"grand; prosperous; magnificent"}	\N	\N	\N
清濁	せいだく	{}	{"good and evil; purity and impurity"}	\N	\N	\N
成長	せいちょう	{}	{"growth; grow to adulthood"}	\N	\N	\N
生長	せいちょう	{}	{"growth; increment"}	\N	\N	\N
制定	せいてい	{}	{"enactment; establishment; creation"}	\N	\N	\N
静的	せいてき	{}	{static}	\N	\N	\N
製鉄	せいてつ	{}	{"iron manufacture"}	\N	\N	\N
晴天	せいてん	{}	{"fine weather"}	\N	\N	\N
生徒	せいと	{}	{pupil}	\N	\N	\N
制度	せいど	{}	{"system; institution; organization"}	\N	\N	\N
正当	せいとう	{}	{"just; justifiable; right; due; proper; equitable; reasonable; legitimate; lawful"}	\N	\N	\N
政党	せいとう	{}	{"(member of) political party"}	\N	\N	\N
成年	せいねん	{}	{"majority; adult age"}	\N	\N	\N
青年	せいねん	{}	{"youth; young man"}	\N	\N	\N
生年月日	せいねんがっぴ	{}	{"birth date"}	\N	\N	\N
性能	せいのう	{}	{"ability; efficiency"}	\N	\N	\N
制覇	せいは	{}	{"domination; mastery; conquest"}	\N	\N	\N
整備	せいび	{}	{"adjustment; completion; consolidation"}	\N	\N	\N
製品	せいひん	{}	{"manufactured goods"}	\N	\N	\N
政府	せいふ	{政治を行う所。立法・司法・行政のすべての作用を包含する、国家の統治機構の総称。日本では、内閣および内閣の統轄する行政機構をさす。内閣。}	{"government; administration"}	\N	\N	\N
制服	せいふく	{}	{uniform}	\N	\N	\N
征服	せいふく	{}	{"conquest; subjugation; overcoming"}	\N	\N	\N
生物	せいぶつ	{}	{"living things; creature"}	\N	\N	\N
成分	せいぶん	{}	{"ingredient; component; composition"}	\N	\N	\N
性別	せいべつ	{}	{"distinction by sex; sex; gender"}	\N	\N	\N
製法	せいほう	{}	{"manufacturing method; recipe; formula"}	\N	\N	\N
正方形	せいほうけい	{}	{square}	\N	\N	\N
精密	せいみつ	{}	{"precise; exact; detailed; minute; close"}	\N	\N	\N
声明	せいめい	{}	{"declaration; statement; proclamation"}	\N	\N	\N
姓名	せいめい	{}	{"full name"}	\N	\N	\N
生命	せいめい	{}	{"life; existence"}	\N	\N	\N
正門	せいもん	{}	{"main gate; main entrance"}	\N	\N	\N
制約	せいやく	{}	{"limitation; restriction; condition; constraints"}	\N	\N	\N
西洋	せいよう	{}	{"West; Western countries"}	\N	\N	\N
生理	せいり	{}	{"physiology; menses"}	\N	\N	\N
整理	せいり	{}	{"sorting; arrangement; adjustment; regulation"}	\N	\N	\N
成立	せいりつ	{}	{"coming into existence; arrangements; establishment; completion"}	\N	\N	\N
勢力	せいりょく	{}	{"influence; power; might; strength; potency; force; energy"}	\N	\N	\N
精霊	せいれい	{}	{"spirit; ghost; soul"}	\N	\N	\N
西暦	せいれき	{}	{"Christian Era; Anno Domini (A.D.)"}	\N	\N	\N
整列	せいれつ	{}	{"stand in a row; form a line"}	\N	\N	\N
世界	せかい	{}	{world}	\N	\N	\N
急かす	せかす	{}	{"to hurry; to urge on"}	\N	\N	\N
席	せき	{}	{seat}	\N	\N	\N
積	せき	{}	{"〔数学で〕the product"}	\N	\N	\N
隻	せき	{比較的大きい船を数えるのに用いる。「駆逐艦二―」}	{vessels}	\N	\N	\N
石炭	せきたん	{}	{coal}	\N	\N	\N
赤道	せきどう	{}	{equator}	\N	\N	\N
責任	せきにん	{}	{"duty; responsibility"}	\N	\N	\N
責務	せきむ	{}	{"duty; obligation"}	\N	\N	\N
石油	せきゆ	{}	{"oil; petroleum; kerosene"}	\N	\N	\N
世間	せけん	{}	{"world; society"}	\N	\N	\N
世帯	せたい	{住居および生計を同じくする者の集まり。所帯。「一―当たりの収入」}	{"household〔家族〕a family"}	\N	\N	\N
世代	せだい	{}	{"generation; the world; the age"}	\N	\N	\N
背丈	せたけ	{かかとから頭頂までの背の高さ。身長。}	{"〔身長〕height; ((文)) stature⇒しんちょう(身長)"}	\N	\N	\N
説	せつ	{}	{theory}	\N	\N	\N
切開	せっかい	{}	{"clearing (land); opening up; cutting through"}	\N	\N	\N
石灰岩	せっかいがん	{}	{limestone}	\N	\N	\N
折角	せっかく	{}	{"with trouble; at great pains; long-awaited"}	\N	\N	\N
赤色	せきしょく	{}	{red}	\N	\N	\N
節	せつ	{}	{"node; section; occasion; time"}	\N	\N	\N
製造	せいぞう	{原料に手を加えて製品にすること。制作。製作。作成。作製。「菓子を―する」「―販売」}	{"manufacture; production"}	\N	\N	\N
石棺	せっかん	{}	{sarcophagus}	\N	\N	\N
積極的	せっきょくてき	{}	{"positive; active; proactive"}	\N	\N	\N
接近	せっきん	{}	{"getting closer; approaching"}	\N	\N	\N
設計	せっけい	{建造物の工事、機械の製造などに際し、対象物の構造・材料・製作法などの計画を図面に表すこと。「ビルを―する」}	{"plan; design"}	\N	\N	\N
石鹸	せっけん	{}	{soap}	\N	\N	\N
摂氏	せっし	{}	{celsius}	\N	\N	\N
切実	せつじつ	{}	{"compelling; serious; severe; acute; earnest; pressing; urgent"}	\N	\N	\N
摂取	せっしゅ	{}	{ingestion}	\N	\N	\N
雪辱	せつじょく	{}	{"revenge; vindication of honor; making up for a loss"}	\N	\N	\N
接触	せっしょく	{}	{"touch; contact"}	\N	\N	\N
接する	せっする	{}	{"come in contact with; connect; attend; receive"}	\N	\N	\N
拙速	せっそく	{できはよくないが、仕事が早いこと。また、そのさま。「―に事を運ぶ」⇔巧遅 (こうち) }	{"hasty; more haste than caution"}	\N	\N	\N
接続	せつぞく	{}	{"connection; union; join; link; changing trains"}	\N	\N	\N
接続詞	せつぞくし	{}	{conjunction}	\N	\N	\N
設置	せっち	{}	{"establishment; institution"}	\N	\N	\N
設定	せってい	{}	{"establishment; creation"}	\N	\N	\N
窃盗	せっとう	{盗難}	{theft}	\N	\N	\N
説得	せっとく	{}	{persuasion}	\N	\N	\N
切ない	せつない	{}	{"painful; trying; oppressive; suffocating"}	\N	\N	\N
設備	せつび	{}	{"equipment; device; facilities; installation"}	\N	\N	\N
節約	せつやく	{}	{"economising; saving"}	\N	\N	\N
設立	せつりつ	{}	{"establishment; foundation; institution"}	\N	\N	\N
瀬戸物	せともの	{}	{"earthenware; crockery; china"}	\N	\N	\N
背中	せなか	{}	{back}	\N	\N	\N
背広	せびろ	{}	{"business suit"}	\N	\N	\N
狭い	せまい	{}	{"narrow; confined; small"}	\N	\N	\N
迫る	せまる	{}	{"draw near; press"}	\N	\N	\N
攻め	せめ	{}	{"attack; offence"}	\N	\N	\N
攻める	せめる	{}	{"attack; assault"}	\N	\N	\N
責める	せめる	{}	{"condemn; blame; criticize"}	\N	\N	\N
世論	せろん	{}	{"public opinion"}	\N	\N	\N
世話	せわ	{}	{"take care of"}	\N	\N	\N
千	せん	{}	{"thousand; many"}	\N	\N	\N
栓	せん	{}	{"stopper; cork"}	\N	\N	\N
仙	せん	{}	{"hermit; wizard"}	\N	\N	\N
線	せん	{}	{line}	\N	\N	\N
繊維	せんい	{細い糸状の物質。}	{"fibre; fiber"}	\N	\N	\N
選挙	せんきょ	{}	{election}	\N	\N	\N
宣教	せんきょう	{}	{"religious mission"}	\N	\N	\N
先月	せんげつ	{}	{"last month"}	\N	\N	\N
宣言	せんげん	{個人・団体・国家などが、意見・方針などを外部に表明すること。また、その内容。「国家の独立をーする」}	{"declaration; proclamation; announcement"}	\N	\N	\N
専攻	せんこう	{}	{"major subject; special study"}	\N	\N	\N
先行	せんこう	{}	{"preceding; going first"}	\N	\N	\N
選考	せんこう	{能力・人柄などをよく調べて適格者を選び出すこと。「受賞者を―する」「書類―」}	{"selection; screening"}	\N	\N	\N
線香	せんこう	{}	{incense}	\N	\N	\N
戦災	せんさい	{}	{"war damage"}	\N	\N	\N
洗剤	せんざい	{}	{"detergent; washing material"}	\N	\N	\N
遷徙	せんし	{ある場所を抜け出て他の所へうつること｡また､うつすこと｡}	{"(animal emigration from a land)"}	\N	\N	\N
先日	せんじつ	{}	{"the other day; a few days ago"}	\N	\N	\N
選手	せんしゅ	{}	{"player (in game); team"}	\N	\N	\N
専修	せんしゅう	{}	{specialization}	\N	\N	\N
先週	せんしゅう	{}	{"last week; the week before"}	\N	\N	\N
戦術	せんじゅつ	{}	{tactics}	\N	\N	\N
洗浄	せんじょう	{}	{"washing; cleaning; laundering"}	\N	\N	\N
扇子	せんす	{}	{"folding fan"}	\N	\N	\N
潜水	せんすい	{}	{diving}	\N	\N	\N
切腹	せっぷく	{}	{"ritual suicide"}	\N	\N	\N
説明	せつめい	{ある事柄が、よくわかるように述べること。解説。論説。「ーを求める」「科学ではーのつかない現象」「事情をーする」}	{explanation}	{名,スル}	\N	\N
専制	せんせい	{}	{"despotism; autocracy"}	\N	\N	\N
先生	せんせい	{}	{"teacher; master; doctor"}	\N	\N	\N
先々月	せんせんげつ	{}	{"month before last"}	\N	\N	\N
先々週	せんせんしゅう	{}	{"week before last"}	\N	\N	\N
先祖	せんぞ	{}	{ancestor}	\N	\N	\N
戦争	せんそう	{}	{war}	\N	\N	\N
先代	せんだい	{}	{"family predecessor; previous age; previous generation"}	\N	\N	\N
洗濯	せんたく	{}	{"washing; laundry"}	\N	\N	\N
選択	せんたく	{}	{"selection; choice"}	\N	\N	\N
選択肢	せんたくし	{}	{choices}	\N	\N	\N
先だって	せんだって	{}	{"recently; the other day"}	\N	\N	\N
先端	せんたん	{}	{"pointed end; tip; fine point; spearhead; cusp; vanguard; advanced; leading edge"}	\N	\N	\N
先着	せんちゃく	{}	{"first arrival"}	\N	\N	\N
船長	せんちょう	{船舶の乗組員の長。船舶の指揮者として法律上の職務・権限や義務をもち、乗組員を監督する者。キャプテン。}	{captain}	\N	\N	\N
宣伝	せんでん	{}	{"propaganda; publicity"}	\N	\N	\N
先天的	せんてんてき	{}	{"a priori; inborn; innate; inherent; congenital; hereditary"}	\N	\N	\N
先頭	せんとう	{}	{"head; lead; vanguard; first"}	\N	\N	\N
戦闘	せんとう	{}	{"battle; fight; combat"}	\N	\N	\N
銭湯	せんとう	{入浴料を取って一般の人を入浴させる浴場。ふろや。ゆや。公衆浴場。}	{"a public bath"}	\N	\N	\N
潜入	せんにゅう	{こっそりと入り込むこと。忍び込むこと。「敵地にーする」}	{"infiltration; sneaking in"}	\N	\N	\N
栓抜き	せんぬき	{瓶の王冠やコルク栓などを抜き取る道具。}	{"bottle opener"}	\N	\N	\N
先輩	せんぱい	{}	{"one´s senior"}	\N	\N	\N
船舶	せんぱく	{}	{ship}	\N	\N	\N
旋風	せんぷう	{}	{"〔つむじ風〕a whirlwind"}	\N	\N	\N
扇風機	せんぷうき	{}	{"electric fan"}	\N	\N	\N
先鋒	せんぽう	{戦闘の際、部隊の先頭に立って進むもの。さきて。「―隊」}	{"the vanguard; the van"}	\N	\N	\N
戦没	せんぼつ	{}	{"death in battle; killed in action"}	\N	\N	\N
洗面	せんめん	{顔を洗うこと。洗顔。}	{"face wash"}	\N	\N	\N
洗面台	せんめんだい	{}	{"wash basin (stand)"}	\N	\N	\N
専門	せんもん	{}	{"expert; speciality"}	\N	\N	\N
専門家	せんもんか	{ある特定の学問・事柄を専門に研究・担当して、それに精通している人。エキスパート。「経済の―」}	{"a specialist; a professional; 〔特に，熟練した〕an expert ((in))"}	\N	\N	\N
専門学校	せんもんがっこう	{}	{"Vocational school (yrkesskola; fackskola)"}	\N	\N	\N
専用	せんよう	{}	{"exclusive use; personal use"}	\N	\N	\N
占領	せんりょう	{}	{"occupation; capture; possession; have a room to oneself"}	\N	\N	\N
戦力	せんりょく	{}	{"war potential"}	\N	\N	\N
線路	せんろ	{}	{"line; track; roadbed"}	\N	\N	\N
詩	し	{}	{"poem; verse of poetry"}	\N	\N	\N
死	し	{}	{"death; decease"}	\N	\N	\N
試合	しあい	{}	{game}	\N	\N	\N
仕上がり	しあがり	{}	{"finish; end; completion"}	\N	\N	\N
仕上がる	しあがる	{}	{"be finished"}	\N	\N	\N
仕上げ	しあげ	{}	{"end; finishing touches; being finished"}	\N	\N	\N
仕上げる	しあげる	{}	{"to finish up; to complete"}	\N	\N	\N
明々後日	しあさって	{}	{"two days after tomorrow"}	\N	\N	\N
幸せ	しあわせ	{}	{"happiness; good fortune; luck; blessing"}	\N	\N	\N
飼育	しいく	{}	{"breeding; raising; rearing"}	\N	\N	\N
強いて	しいて	{}	{"by force"}	\N	\N	\N
強いる	しいる	{}	{"to force; to compel; to coerce"}	\N	\N	\N
仕入れる	しいれる	{}	{"to lay in stock; to replenish stock; to procure"}	\N	\N	\N
ジェット機	ジェットき	{}	{"jet airplane"}	\N	\N	\N
塩辛い	しおからい	{}	{"salty (flavor)"}	\N	\N	\N
歯科	しか	{}	{dentistry}	\N	\N	\N
司会	しかい	{}	{chairmanship}	\N	\N	\N
視界	しかい	{目で見通すことのできる範囲。視野。「濃霧でーがきかない」}	{"the field of vision; visibility"}	\N	\N	\N
市街	しがい	{}	{"urban areas; the streets; town; city"}	\N	\N	\N
四角	しかく	{}	{square}	\N	\N	\N
資格	しかく	{}	{"qualifications; requirements; capabilities"}	\N	\N	\N
視覚	しかく	{}	{"sense of sight; vision"}	\N	\N	\N
四角い	しかくい	{}	{square}	\N	\N	\N
仕掛け	しかけ	{}	{"device; trick; mechanism; gadget; (small) scale; half finished; commencement; set up; challenge"}	\N	\N	\N
仕掛ける	しかける	{}	{"to commence; to lay (mines); to set (traps); to wage (war); to challenge"}	\N	\N	\N
然しながら	しかしながら	{}	{"nevertheless; however"}	\N	\N	\N
如かず	しかず	{及ばない。かなわない。「百聞は一見に―◦ず」}	{"fall short; can not compete;"}	\N	\N	\N
仕方が無い	しかたがない	{どうすることもできない。ほかによい方法がない。やむを得ない。「ー・い。それでやるか」}	{"nothing to do about it; can not be avoided/helped;"}	\N	\N	\N
四月	しがつ	{}	{April}	\N	\N	\N
叱る	しかる	{}	{scold}	\N	\N	\N
四季	しき	{}	{"four seasons"}	\N	\N	\N
指揮	しき	{}	{"command; direction"}	\N	\N	\N
敷金	しききん	{不動産、特に家屋の賃貸借にさいして賃料などの債務の担保にする目的で、賃借人が賃貸人に預けておく保証金。しきがね。}	{"a deposit"}	\N	\N	\N
色彩	しきさい	{}	{"colour; hue; tints"}	\N	\N	\N
式場	しきじょう	{}	{"ceremonial hall; place of ceremony (e.g. marriage)"}	\N	\N	\N
為来り	しきたり	{}	{customs}	\N	\N	\N
敷地	しきち	{}	{site}	\N	\N	\N
式典	しきてん	{}	{"ceremony; rites"}	\N	\N	\N
支給	しきゅう	{}	{"payment; allowance"}	\N	\N	\N
至急	しきゅう	{非常に急ぐこと}	{urgent}	\N	\N	\N
至急お越し	至急お越し	{急いで来て}	{"come ASAP"}	\N	\N	\N
施行	しぎょう	{}	{"execution; enforcing; carrying out"}	\N	\N	\N
資金	しきん	{}	{"funds; capital"}	\N	\N	\N
敷く	しく	{}	{"spread out; to lay out; take a position"}	\N	\N	\N
仕組み	しくみ	{}	{"devising; plan; plot; contrivance; construction; arrangement"}	\N	\N	\N
死刑	しけい	{}	{"death penalty; capital punishment"}	\N	\N	\N
死刑囚	しけいしゅう	{}	{"condemned; criminal condemned to death"}	\N	\N	\N
刺激	しげき	{}	{"stimulus; impetus; incentive; excitement; irritation; encouragement; motivation"}	\N	\N	\N
湿気る	しける	{}	{"to be damp; to be moist"}	\N	\N	\N
茂る	しげる	{}	{"grow thick; luxuriate; be luxurious"}	\N	\N	\N
試験	しけん	{}	{examination}	\N	\N	\N
資源	しげん	{}	{resources}	\N	\N	\N
嗜好	しこう	{}	{"taste; liking; preference"}	\N	\N	\N
志向	しこう	{}	{"intention; aim"}	\N	\N	\N
思考	しこう	{}	{thought}	\N	\N	\N
思考力	しこうりょく	{}	{"thinking power"}	\N	\N	\N
仕事	しごと	{}	{"work; occupation; employment"}	\N	\N	\N
示唆	しさ	{《「じさ」とも》それとなく知らせること。ほのめかすこと。「ーに富む談話」「法改正の可能性をーする」}	{"〔提言〕(a) suggestion; 〔暗示〕a hint"}	\N	\N	\N
施策	しさく	{政策・対策を立てて、それを実地に行うこと。政治などを行うに際して実地にとる策。}	{"〔政策〕a policy; 〔処置〕a measure"}	\N	\N	\N
視察	しさつ	{}	{"inspection; observation"}	\N	\N	\N
刺殺	しさつ	{さしころすこと。野球で、野手が、飛球を捕らえたり、送球を受けたり、走者にタッチしたりして、打者または走者をアウトにすること。プットアウト。→補殺「銃剣で―する」}	{stabbing}	\N	\N	\N
資産	しさん	{}	{"property; fortune; means; assets"}	\N	\N	\N
志士	しし	{高い志を持った人}	{loyalist}	\N	\N	\N
指示	しじ	{}	{"indication; instruction; directions"}	\N	\N	\N
支持	しじ	{}	{"support; maintenance"}	\N	\N	\N
脂質	ししつ	{}	{Lipid}	\N	\N	\N
四捨五入	ししゃごにゅう	{}	{"rounding up (especially fractions)"}	\N	\N	\N
刺繍	ししゅう	{}	{embroidery}	\N	\N	\N
始終	しじゅう	{}	{"continuously; from beginning to end"}	\N	\N	\N
支出	ししゅつ	{}	{"expenditure; expenses"}	\N	\N	\N
師匠	ししょう	{学問または武術・芸術の師。先生。}	{"a teacher; 〔芸術の巨匠など〕a master"}	\N	\N	\N
史上	しじょう	{歴史に現れているところ。歴史上。「―空前の惨事」}	{"in history; from a historical point of view"}	\N	\N	\N
茂み	しげみ	{草木の生い茂っている所。「葦 (あし) の―」}	{"〔低木の茂ったところ〕a thicket; 〔丈の低い下生え〕bushes"}	\N	{繁み}	\N
式	しき	{一定の作法にのっとって行う、あらたまった行事。儀式。「―を挙げる」,ある定まったやり方やかたち。方式。形式。型。「―に従う」,数学その他の科学で、文字や数を演算記号で結びつけ、ある関係や法則を表したもの。数式・方程式・化学式など。「―を立てる」}	{"〔儀式〕a ceremony; 〔宗教上の儀式〕a rite","〔方式〕style; system; fashion","〔数理〕an expression; 〔方程式〕an equation; 〔公式〕a formula ((複-lae",〜s))}	\N	\N	\N
詩人	しじん	{}	{poet}	\N	\N	\N
静か	しずか	{}	{"quiet; peaceful"}	\N	\N	\N
静まる	しずまる	{}	{"calm down; subside; die down; abate; be suppressed"}	\N	\N	\N
沈む	しずむ	{}	{"sink; feel depressed"}	\N	\N	\N
沈める	しずめる	{}	{"to sink; to submerge"}	\N	\N	\N
鎮める	しずめる	{物音や声を小さくさせる。静かにさせる。「場内をー・める」「鳴りをー・める」}	{"to quiet; to calm; to appease"}	\N	\N	\N
姿勢	しせい	{からだの構え方。また、構え。かっこう。「楽なーで話を聞く」}	{"attitude; posture"}	\N	\N	\N
死生	しせい	{死ぬことと生きること。死ぬか生きるか。生死。ししょう。「日本人の―観」}	{"life and death"}	\N	\N	\N
施設	しせつ	{}	{"institution; establishment; facility; (army) engineer"}	\N	\N	\N
自然	しぜん	{}	{"nature; spontaneous"}	\N	\N	\N
自然科学	しぜんかがく	{}	{"natural science"}	\N	\N	\N
思想	しそう	{}	{"thought; idea; ideology"}	\N	\N	\N
子息	しそく	{}	{son}	\N	\N	\N
子孫	しそん	{}	{"descendants; posterity; offspring"}	\N	\N	\N
舌	した	{}	{tongue}	\N	\N	\N
死体	したい	{}	{corpse}	\N	\N	\N
次第	しだい	{}	{"order; precedence; circumstances; immediate(ly); as soon as; dependent upon"}	\N	\N	\N
慕う	したう	{}	{"to yearn for; to miss; to adore; to love dearly"}	\N	\N	\N
従う	したがう	{後ろについて行く。あとに続く。「案内人に―・う」「前を行く人に―・って歩く」}	{"〔服従する〕obey; follow; 〔甘受する〕abide by; accompany"}	\N	\N	\N
随う	したがう	{"目上の人のあとについて行動する。偉い人に随行する という意味。「社長に―ってパリへ行く」"}	{"〔服従する〕obey; follow; 〔甘受する〕abide by; accompany"}	\N	\N	\N
順う	したがう	{言うことを聞く。}	{"obey (a command); follow (an order)"}	\N	\N	\N
遵う	したがう	{道理や法則にしたがう。のっとる。法的対象にしたがう。「遵守」}	{"follow (the law; legal system)"}	\N	\N	\N
下書き	したがき	{}	{"rough copy; draft"}	\N	\N	\N
下着	したぎ	{}	{underwear}	\N	\N	\N
支度	したく	{}	{preparation}	\N	\N	\N
下心	したごころ	{}	{"secret intention; motive"}	\N	\N	\N
下地	したじ	{}	{"groundwork; foundation; inclination; aptitude; elementary knowledge of; grounding in; prearrangement; spadework; signs; symptoms; first coat of plastering; soy"}	\N	\N	\N
親しい	したしい	{}	{"intimate; close"}	\N	\N	\N
親しむ	したしむ	{}	{"to be intimate with; to befriend"}	\N	\N	\N
下調べ	したしらべ	{}	{"preliminary investigation; preparation"}	\N	\N	\N
仕立てる	したてる	{}	{"to tailor; to make; to prepare; to train; to send (a messenger)"}	\N	\N	\N
下取り	したどり	{}	{"trade in; part exchange"}	\N	\N	\N
下火	したび	{}	{"burning low; waning; declining"}	\N	\N	\N
下町	したまち	{}	{"Shitamachi; lower parts of town"}	\N	\N	\N
七	しち	{}	{seven}	\N	\N	\N
七月	しちがつ	{}	{July}	\N	\N	\N
室	しつ	{}	{room}	\N	\N	\N
質	しつ	{}	{quality}	\N	\N	\N
失格	しっかく	{}	{"disqualification; elimination; incapacity (legal)"}	\N	\N	\N
確り	しっかり	{}	{"firmly; tightly; reliable; level-headed; steady"}	\N	\N	\N
疾患	しっかん	{}	{"disease; ailment"}	\N	\N	\N
質疑	しつぎ	{}	{question}	\N	\N	\N
失業	しつぎょう	{}	{unemployment}	\N	\N	\N
湿気	しっけ	{物や空気の中に含まれている水分。水気・モイスチャー}	{"get damp; get soggy"}	\N	\N	\N
仕付ける	しつける	{}	{"to be used to a job; to begin to do; to baste; to tack; to plant"}	\N	\N	\N
湿原	しつげん	{低温で多湿な所に発達した草原。}	{"((米)) a moor; ((英)) a bog; a fen"}	\N	\N	\N
執行	しっこう	{とりおこなうこと。実際に行うこと。「職務を―する」}	{execution}	\N	\N	\N
執行部	しっこうぶ	{}	{"executive office"}	\N	\N	\N
質素	しっそ	{}	{"simplicity; modesty; frugality"}	\N	\N	\N
失着	しっちゃく	{囲碁で、まちがった手を打つこと。また転じて、しくじり。}	{"failure; ⇒しっぱい(失敗)"}	\N	\N	\N
失調	しっちょう	{}	{"lack of harmony"}	\N	\N	\N
嫉妬	しっと	{}	{jealousy}	\N	\N	\N
湿度	しつど	{}	{"level of humidity"}	\N	\N	\N
失敗	しっぱい	{}	{"failure; fail"}	\N	\N	\N
執筆	しっぴつ	{}	{writing}	\N	\N	\N
疾風	しっぷう	{}	{"a gale; a strong wind; 〔気象用語〕a fresh breeze"}	\N	\N	\N
疾風迅雷	しっぷうじんらい	{}	{"buller och bong"}	\N	\N	\N
尻尾	しっぽ	{}	{"tail (animal)"}	\N	\N	\N
失望	しつぼう	{}	{"disappointment; despair"}	\N	\N	\N
質問	しつもん	{}	{"question; inquiry"}	\N	\N	\N
失礼	しつれい	{他人に接する際の心得をわきまえていないこと。礼儀に欠けること。また、そのさま。失敬。「―なやつ」「先日は―しました」}	{"〔無礼〕impoliteness; rudeness; bad manners"}	\N	\N	\N
失恋	しつれん	{}	{"disappointed love; broken heart; unrequited love; be lovelorn;"}	\N	\N	\N
指定	してい	{}	{"designation; specification; assignment; pointing at"}	\N	\N	\N
指摘	してき	{}	{"pointing out; identification"}	\N	\N	\N
私鉄	してつ	{}	{"private railway"}	\N	\N	\N
視点	してん	{}	{"opinion; point of view; visual point"}	\N	\N	\N
支店	してん	{}	{"branch store (office)"}	\N	\N	\N
指導	しどう	{}	{"leadership; guidance; coaching"}	\N	\N	\N
萎びる	しなびる	{}	{"to wilt; to fade"}	\N	\N	\N
品物	しなもの	{}	{"article; goods"}	\N	\N	\N
屎尿	しにょう	{}	{"excreta; raw sewage; human waste; night soil"}	\N	\N	\N
忍び	しのび	{隠れたりして、人目を避けること。人に知られないように、ひそかに物事をすること。→お忍び}	{incognito}	\N	\N	\N
芝	しば	{}	{"lawn; sod; turf"}	\N	\N	\N
支配	しはい	{ある地域や組織に勢力・権力を及ぼして、自分の意のままに動かせる状態に置くこと。統治；統制；指図；管理}	{"rule; control; direction; management"}	\N	\N	\N
賜杯	しはい	{天皇・皇族などが競技・試合などの勝者に与える優勝杯。}	{"the Emperor's Cup"}	\N	\N	\N
芝居	しばい	{}	{"play; drama"}	\N	\N	\N
支配者	しはいしゃ	{}	{"ruler; master"}	\N	\N	\N
始発	しはつ	{}	{"first train"}	\N	\N	\N
芝生	しばふ	{}	{lawn}	\N	\N	\N
支払	しはらい	{}	{payment}	\N	\N	\N
支払う	しはらう	{}	{"to pay"}	\N	\N	\N
暫く	しばらく	{}	{"little while"}	\N	\N	\N
縛る	しばる	{}	{"tie; bind"}	\N	\N	\N
師範	しはん	{}	{"master instructor"}	\N	\N	\N
渋い	しぶい	{}	{"tasteful (clothing); 'cool'; an aura of refined masculinity; astringent; sullen; bitter (taste); grim; quiet; sober; stingy"}	\N	\N	\N
飛沫	しぶき	{}	{"splash; spray"}	\N	\N	\N
私物	しぶつ	{}	{"private property; personal effects"}	\N	\N	\N
紙幣	しへい	{}	{"paper money; notes; bills"}	\N	\N	\N
司法	しほう	{}	{"administration of justice"}	\N	\N	\N
脂肪	しぼう	{}	{"fat; grease; blubber"}	\N	\N	\N
死亡	しぼう	{}	{"death; mortality"}	\N	\N	\N
志望	しぼう	{}	{"wish; desire; ambition"}	\N	\N	\N
萎む	しぼむ	{}	{"to wither; to fade (away); to shrivel; to wilt"}	\N	\N	\N
絞る	しぼる	{}	{"press; wring; squeeze"}	\N	\N	\N
搾る	しぼる	{}	{"squeeze; press"}	\N	\N	\N
島	しま	{}	{island}	\N	\N	\N
仕舞	しまい	{}	{"end; termination; informal (Noh play)"}	\N	\N	\N
死に掛かる	しにかかる	{まさに死のうとしている。もうすこしで死にそうである。「おぼれて―・った」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N	{死に懸かる,死にかかる}	\N
死に掛け	しにかけ	{もう少しで死にそうなこと。瀕死 (ひんし) 。「―のところを助けられる」}	{"the dying (of someone/thing)"}	\N	{死に懸け,死にかけ}	\N
資本	しほん	{商売や事業をするのに必要な基金。もとで。資本金。資金。キャピタル。}	{"funds; capital"}	\N	\N	\N
歯磨剤	しまざい	{歯磨きの際に使用される製品である。}	{"tooth paste"}	\N	\N	\N
始末	しまつ	{}	{"management; dealing; settlement; cleaning up afterwards"}	\N	\N	\N
閉まる	しまる	{}	{"to close; become closed"}	\N	\N	\N
泌み泌み	しみじみ	{}	{"keenly; deeply; heartily"}	\N	\N	\N
染みる	しみる	{}	{"to pierce; to permeate"}	\N	\N	\N
市民	しみん	{市の住民}	{citizen}	\N	\N	\N
占める	しめる	{あるもの・場所・位置・地位などを自分のものとする。占有する。「三賞を一人で―・める」}	{"occupy; hold"}	\N	\N	\N
品揃え	しなぞろえ	{準備した品物の種類。また、商品の種類をいろいろと用意すること。「豊かなー」}	{assortment}	\N	\N	\N
死ぬ	しぬ	{}	{die}	\N	\N	\N
氏名	しめい	{}	{"full name; identity"}	\N	\N	\N
使命	しめい	{}	{"mission; errand; message"}	\N	\N	\N
締め切る	しめきる	{}	{"shut up"}	\N	\N	\N
示す	しめす	{}	{"show; indicate; denote; point out"}	\N	\N	\N
締める	しめる	{}	{"to tie; fasten"}	\N	\N	\N
閉める	しめる	{}	{"to close; shut"}	\N	\N	\N
湿る	しめる	{}	{"be wet; become wet; be damp"}	\N	\N	\N
霜	しも	{}	{frost}	\N	\N	\N
指紋	しもん	{手の指先の、内側にある細い線がつくる紋様。形は弓状・渦状などがあり、人によって異なり一生不変なので、個人の識別や犯罪捜査などに利用される。「―をとる」}	{"a fingerprint; 〔親指の〕a thumbprint"}	\N	\N	\N
諮問	しもん	{}	{"a request for advice; consult (a person on a matter)"}	\N	\N	\N
視野	しや	{}	{"field of vision; outlook"}	\N	\N	\N
社員	しゃいん	{会社の一員として勤務している人。}	{"an employee; a member of the staff (of a company); 〔総称〕the staff"}	\N	\N	\N
社会	しゃかい	{}	{society}	\N	\N	\N
社会科学	しゃかいかがく	{}	{"social science"}	\N	\N	\N
勺	しゃく	{尺貫法の容積の単位。1合の10分の1。約0.018リットル。せき。}	{"〔容積単位〕a shaku (単複同形) (1勺は約0.018liters)"}	\N	\N	\N
爵	しゃく	{中国古代の温酒器。3本足の青銅器で、殷 (いん) 代から周代にかけて祭器として盛行した。}	{nobility}	\N	\N	\N
市役所	しやくしょ	{地方公共団体である市の市長・職員が、市の行政事務を取り扱う役所。市庁。}	{"a town hall，((米)) a city [municipal] hall"}	\N	\N	\N
借用	しゃくよう	{借りて使うこと。使うために借りること。}	{"borrowing; loan"}	\N	\N	\N
車庫	しゃこ	{}	{garage}	\N	\N	\N
社交	しゃこう	{}	{"social life; social intercourse"}	\N	\N	\N
車掌	しゃしょう	{}	{"(train) conductor"}	\N	\N	\N
写真	しゃしん	{}	{photograph}	\N	\N	\N
写生	しゃせい	{}	{"sketch; drawing from nature; portrayal; description"}	\N	\N	\N
社説	しゃせつ	{}	{"editorial; leading article"}	\N	\N	\N
謝絶	しゃぜつ	{}	{refusal}	\N	\N	\N
社宅	しゃたく	{}	{"company owned house"}	\N	\N	\N
遮断	しゃだん	{}	{"cutoff; interception"}	\N	\N	\N
社長	しゃちょう	{}	{president}	\N	\N	\N
借款	しゃっかん	{政府または公的機関の国際的な長期資金の貸借。広義には民間借款も含む。ローン。借用金。}	{"a loan"}	\N	\N	\N
借金	しゃっきん	{}	{"debt; loan; liabilities"}	\N	\N	\N
吃逆	しゃっくり	{}	{"hiccough; hiccup"}	\N	\N	\N
喋る	しゃべる	{物を言う。話す。口数多く話す。口に任せてぺらぺら話す。「一言も＿・らない」「よく＿・る人だ」}	{"talk; chat; chatter"}	\N	\N	\N
三味線	しゃみせん	{}	{shamisen}	\N	\N	\N
斜面	しゃめん	{}	{"slope; slanting surface; bevel"}	\N	\N	\N
車輪	しゃりん	{}	{"(car) wheel"}	\N	\N	\N
下	しも	{}	{"lower; last"}	\N	\N	\N
僕	しもべ	{}	{"manservant; servant (of God)"}	\N	\N	\N
洒落	しゃらく	{}	{"frank; open-hearted"}	\N	\N	\N
洒落	しゃれ	{}	{"frank; open-hearted"}	\N	\N	\N
締切	しめきり	{}	{"closing; cut-off; end; deadline; Closed; No Entrance"}	\N	{締め切り,〆切,〆切り,締切り}	\N
島々	しまじま	{}	{islands}	\N	{島島}	\N
車両	しゃりょう	{車輪のついた乗り物の総称。また、特に汽車・電車など鉄道の貨車・客車。「前の―がすいている」「―故障」「大型―」}	{"vehicles (車輪のあるもの．そりも含む); 〔鉄道の車両の総称〕rolling stock; 〔客車〕a coach，(米) a car，(英) a carriage"}	\N	{車輛}	\N
洒落る	しゃれる	{}	{"to joke; to play on words; to dress stylishly"}	\N	\N	\N
首位	しゅい	{第一の地位。順位の最上位。第1位。「クラスの―を占める」「―打者」}	{"first place"}	\N	\N	\N
朱印	しゅいん	{朱肉を使って押した印。特に、戦国時代以後、将軍や武将が公文書に押したもの。御朱印。}	{"red seal"}	\N	\N	\N
州	しゅう	{}	{"state; province"}	\N	\N	\N
周	しゅう	{}	{"circuit; lap; circumference; vicinity; Chou (dynasty)"}	\N	\N	\N
週	しゅう	{}	{week}	\N	\N	\N
衆	しゅう	{}	{"masses; great number; the people"}	\N	\N	\N
私有	しゆう	{}	{"private ownership"}	\N	\N	\N
集会	しゅうかい	{}	{"meeting; assembly"}	\N	\N	\N
収穫	しゅうかく	{}	{"harvest; crop; ingathering"}	\N	\N	\N
収穫量	しゅうかくりょう	{}	{"harvested amount; crop quantity"}	\N	\N	\N
修学	しゅうがく	{}	{learning}	\N	\N	\N
就活	しゅうかつ	{}	{"job hunting"}	\N	\N	\N
週間	しゅうかん	{}	{"week; weekly"}	\N	\N	\N
習慣	しゅうかん	{}	{"habit; custom"}	\N	\N	\N
周期	しゅうき	{}	{"cycle; period"}	\N	\N	\N
衆議院	しゅうぎいん	{}	{"Lower House; House of Representatives"}	\N	\N	\N
宗教	しゅうきょう	{}	{religion}	\N	\N	\N
修行	しゅうぎょう	{}	{"pursuit of knowledge; studying; learning; training; ascetic practice; discipline"}	\N	\N	\N
就業	しゅうぎょう	{}	{"employment; starting work"}	\N	\N	\N
集金	しゅうきん	{}	{"money collection"}	\N	\N	\N
集計	しゅうけい	{数を寄せ集めて合計すること。また、その合計した数。「各営業所の売上げを―する」}	{"totalization; aggregate"}	\N	\N	\N
襲撃	しゅうげき	{}	{"attack; charge; raid"}	\N	\N	\N
集合	しゅうごう	{}	{"gathering; assembly; meeting; (mathematics) set"}	\N	\N	\N
修士	しゅうし	{}	{"Masters degree program"}	\N	\N	\N
収支	しゅうし	{}	{"income and expenditure"}	\N	\N	\N
終始	しゅうし	{}	{"beginning and end; from beginning to end; doing a thing from beginning to end"}	\N	\N	\N
習字	しゅうじ	{}	{penmanship}	\N	\N	\N
終日	しゅうじつ	{}	{"all day"}	\N	\N	\N
執着	しゅうじゃく	{}	{"attachment; adhesion; tenacity"}	\N	\N	\N
収集	しゅうしゅう	{}	{"gathering up; collection; accumulation"}	\N	\N	\N
修飾	しゅうしょく	{}	{"ornamentation; embellishment; decoration; adornment; polish up (writing); modification (gram)"}	\N	\N	\N
就職	しゅうしょく	{仕事を見付けること。新しく職を得て勤めること。「地元の企業にーする」}	{"find work [a job]; get a job [position]"}	\N	\N	\N
就寝	しゅうしん	{}	{"going to bed"}	\N	\N	\N
修正	しゅうせい	{不十分・不適当と思われるところを改め直すこと。「文章の誤りをーする」}	{"(make) an amendment; a revision"}	\N	\N	\N
修繕	しゅうぜん	{}	{"repair; mending"}	\N	\N	\N
集団	しゅうだん	{}	{"group; mass"}	\N	\N	\N
集中	しゅうちゅう	{}	{"concentration; focusing the mind"}	\N	\N	\N
終点	しゅうてん	{}	{"terminus; last stop (e.g train)"}	\N	\N	\N
周到	しゅうとう	{手落ちがなく、すべてに行き届いていること。また、そのさま。「―な計画を立てる」「用意―」}	{"meticulous; 〔細かい所まで気を配った〕scrupulous; 〔注意深い〕careful"}	\N	\N	\N
収入	しゅうにゅう	{}	{"income; receipts; revenue"}	\N	\N	\N
就任	しゅうにん	{}	{inauguration}	\N	\N	\N
周辺	しゅうへん	{}	{"circumference; outskirts; environs; (computer) peripheral"}	\N	\N	\N
週末	しゅうまつ	{}	{weekend}	\N	\N	\N
周密	しゅうみつ	{注意が隅々にまで行き届いていること。また、そのさま。「―をきわめた計画」「―な配慮」}	{"scrupulous; exhaustive; very careful (plan)"}	\N	\N	\N
収容	しゅうよう	{}	{"accommodation; reception; seating; housing; custody; admission; entering (in a dictionary)"}	\N	\N	\N
修理	しゅうり	{壊れたり傷んだりした部分に手を加えて、再び使用できるようにすること。修繕。「時計を―に出す」「車を―する」}	{"repairing; mending"}	\N	\N	\N
修了	しゅうりょう	{}	{"completion (of a course)"}	\N	\N	\N
終了	しゅうりょう	{}	{"end; close; termination"}	\N	\N	\N
守衛	しゅえい	{}	{"security guard; doorkeeper"}	\N	\N	\N
主演	しゅえん	{}	{"starring; playing the leading part"}	\N	\N	\N
主観	しゅかん	{}	{"subjectivity; subject; ego"}	\N	\N	\N
主義	しゅぎ	{}	{"doctrine; rule; principle"}	\N	\N	\N
祝賀	しゅくが	{}	{"celebration; congratulations"}	\N	\N	\N
祝日	しゅくじつ	{}	{"national holiday"}	\N	\N	\N
宿舎	しゅくしゃ	{}	{"lodgings; 〔宿泊設備〕accommodations，((英)) accommodation;〔住居〕housing"}	\N	\N	\N
淑女	しゅくじょ	{しとやかで上品な女性。品格の高い女性。レディー。「紳士―」}	{lady}	\N	\N	\N
縮小	しゅくしょう	{}	{"reduction; curtailment"}	\N	\N	\N
宿題	しゅくだい	{}	{homework}	\N	\N	\N
宿泊	しゅくはく	{自宅以外の所に泊まること}	{lodging}	\N	\N	\N
宿命	しゅくめい	{}	{"fate; destiny; predestination"}	\N	\N	\N
手芸	しゅげい	{}	{handicrafts}	\N	\N	\N
主権	しゅけん	{}	{"sovereignty; supremacy; dominion"}	\N	\N	\N
主語	しゅご	{}	{"(grammar) subject"}	\N	\N	\N
主催	しゅさい	{}	{"organization; sponsorship"}	\N	\N	\N
主宰	しゅさい	{人々の上に立って全体をまとめること。団体・結社などを、中心となって運営すること。また、その人。「劇団を―する」}	{"~する 〔監督する〕supervise; superintend; 〔司会する〕preside (over)"}	\N	\N	\N
取材	しゅざい	{}	{"choice of subject; collecting data"}	\N	\N	\N
趣旨	しゅし	{}	{"object; meaning"}	\N	\N	\N
種子	しゅし	{種子植物で、受精した胚珠 (はいしゅ) が成熟して休眠状態になったもの。発芽して次の植物体になる胚と、胚の養分を貯蔵している胚乳、およびそれらを包む種皮からなる。たね。}	{"⇒たね(種)a seed; 〔桃などの〕a stone; (米) a pit"}	\N	\N	\N
手術	しゅじゅつ	{}	{"surgical operation"}	\N	\N	\N
首相	しゅしょう	{}	{"Prime Minister; Chancellor (Germany; Austria; etc.)"}	\N	\N	\N
主食	しゅしょく	{}	{"staple food"}	\N	\N	\N
主人公	しゅじんこう	{}	{"protagonist; main character; hero(ine) (of a story); head of household"}	\N	\N	\N
主体	しゅたい	{}	{"subject; main constituent"}	\N	\N	\N
主題	しゅだい	{}	{"subject; theme; motif"}	\N	\N	\N
主張	しゅちょう	{}	{"claim; request; insistence; assertion; advocacy; emphasis; contention; opinion; tenet"}	\N	\N	\N
出演	しゅつえん	{}	{"performance; stage appearance"}	\N	\N	\N
出勤	しゅっきん	{}	{"going to work; at work"}	\N	\N	\N
出血	しゅっけつ	{}	{"bleeding; haemorrhage"}	\N	\N	\N
出現	しゅつげん	{あらわれでること。隠れていたものや見えなかったものなどが、姿をあらわすこと。「救世主が―する」「新技術の―」}	{"appearance; ((文)) emergence"}	\N	\N	\N
出産	しゅっさん	{}	{"(child)birth; delivery; production (of goods)"}	\N	\N	\N
出社	しゅっしゃ	{}	{"arrival (in a country at work etc.)"}	\N	\N	\N
出生	しゅっしょう	{}	{birth}	\N	\N	\N
出身	しゅっしん	{}	{"person´s place of origin; institution from which one graduated; director in charge of employee relations"}	\N	\N	\N
出身地	しゅっしんち	{その人が生まれた土地。また、育った土地。「有名な俳優の―」}	{"the place where one was born; one's native place; one's hometown"}	\N	\N	\N
出世	しゅっせ	{}	{"promotion; successful career; eminence"}	\N	\N	\N
出席	しゅっせき	{}	{attend}	\N	\N	\N
出題	しゅつだい	{}	{"proposing a question"}	\N	\N	\N
出張	しゅっちょう	{}	{"official tour; business trip"}	\N	\N	\N
出動	しゅつどう	{}	{"sailing; marching; going out"}	\N	\N	\N
出発	しゅっぱつ	{}	{depart}	\N	\N	\N
出版	しゅっぱん	{}	{publication}	\N	\N	\N
出費	しゅっぴ	{}	{"expenses; disbursements"}	\N	\N	\N
出品	しゅっぴん	{}	{"exhibit; display"}	\N	\N	\N
出没	しゅつぼつ	{現れたり隠れたりすること。どこからともなく姿を現しては、またいなくなること。「空き巣が―する」}	{"can often be seen; ubiquitous; infested with; frequenting"}	\N	\N	\N
首都	しゅと	{}	{"capital city"}	\N	\N	\N
種痘	しゅとう	{}	{vaccination}	\N	\N	\N
主導	しゅどう	{}	{"main leadership"}	\N	\N	\N
取得	しゅとく	{手に入れること。ある資格・権利・物品などを自分のものとして得ること。「免許を―する」}	{acquisition}	\N	\N	\N
主任	しゅにん	{}	{"person in charge; responsible official"}	\N	\N	\N
執念	しゅうねん	{ある一つのことを深く思いつめる心。執着してそこから動かない心。「―をもってやり遂げる」「―を燃やす」}	{"〔物事にとらわれた心〕an obsession; 〔復讐心，しつこく恨むこと〕vindictiveness"}	\N	\N	\N
首脳	しゅのう	{}	{"head; brains"}	\N	\N	\N
主犯	しゅはん	{二人以上の者による犯罪行為の中心となった者。}	{"the ringleader; the principal offender"}	\N	\N	\N
守備	しゅび	{}	{defense}	\N	\N	\N
主婦	しゅふ	{}	{"housewife; mistress"}	\N	\N	\N
症状	しょうじょう	{病気やけがの状態。病気などによる肉体的、精神的な異状。「自覚―」}	{"symptoms; condition"}	\N	\N	\N
殳部	しゅぶ	{ほこ、ほこづくり、るまた（上部の「几」が片仮名の「ル」に見えたことから「るまた」(ル又)という俗称が付けられた）}	{"(Radical) weapon; missile"}	\N	\N	\N
手法	しゅほう	{物事のやり方。特に、芸術作品などをつくるうえでの表現方法。技法。「写実的な―」「新―を用いる」}	{technique}	\N	\N	\N
趣味	しゅみ	{}	{hobby}	\N	\N	\N
主役	しゅやく	{}	{"leading part; leading actor or actress"}	\N	\N	\N
主要	しゅよう	{}	{"chief; main; principal; major"}	\N	\N	\N
狩猟	しゅりょう	{山野の鳥獣を銃・網・わななどを使って捕らえること。狩り。猟。}	{hunting}	\N	\N	\N
種類	しゅるい	{}	{"variety; kind; type; category; counter for different sorts of things"}	\N	\N	\N
瞬間	しゅんかん	{}	{"moment; second; instant"}	\N	\N	\N
諸	しょ	{}	{"various; many; several"}	\N	\N	\N
小	しょう	{}	{small}	\N	\N	\N
章	しょう	{}	{"chapter; section; medal"}	\N	\N	\N
商	しょう	{}	{quotient}	\N	\N	\N
賞	しょう	{}	{"prize; award"}	\N	\N	\N
症	しょう	{}	{illness}	\N	\N	\N
私用	しよう	{}	{"personal use; private business"}	\N	\N	\N
仕様	しよう	{}	{"way; method; resource; remedy; (technical) specification"}	\N	\N	\N
使用	しよう	{}	{"use; employment"}	\N	\N	\N
省エネ	しょうえね	{「省エネルギー」の略。石油・電力・ガスなどのエネルギーを効率的に使用し、その消費量を節約すること。}	{"energy conservation; saving energy; 省エネのenergy-saving."}	\N	\N	\N
消化	しょうか	{生体が体内で食物を吸収しやすい形に変化させること。また、その過程。多くの動物では消化管内で、消化器の運動（物理的消化）、消化液の作用（化学的消化）、腸内細菌の作用（生物学的消化）などによって行われる。「―のいい食べ物」「よくかまないと―に悪い」}	{〔食べ物の〕digestion}	\N	\N	\N
紹介	しょうかい	{}	{introduce}	\N	\N	\N
障害	しょうがい	{}	{"obstacle; impediment (fault); damage"}	\N	\N	\N
奨学金	しょうがくきん	{}	{scholarship}	\N	\N	\N
小学生	しょうがくせい	{}	{"little school student"}	\N	\N	\N
小学校	しょうがっこう	{}	{"primary school"}	\N	\N	\N
召喚	しょうかん	{人を呼び出すこと。特に、裁判所が被告人・証人・鑑定人などに対し、一定の日時に裁判所その他の場所に出頭を命ずること。「証人としてーされる」}	{summons}	\N	\N	\N
償還	しょうかん	{}	{redemption}	\N	\N	\N
将棋	しょうぎ	{}	{"Japanese chess"}	\N	\N	\N
将棋駒	しょうぎごま	{}	{"shougi (chess) piece"}	\N	\N	\N
償却	しょうきゃく	{借金などをすっかり返すこと。償還。払い戻し。減価償却}	{"repayment; depreciation"}	\N	\N	\N
消去	しょうきょ	{}	{"elimination; erasing; dying out; melting away"}	\N	\N	\N
商業	しょうぎょう	{}	{"commerce; trade; business"}	\N	\N	\N
消極的	しょうきょくてき	{}	{passive}	\N	\N	\N
賞金	しょうきん	{}	{"prize; monetary award"}	\N	\N	\N
衝撃	しょうげき	{瞬間的に大きな力を物体に加えること。また、その力。「衝突時の―を吸収する」}	{"〔激しい打撃〕a shock; 〔衝突による〕an impact; crash"}	\N	\N	\N
証券	しょうけん	{財産法上の権利・義務に関する記載のされた紙片。有価証券と証拠証券とがある。}	{"〔債務証書〕a bond; 〔株式証券〕a certificate; 〔為替手形など〕a bill; 〔公債，株券などの有価証券〕securities"}	\N	\N	\N
正午	しょうご	{}	{"noon; mid-day"}	\N	\N	\N
照合	しょうごう	{}	{"collation; comparison"}	\N	\N	\N
昇降機	しょうこうき	{}	{lift}	\N	\N	\N
症候群	しょうこうぐん	{同時に起こる一群の症候。シンドローム。「ネフローゼ―」「頸腕 (けいわん) ―」}	{syndrome}	\N	\N	\N
詳細	しょうさい	{}	{"detail; particulars"}	\N	\N	\N
障子	しょうじ	{}	{"paper sliding door"}	\N	\N	\N
正直	しょうじき	{}	{"honesty; integrity; frankness"}	\N	\N	\N
商社	しょうしゃ	{}	{"trading company; firm"}	\N	\N	\N
詔書	しょうしょ	{}	{"decree; imperial edict"}	\N	\N	\N
少々	しょうしょう	{}	{"just a minute; small quantity"}	\N	{少少}	\N
証拠	しょうこ	{事実・真実を明らかにする根拠となるもの。証左。あかし。しるし。「―を残す」「動かぬ―」「論より―」}	{"evidence; proof"}	\N	\N	\N
昇格	しょうかく	{格式や階級などが上がること。また、上げること。格上げ。昇進。昇任。栄進。「課から部に―する」⇔降格。}	{promotion}	{名,スル}	\N	\N
生じる	しょうじる	{}	{"produce; yield; result from; arise; be generated"}	\N	\N	\N
昇進	しょうしん	{}	{promotion}	\N	\N	\N
精進	しょうじん	{}	{"devotion; diligence"}	\N	\N	\N
小数	しょうすう	{}	{"fraction (part of); decimal"}	\N	\N	\N
少数	しょうすう	{}	{"minority; few"}	\N	\N	\N
称する	しょうする	{名乗る。名づけて言う。「自ら名人と―・する」「論文と―・するほどのものではない」}	{"to pretend; to take the name of; to feign; to purport"}	\N	\N	\N
生ずる	しょうずる	{}	{"cause; arise; be generated"}	\N	\N	\N
小説	しょうせつ	{}	{novel}	\N	\N	\N
肖像	しょうぞう	{人の姿や顔を写した絵の像}	{portrait}	\N	\N	\N
消息	しょうそく	{}	{"news; letter; circumstances"}	\N	\N	\N
招待	しょうたい	{}	{invite}	\N	\N	\N
承諾	しょうだく	{}	{"consent; acquiescence; agreement"}	\N	\N	\N
承知	しょうち	{}	{"consent; agree"}	\N	\N	\N
象徴	しょうちょう	{}	{symbol}	\N	\N	\N
焦点	しょうてん	{}	{"focus; point"}	\N	\N	\N
商店	しょうてん	{}	{"shop; business firm"}	\N	\N	\N
消毒	しょうどく	{}	{"disinfection; sterilization"}	\N	\N	\N
衝突	しょうとつ	{}	{"collision; conflict"}	\N	\N	\N
小児科	しょうにか	{}	{pediatrics}	\N	\N	\N
証人	しょうにん	{}	{witness}	\N	\N	\N
使用人	しようにん	{}	{"employee; servant"}	\N	\N	\N
承認	しょうにん	{そのことが正当または事実であると認めること。「相手の所有権をーする」}	{"approval; consent"}	\N	\N	\N
少年	しょうねん	{}	{"boys; juveniles"}	\N	\N	\N
勝敗	しょうはい	{}	{"victory or defeat; issue (of battle)"}	\N	\N	\N
商売	しょうばい	{}	{"trade; business; commerce; transaction; occupation"}	\N	\N	\N
消費	しょうひ	{}	{"consumption; expenditure"}	\N	\N	\N
商品	しょうひん	{}	{"commodity; goods; stock; merchandise"}	\N	\N	\N
賞品	しょうひん	{}	{"prize; trophy"}	\N	\N	\N
勝負	しょうぶ	{}	{"victory or defeat; match; contest; game; bout"}	\N	\N	\N
消防	しょうぼう	{}	{"fire fighting; fire department"}	\N	\N	\N
消防士	しょうぼうし	{}	{"fire fighter; fire man"}	\N	\N	\N
消防署	しょうぼうしょ	{}	{"fire station"}	\N	\N	\N
正味	しょうみ	{}	{"net (weight)"}	\N	\N	\N
賞味	しょうみ	{食べ物のおいしさをよく味わって食べること。「郷土料理をーする」}	{"enjoy (a dish; food)"}	\N	\N	\N
賞味期限	しょうみきげん	{}	{"expiration date (taste / relish + limit)"}	\N	\N	\N
照明	しょうめい	{}	{illumination}	\N	\N	\N
証明	しょうめい	{}	{"proof; verification"}	\N	\N	\N
正面	しょうめん	{}	{"front; frontage; facade; main"}	\N	\N	\N
庄屋	しょうや	{}	{"a village headman (in the Edo period)"}	\N	\N	\N
醤油	しょうゆ	{}	{"soy sauce"}	\N	\N	\N
将来	しょうらい	{これから先。未来。前途。副詞的にも用いる。「―の日本」「―を期待する」「―のある若者」「―医者になりたい」}	{future}	\N	\N	\N
勝利	しょうり	{}	{"victory; triumph; conquest; success; win"}	\N	\N	\N
省略	しょうりゃく	{}	{"omission; abbreviation; abridgment"}	\N	\N	\N
昇龍裂破	しょうりゅうれっぱ	{}	{"shoryu reppa"}	\N	\N	\N
奨励	しょうれい	{ある事柄を、よいこととして、それをするように人に強く勧めること}	{incentive}	\N	\N	\N
抄録	しょうろく	{}	{"summary; extract (of a book)"}	\N	\N	\N
初級	しょきゅう	{}	{"elementary level"}	\N	\N	\N
職	しょく	{}	{employment}	\N	\N	\N
職員	しょくいん	{}	{"staff member; personnel"}	\N	\N	\N
食塩	しょくえん	{}	{"table salt"}	\N	\N	\N
職業	しょくぎょう	{生計を維持するために、人が日常従事する仕事。生業。職。「教師を―とする」「―につく」「家の―を継ぐ」「―に貴賤 (きせん) なし」}	{"occupation; business"}	\N	\N	\N
食事	しょくじ	{}	{meal}	\N	\N	\N
食卓	しょくたく	{}	{"dining table"}	\N	\N	\N
称す	しょうす	{名乗る。名づけて言う。「自ら名人と―・する」「論文と―・するほどのものではない」}	{"to pretend; to take the name of; to feign; to purport"}	\N	\N	\N
嘱託	しょくたく	{仕事を頼んで任せること。「資料収集をーする」}	{"emporary employee"}	\N	\N	\N
食堂	しょくどう	{}	{"cafeteria; dining room"}	\N	\N	\N
職人	しょくにん	{}	{"worker; mechanic; artisan; craftsman"}	\N	\N	\N
職場	しょくば	{}	{"work place"}	\N	\N	\N
食品	しょくひん	{}	{"commodity; foodstuff"}	\N	\N	\N
植物	しょくぶつ	{}	{"plant; vegetation"}	\N	\N	\N
植民地	しょくみんち	{}	{colony}	\N	\N	\N
職務	しょくむ	{}	{"professional duties"}	\N	\N	\N
食物	しょくもつ	{}	{"food; foodstuff"}	\N	\N	\N
食欲	しょくよく	{}	{"appetite (for food)"}	\N	\N	\N
食糧	しょくりょう	{}	{"provisions; rations"}	\N	\N	\N
食料	しょくりょう	{}	{food}	\N	\N	\N
食料品	しょくりょうひん	{}	{foods}	\N	\N	\N
諸君	しょくん	{}	{"Gentlemen!; Ladies!"}	\N	\N	\N
将軍	しょうぐん	{一軍を指揮して出征する大将のこと。鎌倉時代以降、幕府の主宰者の職名。鎌倉幕府を開いた源頼朝以後、室町幕府の足利 (あしかが) 氏、江戸幕府の徳川氏まで引き継がれた。「鎮東―」}	{"a general; 〔幕府の〕a shogun"}	\N	\N	\N
諸国	しょこく	{多くの国々。いろいろな国。「―を行脚する」「近隣―」}	{"various [all; many] countries; 〔諸地方〕various [all; many] districts"}	\N	\N	\N
書斎	しょさい	{}	{study}	\N	\N	\N
所在	しょざい	{}	{whereabouts}	\N	\N	\N
所持	しょじ	{}	{"possession; owning"}	\N	\N	\N
初旬	しょじゅん	{}	{"first 10 days of the month"}	\N	\N	\N
初心者	しょしんしゃ	{その道に入ったばかりで、まだ未熟な者。習い始め、あるいは覚えたての人。}	{"a beginner; a novice"}	\N	\N	\N
書籍	しょせき	{文章・絵画などを筆写または印刷した紙の束をしっかり綴 (と) じ合わせ、表紙をつけて保存しやすいように作ったもの。巻き物に仕立てることもある。多く、雑誌と区別していう。書物。本。図書。しょじゃく。→電子書籍}	{"book; publication"}	\N	\N	\N
所属	しょぞく	{}	{"attached to; belong to"}	\N	\N	\N
初代	しょだい	{家系・芸道などで、一家を立てた最初の人。また、その人の代。}	{"first (e.g. president)"}	\N	\N	\N
処置	しょち	{その場や状況に応じた判断をし手だてを講じて、物事に始末をつけること。「適切にーする」}	{"treatment; disposal; measures"}	\N	\N	\N
暑中	しょちゅう	{}	{midsummer}	\N	\N	\N
食器	しょっき	{}	{tableware}	\N	\N	\N
所定	しょてい	{}	{"fixed; prescribed"}	\N	\N	\N
書店	しょてん	{}	{bookstore}	\N	\N	\N
書道	しょどう	{}	{calligraphy}	\N	\N	\N
所得	しょとく	{}	{"income; earnings"}	\N	\N	\N
処罰	しょばつ	{}	{punishment}	\N	\N	\N
初版	しょはん	{}	{"first edition"}	\N	\N	\N
書評	しょひょう	{}	{"book review"}	\N	\N	\N
処分	しょぶん	{}	{disposal}	\N	\N	\N
庶民	しょみん	{}	{"masses; common people"}	\N	\N	\N
庶務	しょむ	{}	{"general affairs"}	\N	\N	\N
署名	しょめい	{}	{signature}	\N	\N	\N
書物	しょもつ	{}	{books}	\N	\N	\N
所有	しょゆう	{自分のものとして持っていること。また、そのもの。「多大な財産をーする」「父のーする土地」}	{"possession; proprietary"}	\N	\N	\N
所有者	しょゆうしゃ	{所有している人。所有権のある人。所有主。}	{"proprietary; relating to an owner or ownership"}	\N	\N	\N
処理	しょり	{物事を取りさばいて始末をつけること。「事務を手早く―する」「事後―」「熱―」}	{"processing; dealing with; treatment; disposition; disposal"}	\N	\N	\N
書類	しょるい	{文書・書き付けなどの総称。特に、事務や記録などに関する書き付け。「重要―」}	{"documents; official papers"}	\N	\N	\N
白髪	しらが	{}	{"white or grey hair; trendy hair bleaching"}	\N	\N	\N
知らせ	しらせ	{}	{notice}	\N	\N	\N
知らせる	しらせる	{他の人が知るようにする。言葉やその他の手段で伝える。「手紙で無事を―・せる」「事件を―・せる」「虫が―・せる」}	{"〔分からせる〕let ((a person)) know; 〔告げる〕tell ((a person about [that]))，((文)) inform ((a person of a matter)); 〔暗に知らせる〕suggest"}	\N	\N	\N
報せる	しらせる	{他の人が知るようにする。知らせる}	{report}	\N	\N	\N
知られる	しられる	{知れる、他の人の知るところとなる}	{known}	\N	\N	\N
調べ	しらべ	{}	{"preparation; investigation; inspection"}	\N	\N	\N
調べる	しらべる	{}	{investigate}	\N	\N	\N
尻	しり	{}	{"buttocks; bottom"}	\N	\N	\N
知り合い	しりあい	{}	{acquaintance}	\N	\N	\N
弾	たま	{}	{"bullet; shot; shell"}	\N	\N	\N
私立	しりつ	{}	{"private (e.g. school or detective)"}	\N	\N	\N
資料	しりょう	{研究・調査の基礎となる材料。}	{"materials; data"}	\N	\N	\N
汁	しる	{}	{"juice; sap; soup; broth"}	\N	\N	\N
知る	しる	{}	{"know; understand; be acquainted with; feel"}	\N	\N	\N
記す	しるす	{}	{"to note; to write down"}	\N	\N	\N
指令	しれい	{}	{"orders; instructions; directive"}	\N	\N	\N
白	しろ	{}	{white}	\N	\N	\N
城	しろ	{}	{castle}	\N	\N	\N
代	しろ	{}	{"price; materials; substitution"}	\N	\N	\N
白い	しろい	{}	{white}	\N	\N	\N
素人	しろうと	{}	{"amateur; novice"}	\N	\N	\N
新	しん	{}	{new}	\N	\N	\N
芯	しん	{}	{"core; heart; wick; marrow"}	\N	\N	\N
進化	しんか	{}	{"evolution; progress"}	\N	\N	\N
進学	しんがく	{}	{"going on to university"}	\N	\N	\N
新型	しんがた	{従来のものとは違う、新しい型・形式。また、その製品。「―の車両」}	{"a new style [type]"}	\N	\N	\N
殿	しんがり	{}	{"rear; rear unit guard"}	\N	\N	\N
新幹線	しんかんせん	{}	{"bullet train"}	\N	\N	\N
新規	しんき	{}	{new}	\N	\N	\N
審議	しんぎ	{}	{deliberation}	\N	\N	\N
真空	しんくう	{}	{"vacuum; hollow; empty"}	\N	\N	\N
神経	しんけい	{からだの機能を統率し、刺激を伝える組織。過敏な心の働き。感受性}	{"nerve; sensitivity; nervous"}	\N	\N	\N
真剣	しんけん	{}	{"seriousness; earnestness"}	\N	\N	\N
震源	しんげん	{}	{epicenter}	\N	\N	\N
進行	しんこう	{}	{advance}	\N	\N	\N
信仰	しんこう	{}	{"(religious) faith; belief; creed"}	\N	\N	\N
新興	しんこう	{}	{"rising; developing; emergent"}	\N	\N	\N
振興	しんこう	{}	{"promotion; encouragement"}	\N	\N	\N
侵攻	しんこう	{}	{invasion}	\N	\N	\N
信号	しんごう	{}	{"traffic lights; signal; semaphore"}	\N	\N	\N
申告	しんこく	{}	{"report; statement; filing a return; notification"}	\N	\N	\N
深刻	しんこく	{}	{serious}	\N	\N	\N
新婚	しんこん	{}	{newly-wed}	\N	\N	\N
審査	しんさ	{}	{"judging; inspection; examination; investigation"}	\N	\N	\N
診察	しんさつ	{}	{"medical examination"}	\N	\N	\N
診察券	しんさつけん	{}	{"medical examination card"}	\N	\N	\N
紳士	しんし	{}	{gentleman}	\N	\N	\N
紳士淑女	しんししゅくじょ	{}	{"lady and gentleman"}	\N	\N	\N
寝室	しんしつ	{寝るために使う部屋。ねや。}	{"a bedroom"}	\N	\N	\N
信者	しんじゃ	{}	{"believer; adherent; devotee; Christian"}	\N	\N	\N
真珠	しんじゅ	{}	{pearl}	\N	\N	\N
心中	しんじゅう	{}	{"double suicide; lovers suicide"}	\N	\N	\N
進出	しんしゅつ	{}	{"advance; step forward"}	\N	\N	\N
心情	しんじょう	{}	{mentality}	\N	\N	\N
信じる	しんじる	{}	{"believe; believe in; place trust in; confide in; have faith in"}	\N	\N	\N
心身	しんしん	{}	{"mind and body"}	\N	\N	\N
新人	しんじん	{}	{"new face; newcomer"}	\N	\N	\N
信ずる	しんずる	{}	{"believe; believe in; place trust in; confide in; have faith in"}	\N	\N	\N
神聖	しんせい	{}	{"holiness; sacredness; dignity"}	\N	\N	\N
申請	しんせい	{}	{"application; request; petition"}	\N	\N	\N
親切	しんせつ	{}	{kind}	\N	\N	\N
新鮮	しんせん	{}	{fresh}	\N	\N	\N
親善	しんぜん	{}	{friendship}	\N	\N	\N
真相	しんそう	{ある物事の真実のすがた。特に、事件などの、本当の事情・内容。}	{"truth; fact"}	\N	\N	\N
心臓	しんぞう	{}	{heart}	\N	\N	\N
心臓発作	しんぞうほっさ	{}	{"heart attack"}	\N	\N	\N
寝台	しんだい	{}	{"bed; couch"}	\N	\N	\N
診断	しんだん	{}	{diagnosis}	\N	\N	\N
新築	しんちく	{}	{"new building; new construction"}	\N	\N	\N
慎重	しんちょう	{}	{"discretion; prudence"}	\N	\N	\N
身長	しんちょう	{}	{"height (of body); stature"}	\N	\N	\N
慎重な	しんちょうな	{注意深い・思慮深い・用心深い}	{"prudently; carefully"}	\N	\N	\N
進呈	しんてい	{}	{presentation}	\N	\N	\N
進展	しんてん	{}	{"progress; development"}	\N	\N	\N
海路	うみじ	{}	{"sea route"}	\N	\N	\N
親戚	しんせき	{血縁や婚姻によって結びつきのある人。親類。}	{relative}	\N	\N	\N
神殿	しんでん	{}	{"temple; sacred place"}	\N	\N	\N
進度	しんど	{}	{progress}	\N	\N	\N
深度	しんど	{深さの程度・度合い。「焦点―」}	{depth}	\N	\N	\N
神道	しんとう	{}	{Shinto}	\N	\N	\N
振動	しんどう	{揺れ動くこと。「爆音でガラス戸が―する」}	{"vibration; oscillation"}	\N	\N	\N
侵入	しんにゅう	{}	{"penetration; invasion; raid; aggression; trespass"}	\N	\N	\N
新入生	しんにゅうせい	{}	{"freshman; first-year student"}	\N	\N	\N
信任	しんにん	{}	{"trust; confidence; credence"}	\N	\N	\N
心配	しんぱい	{}	{"worry; concern; anxiety; care"}	\N	\N	\N
神秘	しんぴ	{}	{mystery}	\N	\N	\N
新聞	しんぶん	{}	{newspaper}	\N	\N	\N
新聞社	しんぶんしゃ	{}	{"newspaper office"}	\N	\N	\N
進歩	しんぽ	{}	{"progress; development"}	\N	\N	\N
辛抱	しんぼう	{}	{"patience; endurance"}	\N	\N	\N
審問	しんもん	{}	{"an inquiry ((into)); 〔聴問〕a hearing"}	\N	\N	\N
深夜	しんや	{}	{"late at night"}	\N	\N	\N
親友	しんゆう	{}	{"close friend"}	\N	\N	\N
信頼	しんらい	{}	{"reliance; trust; confidence"}	\N	\N	\N
辛辣	しんらつ	{言うことや他に与える批評の、きわめて手きびしいさま。「―をきわめる」「―な風刺漫画」}	{"〜な acerbic; sharp; sarcastic; sardonic"}	\N	\N	\N
真理	しんり	{}	{truth}	\N	\N	\N
心理	しんり	{}	{mentality}	\N	\N	\N
侵略	しんりゃく	{}	{"aggression; invasion; raid"}	\N	\N	\N
診療	しんりょう	{}	{"medical examination and treatment; diagnosis"}	\N	\N	\N
診療所	しんりょうしょ	{}	{"clinic (local)"}	\N	\N	\N
森林	しんりん	{}	{"forest; woods"}	\N	\N	\N
親類	しんるい	{}	{"relation; kin"}	\N	\N	\N
針路	しんろ	{}	{"course; direction; compass bearing"}	\N	\N	\N
進路	しんろ	{}	{"course; route"}	\N	\N	\N
神話	しんわ	{}	{"myth; legend"}	\N	\N	\N
掃除	そうじ	{}	{"cleaning; sweeping"}	\N	\N	\N
葬式	そうしき	{}	{funeral}	\N	\N	\N
審判	しんばん	{}	{"refereeing; trial; judgement; umpire; referee"}	\N	\N	\N
葦	あし	{}	{"ditch reed"}	{植物}	\N	\N
芦	あし	{}	{"hollow reed"}	{植物}	\N	\N
杏子	あんず	{}	{"あんy apricot brand will do+椅子"}	{植物}	\N	\N
梅	うめ	{}	{"plum; plum-tree; lowest (of a three-tier ranking system)"}	{植物}	\N	\N
荻	おぎ	{}	{reed}	{植物}	\N	\N
柿	かき	{}	{"kaki; persimon"}	{植物}	\N	\N
信用	しんよう	{"1 確かなものと信じて受け入れること。「相手の言葉を―する」",それまでの行為・業績などから、信頼できると判断すること。また、世間が与える、そのような評価。人望。名望。声望。信望。「―を得る」「―を失う」「―の置けない人物」「店の―に傷がつく」}	{"〔信頼〕confidence (in); trust (in); faith (in); reliance (on)",〔評判〕reputation〔取り引き相手の信用度〕credit}	{名,スル}	\N	\N
添う	そう	{}	{"to accompany; to become married; to comply with"}	\N	\N	\N
沿う	そう	{}	{"to run along; to follow"}	\N	\N	\N
僧	そう	{}	{"monk; priest"}	\N	\N	\N
総	そう	{}	{"whole; all; general; gross"}	\N	\N	\N
相違	そうい	{}	{"difference; discrepancy; variation"}	\N	\N	\N
相応	そうおう	{}	{"suitability; fitness"}	\N	\N	\N
騒音	そうおん	{}	{noise}	\N	\N	\N
総会	そうかい	{}	{"general meeting"}	\N	\N	\N
爽快	そうかい	{}	{"refreshing; exhilarating"}	\N	\N	\N
総括	そうかつ	{概要}	{"generalization; summary"}	\N	\N	\N
創刊	そうかん	{}	{"launching (e.g. newspaper); first issue"}	\N	\N	\N
創業	そうぎょう	{事業を始めること。会社や店を新しく興すこと。「―して百年になる」}	{"the establishment [founding] of a business"}	\N	\N	\N
送金	そうきん	{}	{"remittance; sending money"}	\N	\N	\N
総計	そうけい	{全体をひっくるめて計算すること。また、その合計。「一か月の支出を―する」→小計}	{"the total [sum]"}	\N	\N	\N
倉庫	そうこ	{}	{"storehouse; warehouse"}	\N	\N	\N
相互	そうご	{}	{"mutual; reciprocal"}	\N	\N	\N
走行	そうこう	{}	{"running a wheeled vehicle (e.g. car); traveling"}	\N	\N	\N
総合	そうごう	{}	{"synthesis; coordination; putting together; integration; composite"}	\N	\N	\N
操作	そうさ	{}	{"operation; management; processing"}	\N	\N	\N
捜査	そうさ	{}	{"search (esp. in criminal investigations); investigation"}	\N	\N	\N
総裁	そうさい	{政党・銀行・公社などの長として、全体を取りまとめる職務。また、その人。「―選挙」「日銀―」}	{"president (総裁候補)"}	\N	\N	\N
総裁候補	そうさいこうほ	{}	{"government candidate"}	\N	\N	\N
捜査官	そうさかん	{}	{"(police) investigator"}	\N	\N	\N
捜索	そうさく	{}	{"search (esp. for someone or something missing); investigation"}	\N	\N	\N
創作	そうさく	{}	{"production; literary creation; work"}	\N	\N	\N
葬儀	そうぎ	{死者をほうむる儀式。葬式。とむらい。}	{Funeral}	\N	\N	\N
操縦	そうじゅう	{}	{"management; handling; control; manipulation"}	\N	\N	\N
操縦士	そうじゅうし	{}	{pilot}	\N	\N	\N
装飾	そうしょく	{}	{ornament}	\N	\N	\N
送信	そうしん	{信号を送ること。特に、電気信号を遠方に送ること。「緊急信号を―する」「メールを―する」⇔受信。}	{"transmission (of a message)"}	\N	\N	\N
創設	そうせつ	{}	{"founding; establishment"}	\N	\N	\N
創造	そうぞう	{}	{creation}	\N	\N	\N
想像	そうぞう	{}	{"imagination; guess"}	\N	\N	\N
騒々しい	そうぞうしい	{}	{"noisy; boisterous"}	\N	\N	\N
相続	そうぞく	{}	{"succession; inheritance"}	\N	\N	\N
壮大	そうだい	{}	{"magnificent; grand; majestic; splendid"}	\N	\N	\N
相談	そうだん	{問題の解決のために話し合ったり、他人の意見を聞いたりすること。また、その話し合い。「―がまとまる」「―に乗る」「友人に―する」「身の上―」}	{"consultation; discussion"}	\N	\N	\N
装置	そうち	{}	{"equipment; installation; apparatus"}	\N	\N	\N
漕艇	そうてい	{}	{"rowing boat"}	\N	\N	\N
相当	そうとう	{}	{"suitable; fair; tolerable; proper; extremely"}	\N	\N	\N
騒動	そうどう	{}	{"strife; riot; rebellion"}	\N	\N	\N
遭難	そうなん	{}	{"disaster; shipwreck; accident"}	\N	\N	\N
挿入	そうにゅう	{中にさし入れること。中にはさみこむこと。「イラストを―する」}	{"(an) insertion (into)"}	\N	\N	\N
相場	そうば	{}	{"market price; speculation; estimation"}	\N	\N	\N
装備	そうび	{必要な機器などを取り付けること。戦闘・登山など特定の目的に応じた用具をそろえたり身につけたりすること。また、その機器や用具。「魚探機をーする」「冬山用のー」}	{equipment}	\N	\N	\N
送別	そうべつ	{}	{"farewell; send-off"}	\N	\N	\N
総理大臣	そうりだいじん	{}	{"Prime Minister"}	\N	\N	\N
創立	そうりつ	{}	{"establishment; founding; organization"}	\N	\N	\N
僧侶	そうりょ	{}	{"a priest⇒そう(僧)"}	\N	\N	\N
送料	そうりょう	{}	{postage}	\N	\N	\N
疎遠	そえん	{遠ざかって関係が薄いこと。音信や訪問が久しく途絶えていること。また、そのさま。「平素の―をわびる」「―になる」「―な間柄」}	{"alienate; estrange; drift (apart)"}	\N	\N	\N
即座に	そくざに	{}	{"immediately; right away"}	\N	\N	\N
即死	そくし	{事故などにあったその時点ですぐさま死ぬこと。「―状態」}	{"instant death"}	\N	\N	\N
促進	そくしん	{}	{"promotion; acceleration; encouragement; facilitation; spurring on"}	\N	\N	\N
即時	そくじ	{すぐその時。即刻。また、短時間。副詞的にも用いる。「ーの判断が要求される」「ー徹退せよ」「ー通話」}	{"instantly; promptly; at once; 〔その場で〕on the spot"}	\N	\N	\N
側室	そくしつ	{貴人のめかけ。そばめ。⇔正室／嫡室。}	{"a nobleman's concubine [mistress]"}	\N	\N	\N
即する	そくする	{}	{"to conform to; to agree with; to be adapted to; to be based on"}	\N	\N	\N
速達	そくたつ	{}	{"express; special delivery"}	\N	\N	\N
測定	そくてい	{}	{measurement}	\N	\N	\N
速度	そくど	{}	{"speed; velocity; rate"}	\N	\N	\N
束縛	そくばく	{}	{"restraint; shackles; restriction; confinement; binding"}	\N	\N	\N
側面	そくめん	{}	{"side; flank; sidelight; lateral"}	\N	\N	\N
測量	そくりょう	{}	{"measurement; surveying"}	\N	\N	\N
速力	そくりょく	{}	{speed}	\N	\N	\N
狙撃	そげき	{狙い撃ち}	{sniping}	\N	\N	\N
其処	そこ	{}	{"that place; there"}	\N	\N	\N
底	そこ	{}	{"bottom; sole"}	\N	\N	\N
損なう	そこなう	{}	{"to harm; to hurt; to injure; to damage; to fail in doing"}	\N	\N	\N
其処ら	そこら	{}	{"everywhere; somewhere; approximately; that area; around there"}	\N	\N	\N
素材	そざい	{もとになる材料。原料。材料}	{material}	\N	\N	\N
阻止	そし	{妨げること。くいとめること。はばむこと。「反対派の入場を―する」}	{"obstruction; check; hindrance; prevention; interdiction"}	\N	\N	\N
早熟	そうじゅく	{肉体や精神の発育が普通より早いこと。また、そのさま。「―な娘」⇔晩熟。}	{"precocity; (advanced; old beyond one's years; forward; ahead of one's peers; mature)"}	\N	\N	\N
組織	そしき	{}	{"organization; structure; construction; tissue; system"}	\N	\N	\N
素質	そしつ	{}	{"character; qualities; genius"}	\N	\N	\N
然して	そして	{}	{and}	\N	\N	\N
訴訟	そしょう	{}	{"litigation; lawsuit"}	\N	\N	\N
租税	そぜい	{国または地方公共団体が、その経費に充てるために、法律に基づいて国民や住民から強制的に徴収する金銭。国税と地方税とがある。税。税金。}	{taxes⇒ぜいきん(税金)}	\N	\N	\N
祖先	そせん	{}	{ancestor}	\N	\N	\N
育ち	そだち	{}	{"breeding; growth"}	\N	\N	\N
育つ	そだつ	{}	{"bring up; be brought up; grow (up)"}	\N	\N	\N
育てる	そだてる	{}	{"bring up"}	\N	\N	\N
措置	そち	{事態に応じて必要な手続きをとること。取り計らって始末をつけること。処置。「万全のーをとる」「適当にーする」}	{"a measure (against); a step"}	\N	\N	\N
其方	そちら	{}	{"over there; the other"}	\N	\N	\N
卒	そつ	{}	{-graduate}	\N	\N	\N
卒業	そつぎょう	{}	{graduate}	\N	\N	\N
卒論	そつろん	{大学の学部の学生が卒業に際して提出し、審査を受ける論文。}	{"a graduation thesis"}	\N	\N	\N
卒業論文	そつぎょうろんぶん	{大学の学部の学生が卒業に際して提出し、審査を受ける論文。}	{"a graduation thesis"}	\N	\N	\N
素っ気ない	そっけない	{}	{"cold; short; curt; blunt"}	\N	\N	\N
外方	そっぽ	{}	{"look (or turn) the other way"}	\N	\N	\N
袖	そで	{}	{sleeve}	\N	\N	\N
備え付ける	そなえつける	{}	{"to provide; to furnish; to equip; to install"}	\N	\N	\N
具える	そなえる	{}	{"furnish; provide for; equip; install; have ready; prepare for; possess; have; be endowed with; be armed with"}	\N	\N	\N
備える	そなえる	{ある事態が起こったときにうろたえないように、また、これから先に起こる事態に対応できるように準備しておく。心構えをしておく。「万一に―・える」「地震に―・える」「試験に―・えて夜遅くまで勉強する」}	{"to furnish; to provide for; to equip; to install; to have ready; to prepare for; to possess; to have; to be endowed with; to be armed with"}	\N	\N	\N
備わる	そなわる	{}	{"to be furnished with; to be endowed with; to possess; to be among; to be one of; to be possessed of"}	\N	\N	\N
その上	そのうえ	{}	{"in addition; furthermore"}	\N	\N	\N
其の度	そのたび	{ある事が行われたり、ある状況になったりすると、決まって生じるさま。その時々・その時その時・決まって・いつも}	{"whenever; each time"}	\N	\N	\N
そのたび	其の度	{ある事が行われたり、ある状況になったりすると、決まって生じるさま。その時々・その時その時・決まって・いつも}	{"whenever; each time"}	\N	\N	\N
その為	そのため	{}	{"hence; for that reason"}	\N	\N	\N
その外	そのほか	{}	{"besides; in addition; the rest"}	\N	\N	\N
蕎麦	そば	{穀物のソバの実を原料とする蕎麦粉を用いて加工した、日本の麺類の一種、および、それを用いた料理である。}	{"soba (buckwheat noodles)"}	\N	\N	\N
祖父	そふ	{}	{"grand father"}	\N	\N	\N
祖母	そぼ	{}	{"grand mother"}	\N	\N	\N
素朴	そぼく	{}	{"simplicity; artlessness; naivete"}	\N	\N	\N
粗末	そまつ	{}	{"crude; rough; plain; humble"}	\N	\N	\N
染まる	そまる	{}	{"to dye"}	\N	\N	\N
背く	そむく	{}	{"to run counter to; to go against; to disobey; to infringe"}	\N	\N	\N
染める	そめる	{}	{"to dye; to colour"}	\N	\N	\N
抑	そもそも	{最初。発端。副詞的にも用いる。元々。大体「この話には―から反対だった」「目的が―違う」}	{"in the first place; from the beginning"}	\N	\N	\N
注ぐ	そそぐ	{}	{"pour (into); fill; irrigate; pay; feed (a fire)"}	\N	\N	\N
外	そと	{}	{"other place; the rest"}	\N	\N	\N
園	その	{}	{"garden; park; plantation"}	\N	\N	\N
側	そば	{}	{"near; close; beside; vicinity; proximity; besides; while"}	\N	\N	\N
卒直	そっちょく	{}	{"frankness; candour; openheartedness"}	\N	{率直}	\N
其の後	そのご	{ある事があったあと。それ以来。以後。副詞的にも用いる。「事件の―は知らない」「―いかがお過ごしですか」}	{"after that"}	\N	{その後}	\N
逸らす	そらす	{}	{"to turn away; to avert"}	\N	\N	\N
反り	そり	{}	{"warp; curvature; curve; arch"}	\N	\N	\N
剃る	そる	{毛髪やひげなどを、かみそりなどで根元からきれいに切り落とす。「ひげを―・る」}	{"shave (hair)"}	\N	\N	\N
其れ	それ	{}	{"〔相手に近い物〕that; it"}	\N	\N	\N
それでは	それでは	{前に示された事柄を受けて、それに対する判断・意見などを導く。そういうことなら。それなら。では。それじゃ。「ーいずれ手にはいるね」「ーこうしたらどうか」}	{"Well then; all right; So..; now..;"}	\N	\N	\N
それじゃ	それじゃ	{前に示された事柄を受けて、それに対する判断・意見などを導く。そういうことなら。それなら。では。それでは。「ーいずれ手にはいるね」「ーこうしたらどうか」}	{"Well then; all right; So..; now..;"}	\N	\N	\N
其れ程	それほど	{}	{"to that degree; extent"}	\N	\N	\N
其れ故	それゆえ	{}	{"therefore; for that reason; so"}	\N	\N	\N
逸れる	それる	{}	{"stray from subject; get lost; go astray"}	\N	\N	\N
揃える	そろえる	{二つ以上のものの、形・大きさなどを同じにする。「ひもの長さをー・える」「彼とセーターの柄を＿・える」}	{"carries; gathers"}	\N	\N	\N
算盤	そろばん	{}	{abacus}	\N	\N	\N
損	そん	{}	{"loss; disadvantage"}	\N	\N	\N
損害	そんがい	{}	{"damage; injury; loss"}	\N	\N	\N
尊敬	そんけい	{}	{"respect; esteem; reverence; honour"}	\N	\N	\N
存在	そんざい	{}	{"existence; being"}	\N	\N	\N
損失	そんしつ	{}	{loss}	\N	\N	\N
存続	そんぞく	{}	{"duration; continuance"}	\N	\N	\N
尊重	そんちょう	{}	{"respect; esteem; regard"}	\N	\N	\N
損得	そんとく	{}	{"loss and gain; advantage and disadvantage"}	\N	\N	\N
そんな	そんな	{聞き手、または、そのそばにいる人が当面している事態や、現に置かれている状況がそのようであるさま。それほどの。そのような。「―話は聞いたことがない」「―に嫌ならやめなさい」}	{"(all) that; such (a fuss); very  (much)"}	\N	\N	\N
すっかり	すっかり	{残るもののないさま。ことごとく。まったく。完全に。}	{"completely; really (aged; pleased)"}	\N	\N	\N
清々しい	すがすがしい	{さわやかで気持ちがいい。涼しい}	{refreshing}	\N	\N	\N
即ち	すなわち	{前に述べた事を別の言葉で説明しなおすときに用いる。言いかえれば。つまり。}	{"namely; that is (to say); or"}	\N	\N	\N
術	すべ	{方法や道など}	{"a way; means"}	\N	\N	\N
酢	す	{}	{vinegar}	\N	\N	\N
巣	す	{}	{"nest; rookery; breeding place; beehive; cobweb; den"}	\N	\N	\N
水位	すいい	{一定の基準面から測った水面の高さ。}	{"water level"}	\N	\N	\N
推移	すいい	{時がたつにつれて状態が変化すること。移り変わっていくこと。「情勢が―する」}	{"〔変化〕a change; 〔移行〕a transition"}	\N	\N	\N
水泳	すいえい	{}	{swimming}	\N	\N	\N
西瓜	すいか	{}	{watermelon}	\N	\N	\N
水気	すいき	{}	{"moisture; dampness; vapor; dropsy; edema"}	\N	\N	\N
水源	すいげん	{}	{"source of river; fountainhead"}	\N	\N	\N
水産	すいさん	{}	{"marine products; fisheries"}	\N	\N	\N
水死	すいし	{水におぼれて死ぬこと。溺死(できし)。「池にはまって―する」}	{"death from drowning"}	\N	\N	\N
水死体	すいしたい	{}	{"corpse of a drowned individual"}	\N	\N	\N
炊事	すいじ	{}	{"cooking; culinary arts"}	\N	\N	\N
水準	すいじゅん	{}	{"water level; level; standard"}	\N	\N	\N
水晶	すいしょう	{}	{crystal}	\N	\N	\N
水蒸気	すいじょうき	{}	{"water vapour; steam"}	\N	\N	\N
推進	すいしん	{物を前へおし進めること。「スクリューで＿する」}	{"promote; propel"}	\N	\N	\N
水洗	すいせん	{}	{flushing}	\N	\N	\N
推薦	すいせん	{}	{recommendation}	\N	\N	\N
推薦状	すいせんじょう	{}	{"Letter of recommendation"}	\N	\N	\N
水素	すいそ	{}	{hydrogen}	\N	\N	\N
吹奏	すいそう	{}	{"playing wind instruments"}	\N	\N	\N
推測	すいそく	{}	{"guess; conjecture"}	\N	\N	\N
衰退	すいたい	{減少}	{decline}	\N	\N	\N
垂直	すいちょく	{}	{"vertical; perpendicular"}	\N	\N	\N
推定	すいてい	{}	{"presumption; assumption; estimation"}	\N	\N	\N
水滴	すいてき	{}	{"drop of water"}	\N	\N	\N
家賃	やちん	{}	{rent}	\N	\N	\N
各々	それぞれ	{}	{"each; every; either; respectively; severally"}	\N	{各各}	\N
水田	すいでん	{}	{"(water-filled) paddy field"}	\N	\N	\N
水筒	すいとう	{}	{"canteen; flask; water bottle"}	\N	\N	\N
水道	すいどう	{}	{"water works"}	\N	\N	\N
水分	すいぶん	{}	{moisture}	\N	\N	\N
水平	すいへい	{}	{"water level; horizon"}	\N	\N	\N
水平線	すいへいせん	{}	{horizon}	\N	\N	\N
睡眠	すいみん	{}	{sleep}	\N	\N	\N
水曜	すいよう	{}	{Wednesday}	\N	\N	\N
水曜日	すいようび	{}	{Wednesday}	\N	\N	\N
推理	すいり	{}	{"reasoning; inference; mystery or detective genre (movie novel etc.)"}	\N	\N	\N
吸う	すう	{}	{"to smoke; breathe in; sip; suck"}	\N	\N	\N
数学	すうがく	{}	{mathematics}	\N	\N	\N
崇敬	すうけい	{あがめうやまうこと。尊崇。「生き仏として―する」「―の念」}	{"veneration; adoration"}	\N	\N	\N
数詞	すうし	{}	{numeral}	\N	\N	\N
数字	すうじ	{}	{"numeral; figure"}	\N	\N	\N
崇拝	すうはい	{}	{"worship; adoration; admiration; cult"}	\N	\N	\N
数量	すうりょう	{}	{quantity}	\N	\N	\N
据え付ける	すえつける	{}	{"to install; to equip; to mount"}	\N	\N	\N
末っ子	すえっこ	{}	{"youngest child"}	\N	\N	\N
据える	すえる	{}	{"to set (table); to lay (foundation); to place (gun); to apply (moxa)"}	\N	\N	\N
姿	すがた	{}	{"figure; shape; appearance"}	\N	\N	\N
好き	すき	{}	{"liking; fondness; love"}	\N	\N	\N
過ぎ	すぎ	{}	{"past; after"}	\N	\N	\N
好き嫌い	すききらい	{}	{"likes and dislikes; taste"}	\N	\N	\N
好き好き	すきずき	{}	{"matter of taste"}	\N	\N	\N
透き通る	すきとおる	{}	{"be or become transparent"}	\N	\N	\N
隙間	すきま	{}	{"crevice; crack; gap; opening"}	\N	\N	\N
過ぎる	すぎる	{}	{pass}	\N	\N	\N
直ぐ	すぐ	{}	{"immediately; soon; easily; right (near); honest; upright"}	\N	\N	\N
救い	すくい	{}	{"help; aid; relief"}	\N	\N	\N
巣喰う	すくう	{悪い考えや病気などが宿る「妄想が―・う」「病魔が―・う」}	{"infest; build a nest"}	\N	\N	\N
救う	すくう	{}	{"rescue from; help out of"}	\N	\N	\N
少ない	すくない	{}	{"few; a little; scarce; insufficient; seldom"}	\N	\N	\N
少なくとも	すくなくとも	{}	{"at least"}	\N	\N	\N
優れる	すぐれる	{}	{"surpass; outstrip; excel"}	\N	\N	\N
凄い	すごい	{}	{"terrible; dreadful; terrific; amazing; great; wonderful; to a great extent"}	\N	\N	\N
少し	すこし	{}	{"small quantity; little; few; something; little while; short distance"}	\N	\N	\N
少しずつ	すこしずつ	{}	{little-by-little}	\N	\N	\N
少しも	すこしも	{}	{"anything of; not one bit"}	\N	\N	\N
過ごす	すごす	{}	{"pass; spend; go through; tide over"}	\N	\N	\N
健やか	すこやか	{}	{"vigorous; healthy; sound"}	\N	\N	\N
濯ぐ	すすぐ	{}	{"to rinse; to wash out"}	\N	\N	\N
進み	すすみ	{}	{progress}	\N	\N	\N
進む	すすむ	{}	{"make progress; advance; improve"}	\N	\N	\N
勧め	すすめ	{}	{"recommendation; advice; encouragement"}	\N	\N	\N
進める	すすめる	{}	{"advance; promote; hasten"}	\N	\N	\N
勧める	すすめる	{}	{"recommend; advise; encourage"}	\N	\N	\N
薦める	すすめる	{ある人や物をほめて、採用するように説く。推薦する。「有望株を―・める」}	{recommend}	\N	\N	\N
鈴	すず	{}	{bell}	\N	\N	\N
涼しい	すずしい	{}	{"cool; refreshing"}	\N	\N	\N
裾	すそ	{}	{"(trouser) cuff; (skirt) hem; cut edge of a hairdo; foot of mountain"}	\N	\N	\N
廃れる	すたれる	{}	{"to go out of use; to become obsolete; to die out; to go out of fashion"}	\N	\N	\N
酸っぱい	すっぱい	{}	{"sour; acid"}	\N	\N	\N
素敵	すてき	{}	{"lovely; dreamy; beautiful; great; fantastic; superb; cool; capital"}	\N	\N	\N
既にして	すでにして	{そうこうしているうちに。かれこれする間に。やがて。}	{"in the meantime; soon; before long"}	\N	\N	\N
捨てる	すてる	{}	{throw}	\N	\N	\N
既に	すでに	{ある動作が過去に行われていたことを表す。以前に。前に。「―述べた事柄」}	{"already; too late"}	\N	{已に}	\N
筋	すじ	{筋肉。また、その線維。「肩の―が凝る」,皮膚の表面に浮き上がってみえる血管。「―の浮き出た手」「額に―を立てて怒る」,家系。家柄。「貴族の―を引く」,物事の道理。すじみち。「―の通った話」,小説や演劇などの、大体の内容。梗概 (こうがい) 。「芝居の―」}	{"〔筋肉の繊維〕(a) sinew; muscle; 〔腱〕a tendon","〔血管〕a vein⇒あおすじ(青筋)","〔血統〕((文)) (a) lineage","〔道理〕reason; logic","〔物語の〕a plot"}	\N	\N	\N
棄てる	すてる	{不用のものとして、手元から放す。ほうる。投棄する。「ごみを―・てる」「武器を―・てて投降する」⇔拾う。}	{"throw away; cast aside; abandon; resign"}	\N	\N	\N
砂	すな	{}	{sand}	\N	\N	\N
素早い	すばやい	{}	{"fast; quick; prompt; agile"}	\N	\N	\N
素晴らしい	すばらしい	{}	{"wonderful; splendid; magnificent"}	\N	\N	\N
全て	すべて	{}	{"all; the whole; entirely; in general; wholly"}	\N	\N	\N
滑る	すべる	{}	{"to slide; to slip; to glide"}	\N	\N	\N
住まい	すまい	{}	{"dwelling; house; residence; address"}	\N	\N	\N
澄ます	すます	{}	{"to clear; to make clear; to be unruffled; to look unconcerned; to look demure; look prim; put on airs"}	\N	\N	\N
済ます	すます	{}	{"to finish; to get it over with; to settle; to conclude; to pay back"}	\N	\N	\N
済ませる	すませる	{}	{"be finished"}	\N	\N	\N
済まない	すまない	{}	{"sorry (phrase)"}	\N	\N	\N
墨	すみ	{}	{ink}	\N	\N	\N
隅	すみ	{}	{corner}	\N	\N	\N
住む	すむ	{}	{"abide; reside; live in; inhabit; dwell"}	\N	\N	\N
清む	すむ	{}	{"to clear (e.g. weather); become transparent"}	\N	\N	\N
澄む	すむ	{}	{"to clear (e.g. weather); to become transparent"}	\N	\N	\N
済む	すむ	{}	{end}	\N	\N	\N
相撲	すもう	{}	{"sumo wrestling"}	\N	\N	\N
刷り	すり	{}	{printing}	\N	\N	\N
刷る	する	{}	{"print; publish"}	\N	\N	\N
鋭い	するどい	{}	{"pointed; sharp"}	\N	\N	\N
擦れ違い	すれちがい	{}	{"chance encounter"}	\N	\N	\N
すれ違う	すれちがう	{}	{"to pass by one another; to disagree; to miss each other"}	\N	\N	\N
擦れる	すれる	{}	{"to rub; to chafe; to wear; to become sophisticated"}	\N	\N	\N
座る	すわる	{}	{sit}	\N	\N	\N
寸前	すんぜん	{}	{"on the verge; just (before)"}	\N	\N	\N
寸法	すんぽう	{}	{"measurement; size; dimension"}	\N	\N	\N
田	た	{}	{"rice field"}	\N	\N	\N
他意	たい	{}	{"ill will; malice; another intention; secret purpose; ulterior motive; fickleness; double-mindedness"}	\N	\N	\N
対	たい	{}	{"ratio; versus; against; opposition"}	\N	\N	\N
体育	たいいく	{}	{"physical education; gymnastics; athletics"}	\N	\N	\N
退院	たいいん	{}	{"leave hospital"}	\N	\N	\N
対応	たいおう	{}	{"interaction; correspondence; coping with; dealing with"}	\N	\N	\N
体温	たいおん	{}	{"temperature (body)"}	\N	\N	\N
退化	たいか	{}	{"degeneration; retrogression"}	\N	\N	\N
大会	たいかい	{}	{"convention; tournament; mass meeting; rally"}	\N	\N	\N
大概	たいがい	{}	{"in general; mainly"}	\N	\N	\N
体格	たいかく	{}	{"physique; constitution"}	\N	\N	\N
退学	たいがく	{}	{"dropping out of school"}	\N	\N	\N
体幹	たいかん	{体の主要部分。胴体のこと。また、その部分にある筋肉。コア。「―を鍛える運動器具」}	{core}	\N	\N	\N
体感	たいかん	{からだで感じること。また、からだが受ける感じ。}	{"a feeling in the body; a bodily sensation"}	\N	\N	\N
体感温度	たいかんおんど	{からだに感じる暑さ・寒さなどの度合いを数量で表したもの。気温のほか風速・湿度・日射なども関係する。実効温度・不快指数などがある。}	{"sensible temperature"}	\N	\N	\N
大気	たいき	{}	{atmosphere}	\N	\N	\N
待遇	たいぐう	{}	{"treatment; reception"}	\N	\N	\N
退屈	たいくつ	{}	{"tedium; boredom"}	\N	\N	\N
体系	たいけい	{}	{"system; organization"}	\N	\N	\N
対決	たいけつ	{}	{"confrontation; showdown"}	\N	\N	\N
体験	たいけん	{}	{"personal experience"}	\N	\N	\N
太鼓	たいこ	{}	{"drum; tambourine"}	\N	\N	\N
対抗	たいこう	{}	{"opposition; antagonism"}	\N	\N	\N
滞在	たいざい	{}	{"stay; staying「不法滞在者：illegal immigrant」"}	\N	\N	\N
耐える	たえる	{}	{"to bear; to endure"}	\N	\N	\N
絶える	たえる	{}	{"to die out; to peter out; to become extinct"}	\N	\N	\N
他	た	{}	{"other (especially people and abstract matters)"}	\N	\N	\N
臑	すね	{膝 (ひざ) からくるぶしまでの間の部分。はぎ。}	{"〔向こうずね〕the shin"}	\N	{脛}	\N
大金	たいきん	{多額の金銭。大きな金高 (きんだか) 。「―をはたく」}	{"a large sum of money"}	\N	\N	\N
素直	すなお	{性質・態度などが、穏やかでひねくれていないさま。従順。柔順。「―な性格」「―に答える」}	{"〔穏やかな〕gentle; mild〔従順な〕obedient〔おとなしい〕meek"}	\N	\N	\N
対策	たいさく	{相手の態度や事件の状況に対応するための方法・手段。「人手不足の―を立てる」「―を練る」「税金―」}	{"〔方策〕measures; a step; 〔対抗策〕a countermeasure"}	\N	\N	\N
大使	たいし	{}	{ambassador}	\N	\N	\N
退治	たいじ	{}	{extermination}	\N	\N	\N
胎児	たいじ	{}	{fetus}	\N	\N	\N
大使館	たいしかん	{}	{embassy}	\N	\N	\N
大した	たいした	{}	{"considerable; great; important; significant; a big deal"}	\N	\N	\N
大して	たいして	{}	{"(not so) much; (not) very"}	\N	\N	\N
対して	たいして	{}	{"for; in regard to; per"}	\N	\N	\N
大衆	たいしゅう	{}	{"general public"}	\N	\N	\N
対処	たいしょ	{}	{"deal with; cope"}	\N	\N	\N
対照	たいしょう	{}	{"contrast; antithesis; comparison"}	\N	\N	\N
対象	たいしょう	{行為の目標となるもの。めあて。「幼児をーとする絵本」「調査のー」}	{"object; subject; target"}	\N	\N	\N
対象外	たいしょうがい	{}	{"not covered (by); not subject (to); exempt"}	\N	\N	\N
退職	たいしょく	{}	{"retirement (from office)"}	\N	\N	\N
対人	たいじん	{}	{interpersonal}	\N	\N	\N
対人恐怖症	たいじんきょうふしょう	{}	{"social phobia"}	\N	\N	\N
対する	たいする	{}	{"face; confront; oppose"}	\N	\N	\N
体勢	たいせい	{からだの構え。姿勢。「崩れた―を立て直す」}	{"a posture; a physical position [stance]"}	\N	\N	\N
大勢	たいせい	{物事の一般的な傾向。大体の状況。「試合の―が決まる」「―に影響はない」}	{"〔大体の情勢〕the general situation; 〔大体の傾向〕the general trend; 〔世の中の趨勢(すうせい)〕the general tendency; 〔時代の風潮〕the current of the times"}	\N	\N	\N
態勢	たいせい	{}	{"attitude; conditions; preparations"}	\N	\N	\N
体制	たいせい	{各部分が統一的に組織されて一つの全体を形づくっている状態。「経営の―を立て直す」「厳戒―」}	{"order; system; structure; set-up; organization"}	\N	\N	\N
体積	たいせき	{}	{"capacity; volume"}	\N	\N	\N
大切	たいせつ	{}	{important}	\N	\N	\N
大戦	たいせん	{}	{"great war; great battle"}	\N	\N	\N
大層	たいそう	{}	{"very much; exaggerated; very fine"}	\N	\N	\N
体操	たいそう	{}	{"gymnastics; physical exercises; calisthenics"}	\N	\N	\N
対談	たいだん	{}	{"talk; dialogue; conversation"}	\N	\N	\N
隊長	たいちょう	{軍隊で、一隊の兵士の指揮権をもつ人。}	{"指導者〕a leader; a captain; 〔一般に，指揮する人〕a commander; 〔軍の〕a commanding officer"}	\N	\N	\N
大抵	たいてい	{}	{"usually; generally"}	\N	\N	\N
大敵	たいてき	{敵にむかうこと。敵として相対すること。敵対。「―する構えを見せる」}	{"〜する〔手向う〕turn [fight] against; 〔反対する〕oppose"}	\N	\N	\N
態度	たいど	{}	{attitude}	\N	\N	\N
対等	たいとう	{}	{equivalent}	\N	\N	\N
滞納	たいのう	{}	{"non-payment; default"}	\N	\N	\N
大半	たいはん	{}	{"majority; mostly; generally"}	\N	\N	\N
対比	たいひ	{}	{"contrast; comparison"}	\N	\N	\N
退避	たいひ	{その場所を退いて危険を避けること。避難。「津波の前に高台まで―する」}	{"take shelter ((in; under))"}	\N	\N	\N
大部	たいぶ	{}	{"most (e.g. most part); greater; fairly; a good deal; much"}	\N	\N	\N
台風	たいふう	{}	{typhoon}	\N	\N	\N
泰平	たいへい	{世の中が平和に治まり穏やかなこと。また、そのさま。「―の夢を破る」「―な（の）世」「天下―」}	{"(world) peace; tranquil (mood)"}	\N	\N	\N
対辺	たいへん	{}	{"(geometrical) opposite side"}	\N	\N	\N
大変	たいへん	{重大な事件。大変事。一大事。「国家の―」}	{"〔程度がはなはだしいこと〕〜な terrible; (口) awful"}	\N	\N	\N
逮捕	たいほ	{人の身体に直接力を加えて身柄を拘束すること。}	{"arrest; apprehension"}	\N	\N	\N
待望	たいぼう	{}	{"expectant waiting"}	\N	\N	\N
大木	たいぼく	{}	{"large tree"}	\N	\N	\N
怠慢	たいまん	{}	{"negligence; procrastination; carelessness"}	\N	\N	\N
対面	たいめん	{}	{"interview; meeting"}	\N	\N	\N
太陽	たいよう	{}	{"sun; solar"}	\N	\N	\N
平ら	たいら	{}	{"flatness; level; smooth; calm; plain"}	\N	\N	\N
大陸	たいりく	{}	{continent}	\N	\N	\N
対立	たいりつ	{}	{"confrontation; opposition; antagonism"}	\N	\N	\N
大量	たいりょう	{数量の多いこと。たくさんなこと。また、そのさま。多量。「―な（の）商品をさばく」⇔少量。}	{"bulk; large quantity; large-scale; mass"}	\N	\N	\N
体力	たいりょく	{}	{"physical strength"}	\N	\N	\N
対話	たいわ	{}	{"interactive; interaction; conversation; dialogue"}	\N	\N	\N
田植え	たうえ	{}	{"rice planting"}	\N	\N	\N
絶えず	たえず	{}	{constantly}	\N	\N	\N
倒す	たおす	{}	{"throw down; beat; bring down; blow down; fell; knock down; trip up; defeat; ruin; overthrow; kill; leave unpaid; cheat"}	\N	\N	\N
倒れる	たおれる	{}	{"fall down"}	\N	\N	\N
高	たか	{}	{"quantity; amount; volume; number; amount of money"}	\N	\N	\N
高い	たかい	{}	{"tall; high; expensive"}	\N	\N	\N
互い	たがい	{}	{"mutual; reciprocal"}	\N	\N	\N
高が	たかが	{程度・質・数量などが、取るに足りないさま。問題にするほどの価値のないさま。「―子供となめてかかる」「―一度の失敗」}	{"mere (child); trivial (sum); (he's) just (a)"}	\N	\N	\N
高まる	たかまる	{}	{"to rise; to swell; to be promoted"}	\N	\N	\N
高める	たかめる	{}	{"raise; lift; boost"}	\N	\N	\N
耕す	たがやす	{}	{"till; plow; cultivate"}	\N	\N	\N
宝	たから	{}	{treasure}	\N	\N	\N
滝	たき	{}	{waterfall}	\N	\N	\N
焚火	たきび	{}	{"(open) fire"}	\N	\N	\N
炊く	たく	{}	{"boil; cook"}	\N	\N	\N
宅	たく	{}	{"house; home; husband"}	\N	\N	\N
類	たぐい	{}	{"a kind"}	\N	\N	\N
沢山	たくさん	{数量の多いこと。また、そのさま。多数。副詞的にも用いる。「ーな（の）贈り物」「本をー持っている」}	{"〔数〕many (things; persons)，(文) many a (thing; person) a good [great] many; a large number of (things; persons)  ，(口) lots of ((things; persons)); 〔量〕much; plenty of; a good [great] deal of; a large quantity of，(口) lots of"}	\N	\N	\N
託す	たくす	{「たく（託）する」（サ変）の五段化。「将来に希望を―・す」}	{"entrust; ask to look after; ⇒あずける(預ける)，いたく(委託)"}	\N	\N	\N
託する	たくする	{自分がなすべきことを他の人に頼む。まかせる。「後事を友人に―・する」}	{"entrust; ask to look after; ⇒あずける(預ける)，いたく(委託)"}	\N	\N	\N
宅配	たくはい	{}	{"home delivery"}	\N	\N	\N
蓄える	たくわえる	{}	{"to store"}	\N	\N	\N
竹	たけ	{}	{"bamboo; middle (of a three-tier ranking system)"}	\N	\N	\N
他国	たこく	{自分の国でない国。よその国。外国。}	{"〔外国〕a foreign country; 〔未知の土地〕a strange land"}	\N	\N	\N
確か	たしか	{}	{"sure; certain"}	\N	\N	\N
確かめる	たしかめる	{}	{ascertain}	\N	\N	\N
足し算	たしざん	{}	{addition}	\N	\N	\N
多少	たしょう	{}	{"more or less; somewhat; a little; some"}	\N	\N	\N
足す	たす	{}	{add}	\N	\N	\N
多数	たすう	{人や物の数が多いこと。「―の参拝客」「―の書物」「市民が―参加する」⇔少数。}	{"〜の a great many; a large number of; a lot of⇒たくさん(沢山)"}	\N	\N	\N
多数決	たすうけつ	{}	{"majority rule"}	\N	\N	\N
助かる	たすかる	{}	{"be saved; be rescued; survive; be helpful"}	\N	\N	\N
助け	たすけ	{}	{assistance}	\N	\N	\N
携わる	たずさわる	{}	{"to participate; to take part"}	\N	\N	\N
但し	ただし	{しかし。前述の事柄に対して、その条件や例外などを示す。}	{"but; however; given that; provided that"}	\N	\N	\N
ただし	但し	{しかし。前述の事柄に対して、その条件や例外などを示す。}	{"but; however; given that; provided that"}	\N	\N	\N
畳む	たたむ	{}	{"fold (clothes)"}	\N	\N	\N
只	ただ	{}	{"trivial matter"}	\N	\N	\N
正しい	ただしい	{道理にかなっている。事実に合っている。正確である。「―・い解答のしかた」「―・い内容」「公選法は―・くは公職選挙法という」}	{"〔正確な〕right; correct〔道理・規則・習慣などにかなっている〕proper; 〔判断などが当を得た〕right; just; 〔合法の〕lawful"}	\N	\N	\N
戦う	たたかう	{}	{"to fight; battle; combat; struggle against; wage war; engage in contest"}	\N	{闘う}	\N
匠	たくみ	{細工師・大工など、手先や道具を使って物を作る職人。工匠。「飛騨のー」}	{"〜な〔熟練した〕skillful，((英)) skilful; 〔上手な〕good; 〔工夫をこらした，巧妙な〕ingenious"}	\N	{巧み}	\N
戦い	たたかい	{}	{"battle; fight; struggle; conflict"}	\N	{闘い}	\N
尋ねる	たずねる	{わからないことを人に聞く。質問する。問う。「道を―・ねる」「安否を―・ねる」}	{"〔質問をする〕ask; inquire (▼askよりも改まった語) ⇒きく(聞く)，しつもん(質問)"}	\N	{訊ねる,たづねる}	\N
助ける	たすける	{}	{"help; save; rescue; give relief to; reinforce; promote; abet"}	\N	{扶ける}	\N
直ちに	ただちに	{}	{"at once; immediately; directly; in person"}	\N	\N	\N
漂う	ただよう	{}	{"to drift about; to float; to hang in air"}	\N	\N	\N
達	たち	{人を表す名詞や代名詞に付く。複数であることを表す。「子供―」「僕―」}	{"plural (for humans); 俺―：we；子供―：children"}	\N	\N	\N
立ち上がる	たちあがる	{}	{"stand up"}	\N	\N	\N
立方	たちかた	{}	{"dancing (geisha)"}	\N	\N	\N
立ち止まる	たちどまる	{}	{"stop; halt; stand still"}	\N	\N	\N
立場	たちば	{}	{"standpoint; position; situation"}	\N	\N	\N
立ち向かう	たちむかう	{正面から向かっていく。対抗する。「権力に―・う」}	{"〔敢然と直面する〕confront; 〔恐れず向かっていく〕stand up to (▼通例相手は人); 〔戦う〕fight against"}	\N	\N	\N
立ち寄る	たちよる	{}	{"to stop by; to drop in for a short visit"}	\N	\N	\N
立ち技	たちわざ	{柔道やレスリングで、立った姿勢で掛ける技。⇔寝技。}	{"standing technique"}	\N	\N	\N
建つ	たつ	{}	{"build; erect"}	\N	\N	\N
立つ	たつ	{}	{"to stand"}	\N	\N	\N
経つ	たつ	{}	{"pass; lapse"}	\N	\N	\N
発つ	たつ	{}	{"depart (on a plane; train; etc.)"}	\N	\N	\N
絶つ	たつ	{}	{"to sever; to cut off; to suppress; to abstain (from)"}	\N	\N	\N
卓球	たっきゅう	{}	{"table tennis"}	\N	\N	\N
達者	たっしゃ	{}	{"skillful; in good health"}	\N	\N	\N
達する	たっする	{}	{"reach; get to"}	\N	\N	\N
達成	たっせい	{}	{achievement}	\N	\N	\N
尊ぶ	たっとぶ	{}	{"to value; to prize; to esteem"}	\N	\N	\N
たっぷり	たっぷり	{満ちあふれるほど十分にあるさま。「―な水で麺 (めん) をゆでる」}	{"full; to hearts content; as much as you like"}	\N	\N	\N
竜巻	たつまき	{}	{tornado}	\N	\N	\N
縦	たて	{}	{"length; height"}	\N	\N	\N
盾	たて	{}	{"shield; buckler; escutcheon; pretext"}	\N	\N	\N
建前	たてまえ	{}	{"face; official stance; public position or attitude (as opposed to private thoughts)"}	\N	\N	\N
奉る	たてまつる	{}	{"to offer; to present; to revere; to do respectfully"}	\N	\N	\N
建物	たてもの	{}	{building}	\N	\N	\N
建てる	たてる	{}	{build}	\N	\N	\N
立てる	たてる	{}	{"raise; set up"}	\N	\N	\N
他動詞	たどうし	{}	{"transitive verb (direct obj)"}	\N	\N	\N
例えば	たとえば	{}	{"for example"}	\N	\N	\N
例える	たとえる	{}	{"compare; use a simile"}	\N	\N	\N
辿り着く	たどりつく	{尋ね求めながら、やっと目的地に行き着く。}	{"arrive at; work your way to"}	\N	\N	\N
棚	たな	{}	{shelf}	\N	\N	\N
掌	たなごころ	{}	{"the palm"}	\N	\N	\N
谷	たに	{}	{valley}	\N	\N	\N
楽しい	たのしい	{}	{"pleasant; enjoyable; fun"}	\N	\N	\N
楽しみ	たのしみ	{}	{"pleasure; joy"}	\N	\N	\N
楽しむ	たのしむ	{}	{"to enjoy oneself"}	\N	\N	\N
楽む	たのしむ	{}	{"enjoyment; pleasure"}	\N	\N	\N
頼み	たのみ	{}	{"request; favor; reliance; dependence"}	\N	\N	\N
頼む	たのむ	{}	{"to request; ask"}	\N	\N	\N
頼もしい	たのもしい	{}	{"reliable; trustworthy; hopeful; promising"}	\N	\N	\N
束	たば	{}	{"bundle; bunch; sheaf; coil"}	\N	\N	\N
煙草	たばこ	{}	{"(pt:) (n) (uk) tobacco (pt: tabaco); cigarettes"}	\N	\N	\N
足袋	たび	{}	{"Japanese socks (with split toe)"}	\N	\N	\N
旅	たび	{}	{"travel; trip; journey"}	\N	\N	\N
多分	たぶん	{}	{"perhaps; probably"}	\N	\N	\N
食べ物	たべもの	{}	{food}	\N	\N	\N
食べる	たべる	{}	{eat}	\N	\N	\N
他方	たほう	{}	{"another side; different direction; (on) the other hand"}	\N	\N	\N
多忙	たぼう	{}	{"busy; pressure of work"}	\N	\N	\N
貴い	たっとい	{}	{"precious; valuable; priceless; noble; exalted; sacred"}	\N	{尊い}	\N
例え	たとえ	{}	{"example; even if; if; though; although"}	\N	{仮令}	\N
度々	たびたび	{}	{"often; repeatedly; frequently"}	\N	{度度}	\N
給う	たまう	{}	{"to receive; to grant"}	\N	\N	\N
卵	たまご	{}	{"egg(s); spawn; roe; (an expert) in the making"}	\N	\N	\N
玉葱	たまねぎ	{ユリ科ネギ属の野菜。}	{onion}	\N	\N	\N
堪らない	たまらない	{}	{"intolerable; unbearable; unendurable"}	\N	\N	\N
貯まる	たまる	{たくわえが多くなる。「資金が―・る」}	{"be saved"}	\N	\N	\N
賜る	たまわる	{}	{"to grant; to bestow"}	\N	\N	\N
民	たみ	{国家や社会を構成する人々。国民。}	{"people; citizen"}	\N	\N	\N
為	ため	{}	{"for; in order to"}	\N	\N	\N
為なら	ためなら	{「柔道の＿死んでもいい」}	{"for the sake of"}	\N	\N	\N
溜息	ためいき	{}	{"a sigh"}	\N	\N	\N
試し	ためし	{}	{"trial; test"}	\N	\N	\N
試す	ためす	{}	{"attempt; test"}	\N	\N	\N
貯める	ためる	{少しずつ集めて量をふやす。集めたものを減らさずに取っておく。集めたくわえる。「雨水を―・める」「目に涙を―・めて哀願する」}	{"save (e.g. money)"}	\N	\N	\N
保つ	たもつ	{}	{"to keep; to preserve; to hold; to retain; to maintain; to support; to sustain; to last; to endure; to keep well (food); to wear well; to be durable"}	\N	\N	\N
容易い	たやすい	{}	{"easy; simple; light"}	\N	\N	\N
多様	たよう	{}	{"diversity; variety"}	\N	\N	\N
頼る	たよる	{}	{"rely on; have recourse to; depend on"}	\N	\N	\N
足りる	たりる	{}	{"be sufficient; be enough"}	\N	\N	\N
足る	たる	{}	{"be sufficient; be enough"}	\N	\N	\N
垂れる	たれる	{}	{"to hang; to droop; to drop; to lower; to pull down; to dangle; to sag; to drip; to ooze; to trickle; to leave behind (at death); to give; to confer"}	\N	\N	\N
戯れる	たわむれる	{遊び興じる。何かを相手にして、おもしろがって遊ぶ。「子犬が―・れる」「波と―・れる」}	{"〔遊び興じる〕play (e.g. with a dog)〔ふざける〕(tease) in jest〔いちゃつく〕flirt"}	\N	\N	\N
反	たん	{}	{"roll of cloth (c. 10 yds.); .245 acres; 300 tsubo"}	\N	\N	\N
単位	たんい	{}	{"unit; denomination; credit (in school)"}	\N	\N	\N
単一	たんいつ	{}	{"single; simple; sole; individual; unitory"}	\N	\N	\N
短歌	たんか	{}	{"tanka; 31-syllable Japanese poem"}	\N	\N	\N
担架	たんか	{}	{"stretcher; litter"}	\N	\N	\N
嘆願	たんがん	{}	{plea}	\N	\N	\N
嘆願書	たんがんしょ	{}	{petition}	\N	\N	\N
短気	たんき	{}	{"quick temper"}	\N	\N	\N
短期	たんき	{}	{"short term"}	\N	\N	\N
探検	たんけん	{}	{"exploration; expedition"}	\N	\N	\N
単語	たんご	{}	{"word; vocabulary; (usually) single-character word"}	\N	\N	\N
炭鉱	たんこう	{}	{"coal mine"}	\N	\N	\N
探索	たんさく	{未知の事柄などをさぐり調べること。「古代史の謎を―する」「海底を―する」}	{"a search"}	\N	\N	\N
短縮	たんしゅく	{}	{"shortening; abbreviation; reduction"}	\N	\N	\N
単純	たんじゅん	{}	{simplicity}	\N	\N	\N
短所	たんしょ	{}	{"defect; demerit; weak point; disadvantage"}	\N	\N	\N
誕生	たんじょう	{}	{birth}	\N	\N	\N
誕生日	たんじょうび	{}	{birthday}	\N	\N	\N
淡水	たんすい	{}	{"fresh water"}	\N	\N	\N
炭水化物	たんすいかぶつ	{}	{carbohydrates}	\N	\N	\N
単数	たんすう	{}	{"singular (number)"}	\N	\N	\N
炭素	たんそ	{}	{"carbon (C)"}	\N	\N	\N
短大	たんだい	{}	{"junior college"}	\N	\N	\N
単調	たんちょう	{}	{"monotony; monotone; dullness"}	\N	\N	\N
探偵	たんてい	{他人の行動・秘密などをひそかにさぐること。また、それを職業とする人。「一日の動きを―する」「私立―」}	{"〔行為〕detective work; covert investigation; 〔人〕a detective"}	\N	\N	\N
担当	たんとう	{一定の事柄を受け持つこと。「営業部門を―する」「―者」}	{"(in) charge (of); responsibility"}	\N	\N	\N
単独	たんどく	{}	{"sole; independence; single; solo (flight)"}	\N	\N	\N
偶々	たまたま	{}	{"casually; unexpectedly; accidentally; by chance"}	\N	{偶偶}	\N
偶に	たまに	{}	{"occasionally; once in a while; (treat) for a change"}	\N	\N	\N
偶	たま	{まれであること。めったにないこと。また、そのさま。珍しい。「―の休み」「彼は―に来る」}	{"occasional; rare"}	\N	{適}	\N
淡々	たんたん	{感じなどが、あっさりしているさま。淡泊なさま。「―たる色調」}	{"unconcerned; dispassion; indifferent; serene"}	\N	{淡淡,澹澹,澹々}	\N
便り	たより	{何かについての情報。手紙。知らせ。「―が届く」「風の―に聞く」}	{"〔消息〕news ((of/about)); ((文)) tidings ((of)); 〔手紙〕a letter"}	\N	\N	\N
単なる	たんなる	{それだけで、ほかに何も含まないさま。ただの。}	{"mere; simple"}	\N	\N	\N
単に	たんに	{}	{"simply; merely; only; solely"}	\N	\N	\N
堪能	たんのう	{技芸に優れていること}	{"be skilled/proficient (in)"}	\N	\N	\N
短波	たんぱ	{}	{"short wave"}	\N	\N	\N
蛋白質	たんぱくしつ	{}	{protein}	\N	\N	\N
短編	たんぺん	{}	{"short (e.g. story; film)"}	\N	\N	\N
田ぼ	たんぼ	{}	{"paddy field; farm"}	\N	\N	\N
端末	たんまつ	{}	{terminal}	\N	\N	\N
手	て	{}	{hand}	\N	\N	\N
手当て	てあて	{}	{"allowance; compensation; treatment; medical care"}	\N	\N	\N
手洗い	てあらい	{}	{"restroom; lavatory; hand-washing"}	\N	\N	\N
艇	てい	{細長い小舟}	{"a boat"}	\N	\N	\N
提案	ていあん	{議案や意見を提出すること。また、その議案や意見。「具体策を―する」「―者」}	{"proposal; proposition; suggestion"}	\N	\N	\N
定員	ていいん	{}	{"fixed number of regular personnel; capacity (of boat; hall; aeroplane; etc.)"}	\N	\N	\N
庭園	ていえん	{計画的に草木・池などを配し、整えられた庭。「日本―」「屋上―」}	{"a garden"}	\N	\N	\N
低下	ていか	{}	{"decline; deterioration"}	\N	\N	\N
定価	ていか	{}	{"established price"}	\N	\N	\N
定期	ていき	{}	{"fixed term"}	\N	\N	\N
定義	ていぎ	{物事の意味・内容を他と区別できるように、言葉で明確に限定すること。「敬語の用法をーする」}	{definition}	\N	\N	\N
定期券	ていきけん	{}	{"commuter pass; season ticket"}	\N	\N	\N
定休日	ていきゅうび	{}	{"regular holiday"}	\N	\N	\N
提供	ていきょう	{金品・技能などを相手に役立ててもらうために差し出すこと。申し出。「場所を―する」「血液を―する」}	{"offer; provide"}	\N	\N	\N
提携	ていけい	{}	{"cooperation; tie-up; joint business; link-up"}	\N	\N	\N
低血圧	ていけつあつ	{血圧が持続的に異常に低い状態。一般に、最大血圧100ミリ水銀柱以下をいう。→高血圧}	{"low blood pressure"}	\N	\N	\N
抵抗	ていこう	{}	{"electrical resistance; resistance; opposition"}	\N	\N	\N
体裁	ていさい	{}	{"decency; style; form; appearance; show; get-up; format"}	\N	\N	\N
停止	ていし	{}	{"suspension; interruption; stoppage; ban; standstill; deadlock; stalemate; abeyance"}	\N	\N	\N
提示	ていじ	{}	{"presentation; exhibit; suggest; citation"}	\N	\N	\N
停車	ていしゃ	{}	{"stopping (e.g. train)"}	\N	\N	\N
提出	ていしゅつ	{書類・資料などを、ある場所、特に公 (おおやけ) の場に差し出すこと。「議案の―」「レポートを―する」「辞表を―する」}	{"presentation ((of)); 〔議案などの〕introduction (of; to; into); submission; filing"}	\N	\N	\N
提唱	ていしょう	{意見・主張などを唱え、発表すること。「改革をーする」}	{"proposal; advocation"}	\N	\N	\N
定食	ていしょく	{}	{"set meal; special (of the day)"}	\N	\N	\N
逓信	ていしん	{}	{communications}	\N	\N	\N
訂正	ていせい	{}	{"correction; revision"}	\N	\N	\N
停滞	ていたい	{}	{"stagnation; tie-up; congestion; retention; accumulation; falling into arrears"}	\N	\N	\N
邸宅	ていたく	{}	{"mansion; residence"}	\N	\N	\N
停電	ていでん	{}	{"failure of electricity"}	\N	\N	\N
程度	ていど	{}	{"degree; amount; grade; standard; of the order of (following a number)"}	\N	\N	\N
丁寧	ていねい	{}	{"polite; courteous"}	\N	\N	\N
定年	ていねん	{}	{"retirement age"}	\N	\N	\N
堤防	ていぼう	{}	{"bank; weir"}	\N	\N	\N
低迷	ていめい	{低くただようこと。「暗雲―」}	{"(clouds) hanging over; threatening"}	\N	\N	\N
停留所	ていりゅうじょ	{}	{"bus or tram stop"}	\N	\N	\N
手入れ	ていれ	{}	{"repairs; maintenance"}	\N	\N	\N
手遅れ	ておくれ	{}	{"too late; belated treatment"}	\N	\N	\N
手掛かり	てがかり	{}	{"contact; trail; scent; on hand; hand hold; clue; key"}	\N	\N	\N
手掛ける	てがける	{}	{"to handle; to manage; to work with; to rear; to look after; to have experience with"}	\N	\N	\N
手数	てかず	{}	{"number of moves; trouble"}	\N	\N	\N
手紙	てがみ	{}	{letter}	\N	\N	\N
手軽	てがる	{手数がかからず、簡単なさま。「―な食事」「―に扱えるカメラ」}	{"easy; simple; informal; offhand; cheap"}	\N	\N	\N
て居ります	ております	{「…ている」の丁寧な言い方。「ただ今、外出して―・ります」}	{"～ており is equivalent to ～ていて (which itself comes from ～ている; e.g. 書いている; 'currently writing')"}	\N	\N	\N
適応	てきおう	{}	{"adaptation; accommodation; conformity"}	\N	\N	\N
適宜	てきぎ	{}	{suitability}	\N	\N	\N
適する	てきする	{}	{"fit; suit"}	\N	\N	\N
適性	てきせい	{}	{aptitude}	\N	\N	\N
適切	てきせつ	{}	{"pertinent; appropriate; adequate; relevance"}	\N	\N	\N
適度	てきど	{}	{moderate}	\N	\N	\N
適当	てきとう	{}	{appropriate}	\N	\N	\N
適用	てきよう	{}	{applying}	\N	\N	\N
手際	てぎわ	{}	{"performance; skill; tact"}	\N	\N	\N
手首	てくび	{}	{wrist}	\N	\N	\N
手頃	てごろ	{}	{"moderate; handy"}	\N	\N	\N
手品	てじな	{}	{"sleight of hand; conjuring trick; magic; juggling"}	\N	\N	\N
手順	てじゅん	{}	{"process; procedure; protocol"}	\N	\N	\N
手錠	てじょう	{}	{"handcuffs; manacles"}	\N	\N	\N
手助け	てだすけ	{他の人の仕事などを助けること。手伝うこと。また、その人。「いくらか―になる」「母を―する」}	{"(give) help; assistance"}	\N	\N	\N
手近	てぢか	{}	{"near; handy; familiar"}	\N	\N	\N
手帳	てちょう	{}	{notebook}	\N	\N	\N
鉄	てつ	{}	{iron}	\N	\N	\N
哲学	てつがく	{}	{philosophy}	\N	\N	\N
哲学者	てつがくしゃ	{}	{philosopher}	\N	\N	\N
鉄橋	てっきょう	{}	{"railway bridge; iron bridge"}	\N	\N	\N
鉄拳	てっけん	{}	{"iron fist"}	\N	\N	\N
鉄鋼	てっこう	{}	{"iron and steel"}	\N	\N	\N
徹する	てっする	{}	{"to sink in; to penetrate; to devote oneself; to believe in; to go through; to do intently and exclusively"}	\N	\N	\N
撤退	てったい	{}	{retreat}	\N	\N	\N
手伝い	てつだい	{}	{"help; helper; assistant"}	\N	\N	\N
手伝う	てつだう	{}	{help}	\N	\N	\N
手続き	てつづき	{}	{"procedure; (legal) process; formalities"}	\N	\N	\N
徹底	てってい	{中途半端でなく一貫していること。「―した利己主義者」}	{"〜した 〔徹底的にやる〕thoroughgoing; 〔根っからの〕out-and-out; 〔度し難い〕incorrigible; 〔どうしようもない〕hopeless"}	\N	\N	\N
鉄道	てつどう	{}	{railroad}	\N	\N	\N
鉄片	てっぺん	{}	{"iron scraps"}	\N	\N	\N
鉄砲	てっぽう	{}	{gun}	\N	\N	\N
徹夜	てつや	{}	{"all night; all-night vigil; sleepless night"}	\N	\N	\N
手並み	てなみ	{腕前。技量。「おー拝見」}	{skill}	\N	\N	\N
手拭い	てぬぐい	{}	{"(hand) towel"}	\N	\N	\N
手の施しようがない	てのほどこしようがない	{処置のしようがない}	{"beyond help; there's nothing that can be done"}	\N	\N	\N
手配	てはい	{}	{"arrangement; search (by police)"}	\N	\N	\N
手筈	てはず	{}	{"arrangement; plan; programme"}	\N	\N	\N
手引き	てびき	{}	{"guidance; guide; introduction"}	\N	\N	\N
手袋	てぶくろ	{}	{gloves}	\N	\N	\N
手本	てほん	{}	{"model; pattern"}	\N	\N	\N
手間	てま	{}	{"time; labour"}	\N	\N	\N
手前	てまえ	{}	{"before; this side; we; you"}	\N	\N	\N
手回し	てまわし	{}	{"preparations; arrangements"}	\N	\N	\N
手元	てもと	{}	{"on hand; at hand; at home"}	\N	\N	\N
寺	てら	{}	{temple}	\N	\N	\N
照らす	てらす	{}	{"shine on; illuminate"}	\N	\N	\N
照り返す	てりかえす	{}	{"to reflect; to throw back light"}	\N	\N	\N
照る	てる	{}	{shine}	\N	\N	\N
手分け	てわけ	{}	{"division of labour"}	\N	\N	\N
点	てん	{}	{"point; mark; grade"}	\N	\N	\N
店員	てんいん	{}	{salesclerk}	\N	\N	\N
点火	てんか	{}	{"ignition; lighting; set fire to"}	\N	\N	\N
転回	てんかい	{}	{"revolution; rotation"}	\N	\N	\N
展開	てんかい	{}	{"develop; expansion (opposite of compression)"}	\N	\N	\N
天涯	てんがい	{}	{"horizon; distant land; skyline; heavenly shores; remote region"}	\N	\N	\N
転換	てんかん	{}	{"convert; divert"}	\N	\N	\N
典雅	てんが	{}	{grace}	\N	\N	\N
天気	てんき	{}	{"weather; the elements; fine weather"}	\N	\N	\N
転居	てんきょ	{}	{"moving; changing residence"}	\N	\N	\N
天気予報	てんきよほう	{}	{"weather forecast"}	\N	\N	\N
転勤	てんきん	{}	{"transfer; transmission"}	\N	\N	\N
典型	てんけい	{}	{"type; pattern; archetypal"}	\N	\N	\N
的確	てきかく	{}	{"precise; accurate"}	\N	{適確}	\N
点検	てんけん	{}	{"inspection; examination; checking"}	\N	\N	\N
転校	てんこう	{}	{"change schools"}	\N	\N	\N
天候	てんこう	{}	{weather}	\N	\N	\N
天国	てんごく	{}	{"paradise; heaven; Kingdom of Heaven"}	\N	\N	\N
天災	てんさい	{}	{"natural calamity; disaster"}	\N	\N	\N
天才	てんさい	{}	{"genius; prodigy; natural gift"}	\N	\N	\N
展示	てんじ	{}	{"exhibition; display"}	\N	\N	\N
天守	てんしゅ	{城の本丸に築かれた最も高い物見やぐら。・・閣。}	{"a castle tower [keep]; a donjon"}	\N	\N	\N
天守閣	てんしゅかく	{城の本丸に築かれた最も高い物見やぐら。}	{"a castle tower [keep]; a donjon"}	\N	\N	\N
天井	てんじょう	{}	{"ceiling; ceiling price"}	\N	\N	\N
転じる	てんじる	{}	{"to turn; to shift; to alter; to distract"}	\N	\N	\N
点数	てんすう	{}	{"marks; points; score; number of items; credits"}	\N	\N	\N
点線	てんせん	{}	{"dotted line; perforated line"}	\N	\N	\N
天体	てんたい	{}	{"heavenly body"}	\N	\N	\N
点々	てんてん	{}	{"here and there; little by little; sporadically; scattered in drops; dot; spot"}	\N	\N	\N
転々	てんてん	{}	{"rolling about; moving from place to place; being passed around repeatedly"}	\N	\N	\N
店舗	てんぽ	{商品を並べて売るための建物。みせ。「―を広げる」「大型―」}	{みせ(店)，しょうてん(商店)}	\N	\N	\N
転任	てんにん	{}	{"change of post"}	\N	\N	\N
天然	てんねん	{}	{"nature; spontaneity"}	\N	\N	\N
転覆	てんぷく	{}	{capsize}	\N	\N	\N
展望	てんぼう	{}	{"view; outlook; prospect"}	\N	\N	\N
転落	てんらく	{}	{"fall; degradation; slump"}	\N	\N	\N
展覧会	てんらんかい	{}	{exhibition}	\N	\N	\N
問い	とい	{}	{"question; query"}	\N	\N	\N
問い合わせ	といあわせ	{}	{enquiry}	\N	\N	\N
問い合わせる	といあわせる	{}	{"to enquire; to seek information"}	\N	\N	\N
問屋	といや	{}	{"wholesale store"}	\N	\N	\N
塔	とう	{}	{"tower; pagoda"}	\N	\N	\N
棟	とう	{むねの長い建物。大きい建物。}	{"place; section; building"}	\N	\N	\N
党	とう	{}	{"party (political); faction; -ite"}	\N	\N	\N
問う	とう	{}	{"to ask; to question; to charge (i.e. with a crime); to accuse; without regard to (neg)"}	\N	\N	\N
答案	とうあん	{}	{"examination paper; examination script"}	\N	\N	\N
統一	とういつ	{}	{"unity; consolidation; uniformity; unification; compatible"}	\N	\N	\N
東欧	とうおう	{}	{"Eastern Europe"}	\N	\N	\N
当該	とうがい	{}	{"the (above said)"}	\N	\N	\N
唐辛子	とうがらし	{}	{"cayenne pepper; red pepper"}	\N	\N	\N
冬季	とうがん	{冬の季節。冬のシーズン。冬。「―料金」}	{"winter; wintertime; the winter season"}	\N	\N	\N
冬瓜	とうがん	{ウリ科の蔓性 (つるせい) の一年草。茎に巻きひげがあり、葉は手のひら状に裂けている。}	{"(a white gourd-melon; a wax gourd)"}	\N	\N	\N
陶器	とうき	{}	{"pottery; ceramics"}	\N	\N	\N
討議	とうぎ	{}	{"debate; discussion"}	\N	\N	\N
等級	とうきゅう	{}	{"grade; class"}	\N	\N	\N
峠	とうげ	{}	{"ridge; (mountain) pass; difficult part"}	\N	\N	\N
統計	とうけい	{}	{statistics}	\N	\N	\N
統計者	とうけいしゃ	{}	{statistician}	\N	\N	\N
統計学	とうけいがく	{確率論を基盤にして、集団全体の性質を一部の標本を調べることによって推定するための処理・分析方法について研究する学問。}	{"statistics; statistical"}	\N	\N	\N
登校	とうこう	{}	{"attendance (at school)"}	\N	\N	\N
投稿	とうこう	{インターネット上の決められた場所で、文章・画像・動画などを公開すること。特に、ブログ・簡易ブログ・SNS・BBSなどに文章や画像を掲載したり、動画共有サービスに動画のデータをアップロードしたりすることを指す。}	{"submission; posting"}	\N	\N	\N
統合	とうごう	{}	{"integration; unification; synthesis"}	\N	\N	\N
投稿欄	とうこうらん	{}	{"a readers' [contributors'] column; a letter-to-the-editor column"}	\N	\N	\N
搭載	とうさい	{機器・自動車などに、ある装備や機能を組み込むこと}	{"powered by; loading on board (e.g. missile on a boat)"}	\N	\N	\N
東西	とうざい	{}	{"East and West; Orient and Occident; whole country; Your attention; please!"}	\N	\N	\N
倒産	とうさん	{}	{"(corporate) bankruptcy; insolvency"}	\N	\N	\N
投資	とうし	{}	{investment}	\N	\N	\N
当時	とうじ	{}	{"at that time; in those days"}	\N	\N	\N
戸	と	{}	{"door (Japanese style)"}	\N	\N	\N
統治	とうじ	{}	{"rule; reign; government; governing"}	\N	\N	\N
陶磁器	とうじき	{}	{pottery}	\N	\N	\N
当日	とうじつ	{}	{"appointed day"}	\N	\N	\N
東芝	とうしば	{}	{Toshiba}	\N	\N	\N
投書	とうしょ	{}	{"letter to the editor; letter from a reader; contribution"}	\N	\N	\N
当初	とうしょ	{そのことのはじめ。最初。また、その時期。「―の計画」「―組まれた予算」}	{"(at) first/beginning; original (goal)"}	\N	\N	\N
登場	とうじょう	{}	{"entry (on stage); appearance (on screen); entrance; introduction (into a market)"}	\N	\N	\N
当選	とうせん	{}	{"being elected; winning the prize"}	\N	\N	\N
統率	とうそつ	{}	{"command; lead; generalship; leadership"}	\N	\N	\N
灯台	とうだい	{}	{lighthouse}	\N	\N	\N
到達	とうたつ	{}	{"reaching; attaining; arrival"}	\N	\N	\N
到着	とうちゃく	{目的地などに行きつくこと。到達。}	{arrival}	\N	\N	\N
等々	とうとう	{}	{etc.}	\N	\N	\N
党内	とうない	{政党の内部。仲間うち。}	{"inside party; intraparty; internal party (reasons)"}	\N	\N	\N
盗難	とうなん	{}	{"theft; robbery"}	\N	\N	\N
投入	とうにゅう	{}	{"throw; investment; making (an electrical circuit)"}	\N	\N	\N
糖尿病	とうにょうびょう	{}	{diabetes}	\N	\N	\N
当人	とうにん	{}	{"the one concerned; the said person"}	\N	\N	\N
当番	とうばん	{}	{"being on duty"}	\N	\N	\N
逃避	とうひ	{困難などに直面したとき逃げたり、意識しないようにしたりして、それを避けること。「現実から―する」}	{"escape; flight (perfom flee)"}	\N	\N	\N
投票	とうひょう	{}	{"voting; poll"}	\N	\N	\N
豆腐	とうふ	{}	{Tofu}	\N	\N	\N
等分	とうぶん	{}	{"division into equal parts"}	\N	\N	\N
謄本	とうほん	{原本の内容を全部写して作った文書。戸籍謄本・登記簿謄本など。→抄本}	{"a (certified) copy; a transcript"}	\N	\N	\N
逃亡	とうぼう	{}	{escape}	\N	\N	\N
冬眠	とうみん	{}	{"hibernation; winter sleep"}	\N	\N	\N
透明	とうめい	{すきとおって向こうがよく見えること。物体が光をよく通すこと。}	{"transparency; cleanness"}	\N	\N	\N
灯油	とうゆ	{}	{"lamp oil; kerosene"}	\N	\N	\N
東洋	とうよう	{}	{Orient}	\N	\N	\N
登用	とうよう	{}	{任命(昇進appointment)}	\N	\N	\N
棟梁	とうりょう	{一族・一門の統率者。集団のかしら。頭領。また、一国を支える重職。武家の統率者のこと。}	{"leader (e.g. of a clan; group of carpenters etc.)"}	\N	\N	\N
登録	とうろく	{}	{"registration; register; entry; record"}	\N	\N	\N
討論	とうろん	{}	{"debate; discussion"}	\N	\N	\N
遠い	とおい	{}	{"far; distant"}	\N	\N	\N
十日	とおか	{}	{"ten days; the tenth day of the month"}	\N	\N	\N
遠ざかる	とおざかる	{}	{"to go far off"}	\N	\N	\N
通す	とおす	{}	{"let pass; overlook; continue; keep; make way for; persist in"}	\N	\N	\N
遠回り	とおまわり	{}	{"detour; roundabout way"}	\N	\N	\N
通り	とおり	{}	{"street; road"}	\N	\N	\N
通り掛かる	とおりかかる	{}	{"happen to pass by"}	\N	\N	\N
通りかかる	とおりかかる	{}	{"to happen to pass by"}	\N	\N	\N
通り過ぎる	とおりすぎる	{}	{"pass; pass through"}	\N	\N	\N
都会	とかい	{}	{city}	\N	\N	\N
兎角	とかく	{}	{"anyhow; anyway; somehow or other; generally speaking; in any case; this and that; many; be apt to"}	\N	\N	\N
溶かす	とかす	{}	{"melt; dissolve"}	\N	\N	\N
時	とき	{}	{"time; hour; occasion; moment"}	\N	\N	\N
時折	ときおり	{}	{sometimes}	\N	\N	\N
時々	ときどき	{}	{sometimes}	\N	\N	\N
解き放つ	ときはなつ	{つながっているものをほどいて別々にする。}	{"set free; let loose; unleash"}	\N	\N	\N
跡切れる	とぎれる	{}	{"to pause; to be interrupted"}	\N	\N	\N
十	とお	{}	{"10; ten"}	\N	\N	\N
奴	やつ	{}	{dude}	\N	\N	\N
逃走	とうそう	{にげること。にげ去ること。遁走 (とんそう) 。「その場から―する」}	{"flight; desertion; escape"}	\N	\N	\N
丁々	とうとう	{}	{"clashing of swords; felling of trees; ringing of an ax"}	\N	{丁丁}	\N
遠く	とおく	{}	{"〔距離が離れている所〕far-off; distant"}	\N	\N	\N
到底	とうてい	{"1 （あとに打消しの語を伴って）どうやってみても。どうしても。とても。「―相手にならない」「―できない」",つまるところ。つまり。「―人間として、生存する為には」}	{"at all; by no means; hardly（全く）quite; absolutely","to a full extent"}	\N	\N	\N
説く	とく	{}	{"to explain; to advocate; to preach; to persuade"}	\N	\N	\N
溶く	とく	{}	{"dissolve (e.g. paint)"}	\N	\N	\N
研ぐ	とぐ	{}	{"to sharpen; to grind; to scour; to hone; to polish; to wash (rice)"}	\N	\N	\N
得意	とくい	{}	{"pride; triumph; prosperity; one´s strong point; one´s forte; one´s specialty; customer; client"}	\N	\N	\N
得意技	とくいわざ	{}	{"signature move (assoc. with a martial artist; wrestler; etc.); finishing move"}	\N	\N	\N
特技	とくぎ	{}	{"special skill"}	\N	\N	\N
特産	とくさん	{}	{"specialty; special product"}	\N	\N	\N
特殊	とくしゅ	{}	{"special; unique"}	\N	\N	\N
特集	とくしゅう	{}	{"feature (e.g. newspaper); special edition; report"}	\N	\N	\N
特色	とくしょく	{}	{"characteristic; feature"}	\N	\N	\N
特長	とくちょう	{}	{"forte; merit"}	\N	\N	\N
特徴	とくちょう	{}	{"feature; characteristic"}	\N	\N	\N
特定	とくてい	{}	{"specific; special; particular"}	\N	\N	\N
得点	とくてん	{}	{"score; points made; marks obtained; runs"}	\N	\N	\N
特に	とくに	{}	{specially}	\N	\N	\N
特派	とくは	{}	{"send specially; special envoy"}	\N	\N	\N
特売	とくばい	{}	{"special sale"}	\N	\N	\N
特別	とくべつ	{}	{special}	\N	\N	\N
匿名	とくめい	{}	{"anonymity; pseudonym"}	\N	\N	\N
特命	とくめい	{特別の命令・任命。「ーを帯びる」}	{"special mission"}	\N	\N	\N
特有	とくゆう	{}	{"characteristic (of); peculiar (to)"}	\N	\N	\N
溶け合う	とけあう	{とけて、まざり合い一つになる。「―・わない物質」}	{"〔溶けて入り混じる〕melt together"}	\N	\N	\N
時計	とけい	{}	{"watch; clock"}	\N	\N	\N
溶け込む	とけこむ	{}	{"melt into"}	\N	\N	\N
溶ける	とける	{}	{"melt; thaw; fuse; dissolve"}	\N	\N	\N
解ける	とける	{}	{loosen}	\N	\N	\N
遂げる	とげる	{}	{"to accomplish; to achieve; to carry out"}	\N	\N	\N
床に就く	とこにつく	{寝床に入る。就寝する。「毎晩早く―・く」}	{"go to bed"}	\N	\N	\N
床の間	とこのま	{}	{alcove}	\N	\N	\N
床屋	とこや	{}	{barber}	\N	\N	\N
所	ところ	{}	{place}	\N	\N	\N
所が	ところが	{}	{"however; while; even if"}	\N	\N	\N
登山	とざん	{}	{"mountain climbing"}	\N	\N	\N
都市	とし	{}	{"town; city; municipal; urban"}	\N	\N	\N
年	とし	{}	{year}	\N	\N	\N
年上	としうえ	{年齢が上であること。また、その人。年長。年嵩 (としかさ) 。⇔年下。}	{"(three years) older (than); (a wife) older (than oneself)"}	\N	\N	\N
年頃	としごろ	{}	{"age; marriageable age; age of puberty; adolescence; for some years"}	\N	\N	\N
戸締り	とじまり	{}	{"closing up; fastening the doors"}	\N	\N	\N
図書	としょ	{}	{books}	\N	\N	\N
途上	とじょう	{}	{"en route; half way"}	\N	\N	\N
図書館	としょかん	{}	{library}	\N	\N	\N
年寄り	としより	{}	{"old people; the aged"}	\N	\N	\N
閉じる	とじる	{}	{"close (e.g. book; eyes; meeting; etc.); shut"}	\N	\N	\N
都心	としん	{}	{"heart of city"}	\N	\N	\N
渡世	とせい	{}	{"making a living; earning a livelihood"}	\N	\N	\N
途絶える	とだえる	{}	{"to stop; to cease; to come to an end"}	\N	\N	\N
戸棚	とだな	{}	{"cupboard; locker; closet; wardrobe"}	\N	\N	\N
途端	とたん	{}	{"just (now; at the moment; etc.)"}	\N	\N	\N
土地	とち	{}	{"plot of land; lot; soil"}	\N	\N	\N
特急	とっきゅう	{}	{"limited express (train; faster than an express)"}	\N	\N	\N
特許	とっきょ	{}	{"special permission; patent"}	\N	\N	\N
特権	とっけん	{}	{"privilege; special right"}	\N	\N	\N
とっく	疾っく	{ずっと以前。とう。「―からここに住んでいる」}	{"long ago"}	\N	\N	\N
解く	とく	{筋道をたどって解答を出す。「問題を―・く」}	{"solve; answer; unravel; untie"}	\N	\N	\N
刺	とげ	{}	{"thorn; splinter; spine; biting words"}	\N	{朿,棘}	\N
所で	ところで	{}	{"by the way; even if; no matter what"}	\N	\N	\N
とっくに	疾っくに	{ずっと前に。とうに。「食事は―に済ませた」}	{"long ago; (had) long since (forgotten); (is) well (past 12); (is) well (over 60);"}	\N	\N	\N
突如	とつじょ	{}	{"suddenly; all of a sudden"}	\N	\N	\N
突然	とつぜん	{}	{"abruptly; suddenly; unexpectedly; all at once"}	\N	\N	\N
取っ手	とって	{}	{"handle; grip; knob"}	\N	\N	\N
突破	とっぱ	{}	{"breaking through; breakthrough; penetration"}	\N	\N	\N
届く	とどく	{送った品物や郵便物が相手の所に着く。到着する「母から便りがー・く」}	{"reach; receive; arrive"}	\N	\N	\N
届け	とどけ	{}	{"report; notification; registration"}	\N	\N	\N
届ける	とどける	{}	{deliver}	\N	\N	\N
滞る	とどこおる	{}	{"to stagnate; to be delayed"}	\N	\N	\N
整う	ととのう	{}	{"be prepared; be in order; be put in order; be arranged"}	\N	\N	\N
整える	ととのえる	{}	{"to put in order; to get ready; to arrange; to adjust"}	\N	\N	\N
と共に	とともに	{…と一緒に。「友人―学ぶ」}	{"along with"}	\N	\N	\N
都内	とない	{}	{"inner-metropolis; inner-city"}	\N	\N	\N
唱える	となえる	{}	{"to recite; to chant; to call upon"}	\N	\N	\N
隣	となり	{}	{"next to; next door to"}	\N	\N	\N
とにかく	兎に角	{他の事柄は別問題としてという気持ちを表す。何はともあれ。いずれにしても。ともかく。「―話すだけ話してみよう」「間に合うかどうか、―行ってみよう」}	{"anyhow; in any case; anyway"}	\N	\N	\N
殿様	とのさま	{}	{"feudal lord"}	\N	\N	\N
飛ばす	とばす	{}	{"skip over; omit"}	\N	\N	\N
帳	とばり	{}	{curtain}	\N	\N	\N
飛び	とび	{}	{jump}	\N	\N	\N
飛び越える	とびこえる	{}	{"to jump over"}	\N	\N	\N
飛び込む	とびこむ	{}	{"jump in; leap in; plunge into; dive"}	\N	\N	\N
飛び出す	とびだす	{}	{"jump out; rush out; fly out; appear suddenly; protrude; project"}	\N	\N	\N
扉	とびら	{}	{"door; opening"}	\N	\N	\N
飛ぶ	とぶ	{空中を移動する。飛行する。「鳥が＿・ぶ」}	{"jump; fly; leap; spring; bound; hop"}	\N	\N	\N
徒歩	とほ	{}	{"walking; going on foot"}	\N	\N	\N
乏しい	とぼしい	{}	{"meagre; scarce; limited; destitute; hard up; scanty; poor"}	\N	\N	\N
戸惑い	とまどい	{手段や方法がわからなくてどうしたらよいか迷うこと。「―を感じる」「―の表情を見せる」}	{〔方向が分からないこと〕confusion}	\N	\N	\N
泊まる	とまる	{宿泊する。停泊する。「宿直室にー・まる」「友達を家にー・める」「船が港にー・まる」}	{"stay at (e.g. hotel)"}	\N	\N	\N
停まる	とまる	{「一時的な中断」特に車などの場合、を意味します。停止・停車・調停する。}	{"to halt (espeically a vehicle)"}	\N	\N	\N
富	とみ	{}	{"wealth; fortune"}	\N	\N	\N
富む	とむ	{}	{"to be rich; to become rich"}	\N	\N	\N
泊める	とめる	{宿泊する。停泊する。「宿直室にー・まる」「友達を家にー・める」「船が港にー・まる」}	{"stay at (e.g. hotel)"}	\N	\N	\N
友	とも	{}	{"friend; companion; pal"}	\N	\N	\N
共稼ぎ	ともかせぎ	{}	{"working together; (husband and wife) earning a living together"}	\N	\N	\N
友達	ともだち	{}	{friend}	\N	\N	\N
伴う	ともなう	{}	{"to accompany; to bring with; to be accompanied by; to be involved in"}	\N	\N	\N
共に	ともに	{}	{"sharing with; participate in; both; alike; together; along with; with; including"}	\N	\N	\N
共働き	ともばたらき	{}	{"dual income"}	\N	\N	\N
融資	ゆうし	{}	{"financing; loan"}	\N	\N	\N
止まる	とどまる	{}	{"to be limited to"}	\N	\N	\N
留まる	とどまる	{}	{"remain; abide; stay (in the one place); come to a halt; be limited to; stop"}	\N	\N	\N
跳ぶ	とぶ	{はずみをつけて、地面・床などをけり、からだが空中にあがるようにする。強く踏みきって遠くへ行く。また、はねて越える。「ジャンプ競技でK点まで―・ぶ」「溝を―・ぶ」「飛び箱を―・ぶ」}	{"jump; fly; leap; spring; bound; hop"}	\N	\N	\N
当然	とつぜん	{そうなるのがあたりまえであること、道理にかなっていること。また、そのさま。もちろん。「―の帰結」「罪人が報いを受けるのは―だ」「至極―」}	{"only natural .. of course; ought to; deserves; proper; naturally"}	\N	\N	\N
捕える	とらえる	{}	{"（捕まえる）catch; capture; seize; （つかむ）take; （逮捕する）arrest","（把握する）grasp; （理解する）understand; （問題とする）pounce on; （みなす）consider; reckon"}	\N	{捕らえる,捉える,捉らえる}	\N
取り上げる	とりあげる	{}	{"take up; pick up; disqualify; confiscate; deprive"}	\N	\N	\N
取り扱い	とりあつかい	{}	{"treatment; service; handling; management"}	\N	\N	\N
取り扱う	とりあつかう	{}	{"to treat; to handle; to deal in"}	\N	\N	\N
鳥居	とりい	{}	{"torii (Shinto shrine archway)"}	\N	\N	\N
取り入れる	とりいれる	{}	{"harvest; take in; adopt"}	\N	\N	\N
取り押さえる	とりおさえる	{犯人をつかまえる。とらえる。「泥棒を―・える」「密売の現場を―・える」}	{"〔逮捕する〕arrest; capture"}	\N	\N	\N
取り替え	とりかえ	{}	{"swap; exchange"}	\N	\N	\N
取り替える	とりかえる	{}	{exchange}	\N	\N	\N
取り組む	とりくむ	{}	{"to tackle; to wrestle with; to engage in a bout; to come to grips with"}	\N	\N	\N
取り消す	とりけす	{}	{cancel}	\N	\N	\N
取り下げる	とりさげる	{}	{??}	\N	\N	\N
取り締まる	とりしまる	{不正や不法が行われないように監視する。管理・監督する。「違法行為を―・る」}	{"to manage; to control; to supervise"}	\N	\N	\N
取り調べ	とりしらべ	{特に、捜査機関が、被疑者や参考人の出頭を求めて犯罪に関する事情を聴取すること。尋問}	{"取り調べること。 interrogation; examination; inquiry"}	\N	\N	\N
取り調べる	とりしらべる	{}	{"to investigate; to examine"}	\N	\N	\N
取り出す	とりだす	{}	{"take out; produce; pick out"}	\N	\N	\N
取り立てる	とりたてる	{}	{"to collect; to extort; to appoint; to promote"}	\N	\N	\N
取り次ぐ	とりつぐ	{}	{"to act as an agent for; to announce (someone); to convey (a message)"}	\N	\N	\N
取り除く	とりのぞく	{}	{"to remove; to take away; to set apart"}	\N	\N	\N
取り巻く	とりまく	{}	{"to surround; to circle; to enclose"}	\N	\N	\N
取り混ぜる	とりまぜる	{}	{"to mix; to put together"}	\N	\N	\N
取り戻す	とりもどす	{}	{"to take back; to regain"}	\N	\N	\N
塗料	とりょう	{}	{paint}	\N	\N	\N
取り寄せる	とりよせる	{}	{"to order; to send away for"}	\N	\N	\N
取り分	とりわけ	{}	{"especially; above all"}	\N	\N	\N
採る	とる	{}	{"adopt (measure; proposal); pick (fruit); assume (attitude)"}	\N	\N	\N
取る	とる	{}	{"take; pick up; harvest; earn; choose"}	\N	\N	\N
撮る	とる	{}	{"take (a photo); make (a film)"}	\N	\N	\N
捕る	とる	{}	{"take; catch (fish); capture"}	\N	\N	\N
取れる	とれる	{}	{"come off; be taken off; be removed; be obtained; leave; come out (e.g. photo); be interpreted"}	\N	\N	\N
摘み	つまみ	{選び・取り}	{picked}	\N	\N	\N
強者	つわもの	{強い者。他にまさる力や権力をもつ者。「―の論理」反：弱者。}	{"a strong man"}	\N	\N	\N
強者揃い	つわものぞろい	{すごく強い}	{"incredibily skilled"}	\N	\N	\N
追加	ついか	{}	{"addition; supplement; appendix"}	\N	\N	\N
追及	ついきゅう	{}	{"gaining on; carrying out; solving (crime)"}	\N	\N	\N
追従	ついじゅう	{あとにつき従うこと}	{"complience; follow"}	\N	\N	\N
追跡	ついせき	{}	{pursuit}	\N	\N	\N
次いで	ついで	{}	{"next; secondly; subsequently"}	\N	\N	\N
遂に	ついに	{長い時間ののちに、最終的にある結果に達するさま。とうとう。しまいに。「ー優勝を果たした」「ー完成した」「疲れ果ててー倒れた」}	{"finally; at last"}	\N	\N	\N
追放	ついほう	{}	{"exile; banishment"}	\N	\N	\N
費やす	ついやす	{}	{"to spend; to devote; to waste"}	\N	\N	\N
墜落	ついらく	{}	{"falling; crashing"}	\N	\N	\N
通	つう	{}	{"connoisseur; counter for letters"}	\N	\N	\N
通貨	つうか	{}	{currency}	\N	\N	\N
通学	つうがく	{}	{"commuting to school"}	\N	\N	\N
痛感	つうかん	{}	{"feeling keenly; fully realizing"}	\N	\N	\N
通勤	つうきん	{}	{"commuting to work"}	\N	\N	\N
一日	ついたち	{}	{"first day of month"}	\N	\N	\N
取締まり	とりしまり	{不正や不法が行われないように監視すること。管理・監督すること。「管内の―にあたる」}	{"control; management; supervision"}	\N	{取り締まり}	\N
通過	つうか	{}	{"〔通り過ぎること〕passage; transit; passage through; passing; 〜する pass (through)"}	\N	\N	\N
繋がる	つながる	{離れているものが結ばれて、ひと続きになる。「島と島とが橋で―・がる」「電話が―・る」「光回線が―・る」}	{"（結ばれる）be connected; be linked together; be joined together"}	\N	\N	\N
追悼	ついとう	{死者の生前をしのんで、悲しみにひたること。哀悼。哀惜。「―の辞」「故人を―する」}	{mourning}	{名,スル}	\N	\N
通行	つうこう	{}	{"passage; passing"}	\N	\N	\N
通称	つうしょう	{正式ではないが世間一般で呼ばれている名称。とおり名。鎌倉東慶寺を縁切り寺、徳川光圀を水戸黄門、歌舞伎「与話情浮名横櫛 (よわなさけうきなのよこぐし) 」を「切られ与三 (よさ) 」とよぶ類。}	{"a popular name"}	\N	\N	\N
通常	つうじょう	{特別でなく、普通の状態であること。普通}	{"usual; normal; general"}	\N	\N	\N
通信	つうしん	{}	{"correspondence; communication; news; signal"}	\N	\N	\N
痛切	つうせつ	{}	{"keen; acute"}	\N	\N	\N
通知	つうち	{}	{"notice; notification"}	\N	\N	\N
通帳	つうちょう	{}	{passbook}	\N	\N	\N
通用	つうよう	{}	{"popular use; circulation"}	\N	\N	\N
通路	つうろ	{}	{"passage; pathway"}	\N	\N	\N
通訳	つうやく	{異なる言語を話す人の間に立って、双方の言葉を翻訳してそれぞれの相手方に伝えること。}	{"interpretation; 〔人〕an interpreter"}	\N	\N	\N
遣い	つかい	{}	{"mission; simple task; doing"}	\N	\N	\N
使い道	つかいみち	{}	{use}	\N	\N	\N
使う	つかう	{}	{"use; handle; manipulate; employ; need; want; spend; consume; speak (English); practise (fencing); take (one´s lunch); circulate (bad money)"}	\N	\N	\N
遣う	つかう	{物・金銭・時間などを、何かをするのに当ててその量や額を減らす。消費する。ついやす。「金を―・う」「時間を有効に―・う」}	{"〔金，時間などを費やす〕spend; 〔消費する〕consume"}	\N	\N	\N
仕える	つかえる	{}	{"to serve; to work for"}	\N	\N	\N
司る	つかさどる	{}	{"to rule; to govern; to administer"}	\N	\N	\N
束の間	つかのま	{}	{"moment; brief time; brief; transient"}	\N	\N	\N
捕まえる	つかまえる	{}	{catch}	\N	\N	\N
捕まる	つかまる	{取り押さえられて、逃げることができなくなる。とらえられる。「どろぼうがー・る」}	{"be caught; be arrested"}	\N	\N	\N
攫む	つかむ	{手でしっかりと握り持つ。強くとらえて離すまいとする。「腕を―・む」「まわしを―・む」}	{"〔物を捕まえる〕catch; take [catch] hold of; 〔急に，力ずくで〕seize; 〔握りしめる〕grasp; 〔しっかりつかむ〕grip"}	\N	\N	\N
疲れ	つかれ	{}	{"tiredness; fatigue"}	\N	\N	\N
疲れる	つかれる	{}	{"to get tired; to tire"}	\N	\N	\N
月	つき	{}	{"month; moon"}	\N	\N	\N
付き	つき	{}	{"attached to; impression; sociality; appearance; furnished with; under; to"}	\N	\N	\N
付き合う	つきあう	{}	{"to associate with; to keep company with; to get on with"}	\N	\N	\N
付合う	つきあう	{}	{"associate with; keep company with; get on with"}	\N	\N	\N
突き上げる	つきあげる	{下から突いて上の方にあげる。突いて押し上げる。「こぶしを天に―・げる」}	{"push up; raise up (e.g. one's fist)"}	\N	\N	\N
突き当たり	つきあたり	{}	{"end (e.g. of street)"}	\N	\N	\N
突き当たる	つきあたる	{}	{"run into; collide with"}	\N	\N	\N
次々	つぎつぎ	{}	{"in succession; one by one"}	\N	\N	\N
月並み	つきなみ	{}	{"every month; common"}	\N	\N	\N
継ぎ目	つぎめ	{}	{"a joint; joining point"}	\N	\N	\N
尽きる	つきる	{}	{"to be used up; to be run out; to be exhausted; to be consumed; to come to an end"}	\N	\N	\N
点く	つく	{}	{"be lit; catch fire"}	\N	\N	\N
着く	つく	{}	{"arrive at; reach"}	\N	\N	\N
努める	つとめる	{}	{"to exert oneself; to make great effort; to try hard"}	\N	\N	\N
使い慣らす	つかいならす	{いつも使って、物をその作業などになれさせる。「よく―・したグローブ」}	{"accustom (oneself)"}	\N	{使い馴らす}	\N
使い慣れる	つかいなれる	{長い間使って、その使い方などになれる。「―・れた辞書」}	{"be used to; be accustomed to"}	\N	{使い馴れる}	\N
付き合い	つきあい	{人と交際すること。「彼とは長い―だ」}	{"acquaintance; association; friend;"}	\N	{付合い}	\N
通ずる	つうずる	{何かを伝って到達する。また、届かせる。「電話がー・ずる」,意志やものの意味などが相手に伝わる。また、伝える。「冗談が―・じない」「気脈を―・ずる」}	{"run to; lead to; communicate; understand; be well-informed","to convey (idea or intention)"}	\N	{通じる,つうじる}	\N
付く	つく	{"",２ある定まった状態がつくられる。解決する。まとまる。落着する。「話が―・く」「勝負が―・く」}	{"1 adjoin; be attached; adhere; be connected with; be dyed; be stained; be scarred; be recorded; start (fires); follow; become allied to; accompany; study with; increase; be added to","2〔決まる〕make up (one's mind); reach (an agreement)"}	\N	\N	\N
衝く	つく	{"棒状の物の先端で瞬間的に強く押す。 「指先で－・く」 「背中をどんと－・く」"}	{"perform a quick stab using a pointy object"}	\N	\N	\N
捺く	つく	{"印鑑で印をつける。 「判を－・く」"}	{"make (an seal using the inkan); impress? (heisig meaning)"}	\N	\N	\N
撞く	つく	{"鐘に棒などを打ち当てて音を出す。 「鐘を－・く」"}	{"toll (bell); stab (bell); bump into? (heisig meaning)"}	\N	\N	\N
就く	つく	{}	{"settle in (place); take (seat; position); study (under teacher)"}	\N	\N	\N
継ぐ	つぐ	{前の者のあとを受けて、その仕事・精神・地位などを引き続いて行う。続けてする。相続する。継承する。}	{"succeed; inherit; resume"}	\N	\N	\N
次ぐ	つぐ	{}	{"rank next to; come after"}	\N	\N	\N
接ぐ	つぐ	{}	{"to join; to piece together; to set (bones); to graft (trees)"}	\N	\N	\N
机	つくえ	{}	{desk}	\N	\N	\N
尽くす	つくす	{}	{"to exhaust; to run out; to serve (a person); to befriend"}	\N	\N	\N
償う	つぐなう	{金品を出して、負債や相手に与えた損失の補いをする。弁償する。「修理代を―・う」}	{"〔損害を〕compensate，((文)) recompense ((a person for)); 〔埋め合わせる〕make up ((for)); 〔罪を〕atone ((for one's sin))"}	\N	\N	\N
漬物	つけもの	{}	{"pickled veggies"}	\N	\N	\N
造り	つくり	{}	{"make up; structure; physique"}	\N	\N	\N
作り	つくり	{}	{"make-up; sliced raw fish"}	\N	\N	\N
作る	つくる	{}	{"create; make"}	\N	\N	\N
造る	つくる	{}	{"make; create; manufacture; draw up; write; compose; build; organize; establish"}	\N	\N	\N
繕う	つくろう	{}	{"to mend; to repair; to fix; to patch up; to darn; to tidy up; to adjust; to trim"}	\N	\N	\N
付け加える	つけくわえる	{}	{"to add one thing to another"}	\N	\N	\N
点ける	つける	{}	{"turn on; switch on; light up"}	\N	\N	\N
着ける	つける	{}	{"to arrive; to wear; to put on"}	\N	\N	\N
付ける	つける	{}	{"to attach; to join; to stick; to glue; to fasten; to sew on; to furnish (a house with); to wear; to put on; to make an entry; to appraise; to set (a price); to apply (ointment); to bring alongside; to place (under guard or doctor); to follow; to shad"}	\N	\N	\N
浸ける	つける	{}	{"dip in; soak"}	\N	\N	\N
漬ける	つける	{}	{"soak; pickle"}	\N	\N	\N
告げる	つげる	{}	{"to inform"}	\N	\N	\N
都合	つごう	{ぐあいがよいか悪いかということ。「今日はちょっと―が悪い」}	{circumstances〔便宜〕convenience}	\N	\N	\N
辻	つじ	{十字路・交差点}	{"crossroads; intersection"}	\N	\N	\N
辻褄	つじつま	{}	{"coherence; consistency"}	\N	\N	\N
蔦	つた	{}	{"ivy; 〔つる植物〕a vine; a creeper"}	\N	\N	\N
伝える	つたえる	{}	{"tell; report"}	\N	\N	\N
伝わる	つたわる	{}	{"be handed down; be introduced; be transmitted; be circulated; go along; walk along"}	\N	\N	\N
土	つち	{}	{"earth; soil"}	\N	\N	\N
筒	つつ	{}	{"pipe; tube"}	\N	\N	\N
続き	つづき	{}	{"sequel; continuation"}	\N	\N	\N
続く	つづく	{}	{"continue (to be the case); keep up"}	\N	\N	\N
続ける	つづける	{}	{"continue; go on; follow"}	\N	\N	\N
突っ込む	つっこむ	{}	{"thrust something into something; plunge into; go into deeply; meddle; interfere"}	\N	\N	\N
慎む	つつしむ	{あやまちや軽はずみなことがないように気をつける。慎重に事をなす。「行動をー・む」「言葉をー・みなさい」}	{"to be careful; to be chaste or discreet; to abstain or refrain"}	\N	\N	\N
謹む	つつしむ	{うやうやしくかしこまる。「ー・んで御礼申し上げます」}	{"reverently tighten up"}	\N	\N	\N
突っ張る	つっぱる	{}	{"to support; to become stiff; to become taut; to thrust (ones opponent); to stick to (ones opinion); to insist on"}	\N	\N	\N
慎ましい	つつましい	{}	{"modest; reserved"}	\N	\N	\N
包み	つつみ	{}	{"bundle; package; parcel; bale"}	\N	\N	\N
勤まる	つとまる	{}	{"to be fit for; to be equal to; to function properly"}	\N	\N	\N
務め	つとめ	{}	{"service; duty; business; responsibility; task"}	\N	\N	\N
勤め	つとめ	{}	{"service; duty; business; Buddhist religious services"}	\N	\N	\N
勤め先	つとめさき	{}	{"place of work"}	\N	\N	\N
努めて	つとめて	{}	{"make an effort!; work hard!"}	\N	\N	\N
務める	つとめる	{}	{"to serve; to fill a post; to serve under; to exert oneself; to endeavor; to be diligent; to play (the part of); to work (for)"}	\N	\N	\N
勤める	つとめる	{}	{"serve; fill a post; work (for); exert oneself; endeavor; be diligent; to play (the part of)"}	\N	\N	\N
綱	つな	{}	{rope}	\N	\N	\N
津波	つなみ	{}	{"tsunami; tidal wave"}	\N	\N	\N
常に	つねに	{}	{"always; constantly"}	\N	\N	\N
募る	つのる	{}	{"to invite; to solicit help participation etc"}	\N	\N	\N
唾	つば	{}	{"saliva; sputum"}	\N	\N	\N
翼	つばさ	{}	{wing}	\N	\N	\N
粒	つぶ	{}	{grain}	\N	\N	\N
粒餡	つぶあん	{}	{"grainy azuki bean paste"}	\N	\N	\N
潰す	つぶす	{}	{"smash; waste"}	\N	\N	\N
っぷり	っぷり	{物事の様子や、あり方などを指す表現。「振り」の音便。「書きっぷり」などのように用いられる。}	{"appearance of something; (e.g. 食べ〜 manners of eating)"}	\N	\N	\N
坪	つぼ	{}	{"〔面積の単位〕a tsubo ((単複同形)) (▼約3.3m2 )"}	\N	\N	\N
妻	つま	{}	{wife}	\N	\N	\N
摘む	つまむ	{}	{"to pinch; to hold; to pick up"}	\N	\N	\N
詰まる	つまる	{}	{"be blocked; be packed"}	\N	\N	\N
罪	つみ	{}	{"crime; fault; indiscretion"}	\N	\N	\N
積む	つむ	{}	{"pile up; stack"}	\N	\N	\N
錘	つむ	{}	{"a spindle"}	\N	\N	\N
爪	つめ	{}	{"fingernail or toenail; claw; talon; hoof"}	\N	\N	\N
爪切り	つめきり	{}	{"nail clipper"}	\N	\N	\N
冷たい	つめたい	{}	{"cold (to the touch); chilly; icy; freezing; coldhearted"}	\N	\N	\N
詰める	つめる	{}	{"pack; shorten; work out (details)"}	\N	\N	\N
積もり	つもり	{}	{"intention; plan"}	\N	\N	\N
積もる	つもる	{}	{"pile up"}	\N	\N	\N
梅雨	つゆ	{}	{"rainy season; rain during the rainy season"}	\N	\N	\N
露	つゆ	{}	{dew}	\N	\N	\N
強い	つよい	{}	{"strong; powerful; mighty; potent"}	\N	\N	\N
強まる	つよまる	{}	{"to get strong; to gain strength"}	\N	\N	\N
強さ	つよさ	{}	{"force; strength; power"}	\N	\N	\N
強める	つよめる	{}	{"to strengthen; to emphasize"}	\N	\N	\N
連なる	つらなる	{}	{"to extend; to stretch out; to stand in a row"}	\N	\N	\N
貫く	つらぬく	{}	{"to go through"}	\N	\N	\N
連ねる	つらねる	{}	{"to link; to join; to put together"}	\N	\N	\N
釣り合う	つりあう	{}	{"balance; be in harmony; suit"}	\N	\N	\N
釣鐘	つりがね	{}	{"hanging bell"}	\N	\N	\N
吊り革	つりかわ	{}	{strap}	\N	\N	\N
釣る	つる	{}	{"to fish"}	\N	\N	\N
連れ	つれ	{}	{"companion; company"}	\N	\N	\N
連れる	つれる	{}	{bring}	\N	\N	\N
嘘	うそ	{}	{"真実でないこと〕a lie; an untruth; 〔軽いうそ〕a fib"}	\N	\N	\N
植木	うえき	{}	{"garden shrubs; trees; potted plant"}	\N	\N	\N
植え込む	うえこむ	{ある物を、他の物の中にしっかりとはめ入れる}	{implanted}	\N	\N	\N
植える	うえる	{}	{plant}	\N	\N	\N
飢える	うえる	{}	{starve}	\N	\N	\N
生まれつき	うまれつき	{}	{"by nature; by birth; native"}	\N	\N	\N
角	つの	{}	{"〔牛・やぎなどの〕a horn; 〔しかの枝角〕an antler"}	\N	\N	\N
艶	つや	{}	{"gloss; glaze"}	\N	\N	\N
強気	つよき	{}	{"firm; strong"}	\N	\N	\N
辛い	つらい	{}	{"painful; heart-breaking"}	\N	\N	\N
剣	つるぎ	{}	{"a sword⇒けん(剣)"}	\N	\N	\N
常	つね	{いつでも変わることなく同じであること。永久不変であること。「有為転変の、―のない世」}	{"〔普段・平素〕usual; ordinary"}	\N	{恒}	\N
常々	つねづね	{いつも。ふだん、平生。副詞的にも用いる。「―の心掛け」「―言い聞かせてある」}	{"always; usually"}	\N	{常常}	\N
潰れる	つぶれる	{外部からの力を受けて、もとの形が崩れる。「地震で建物が―・れる」「肉刺 (まめ) が―・れる」,本来の働きが失われる。役に立たなくなる。だめになる。「歌いすぎてのどが―・れる」「企画が―・れる」}	{"〔押されて形が崩れる〕be crushed; be smashed","〔駄目になる，役に立たなくなる〕give up (plans); lose (voice)"}	\N	\N	\N
艶艶	つやつや	{光沢があって美しいさま。「―（と）した肌」}	{"glossy; glowing"}	\N	{艶々,ツヤツヤ}	\N
浮かぶ	うかぶ	{}	{"to float; to rise to surface; to come to mind"}	\N	\N	\N
浮ぶ	うかぶ	{}	{"float; rise to surface; come to mind"}	\N	\N	\N
浮かべる	うかべる	{}	{"float; express; look (sad; glad)"}	\N	\N	\N
受かる	うかる	{}	{"to pass (examination)"}	\N	\N	\N
浮き彫り	うきぼり	{あるものがはっきりと見えるようになること。「問題点がーにされる」平面に絵・文字などを浮き上がるように彫ること。レリーフ。}	{"bring out (a mean side of personality); relief; the state of being clearly visible due to being accentuated.; a method of moulding; carving in which the design stands out from the surface; to a greater (high relief) or lesser (low relief) extent"}	\N	\N	\N
浮く	うく	{}	{"float; become merry; become loose"}	\N	\N	\N
受け入れ	うけいれ	{}	{"receiving; acceptance"}	\N	\N	\N
受け入れる	うけいれる	{}	{"to accept; to receive"}	\N	\N	\N
承る	うけたまわる	{}	{"(humble) hear; be told; know"}	\N	\N	\N
受け継ぐ	うけつぐ	{}	{"to inherit; to succeed; to take over"}	\N	\N	\N
受付	うけつけ	{}	{reception}	\N	\N	\N
受け付ける	うけつける	{}	{"to be accepted; to receive (an application)"}	\N	\N	\N
受け止める	うけとめる	{}	{"to catch; to stop the blow; to react to; to take"}	\N	\N	\N
受け取り	うけとり	{}	{receipt}	\N	\N	\N
受け取る	うけとる	{}	{"to receive; to get; to accept; to take; to interpret; to understand"}	\N	\N	\N
受身	うけみ	{}	{"passive; passive voice"}	\N	\N	\N
受け持つ	うけもつ	{自分の仕事として引き受けて行う。担当する。担任する。「一年生を―・つ」「この地区の配達を―・つ」}	{"take (be in) charge of"}	\N	\N	\N
動かす	うごかす	{}	{"move; shift; set in motion; operate; inspire;; rouse; ;influence; mobilize; deny; change"}	\N	\N	\N
潮	うしお	{}	{tide}	\N	\N	\N
氏神	うじがみ	{神として祭られた氏族の先祖。藤原氏の天児屋命 (あまのこやねのみこと) 、斎部 (いんべ) 氏の天太玉命 (あまのふとだまのみこと) など。}	{"a tutelary [guardian/patron] deity; house god"}	\N	\N	\N
失う	うしなう	{今まで持っていたもの、備わっていたものをなくす。手に入れかけて、のがしてしまう。取り逃がす。「友情をー・う」「機会をー・う」}	{"lose; part with"}	\N	\N	\N
喪う	うしなう	{失う・世界から消える「15歳にして母をー・う」「絶壁より堕ちてその命をー・う」}	{"miss (something)"}	\N	\N	\N
渦	うず	{}	{swirl}	\N	\N	\N
薄い	うすい	{}	{"thin; weak; watery; diluted"}	\N	\N	\N
薄暗い	うすぐらい	{}	{"dim; gloomy"}	\N	\N	\N
埋まる	うずまる	{}	{"to be buried; to be surrounded; to overflow; to be filled"}	\N	\N	\N
薄める	うすめる	{}	{dilute}	\N	\N	\N
歌	うた	{}	{"song; poetry"}	\N	\N	\N
歌う	うたう	{音楽的な高低・調子などをつけて発声する。「歌を―・う」「ピアノに合わせて―・う」}	{sing}	\N	\N	\N
唄う	うたう	{節をつけてことばを発する、主として日本古来の大衆的なもの。長唄、小唄、端唄、馬子唄など。}	{"sing (a pop song);"}	\N	\N	\N
謡う	うたう	{節をつけてことばを発する、日本古来の文学的なもの。謡曲。}	{"sing (Noh); (Noh) versify"}	\N	\N	\N
生まれる	うまれる	{}	{"be born"}	\N	\N	\N
海	うみ	{}	{"sea; beach"}	\N	\N	\N
氏	うじ	{}	{"family name"}	\N	\N	\N
後	うしろ	{}	{"afterwards; since then; in the future"}	\N	\N	\N
受取人	うけとりにん	{金・書類・物品などを受け取る人。}	{"a recipient; 〔送金の〕a remittee; 〔手形の〕a payee; 〔保険の〕a beneficiary; 〔貨物の〕a consignee"}	\N	{受け取り人}	\N
動き	うごき	{}	{"1〔動作・運動〕(a) movement; a move; (a) motion","2〔動向，移り変わり〕trend; changes; development;〔きざし〕signs; ","3〔行動〕activities; movements"}	\N	\N	\N
受ける	うける	{自分の方に向かってくるものを、支え止めたり、取って収めたりする。受け止める。受け取る。「ミットでボールを―・ける」「雨水を桶 (おけ) に―・ける」}	{"〔受け取る，得る〕receive; get"}	\N	\N	\N
謳う	うたう	{多くの人々が褒めたたえる。謳歌する。「太平の世を―・う」}	{"〔ほめたたえる〕sing the praises ((of)); ((文)) extol"}	\N	\N	\N
詠う	うたう	{詩歌を作る。また、詩歌に節をつけて朗読する。「望郷の心を―・った詩」}	{"versify (a poem)?"}	\N	\N	\N
疑い	うたがい	{}	{"doubt; distrust"}	\N	\N	\N
疑う	うたがう	{}	{"doubt; distrust; be suspicious of; suspect"}	\N	\N	\N
疑わしい	うたがわしい	{}	{"doubtful; suspicious"}	\N	\N	\N
宴	うたげ	{酒宴。宴会。さかもり。「うちあげ（打ち上げ）」の音変化とも、歌酒の意ともいう。}	{banquet}	\N	\N	\N
打たす	うたす	{《「す」はもと使役の助動詞。むちで打って馬を走らせる意から》馬に乗って行く。}	{"ride horse?"}	\N	\N	\N
打たれる	うたれる	{ある物事から強い感動を受ける。「美談に胸を―◦れる」「意外の感に―◦れる」}	{"get hammered"}	\N	\N	\N
内	うち	{}	{inside}	\N	\N	\N
打ち明ける	うちあける	{人に知られたくない事実や秘密などを、思い切って隠さずに話す。うちあかす。「思いのたけを―・ける」}	{"confide ((in a person; a thing to a person))，confess ((to a person; a thing to a person))"}	\N	\N	\N
打ち合わせ	うちあわせ	{}	{"business meeting; previous arrangement; appointment"}	\N	\N	\N
打合せ	うちあわせ	{}	{"business meeting; appointment; previous arrangement"}	\N	\N	\N
打ち合わせる	うちあわせる	{}	{"to knock together; to arrange"}	\N	\N	\N
打ち切る	うちきる	{}	{"to stop; to abort; to discontinue; to close"}	\N	\N	\N
打ち消し	うちけし	{}	{"negation; denial; negative"}	\N	\N	\N
打ち消す	うちけす	{}	{"deny; negate; contradict"}	\N	\N	\N
打ち込む	うちこむ	{}	{"to drive in (e.g. nail stake); to devote oneself to; to shoot into; to smash; to throw into; to cast into"}	\N	\N	\N
宇宙	うちゅう	{}	{"universe; cosmos; space"}	\N	\N	\N
宇宙人	うちゅうじん	{}	{alien}	\N	\N	\N
団扇	うちわ	{}	{fan}	\N	\N	\N
内訳	うちわけ	{}	{"the items; breakdown; classification"}	\N	\N	\N
美しい	うつくしい	{}	{"beautiful; lovely"}	\N	\N	\N
写し	うつし	{}	{"copy; duplicate; facsimile; transcript"}	\N	\N	\N
移す	うつす	{}	{"remove; transfer; infect"}	\N	\N	\N
写す	うつす	{}	{"copy; photograph"}	\N	\N	\N
映す	うつす	{}	{"project; reflect; cast (shadow)"}	\N	\N	\N
訴え	うったえ	{}	{"lawsuit; complaint"}	\N	\N	\N
訴える	うったえる	{物事の善悪、正邪の判定を求めて裁判所などの機関に申し出る。}	{"appeal; sue; accuse"}	\N	\N	\N
鬱陶しい	うっとうしい	{}	{"gloomy; depressing"}	\N	\N	\N
映る	うつる	{"１鏡・水面などに反射して見える ２映像として見える"}	{"be reflected; show (a TV-image)"}	\N	\N	\N
移る	うつる	{}	{"move; change"}	\N	\N	\N
写る	うつる	{}	{"be photographed; be projected"}	\N	\N	\N
空ろ	うつろ	{}	{"blank; cavity; hollow; empty (space)"}	\N	\N	\N
器	うつわ	{}	{"bowl; vessel; container"}	\N	\N	\N
腕	うで	{}	{arm}	\N	\N	\N
腕前	うでまえ	{巧みに物事をなしうる能力や技術。手並み。技量。技能}	{"skill; ability; talent"}	\N	\N	\N
雨天	うてん	{}	{"rainy weather"}	\N	\N	\N
疎い	うとい	{親しい間柄でない。疎遠だ。「二人の仲は―・くなった」「去る者は日々に―・し」}	{"〔よく知らない〕know little; be ill-informed〔親しくない〕out-of-mind"}	\N	\N	\N
饂飩	うどん	{小麦粉を練って長く切った、ある程度の幅と太さを持つ麺。またその料理。}	{Udon}	\N	\N	\N
促す	うながす	{物事を早くするようにせきたてる；促進する；勧める}	{"stimulate; encourage"}	\N	\N	\N
自惚れ	うぬぼれ	{}	{"pretension; conceit; hubris"}	\N	\N	\N
奪う	うばう	{}	{"snatch away"}	\N	\N	\N
味酒	うまさけ	{}	{"sweet sake"}	\N	\N	\N
生まれ	うまれ	{}	{"birth; birth-place"}	\N	\N	\N
打つ	うつ	{}	{"hit; beat"}	\N	\N	\N
旨い	うまい	{食物などの味がよい。おいしい。「―・い酒」「山の空気が―・い」⇔まずい。}	{"〔おいしい〕delicious; tasty"}	\N	{甘い,美味い}	\N
射つ	うつ	{弾丸・矢などを発射する。「拳銃で―・つ」「標的を―・つ」}	{〔発射・射撃する〕shoot〔攻撃する〕attack}	\N	{撃つ}	\N
討つ	うつ	{}	{"〔敵(かたき)をとる〕avenge; get revenge; get even","〔討伐する〕subjugate; crush (e.g. the rebels)"}	\N	\N	\N
有無	うむ	{}	{"yes or no; existence; presence or absence marker"}	\N	\N	\N
産む	うむ	{}	{"to give birth; to deliver; to produce"}	\N	\N	\N
埋め込む	うめこむ	{物の全部または一部を、中に入れ込む。「石材を土中に―・む」}	{"to bury; to embed"}	\N	\N	\N
梅干	うめぼし	{}	{"dried plum"}	\N	\N	\N
埋める	うめる	{}	{"bury (e.g. one´s face in hands)"}	\N	\N	\N
敬う	うやまう	{}	{"show respect; to honour"}	\N	\N	\N
裏	うら	{}	{"the back; the wrong side"}	\N	\N	\N
浦	うら	{}	{"〔入り江〕an inlet; a bay，((英)) a creek; 〔海辺〕the seashore; a beach"}	\N	\N	\N
裏返し	うらがえし	{}	{"inside out; upside down"}	\N	\N	\N
裏返す	うらがえす	{}	{"turn inside out; turn the other way; turn over"}	\N	\N	\N
裏切る	うらぎる	{}	{"betray; double-cross"}	\N	\N	\N
裏口	うらぐち	{}	{"back door; rear entrance"}	\N	\N	\N
占う	うらなう	{}	{"forecast; predict"}	\N	\N	\N
裏腹	うらはら	{相反していること。また、そのさま。逆さま。反対。あべこべ。「気持ちと―な言葉」}	{"〔裏表，反対〕reverse; opposite"}	\N	\N	\N
憾む	うらむ	{望みどおりにならず、残念に思う。「機会を逸したことが―・まれる」}	{"to deeply regret; to resent"}	\N	\N	\N
恨む	うらむ	{ひどい仕打ちをした相手を憎く思う気持ちをもちつづける。「冷たい態度を―・む」}	{"feel bitter"}	\N	\N	\N
怨む	うらむ	{憎悪を感じる。「親をー」}	{"feel hatred"}	\N	\N	\N
羨ましい	うらやましい	{}	{"envious; enviable"}	\N	\N	\N
羨む	うらやむ	{}	{envy}	\N	\N	\N
売上	うりあげ	{}	{"amount sold; proceeds"}	\N	\N	\N
売り切れ	うりきれ	{}	{"sold out"}	\N	\N	\N
売り切れる	うりきれる	{}	{"be sold out"}	\N	\N	\N
売り出し	うりだし	{}	{"(bargain) sale"}	\N	\N	\N
売り出す	うりだす	{}	{"to put on sale; to market; to become popular"}	\N	\N	\N
売り場	うりば	{}	{"selling area"}	\N	\N	\N
売る	うる	{}	{sell}	\N	\N	\N
潤う	うるおう	{}	{"to be moist; to be damp; to get wet; to profit by; to be watered; to receive benefits; to favor; to charm; to steepen"}	\N	\N	\N
愁い	うれい	{}	{"grief; sorrow"}	\N	\N	\N
嬉しい	うれしい	{物事が自分の望みどおりになって満足であり、喜ばしい。自分にとってよいことが起き、愉快で、楽しい。「努力が報われてとても―・い」「―・いことに明日は晴れるらしい」⇔悲しい。}	{"be glad ((of; about; to do; that)); be happy; be delighted ((at; with; to do; that))"}	\N	\N	\N
売れ行き	うれゆき	{}	{sales}	\N	\N	\N
売れる	うれる	{}	{"be sold"}	\N	\N	\N
浮気	うわき	{}	{"flighty; fickle; wanton; unfaithful"}	\N	\N	\N
上着	うわぎ	{}	{"coat; tunic; jacket; outer garment"}	\N	\N	\N
噂	うわさ	{そこにいない人を話題にしてあれこれ話すこと。}	{rumour}	\N	\N	\N
上回る	うわまわる	{}	{"to exceed"}	\N	\N	\N
植わる	うわる	{}	{"to be planted"}	\N	\N	\N
運	うん	{}	{"fortune; luck"}	\N	\N	\N
運営	うんえい	{}	{"management; administration; operation"}	\N	\N	\N
運河	うんが	{}	{canal}	\N	\N	\N
運送	うんそう	{}	{"shipping; marine transportation"}	\N	\N	\N
運賃	うんちん	{}	{"freight rates; shipping expenses; fare"}	\N	\N	\N
運転	うんてん	{}	{"operation; motion; driving"}	\N	\N	\N
運転手	うんてんしゅ	{}	{drive}	\N	\N	\N
運搬	うんぱん	{}	{"transport; carriage"}	\N	\N	\N
運命	うんめい	{}	{fate}	\N	\N	\N
運輸	うんゆ	{}	{transportation}	\N	\N	\N
運用	うんよう	{}	{"making use of; application; investment; practical use"}	\N	\N	\N
和	わ	{}	{"sum; harmony; peace"}	\N	\N	\N
和英	わえい	{}	{Japanese-English}	\N	\N	\N
若い	わかい	{}	{young}	\N	\N	\N
若草色	わかくさいろ	{}	{"grass green"}	\N	\N	\N
沸かす	わかす	{}	{boil}	\N	\N	\N
我がまま	わがまま	{}	{"selfishness; egoism; wilfulness; disobedience; whim"}	\N	\N	\N
我が家	わがや	{自分の家。また、自分の家庭。}	{"〔家庭〕one's home; 〔建物〕one's house"}	\N	\N	\N
輪	わ	{}	{"ring; hoop; circle"}	\N	\N	\N
煩い	うるさい	{}	{"noisy; loud; fussy"}	\N	{五月蝿い}	\N
恨み	うらみ	{他からの仕打ちを不満に思って憤り憎む気持ち。怨恨  。遺恨。「あいつには―がある」「―を晴らす」}	{"a grudge (against)〔悪感情〕ill will (against)〔憎しみ〕hatred (of/for)"}	\N	{怨み,憾み}	\N
分かる	わかる	{}	{"to be understood"}	\N	\N	\N
分る	わかる	{}	{"be understood"}	\N	\N	\N
別れ	わかれ	{}	{"parting; separation; farewell; (lateral) branch; fork; offshoot; division; section"}	\N	\N	\N
別れ際	わかれぎわ	{}	{"parting (separating occasion)"}	\N	\N	\N
別れる	わかれる	{}	{separate}	\N	\N	\N
分かれる	わかれる	{}	{"branch off; diverge from; fork; split; dispense; scatter; divide into"}	\N	\N	\N
若々しい	わかわかしい	{}	{"youthful; young"}	\N	\N	\N
脇	わき	{}	{side}	\N	\N	\N
枠	わく	{}	{"frame; slide"}	\N	\N	\N
沸く	わく	{}	{boil}	\N	\N	\N
惑星	わくせい	{}	{planet}	\N	\N	\N
分ける	わける	{}	{"divide; separate; make distinctions; differentiate (between)"}	\N	\N	\N
技	わざ	{}	{"art; technique"}	\N	\N	\N
わざわざ	態々	{他のことのついでではなく、特にそのためだけに行うさま。特にそのために。故意に。「御親切にも―忠告に来る人がいる」「―出掛けなくても電話で済むことだ」}	{"expressly; purposely; intentionally; specially; doing something especially rather than incidentally"}	\N	\N	\N
和室	わしつ	{}	{"japanese-style room"}	\N	\N	\N
和食	わしょく	{}	{"japanese-style meal"}	\N	\N	\N
患う	わずらう	{病気で苦しむ。古くは「…にわずらう」の形で用いることが多い。「目を―・う」}	{"fall ill; become sick"}	\N	\N	\N
煩う	わずらう	{あれこれと心をいためる。思い悩む。}	{"become sick"}	\N	\N	\N
煩わしい	わずらわしい	{}	{"troublesome; annoying; complicated"}	\N	\N	\N
忘れ物	わすれもの	{}	{"a thing left behind"}	\N	\N	\N
忘れる	わすれる	{}	{"forget; leave carelessly"}	\N	\N	\N
話題	わだい	{}	{"topic; subject"}	\N	\N	\N
私共	わたくしども	{一人称の人代名詞。自分、または自分の家族・集団などをへりくだっていう語。手前ども。わたくしたち。「―もみな元気に暮らしております」}	{our}	\N	\N	\N
渡す	わたす	{}	{"pass over; hand over"}	\N	\N	\N
渡り鳥	わたりどり	{}	{"migratory bird; bird of passage"}	\N	\N	\N
和風	わふう	{}	{"Japanese style"}	\N	\N	\N
和服	わふく	{}	{"Japanese clothes"}	\N	\N	\N
和文	わぶん	{}	{"Japanese text; sentence in Japanese"}	\N	\N	\N
和睦	わぼく	{争いをやめて仲直りすること。和解。「―を結ぶ」「両国が―する」}	{"peace (negotiations; settlements; talks)"}	\N	\N	\N
罠	わな	{}	{trap}	\N	\N	\N
笑い	わらい	{}	{"laugh; laughter; smile"}	\N	\N	\N
笑う	わらう	{}	{laugh}	\N	\N	\N
割	わり	{比率。割合。「三日に一回の＿で通う」}	{"per; out of; proportion"}	\N	\N	\N
割合	わりあい	{}	{"rate; ratio; proportion; comparatively; contrary to expectations"}	\N	\N	\N
割合に	わりあいに	{}	{comparatively}	\N	\N	\N
割り当て	わりあて	{}	{"allotment; assignment; allocation; quota; rationing"}	\N	\N	\N
割り込む	わりこむ	{}	{"to cut in; to thrust oneself into; to wedge oneself in; to muscle in on; to interrupt; to disturb"}	\N	\N	\N
割り算	わりざん	{}	{"division (math)"}	\N	\N	\N
割算	わりざん	{}	{"(mathematics) division"}	\N	\N	\N
割り出す	わりだす	{ある根拠に基づいて推論し、結論を導き出す。「遺留品から犯人を―・す」}	{"〔推断する〕deduce; figure out; arrive at (a conclussion)"}	\N	\N	\N
割と	わりと	{}	{"relatively; comparatively"}	\N	\N	\N
割引	わりびき	{}	{"discount; reduction; rebate; tenths discounted"}	\N	\N	\N
割る	わる	{}	{"divide; cut; break; halve; separate; split; rip; crack; smash; dilute"}	\N	\N	\N
渡座	わたまし	{貴人の転居、神輿 (しんよ) の渡御を敬っていう語。}	{"(moving of a venerable person; religious expression)"}	\N	{移徙}	\N
態々	わざわざ	{他のことのついでではなく、特にそのためだけに行うさま。特にそのために。故意に。「御親切にも―忠告に来る人がいる」「―出掛けなくても電話で済むことだ」}	{"expressly; purposely; intentionally; specially; doing something especially rather than incidentally"}	\N	{態態}	\N
悪い	わるい	{人の行動・性質や事物の状態が、正邪・当否の判断基準に達していないさま。「心がけが―・い」「兄弟仲が―・い」⇔よい。,人の行動・性質や事物の状態などが水準より劣っているさま。「成績が―・い」「画質の―・いテレビ」⇔よい。}	{"〔道徳上よくない〕bad; 〔邪悪な〕evil",wicked,"〔劣っている〕poor (build); slow (work); ugly/plain look;"}	\N	\N	\N
湧く	わく	{水などが地中から噴き出る。「温泉が―・く」「石油が―・く」}	{"〔わき出る〕gush out; spring out"}	\N	{涌く}	\N
悪者	わるもの	{}	{"bad fellow; rascal; ruffian; scoundrel"}	\N	\N	\N
我等	われら	{一人称の人代名詞。「われ」の複数。わたくしたち。われわれ。「―が母校」「―の自由」}	{"we; us"}	\N	\N	\N
割れる	われる	{}	{"split; crack"}	\N	\N	\N
湾	わん	{}	{"bay; gulf; inlet"}	\N	\N	\N
湾曲	わんきょく	{}	{curvature}	\N	\N	\N
腕力	わんりょく	{}	{force}	\N	\N	\N
矢	や	{}	{arrow}	\N	\N	\N
やおい	㚻	{男性同性愛を題材にした漫画や小説などの俗称。また、それらを愛好する人や、作中での同性愛的な関係・あるいはそういったものが好まれる現象の総体をやおいということもある。801と表記されることもある。}	{"also known as Boys' Love (BL); is a Japanese genre of fictional media focusing on romantic or sexual relationships between male characters; typically aimed at a female audience and usually created by female authors."}	\N	\N	\N
八百屋	やおや	{}	{greengrocer}	\N	\N	\N
野外	やがい	{}	{"fields; outskirts; open air; suburbs"}	\N	\N	\N
夜間	やかん	{}	{"at night; nighttime"}	\N	\N	\N
薬缶	やかん	{}	{kettle}	\N	\N	\N
野球	やきゅう	{}	{baseball}	\N	\N	\N
焼く	やく	{}	{"bake; grill"}	\N	\N	\N
約	やく	{}	{"approximately; about; some"}	\N	\N	\N
夜具	やぐ	{}	{bedding}	\N	\N	\N
役者	やくしゃ	{}	{"actor; actress"}	\N	\N	\N
役所	やくしょ	{}	{"government office; public office"}	\N	\N	\N
薬用	やくよう	{薬として用いること。「―クリーム」}	{"medicinal use"}	\N	\N	\N
役職	やくしょく	{}	{"post; managerial position; official position"}	\N	\N	\N
訳す	やくす	{}	{translate}	\N	\N	\N
約束	やくそく	{}	{promise}	\N	\N	\N
役立つ	やくだつ	{使って効果がある。有用である。「社会に―・つ人材」}	{"to be useful; to be helpful; to serve the purpose"}	\N	\N	\N
役に立つ	やくにたつ	{使って効果がある。有用である。「―・つ人材」「急場の―・つ」}	{useful}	\N	\N	\N
役人	やくにん	{}	{"government official"}	\N	\N	\N
役場	やくば	{}	{"town hall"}	\N	\N	\N
薬品	やくひん	{}	{"medicine(s); chemical(s)"}	\N	\N	\N
役目	やくめ	{}	{"duty; business"}	\N	\N	\N
役割	やくわり	{}	{"part; assigning (allotment of) parts; role; duties"}	\N	\N	\N
焼ける	やける	{}	{"be burned"}	\N	\N	\N
優	やさ	{}	{"gentle; affectionate"}	\N	\N	\N
野菜	やさい	{}	{vegetable}	\N	\N	\N
優しい	やさしい	{}	{kind}	\N	\N	\N
易しい	やさしい	{}	{"easy; plain; simple"}	\N	\N	\N
屋敷	やしき	{}	{mansion}	\N	\N	\N
矢印	やじるし	{}	{"directing arrow"}	\N	\N	\N
社	やしろ	{}	{"Shinto shrine"}	\N	\N	\N
野心	やしん	{}	{"ambition; aspiration; designs; treachery"}	\N	\N	\N
安い	やすい	{}	{"cheap; inexpensive; peaceful; quiet; gossipy; thoughtless"}	\N	\N	\N
易い	やすい	{}	{easy}	\N	\N	\N
安っぽい	やすっぽい	{}	{"cheap-looking; tawdry; insignificant"}	\N	\N	\N
休み	やすみ	{}	{"rest; recess; respite; vacation; holiday; absence; suspension"}	\N	\N	\N
休む	やすむ	{}	{"to rest; have a break; take a day off; be finished; be absent; retire; sleep"}	\N	\N	\N
休める	やすめる	{}	{"to rest; to suspend; to give relief"}	\N	\N	\N
安物	やすもの	{値段が安く、粗悪な物。}	{"shlook; cheap"}	\N	\N	\N
安らぎ	やすらぎ	{穏やかなゆったりとした気分。「あわただしさの中に一時の―を見いだす」}	{calmness}	\N	\N	\N
野生	やせい	{動植物が自然に山野で生育すること。「―の猿」}	{wild}	\N	\N	\N
痩せる	やせる	{}	{"lose weight"}	\N	\N	\N
野戦	やせん	{フィールド}	{field}	\N	\N	\N
野戦服	やせんふく	{}	{"battle field uniform"}	\N	\N	\N
夜想曲	やそうきょく	{}	{"nocturne (music inspired by the night)"}	\N	\N	\N
悪口	わるくち	{}	{"abuse; insult; slander; evil speaking"}	\N	\N	\N
我々	われわれ	{}	{we}	\N	{我我}	\N
厄介	やっかい	{悩み・困難・気遣い}	{"trouble; burden; care; bother; worry; dependence; support; kindness; obligation"}	\N	\N	\N
薬局	やっきょく	{}	{pharmacy}	\N	\N	\N
八つ	やっつ	{}	{eight}	\N	\N	\N
やっ付ける	やっつける	{}	{"to beat"}	\N	\N	\N
矢っ張り	やっぱり	{}	{"also; as I thought; still; in spite of; absolutely"}	\N	\N	\N
奴等	やつら	{}	{"those guys"}	\N	\N	\N
宿	やど	{}	{"inn; lodging"}	\N	\N	\N
野党	やとう	{}	{"opposition party"}	\N	\N	\N
屋根	やね	{}	{roof}	\N	\N	\N
破く	やぶく	{}	{"tear; violate; defeat; smash; destroy"}	\N	\N	\N
破る	やぶる	{}	{"tear; violate; defeat; smash; destroy"}	\N	\N	\N
破れる	やぶれる	{}	{"get torn; wear out"}	\N	\N	\N
野暮	やぼ	{人情の機微に通じないこと。わからず屋で融通のきかないこと。また、その人やさま。無粋 (ぶすい) 。「―を言わずに金を貸してやれ」「聞くだけ―だ」⇔粋 (いき) 。}	{"〜な 〔がさつな，無神経な〕boorish; 〔気のきかない，不器用な〕gauche [óu]; 〔ぎこちない，ぶざまな〕uncouth"}	\N	\N	\N
野望	やぼう	{分不相応な望み。また、身の程を知らない大それた野心。「世界制覇の―を抱く」}	{ambition}	\N	\N	\N
山	やま	{}	{"mountain; pile; heap; climax; critical point"}	\N	\N	\N
闇	やみ	{}	{"darkness; the dark; black-marketeering; dark; shady; illegal"}	\N	\N	\N
止む	やむ	{}	{"stop (e.g. rain)"}	\N	\N	\N
病む	やむ	{}	{"to fall ill; to be ill"}	\N	\N	\N
止むを得ない	やむをえない	{そうするよりほかに方法がない。しかたがない。「撤退もー・ない」}	{unavoidable}	\N	\N	\N
辞める	やめる	{}	{retire}	\N	\N	\N
寡	やもめ	{}	{widow}	\N	\N	\N
遣り通す	やりとおす	{}	{"to carry through; to achieve; to complete"}	\N	\N	\N
やり遂げる	やりとげる	{}	{"to accomplish"}	\N	\N	\N
軟い	やわい	{壊れやすい、こわれやすい}	{weak}	\N	\N	\N
軟らかい	やわらかい	{}	{"soft; tender; limp"}	\N	\N	\N
柔らかい	やわらかい	{}	{soft}	\N	\N	\N
和らげる	やわらげる	{}	{"to soften; to moderate; to relieve"}	\N	\N	\N
世	よ	{}	{"world; society; age; generation"}	\N	\N	\N
夜明け	よあけ	{}	{"dawn; daybreak"}	\N	\N	\N
好い	よい	{}	{good}	\N	\N	\N
宵	よい	{日が暮れてまだ間もないころ。古代では夜を3区分した一つで、日暮れから夜中までの間。初夜。「―のうちから床に就く」}	{evening}	\N	\N	\N
用	よう	{}	{"business; errand"}	\N	\N	\N
酔う	よう	{}	{"get drunk; become intoxicated"}	\N	\N	\N
昜	よう	{}	{"[piggy bank radical]"}	\N	\N	\N
用意	ようい	{前もって必要なものをそろえ、ととのえておくこと。したく。「食事の―がととのう」「招待客の車を―する」}	{prepare}	\N	\N	\N
容易	ようい	{}	{"easy; simple; plain"}	\N	\N	\N
要因	よういん	{}	{"primary factor; main cause"}	\N	\N	\N
余韻	よいん	{}	{"a lingering sound"}	\N	\N	\N
溶液	ようえき	{}	{"solution (liquid)"}	\N	\N	\N
八日	ようか	{}	{"eight days; the eighth (day of the month)"}	\N	\N	\N
溶岩	ようがん	{}	{lava}	\N	\N	\N
容器	ようき	{}	{"container; vessel"}	\N	\N	\N
陽気	ようき	{}	{"season; weather; cheerfulness"}	\N	\N	\N
要求	ようきゅう	{}	{"request; demand; requisition"}	\N	\N	\N
謡曲	ようきょく	{}	{"a Noh song; Noh singing"}	\N	\N	\N
用具	ようぐ	{}	{"tool; utensil"}	\N	\N	\N
用件	ようけん	{}	{business}	\N	\N	\N
用語	ようご	{}	{"term; terminology"}	\N	\N	\N
養護	ようご	{}	{"protection; nursing; protective care"}	\N	\N	\N
擁護	ようご	{}	{"protection; support"}	\N	\N	\N
奴	やっこ	{}	{"servant; fellow"}	\N	\N	\N
家主	やぬし	{}	{landlord}	\N	\N	\N
止める	やめる	{}	{"quit smoking"}	\N	\N	\N
夜	よ	{}	{night}	\N	\N	\N
柔い	やわい	{「柔らかい」に同じ。「―・い紙」}	{"〔固くない〕soft〔穏やかな〕soft; gentle; mild"}	\N	\N	\N
雇う	やとう	{賃金を払って人を使う。また、料金を払って乗り物などを使う。「人を―・う」「ハイヤーを―・う」}	{"〔雇用する〕employ; hire〔料金を出して乗り物を使う〕"}	\N	{傭う}	\N
要旨	ようし	{}	{"gist; essentials; summary; fundamentals"}	\N	\N	\N
用紙	ようし	{}	{"blank form"}	\N	\N	\N
幼児	ようじ	{}	{"infant; baby; child"}	\N	\N	\N
用事	ようじ	{}	{"business; errand"}	\N	\N	\N
様式	ようしき	{}	{"style; form; pattern"}	\N	\N	\N
用心	ようじん	{}	{"care; precaution; caution"}	\N	\N	\N
様子	ようす	{外から見てわかる物事のありさま。状況。状態。「当時の―を知る人」「室内の―をうかがう」}	{"aspect; state; appearance"}	\N	\N	\N
要する	ようする	{}	{"to demand; to require; to take"}	\N	\N	\N
要するに	ようするに	{}	{"in a word; after all; the point is ...; in short ..."}	\N	\N	\N
養成	ようせい	{}	{"training; development"}	\N	\N	\N
要請	ようせい	{必要だとして、強く願い求めること。「会長就任をーする」}	{request}	\N	\N	\N
容積	ようせき	{}	{"capacity; volume"}	\N	\N	\N
要素	ようそ	{あるものごとを成り立たせている基本的な内容や条件。成分。要因。}	{elements}	\N	\N	\N
様相	ようそう	{}	{aspect}	\N	\N	\N
幼稚	ようち	{}	{"infancy; childish; infantile"}	\N	\N	\N
幼稚園	ようちえん	{}	{kindergarten}	\N	\N	\N
要点	ようてん	{}	{"gist; main point"}	\N	\N	\N
用途	ようと	{}	{"use; usefulness"}	\N	\N	\N
様な	ような	{例示の意を表す。たとえば＿のようだ。〜似ている；〜と同様である；例示して；〜とかいう}	{"like; such as"}	\N	\N	\N
曜日	ようび	{}	{"day of the week"}	\N	\N	\N
用品	ようひん	{}	{"articles; supplies; parts"}	\N	\N	\N
洋品店	ようひんてん	{}	{"shop which handles Western-style apparel and accessories"}	\N	\N	\N
洋風	ようふう	{}	{"western style"}	\N	\N	\N
洋服	ようふく	{}	{"Western-style clothes"}	\N	\N	\N
養分	ようぶん	{}	{"nourishment; nutrient"}	\N	\N	\N
用法	ようほう	{}	{"directions; rules of use"}	\N	\N	\N
要望	ようぼう	{}	{"demand for; request"}	\N	\N	\N
羊毛	ようもう	{}	{wool}	\N	\N	\N
漸く	ようやく	{}	{"gradually; finally; hardly"}	\N	\N	\N
擁立	ようりつ	{}	{fielded(?)}	\N	\N	\N
要領	ようりょう	{}	{"point; gist; essentials; outline"}	\N	\N	\N
容量	ようりょう	{器物の中に入れることのできる分量。容積。}	{"capacity; 〔容積〕volume"}	\N	\N	\N
余暇	よか	{}	{"leisure; leisure time; spare time"}	\N	\N	\N
予感	よかん	{}	{"presentiment; premonition"}	\N	\N	\N
予期	よき	{前もって期待すること。「―に反する」「―した以上の成果」}	{"expectation; assume will happen; forecast"}	\N	\N	\N
余興	よきょう	{}	{"side show; entertainment"}	\N	\N	\N
夜霧	よぎり	{"夜に立つ霧。《季 秋》「山国の―に劇場 (しばゐ) 出て眠し／水巴」"}	{"night fog"}	\N	\N	\N
預金	よきん	{}	{"deposit; bank account"}	\N	\N	\N
良く	よく	{}	{good}	\N	\N	\N
抑圧	よくあつ	{}	{"check; restraint; oppression; suppression"}	\N	\N	\N
抑止	よくし	{おさえつけて活動などをやめさせること。「地価の高騰をーする」「核のー力」}	{"barestraint; deterrence"}	\N	\N	\N
浴室	よくしつ	{}	{"bathroom; bath"}	\N	\N	\N
翌日	よくじつ	{}	{"next day"}	\N	\N	\N
浴する	よくする	{水や湯を浴びる。入浴する。「温泉に―・する」}	{⇒あびる(浴びる)，にゅうよく(入浴)}	\N	\N	\N
抑制	よくせい	{}	{suppression}	\N	\N	\N
浴槽	よくそう	{湯ぶね。ふろおけ。}	{bathtub}	\N	\N	\N
翌年	よくねん	{}	{"next year"}	\N	\N	\N
欲張り	よくばり	{}	{"avarice; covetousness; greed"}	\N	\N	\N
欲深い	よくふかい	{}	{greedy}	\N	\N	\N
欲望	よくぼう	{}	{"desire; appetite"}	\N	\N	\N
横	よこ	{}	{"beside; side; width"}	\N	\N	\N
夕暮れ	ゆうぐれ	{}	{"evening; (evening) twilight"}	\N	\N	\N
余計	よけい	{物が余っていること。必要な数より多くあること。また、そのさま。余り。余分。「一人分切符が―だ」,普通より分量の多いこと。程度が上なこと。また、そのさま。たくさん。「いつもより―に食べる」「人より―な苦労をする」}	{"〔余り，余分〕〜な too many [much]; surplus; 〜に too much","〔普通よりたくさん〕more than usual; extra"}	\N	\N	\N
横文字	よこもじ	{横に書きつづる文字。西洋文字・梵字 (ぼんじ) ・アラビア文字など。特に、西洋文字をいう。}	{"〔西洋の文字〕the Roman alphabet; 〔外国語〕a Western [European] language"}	\N	\N	\N
横切る	よこぎる	{}	{"cross (e.g. arms); traverse"}	\N	\N	\N
寄こす	よこす	{}	{"to send; to forward"}	\N	\N	\N
横しま風	よこしまかぜ	{横なぐりに吹く風。暴風。「思はぬに―のにふふかに覆ひ来ぬれば」}	{"violent wind;"}	\N	\N	\N
横綱	よこづな	{}	{"sumo grand champion"}	\N	\N	\N
横手	よこて	{横に当たる方向。わき。「寺の―にある堂」「―から入る」}	{"side; beside; next"}	\N	\N	\N
予算	よさん	{}	{"estimate; budget"}	\N	\N	\N
善し悪し	よしあし	{}	{"good or bad; merits or demerits; quality; suitability"}	\N	\N	\N
予習	よしゅう	{}	{preparation}	\N	\N	\N
止す	よす	{}	{"cease; abolish; resign; give up"}	\N	\N	\N
寄せる	よせる	{}	{"collect; gather; add; put aside"}	\N	\N	\N
余所	よそ	{}	{"another place; somewhere else; strange parts"}	\N	\N	\N
予想	よそう	{}	{"expectation; anticipation; prediction; forecast"}	\N	\N	\N
予測	よそく	{}	{"prediction; estimation"}	\N	\N	\N
余所見	よそみ	{}	{"looking away; looking aside"}	\N	\N	\N
余地	よち	{}	{"place; room; margin; scope"}	\N	\N	\N
予兆	よちょう	{}	{"omen; portent"}	\N	\N	\N
四日	よっか	{}	{"fourth day of the month; four days"}	\N	\N	\N
四つ角	よつかど	{}	{"four corners; crossroads"}	\N	\N	\N
四つ	よっつ	{}	{four}	\N	\N	\N
依って	よって	{}	{"therefore; consequently; accordingly; because of"}	\N	\N	\N
酔っ払い	よっぱらい	{}	{drunkard}	\N	\N	\N
余程	よっぽど	{}	{"very; greatly; much; to a large extent; quite"}	\N	\N	\N
予定	よてい	{}	{plan}	\N	\N	\N
与党	よとう	{}	{"government party; (ruling) party in power; government"}	\N	\N	\N
予備	よび	{}	{"preparation; preliminaries; reserve; spare"}	\N	\N	\N
呼び掛ける	よびかける	{}	{"call out to; accost; address (crowd); make an appeal"}	\N	\N	\N
呼び出す	よびだす	{}	{"summon; call (e.g. via telephone)"}	\N	\N	\N
呼び止める	よびとめる	{}	{"to challenge; to call somebody to halt"}	\N	\N	\N
呼ぶ	よぶ	{}	{"call out; invite"}	\N	\N	\N
夜更かし	よふかし	{}	{"staying up late; keeping late hours; sitting up late at night; nighthawk"}	\N	\N	\N
夜更け	よふけ	{}	{"late at night"}	\N	\N	\N
余分	よぶん	{}	{"extra; excess; surplus"}	\N	\N	\N
予報	よほう	{}	{"forecast; prediction"}	\N	\N	\N
予防	よぼう	{悪い事態の起こらないように前もってふせぐこと。「病気の蔓延を―する」}	{"prevention; precaution; protection against"}	\N	\N	\N
読み	よみ	{}	{reading}	\N	\N	\N
読み上げる	よみあげる	{}	{"to read out loud (and clearly); to call a roll"}	\N	\N	\N
夜道	よみち	{}	{"night journey; walk after dark"}	\N	\N	\N
読む	よむ	{}	{read}	\N	\N	\N
詠む	よむ	{}	{"chant; recite"}	\N	\N	\N
嫁	よめ	{}	{"bride; daughter-in-law"}	\N	\N	\N
予約	よやく	{}	{reservation}	\N	\N	\N
余裕	よゆう	{必要分以上に余りがあること。また、限度いっぱいまでには余りがあること。「金にーがある」「時間のーがない」}	{"allowance; margin; room"}	\N	\N	\N
有効	ゆうこう	{}	{"validity; availability; effectiveness"}	\N	\N	\N
汚す	よごす	{}	{"disgrace; dishonour; pollute; contaminate; soil; make dirty; stain"}	\N	\N	\N
汚れる	よごれる	{}	{"get dirty"}	\N	\N	\N
夜中	よなか	{}	{"all night; the whole night"}	\N	\N	\N
邪	よこしま	{正しくないこと。道にはずれていること。また、そのさま。「―な考えをいだく」}	{"wicked; evil; not doing the right thing; on the wrong path"}	\N	{横しま}	\N
装い	よそい	{身なりを整えたり、身を飾ったりすること。また、その装束や装飾。「農家の婦人の―したる媼ありて」「何ばかりの御―なく、うちやつして」}	{〔服装〕clothing〔飾り付け〕decoration}	\N	{粧い}	\N
寄り道	よりみち	{目的地へ行く途中で、他の所へ立ち寄ること。また、回り道して立ち寄ること。回り道。「ーして帰る」}	{"stop on the way; detour; go the long way aaround"}	\N	\N	\N
寄り掛かる	よりかかる	{}	{"to lean against; to recline on; to lean on; to rely on"}	\N	\N	\N
寄る	よる	{}	{"drop in; stop by"}	\N	\N	\N
喜び	よろこび	{}	{"joy; (a) delight; rapture; pleasure; gratification; rejoicing; congratulations; felicitations"}	\N	\N	\N
慶び	よろこび	{}	{"joy; delight; rapture; pleasure; gratification; rejoicing; congratulations; felicitations"}	\N	\N	\N
喜ぶ	よろこぶ	{}	{"be delighted"}	\N	\N	\N
慶ぶ	よろこぶ	{}	{"be delighted; be glad"}	\N	\N	\N
宜しい	よろしい	{}	{good}	\N	\N	\N
宜しく	よろしく	{}	{"well; properly; suitably; best regards; please remember me"}	\N	\N	\N
弱い	よわい	{}	{weak}	\N	\N	\N
弱まる	よわまる	{}	{"to abate; to weaken; to be emaciated; to be dejected; to be perplexed"}	\N	\N	\N
弱める	よわめる	{}	{"to weaken"}	\N	\N	\N
弱る	よわる	{}	{"to weaken; to be troubled; to be downcast; to be emaciated; to be dejected; to be perplexed; to impair"}	\N	\N	\N
湯	ゆ	{}	{"hot water"}	\N	\N	\N
唯一	ゆいいつ	{}	{"only; sole; unique"}	\N	\N	\N
優位	ゆうい	{}	{"predominance; ascendancy; superiority"}	\N	\N	\N
憂鬱	ゆううつ	{}	{"depression; melancholy; dejection; gloom"}	\N	\N	\N
有益	ゆうえき	{}	{"beneficial; profitable"}	\N	\N	\N
優越	ゆうえつ	{}	{"supremacy; predominance; being superior to"}	\N	\N	\N
遊園地	ゆうえんち	{}	{"amusement park"}	\N	\N	\N
誘拐	ゆうかい	{だまして、人を連れ去ること。かどわかし。「幼児を―する」「営利―」→略取誘拐罪}	{"kidnapping; abduction"}	\N	\N	\N
夕方	ゆうがた	{}	{evening}	\N	\N	\N
夕刊	ゆうかん	{}	{"evening paper"}	\N	\N	\N
勇敢	ゆうかん	{}	{"bravery; heroism; gallantry"}	\N	\N	\N
優雅	ゆうが	{}	{elegance}	\N	\N	\N
有機	ゆうき	{}	{organic}	\N	\N	\N
勇気	ゆうき	{}	{"courage; bravery; valour; nerve; boldness"}	\N	\N	\N
遊戯	ゆうぎ	{遊びたわむれること。遊び。「言語―」}	{"〔遊び戯れること〕play; a game"}	\N	\N	\N
遊戯室	ゆうぎしつ	{}	{"a playroom"}	\N	\N	\N
遊技場	ゆうぎじょう	{パチンコ・ビリヤード・ボウリングなどの遊技を行うための施設。}	{"an amusement center"}	\N	\N	\N
遊戯場	ゆうぎじょう	{}	{"a playground"}	\N	\N	\N
悠久	ゆうきゅう	{果てしなく長く続くこと。長く久しいこと。「ーの歴史」}	{"eternity; everlasting"}	\N	\N	\N
友好	ゆうこう	{}	{friendship}	\N	\N	\N
夜	よる	{}	{"evening; night"}	\N	\N	\N
四	よん	{}	{"four; fourth; quadruple"}	\N	\N	\N
喜ばしい	よろこばしい	{喜ぶべき状態である。うれしい。「こんな―・いことはない」「―・い知らせ」}	{"〔うれしい〕happy; 〔望ましい〕desirable; 〔よい〕good"}	\N	{悦ばしい}	\N
因る	よる	{それを原因とする。起因する。「濃霧にー・る欠航」「成功は市民の協力にー・る」}	{"come from"}	\N	{由る}	\N
優秀	ゆうしゅう	{非常にすぐれていること}	{excellence;superiority}	\N	\N	\N
優勝	ゆうしょう	{}	{"overall victory; championship"}	\N	\N	\N
夕食	ゆうしょく	{夕方にとる食事。夕飯。夕餉 (ゆうげ) 。}	{"supper; dinner"}	\N	\N	\N
友情	ゆうじょう	{}	{"friendship; fellowship"}	\N	\N	\N
友人	ゆうじん	{}	{friend}	\N	\N	\N
融通	ゆうずう	{}	{"lending (money); accommodation; adaptability; versatility; finance"}	\N	\N	\N
有する	ゆうする	{}	{"to own; to be endowed with"}	\N	\N	\N
優勢	ゆうせい	{}	{"superiority; superior power; predominance; preponderance"}	\N	\N	\N
優先	ゆうせん	{}	{"preference; priority"}	\N	\N	\N
郵送	ゆうそう	{}	{mailing}	\N	\N	\N
夕立	ゆうだち	{}	{"(sudden) evening shower (rain)"}	\N	\N	\N
誘導	ゆうどう	{}	{"guidance; leading; induction; introduction; incitement; inducement"}	\N	\N	\N
有能	ゆうのう	{}	{"able; capable; efficient; skill"}	\N	\N	\N
夕飯	ゆうはん	{}	{dinner}	\N	\N	\N
夕日	ゆうひ	{}	{"setting sun"}	\N	\N	\N
優美	ゆうび	{}	{"grace; refinement; elegance"}	\N	\N	\N
郵便	ゆうびん	{}	{"mail; postal service"}	\N	\N	\N
郵便局	ゆうびんきょく	{}	{"post office"}	\N	\N	\N
夕べ	ゆうべ	{きのうの夜。さくや。昨晩。「―は飲み明かした」「―地震があった」}	{"evening; last night"}	\N	\N	\N
有望	ゆうぼう	{}	{"good prospects; full of hope; promising"}	\N	\N	\N
遊牧	ゆうぼく	{}	{nomadism}	\N	\N	\N
有名	ゆうめい	{世間に名が知られていること。また、そのさま。著名。「―な俳優」「風光明媚で―な地」「―人」⇔無名。}	{fame}	\N	\N	\N
夕焼け	ゆうやけ	{}	{sunset}	\N	\N	\N
猶予	ゆうよ	{ぐずぐず引き延ばして、決定・実行しないこと。「もはや一刻の＿も許されない」}	{hesitation}	\N	\N	\N
有利	ゆうり	{}	{"advantageous; better; profitable; lucrative"}	\N	\N	\N
憂慮	ゆうりょ	{慎む・先を考えること}	{"reserved / foresight"}	\N	\N	\N
有料	ゆうりょう	{}	{"admission-paid; toll"}	\N	\N	\N
有力	ゆうりょく	{}	{"influence; prominence; potent"}	\N	\N	\N
幽霊	ゆうれい	{}	{"ghost; specter; apparition; phantom"}	\N	\N	\N
誘惑	ゆうわく	{}	{"temptation; allurement; lure"}	\N	\N	\N
故に	ゆえに	{前に述べた事を理由として、あとに結果が導かれることを表す。数学の証明問題などでは「∴」の記号が用いられる。よって。したがって。「貴君の功績は大きい。―ーれを賞する」}	{"therefore; accordingly; consequently"}	\N	\N	\N
愉快	ゆかい	{}	{"pleasant; happy"}	\N	\N	\N
浴衣	ゆかた	{}	{"bathrobe; informal summer kimono"}	\N	\N	\N
雪	ゆき	{}	{snow}	\N	\N	\N
行く行くは	ゆくゆくは	{将来。いつか。結局。}	{"in the future; someday; in the end"}	\N	\N	\N
湯気	ゆげ	{}	{"steam; vapour"}	\N	\N	\N
輸血	ゆけつ	{}	{"blood transfusion"}	\N	\N	\N
揺さぶる	ゆさぶる	{}	{"to shake; to jolt; to rock; to swing"}	\N	\N	\N
輸出	ゆしゅつ	{}	{export}	\N	\N	\N
譲る	ゆずる	{}	{"turn over; assign; hand over; transmit; convey; sell; dispose of; yield; surrender"}	\N	\N	\N
輸送	ゆそう	{}	{"transport; transportation"}	\N	\N	\N
豊か	ゆたか	{}	{"abundant; wealthy; plentiful; rich"}	\N	\N	\N
油断	ゆだん	{不注意である；警戒を怠る}	{"be careless; be off (one)'s guard; negligence"}	\N	\N	\N
癒着	ゆちゃく	{}	{"adhesion; fastening; fixing"}	\N	\N	\N
油田	ゆでん	{}	{"an oil field"}	\N	\N	\N
輸入	ゆにゅう	{}	{"importation; import; introduction"}	\N	\N	\N
指	ゆび	{}	{finger}	\N	\N	\N
指差す	ゆびさす	{}	{"to point at"}	\N	\N	\N
指輪	ゆびわ	{}	{ring}	\N	\N	\N
弓	ゆみ	{}	{"bow (and arrow)"}	\N	\N	\N
夢	ゆめ	{}	{dream}	\N	\N	\N
由来	ゆらい	{}	{origin}	\N	\N	\N
揺らぐ	ゆらぐ	{}	{"to swing; to sway; to shake; to tremble"}	\N	\N	\N
善事	ぜんじ	{}	{"good thing/deed"}	\N	\N	\N
床	ゆか	{}	{floor}	\N	\N	\N
湯呑み	ゆのみ	{}	{teacup}	\N	{湯飲み}	\N
悠々	ゆうゆう	{}	{"quiet; calm; leisurely"}	\N	{悠悠}	\N
緩い	ゆるい	{}	{"loose; lenient; slow"}	\N	\N	\N
許す	ゆるす	{}	{"permit; allow; approve; exempt (from fine); excuse (from); confide in; forgive; pardon; excuse; release; let off"}	\N	\N	\N
緩む	ゆるむ	{}	{"to become loose; to slacken"}	\N	\N	\N
緩める	ゆるめる	{}	{"to loosen; to slow down"}	\N	\N	\N
緩やか	ゆるやか	{}	{lenient}	\N	\N	\N
揺れる	ゆれる	{}	{"shake; quake"}	\N	\N	\N
財宝	ざいほう	{財産や宝物。財産となる価値の高い物品。宝物。富。}	{"treasure(s); riches"}	\N	\N	\N
財	ざい	{}	{"fortune; riches"}	\N	\N	\N
在学	ざいがく	{}	{"(enrolled) in school"}	\N	\N	\N
財源	ざいげん	{}	{"source of funds; resources; finances"}	\N	\N	\N
在庫	ざいこ	{}	{"stockpile; stock"}	\N	\N	\N
財産	ざいさん	{}	{"property; fortune; assets"}	\N	\N	\N
座椅子	ざいす	{}	{"sitting chair"}	\N	\N	\N
財政	ざいせい	{}	{"economy; financial affairs"}	\N	\N	\N
材木	ざいもく	{}	{"lumber; timber"}	\N	\N	\N
材料	ざいりょう	{}	{"ingredients; material"}	\N	\N	\N
座敷	ざしき	{}	{"tatami room"}	\N	\N	\N
座席	ざせき	{}	{seat}	\N	\N	\N
座卓	ざたく	{}	{"sitting table"}	\N	\N	\N
座談会	ざだんかい	{}	{"symposium; round-table discussion"}	\N	\N	\N
雑	ざつ	{}	{"rough; crude"}	\N	\N	\N
雑音	ざつおん	{}	{"noise (jarring; grating)"}	\N	\N	\N
雑貨	ざっか	{}	{"miscellaneous goods; general goods; sundries"}	\N	\N	\N
雑誌	ざっし	{}	{"journal; magazine"}	\N	\N	\N
雑多	ざった	{いろいろなものが入りまじっていること。また、そのさま。「―な展示物」}	{"miscellaneous; mixed"}	\N	\N	\N
雑談	ざつだん	{}	{"chatting; idle talk"}	\N	\N	\N
雑木	ざつぼく	{}	{"various kinds of small trees; assorted trees"}	\N	\N	\N
座標	ざひょう	{}	{coordinate(s)}	\N	\N	\N
座布団	ざぶとん	{}	{"cushion (Japanese-- square cushion used when sitting on one´s knees on a tatami-mat floor)"}	\N	\N	\N
残金	ざんきん	{}	{"remaining money"}	\N	\N	\N
残酷	ざんこく	{}	{"cruelty; harshness"}	\N	\N	\N
残高	ざんだか	{}	{"(bank) balance; remainder"}	\N	\N	\N
惨敗	ざんぱい	{}	{"crushing defeat; ignominious defeat"}	\N	\N	\N
残念	ざんねん	{}	{sorry}	\N	\N	\N
前係長	ぜんかかりちょう	{前の係長}	{"previous chief"}	\N	\N	\N
税	ぜい	{}	{tax}	\N	\N	\N
税関	ぜいかん	{}	{"customs house"}	\N	\N	\N
税金	ぜいきん	{}	{"tax; duty"}	\N	\N	\N
贅沢	ぜいたく	{}	{"luxury; extravagance"}	\N	\N	\N
税抜	ぜいぬき	{}	{"excl. tax"}	\N	\N	\N
税務署	ぜいむしょ	{}	{"tax office"}	\N	\N	\N
是正	ぜせい	{}	{"correction; revision"}	\N	\N	\N
絶対	ぜったい	{}	{"absolute; unconditional; absoluteness"}	\N	\N	\N
絶版	ぜっぱん	{}	{"out of print"}	\N	\N	\N
絶壁	ぜっぺき	{切り立ったがけ。懸崖 (けんがい) 。「断崖ー」}	{"a precipice; 〔特に海岸の〕a cliff"}	\N	\N	\N
絶望	ぜつぼう	{希望を失うこと。全く期待できなくなること。「深い―におそわれる」「将来に―する」}	{"despair; hopelessness"}	\N	\N	\N
舌鋒	ぜっぽう	{言葉つきの鋭いことを、ほこさきにたとえていう語。「―鋭く追及する」}	{"scathing (question)"}	\N	\N	\N
絶滅	ぜつめつ	{}	{"destruction; extinction"}	\N	\N	\N
是非	ぜひ	{}	{"certainly; without fail"}	\N	\N	\N
是非とも	ぜひとも	{}	{"by all means (with sense of not taking 'no' for an answer)"}	\N	\N	\N
全	ぜん	{}	{"all; whole; entire; complete; overall; pan-"}	\N	\N	\N
善	ぜん	{}	{"good; goodness; right; virtue"}	\N	\N	\N
膳	ぜん	{}	{"(small) table; tray; meal"}	\N	\N	\N
全員	ぜんいん	{}	{"all members (unanimity); all hands; the whole crew"}	\N	\N	\N
全快	ぜんかい	{}	{"complete recovery of health"}	\N	\N	\N
全形	ぜんけい	{全体の形。すべての形。}	{whole-form}	\N	\N	\N
前後	ぜんご	{}	{"around; throughout; front and back; before and behind; before and after; about that (time); longitudinal; context; nearly; approximately"}	\N	\N	\N
全国	ぜんこく	{}	{"nation-wide; whole country; national"}	\N	\N	\N
禅師	ぜんじ	{}	{"zen master"}	\N	\N	\N
零	ぜろ	{}	{0}	\N	\N	\N
揺り籃	ゆりかご	{赤ん坊を入れて揺り動かすかご。ようらん。}	{cradle}	\N	{揺り籠}	\N
禅	ぜん	{}	{"Zen (Buddhism)"}	\N	{禪}	\N
前者	ぜんしゃ	{}	{"the former"}	\N	\N	\N
全集	ぜんしゅう	{}	{"complete works"}	\N	\N	\N
全身	ぜんしん	{}	{"the whole body; full-length (portrait)"}	\N	\N	\N
前進	ぜんしん	{}	{"advance; drive; progress"}	\N	\N	\N
漸進	ぜんしん	{}	{"progressive; steady advance; gradual process"}	\N	\N	\N
全盛	ぜんせい	{}	{"height of prosperity"}	\N	\N	\N
全然	ぜんぜん	{}	{"wholly; entirely; completely; not at all (with neg. verb)"}	\N	\N	\N
全体	ぜんたい	{あるひとまとまりの物事のすべての部分。「組織の―にかかわる問題」「―の構造を把握する」「画用紙の―を使って描く」「―像」}	{"whole; entirety; whatever (is the matter)"}	\N	\N	\N
前提	ぜんてい	{ある物事が成り立つための、前置きとなる条件。「匿名を―に情報を提供する」「結婚を―につきあう」}	{"preamble; premise; reason; prerequisite"}	\N	\N	\N
全逓	ぜんてい	{「全逓信労働組合」の略称}	{"Japan Postal Workers' Union、JPU"}	\N	\N	\N
前途	ぜんと	{}	{"future prospects; outlook; the journey ahead"}	\N	\N	\N
全般	ぜんぱん	{}	{"whole; universal; wholly; general"}	\N	\N	\N
全部	ぜんぶ	{}	{"all; entire; whole; altogether"}	\N	\N	\N
全滅	ぜんめつ	{}	{annihilation}	\N	\N	\N
全裸	ぜんら	{}	{naked}	\N	\N	\N
善良	ぜんりょう	{}	{"goodness; excellence; virtue"}	\N	\N	\N
前例	ぜんれい	{}	{precedent}	\N	\N	\N
続行	ぞっこう	{引き続いて行うこと。}	{"continue; resume"}	\N	\N	\N
沿い	ぞい	{}	{along}	\N	\N	\N
像	ぞう	{}	{"statue; image; figure; picture; portrait"}	\N	\N	\N
臓器	ぞうき	{}	{"organ (entrails)"}	\N	\N	\N
増強	ぞうきょう	{}	{"augment; reinforce; increase"}	\N	\N	\N
雑巾	ぞうきん	{}	{"dust cloth"}	\N	\N	\N
増減	ぞうげん	{}	{"increase and decrease; fluctuation"}	\N	\N	\N
蔵相	ぞうしょう	{}	{"Minister of Finance"}	\N	\N	\N
増進	ぞうしん	{}	{"promoting; increase; advance"}	\N	\N	\N
造船	ぞうせん	{}	{shipbuilding}	\N	\N	\N
増大	ぞうだい	{}	{enlargement}	\N	\N	\N
草履	ぞうり	{}	{sandals}	\N	\N	\N
族	ぞく	{}	{"〔家族〕a family; 〔種族〕a race; 〔部族〕a tribe; 〔元素などの〕a group"}	\N	\N	\N
属する	ぞくする	{}	{"belong to; come under; be affiliated with; be subject to"}	\N	\N	\N
続々	ぞくぞく	{}	{"successively; one after another"}	\N	\N	\N
揃い	ぞろい	{衣服の色や柄などが同じであること。一組。揃っていること。}	{"team; gathering"}	\N	\N	\N
存知	ぞんじ	{よく知っていること。理解していること。「今は礼儀を―してこそふるまふべきに」}	{well-known}	\N	\N	\N
存じる	ぞんじる	{}	{"(humble) to know"}	\N	\N	\N
存ずる	ぞんずる	{}	{"(humble) to think; feel; consider; know; etc."}	\N	\N	\N
存知	ぞんち	{よく知っていること。理解していること。「今は礼儀を―してこそふるまふべきに」}	{well-known}	\N	\N	\N
図	ず	{}	{"drawing; picture; illustration"}	\N	\N	\N
ず	ず	{"活用語の未然形に付き、断定的な否定判断を表す。ない。ぬ。→ざり →ぬ"}	{"Another way to indicate an action that was done without doing another action is to replace the 「ない」 part of the negative action that was not done with 「ず」.  食べる → 食べない → 食べず 。 行く → 行かない → 行かず"}	\N	\N	\N
随筆	ずいひつ	{}	{"essays; miscellaneous writings"}	\N	\N	\N
随分	ずいぶん	{}	{"pretty much; very much"}	\N	\N	\N
図々しい	ずうずうしい	{}	{"impudent; shameless"}	\N	\N	\N
図鑑	ずかん	{}	{"picture book"}	\N	\N	\N
図形	ずけい	{}	{figure}	\N	\N	\N
涼む	すずむ	{}	{"cool oneself; cool off; enjoy evening cool"}	\N	\N	\N
ずつ	ずつ	{等しい量の繰り返し「少しー元気を回復した」}	{"(one) by (one); (little) by (little)"}	\N	\N	\N
頭痛	ずつう	{}	{headache}	\N	\N	\N
頭脳	ずのう	{}	{"head; brains; intellect"}	\N	\N	\N
象	ぞう	{}	{elephant}	\N	\N	\N
増加	ぞうか	{［名］(スル)物の数量がふえること。また、ふやすこと。増大。増殖。増量。「人口が―する」⇔減少。}	{"increase; addition"}	\N	\N	\N
増殖	ぞうしょく	{ふえること。また、ふやすこと。増加。増大。増量。「資本をーする」}	{"increase; multiplication; propagation"}	{名,スル}	\N	\N
図表	ずひょう	{}	{"chart; diagram; graph"}	\N	\N	\N
滑れる	ずれる	{}	{"slide; slip off"}	\N	\N	\N
ローマ字	ローマじ	{}	{"romanization; Roman letters"}	\N	\N	\N
乗り越える	のりこえる	{物の上を越えて、向こう側へ行く。「塀を―・えて侵入する」,困難などを切り抜けて進む。「人生の荒波を―・える」}	{"〔上を越えて行く〕climb over (e.g. montain; fence)",〔苦難を切り抜ける〕overcome}	\N	\N	\N
ばりばり	ばりばり	{勢いよく裂いたりはがしたりする音や、そのさまを表す語。「ふすま紙を―（と）裂く」「ベニヤを―（と）はがす」「猫が―（と）爪を研ぐ」,固くこわばっているさま。「のりがきいて―（と）した浴衣」「―（と）した強飯 (こわめし) 」}	{"〔引き裂いたりする音〕rip-rip〔硬いこわばった物の音〕crunch-crunch; munch-munch","〔威勢よく行う様子〕(work) hard / energetically"}	\N	\N	\N
中	ちゅう	{}	{"medium; mediocre"}	\N	\N	\N
中	うち	{ある一定の区域・範囲の中。}	{"out of (a group); inside (a group)"}	\N	\N	\N
中	なか	{}	{"inside; middle; among"}	\N	\N	\N
様	よう	{}	{"way; manner; kind; sort; appearance; like; such as; so as to; in order to; so that","〔…らしい〕seems (to be); looks like (e.g. snow is falling); appearantly (e.g. fails)"}	\N	\N	\N
様	さま	{}	{"Mr. or Mrs.; manner; kind; appearance"}	\N	\N	\N
生臭い	なまぐさい	{}	{"smelling of fish or blood; fish or meat<br />臭い(くさい): stinking<br />面倒臭い(めんどうくさい): bother to do; tiresome"}	\N	\N	\N
いらっしゃる	いらっしゃる	{「行く」の尊敬語。おいでになる。「休日にはどこへ―・るのですか」,「来る」の尊敬語。おいでになる。「先生が―・った」,「居る」の尊敬語。おいでになる。「明日は家に―・いますか」}	{"go; leave (for France)","come by","be; be in; be at home"}	\N	\N	\N
改める	あらためる	{新しくする。古いもの、旧来のものを新しいものと入れ替える。「日を＿・める」「第一項は次のように＿・める」,悪い点、不備な点をよいほうへ変える。改善する。「態度をー・める」「悪習をー・める」,正しいかどうか詳しく調べて確かめる。吟味する。「罪状をー・める」「財布の中身をー・める」}	{"renew; change; reform","correct; reform; improve upon","examine; count"}	\N	\N	\N
順応	じゅんのう	{環境や境遇の変化に従って性質や行動がそれに合うように変わること。「新しい生活に―する」「―性」}	{"adapt (oneself); adjust (oneself); conform;"}	\N	\N	\N
世の中	よのなか	{々が互いにかかわり合って生きて暮らしていく場。世間。社会。「―が騒がしくなる」「暮らしにくい―になる」,当世。その時分。「入道殿をはじめ参らせて―におはしある人、参らぬはなかりけり」}	{"society; the world; the times","〔時勢〕times; 〔時代〕an age;"}	\N	\N	\N
行く行く	ゆくゆく	{行く末。やがて。将来。いつか。結局。「ーは家業を継ぐことになる」,歩きながら。道すがら。「何を買おうかとー考えていた」}	{"in the future; someday; in the end","〔途中で〕on the [one's] way"}	\N	\N	\N
設ける	もうける	{前もって用意・準備をする。「一席＿・ける」,建物・機関などを、こしらえる。設置する。「窓口をー・ける」「規則をー・ける」}	{"〔用意する〕provide; prepare","organize; set up; lay down (e.g. rules/laws); make (e.g. excuse)"}	\N	\N	\N
施す	ほどこす	{恵まれない人に物質的な援助を与える。あわれみの気持ちで、人が困っている状態を助けるような行為をする。恵み与える。「難民に食糧を―・す」「医療を―・す」「恩恵を―・す」,効果・影響を期待して、事を行う。「策を―・す」}	{"to donate; to give","to conduct; to apply; to perform"}	\N	\N	\N
変態	へんたい	{形や状態を変えること。また、その形や状態。,普通の状態と違うこと。異常な、または病的な状態。}	{"〔生物の〕(a) metamorphosis ((複-phoses))","〔異常〕abnormality; 〔性的な〕perversion"}	\N	\N	\N
反映	はんえい	{光や色などが反射して光って見えること。「夕日が雪山にーする」,あるものの性質が、他に影響して現れること。反影。また、それを現すこと。「住民の意見を政治にーさせる」}	{reflection,"reflection; influency"}	\N	\N	\N
灰皿	はいさら	{}	{ashtray}	\N	\N	\N
三日月	みかずき	{}	{"new moon; crescent moon"}	\N	\N	\N
温める	あたためる	{程よい温度に高める。あたたかくする。あっためる。「冷えた手を―・める」「ミルクを―・める」}	{"〔熱くする〕warm (up); heat (up)","〔大事にしておく〕take care of (nursing; keep)"}	\N	{暖める}	\N
取り敢えず	とりあえず	{何する間もなく。すぐに。差し当たり。「―応急処置をして、病院へ運ぶ」,ほかのことはさしおいて、まず第一に。なにはさておき。「―母に合格を知らせる」「―お礼まで」}	{"for the time being","first of all"}	{副}	\N	\N
三日月	みかづき	{}	{"new moon; crescent moon"}	\N	\N	\N
丈夫	じょうふ	{}	{"hero; gentleman; warrior; manly person; good health; robustness; strong; solid; durable"}	\N	\N	\N
審判	しんぱん	{}	{"refereeing; trial; judgement; umpire; referee"}	\N	\N	\N
作物	さくもつ	{}	{"literary work"}	\N	\N	\N
傾く	かたぶく	{}	{"to incline toward; to slant; to lurch; to heel over; to be disposed to; to trend toward; to be prone to; to go down (sun); to wane; to sink; to decline"}	\N	\N	\N
不便	ふびん	{}	{"pity; compassion"}	\N	\N	\N
鈍い	にぶい	{}	{"dull (e.g. a knife); thickheaded; slow; stupid"}	\N	\N	\N
一個	いっか	{}	{"1 piece (article)"}	\N	\N	\N
検証	けんしょう	{実際に物事に当たって調べ、仮説などを証明すること。「理論の正しさを―する」,裁判官や捜査機関が、直接現場の状況や人・物を観察して証拠調べをすること。「現場―」「実地―」}	{"〔実証〕(a) verification; verify (a hypothesis)","〔証拠物件などの取り調べ〕(an) inspection"}	\N	\N	\N
参謀	さんぼう	{謀議に加わること。また、その人。「選挙―」,高級指揮官の幕僚として、作戦・用兵などの計画に参与し、補佐する将校。}	{"〔相談役〕an adviser; a counselor，((英)) a counsellor; ((口)) a brain，〔総称〕the brains ((of))","〔軍の〕a staff officer; 〔総称〕the staff"}	\N	\N	\N
継続	けいぞく	{そのまま続くこと,中断してはまた続くこと}	{"continuation (of)","(〜に) continual(ly)"}	\N	\N	\N
覚える	おぼえる	{見聞きした事柄を心にとどめる。記憶する。「子供のころのことはー・えていない」,からだや心に感じる。「疲れをー・える」「愛着をー・える」}	{"learn; remember; bear ((a thing)) in mind; memorize",feel}	\N	\N	\N
応じる	おうじる	{呼びかけに返事をする。応答する。,相手の働きかけに対応して行動を起こす。こたえる。従う,物事の変化に合わせて、それにふさわしく対応する。適合する。「その場に―・じた処置」}	{"in answer to (your question); in response to (his call)","consent; agree (to conditions); accept (an order or challenge); meet/satisfy (a demand)","according to; in proportion to; depends on"}	\N	\N	\N
伺う	うかがう	{「聞く」の謙譲語。拝聴する。お聞きする。「おうわさはかねがね―・っております」,「聞く」の謙譲語。拝聴する。お聞きする。「おうわさはかねがね―・っております」,「訪れる」「訪問する」の謙譲語。「明朝、こちらから―・います」,神仏の託宣を願う。「御神託を―・う」,「尋ねる」「問う」の謙譲語。「この件について御意見をお―・いします」}	{"(polite) ask; inquire; hear; be told;","(polite) 〔聞く〕hear; be told (that)","(polite) 〔訪問する〕visit; call on (a person); call at (a place); pay (a person) a visit","implore (a god for an oracle)","(polite) 〔問う，尋ねる〕ask (about; a person something); inquire (about)"}	\N	\N	\N
糸口	いとぐち	{巻いてある糸の端。糸の先。,きっかけ。手がかり。}	{"the end of a thread","a lead; a clue"}	\N	\N	\N
頂く	いただく	{頭にのせる。かぶる。また、頭上にあるようにする。「王冠を―・く」「雪を―・いた山々」「星を―・いて夜道を行く」,「食う」「飲む」の謙譲語。,「もらう」の謙譲語。「激励の言葉を―・く」,（動詞の未然形に使役の助動詞「せる」「させる」の連用形、接続助詞「て」を添えた形に付いて）自己がある動作をするのを、他人に許してもらう意を表す。「させてもらう」の謙譲語。「あとで読ませて―・きます」「本日は休業させて―・きます」}	{"〔上に載せる〕have (a hat) on; wear (a hat; a crown); be crowned (with)","take food or drink","receive (polite)","receiving something for oneself;   (knitt this/explain this) for me"}	\N	\N	\N
鮮やか	あざやか	{ものの色彩・形などがはっきりしていて、目立つさま。「―な若葉の緑」「印象―な短編小説」,技術・動作などがきわだって巧みであるさま。「―な包丁さばき」}	{"〔色・形などが際立っている様子〕〜な vivid; bright","〔技術などがすぐれている様子〕〜な 〔見事な〕fine; 〔巧みな〕skillful，((英)) skilful"}	\N	\N	\N
ずっと	ずっと	{ある範囲内に、残す所なく動作を及ぼすさま。くまなく。隅から隅まで。「広い校内をー探しまわる」「町じゅうをー見まわる」,ためらわずに、また、とどこおらずに動作をするさま。ずいと。「さあ、ーお通りください」,ほかのものと比べてかけ離れているさま。段違いに。はるかに。「このほうがー大きい」「それよりー以前の話だ」「駅は学校のー先にある」}	{"all the (time; way); the whole (night; way)","straight (to a location); (go) right (in)","long (distance; time)"}	\N	\N	\N
陵	みささぎ	{天皇・皇后などの墓所。御陵。みはか。}	{"emperor's grave; maosoleum"}	\N	\N	\N
陵	りょう	{尾根の長い大きな丘。「丘陵」,天子の墓。日本では、天皇および三后の墓をいう。山陵。丘の形をした大きな墓。みささぎ。「陵墓／古陵・御陵・山陵」}	{"hump; big hill","a mausoleum"}	\N	\N	\N
最早	もはや	{ある事態が変えられないところまで進んでいるさま。今となっては。もう。「―如何ともしがたい」「―これまで」,ある事態が実現しようとしているさま。早くも。まさに。「―今年も暮れようとしている」}	{"already; now","exactly; as early as"}	\N	\N	\N
萌える	もえる	{草木が芽を出す。芽ぐむ。「若草―・える野山」,俗に、ある物や人に対し、一方的で強い愛着心・情熱・欲望などの気持ちをもつ。→萌え}	{"bud; sprout","(also written 萌ゑ) crush (anime; manga term); fascination; infatuation"}	\N	\N	\N
見舞う	みまう	{病人や災難にあった人などを訪れて慰める。また、書面などで安否をたずねる。「けがをした友人を―・う」,望ましくない事が訪れる。災難などが襲う。「パンチを―・う」「台風に―・われる」}	{"〔人を尋ねて慰める〕inquire [ask] after ((a sick person/a person's health))","〔悪い物事が襲う〕meet with (a misfortune); struck (by waves)"}	\N	\N	\N
見事	みごと	{すばらしいこと,完全に}	{"excellent; splendid; fine; supurb; admirable","completely; proper; real"}	\N	\N	\N
風情	ふぜい	{風流・風雅の趣・味わい。情緒。「ーのある庭」,けはい。ようす。ありさま。「どことなく哀れなー」,名詞に付いて、...のようなもの、...に似通ったもの、などの意を表す。}	{"tasteful; elegant; poetic",appearance,"(traders and) the like; (no place for a fellow) like (that)"}	\N	\N	\N
深い	ふかい	{表面から底まで、また入り口から奥までの距離が長い。「―・い川」「―・い茶碗」「椅子に―・く腰掛ける」「山―・く分け入る」「彫りの―・い顔」⇔浅い。,密度が濃い。また、密生している。程度が大きい。「霧が―・い」「―・い草むら」}	{〔底までの隔たりが大きい〕deep,〔程度が大きい〕}	\N	\N	\N
許り	ばかり	{範囲を限定する意を表す。…だけ。…のみ。「あとは清書する―だ」「大きい―が能じゃない」,おおよその程度・分量を表す。…ほど。…くらい。「まだ半分―残っている」「一〇歳―の男の子」}	{"just (play games); nothing but; just (got home); only","about (20 mins); (ten mins) or so; some (20 people)"}	\N	\N	\N
填める	はめる	{ある形に合うように中に入れておさめる。ぴったりと入れ込む。「障子を桟にー・める」「コートのボタンをー・める」,計略にかける。いっぱいくわせる。「罠 (わな) にー・める」「策略にー・められる」}	{"to get in; to insert; to put on; to make love","わなに陥れる〕entrap; 〔だます〕take in"}	\N	\N	\N
走る	はしる	{足をすばやく動かして移動する。駆ける。「ゴールめざして―・る」「通りを―・って渡る」「―・るのが速い動物」,乗り物などが進む。運行する。また、物が速く動く。「駅から遊園地までモノレールが―・っている」「風を受けてヨットが―・る」「雲が―・る」}	{"to run","(vehicle) advance forward / run"}	\N	\N	\N
把握	はあく	{しっかりとつかむこと。手中におさめること。「政権をーする」,しっかりと理解すること。「その場の状況をーする」}	{"(lit.) grasp; catch","(fig.) grasp; catch; understanding"}	\N	\N	\N
望む	のぞむ	{自分の所に来てくれるように働きかける。欲しがる。「後妻にと―・まれる」,はるかに隔てて見る。遠くを眺めやる。「富士を―・む展望台」}	{"〔願望する〕want; wish，((文)) desire ((to do; a person to do))","〔眺める〕see; 〔見渡す〕((場所を主語にして)) command ((a view))"}	\N	\N	\N
半ば	なかば	{壱：半分,弐：ある程度,参：真ん中あたり}	{half,"partly; in part; half; nearly",mid-;halfway}	\N	\N	\N
土台	どだい	{物事の基礎。物事の根本。「信頼関係をーから揺るがす事件」,根本から。はじめから。もともと。「ー無理な相談だ」「ー勝てるはずがない」}	{"(stone or building) foundation; base; basis","foundation (of a person's character); base on (observations)"}	\N	\N	\N
通る	とおる	{往来する。通過する。突き抜ける。入る,認められて成り立つ。認められる。論理的である「法案がー・る」}	{"pass; go along","be accepted; make sense; be reasonable"}	\N	\N	\N
抱く	いだく	{腕でかかえ持つ。だく。「ひしと―・く」「母親の胸に―・かれる」,かかえるように包み込む。「村々を―・く山塊」「大自然の懐に―・かれる」}	{"embrace; hug; harbour; entertain; sleep with","〔心に持つ〕hold; have; bear，((文)) entertain; harbor，((英)) harbour; 〔心の中に大事にしまっておく〕cherish"}	\N	\N	\N
深い	ぶかい	{程度のはなはだしいさまを表す。「情け―・い」「疑り―・い」}	{〔程度が大きい〕}	\N	\N	\N
抱く	だく	{腕を回して、しっかりとかかえるように持つ。「子供を―・く」「肩を―・く」}	{"〔腕にかかえる〕hold ((a person; a thing)) in one's arms〔抱擁する〕embrace; hug"}	\N	\N	\N
家主	いえぬし	{}	{landlord}	\N	\N	\N
雷	いかずち	{}	{thunder}	\N	\N	\N
怒る	いかる	{}	{"to get angry; to be angry"}	\N	\N	\N
一定	いちじょう	{}	{"fixed; settled; definite; uniform; regularized; defined; standardized; certain; prescribed"}	\N	\N	\N
一人	いちにん	{}	{"one person"}	\N	\N	\N
一昨日	いっさくじつ	{}	{"day before yesterday"}	\N	\N	\N
一昨年	いっさくねん	{}	{"year before last"}	\N	\N	\N
間	かん	{時間の隔たり}	{"during (that time); for (30 mins); 〜で in (3 days)"}	\N	\N	\N
少女	おとめ	{}	{"daughter; young lady; virgin; maiden; little girl"}	\N	\N	\N
女子	おなご	{}	{"woman; girl"}	\N	\N	\N
間	ま	{時間,空間,ころあい}	{time,space,"chance; opportune moment"}	\N	\N	\N
灰	あく	{}	{"puckery juice"}	\N	\N	\N
空く	あく	{}	{"become vacant"}	\N	\N	\N
開く	あく	{}	{"open (e.g. a festival)"}	\N	\N	\N
彼方此方	あちらこちら	{}	{"here and there"}	\N	\N	\N
悪口	あっこう	{}	{"abuse; insult; slander; evil speaking"}	\N	\N	\N
後	あと	{}	{"afterwards; since then; in the future"}	\N	\N	\N
上	うえ	{}	{"top; best; superior quality; going up; presenting; showing; aboard a ship or vehicle; from the standpoint of; as a matter of (fact)"}	\N	\N	\N
上下	うえした	{}	{"high and low; up and down; unloading and loading; praising and blaming"}	\N	\N	\N
末	うら	{}	{"top end; tip"}	\N	\N	\N
得る	うる	{}	{"obtain; acquire"}	\N	\N	\N
上手	うわて	{}	{"upper part; upper stream; left side (of a stage); skillful (only in comparisons); dexterity (only in comparisons)"}	\N	\N	\N
描く	かく	{絵・模様や図をえがく。「眉を―・く」「グラフを―・く」}	{"〔鉛筆・クレヨンなどで〕draw; 〔彩色して〕paint"}	\N	\N	\N
画く	えがく	{物の形を絵や図にかき表す。「田園の風景を―・く」}	{"〔鉛筆・ペンなどで〕draw; 〔絵筆で〕paint; sketch"}	\N	\N	\N
役	えき	{}	{"war; campaign; battle"}	\N	\N	\N
得る	える	{}	{"get; gain; win"}	\N	\N	\N
園	えん	{}	{"garden (esp. man-made)"}	\N	\N	\N
縁	えん	{}	{"chance; fate; destiny; relation; bonds; connection; karma"}	\N	\N	\N
塩	えん	{}	{salt}	\N	\N	\N
艶	えん	{}	{"charming; fascinating; voluptuous"}	\N	\N	\N
円	えん	{}	{"yen; circle"}	\N	\N	\N
降りる	おりる	{霧や霜などが地上・空中などに生じる。「露がー・りる」}	{"(e.g. frost;dew) to fall"}	\N	\N	\N
音	おん	{}	{"sound; (music) note"}	\N	\N	\N
禍	か	{災い。ふしあわせ。「―を転じて福となす」⇔福。}	{disaster}	\N	\N	\N
会	かい	{}	{"meeting; assembly; party; association; club"}	\N	\N	\N
重なる	かさなる	{}	{"be piled up; lie on top of one another; overlap each other"}	\N	\N	\N
華奢	かしゃ	{華やかにおごること。はででぜいたくなこと。また、そのさま。}	{"luxury; pomp; delicate; slender; gorgeous"}	\N	\N	\N
火傷	かしょう	{}	{"burn; scald"}	\N	\N	\N
数	かず	{}	{"number; figure"}	\N	\N	\N
各々	おのおの	{}	{"each; every; either; respectively; severally"}	\N	{各各}	\N
間	あいだ	{二つの物・場所にはさまれた部分。ある時からある時までの時間,あるグループの人たちの範囲。関係。間柄}	{"between; during","among (e.g. men/pictures); between (us); among (e.g. four pics); (born) of (Greek))"}	\N	\N	\N
上げる	あげる	{物の位置を低い所から高い所に移す。「箱を棚に―・げる」「幕を―・げる」「すだれを―・げる」⇔下ろす。,人の目についたり、広く知られるようにする。}	{"raise; elevate","bring to attention; mention"}	\N	\N	\N
動く	うごく	{}	{"to move; to stir; to shift; to shake; to swing; to operate; to run; to go; to work; to be touched; to be influenced; to waver; to fluctuate; to vary; to change; to be transferred",move}	\N	\N	\N
描く	えがく	{物の形を絵や図にかき表す。「田園の風景を―・く」,物事のありさまを文章や音楽などで写し出す。描写する。表現する。「下町の生活を―・いた小説」}	{"〔鉛筆・ペンなどで〕draw; 〔絵筆で〕paint; sketch","〔表現する〕describe; ((文)) depict"}	\N	\N	\N
居る	おる	{人が存在する。そこにいる。「海外に何年―・られましたか」,（「おります」の形で、自分や自分の側の者についていう）「いる」の丁寧な言い方。「五時までは会社に―・ります」}	{"be here (polite)","be here (polite)"}	\N	\N	\N
越す	こす	{ある物の上を通り過ぎて一方から他方へ行く。また、難所や障害となるものを通って、その先へ行く。「塀を―・す」「難関を―・す」「峠を―・す」,「行く」「来る」の意の尊敬語。「どちらへお―・しですか」「またお―・しください」}	{"〔横切る〕cross; 〔通り過ぎる〕pass","come over (here to e.g. the hospital)"}	\N	\N	\N
流石	さすが	{あることを認めはするが、特定の条件下では、それと相反する感情を抱くさま。そうは言うものの。それはそうだが、やはり。「味はよいが、これだけ多いと―に飽きる」「非はこちらにあるが、一方的に責められると―に腹が立つ」,予想・期待したことを、事実として納得するさま。また、その事実に改めて感心するさま。なるほど、やはり。「一人暮らしは―に寂しい」「―（は）ベテランだ」}	{"as one would expect","good; see ... (we can do it)"}	\N	\N	\N
添える	そえる	{主となるもののそばにつける。補助として付け加える。「贈り物に手紙を―・える」「薬味を―・える」「介護の手を―・える」,付き添わせる。付き従わせる。「旅行に案内役を―・える」}	{"〔そばに付けておく〕attach (to)","〔付け加える〕add (to)"}	\N	\N	\N
其処で	そこで	{前述の事柄を受けて、次の事柄を導く。それで。そんなわけで。「いろいろ意見された。ー考えた」,話題をかえたり、話題をもとにもどしたりすることを示す。さて。}	{"So then; that was why","now; ..; Okay; .."}	\N	\N	\N
陣	じん	{軍隊を配置して備えること。「背水のー」,軍隊の集結している所。兵営。陣地。陣営。「ーを張る」,いくさ。たたかい。合戦。「大坂夏のー」}	{camp,"a position (in battle)","battle; (ett slag)"}	\N	\N	\N
条	じょう	{細長いものを数えるのに用いる。「帯一―」「一―の川」,いくつかに分かれた事項の数を数えるのに用いる。「十七―の憲法」「第一―」}	{"counter for long things","Article (9 of the Constitution)"}	\N	\N	\N
兆	ちょう	{古代の占いで、亀の甲を焼いてできる裂け目の形。転じて、物事が起こる前ぶれ。きざし。しるし。「災いのー」,数の単位。1億の1万倍。10の12乗。古くは中国で1億の10倍。「八―円の予算」}	{"〔兆候〕⇒きざし(兆し) omen","〔数〕a trillion，((英)) a billion"}	\N	\N	\N
釣	つり	{}	{"change (e.g. for a dollar)",fishing}	\N	\N	\N
迷う	まよう	{どうしたらよいか決断がつかない。「進学か就職かで―・う」「判断に―・う」,まぎれて、進むべき道や方向がわからなくなる。「山中で道に―・う」}	{"〔思い惑う〕be at a loss; 〔決断できない〕be irresolute","〔道が分からなくなる〕get lost; lose one's way ((in a wood)); 〔はぐれる〕stray"}	\N	\N	\N
無駄	むだ	{役に立たないこと。それをしただけのかいがないこと。益がないこと,浪費}	{"useless; no use","waste; wastefulness"}	\N	\N	\N
綿	わた	{}	{"cotton; padding"}	\N	\N	\N
私	わたくし	{}	{"I (formal); myself; private affairs"}	\N	\N	\N
世辞	せじ	{他人に対する愛想のよい言葉。人に気に入られるような上手な口ぶり。「―がうまい」}	{"flattery; compliment"}	\N	\N	\N
蛇	へび	{}	{"a snake; 〔大蛇〕a serpent"}	{動物}	\N	\N
虎	とら	{}	{"〔動物〕〔雄〕a tiger; 〔雌〕a tigress; 〔子〕a tiger cub","〔酔っぱらい〕a drunk"}	{動物}	\N	\N
けれども	けれども	{}	{"〔逆の関係を示して〕though; although⇒しかし",〔特別の意味なしに前後を結びつけて〕,〔特別の意味なしに前後を結びつけて〕}	\N	{けれど,けど}	\N
会長	かいちょう	{}	{"the chairman (of the board of directors)"}	\N	\N	\N
餓鬼	がき	{"1 生前の悪行のために餓鬼道に落ち、いつも飢えと渇きに苦しむ亡者。",2《食物をがつがつ食うところから》子供を卑しんでいう語。「手に負えないーだ」}	{"〔餓鬼道の亡者〕a starving ghost","〔子供〕a brat"}	\N	\N	\N
擦る	かする	{}	{"to touch lightly; to take a percentage (from)"}	\N	\N	\N
方々	かたがた	{}	{"persons; all people; this and that; here and there; everywhere; any way; all sides"}	\N	\N	\N
日付	かづけ	{}	{"date; dating"}	\N	\N	\N
門	かど	{}	{gate}	\N	\N	\N
角	かど	{}	{"corner; horn"}	\N	\N	\N
金	かね	{}	{"money; metal"}	\N	\N	\N
金庫	かねぐら	{}	{"safe; vault; treasury; provider of funds"}	\N	\N	\N
下品	かひん	{}	{"inferior article"}	\N	\N	\N
上	かみ	{}	{"top; head; upper part; emperor; a superior; upper part of the body; the above"}	\N	\N	\N
雷	かみなり	{}	{thunder}	\N	\N	\N
瓶	かめ	{}	{"earthenware pot"}	\N	\N	\N
身体	からだ	{}	{"the body"}	\N	\N	\N
体	からだ	{}	{"appearance; air; condition; state; form"}	\N	\N	\N
側	かわ	{}	{"side; row; surroundings; part; (watch) case"}	\N	\N	\N
冠	かん	{}	{"crown; diadem; first; best; peerless; cap; naming; designating; initiating on coming of age; top character radical"}	\N	\N	\N
乾	かん	{}	{"heaven; emperor"}	\N	\N	\N
管	かん	{}	{"pipe; tube"}	\N	\N	\N
館	かん	{}	{"house; hall; building; hotel; inn; guesthouse"}	\N	\N	\N
冠	かんむり	{}	{"crown; cap; first; best; peerless; naming; designating; top kanji radical"}	\N	\N	\N
傷	きず	{}	{"wound; injury; hurt; cut; gash; bruise; scratch; scar; weak point"}	\N	\N	\N
来る	きたる	{}	{"to come; to arrive; to be due to; to be next; to be forthcoming"}	\N	\N	\N
気配	きはい	{}	{"indication; market trend; worry"}	\N	\N	\N
君	きみ	{}	{you}	\N	\N	\N
客	きゃく	{}	{"guest; customer"}	\N	\N	\N
客人	きゃくじん	{客として来ている人。}	{guest}	\N	\N	\N
華奢	きゃしゃ	{姿かたちがほっそりして、上品に感じられるさま。繊細で弱々しく感じられるさま。「―なからだつき」}	{"〜な 〔ひ弱な感じの〕delicate; 〔ほっそりした〕slender; slim"}	\N	\N	\N
球	きゅう	{}	{"globe; sphere; ball"}	\N	\N	\N
今日	きょう	{}	{"today; this day"}	\N	\N	\N
姉妹	きょうだい	{}	{sisters}	\N	\N	\N
着る	きる	{衣類などを身につける。}	{"put on; wear"}	\N	\N	\N
際	きわ	{}	{"edge; brink; verge; side"}	\N	\N	\N
木綿	きわた	{}	{cotton}	\N	\N	\N
金	きん	{}	{"metal; money; gold"}	\N	\N	\N
金色	きんいろ	{金のような輝きのある黄色。こがねいろ。こんじき。「―の穂波」}	{"golden; golden-colored"}	\N	\N	\N
近々	きんきん	{}	{"nearness; before long"}	\N	\N	\N
金庫	きんこ	{}	{"safe; vault; treasury; provider of funds"}	\N	\N	\N
九	く	{}	{nine}	\N	\N	\N
潜る	くぐる	{}	{"to drive; to pass through; to evade; to hide; to dive (into or under water); to go underground"}	\N	\N	\N
管	くだ	{}	{"pipe; tube"}	\N	\N	\N
下る	くだる	{}	{"go down; descend; leave"}	\N	\N	\N
国境	くにざかい	{}	{"national or state border"}	\N	\N	\N
包む	くるむ	{}	{"to be engulfed in; to be enveloped by; to wrap up; to tuck in; to pack; to do up; to cover with; to dress in; to conceal"}	\N	\N	\N
剣	けん	{両刃 (もろは) の刀。また、広く両刃・片刃の区別なく大刀 (だいとう) をいう。つるぎ。太刀 (たち) }	{"a sword; 〔フェンシング用〕an epee; 〔短剣〕a dagger"}	\N	\N	\N
戸	こ	{}	{"counter for houses"}	\N	\N	\N
工場	こうじょう	{}	{factory}	\N	\N	\N
工場	こうば	{}	{"factory; plant; mill; workshop"}	\N	\N	\N
紅葉	こうよう	{}	{"autumn colours"}	\N	\N	\N
堪える	こたえる	{}	{"to bear; to stand; to endure; to put up with; to support; to withstand; to resist; to brave; to be fit for; to be equal to"}	\N	\N	\N
国境	こっきょう	{隣接する国と国との境目。国家主権の及ぶ限界。河川・山脈などによる自然的なものと、協定などによって人為的に決定するものとがある。くにざかい。}	{"national or state border"}	\N	\N	\N
この間	このあいだ	{}	{"the other day; lately; recently"}	\N	\N	\N
この間	このかん	{}	{"during this time"}	\N	\N	\N
堪える	こらえる	{}	{"to bear; to stand; to endure; to put up with; to support; to withstand; to resist; to brave; to be fit for; to be equal to"}	\N	\N	\N
凝る	こる	{冷えて固まる。凍る。「露が―・って霜になる時節なので」}	{"〔筋肉が固くなる〕become stiff"}	\N	\N	\N
頃	ころ	{}	{"time; about; toward; approximately (time)"}	\N	\N	\N
魂	こん	{}	{"soul; spirit"}	\N	\N	\N
盛る	さかる	{勢いが盛んになる。「火が―・る」「燃え―・る炎」}	{"to prosper; to flourish; to copulate (animals)"}	\N	\N	\N
桟橋	さんばし	{船を横づけにして、人の乗り降りや貨物の積みおろしなどができるように、岸から水上に突き出して造った構築物。床面を木・鉄・コンクリートなどの柱で支える。}	{"a pier; a jetty; a wharf ((複wharves))"}	\N	\N	\N
四	し	{}	{four}	\N	\N	\N
市	し	{}	{"market; fair"}	\N	\N	\N
次	し	{}	{"order; sequence; times; next; below"}	\N	\N	\N
氏	し	{}	{"family name; lineage"}	\N	\N	\N
塩	しお	{}	{salt}	\N	\N	\N
市場	しじょう	{売り手と買い手とが特定の商品や証券などを取引する場所。中央卸売市場・証券取引所（金融商品取引所）・商品取引所など。マーケット。}	{"a market; 〔取り引き所〕an exchange"}	\N	\N	\N
下	した	{}	{"under; below; beneath"}	\N	\N	\N
認める	したためる	{}	{"to write up"}	\N	\N	\N
品	しな	{}	{"thing; article; goods; dignity; counter for meal courses"}	\N	\N	\N
姉妹	しまい	{}	{sisters}	\N	\N	\N
種	しゅ	{}	{"kind; variety; species"}	\N	\N	\N
背負う	しょう	{}	{"to be burdened with; to carry on back or shoulder"}	\N	\N	\N
傷	しょう	{}	{"wound; injury; hurt; cut; gash; bruise; scratch; scar; weak point"}	\N	\N	\N
象	しょう	{}	{phenomenon}	\N	\N	\N
消耗	しょうこう	{}	{"exhaustion; consumption"}	\N	\N	\N
少女	しょうじょ	{}	{"daughter; young lady; virgin; maiden; little girl"}	\N	\N	\N
退く	しりぞく	{}	{"to retreat; to recede; to withdraw"}	\N	\N	\N
商人	しょうにん	{}	{"trader; shopkeeper; merchant"}	\N	\N	\N
消耗	しょうもう	{使って減らすこと。また、使って減ること。「電力を―する」}	{"exhaustion; consumption"}	\N	\N	\N
所々	しょしょ	{}	{"here and there; some parts (of something)"}	\N	\N	\N
退ける	しりぞける	{}	{"to repel; to drive away"}	\N	\N	\N
印	しるし	{}	{"seal; stamp; mark; print"}	\N	\N	\N
身体	しんたい	{}	{"body; health"}	\N	\N	\N
玉	ぎょく	{}	{"king (shogi)"}	\N	\N	\N
下品	げひん	{}	{"inferior article"}	\N	\N	\N
原	げん	{}	{"original; primitive; primary; fundamental; raw"}	\N	\N	\N
現場	げんじょう	{}	{"actual spot; scene; scene of the crime"}	\N	\N	\N
強気	ごうぎ	{}	{"great; grand"}	\N	\N	\N
応え	ごたえ	{}	{"well worth (e.g. reading); rich in (content); e.g. 遊び＿ well worth playing"}	\N	\N	\N
数	すう	{}	{"number; (mathematics) function"}	\N	\N	\N
空く	すく	{ある空間を満たしていた人や物が少なくなって、あきができる。まばらになる。減る。「がらがらに―・いた電車」「道路が―・く」}	{"be less crowded; open; become open; become empty"}	\N	\N	\N
角	すみ	{}	{"corner; nook"}	\N	\N	\N
天皇	すめらぎ	{}	{"Emperor of Japan"}	\N	\N	\N
為る	する	{}	{"do; try; play; practice; cost; serve as; pass; elapse"}	\N	\N	\N
末	すえ	{"1 （本 (もと) に対して）続いているものの先端の方。末端。「毛の―」","2 今からのち。行く末。将来。「―が思いやられる」","3 一番あとに生まれた子。末っ子。「―は女です」",ある期間の終わりのほう。「今月の―」}	{"〔端，終わり〕(at) the end","〔将来〕the future","〔末っ子〕youngest child","〔端・終わり〕(at) the end (e.g. of September)"}	\N	\N	\N
空	そら	{頭上はるかに高く広がる空間。天。天空。「鳥のようにーを飛び回りたい」,その人の居住地や本拠地から遠く離れている場所。または、境遇。「異国のー」「旅のー」,心の状態。心持ち。心地。また、心の余裕。「生きたーもない」,それらしく思われるが実際はそうでない、という意を表す。うそ。いつわり。「ー涙」「ー笑い」「ーとぼける」,すっかり覚え込んでいて、書いたものなどを見ないで済むこと。「山手線の駅名をーで言える」}	{sky,"land; place; location;","feelings; emotion","pretending; lie","(learn) by heart; (recite) from memory"}	\N	\N	\N
戯れる	ざれる	{ふざける。たわむれる。「男女が―・れる」}	{"play around"}	\N	\N	\N
実	じつ	{}	{"truth; reality; sincerity; fidelity; kindness; faith; substance; essence"}	\N	\N	\N
十分	じっぷん	{}	{"10 minutes"}	\N	\N	\N
戯れる	じゃれる	{ふざけたわむれる。まつわりついてたわむれる。「子猫がまりに―・れる」}	{play}	\N	\N	\N
上下	じょうげ	{}	{"high and low; up and down; unloading and loading; praising and blaming"}	\N	\N	\N
堪える	たえる	{}	{"to bear; to stand; to endure; to put up with; to support; to withstand; to resist; to brave; to be fit for; to be equal to"}	\N	\N	\N
丈	たけ	{}	{"height; stature; length; measure; all (one has)"}	\N	\N	\N
畳	たたみ	{}	{"tatami mat"}	\N	\N	\N
唯	ただ	{}	{"free of charge; mere; sole; only; usual; common"}	\N	\N	\N
館	たち	{}	{"mansion; small castle"}	\N	\N	\N
唯	たった	{}	{"only; merely; no more than"}	\N	\N	\N
他人	たにん	{}	{"another person; unrelated person; outsider; stranger"}	\N	\N	\N
種	たね	{}	{"seed; kind; variety; quality; tone; material; matter; subject; theme; (news) copy; cause; source; trick; secret; inside story"}	\N	\N	\N
度	たび	{}	{"times (three times; etc.); degree"}	\N	\N	\N
玉	たま	{}	{"ball; sphere; coin"}	\N	\N	\N
球	たま	{}	{"globe; sphere; ball"}	\N	\N	\N
魂	たましい	{生きものの体の中に宿って、心の働きをつかさどると考えられるもの。古来、肉体を離れても存在し、不滅のものと信じられてきた。霊魂。たま。「―が抜けたようになる」「仏作って―入れず」}	{"〔霊魂〕a soul〔心・気力〕spirit"}	\N	\N	\N
例	ためし	{}	{"instance; example; case; precedent; experience; custom; usage; parallel; illustration"}	\N	\N	\N
誰	たれ	{}	{"adjectival suffix for a person"}	\N	\N	\N
値	ち	{}	{value}	\N	\N	\N
近々	ちかぢか	{}	{"nearness; before long"}	\N	\N	\N
父母	ちちはは	{}	{"father and mother; parents"}	\N	\N	\N
昼間	ちゅうかん	{}	{"daytime; during the day"}	\N	\N	\N
中指	ちゅうし	{}	{"middle finger"}	\N	\N	\N
次	つぎ	{}	{"next; stage station; stage; subsequent"}	\N	\N	\N
月日	つきひ	{}	{"(the) date"}	\N	\N	\N
突く	つく	{とがった物で一つ所を勢いよく刺したり、強く当てたりする。「槍で―・く」}	{"thrust; strike; attack; poke; nudge; pick at"}	\N	\N	\N
吐く	つく	{好ましくないことを口に出して言う。「悪態をー・く」「うそをー・く」}	{"told/spit (a lie); drew (e.g. a sigh of relief)"}	\N	\N	\N
注ぐ	つぐ	{}	{"pour (in); fill (with)"}	\N	\N	\N
途中	つちゅう	{}	{"on the way; en route"}	\N	\N	\N
銃	つつ	{}	{gun}	\N	\N	\N
突く	つつく	{}	{"to thrust; to strike; to attack; to poke; to nudge; to pick at"}	\N	\N	\N
包む	つつむ	{}	{"wrap; pack"}	\N	\N	\N
伝言	つてごと	{}	{"verbal message; rumor; word"}	\N	\N	\N
体	てい	{}	{"appearance; air; condition; state; form"}	\N	\N	\N
梯子	ていし	{}	{"ladder; stairs"}	\N	\N	\N
的	てき	{}	{"-like; typical"}	\N	\N	\N
敵	てき	{}	{"foe; enemy; rival"}	\N	\N	\N
店	てん	{}	{"store; shop; establishment"}	\N	\N	\N
天皇	てんのう	{}	{"Emperor of Japan"}	\N	\N	\N
都	と	{}	{"metropolitan; municipal"}	\N	\N	\N
等	とう	{}	{"et cetera; etc.; and the like"}	\N	\N	\N
床	とこ	{}	{"bed; sickbed; alcove; padding"}	\N	\N	\N
所々	ところどころ	{}	{"here and there; some parts (of something)"}	\N	\N	\N
年月	としつき	{}	{"months and years"}	\N	\N	\N
途中	とちゅう	{出発してから目的地に着くまでの間。まだ目的地に到着しないうち。「出勤―の事故」「―で引き返す」}	{"on the way"}	\N	\N	\N
幕	とばり	{}	{"curtain; bunting; act (in play)"}	\N	\N	\N
止まる	とまる	{動いていたものが動かなくなる。動きをそこでやめた状態になる。停止する。「時計が―・る」「特急の―・る駅」「エンジンが―・る」}	{"come to a halt"}	\N	\N	\N
留まる	とまる	{一定期間ある場所にいること。動作として止まっているとは限らない。}	{"fasten; turn off; detain"}	\N	\N	\N
灯	ともしび	{}	{light}	\N	\N	\N
誰	だれ	{}	{who}	\N	\N	\N
度	ど	{}	{"time (occurrence); system"}	\N	\N	\N
銅	どう	{}	{copper}	\N	\N	\N
退く	どく	{}	{"retreat; recede; withdraw"}	\N	\N	\N
生	なま	{}	{"raw; unprocessed"}	\N	\N	\N
平均	ならし	{}	{"equilibrium; balance; average; mean"}	\N	\N	\N
為る	なる	{}	{"change; be of use; reach to"}	\N	\N	\N
南	なん	{}	{south}	\N	\N	\N
悪い	にくい	{}	{"hateful; abominable; poor-looking"}	\N	\N	\N
二人	ににん	{}	{"two persons; two people; pair; couple"}	\N	\N	\N
入る	はいる	{}	{"enter; break into; join; enroll; contain; hold; accommodate; have (an income of)"}	\N	\N	\N
吐く	はく	{}	{"breathe; tell (lies); vomit"}	\N	\N	\N
弾く	ひく	{}	{"play (piano; guitar)"}	\N	\N	\N
額	ひたい	{}	{"forehead; brow"}	\N	\N	\N
日付	ひづけ	{}	{date}	\N	\N	\N
人	ひと	{}	{"man; person; human being; mankind; people; character; personality; true man; man of talent; adult; other people; messenger; visitor"}	\N	\N	\N
一言	ひとこと	{}	{"single word"}	\N	\N	\N
一人	ひとり	{}	{"one person"}	\N	\N	\N
暇	ひま	{}	{"free time; leisure; leave; spare time; farewell"}	\N	\N	\N
表	ひょう	{}	{"table (in a document); chart; list"}	\N	\N	\N
開く	ひらく	{}	{"to open"}	\N	\N	\N
昼間	ひるま	{}	{"daytime; during the daytime"}	\N	\N	\N
品	ひん	{}	{"article; item"}	\N	\N	\N
二人	ふたり	{}	{"two persons; two people; pair; couple"}	\N	\N	\N
仏	ふつ	{}	{French}	\N	\N	\N
不定	ふてい	{決まっていないこと。一定しないこと。また、そのさま。「居所が―な人」「住所―」}	{"〜の〔不安定な〕unsettled; 〔不明確な〕indefinite"}	\N	\N	\N
不定	ふじょう	{さだまらないこと。確かでないこと。また、そのさま。ふてい。「老少―」「生死 (しょうじ) ―」}	{"unforseen; uncertain; unexpected"}	\N	\N	\N
父母	ふぼ	{}	{"father and mother; parents"}	\N	\N	\N
文	ふみ	{}	{"letter; writings"}	\N	\N	\N
糞	ふん	{動物が肛門から排泄 (はいせつ) する食物のかす。大便。くそ。}	{"excrement; ((文))((米)) feces，((英)) faeces [físiz]; ((俗)) a turd; ((卑)) shit; 〔牛・馬など大きい動物の〕dung; 〔特に鳥の〕droppings"}	\N	\N	\N
平均	へいきん	{}	{"equilibrium; balance; average; mean"}	\N	\N	\N
牛	うし	{}	{cow}	{動物}	\N	\N
何々	なになに	{}	{"such and such; What?; What is the matter?"}	\N	{何何}	\N
方々	ほうぼう	{}	{"persons; this and that; here and there; everywhere; any way; all sides; all people"}	\N	\N	\N
外	ほか	{}	{"other place; the rest"}	\N	\N	\N
他	ほか	{}	{"other (especially places and things)"}	\N	\N	\N
骨	ほね	{}	{bone}	\N	\N	\N
判	ばん	{}	{"size (of paper or books)"}	\N	\N	\N
病	びょう	{やむ。やまい。「病気」悪いこと。欠点。「病弊」}	{"sickness; bad point"}	\N	\N	\N
瓶	びん	{}	{"bottle; vase; vial"}	\N	\N	\N
打つ	ぶつ	{}	{"hit; strike"}	\N	\N	\N
分	ぶん	{}	{"part; segment; share; ration; rate; degree; one´s lot; one´s status; relation; duty; kind; lot; in proportion to; just as much as"}	\N	\N	\N
文	ぶん	{}	{sentence}	\N	\N	\N
幕	まく	{}	{"curtain; screen"}	\N	\N	\N
呪い	まじない	{神仏その他不可思議なものの威力を借りて、災いや病気などを起こしたり、また除いたりする術。「―をかける」「人前でもあがらないお―」}	{"(an) incantation"}	\N	\N	\N
未だ	まだ	{}	{"yet; still; more; besides"}	\N	\N	\N
街	まち	{}	{street}	\N	\N	\N
万	まん	{}	{"10;000; ten thousand; myriad(s); all; everything"}	\N	\N	\N
刃	やいば	{刀剣・刃物などの総称。「―を交える」「―を向ける」}	{"〔刀身〕a blade; 〔刀〕a sword"}	\N	\N	\N
夜行	やぎょう	{}	{"walking around at night; night train; night travel"}	\N	\N	\N
役	やく	{}	{"use; service; role; position"}	\N	\N	\N
訳	やく	{}	{translation}	\N	\N	\N
火傷	やけど	{}	{"burn; scald"}	\N	\N	\N
夜行	やこう	{}	{"walking around at night; night train; night travel"}	\N	\N	\N
養う	やしなう	{養育する}	{"bring up; rear; raise"}	\N	\N	\N
夜中	やちゅう	{}	{"all night; the whole night"}	\N	\N	\N
病	やまい	{病気。わずらい。「胸の―」}	{"〔病気〕illness; 〔特定の病気〕a disease〔悪癖〕a bad habit"}	\N	\N	\N
例	れい	{}	{"instance; example; case; precedent; experience; custom; usage; parallel; illustration"}	\N	\N	\N
禍	わざわい	{災い。ふしあわせ。「―を転じて福となす」⇔福。}	{disaster}	\N	\N	\N
客人	まろうど	{訪ねて来た人。きゃく。きゃくじん。}	{guests}	\N	{賓,客}	\N
背負う	せおう	{}	{"be burdened with; carry on back or shoulder"}	\N	\N	\N
前	せん	{}	{before}	\N	\N	\N
起こす	おこす	{横になっているものを立たせる。「からだを―・す」,目を覚まさせる。「寝入りばなを―・される」,今までなかったものを新たに生じさせる。「風力を利用して電気を―・す」「波を―・す」,平常と異なる状態や、好ましくない事態を生じさせる。ひきおこす。「革命を―・す」「事故を―・す」,""}	{〔横になったものを立てる〕raise,"〔目を覚まさせる〕wake (up)","〔始める〕start; begin","〔引き起こす〕cause; bring about","〔設立する〕establish; found"}	\N	\N	\N
行書	ぎょうしょ	{漢字の書体の一。楷書をやや崩した書体で、楷書と草書の中間にあたる。}	{"Semi-cursive script is a cursive style of Chinese characters. Because it is not as abbreviated as cursive; most people who can read regular script can read semi-cursive."}	{書体}	\N	\N
魚	さかな	{}	{fish}	{動物}	\N	\N
申	さる	{十二支の9番目。}	{"〔十二支の一つ〕the Monkey (the ninth of the twelve signs of the Chinese zodiac); 〔方角〕west-southwest; west by southwest; 〔時刻〕the hour of the Monkey (4:00 p.m.; or the hours between 3:00 p.m. and 5:00 p.m.)"}	{動物}	\N	\N
辰	しん	{十二支の一つで、その5番目。}	{"〔十二支の一つ〕the Dragon (the fifth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Dragon (8:00 a.m. or the hours between 7:00 a.m. and 9:00 a.m.); 〔方角〕east-southeast"}	{動物}	\N	\N
午	ご	{十二支の7番目。うま。}	{"〔十二支の一つ〕the Horse (the seventh of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Horse (noon or the hours between 11:00 a.m. and 1:00 p.m.); 〔方角〕south"}	{動物}	\N	\N
竜	たつ	{「りゅう（竜）」に同じ。}	{"a dragon"}	{動物}	\N	\N
辰	たつ	{十二支の一つで、その5番目。}	{"〔十二支の一つ〕the Dragon (the fifth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Dragon (8:00 a.m. or the hours between 7:00 a.m. and 9:00 a.m.); 〔方角〕east-southeast"}	{動物}	\N	\N
酉	とり	{十二支の一つで、その10番目。}	{"〔十二支の一つ〕the Cock (the tenth of the twelve signs of the Chinese zodiac); 〔方角〕west; 〔時刻〕the hour of the Cock (6:00 p.m. or the hours between 5:00 p.m. and 7:00 p.m.)"}	{動物}	\N	\N
豹	ひょう	{}	{panther}	{動物}	\N	\N
蛍	ほたる	{}	{firefly}	{動物}	\N	\N
猛虎	もうこ	{}	{"fierce tiger"}	{動物}	\N	\N
龍	りゅう	{}	{"a dragon"}	{動物}	{竜}	\N
子	し	{十二支の一で、その1番目。}	{"〔十二支の一つ〕the Rat (the first of the twelve signs of the Chinese zodiac); 〔方角〕north; 〔時刻〕the hour of the Rat (midnight or the hours between 11:00 p.m. and 1:00 a.m.)"}	{動物}	\N	{ね}
寅	とら	{十二支の一つで、その3番目。}	{"〔十二支の一つ〕the Tiger (the third of the twelve signs of the Chinese zodiac); 〔方角〕east-northeast; 〔時刻〕the hour of the Tiger (4:00 a.m. or the hours between 3:00 a.m. and 5:00 a.m.)"}	{動物}	\N	{いん}
未	ひつじ	{十二支の8番目。}	{"〔十二支の一つ〕the Sheep; the eighth of the twelve signs of the Chinese Zodiac; 〔時刻〕the hour of the Sheep; 2:00 p.m.; the hours between 1:00 p.m. and 3:00 p.m.; 〔方角〕south-southwest"}	{動物}	\N	{び}
楷書	かいしょ	{漢字の書体の一。点画を正確に書き、現在、最も標準的な書体とされている。隷書から転じたもので、六朝 (りくちょう) 中期に始まり唐のころ完成した。真書。正書。}	{"Regular script. also called 正楷. is the newest of the Chinese script styles (appearing by the Cao Wei dynasty ca. 200 CE and maturing stylistically around the 7th century); hence most common in modern writings and publications (after the Ming and sans-serif styles; used exclusively in print)."}	{書体}	\N	\N
楷書体	かいしょたい	{漢字の書体の一。点画を正確に書き、現在、最も標準的な書体とされている。隷書から転じたもので、六朝 (りくちょう) 中期に始まり唐のころ完成した。真書。正書。}	{"Regular script. also called 正楷. is the newest of the Chinese script styles (appearing by the Cao Wei dynasty ca. 200 CE and maturing stylistically around the 7th century); hence most common in modern writings and publications (after the Ming and sans-serif styles; used exclusively in print)."}	{書体}	\N	\N
行書体	ぎょうしょたい	{漢字の書体の一。楷書をやや崩した書体で、楷書と草書の中間にあたる。}	{"Semi-cursive script is a cursive style of Chinese characters. Because it is not as abbreviated as cursive; most people who can read regular script can read semi-cursive."}	{書体}	\N	\N
草書	そうしょ	{書体の一。古くは、篆隷 (てんれい) を簡略にしたもの。後代には、行書 (ぎょうしょ) をさらに崩して点画を略し、曲線を多くしたもの。そう。そうがき。}	{"〔字体〕the fully cursive style of writing (Chinese characters); 〔文字〕a character written in 「a cursive hand [the cursive style]"}	{書体}	\N	\N
草書体	そうしょたい	{書体の一。古くは、篆隷 (てんれい) を簡略にしたもの。後代には、行書 (ぎょうしょ) をさらに崩して点画を略し、曲線を多くしたもの。そう。そうがき。}	{"〔字体〕the fully cursive style of writing (Chinese characters); 〔文字〕a character written in 「a cursive hand [the cursive style]"}	{書体}	\N	\N
篆書	てんしょ	{中国で秦以前に使われた書体。大篆と小篆とがあり、隷書・楷書のもとになった。印章・碑銘などに使用。篆。}	{"a style of writing Chinese characters (mainly used for seals); a tensho hand. The seal script (often called 'small seal' script) is the formal script of the Qín system of writing; which evolved during the Eastern Zhōu dynasty in the state of Qín and was imposed as the standard in areas Qín gradually conquered. Although some modern calligraphers practice the most ancient oracle bone script as well as various other scripts older than seal script found on Zhōu dynasty bronze inscriptions; seal script is the oldest style that continues to be widely practiced."}	{書体}	\N	\N
隷書	れいしょ	{漢字の書体の一。秦の程邈 (ていばく) が小篆 (しょうてん) を簡略化して作ったものといわれる。漢代に装飾的になり、後世、これを八分 (はっぷん) または漢隷、それ以前のものを古隷といって区別した。現在は一般に八分をさす。→八分}	{"Clerical script; also formerly chancery script; is an archaic style of Chinese calligraphy which evolved in the Warring States period to the Qin dynasty; was dominant in the Han dynasty; and remained in use through the Wei-Jin periods."}	{書体}	\N	\N
隷書体	れいしょたい	{漢字の書体の一。秦の程邈 (ていばく) が小篆 (しょうてん) を簡略化して作ったものといわれる。漢代に装飾的になり、後世、これを八分 (はっぷん) または漢隷、それ以前のものを古隷といって区別した。現在は一般に八分をさす。→八分}	{"Clerical script; also formerly chancery script; is an archaic style of Chinese calligraphy which evolved in the Warring States period to the Qin dynasty; was dominant in the Han dynasty; and remained in use through the Wei-Jin periods."}	{書体}	\N	\N
狛犬	こまいぬ	{}	{"(mythologic) dog"}	{動物}	\N	\N
鮭	さけ	{}	{bass}	{動物}	\N	\N
猿	さる	{}	{monkey}	{動物}	\N	\N
獅子	しし	{}	{lion}	{動物}	\N	\N
縞馬	しまうま	{}	{zebra}	{動物}	\N	\N
鯛	たい	{}	{"sea bream"}	{動物}	\N	\N
鶴	つる	{}	{crane}	{動物}	\N	\N
鳥	とり	{}	{"bird; fowl; poultry"}	{動物}	\N	\N
丑	うし	{十二支の2番目。}	{"〔十二支の一つ〕the Ox (the second of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Ox (2:00 a.m. or the hours between 1:00 a.m. and 3:00 a.m.); 〔方角〕north-northeast"}	{動物}	\N	{ちゅう}
亥	い	{十二支の12番目。}	{"〔十二支の一つ〕the Boar (the last of the twelve signs of the Chinese zodiac); 〔方角〕north-northwest; 〔時刻〕the hour of the Boar (10:00 p.m. or the hours between 9:00 p.m. and 11:00 p.m.)"}	{動物}	\N	{ぐ}
卯	う	{十二支の4番目。}	{"〔十二支の一つ〕the Rabbit (the fourth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Rabbit (6:00 a.m. or the hours between 5:00 a.m. and 7:00 a.m.); 〔方角〕east"}	{動物}	\N	{ぼう}
蛇	み	{}	{"a snake; 〔大蛇〕a serpent"}	{動物}	\N	\N
酉	ゆう	{十二支の一つで、その10番目。}	{"〔十二支の一つ〕the Cock (the tenth of the twelve signs of the Chinese zodiac); 〔方角〕west; 〔時刻〕the hour of the Cock (6:00 p.m. or the hours between 5:00 p.m. and 7:00 p.m.)"}	{動物}	\N	\N
猪	い	{豚の原種で、肉は山鯨 (やまくじら) ・牡丹 (ぼたん) といわれ食用。しし。いのこ。}	{"a wild boar"}	{動物}	\N	\N
猪	いのしし	{豚の原種で、肉は山鯨 (やまくじら) ・牡丹 (ぼたん) といわれ食用。しし。いのこ。}	{"a wild boar"}	{動物}	\N	\N
午	うま	{十二支の7番目。うま。}	{"〔十二支の一つ〕the Horse (the seventh of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Horse (noon or the hours between 11:00 a.m. and 1:00 p.m.); 〔方角〕south"}	{動物}	\N	\N
魚	うお	{}	{fish}	{動物}	\N	\N
申	しん	{十二支の9番目。}	{"〔十二支の一つ〕the Monkey (the ninth of the twelve signs of the Chinese zodiac); 〔方角〕west-southwest; west by southwest; 〔時刻〕the hour of the Monkey (4:00 p.m.; or the hours between 3:00 p.m. and 5:00 p.m.)"}	{動物}	\N	\N
柏	かしわ	{}	{"Japanese oak"}	{植物}	\N	\N
桂	かつら	{}	{"Japanese Judas tree"}	{植物}	\N	\N
蒲	がま	{}	{"bulrush; broadleaf cattail; great reedmace; cooper's reed; cumbungi; Typha latifolia [Bredkaveldun]"}	{植物}	\N	\N
桐	きり	{}	{"paulownia tree"}	{植物}	\N	\N
昆布	こんぶ	{}	{"konbu (sea grass)"}	{植物}	\N	\N
桜	さくら	{}	{"cherry blossom; cherry tree"}	{植物}	\N	\N
薩摩芋	さつまいも	{}	{"sweet potato"}	{植物}	\N	\N
杉	すぎ	{}	{"Japanese cedar"}	{植物}	\N	\N
蒲公英	たんぽぽ	{}	{"[maskros]; dandelion; Taraxacum"}	{植物}	\N	\N
椿	つばき	{}	{camelia}	{植物}	\N	\N
梨	なし	{}	{"pear (fruit or tree)"}	{植物}	\N	\N
人参	にんじん	{}	{carrot}	{植物}	\N	\N
海苔	のり	{}	{"nori (sea grass)"}	{植物}	\N	\N
檜	ひのき	{桧。}	{"Japanese Cypress (old)"}	{植物}	\N	\N
桧	ひのき	{}	{"Japanese Cypress"}	{植物}	\N	\N
藤	ふじ	{}	{wisteria}	{植物}	\N	\N
桃	もも	{}	{"peach (tree)"}	{植物}	\N	\N
柳	やなぎ	{}	{willow}	{植物}	\N	\N
榎	えのき	{}	{"enoki-take;  long; thin white mushroom used in East Asian cuisine"}	{菌類}	\N	\N
榎茸	えのきたけ	{}	{"enoki-take;  long; thin white mushroom used in East Asian cuisine"}	{菌類}	\N	\N
一課	いっか	\N	{"Division 1"}	\N	\N	\N
茅	かや	{}	{"grassy reed"}	{植物}	{萱}	\N
ヒジキ	ひじき	{}	{"hijiki (sea grass)"}	{植物}	{羊栖菜,鹿尾菜}	\N
稚海藻	わかめ	{}	{"wakame (sea grass)"}	{植物}	{若布,和布}	\N
解錠	かいじょう	{}	{unlocking}	\N	\N	\N
錠前	じょうまえ	{}	{lock}	\N	\N	\N
怖がる	こわがる	{こわいという気持ちを態度や表情に表す。「小さな子が暗がりを―・る」}	{"be afraid ((of)); be frightened; be scared; fear"}	\N	{恐がる}	\N
綿棒	めんぼう	{}	{swab}	\N	\N	\N
居酒屋	いざかや	{}	{bar}	\N	\N	\N
禁酒	きんしゅ	{}	{alcohol-prohibition}	\N	\N	\N
演舞	えんぶ	{}	{performance}	\N	\N	\N
丹念	たんねん	{}	{diligence}	\N	\N	\N
巳	み	{十二支の6番目。}	{"〔十二支の一つ〕the Snake (the sixth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Snake (10:00 a.m. or the hours between 9:00 a.m. and 11:00 a.m.); 〔方角〕south-southeast"}	{動物}	\N	{し}
戌	いぬ	{十二支の11番目。}	{"〔十二支の一つ〕the Dog; the eleventh of the twelve signs of the Chinese zodiac; 〔方角〕west-northwest; 〔時刻〕the hour of the Dog (8:00 p.m. or the hours between 7:00 p.m. and 9:00 p.m.)"}	{動物}	\N	{じゅつ}
滑子	ナメコ	{}	{"Nameko; Namekotofsskivling; Pholiota nameko"}	{菌類}	\N	\N
舞茸	まいたけ	{}	{"maitake; Grifola frondosa; Korallticka"}	{菌類}	\N	\N
松茸	まつたけ	{}	{"Matsutake; Goliatmusseron"}	{菌類}	\N	\N
合法的	ごうほうてき	{法規にかなっているさま。「―な手段」}	{"〔適法の〕lawful; 〔法定の〕legal; 〔法律上正当な〕legitimate"}	{形動}	\N	\N
形動	けいどう	{形容動詞の略。}	{"adjectival noun, adjectival, or na-adjective is a noun that can function as an adjective by taking the particle 〜な -na. (In comparison, regular nouns can function adjectivally by taking the particle 〜の -no, which is analyzed as the genitive case.)"}	\N	\N	\N
逃走経路	とうそうけいろ	\N	{"an escape route"}	\N	\N	\N
逃走者	とうそうしゃ	\N	{"a runaway; a fugitive (▼主に警察からの)"}	\N	\N	\N
駆除	くじょ	{害を与えるものを追い払うこと。「害虫を―する」「コンピューターウイルスを―する」}	{"'exterminate; get rid of (e.g. rats)'"}	\N	\N	\N
合体	がったい	{二つ以上のものがまとまって一つになること。「両派が―して新党をつくる」}	{union}	\N	\N	\N
切り取り線	きりとりせん	{切り離す位置を示した線。多く破線・点線で示す。}	{"a perforated line; a dotted line; 〔表示〕Cut [Tear off] here"}	\N	\N	\N
シメジ	しめじ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}	{湿地,占地}	\N
弊害	へいがい	{害になること。他に悪い影響を与える物事。害悪。「―を及ぼす」「―が伴う」}	{"an evil; an abuse; 〔悪影響〕「an evil [a harmful] influence, a bad effect"}	\N	\N	\N
シメジ茸	しめじたけ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}	{湿地茸,占地茸,シメジたけ,しめじ茸}	\N
仕切る	しきる	{境を作って他と区別する。隔てとなるものを設けて、いくつかの部分に分ける。「大部屋を二つに―・る」,帳簿または取引の決算をする。「三月末に―・る」}	{"to partition; to divide; to mark off; to toe the mark","to settle accounts;"}	\N	\N	\N
エリンギ	えりんぎ	{}	{"Eryngii (trumpet mushroom); kungsmussling; king trumpet mushroom; French horn mushroom; king oyster mushroom; king brown mushroom; boletus of the steppes; trumpet royale"}	{菌類}	\N	\N
只今	ただいま	{今この時。現在。「―の時刻は午前九時です」「―用意しています」,ごく近い過去。ほんの少し前。今しがた。「―の報告に異議がある」「―帰ってきたところです」,ごく近い未来。すぐ。じき。「―お持ちします」}	{"〔現在〕now; at present","〔たった今〕just now","〔すぐに〕at once; right away; immediately"}	\N	{唯今}	\N
切り取り	きりとり	{}	{"a cut out"}	\N	{斬り取り}	\N
ブナシメジ	ぶなしめじ	{}	{"buna-shimeji; Hypsizygus marmoreus"}	{菌類}	{橅湿地,橅占地}	\N
持ち出す	もちだす	{持って外へ出す。中にある物を外へ出す。「ベランダにいすを―・す」「家の金を―・す」,ある事柄を言い出す。話題として出す。「結婚話を―・す」,訴えて出る。「法廷に―・す」}	{"〔盗み出す〕take/embezzle (e.g. money)〔持って出る〕carry out; take out",〔言い出す〕,〔訴えて出る〕}	\N	\N	\N
大事	だいじ	{"",価値あるものとして、大切に扱うさま。「―な品」「親を―にする」「どうぞ、お―に」}	{important,"〜な precious; valuable"}	\N	\N	\N
通り魔	とおりま	{通りすがりに人に不意に危害を加える者。}	{"〔殺人者〕a phantom killer; 〔強盗〕a phantom robber; a pervert who slashes people as he passes them on the street"}	\N	\N	\N
通り	どおり	{数量を表す語に付いて、だいたいそのくらいという意を表す。「八、九分―でき上がった」,名詞に付いて、同じ状態、そのままであるなどの意を表す。「従来―」「予想―」}	{〔程度〕,"〔同じ様子〕as expected; as suggested; according (to plan)"}	\N	\N	\N
面が割れる	めんがわれる	{その人物が誰であるかわかる。氏名や身元がわかる。「取り調べで―・れる」}	{"〔写真から身元が分かる〕identify by face〔顔を知られる〕recognize"}	\N	\N	\N
有数	ゆうすう	{取り上げて数えるほどにおもだって有名であること。また、そのさま。屈指。「日本で―な（の）植物園」「世界―の画家」}	{"〜の eminent; prominent"}	\N	\N	\N
こちらこそ	こちらこそ	{}	{"'(used as a response) I'm the one that should really be saying that. literally: this way","for sure; as in the thanks/apology should really be going this way (your way)'"}	\N	\N	\N
半年	はんとし	{}	{"half a year; ((米)) a half year"}	\N	\N	\N
営業所	えいぎょうしょ	{営業活動の中心となる場所。}	{"an office; a sales office; a place of business"}	\N	\N	\N
所為	せい	{上の言葉を受け、それが原因・理由であることを表す。「年の―か疲れやすい」「人の―にする」「気の―」}	{"act; deed; one´s doing"}	\N	\N	\N
掴む	つかむ	{手でしっかりと握り持つ。強くとらえて離すまいとする。「腕を―・む」「まわしを―・む」,自分のものとする。手に入れる。「思いがけない大金を―・む」「幸運を―・む」}	{"〔物を捕まえる〕catch; take [catch] hold of; 〔急に，力ずくで〕seize; 〔握りしめる〕grasp; 〔しっかりつかむ〕grip","〔手に入れる〕got; have; acquire; seize"}	\N	{攫む}	\N
諄い	くどい	{同じようなことを繰り返して言ったり長々と続けたりして、うんざりさせる。しつこくて、うるさい。「表現が―・い」「―・い質問」,味つけや配色などがしつこい。「色が―・い」}	{"〔言葉数の多い〕wordy; 〔長ったらしい〕long-winded; 〔冗長な〕boring",〔味・色などがしつこい〕}	\N	\N	\N
と言えば	といえば	{話題の中のある事柄を取り上げて提示し、それに関連したことについて下に続ける意を表す。多く、話題を別方面に展開する場合に用いる。…ということについては。「事件―昨日の新聞は読みましたか」}	{"speaking of; in a sense"}	\N	\N	\N
仕向ける	しむける	{あることをするよう、人に働きかける。「生徒が自分から研究するように―・ける」}	{'〔働きかける〕induce,urge,tempt,"prompt ((a person to do)); 〔無理矢理に〕force ((a person to do))'"}	\N	\N	\N
見初める	みそめる	{その異性を一目見て恋心をいだく。「友人の披露宴で―・めた女性」}	{"fall in love ((with a person)) at first sight"}	\N	{見そめる}	\N
然うしたら	そうしたら	{前の事柄を仮定し、その場合にあとの事柄が起こることを示す。「今日中に仕上げよう。―明日は出掛けられる」}	{"And then; moreover"}	\N	{そしたら}	\N
張込み	はりこみ	{ある場所に待機して見張ること。「―の刑事」}	{"a (detective) stakeout"}	\N	{張り込み}	\N
近付く	ちかづく	{あるものがある場所の近くに移動する。「目的地に―・く」「台風が本土に―・く」,それを行う時期が近くなる。ある期日・刻限が迫る。「開会式が―・く」「終わりに―・く」}	{"to approach; get near; get closer (to a location)","to approach; get near; get closer (a moment in time)"}	\N	{近づく}	\N
会食	かいしょく	{}	{"dining together"}	\N	\N	\N
奇遇	きぐう	{思いがけなく出あうこと。意外なめぐりあい。「こんなところで会うなんて―だね」}	{"「a chance [an unexpected] meeting; 〔幸運な〕((文)) a fortuitous meeting"}	\N	\N	\N
何時だって	いつだって	{どんな状況下であろうと、いつも。「＿私は元気です」「君は＿かわいい」}	{"always; at any time"}	\N	\N	\N
罪のない	つみのない	{}	{"innocent; harmless"}	\N	\N	\N
一杯	いっぱい	{一つの杯・茶碗などに入る分量。「コップ―の水」,一定の容器や場所などに物があふれんばかりに満ちているさま。「日が―さし込む」「部屋は来客で―になる」,できる限り。ありったけ。「弓を―に引き絞る」}	{"〔容器一つの分量〕one (e.g. glas)","〔充満〕full (sated); crowded (with people); fill (the basin/room)","〔全部〕all (of next week); all (my might)"}	\N	\N	\N
見ぬ振り	みぬふり	{}	{"look the other way; shut one's eyes to (his shameless conduct); look at from a glance"}	\N	\N	\N
密売	みつばい	{法律や規則を犯して、ひそかに売ること。「拳銃を―する」}	{"an illicit sale; 〔酒の〕((米)) bootlegging; sell in secret/ under cover"}	\N	\N	\N
独り身	ひとりみ	{結婚していないこと。また、その人。どくしん。「―を守る」}	{"single life; 〔男性〕bachelor life⇒どくしん(独身)"}	\N	\N	\N
何にも	なんにも	{何物にも。何事にも。「それでは―ならない」}	{"nothing (whatsoever)"}	\N	\N	\N
訳	わけ	{物事の道理。すじみち。「―のわからない人」「―を説明する」,言葉などの表す内容、意味。「言うことの―がわからない」,理由。事情。いきさつ。「これには深い―がある」「どうした―かきげんが悪い」,男女間のいきさつ。また、情事。「―のありそうな二人」}	{"〔道理〕truth; reason","〔意味〕(a) meaning; sense","〔理由〕(a) reason ((for; why))",〔事情〕circumstances}	\N	\N	\N
遣る	やる	{そこへ行かせる。さしむける。送り届ける。「子供を大学へ―・る」「使いを―・る」「手紙を―・る」,漕 (こ) いだり、走らせたりして進める。「車を―・る」,そちらへ向ける。「目を―・る」,目下の者や動物などに与える。くれる。「褒美を―・る」「鳥にえさを―・る」,何かをすることを、広く、または漠然という。する。行う。営む。「宿題を―・る」「今度の舞台で大星由良之介を―・る」「民宿を―・っている」,""}	{〔送る，行かせる〕send,"〔進ませる〕drive; advance","〔向ける〕turn (e.g. towards someone); look at (his face)",〔与える〕give,〔行う〕do,"to kill; to have sexual intercourse; to study; to play (sports game); to have (eat drink smoke); to row (a boat); to run or operate (a restaurant)"}	\N	\N	\N
照れる	てれる	{気恥ずかしく感じる。また、恥ずかしそうな態度や表情をする。「あまりほめられると―・れる」「冷やかされて―・れる」}	{"feel shy/embarressment/self-conscious"}	\N	\N	\N
引き続き	ひきつづき	{続けざまに。途切れることなく。「―三日も雨が降っている」,すぐそれに続いて。「―慰労会に移る」}	{"〔絶え間なく〕continuously; 〔短い間隔をおいて連続して〕continually; 〔続々と〕one after another","〔すぐ続いて〕follow up; follow by"}	\N	\N	\N
張り合い	はりあい	{努力するかいがあると感じられること。「―のある仕事」,''}	{"〔やりがいのあること〕challenge; sense of worthwhile; encouragement; meaning","〔競争〕(a) rivalry"}	\N	{張合い}	\N
生きがい	いきがい	{生きるに値するもの。生きていくはりあいや喜び。「―を見いだす」}	{"purpose in life; thing to live for"}	\N	{生き甲斐}	\N
死に掛ける	しにかける	{今にも死にそうになる。死に瀕 (ひん) する。「危うく―・けた」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N	{死に懸ける,死にかける}	\N
折衷	せっちゅう	{いくつかの異なった考え方のよいところをとり合わせて、一つにまとめ上げること。「両者の意見を―する」「和洋―」「―案」}	{"compromise; cross; blending; eclecticism"}	\N	{折中}	\N
香り	かおり	{よいにおい。香気。}	{"aroma; fragrance; scent; smell"}	\N	{薫り}	\N
止める	とどめる	{}	{"to stop; to cease; to put an end to"}	\N	{留める}	\N
粥	かゆ	{}	{"'〔米の〕rice porridge [gruel]; 〔オートミールなどの〕porridge",gruel'}	\N	\N	\N
あくどい	あくどい	{程度を超えてどぎつい。やり方が行きすぎてたちが悪い。「―・い宣伝」「―・い商売」}	{"〔性質が悪い〕vicious; wicked"}	\N	\N	\N
切腹	はらきり	{}	{"ritual suicide"}	\N	\N	\N
押麦	おしむぎ	{蒸した大麦を押しつぶして平たくし、乾かしたもの。米にまぜ、炊いて食べる。}	{"rolled barley"}	\N	\N	\N
糞	くそ	{動物が、消化器で消化したあと、肛門から排出する食物のかす。大便。ふん。}	{"〔うんこ〕((俗)) shit; 〔牛馬の〕dung⇒だいべん(大便)"}	\N	{屎}	\N
海藻	かいそう	{}	{"(a kind of) seaweed; (marine) alga (複algae)"}	\N	{海草}	\N
十	じゅう	{}	{"10; ten"}	\N	{拾}	\N
犬	いぬ	{食肉目イヌ科の哺乳類。嗅覚・聴覚が鋭く、古くから猟犬・番犬・牧畜犬などとして家畜化。多くの品種がつくられ、大きさや体形、毛色などはさまざま。警察犬・軍用犬・盲導犬・競走犬・愛玩犬など用途は広い。,他人の秘密などをかぎ回って報告する者。スパイ。「官憲の―」}	{"a dog; 〔雌犬〕a bitch; a she-dog; 〔猟犬〕a hound","〔スパイ〕a spy; a secret agent"}	{動物}	{狗}	\N
別居	べっきょ	{夫婦・家族などが別れて住むこと。「単身赴任で家族と―している」⇔同居。}	{"〔夫婦の〕(a) separation; 〔法律上の〕legal [judicial] separation"}	\N	\N	\N
杓子定規	しゃくしじょうぎ	{《曲がっている杓子を定規代わりにすること、正しくない定規ではかることの意から》すべてのことを一つの標準や規則に当てはめて処置しようとする、融通のきかないやり方や態度。また、そのさま。「―な考え方」「―に扱う」}	{"〔形式主義〕formalism; 〔官僚主義〕bureaucratic procedures [rigidity]"}	{形動}	\N	\N
恐る	おそる	{危険を感じて不安になる。恐怖心を抱く。「報復を―・れる」「死を―・れる」「社会から―・れられている病気」}	{"〔怖がる〕fear; be afraid of"}	\N	{怖る,懼る,畏る}	\N
恐れる	おそれる	{危険を感じて不安になる。恐怖心を抱く。「報復をー・れる」「死をー・れる」,よくないことが起こるのではないかと心配する。危ぶむ。「失敗を―・れるな」「トキの絶滅を―・れる」,（畏れる）近づきがたいものとしてかしこまり敬う。畏敬 (いけい) する。「神をも―・れぬしわざ」}	{"〔怖がる〕fear; be afraid of (e.g. death)","〔気遣う〕fear; be afraid of (e.g. the worst",failing),"〔かしこまる〕have reverance; respect"}	\N	{畏れる,怖れる,懼れる}	\N
蟠り	わだかまり	{心の中にこだわりとなっている重苦しくいやな気分。特に、不満・不信・疑惑などの感情。「―を捨てる」「互いに何の―もなく話し合う」}	{"〔反感〕a feeling of antagonism; 〔悪感情〕bad [hard] feelings"}	\N	\N	\N
絶対的	ぜったいてき	{他の何物ともくらべようもない状態・存在であるさま。「―な信頼を得る」「―に有利な立場」⇔相対的。}	{"absolute; complete"}	{形動}	\N	\N
相対的	そうたいてき	{他との関係において成り立つさま。また、他との比較の上に成り立つさま。「―な価値」「物事を―に見る」⇔絶対的。}	{relative(ly)}	\N	\N	\N
相対	そうたい	{向かい合うこと。向き合っていること。また、対立すること。「難題に―する」}	{relative}	\N	\N	\N
飛び移る	とびうつる	{空中を飛んで他の場所へ移動する。「猿が隣の木に―・る」}	{"moving by jump"}	\N	{飛移る}	\N
功	こう	{すぐれた働き。りっぱな仕事。てがら。「―を立てる」「内助の―」}	{"〔手柄〕a great achievement; 〔成功〕success ((in))"}	\N	\N	\N
御粥	おかゆ	{}	{"〔米の〕rice porridge [gruel]; 〔オートミールなどの〕porridge; gruel"}	\N	{お粥}	\N
家	うち	{}	{"〔住むための建物〕a house","〔自分の家〕one's house; 〔自分の家庭〕one's home"}	\N	\N	\N
有り合せ	ありあわせ	{特に準備したのではなく、たまたまその場にあること。また、そのもの。ありあい。「―の菓子をすすめる」}	{"(whatever) is available (e.g. in a position of being unprepared)"}	\N	{有り合わせ,在り合わせ,在り合せ}	\N
有り合せる	ありあわせる	{たまたまそこにある。「―・せた紙に書く」}	{"to have something on hand; to have something in stock; (make do with whatever) is available"}	\N	{有り合わせる,在り合せる,在り合わせる}	\N
主人	しゅじん	{}	{"your husband; her husband"}	\N	\N	\N
命	めい	{命令。「―を帯びる」「―に背く」,いのち。生命。「―が果てる」「―を捨てる」}	{order,life}	\N	\N	\N
鯨	くじら	{}	{whale}	{動物}	\N	\N
這う	はう	{}	{"to crawl; creep"}	\N	{延う}	\N
付け込む	つけこむ	{}	{"〔付け入る〕take advantage of; presume on; (selectively) pick (e.g. a time that fits your purpose)"}	\N	{付込む,つけ込む}	\N
此方	こっち	{}	{〔話者に近い場所〕here,"〔自分 (たち) 〕"}	\N	\N	\N
其方	そっち	{}	{〔相手の場所・方向〕⇒そちら(其方)1,"〔相手 (の側) 〕"}	\N	\N	\N
好い加減	いいかげん	{程よい程度。手ごろ。適当。「―の湯」「小物をしまうのに―の大きさの箱」,仕事を最後までやり遂げずに途中で投げ出すさま。投げやり。おざなり。無責任。「―なやり方」「―な人」,かなり。相当。「―いやになった」「―飽きがきた」,相当な程度に達しているので、ほどほどのところで終わってほしいさま。「―に雨もやんでほしい」「冗談は―でやめてくれ」}	{"〔適度〕just the right (temperature)","〔おざなり，不徹底〕irresponsible; inaccurate; halfhearted","〔かなり〕pretty (tired); rather (fed up)","(this) is overdone/played please stop"}	\N	{いい加減}	\N
家庭科	かていか	{}	{"home economics"}	\N	\N	\N
せめて	せめて	{不満足ながら、これだけは実現させたいという最低限の願望を表す。少なくとも。十分ではないが、これだけでも。「―声だけでも聞きたい」「―10歳若ければなあ」}	{"at least"}	\N	\N	\N
利用価値	りようかち	{利用するに足る価値。「―に乏しい作物」}	{"utility value"}	\N	\N	\N
程々に	ほどほどに	{}	{"moderately; within bounds"}	\N	{程程に}	\N
程々	ほどほど	{}	{"〜の moderate 〜に moderately; within bounds"}	\N	{程程}	\N
堂々	どうどう	{}	{"magnificent; grand; impressive"}	\N	{堂堂}	\N
夜遊び	よあそび	{夜、遊び歩くこと。また、その遊び。「悪友と―する」}	{"go out at night"}	\N	\N	\N
寝不足	ねぶそく	{寝足りないこと。また、そのさま。睡眠不足。「―な（の）頭で試験に臨む」}	{"lack of sleep"}	\N	\N	\N
李	すもも	{}	{"Jap/Chinese plum"}	\N	\N	\N
出て行く	でていく	{}	{"leave; get out; move out; depart"}	\N	{出ていく}	\N
言い逃れ	いいのがれ	{＿ること。また、その言葉。言い抜け。言い逃げ。「もう―はきかない」「―してもむだだ」}	{"excuse; evasion of responsibility; evading of an issue"}	\N	{言逃れ}	\N
言い逃れる	いいのがれる	{いひのが・る［ラ下二］うまくごまかして、責任をまぬがれる。言い抜ける。「何とかその場を―・れる」}	{"〔言い逃れをする〕give an evasive answer","equivocate; 〔弁解する〕make excuses"}	\N	{言逃れる}	\N
一千	いっせん	{}	{"one thousand"}	\N	\N	\N
被害者	ひがいしゃ	{}	{"〔被災者〕a victim ((of)); 〔負傷者〕the injured; 〔争いなどの〕the injured party"}	\N	\N	\N
末端	まったん	{}	{"〔端〕the end; the tip"}	\N	\N	\N
末端価格	まったんかかく	{}	{"〔小売価格〕the retail price; the end price; 〔麻薬などの〕the street price"}	\N	\N	\N
薬物	やくぶつ	{薬理作用を有する化学物質。くすり。}	{"(a) medicine; ((米)) a drug"}	\N	\N	\N
持ち掛ける	もちかける	{}	{"offer a suggestion; propose an idea"}	\N	{持掛ける,持ちかける}	\N
婚約者	こんやくしゃ	{}	{"〔男〕a fiancé; 〔女〕a fiancée"}	\N	\N	\N
目くじらを立てる	めくじらをたてる	{目をつりあげて人のあらさがしをする。他人の欠点を取り立てて非難する。目角 (めかど) を立てる。「小さなミスに―・てる」}	{"〔粗探しをする〕find fault with ((a person)); 〔腹を立てる〕get angry about [over]((trifles))"}	\N	\N	\N
歓迎会	かんげいかい	{}	{"a welcome party"}	\N	\N	\N
訳が無い	わけがない	{はずがない。道理がない。「書留がそんな中に入ってる―・いよ」}	{"should not"}	\N	{わけが無い,訳がない}	\N
身銭を切る	みぜにをきる	{自分の金で払う。自腹を切る。}	{"spend one's own money"}	\N	{みぜにを切る}	\N
身銭	みぜに	{自分の金。自分の個人的な金銭。}	{"one's own money"}	\N	\N	\N
後ろめたい	うしろめたい	{自分に悪い点があって、気がとがめる。やましい。「親友を裏切ったようで―・い」}	{"(have a) guilty conscience; (feel) guilty"}	\N	{後ろ目痛}	\N
買収	ばいしゅう	{買い取ること。買いおさえること。「会社を―する」「用地―」,ひそかに利益を与えて、自分の有利になるように人を動かすこと。「選挙民を―する」}	{〔買い取ること〕purchase,〔贈賄〕bribery}	\N	\N	\N
幾つか	いくつか	{}	{"a number of them"}	\N	\N	\N
広域	こういき	{広い区域。広い範囲。「―捜査」}	{"a wide area"}	\N	\N	\N
暴力団	ぼうりょくだん	{暴力や脅迫などによって、私的な目的を達成しようとする反社会的な行動集団。}	{"a gangster organization; a crime syndicate"}	\N	\N	\N
薄薄	うすうす	{}	{"〔かすかに〕slightly; 〔漠然と〕vaguely"}	\N	{薄々}	\N
気付く	きづく	{それまで気にとめていなかったところに注意が向いて、物事の存在や状態を知る。気がつく。「誤りに―・く」「忘れ物に―・く」,意識を取り戻す。正気に戻る。気がつく。「―・いたらベッドの上だった」}	{"〔五感により意識する〕notice; become aware ((of)); perceive; be alert〔感づく〕sense; suspect;〔悟る〕realize; discover;","regain sanity; recover your awareness/concounce"}	\N	{気づく}	\N
売人	ばいにん	{品物を売る人。特に、密売組織などの末端で麻薬や銃器などを売りさばく人。}	{"a (e.g. drug) seller"}	\N	\N	\N
軽々	かるがる	{}	{"lightly; 〜と easily"}	\N	{軽軽}	\N
チクる	ちくる	{告げ口をする意の俗語。「仲間の失敗をボスに―・る」}	{"tell ((on)); to tattle (to mommy)"}	\N	\N	\N
構わない	かまわない	{差し支えない。気にしない。「先に帰っても―◦ないよ」}	{"to not care (if you do this and that)"}	\N	\N	\N
極刑	きょっけい	{最も重い刑罰。死刑。「―に処する」}	{"the maximum penalty; 〔死刑〕capital punishment"}	\N	\N	\N
しかない	しかない	{}	{"no alternative","no option but to..."}	\N	\N	\N
詰らない	つまらない	{おもしろくない。興味をひかない。「―◦ない映画」,とりあげる価値がない。大したものではない。「―◦ないものですが、お収めください」,意味がない。ばかげている。「―◦ないうわさ話で時間をつぶす」}	{"〔面白くない〕dull; boring","〔取るに足りない〕trifling; trivial; petty","〔ばかげた〕absurd; nonsense; rubbish"}	\N	{詰まらない}	\N
鹿	しか	{}	{deer}	{動物}	\N	\N
頒布	はんぷ	{}	{distribution}	\N	\N	\N
決まる	きまる	{不確か・未決定であった物事が最終的にはっきりして、動かない状態になる。さだまる。決定する。「方針が―・る」「有罪と―・る」,スポーツや勝負事で、技がうまくかかったり、ねらいどおりに運んだりする。また、勝負がつく。「背負い投げが―・る」「速攻が―・る」「東土俵で―・る」,疑う余地がなく、当然である。きっとそうである。また、必ずそうなる。「冬は寒いに―・っている」「そんなことを言われれば、だれだって怒るに―・っている」}	{"〔決定する〕be decided","〔うまくいく〕vara som klippt och skuren;","「…するに決まっている」「決まって…する」の形で，当然［必ず］…する〕certain; sure (to regret it)"}	\N	{極まる,極る,決る}	\N
尾行	びこう	{}	{"〜する shadow; tail"}	\N	\N	\N
短髪	たんぱつ	{みじかい髪。}	{"short hair"}	\N	\N	\N
うろちょろ	うろちょろ	{目ざわりになるほど、あちこち動き回るさま。「そんなに―（と）されては仕事のじゃまになる」}	{"act of hanging around; run around getting in the way"}	\N	\N	\N
青臭い	あおくさい	{青草から発するようなにおいがする。「薬草の―・い絞り汁」,人格や言動などが未熟である。「―・いことを言う」}	{"〔匂いが〕raw smell","〔未熟な〕immature，((口)) green; 〔うぶな〕naive"}	\N	\N	\N
垂れ込む	たれこむ	{密告する。「極秘情報を新聞に―・む」}	{"((俗)) squeal; rat ((on a person about a matter))"}	\N	{垂込む}	\N
手前	てめえ	{一人称の人代名詞。わたし。あっし。「―にはかかわりのないことです」,二人称の人代名詞。おまえ。きさま。「―に文句がある」}	{"[vulgar] me","[vulgar] you"}	\N	\N	\N
上乗せ	うわのせ	{}	{"add extra; (pay) a little more"}	\N	\N	\N
無意識	むいしき	{意識がないこと。正気を失うこと。「―の状態が続く」}	{unconsciousness}	\N	\N	\N
統制	とうせい	{多くの物事を一つにまとめておさめること。管制。,国家などが一定の計画や方針に従って指導・制限すること。「物資の―」「言論を―する」}	{"(スル) control; place ((a thing)) under one's control; regulate"}	\N	\N	\N
とか	とか	{事物や動作・作用を例示的に並列・列挙する意を表す。「漱石―鴎外―といった文人」「見る―見ない―騒いでいる」→＿や,断定を避け、あいまいにするために語の後に付ける。「学校―から帰る」}	{"〔物事を並列して〕and so on; and such","〔不確かな内容を伝えて〕(I) hear; am not sure but; (a) certain"}	\N	\N	\N
刹那	せつな	{きわめて短い時間。瞬間。「―の快楽に酔う」「衝突した―に気を失う」「―的な生き方」}	{"(live only for) a moment; an instant"}	\N	\N	\N
臭い	くさい	{}	{"〔悪臭がする〕to stink; have a bad smell","〔怪しい〕suspicious; ((口)) fishy"}	\N	\N	\N
過労死	かろうし	{}	{"to die from overworking"}	\N	\N	\N
奴隷	どれい	{人間としての権利・自由を認められず、他人の私有財産として労働を強制され、また、売買・譲渡の対象ともされた人。古代ではギリシャ・ローマ、近代ではアメリカにみられた。,ある事に心を奪われ、他をかえりみない人。「恋の―」「金銭の―」}	{"〔昔の〕a slave","〔あるもののとりこ〕a slave (to love; music; passion)"}	\N	\N	\N
シャブ	しゃぶ	{覚醒剤のこと。}	{meth}	\N	\N	\N
漬け	づけ	{}	{〔漬けたもの〕pickled,"〔多量な様子〕filled up to his/her ears"}	\N	\N	\N
叩く	たたく	{}	{〔打つ〕beat,"knock，〔軽く〕tap ((at",on)),"〔非難する〕criticize ((for)); ((文)) censure ((for))","〔値切る〕demand a discount; beat down the price"}	\N	{敲く}	\N
叩き売り	たたきうり	{}	{"sell at bargain prices"}	\N	{たたき売り}	\N
女房	にょうぼう	{妻のこと。多く、夫が自分の妻をさしていう。家内。ワイフ。「―に頭があがらない」「恋―」「世話―」}	{wife}	\N	\N	{にゅうぼう,にょうぼ}
振るう	ふるう	\N	{"〔力を発揮する〕use (violence); wield (power); demostrate one's (ability)","〔栄える〕florish (e.g. business)","〔成績がよい〕doing well (e.g in sports or math)"}	\N	{揮う}	\N
肯定	こうてい	{そのとおりであると認めること。また、積極的に意義を認めること。「現世を―する」⇔否定。}	{"affirmation; acknowledgement"}	\N	\N	\N
百十番	ひゃくとおばん	{}	{"the (Japanese) emergency police telephone number (アメリカでは911)"}	\N	\N	\N
ちょくちょく	ちょくちょく	{わずかの間を置いて同じことが繰り返されるさま。たびたび。ちょいちょい。「妹が―遊びに来る」}	{"〔たびたび〕often; frequently; 〔時々〕now and then; occasionally"}	\N	\N	\N
追い詰める	おいつめる	\N	{"〔獲物などを〕run down; hunt down (a criminal)"}	\N	\N	\N
見殺し	みごろし	{}	{"stand by and watch (someone) die; leave stranded to die"}	\N	\N	\N
骨までしゃぶる	ほねまでしゃぶる	{}	{"lose everything; suck dry; exploit (workers to death)"}	\N	\N	\N
ウヨウヨ	うようよ	{}	{"be covered (with germs); be crawling (with maggots); (earthworms) be wriggling (under pots)"}	\N	\N	\N
罷免	ひめん	{}	{"dismissal; discharge"}	\N	\N	\N
楠	くすのき	{}	{"camphor tree"}	{植物}	\N	\N
浮世絵	うきよえ	{}	{"Japanese wooden block painting"}	\N	\N	\N
雨雪	うせつ	{雨と雪。}	{"snowy rain"}	\N	\N	\N
廿日	はつか	{}	{"20 days"}	\N	\N	\N
獣医	じゅうい	{}	{veteranarian}	\N	\N	\N
喚起	かんき	{}	{evocation}	\N	\N	\N
喚呼	かんこ	{}	{大声で呼ぶこと}	\N	\N	\N
ジャガ芋	じゃがいも	{}	{potato}	\N	{じゃが芋,ジャガイモ,ジャガいも}	\N
湖畔	こはん	{}	{"lake side; lake shore"}	\N	\N	\N
視聴	しちょう	{}	{viewing}	\N	\N	\N
囲碁	いご	{}	{Go}	\N	\N	\N
堤	つつみ	{}	{"dike; embarkment; bank"}	\N	\N	\N
猛稽古	もうげいこ	{}	{"fierce training"}	\N	\N	\N
糊	のり	{}	{glue}	\N	\N	\N
鞭	むち	{}	{whip}	\N	\N	\N
鶏肉	とりにく	{}	{"chicken meat"}	\N	\N	\N
鶏	にわとり	{}	{chicken}	{動物}	\N	\N
豚	ぶた	{}	{"domesticated pig"}	{動物}	\N	\N
大尉	たいい	{}	{captian}	\N	\N	\N
和暦	われき	{}	{"Japanese calendar"}	\N	\N	\N
桜桃	さくらんぼ	{}	{cherry}	\N	\N	\N
鉄瓶	てつびん	{}	{"iron kettle"}	\N	\N	\N
舐める	なめる	{}	{"to lick"}	\N	\N	\N
試着	しちゃく	{服などを買う前に、自分のからだに合うかどうか試みに着てみること。「吊 (つ) るしのブレザーを―する」「―室」}	{"try on (e.g. a jacket)"}	\N	\N	\N
空室	くうしつ	{使っていない部屋。また、人の住んでいない部屋。あきべや。「―有り」}	{"vacant rooms"}	\N	\N	\N
新年	しんねん	{}	{"new year"}	\N	\N	\N
こそ	こそ	{ある事柄を取り立てて強める意を表す。「今―実行にうつすべきだ」}	{"((係助詞)) (the) very (thing); just (the thing); (this) very (year)"}	\N	\N	\N
ような気がする	ようなきがする	{}	{"feel that ~; seem to ~"}	\N	{様な気がする}	\N
初夢	はつゆめ	{}	{"the first dream of the New Year"}	\N	\N	\N
巡り会う	めぐりあう	{めぐりめぐって出あう。別れ別れになっていた相手や、長く求めていたものに出あう。「生き別れた親子が―・う」「幸運に―・う」}	{"to come across"}	\N	\N	\N
宝くじ	たからくじ	{}	{lottery}	\N	{宝籤}	\N
願いごと	ねがいごと	{}	{wish}	\N	{願い事,お願い事,お願いごと,御願い事,御願いごと}	\N
多過ぎる	おおすぎる	{}	{"too many"}	\N	{おお過ぎる,多すぎる}	\N
正月	しょうがつ	{}	{"〔新年〕the New Year〔1月〕January"}	\N	{お正月,御正月}	\N
二日酔い	ふつかよい	{酒の酔いが翌日まで残り、はきけや頭痛・めまいなどがして気分の悪い状態。宿酔 (しゅくすい) 。}	{"((have)) a hangover"}	\N	\N	\N
酔いつぶれる	よいつぶれる	{酒にひどく酔って正体を失う。泥酔 (でいすい) する。「―・れて寝てしまう」}	{"drink oneself under the table; pass out from drinking"}	\N	{酔い潰れる}	\N
大好物	だいこうぶつ	{}	{"favorite food"}	\N	\N	\N
買い換える	かいかえる	{新しく買い入れて、今までの物ととりかえる。「車を―・える」}	{"buy a replacement (tv; fridge)"}	\N	{買い替える,買替える,買換える,買いかえる}	\N
かな	かな	{念を押したり、心配したりする気持ちを込めた疑問の意を表す。「うまく書ける―」「君一人で大丈夫―」}	{"I wonder ~"}	\N	\N	\N
っけ	っけ	{「〜かな」と同じ。念を押したり、心配したりする気持ちを込めた疑問の意を表す。「うまく書ける―」「君一人で大丈夫―」}	{"（〜かな）I wonder ~"}	\N	\N	\N
服務	ふくむ	{仕事に従事すること。「夜間に―する」}	{"service; on duty"}	\N	\N	\N
出撃	しゅつげき	{敵を攻撃するために陣地・基地を出ること。「一斉に―する」「―命令」}	{"a sortie"}	\N	\N	\N
じっと	じっと	{動かないで、そのままの状態を保つさま。「家で―している」}	{"keeping still; sit still; not moving"}	\N	\N	\N
録画	ろくが	{再生を目的として、画像をテープ・ディスク・フィルムなどの媒体に記録すること。また、その画像。}	{"(a) video(tape) recording; (a) filming; 〔テレビからの〕(a) telerecording"}	\N	\N	\N
厚化粧	あつげしょう	{おしろい・口紅などを、厚くけばけばしく塗った化粧。濃い化粧。⇔薄化粧。}	{"heavy make-up"}	\N	\N	\N
主題歌	しゅだいか	{「テーマソング」に同じ。「映画の―」}	{"Theme song"}	\N	\N	\N
下らない	くだらない	{まじめに取り合うだけの価値がない。程度が低くてばからしい。くだらぬ。くだらん。「―◦ない話」「―◦ないまちがい」「―◦ない連中と付き合う」}	{"〔値打ちがない〕worthless; 〔取るに足らない〕trifling"}	\N	\N	\N
税抜き	ぜいぬき	{}	{"excl. tax"}	\N	\N	\N
ちゃう	ちゃう	{〜ちまう〜してしまう。その動作・行為が完了する、すっかりその状態になる意を表す。,〜ちまう〜してしまう。そのつもりでないのに、ある事態が実現する意を表す。}	{"to do something by accident","to finish completely"}	\N	\N	\N
胃腸薬	いちょうやく	{}	{"digestive medicine"}	\N	\N	\N
避難訓練	ひなんくんれん	{}	{"evacuation drill"}	\N	\N	\N
癇症	かんしょう	{}	{"petulance; irritability"}	\N	\N	\N
癇癪	かんしゃく	{}	{"temper; irritability"}	\N	\N	\N
でも	でも	{物事の一部分を挙げて、他の場合はまして、ということを類推させる意を表す。…でさえ。「子供―できる」「昼前―気温が三〇度ある」,すべてのものにあてはまる意を表す。「なん―食べるよ」「だれ―知っている」}	{"〔…でさえ〕any(child); (first volume) at least; even (the most)","〔不特定の語に付けて〕any(time); any(thing)"}	\N	\N	\N
てから	てから	{…から後。…以降。「相手に会っ―考えを決める」}	{"indicates that an action begins immediately after the previous one ends."}	\N	\N	\N
立ちっぱなし	たちっぱなし	{立ったままでいること。「―で待ち続けた」}	{"to stand all day/the way"}	\N	{立ちっ放し}	\N
使いこなす	つかいこなす	{}	{"to master the situation; manage; handle"}	\N	{使い熟す}	\N
見過ぎ	みすぎ	{}	{"watched too much"}	\N	\N	\N
やっと	やっと	{}	{"〔ついに〕at last; finally; at length","〔かろうじて〕barely; just","〔苦労して〕with great difficulty"}	\N	\N	\N
溜る	たまる	{物事が少しずつ積もり集まって多くなる。1か所に集まってとどまる。「ごみが―・る」「水が―・る」「耳垢 (みみあか) が―・る」「ストレスが―・る」}	{"〔一つの所に集まる〕collect; accumulate"}	\N	{溜まる}	\N
限り限り	ぎりぎり	{限度いっぱいで、それ以上余地がないこと。また、そのさま。副詞的にも用いる。「しめきり―に間に合う」「経済的に―な（の）状態で生活する」「―許容できる線」}	{"at the very limit; utmost; barely; at the very last minute; just before (deadline)"}	\N	{ギリギリ}	\N
思いやり	おもいやり	{他人の身の上や心情に心を配ること。また、その気持ち。同情。「―のある処置」「病人に対する―がない」}	{"sympathy; compassion"}	\N	{思い遣り}	\N
部長	ぶちょう	{官庁・会社などで、部の事務を統轄し、部下を監督する役職。また、その人。}	{"he head [manager] of a department; the general manager⇒かいしゃ(会社)〔大学の学部長〕the dean of a department"}	\N	\N	\N
御仕舞い	おしまい	{終わること。「夏休みも今日で―だ」}	{"⇒おわり(終わり); leave off (work); that's all (for today)"}	\N	{お仕舞い,御仕舞,お仕舞い,お終い}	\N
幾ら遣っても	いくらやっても	{}	{"even if much is done; however one may try"}	\N	{いくら遣っても,幾らやっても}	\N
徐々	そろそろ	{動作が静かにゆっくりと行われるさま。そろり。ぼつぼつ「ー歩く」}	{"gradually; steadily; quietly; slowly; soon"}	\N	{徐徐,ソロソロ}	\N
似合い	にあい	{似合うこと。ふさわしいこと。「―のカップル」}	{"〜の 〔釣り合いのとれた〕well-matched; 〔ふさわしい〕suitable ((for))"}	\N	{似合}	\N
口先	くちさき	{口の先端。「―をとがらせる」,本心でないうわべだけの言葉。ただ口でだけ言っている言葉。また、ものの言い方。「―だけの約束」「―で人を言いくるめる」「―のうまい人」}	{"〔口の端〕lips; a mouth; 〔動物の〕a snout; a muzzle","〔言葉〕(smooth)-talk; (glib-)talk"}	\N	\N	\N
口先だけ	くちさきだけ	{}	{"just talk; (empty) promise; insincere talk"}	\N	\N	\N
はっきり	はっきり	{}	{"〔他のものとまぎれない〕clearly; distincly"}	\N	\N	\N
放って置く	ほうっておく	{}	{"構わずにおく〉 leave somebody [something] alone; leave somebody [something] as he [it] is; let somebody [something] be"}	\N	{ほっとく}	\N
寝返り	ねがえり	{寝たままからだの向きを変えること。}	{"〔向きを変えること〕turn in bed"}	\N	\N	\N
嗽	うがい	{水や薬液などを口に含んで、口やのどをすすぐこと。含嗽 (がんそう) 。「食塩水で―する」「―薬」}	{gargling}	\N	\N	\N
解かす	とかす	{櫛 (くし) やブラシで髪の毛のもつれをととのえる。くしけずる。「髪を―・す」}	{"〔くしで〕comb; 〔ブラシで〕brush"}	\N	{梳かす}	\N
脱臼	だっきゅう	{}	{"dislocation (e.g. an arm)"}	\N	\N	\N
石臼	いしうす	{}	{"a stone mill [mortar]"}	\N	\N	\N
嗅覚	きゅうかく	{}	{"the sense of smell"}	\N	\N	\N
淹れる	いれる	{湯を差して、茶などを出す。「コーヒーを―・れる」}	{"〔茶やコーヒーを〕make (coffee/tea)"}	\N	{点れる}	\N
碾く	ひく	{ひき臼 (うす) を回して穀類をすり砕く。「豆を―・く」}	{"to grind"}	\N	\N	\N
安売り	やすうり	{}	{"〔安値で売ること〕a (bargain) sale"}	\N	\N	\N
散らし	ちらし	{}	{"〔折り込み広告〕a flier; 〔手渡しビラ〕a handbill"}	\N	{チラシ}	\N
噂話	うわさばなし	{うわさ。世間話。「―に花を咲かせる」}	{"act of gossiping"}	\N	\N	\N
お隣	おとなり	{隣人と同じ。}	{neighbor}	\N	{御隣}	\N
レジスター	レジスター	{}	{"〔金銭登録機〕a cash register; 〔出納係〕a cashier; 〔スーパーなどの精算台〕((at)) the checkout counter"}	\N	{レジ}	\N
馴鹿	じゅんろく	{}	{reindeer}	{動物}	{トナカイ}	{となかい}
立技	たちわざ	{柔道やレスリングで、立った姿勢で掛ける技。⇔寝技。}	{"Judo techniques on the feet"}	\N	{立ち技}	\N
訪ねる	たずねる	{会うためにその人のいる所に行く。ある目的があってわざわざその場所へ行く。訪問する。おとずれる。「旧友を―・ねる」「秘湯を―・ねる」「史跡を―・ねる」}	{"visit; pay [make] a visit to; call on [at]; come [go] to see"}	\N	{たづねる}	\N
丙	へい	{}	{"〔等級の〕third class; C"}	\N	\N	\N
蚕	かいこ	{}	{"a silkworm"}	\N	\N	\N
老朽	ろうきゅう	{}	{"〜した decrepit; ((文)) superannuated; 〔もうろくした〕senile; 〔規定の年月を越えた〕overage"}	\N	\N	\N
如く	ごとく	{}	{"like; same"}	\N	\N	\N
如し	ごとし	{}	{"like; same"}	\N	\N	\N
騙す	だます	{}	{"〔あざむく〕cheat ((a person out of a thing)); trick ((a person into doing)); deceive (通例 cheatは不正な手段，詐欺などで，trickは巧妙な策略で，deceiveはうそなどで人を惑わし，だます)"}	\N	\N	\N
やれやれ	やれやれ	{}	{"1〔感嘆〕thank heaven; yahoo; well (here we are at last)","2〔がっかりした気持ちを表す〕Oh no! (not again)"}	\N	\N	\N
話が付く	はなしがつく	{話の片がつく。相談・交渉がまとまる。「労使間で―・く」}	{"come to an agreement"}	\N	{話がつく}	\N
真摯	しんし	{まじめで熱心なこと。また、そのさま。「―な態度」「―に取り組む」}	{"〜な sincere"}	\N	\N	\N
叱責	しっせき	{他人の失敗などをしかりとがめること。「部下をきびしく―する」}	{"(a) scolding; a reprimand"}	\N	\N	\N
浮腫	むくみ	{むくむこと。また、むくんだもの。ふしゅ。「全身に―がくる」}	{"(a) swelling; a swell; （水腫）dropsy"}	\N	{浮腫み}	\N
浮腫む	むくむ	{体組織に余分な組織液がたまり、からだの全体、または一部分がはれたようになる。「顔が―・む」}	{"swell; become swollen [dropsical] (▼dropsicalは水腫で)"}	\N	\N	\N
腫瘍	しゅよう	{}	{"a tumor; ((英)) a tumour"}	\N	\N	\N
古刹	こさつ	{}	{"a historic old temple"}	\N	{古さつ}	\N
恣意的	しいてき	{気ままで自分勝手なさま。論理的な必然性がなく、思うままにふるまうさま。「―な判断」「規則を―に運用する」}	{"〜な arbitrary"}	\N	\N	\N
斬殺	ざんさつ	{}	{"kill ((a person)) with a sword [knife]"}	\N	\N	\N
斬新	ざんしん	{趣向や発想などがきわだって新しいさま。「―な技法」「―奇抜なアイデア」}	{"〜さ novelty; originality"}	\N	\N	\N
潰瘍	かいよう	{}	{"an ulcer; open sore on an external or internal surface of the body"}	\N	\N	\N
呪縛	じゅばく	{}	{spellbinding}	\N	\N	\N
呪文	じゅもん	{}	{"an incantation; a spell"}	\N	\N	\N
好餌	こうじ	{}	{"〔誘い寄せる手段〕tempting bait; 〔えじき〕fall an easy prey"}	\N	{好じ}	\N
食餌	しょくじ	{}	{"dietary (cure)"}	\N	{食じ}	\N
餌食	えじき	{}	{"1〔えさとして食われるもの〕food; 〔特に肉食動物の〕prey","2〔欲望の犠牲〕a victim; prey"}	\N	\N	\N
名刹	めいさつ	{}	{"a famous [noted] temple"}	\N	{名さつ}	\N
要塞	ようさい	{}	{"a fortress; a stronghold; fortifications"}	\N	{要さい}	\N
脳梗塞	のうこうそく	{脳の血管が詰まり、そこから先の血行が阻害されるために脳の機能が障害された状態。脳血栓と脳塞栓とがある。}	{"cerebral infarction"}	\N	\N	\N
臼歯	きゅうし	{}	{"〔大臼歯〕a molar (tooth); a grinder; 〔小臼歯〕a premolar"}	\N	\N	\N
閉塞	へいそく	{}	{"a blockade; 〔鉄道などの〕a block; 〔医学で〕obstruction",occlusion}	\N	{閉そく}	\N
采配	さいはい	{}	{"a baton (of command)"}	\N	\N	\N
喝采	かっさい	{}	{"〔声と拍手〕applause; 〔歓声〕cheers"}	\N	\N	\N
挫折	ざせつ	{}	{"〔中途でだめになる〕a setback〔気力・希望などがくじかれること〕(a) frustration"}	\N	\N	\N
頓挫	とんざ	{}	{"a setback"}	\N	\N	\N
捻挫	ねんざ	{}	{"a sprain"}	\N	\N	\N
心筋梗塞	しんきんこうそく	{}	{"〔医学用語〕myocardial [cardiac] infarction"}	\N	\N	\N
涙腺	るいせん	{}	{"a lacrimal gland; be moved to tears; start crying"}	\N	\N	\N
前立腺	ぜんりつせん	{}	{"the prostate (gland)"}	\N	\N	\N
煎茶	せんちゃ	{}	{sencha}	\N	\N	\N
憧憬	どうけい	{あこがれること。あこがれの気持ち。「西欧の絵画に―する」}	{adoration}	\N	\N	{しょうけい}
一蹴	いっしゅう	{}	{"〔軽く負かすこと〕beat easily; 〔拒絶〕turn down flat"}	\N	\N	\N
蹴散らす	けちらす	{けって乱し散らす。けちらかす。「子供が落ち葉の山を―・す」}	{"scatter; blow up; kick about"}	\N	\N	\N
羞恥心	しゅうちしん	{恥ずかしく感じる気持ち。「―のない人」}	{"shame; sense of shame; bashfulness"}	\N	\N	\N
半袖	はんそで	{洋服で、ひじくらいまでの長さの袖。また、その衣服。「―のブラウス」}	{"short sleeves"}	\N	\N	\N
戴冠式	たいかんしき	{}	{"((hold)) a coronation (ceremony)"}	\N	\N	\N
戴冠	たいかん	{国王が即位のしるしとして王室伝来の王冠を頭にのせること。}	{crowning}	\N	\N	\N
頂戴	ちょうだい	{もらうこと、また、もらって飲食することをへりくだっていう語。「結構な品を―いたしました」「お叱りを―する」「もう十分―しました」}	{〔もらうこと〕〔飲食する〕〔…してください〕}	\N	\N	\N
堆積	たいせき	{いく重にも高く積み重なること。積み重ねること。また、そのもの。「土砂が―する」「倉庫に貨物が―する」}	{"(an) accumulation; a pile; 〔地質学で〕sedimentation"}	\N	\N	\N
堆肥	たいひ	{}	{"compost; barnyard manure"}	\N	\N	\N
眉唾物	まゆつばもの	{だまされる心配のあるもの。真偽の確かでないもの。信用できないもの。「その情報は―だ」}	{"「a fishy [an unlikely] story; a dubious matter"}	\N	\N	\N
唾液	だえき	{}	{"saliva; 〔医学用語〕sputum"}	\N	\N	\N
唾棄	だき	{つばを吐きすてること。転じて、非常に軽蔑して嫌うこと。「―すべき行為」}	{"despicable / detestable (man)"}	\N	\N	\N
不遜	ふそん	{へりくだる気持ちがないこと。思いあがっていること。また、そのさま。高慢。傲慢。「―な態度」}	{"haughtiness; arrogance⇒ごうまん(傲慢)"}	\N	\N	\N
遜色	そんしょく	{他に比べて劣っていること。見劣り。「入賞作に比べても―のない出来だ」}	{inferiority}	\N	\N	\N
痩身	そうしん	{やせたからだ。痩躯 (そうく) 。}	{"〔やせた体〕a lean figure; 〔やせること〕weight reduction"}	\N	\N	\N
未曽有	みぞう	{今までに一度もなかったこと。また、非常に珍しいこと。希有 (けう) 。みぞうう。「―の大地震」}	{unprecedented}	\N	\N	\N
曽祖父	そうそふ	{祖父母の父にあたる人。ひいじじ。曽祖。}	{"great grandfather"}	\N	\N	\N
曽孫	そうそん	{孫の子。ひまご。}	{"great grandchild"}	\N	\N	\N
遡及	そきゅう	{過去にさかのぼって影響・効力を及ぼすこと。「規定の適用を四月に―して行う」}	{"retroaction; retroactivity"}	\N	\N	\N
遡上	そじょう	{流れをさかのぼっていくこと。「アユが急流を―する」}	{Run-up}	\N	{溯上}	\N
配膳	はいぜん	{食膳を客の前に配ること。料理や箸・茶碗などを食卓に出すこと。「客室ごとに―する」「―係」}	{"〜する set the table"}	\N	\N	\N
処方箋	しょほうせん	{医師が、患者に投与する薬について薬剤師に与える指示書。}	{"a prescription"}	\N	\N	\N
詮索	せんさく	{細かい点まで調べ求めること。「語源を―する」}	{"an inquiry"}	\N	\N	\N
所詮	しょせん	{}	{"〔結局〕after all; 〔とにかく〕anyway〔とうてい〕"}	\N	\N	\N
瞳孔	どうこう	{}	{"the pupil (of the eye)"}	\N	\N	\N
藤色	ふじいろ	{}	{"light purple; lavender"}	\N	\N	\N
賭博	とばく	{金品をかけて勝負を争うこと。かけごと。ばくち。}	{gambling}	\N	\N	\N
賭場	とば	{ばくちをする所。ばくちば。鉄火場。どば。「―を開く」}	{"gambling parlor"}	\N	\N	\N
頭巾	ずきん	{}	{"a hood (clothing)"}	\N	\N	\N
羨望	せんぼう	{うらやむこと。「―の的となる」「他人の栄達を―する」}	{envy}	\N	\N	\N
脊髄	せきずい	{}	{"spinal cord"}	\N	\N	\N
脊柱	せきちゅう	{}	{"the spinal column; the spine"}	\N	\N	\N
脊椎	せきつい	{脊柱をなす骨。脊椎骨。}	{"the backbone; the spine; 〔脊椎骨〕a vertebra ((複-brae))"}	\N	\N	\N
椎間板	ついかんばん	{}	{"an intervertebral disk; ((英)) an intervertebral disc"}	\N	\N	\N
凄絶	せいぜつ	{非常にすさまじいこと。また、そのさま。「―な争い」}	{"fierce (battle)"}	\N	\N	\N
凄惨	せいさん	{目をそむけたくなるほどいたましいこと。ひどくむごたらしいこと。また、そのさま。「―をきわめる事故現場」「―な戦い」}	{"ghastly; appalling; gruesome"}	\N	{悽惨}	\N
裾野	すその	{山麓の緩やかな傾斜地。}	{"〔ふもと〕the foot [lower slopes] of a mountain"}	\N	{すそ野}	\N
山裾	やますそ	{山のふもと。山麓 (さんろく) 。}	{"base/food (of a mountain)"}	\N	{山すそ}	\N
必須	ひっす	{必ず用いるべきこと。欠かせないこと。また、そのさま。ひっしゅ。「成功のための―な（の）条件」}	{"〜の indispensable ((to))"}	\N	\N	\N
腎臓	じんぞう	{}	{"a kidney"}	\N	\N	\N
肝腎	かんじん	{最も重要なこと。また、そのさま。肝要。「―な話」「慎重に対処することが―だ」}	{"な 〔欠くことのできない〕essential"}	\N	{肝心}	\N
襟芯	えりしん	{衣服の襟に張りをもたせるために入れる、やや堅い布。}	{"collar core"}	\N	{襟心}	\N
目尻	めじり	{目の耳側の方の端。まなじり。「―にしわを寄せて笑う」⇔目頭 (めがしら) 。}	{"the outer corner of the eye"}	\N	{眥}	\N
尻込み	しりごみ	{おじけて、あとじさりすること。「滝口をのぞこうとして思わず―した」}	{"〜する 〔ひるむ〕shrink; 〔畏縮する〕flinch ((from danger)); 〔後ずさりする〕recoil"}	\N	{後込み}	\N
失踪	しっそう	{行方をくらますこと。また、行方が知れないこと。失跡。「事件の後―する」}	{disappearance}	\N	\N	\N
死体蹴り	したいげり	{}	{"corpse killing"}	\N	\N	\N
陰謀	いんぼう	{ひそかにたくらむ悪事。また、そのたくらみ。「―を企てる」「―に加担する」}	{"a plot; an intrigue〔共謀〕(a) conspiracy"}	\N	{隠謀}	\N
補填	ほてん	{不足・欠損部分を補って埋めること。填補。「赤字を―する」}	{"make up for; cover; compensate"}	\N	{補塡}	\N
装填	そうてん	{中に詰め込むこと。特に、銃砲に弾丸を込めること。「拳銃 (けんじゅう) に弾丸を―する」}	{"be load (a gun)"}	\N	{装塡}	\N
溺愛	できあい	{むやみにかわいがること。盲愛。「一人娘を―する」}	{"infatuation ((with)); excessive love ((for))"}	\N	\N	\N
溺死	できし	{}	{"(death by) drowning"}	\N	\N	\N
諦観	ていかん	{本質をはっきりと見きわめること。諦視。「世の推移を―する」}	{"resignation ((to))"}	\N	\N	\N
諦念	ていねん	{道理をさとる心。真理を諦観する心。}	{"〔精神的自覚〕spiritual awakening"}	\N	\N	\N
生爪	なまづめ	{指に生えているままのつめ。「―をはがす」}	{"nail (tear off)"}	\N	\N	\N
爪先	つまさき	{足の指の先。「―をそろえる」}	{"the tip of a toe"}	\N	\N	\N
爪弾く	つまびく	{弦楽器を指先ではじいて鳴らす。「ギターを―・く」}	{"pluck ((the strings of a koto)); strum (on) ((a guitar)) (▼pluckは引っ張る感じ．strumは軽くかき鳴らす感じ)"}	\N	{爪引く}	\N
進捗	しんちょく	{物事がはかどること。「工事の―状況」「仕事が―する」}	{"progress; 〜する advance; make progress"}	\N	{進陟}	\N
嘲り	あざけり	{あざけること。揶揄。愚弄。「―を受ける」}	{"a sneer; a jeer; a taunt; derision; ridicule; scorn⇒あざける(嘲る)"}	\N	\N	\N
嘲る	あざける	{}	{"〔冷やかす〕jeer ((at))，〔意地悪くからかう〕ridicule; make fun of ((a thing; a person))，mock; 〔軽蔑(けいべつ)する〕scorn"}	\N	\N	\N
嘲笑う	あざわらう	{}	{"sneer; ridicule; scoff; scorn"}	\N	{嘲う}	\N
自嘲	じちょう	{自分で自分をつまらぬものとして軽蔑すること。「―するような薄笑い」}	{"self-deprecation; self-scorn"}	\N	\N	\N
嘲笑	ちょうしょう	{あざけり笑うこと。あざわらうこと。「他人の失敗を―する」}	{"a sneer (一瞬にやりと笑うこと); ridicule"}	\N	\N	\N
貼付	てんぷ	{はりつけること。「封筒に切手を―する」}	{"〜する stick ((on)); paste ((on)); affix ((to))"}	\N	{ちょうふ}	\N
焼酎	しょうちゅう	{}	{"shochu; a clear distilled liquor"}	\N	\N	\N
緻密	ちみつ	{細かいところまで注意が行き届いていて、手落ちのないこと。また、そのさま。「―な仕事ぶり」「―に練り上げた計画」}	{"〔きめが細かいこと〕closely (woven)〔精密で正確なこと〕accurate/precise mind; close/minute observation; carefull (draw out)"}	\N	\N	\N
精緻	せいち	{極めて詳しく細かいこと。たいへん綿密なこと。また、そのさま。「―を極めた細工」「―な観察」}	{"〜な 〔微細な〕minute [mainjút | -njút]; fine; 〔繊細な〕delicate; 〔微妙な〕nice",subtle}	\N	\N	\N
破綻	はたん	{破れほころびること。「処々―して、垢染 (あかじみ) たる朝衣を」}	{"failure; bankrupcy; collapse"}	\N	\N	\N
旺盛	おうせい	{活動力が非常に盛んであること。また、そのさま。盛ん。盛大。「―な好奇心」}	{"full of energy; good (appetite)"}	\N	\N	\N
色艶	いろつや	{}	{"〔色とつや〕color and luster，((英)) colour and lustre; 〔つや〕luster〔顔色〕(a) complexion〔面白み〕"}	\N	{色つや}	\N
妖艶	ようえん	{あやしいほどになまめかしく美しいこと。また、そのさま。「―なほほえみ」}	{"〜な fascinating; bewitching"}	\N	{妖婉}	\N
才媛	さいえん	{高い教養・才能のある女性。才女。「―の誉 (ほま) れが高い」}	{"a talented woman"}	\N	\N	\N
長唄	ながうた	{}	{"nagauta music; traditional singing [chanting] to samisen accompaniment"}	\N	{長歌}	\N
小唄	こうた	{}	{"a traditional ballad sung to samisen accompaniment"}	\N	\N	\N
淫行	いんこう	{みだらなおこない。}	{indecency}	\N	\N	\N
咽喉	いんこう	{}	{"〔のど〕the throat〔要所〕a key position"}	\N	\N	\N
喉頭	こうとう	{呼吸器の一部。上方は咽頭 (いんとう) 、下方は気管に連なる部分。軟骨に囲まれており、声帯がある。}	{"the larynx ((複 〜es; larynges))"}	\N	\N	\N
喉元	のどもと	{}	{"the throat"}	\N	\N	\N
淫ら	みだら	{}	{"〜な indecent; obscene; lewd; sensual"}	\N	{淫}	\N
発汗	はっかん	{汗が出ること。汗を出すこと。「―作用」}	{"sweat; perspiration（上品な会話では普通sweatを避けperspirationを用いる）"}	\N	\N	\N
朖	あきら	{}	{「人名字」}	\N	\N	\N
嗅ぐ	かぐ	{}	{"smell ((at)); 〔くんくんと〕sniff ((at))"}	\N	\N	\N
珍重	ちんちょう	{珍しいものとして大切にすること。「酒の肴 (さかな) として―される食品」}	{"〜する value highly"}	\N	\N	\N
潜伏	せんぷく	{見つからないように、ひそかに隠れること。「地下に―する」}	{"〔隠れること〕hiding; concealment〔病状が外に現れないこと〕latency"}	\N	\N	\N
本屋	ほんや	{}	{"〔店〕((米)) a bookstore; ((英)) a bookshop;〔人〕a bookseller;〔出版社〕a publisher"}	\N	\N	\N
畏敬	いけい	{}	{"awe and respect"}	\N	\N	\N
砂嵐	すなあらし	{}	{sandstorm}	\N	\N	\N
宛先	あてさき	{手紙や荷物などを受け取る先方、または、場所。「―不明」}	{"〔受信人〕an addressee; 〔住所〕an address"}	\N	\N	\N
後釜	あとがま	{前の人に代わって、その地位に就く人。後任者。「人を陥れて―にすわる」}	{"〔後任〕a successor ((to))"}	\N	\N	\N
顎関節	がくかんせつ	{}	{"Temporomandibular joint"}	\N	\N	\N
上顎	うわあご	{上のほうのあご。あごの上部。⇔下顎 (したあご) 。}	{"the upper jaw"}	\N	{上あご}	{じょうがく}
下顎	したあご	{下のほうのあご。かがく。⇔上顎 (うわあご) 。}	{"the lower jaw; 【解剖】the mandible; the submaxilla"}	\N	{下あご}	{かがく}
下顎骨	かがくこつ	{}	{"the jawbone; 【解剖】the mandible; the submaxilla"}	\N	\N	\N
上顎骨	じょうがくこつ	{}	{"the upper jawbone"}	\N	\N	\N
形骸化	けいがいか	{実質的な意味を失い、形式だけが残ること。「規則が―する」}	{"mere facade; become a mere name; take teeth out (of a law)"}	\N	\N	\N
死骸	しがい	{人または動物の死んだ体。死体。遺体。なきがら。しかばね。}	{"a corpse; a dead body; ((医学)) a cadaver [kdǽvr]; 〔動物・鳥などの〕a carcass，((英)) a carcase"}	\N	{屍骸}	\N
残骸	ざんがい	{}	{"a wreck"}	\N	\N	\N
冷夏	れいか	{例年に比べて気温の低い夏。}	{"a cool summer"}	\N	\N	\N
空間	くうかん	{物体が存在しないで空いている所。また、あらゆる方向への広がり。スペース。空き。「―を利用する」「宇宙―」「生活―」}	{"vacancy; room for rent or lease; space"}	\N	\N	{あきま}
茸	きのこ	{}	{mushroom}	\N	{蕈,菌}	\N
牙	きば	{}	{"〔象・いのししなどの〕a tusk; 〔肉食動物・毒蛇などの〕a fang"}	\N	\N	\N
蓋然性	がいぜんせい	{ある事柄が起こる確実性や、ある事柄が真実として認められる確実性の度合い。確からしさ。これを数量化したものが確率。可能性。「―の乏しい推測」}	{probability}	\N	\N	\N
頭蓋骨	ずがいこつ	{}	{"〔解剖学で〕the cranium ((複 〜s; -nia)); the skull"}	\N	\N	\N
俳諧	はいかい	{}	{"〔こっけい味のある和歌・連歌〕a haikai; an amusing and playful waka"}	\N	{誹諧}	\N
崖下	がけした	{がけの下。絶壁の下。}	{"under the cliff? (from google)"}	\N	\N	{がいか}
瓦解	がかい	{}	{"collapse; a (down) fall; a breakup"}	\N	\N	\N
瓦屋根	かわらやね	{}	{"a tiled roof"}	\N	\N	\N
牙城	がじょう	{}	{"〔本陣〕the inner citadel; the keep"}	\N	\N	\N
歯牙	しが	{}	{"teeth and tusks"}	\N	\N	\N
象牙	ぞうげ	{}	{"an elephant tusk; 〔その材質〕ivory"}	\N	\N	\N
苛酷	かこく	{}	{"〜な (に) severe(ly); cruel(ly)"}	\N	{過酷}	\N
苛烈	かれつ	{}	{"intense; hard-fought"}	\N	\N	\N
臆説	おくせつ	{根拠のない、推測に基づく意見。「ただの―にすぎない」}	{"conjecture; hypothesis"}	\N	{憶説}	\N
臆測	おくそく	{自分でかってに推測すること。当て推量。「―をたくましくする」}	{"speculation; guess"}	\N	{憶測}	\N
参詣	さんけい	{}	{"a visit to a temple [shrine]"}	\N	\N	\N
詣でる	もうでる	{}	{"visit; go to worship"}	\N	\N	\N
初詣	はつもうで	{}	{"first shrine visit of the year"}	\N	{初詣で}	\N
愛玩	あいがん	{大切にし、かわいがること。多く、小さな動物についていう。また、いつくしみ楽しむこと。「―犬」}	{"〜する 〔ペットとしてかわいがる〕pet","make a pet of ((a cat)); 〔やさしく世話する〕care for ((a person)) fondly"}	\N	{愛翫}	\N
歌舞伎	かぶき	{}	{"Kabuki; a type of traditional Japanese drama which follows highly-stylized forms and takes up stories with popular appeal"}	\N	{歌舞妓}	\N
毀損	きそん	{}	{"damage; 〔名誉の〕defamation of character⇒めいよ(名誉)"}	\N	\N	\N
毀誉	きよ	{けなすこととほめること。悪口と称賛。}	{praise}	\N	\N	\N
毀誉褒貶	きよほうへん	{}	{"praise and [or] criticism"}	\N	\N	\N
僅差	きんさ	{}	{"a narrow [slim] margin"}	\N	\N	\N
剥製	はくせい	{}	{"a stuffed animal"}	\N	\N	\N
僅か	わずか	{数量・程度・価値・時間などがほんのすこしであるさま。副詞的にも用いる。「―な金の事でいがみ合う」「―な食料しかない」「―に制限重量をオーバーする」「ここから―10分の距離」}	{"〔数が少ない〕a few; 〔量が少ない〕a little; 〔度合が少ない〕slight; bare; mere; close (second)"}	\N	{纔か}	\N
危惧	きぐ	{あやぶみ、おそれること。危懼 (きく)。懸念。恐れ 。「―の念を抱く」「前途を―する」}	{"apprehensions; misgivings (▼2語とも将来に対する不安); uneasiness"}	\N	\N	\N
串刺し	くしざし	{}	{"〔食物を串に刺すこと〕Skewered; 〔槍(やり)などで刺して殺すこと〕pierced; inpaled"}	\N	\N	\N
槍	やり	{}	{"〔武器〕a spear; 〔騎兵の〕a lance"}	\N	\N	\N
横槍	よこやり	{}	{"〔わきからの干渉・じゃま〕interrupt; cut in; objection","〔横から差してくるやり〕spear from the side"}	\N	\N	\N
横槍を入れる	よこやりをいれる	{}	{"（さえぎる）interrupt; （口出しする）interfere; （割り込む）cut in"}	\N	\N	\N
巣窟	そうくつ	{}	{"a den","a haunt; ((米俗)) a hangout"}	\N	\N	\N
間隙	かんげき	{}	{"〔透き間〕a gap","〔不和〕estranged; differences; distance (between persons)"}	\N	\N	\N
橋桁	はしげた	{}	{"a bridge girder"}	\N	\N	\N
桁違い	けたちがい	{}	{"different order of magnitude"}	\N	\N	\N
鍵穴	かぎあな	{}	{"a keyhole"}	\N	\N	\N
鍵盤	けんばん	{}	{"a keyboard (e.g. piano; instrument)"}	\N	\N	\N
舷側	げんそく	{}	{"the side of a ship"}	\N	\N	\N
右舷	うげん	{}	{"starboard; the right side of a boat"}	\N	\N	\N
股間	こかん	{}	{"croth; balls"}	\N	\N	\N
股関節	こかんせつ	{}	{"a hip joint; a coxa ((複coxae))"}	\N	\N	\N
大股	おおまた	{}	{"big steps; long strides"}	\N	\N	\N
虎穴	こけつ	{}	{"〔虎の穴〕a tiger's den [lair]"}	\N	\N	\N
禁錮	きんこ	{一室に閉じ込めて、外へ出るのを許さないこと。「罰として、土蔵の中に文緒を―するつもりなのであった」}	{imprisonment}	\N	{禁固}	\N
勾留	こうりゅう	{裁判所または裁判官が、被疑者・被告人の逃亡または罪証の隠滅を防止するため、これを拘禁する強制処分。未決勾留。→拘留}	{detention}	\N	\N	\N
勾配	こうばい	{}	{"〔傾斜〕an incline; a slope; an inclination; 〔線路や道路の〕a gradient ((米)) a grade; 〔屋根の〕a pitch"}	\N	\N	\N
命乞い	いのちごい	{}	{"〜する beg [plead] for one's life"}	\N	\N	\N
持ち駒	もちごま	{}	{"〔控えの人員〕a person kept in reserve; 〔いつでも使える手段〕an available means"}	\N	\N	\N
痕跡	こんせき	{}	{"〔形跡〕a trace⇒けいせき(形跡); 〔遺物，なごり〕a vestige; 〔足跡〕a track; 〔兆候〕a sign"}	\N	\N	\N
血痕	けっこん	{}	{"a bloodstain"}	\N	\N	\N
傷痕	きずあと	{傷のついたあと。また、傷の治ったあと。「ほおに残る―」}	{scar}	\N	{疵跡}	\N
貼付	ちょうふ	{はりつけること。「封筒に切手を―する」}	{pasting}	\N	\N	\N
頓に	とみに	{}	{"suddenly; all at once"}	\N	\N	\N
頓着	とんちゃく	{}	{"〜する mind; care ((about))"}	\N	\N	\N
整頓	せいとん	{}	{"order; 〜する put ((things)) in order; straighten ((things)) up","tidy up"}	\N	\N	\N
貪る	むさぼる	{}	{"〔貪欲に求める〕be greedy ((for))，crave; 〔他人の物などを〕((文)) covet; 〔ふける〕indulge ((in))"}	\N	\N	\N
天丼	てんどん	{}	{"a bowl of rice topped with tempura"}	\N	\N	\N
捻出	ねんしゅつ	{}	{"〔無理して金を出すこと〕squeeze out; manage to raise (funds)"}	\N	{拈出}	\N
剥奪	はくだつ	{}	{"〜する deprive ((a person of a thing)); ((文)) divest ((a nobleman of his privileges))"}	\N	\N	\N
汎用	はんよう	{}	{"〜の general-purpose"}	\N	\N	\N
斑点	はんてん	{}	{"a spot; 〔小さな斑点〕a speck","a speckle"}	\N	\N	\N
眉間	みけん	{}	{"the middle of the forehead [brow]"}	\N	{眉相}	{まみあい}
眉目秀麗	びもくしゅうれい	{}	{handsome}	\N	\N	\N
眉目	びもく	{}	{"face; looks"}	\N	\N	\N
焦眉	しょうび	{危険が迫っていること。差し迫った状況にあること。「―の問題」}	{urgent}	\N	\N	\N
膝頭	ひざがしら	{}	{"〔膝小僧〕a kneecap; a kneepan; 〔膝蓋骨〕a patella; 〔膝関節〕a knee joint"}	\N	\N	\N
肘掛け	ひじかけ	{}	{"an armrest"}	\N	{肘掛,ひじ掛け}	\N
訃報	ふほう	{}	{"the news of a person's death"}	\N	\N	\N
雁	がん	{}	{"【鳥類】a wild goose"}	\N	\N	\N
双璧	そうへき	{}	{"pair of bright jewels; unmatched people; matchless things; two finest works (of literature); 〜をなす be the two greatest authorities;"}	\N	\N	\N
蔑視	べっし	{}	{"〜する despise; look down on"}	\N	\N	\N
伴侶	はんりょ	{}	{"a companion; a (life) partner; （夫婦の片方）a spouse"}	\N	\N	\N
哺乳類	ほにゅうるい	{}	{"【動物学】a mammal; （総称）the Mammalia"}	\N	\N	\N
蔑む	さげすむ	{}	{"（見下す）look down on; look down upon; （軽蔑する）despise"}	\N	{貶む}	\N
蜂起	ほうき	{}	{"an uprising; 〜する rise in revolt ((against))"}	\N	\N	\N
変貌	へんぼう	{}	{"(a) transfiguration; (a) metamorphosis; 〜する change; undergo a complete change; be transformed"}	\N	\N	\N
美貌	びぼう	{}	{"good looks; beauty"}	\N	\N	\N
頬張る	ほおばる	{}	{"fill one's mouth; stuff one's mouth"}	\N	\N	\N
親睦	しんぼく	{互いに親しみ合い、仲よくすること。「会員相互の―を図る」「―会」}	{"friendship; 〜会 a social gathering; ((口)) a mixer; ((口)) a get-together"}	\N	\N	\N
勃興	ぼっこう	{}	{"a (sudden) rise"}	\N	\N	\N
三昧	ざんまい	{ともすればその傾向になるという意を表す。「刃物―に及ぶ」}	{"〜 do something exclussively"}	\N	\N	\N
枕元	まくらもと	{}	{"〜で［に］by one's pillow／at the head of one's bed／at one's bedside"}	\N	\N	\N
冥福	めいふく	{死後の幸福。また、死後の幸福を祈って仏事を営むこと。みょうふく。「―を祈る」}	{"happiness in the other world; rest in peace"}	\N	\N	\N
冥加	みょうが	{}	{"〔神仏の助け〕the protection of God; divine protection〔幸せ〕blessing"}	\N	\N	\N
冥利	みょうり	{}	{"a (divine) favor; ((英)) a (divine) favour"}	\N	\N	\N
麺類	めんるい	{}	{noodles}	\N	{麪類}	\N
冶金	やきん	{}	{metallurgy}	\N	\N	\N
陶冶	とうや	{}	{"cultivation; building (e.g. of a character)"}	\N	\N	\N
鍛冶	かじ	{}	{"forging; smithery"}	\N	\N	\N
闇夜	やみよ	{}	{"〔暗夜〕a dark [moonless] night"}	\N	\N	\N
暗闇	くらやみ	{}	{"darkness; the dark"}	\N	\N	\N
比喩	ひゆ	{}	{"〔隠喩〕a metaphor; 〔直喩〕a simile"}	\N	{譬喩}	\N
比喩的	ひゆてき	{}	{"〜に metaphorical(ly); figurative(ly)"}	\N	\N	\N
湧水	ゆうすい	{}	{"spring; mountain spring water"}	\N	\N	\N
湧出	ゆうしゅつ	{地中から液体がわき出ること。「温泉が―する」}	{"〜する gush [spring] out"}	\N	{涌出}	\N
妖怪	ようかい	{}	{"a ghastly apparition"}	\N	\N	\N
妖しい	あやしい	{不思議な力がある。神秘的な感じがする。「―・い魅力」「宝石が―・く光る」}	{"existance of funny/strange power"}	\N	\N	\N
拉致	らち	{むりやりに連れていくこと。らっち。「何者かに―される」}	{"〜する 〔連れ去る〕take ((a person)) away; 〔誘拐する〕kidnap ((a person))，abduct ((a person))"}	\N	\N	\N
辣腕	らつわん	{物事を躊躇 (ちゅうちょ) することなく的確に処理する能力のあること。また、そのさま。すごうで。敏腕。「―を振るう」「―な（の）弁護士」「―家」}	{"outstanding ability and efficiency"}	\N	\N	\N
出藍	しゅつらん	{}	{"surpassing one's teacher"}	\N	\N	\N
藍色	あいいろ	{}	{"〜の indigo-blue; deep blue"}	\N	\N	\N
藍染め	あいぞめ	{藍で糸や布を染めること。また、染めたもの。}	{"indigo dyeing"}	\N	{藍染}	\N
慄然	りつぜん	{}	{"〜として with terror／with horror"}	\N	\N	\N
戦慄	せんりつ	{}	{"a shudder; 〜する shudder; shiver"}	\N	\N	\N
脇腹	わきばら	{}	{"〔横腹〕one's side; 〔特に動物の〕the flank"}	\N	\N	\N
両脇	りょうわき	{}	{"〜に on both sides"}	\N	\N	\N
弄ぶ	もてあそぶ	{}	{"〔いじくる〕play ((with)); toy ((with))〔慰み物にする〕play ((with)); make sport ((of)); toy with"}	\N	\N	\N
愚弄	ぐろう	{}	{"〜する make fun of ((a person)); ridicule; make a mockery of"}	\N	\N	\N
翻弄	ほんろう	{}	{"〔波などによる〕be tossed about (on the waves)"}	\N	\N	\N
山麓	さんろく	{}	{"((at)) the foot [base] of a mountain"}	\N	\N	\N
籠城	ろうじょう	{}	{"〔城にこもること〕be besieged〔ある場所にこもること〕be confined; stay at home"}	\N	\N	\N
籠る	こもる	{}	{"(1)（引きこもる）be shut up; （山寺に）seclude oneself in a mountain temple (2)（部屋がたばこの煙で）The room is filled with tobacco smoke."}	\N	{籠もる,隠る}	\N
籠	かご	{}	{"a basket; （鳥かご）a cage"}	\N	\N	\N
仕舞った	しまった	{失敗したときに思わず発する語。「―、間に合わなかった」}	{"Oops!; Uh oh!; Damn it; Shit (we should've come)"}	\N	\N	\N
根暗	ねくら	{ねっから性格が暗いこと。また、そのさまや、そういう人。「人づきあいの悪い―な（の）人」⇔根明 (ねあか) 。}	{insular}	\N	\N	\N
漆	うるし	{}	{lacquer,lacker,varnish}	\N	\N	\N
灼熱	しゃくねつ	{}	{"〔赤く熱すること〕〔激しいこと〕〜する become red-hot"}	\N	\N	\N
告別	こくべつ	{}	{"leave-taking; valedictory"}	\N	\N	\N
浸蝕	しんしょく	{流水・雨水・海水・風・氷河などが地表の岩石や土壌を削り取ること。また、その作用。「波が岩を―する」}	{"erosion; corrosion"}	\N	{浸食,侵食,侵蝕}	\N
侵蝕	しんしょく	{他の領域をしだいにおかし、損なうこと。「他国の市場を―する」}	{"violation; infringement; enter (to damage)"}	\N	{侵食}	\N
混沌	カオス	{}	{〔無秩序〕chaos〔混乱〕confusion}	\N	{渾沌}	{こんとん}
紐	ひも	{}	{string}	\N	\N	\N
靴紐	くつひも	{}	{"shoe laces"}	\N	\N	\N
瓦礫	がれき	{かわらと小石。破壊された建造物の破片など。「―の山と化す」}	{"〔かわらと小石〕tiles and stones; 〔破壊物の破片〕debris; rubble"}	\N	\N	\N
地上	ちじょう	{地面の上。「―8階建て」⇔地下。}	{"above (the) ground; 〜に［で］on the ground／on (the) earth"}	\N	\N	\N
掌	てのひら	{}	{"the palm [flat] of the hand"}	\N	{手の平}	\N
経綸	けいりん	{国家の秩序をととのえ治めること。また、その方策。「―の才に富む」}	{governing}	\N	\N	\N
痺れる	しびれる	{からだの一部または全体の感覚が失われ、自由がきかなくなる。「正座して足が―・れる」,心を奪われてうっとりとする。強烈な刺激を受けて陶酔する。「ジャズ演奏に―・れる」}	{"〔麻痺(まひ)する〕become numb; 〔電気で〕receive an electric shock","〔陶酔する〕be enraptured; be bewitched; be fascinated ((by))"}	\N	\N	\N
卑劣	ひれつ	{品性や言動がいやしいこと。人格的に低級であること。また、そのさま。「―な行為」}	{"〜な mean; dirty; base"}	\N	\N	\N
鬱	うつ	{心が晴れ晴れしないこと。気がふさぐこと。憂鬱。「酒で―を散じる」「―状態」}	{depression}	\N	{欝}	\N
如何にも	いかにも	{"1 程度・状態のはなはだしいことを表す。どう考えても。全く。実に。「―残念そうだ」","2 まさしく。さも。「―君らしい」「―本物らしくみえる」"}	{"1〔確かに，本当に，なるほど〕indeed; really; phrase meaning agreement","2〔まさに〕just; 〔さも〕as if"}	\N	\N	\N
打ち込み	うちこみ	{剣道などで、相手に打ってかかること。柔道では、相手と組んで一方が続けざまに技をかける練習法。}	{"Basic technique in e.g. Judo; In Judo it can be done 1-3 ppl where you turn around and pull weight on your back"}	\N	{打込み}	\N
守護者	しゅごしゃ	{}	{guardian}	\N	\N	\N
守護	しゅご	{まもること。「国家を―する」}	{protection}	\N	\N	\N
蝿	はえ	{}	{"a fly; ＿を叩くswat a fly"}	{動物}	\N	\N
靭帯	じんたい	{}	{"【解剖】a ligament"}	\N	{靱帯}	\N
総理	そうり	{「内閣総理大臣」の略称。}	{"〔＿大臣〕the Prime Minister; the Premier"}	\N	\N	\N
失業者	しつぎょうしゃ	{失業している人。失職者。}	{"a person who is out of work","an unemployed person; 〔総称〕the unemployed"}	\N	\N	\N
税制	ぜいせい	{租税に関する制度。「―改革」}	{"the taxation system"}	\N	\N	\N
税制改革	ぜいせいかいかく	{}	{"(a) tax reform [revision]"}	\N	\N	\N
答弁	とうべん	{質問に答えて説明すること。また、その説明。「議会で―する」}	{"((give)) an answer","a reply; 〔弁明〕an explanation; 〔被告側の〕a defense; 〜する answer; reply ((to))"}	\N	{答辯}	\N
撤回	てっかい	{いったん提出・公示したものなどを、取り下げること。「前言を―する」}	{"withdrawal; 〔前言の〕((issue)) a retraction; 〜する withdraw"}	\N	\N	\N
大蔵大臣	おおくらだいじん	{}	{"the Minister of Finance"}	\N	\N	\N
大蔵	おおくら	{}	{"(Minister of) Finance"}	\N	\N	\N
機器	きき	{}	{"〔備品〕equipment; 〔特殊な機能をもつ器具の一式〕apparatus; 〔器械〕an instrument; 〔特に家庭用の〕an appliance"}	\N	{器機}	\N
環状	かんじょう	{}	{"〜の ringed; annular"}	\N	\N	\N
軈て	やがて	{あまり時間や日数がたたないうちに、ある事が起こるさま、また、ある事態になるさま。そのうちに。まもなく。じきに。「―日が暮れる」「東京へ出てから、―三年になる」,"",""}	{"〔間もなく〕soon; it wasn't long before","〔およそ，ほとんど〕nearly; almost","〔結局〕finally; in the end"}	\N	{頓て}	\N
挙げる	あげる	{1.検挙する。「犯人を―・げる」,2.表し示す。「例を―・げる」「証拠を―・げる」,3.そのもの全体または部分の位置を低い所から高い方へ動かす、また、移す。「凧 (たこ) を―・げる」「船を浜辺に―・げる」⇔下ろす。}	{arrest,"bring to attention; mention","to raise; to fly"}	\N	\N	\N
見出す	みいだす	{}	{"〔見付ける〕find (out); 〔発見する〕discover; 〔かぎつける〕detect"}	\N	\N	\N
思い掛ける	おもいがける	{予想していたことと実際とが、食い違うさま。}	{unexpectedly}	\N	\N	\N
やがる	やがる	{軽蔑や憎しみなどの気持ちを込めて、相手の動作をいう意を表す。「あいつめ、とんだうそをつき＿った」「あんなやつに負かされ＿って」}	{"verb suffix indicating hatred and contempt","or disdain for another's action; rude conjugation: akin to adding 'f***ing' before a verb in English."}	\N	\N	\N
ビクビク	びくびく	{絶えず恐れや不安を感じて落ち着かないでいるさま。「いつも―（と）している」}	{"be hesitant/afraid; timidly (ask); be nervous"}	\N	\N	\N
疾しい	やましい	{良心がとがめる。後ろめたい。「何も―・いことはしていない」}	{"have a guilty conscience; be ashamed of; have something to hide"}	\N	{疚しい}	\N
駆動	くどう	{}	{"(4-wheel) drive; operation; 〜する operate; drive"}	\N	\N	\N
両輪	りょうりん	{}	{"both wheels〔二つの車輪〕(the) two [both] wheels (of a bicycle)"}	\N	\N	\N
四輪駆動車	よんりんくどうしゃ	{}	{"a four-wheel-drive car; a four-wheeler"}	\N	\N	\N
馬力	ばりき	{}	{"〔動力単位〕horsepower (略HP)"}	\N	\N	\N
制御	せいぎょ	{}	{"control; 〜装置 a control system; a control device; a control unit"}	\N	{制禦,制馭}	\N
梃摺る	てこずる	{取り扱いかねて、もてあます。手にあまる。処置に困る。また、解決に手間取る。「いたずらっ子に―・る」「交渉に―・る」}	{"have a hard time (with); have a lot of trouble (e.g. managing)"}	\N	{手子摺る}	\N
投函	とうかん	{郵便物をポストに入れること。「手紙を―する」}	{"〜する（手紙を）mail a letter; drop a letter into a mailbox"}	\N	\N	\N
時点	じてん	{時の流れの上で、ある一点またはある時期。「今の―では言明できない」「現―」}	{"a point in time"}	\N	\N	\N
詰まり	つまり	{物が詰まること,話の落ち着くところは。要するに。結局。すなわち。「今までいろいろ述べたが、―それはこういうことになる」}	{"(pillow) is stuffed","in short; in other words; the long and short of it; what it all comes down to; that is to say"}	\N	\N	\N
収益	しゅうえき	{事業などによって利益を得ること。また、その利益。給料。利。「―をあげる」}	{income}	\N	\N	\N
惚ける	ぼける	{頭の働きや知覚がにぶくなる。もうろくする。「年とともに―・けてきた」}	{"〔もうろくする〕become senile; (口) go dotty; (口) go gaga"}	\N	{呆ける}	\N
すっと	すっと	{"1 素早く、とどこおらずに動作をするさま。または、変化が起こるさま。「―手を出す」「人影が―消える」「からだが―軽くなる」","2 まっすぐに伸びているさま。「―伸びた肢体」"}	{"〔素早く〕quickly; immediately","〔真っすぐ，ほっそりと〕straight; slim; slender"}	\N	\N	\N
大人しい	おとなしい	{"1 騒いだりしないで、静かなさま。比喩的にも用いる。「もう少し―・くしていなさい」「健康なときは―・い細菌も体調を崩すと活発に活動を始める」","2 性質や態度などが穏やかで従順なさま。「内気で―・い子」「―・く従う」","3 色・柄などが落ち着いた感じがするさま。また、大胆さがあまり感じられないさま。「―・い色合い」「―・い着こなし」"}	{"〔静かにして騒がない〕quiet; gentle",〔行儀のよい〕well-behaved,〔はででない〕}	\N	\N	\N
渡る	わたる	{間を隔てているものの一方から他方へ越えていく。「浅瀬を歩いて―・る」「橋を―・る」「廊下を―・る」,他の人の所有物となる。「家屋敷が人手に―・る」}	{"〔向こう側に移動する〕cross over; go across","〔他人の手に移る〕pass into (other hands); come into (possession); go (from A to B)"}	\N	\N	\N
かどうか	かどうか	{判断に自信がない、迷っているといった気持ちを表す。「本当―わからない」}	{"〔どうであるか〕whether (it is new) or not"}	\N	\N	\N
どうか	どうか	{"1 心から丁重に頼み込む気持ちを表す。どうぞ。なにとぞ。「頼むから―見逃してくれ」","2 具体的な方法はともかくとして、ある問題の解決を望む気持ちを表す。なんとか。どうにか。「小遣いぐらいは自分で―する」","3 判断に自信がない、迷っているといった気持ちを表す。「本当か―わからない」「―な、難しいところだ」"}	{"〔なにとぞ〕⇒どうぞplease (e.g. forget)","〔なんとか〕somehow (I'll make it)","〔どうであるか〕whether (it is new) or not"}	\N	\N	\N
小便	しょうべん	{老廃物として腎臓で血液中から濾過 (ろか) され、尿管から膀胱 (ぼうこう) にたまり、尿道を経て体外に排出される液体。また、それを排出すること。尿。ゆばり。小用。小水。「―に立つ」「寝―」「立ち―」「―小僧」}	{"(colloquial) urine"}	\N	\N	{ションベン}
非戦闘	ひせんとう	{}	{non-combatative}	\N	\N	\N
数年	すうねん	{2、3か5、6ぐらいの年数。}	{"a few years; several years"}	\N	\N	\N
事例	じれい	{前例となる事実。}	{"an instance; an example; a case; （先例）a precedent"}	\N	\N	\N
梃	てこ	{}	{"a lever; 〜作用 leverage"}	\N	{梃子}	\N
此奴	こいつ	{三人称の人代名詞。話題になっている人を軽んじ、ののしったり親しみをこめたりしていう。「だって―が先にやったんだもん」}	{"this guy"}	\N	\N	\N
非合法	ひごうほう	{法律に定めていることに違反すること。法律の許す範囲を越えていること。また、そのさま。違法。不法。違憲。違反。「―な（の）手段」「―な（の）政治活動」}	{illegality}	\N	\N	\N
手にする	てにする	{自分の物にする。「欲しかった車をやっと―◦する」}	{"〔持つ〕have in hand〔手に入れる〕win; gain; collect"}	\N	\N	\N
一見	いっけん	{"1 一度見ること。ひととおり目を通すこと。「―に値する」「百聞は―に如 (し) かず」",2（副詞的に用いて）ちょっと見たところ。「―まじめそうな人」}	{"〔ちょっと見ること〕a look; a glance; 〜する cast a glance; have [take] a look ((at))","〔見たところ〕seemingly; look like"}	\N	\N	\N
第三国	だいさんごく	{当事国以外の国。その問題などに直接関係のない国。「―が調停に立つ」}	{"a third country [power]"}	\N	\N	\N
共犯者	きょうはんしゃ	{}	{"an accomplice (in crime)"}	\N	\N	\N
興味	きょうみ	{その物事が感じさせるおもむき。おもしろみ。関心。「人生の最も深き―あり」}	{interest}	\N	\N	\N
バレる	ばれる	{秘密や隠し事などが露見する。発覚する。「うそが―・れる」「正体が―・れる」}	{"expose (a lie/secret); (secret) coming out; leak"}	\N	\N	\N
持ちつ持たれつ	もちつもたれつ	{互いに助け合うさま。相互に助けたり助けられたりするさま。「―の関係だ」}	{give-and-take;}	\N	\N	\N
遣って来る	やってくる	{}	{"come along; come over; come around"}	\N	\N	\N
やばい	やばい	{危険や不都合な状況が予測されるさま。あぶない。「―・い商売」「連絡だけでもしておかないと―・いぞ」}	{"chancy (work); tough-and-go (job); dubious (work); in trouble (if caught)"}	\N	\N	\N
ネタ	ねた	{}	{"〔小説などの材料〕material ((for a novel)); 〔新聞などの〕a news item; ((米俗)) dope","〔証拠〕proof; evidence","〔手品などの仕掛け〕a trick","〔料理の材料〕an ingredient; material"}	\N	\N	\N
模倣品	もほうひん	{特許権・意匠権などを侵害する模倣品や、著作権を侵害する海賊版（DVD・ソフトウエア等）を防止するための国際条約。}	{"fake goods"}	\N	\N	\N
冓	こう	{}	{"[celery radical]"}	\N	\N	\N
飴	あめ	{}	{sweets}	\N	\N	\N
非番	ひばん	{当番でないこと。また、その人。}	{off-duty}	\N	\N	\N
情状酌量	じょうじょうしゃくりょう	{刑事裁判において、同情すべき犯罪の情状をくみ取って、裁判官の裁量により刑を減軽すること。「―する余地がある」}	{"Extenuation; to lessen or to try to lessen the seriousness or extent of by making partial excuses; mitigation"}	\N	\N	\N
酌量	しゃくりょう	{事情をくみ取って、処置・処罰などに手ごころを加えること。斟酌 (しんしゃく) 。「情状を―する」}	{"consideration; 〜する take into consideration; make allowance(s) ((for))"}	{名,スル}	\N	\N
情状	じょうじょう	{実際の事情。実情。「―を考慮する」}	{circumstances}	\N	\N	\N
別状	べつじょう	{普通と変わった状態。異状。「命に―はない」}	{"injury; in danger of (losing your life); something wrong; damage done"}	\N	\N	\N
別状はない	べつじょうはない	{}	{"（命に）be in no danger of losing one's life"}	\N	\N	\N
より	より	{"1 比較の標準・基準を表す。「思ったー若い」","2 ある事物を、他との比較・対照としてとりあげる意を表す。「僕ー君のほうが金持ちだ」「音楽ー美術の道へ進みたい」","3 事柄の理由・原因・出自を表す。...がもとになって。...から。...のために。","4 動作・作用の起点を表す。…から。「午前一〇時―行う」「父―手紙が届いた」「東―横綱登場」",動作の移動・経由する場所を表す。…を通って。…を。…から。}	{"(younger) than (you); (better) than (movies); (looks younger) than (her age); (rather have tea) than (coffee)","even (harder/taller);","as a result of; due to 「河川の汚染より伝染病が発生した」","from (6 o'clock); as of (April); according to","〔出発点，起点〕⇒−からfrom; (depart) from (Haneda); (1k away) from (the park); (within 100m) of (the station)"}	{格助}	\N	\N
頼り	たより	{何かをするためのよりどころとして、たよっているもの。頼み。「地図を―に家を探す」「兄を―にする」}	{"rely upon"}	\N	\N	\N
沙汰	さた	{便り。知らせ。音信。「このところなんの―もない」「音―」「無―」}	{〔便り〕}	\N	\N	\N
尺度	しゃくど	{}	{"scale; linear measure"}	\N	\N	\N
奢りだ	おごりだ	{}	{"（私の）This is my treat.; It's on me."}	\N	\N	\N
奢り	おごり	{}	{"〔ぜいたく〕luxury; extravagance","〔ごちそうすること〕a treat; (this is my) treat"}	\N	\N	\N
浄瑠璃	じょうるり	{}	{"((recite; chant)) joruri; the narrative which accompanies a Bunraku puppet show"}	\N	\N	\N
余り	あまり	{"1 使ったり処理したりしたあとになお残ったもの。残り。余剰。「―の布切れ」「シチューの―を冷凍する」","2 数量を表す語に付いて、それよりも少し多い意を表す。以上。「百名―の従業員」"}	{"〔余った物，残り〕the rest; the remnants; 〔剰余〕the remainder","〔接尾辞として，以上〕more than; moreover"}	\N	\N	{あんまり}
部屋	へや	{家の中をいくつかに仕切ったそれぞれの空間。座敷。室。間 (ま) 。「子供の―」,ホテル・アパートなどで、宿泊したり生活したりするための一区画。「この宿でいちばん高い―」「一―予約する」}	{room,"hotel; apartment"}	\N	\N	\N
出頭	しゅっとう	{}	{"hand oneself in (to the police); appear in court; 〜する appear; present oneself; report oneself"}	\N	\N	\N
大喜び	おおよろこび	{非常に喜ぶこと。「合格して―する」}	{}	{名,スル}	\N	\N
組対	そだい	{組織犯罪対策部（警視庁）の略。}	{}	\N	\N	\N
珊瑚	さんご	{}	{coral}	\N	\N	\N
鼻が高い	はながたかい	{誇らしい気持ちである。得意である。「りっぱな息子を持って私も―・い」}	{"be proud (as a superior)"}	\N	\N	\N
悪行	あくぎょう	{人の道に外れた悪い行い。悪事。凶行。「―の限りを尽くす」}	{"evildoing; 〔個々の〕an evil deed"}	\N	\N	{あっこう}
突破口	とっぱこう	{"1 敵陣の一部を突破して作った攻め口。「―を開く」",困難や障害を乗りこえる手がかり。「和平の―となる首脳会談」}	{"opening for penetration (of an enemy camp)","breakthrough opening (in negotiation)"}	\N	\N	\N
一石二鳥	いっせきにちょう	{一つの事をして同時に二つの利益・効果をあげること。一挙両得。「―の名案」}	{"'killing two birds with one stone'"}	\N	\N	\N
立ち回る	たちまわる	{}	{"〔行動する〕conduct oneself; play (one's) cards"}	\N	\N	\N
優等生	ゆうとうせい	{}	{"〔優秀な生徒〕an honor student"}	\N	\N	\N
ガサ	がさ	{《「捜す」の語幹「さが」の倒語》家宅捜索のために警官が立ち入ること。「―を食う」「―を入れる」}	{"inspection (at home by the police)"}	\N	\N	\N
重み	おもみ	{}	{"1〔重量〕(physical) weight","2〔人を威圧するもの〕(abstract) weight; significance; worth"}	\N	\N	\N
訳無い	わけない	{"1 簡単である。めんどうなことがない。「問題を―・く解いてみせる」","2 たわいない。「所体 (しょてい) つくるも町風に、―・き夜半の松の風、裾吹き返し」"}	{easily,ridiculuous}	\N	\N	\N
入り込む	はいりこむ	{中へ入る。奥深く入る。潜り込む。忍び込む。「不純物が―・む」「迷路に―・む」}	{"go into (woods); get into (room); ⇒はいる(入る)"}	\N	{入込む}	\N
愛想を尽かす	あいそをつかす	{あきれて好意や親愛の情をなくす。見限る。「放蕩 (ほうとう) 息子に―・す」}	{"throw out (of the house); lose interest"}	\N	\N	\N
愛想尽かし	あいそづかし	{相手に対して好意や愛情をなくすこと。また、それを示す言葉や態度。「―を言う」}	{"spiteful words [acts] intended to 「drive a person away [alienate a person /((俗)) turn a person off]"}	\N	\N	\N
一児	いちじ	{}	{one-year-old}	\N	\N	\N
高騰	こうとう	{物価などがひどく上がること。騰貴。値上がり。「地価が―する」}	{"a sudden rise; a sharp rise; a skyrocket increase (in price/rent)"}	{名,スル}	{昂騰}	\N
企業	きぎょう	{}	{"an enterprise（事業）a business（会社）a corporation; a company"}	\N	\N	\N
実態	じったい	{実際の状態。本当のありさま。実情。事情。「経営の―を調べる」}	{"the actual conditions; the actual circumstances; truth; fact"}	\N	\N	\N
挺身隊	ていしんたい	{}	{"a volunteer corps"}	\N	\N	\N
挺身	ていしん	{}	{"volunteered; offered"}	\N	\N	\N
毎年	まいとし	{としごと。年々。}	{"every year"}	\N	\N	{まいねん}
蜘蛛	くも	{}	{spider}	\N	\N	\N
葡萄	ぶどう	{}	{grapes}	\N	\N	\N
揶揄	やゆ	{からかうこと。なぶること。嘲り。愚弄。嘲弄 (ちょうろう) 。「世相を―する」}	{"〜する（からかう）make fun of; make a fool of; （あざける）ridicule"}	{名,スル}	{邪揄}	\N
蝸牛	かたつむり	{}	{"a snail"}	{動物}	{カタツムリ}	\N
苛める	いじめる	{}	{"〔虐待する〕ill-treat; torment; bully〔つらく当たる〕be hard on〔からかう〕tease"}	\N	{虐める}	\N
苛め	いじめ	{肉体的、精神的に自分より弱いものを、暴力やいやがらせなどによって苦しめること。}	{"(act/problem of) bullying"}	\N	{虐め}	\N
ドヤ顔	どやがお	{得意顔のこと。自らの功を誇り「どうだ」と自慢している顔。}	{"smirk face"}	\N	{どや顔}	\N
死んじまえ	しんじまえ	{}	{"drop dead; go to hell; lit. Die you!"}	\N	{死んじ前}	\N
ヤリマン	やりまん	{}	{"slut; whore"}	\N	\N	\N
仕方	しかた	{物事をする方法。やり方。手段。「掃除の―」}	{"a way; a method; （…する）how to do"}	\N	\N	\N
ダサい	ださい	{}	{"frumpy; dowdy; countrified; unrefined; provincial; ((米口)) hickish"}	\N	\N	\N
胡麻	ごま	{}	{sesame}	\N	\N	\N
胡桃	くるみ	{}	{walnut}	\N	\N	\N
発見者	はっけんしゃ	{}	{"a discoverer（遺体の）the person who found the dead body"}	\N	\N	\N
職務質問	しょくむしつもん	{警察官職務執行法に基づき、警察官が、挙動の不審な者や他人の犯罪事実を知っていると認められる者を呼び止めて質問すること。職質。}	{"questioning ((of a suspect)); a police checkup"}	{名,スル}	\N	\N
ガセ	がせ	{にせものや、まやかしものなどをいう俗語。「―ねた」}	{"fake; not true"}	\N	\N	\N
宿す	やどす	{}	{"（妊娠する）be pregnant; conceive; have a child"}	\N	\N	\N
変わる	かわる	{"1 物事の形やようすなどが今までと違った状態になる。変化する。「顔色が―・る」","2 ある場所・方向から他の場所・方向へ動く。「住まいが―・る」「別の会社に―・る」「風向きが―・る」「席を―・る」","3 普通と比べて異なっている。一般的、標準的なものと違っている。「―・った趣向」「あの人は一風―・っている」（多く「＿った」「＿っている」の形で）"}	{"〔変化する〕change (into/to) undergo a change; shift; turn; be turned; be transformed; （いろいろに）vary","〔変更する，移る〕move; remove","〔普通と違う〕（異なる）be different (from); differ; be different"}	\N	{変る}	\N
口汚い	くちぎたない	{聞く人が不快に感じるほど、言葉づかいが下品で乱暴であるさま。「人を―・くののしる」}	{"foulmouthed; abusive; bad-mouth; revile"}	\N	{口穢い}	\N
色んな	いろんな	{《「いろいろな」の音変化》さまざまの。種々の。「―話をする」}	{various}	\N	\N	\N
アラサー	あらさあ	{"《around thirtyの略》30歳前後の人。→アラフォー"}	{"around thirty person"}	\N	\N	\N
外食	がいしょく	{}	{"eating out; dining out"}	\N	\N	\N
錠剤	じょうざい	{}	{"〔球型の〕a pill〔円板状の〕a tablet"}	\N	\N	\N
巫女	みこ	{}	{"a Shinto priestess（霊媒）a medium; a psychic medium"}	\N	{神子}	{ふじょ}
市子	いちこ	{神霊・生き霊 (りょう) ・死霊 (しりょう) を呪文を唱えて招き寄せ、その意中を語ることを業とする女性。梓巫 (あずさみこ) 。巫女 (みこ) 。口寄 (くちよ) せ。}	{"a medium"}	\N	\N	\N
格闘技	かくとうぎ	{}	{"a martial art; a combat sport"}	\N	{挌闘技}	\N
格技	かくぎ	{一対一で組み合ったり打ち合ったりして勝負する競技。剣道・柔道・相撲・レスリング・ボクシングなど。格闘技。体技。}	{}	\N	{挌技}	\N
格闘	かくとう	{組み合ってたたかうこと。とっくみあい。くみうち。「―技」「暴漢と―する」}	{"a fight; a scuffle; a grapple"}	{名,スル}	{挌闘}	\N
眺める	ながめる	{"1 じっと見つめる。感情をこめて、つくづくと見る。「しげしげと人の顔を―・める」",視野に入ってくるもの全体を見る。のんびりと遠くを見る。広く見渡す。「星を―・める」「田園風景を―・める」}	{"〔見つめる〕look at; stare; gaze at","〔見渡す〕glance at; look out on"}	\N	\N	\N
裏を取る	うらをとる	{確かな証拠や証人を捜し出すなどして、供述・情報などの真偽を確認する。裏付けを取る。「犯人の自白の―・る」}	{"collect evidence; see if (alibi) stands up"}	\N	\N	\N
通報	つうほう	{情報・ニュースなどを告げ知らせること。また、その知らせ。報告。「警察に―する」「気象―」}	{"a report〔公報〕a bulletin〔内報〕(give; get) a tip"}	\N	\N	\N
見掛ける	みかける	{}	{"to (happen to) see; to notice; to catch sight of"}	\N	{見かける}	\N
証言	しょうげん	{"1 ある事柄の証明となるように、体験した事実を話すこと。また、その話。検証。「マスコミに事故の有り様を―する」",法廷などで証人が供述すること。}	{"〜する bear witness (to)","evidence; testimony; 〜する testify (to; against; in favor of); give evidence"}	\N	\N	\N
持たせる	もたせる	{"1 持つようにしてやる。持つようにさせる。また、受け持たせる。「板前に店を一軒―・せる」「所帯を―・せる」「クラスを―・せる」",保つようにさせる。「この金で今月一杯―・せる」「人工呼吸器で命を―・せる」}	{"〔所持させる〕let (someone) have; let (someone) get hold of〔持って行かせる〕have (someone) bring","〔保たせる〕being kept alive〔負担させる〕be born; be paid"}	\N	{凭せる}	\N
そっから	そっから	{}	{"from there; thence"}	\N	{そこから}	\N
煉瓦	れんが	{}	{brick}	\N	{レンガ}	\N
目的地	もくてきち	{目ざして行こうとする土地。「無事に―に着く」}	{"one's destination"}	\N	\N	\N
ご心配おかけしました	ごしんぱいおかけしました	{}	{"sorry for worrying (you)"}	\N	\N	\N
脅かす	おびやかす	{"1 おどかして恐れさせる。こわがらせて従わせる。「刃物で人を―・す」",危険な状態にする。危うくする。「インフレが家計を―・す」}	{〔脅迫する〕⇒おどす(脅す),"〔危うくさせる〕be treatened; be in jeopardy"}	\N	\N	\N
取り引き	とりひき	{"1 商人と商人、または、商人と客との間で行われる経済行為。「外国企業と―する」「―先」",互いに利益を得られるよう交渉すること。「ライバル会社と裏で―する」}	{"〔商業上の〕a deal; (conduct) a transaction; dealings; a (bank) account; business connection/relation","〔駆け引き〕deal (with criminals); (make a) deal (and agree on passing a bill)"}	\N	{取引}	\N
取引先	とりひきさき	{}	{"a customer; a client（関係者）a business acquaintance"}	\N	{取り引き先}	\N
職質	しょくしつ	{「職務質問」の略。}	{"questioning (of a suspect); a police checkup"}	{名,スル}	\N	\N
大恥	おおはじ	{ひどく面目を失うこと。赤恥。「人前で―をかかされる」}	{"big embarassment"}	\N	\N	\N
公務執行妨害	こうむしっこうぼうがい	{}	{"interference with a government official in the execution of his duties"}	\N	\N	\N
彼奴	あいつ	{}	{"〔男〕that fellow [(英) chap] (米口) that guy (英口) that bloke〔女〕that woman"}	\N	\N	\N
何でも	なんでも	{"1 どうしても。ぜひ。「何が―やりぬこう」「あれは世間に重宝する三光とやらいふ鳥であらう。―刺いてくれう」",［連語］どういうものでも。どういうことでも。「生活用品なら―ある」「頼まれたことは―する」}	{"by all means; everything","〔どれでも〕whatever; anything; any (book)"}	\N	\N	\N
蝦	えび	{}	{"（車エビ）a prawn（小エビ）a shrimp（イセエビ）a lobster"}	{動物}	{エビ,海老}	\N
蛸	たこ	{}	{"an octopus"}	{動物}	{章魚,鮹}	\N
持ち合わせ	もちあわせ	{}	{"〜の〔手持ちの〕on hand〔在庫の〕in stock"}	\N	\N	\N
持ち合う	もちあう	{互いに持つ。また、双方が分け合って持つ。「荷物を二人して―・う」「足りない分は皆で―・う」}	{"〔互いに持つ〕（分担する）share; shared with"}	\N	{持合う}	\N
依る	よる	{"1 動作の主体をだれと指し示す。「市民楽団にー・る演奏」",物事の性質や内容などに関係する。応じる。従う。「時と場合にー・る」「人にー・って感想が違う」「成功は努力いかんにー・る」}	{"〔基づく〕based on; attributed to","depending on; according to"}	\N	{拠る}	\N
苛立ち	いらだち	{思うようにならず気持ちが高ぶること。いらいらする気持ち。焦燥。焦慮。「煮えきらない態度に―を覚える」}	{irritation}	\N	\N	\N
荒んだ	すさんだ	{}	{degenerated（自堕落な）dissolute（荒れた）wild}	\N	\N	\N
荒む	すさむ	{心の持ち方・行動などが乱れてきて、ゆとりやおおらかさがなくなる。とげとげした状態になる。「気持ちが―・む」「生活が―・む」}	{"（心が）become hardened of heart; grow wild; get degenerated; lose freshness"}	\N	{進む,遊む}	\N
知り尽くす	しりつくす	{すべてを知る。すっかり知る。「政界の裏側を―・す」}	{"know inside and out"}	\N	{知尽す,知尽くす,知り尽す}	\N
招く	まねく	{"1 客として来るように誘う。招待する。招待。「歓迎会に―・かれる」",好ましくない事態を引き起こす。もたらす。「惨事を―・く」「誤解を―・く」}	{"〔手で招き寄せる〕beckon (to)〔招待する〕invite","〔引き起こす〕bring about; cause"}	\N	\N	\N
たり	たり	{"1 動作や状態を並列して述べる。「泣い―笑っ―する」「とんだり跳ね―する」",2（副助詞的に用いられ）同種の事柄の中からある動作・状態を例示して、他の場合を類推させる意を表す。「車にひかれ―したらたいへんだ」,（終助詞的に用いられ）軽い命令の意を表す。「早く行っ―、行っ―」}	{"〔並述〕and (e.g. on and off; bend and straighten; red and pale)","〔例示〕(i won't hit you) or anything",〔命令〕}	{接助}	\N	\N
様に	ように	{1.ある事物の性質・状態が他の事物に似ている意を表す。「それは羽の―軽い」「君の―スキーが出来るといいなあ」,2.〜の通りに「社長の言う―した」,3.ある動作・作用の目的・目標である意を表す。「わかりやすくなる―並べかえましょう」,婉曲 (えんきょく) な命令・希望の意を表す。「開始時刻に遅れない―」「今後ともよろしくご指導くださいます―」}	{"〔…に似て・同様に〕similar to; (light) as (a feather); likewise","〔…の通りに〕(I did) as (told)","〔…するために〕in order to; for the sake of; so that; as","～・・・ is combined with the formal form of the verb and expresses a wish"}	{助動}	\N	\N
引き取る	ひきとる	{"1 手もとに受け取る。引き受けて手もとに置く。「売れ残りを―・る」","2 引き受けて世話をする。「遺児を―・る」","3 息が絶える。死ぬ。「病院で息を―・る」",その場を立ち去る。退く。「奥の間へ―・る」「どうぞお―・りください」}	{"〔返品などを受け取る〕take back〔紛失物などを受け取る〕claim","（世話する）take care of; look after","〔死ぬ〕die (peacefully)","〔退去する〕leave (me alone)（その場を去る）leave; withdraw"}	\N	\N	\N
臼	うす	{}	{"〔つき臼〕a mortar〔挽き臼〕a set of millstones; a millstone（ひきうす）a mill（手回しの）a hand mill"}	\N	{碓}	\N
孝	こう	{親を大切にすること。孝行すること。「両親に―を尽くす」}	{"dutiful (towards parents)"}	\N	\N	\N
仕舞う	しまう	{続いていた物事を、そこで終わりにする。終業する。「仕事を―・う」,終わりになる。終わる。「予定より仕事が早く―・った」「今年は花見をせずに―・った」}	{"keep (e.g. your bankbook safe); put away/back (e.g. toys); close down (e.g. a store)","to do something by accident; to finish completely"}	\N	{仕舞う,終う,了う}	\N
代物	しろもの	{売買する品物。商品。,人や物を、価値を認めたり、あるいは卑しめたり皮肉ったりするなど、評価をまじえていう語。「めったにない―」「とんだ―をつかまされた」「あれで懲りないなんて、大した―だ」}	{"（物）an article; stuff; a thing","（人）a fellow; a character"}	\N	\N	\N
何にもならない	なににもならない	{}	{"do not lead to anywhere; be of no use（…しても）It is no use to do; It is no use doing"}	\N	\N	\N
掛ける	かける	{"1 高い所からぶらさげる。上から下にさげる。垂らす。「すだれを―・ける」「バッグを肩に―・ける」",望ましくないこと、不都合なことなどを他に与える。こうむらせる。負わせる。「苦労を―・ける」「疑いを―・ける」「迷惑を―・ける」}	{〔ぶら下げる〕hang,"〔影響などを及ぼす〕cause; put suspect to"}	\N	{懸ける}	\N
試飲	しいん	{味見をするなどの目的で、ためしに飲むこと。「新酒を―する」}	{"try drinking; sample"}	{名,スル}	\N	\N
気晴らし	きばらし	{他の物事に心を向けて気分を晴らすこと。元気回復のための娯楽。気散じ。憂さ晴らし。「―に映画を見る」}	{"〔元気回復のための娯楽〕recreation〔息抜き〕relaxation〔楽しく時間を過ごすこと〕a pastime"}	{名,スル}	\N	\N
郵便受け	ゆうびんうけ	{配達される郵便物を受け取るために家の入り口などに設ける箱。受け箱。郵便箱。}	{"a mailbox; 〔英〕a letter box"}	\N	\N	\N
敵を欺くにはまず味方から	てきをあざむくにはまずみかたから	{}	{"in fooling the enemy first deceive your allies"}	\N	\N	\N
周囲	しゅうい	{もののまわり。ぐるり。また、周辺。「―を木でかこまれた家」,""}	{"〔環境〕the surroundings; the environment〔近所〕(米) the neighborhood; (英) the neighbourhood","〔＿の事情; 付帯状況〕circumstances"}	\N	\N	\N
一切	いっさい	{"1 全部。すべて。ことごとく。「会の―をとり仕切る」「―を忘れてやり直す」",（あとに打消しの語を伴って）全然。まったく。いっせつ。「謝礼は―受け取らない」「今後―干渉しない」}	{"〔すべて〕all; everything; whole; total","〔全然〕nothing (at all); nothing (what-so-ever)"}	\N	\N	\N
左遷	させん	{低い地位・官職におとすこと。左降。「閑職に―される」《昔、中国で、右を尊び左を卑しんだところから》}	{"demotion; relegation"}	{名,スル}	\N	\N
憂き目	うきめ	{つらいこと。苦しい体験。憂さ。「落選の―を見る」「失恋の―にあう」}	{"bitter experience〔不運〕misfortune〔苦難〕hardship"}	\N	\N	\N
不良	ふりょう	{"1 質・状態などがよくないこと。また、そのさま。「―な（の）品」「発育―」「天候―」",品行・性質がよくないこと。また、その人。「行状 (ぎょうじょう) の―な（の）人」「―少年」}	{"〔よくないこと〕badness; delinquent; inferiority; failure","〔非行者〕a delinquent; a bad boy; a bad girl"}	\N	\N	\N
体調	たいちょう	{体の調子。体の状態。「―を整える」「―が良い」}	{"one's physical condition; health; feel; shape"}	\N	\N	\N
無責任	むせきにん	{責任がないこと。「事故についての―を主張する」}	{"irresponsibility; 〜な irresponsible; 〜に irresponsibly"}	{名,形動}	\N	\N
扇情	せんじょう	{人の感情や欲望をあおること。〜的：感情や情欲をあおりたてるさま。「―なポスター」}	{"suggestive (poster); sensational (newspaper)"}	\N	{煽情}	\N
一因	いちいん	{一つの原因。「物価上昇の―」}	{"a cause; a factor; a reason"}	\N	\N	\N
治安	ちあん	{世の中が治まって安らかなこと。社会の秩序・安寧が保たれていること。「―を維持する」}	{"peace and order; (public) order; (public) security"}	\N	\N	\N
垂れ流す	たれながす	{大小便を無意識のうちに出してしまう。また、排泄した大小便を始末しないで放置する。「―・して歩く」}	{（汚水などを）discharge}	\N	\N	\N
否む	いなむ	{"1 断る。嫌がる。辞退する。「申し出をむげに―・むわけにもいかない」",否定する。「―・むことのできない事実」}	{"〔拒む・断る〕refuse⇒きょぜつ(拒絶); ことわる(断る)",〔否定する〕deny}	\N	\N	\N
怨恨	えんこん	{うらむこと。また、深いうらみの心。恨み。遺恨。「―による犯行」}	{"(have/bear) a grudge (against)⇒怨み"}	\N	\N	\N
手段	しゅだん	{ある事を実現させるためにとる方法。てだて。仕方。方法。「―を講じる」「目的のためには―を選ばない」「強硬―」「生産―」}	{"（方法）a means; a way（措置）a measure; a step"}	\N	\N	\N
一体	いったい	{"1 一つのからだ。また、同一のからだのようになっていること。同体。「―を成す」「夫婦は―」「三位 (さんみ) ―」","2 全体にならしていうさま。総じて。概して。「―に今年は雪が多い」「日本人は―に表情に乏しい」",強い疑問や、とがめる意を表す。そもそも。「―君は何者だ」}	{"〔一団〕a [one] body; 〔統一体〕(a) unity","〔「一体に」の形で，全般に〕⇒がいして(概して)in general","〔強い疑問〕what on earth (bothers you); why the hell (didn't you come)⇒いったいぜんたい(一体全体)"}	\N	\N	\N
筋書き	すじがき	{"1 演劇や小説などの大体の内容を書いたもの。あらすじ。「芝居の―」",あらかじめ仕組んだ展開。計画。プラン。構造。「事が―どおりに運ぶ」}	{"〔大要〕an outline; a synopsis; a précis〔小説・劇の〕a plot","〔計画〕a plan; arrangement"}	\N	{筋書}	\N
見に来る	みにくる	{}	{"to come and see (someone/something); to visit"}	\N	\N	\N
栄転	えいてん	{今までより高い地位・役職に就くこと。転任をいう尊敬語としても用いる。}	{"a promotion 〜する be transferred to a higher post"}	{名,スル}	\N	\N
最前線	さいぜんせん	{}	{"〔戦場の〕the front (line; lines)（先頭）the forefront"}	\N	\N	\N
切らす	きらす	{用意していた物や金を出し切ってなくしてしまう。たやす。「油を―・す」「小銭を―・す」}	{"〔たくわえをなくす〕run out of（物が主語）be out of stock"}	\N	\N	\N
脅し取る	おどしとる	{脅迫して人から物を取る。「金を―・る」}	{"extort (money) from somebody by threats; blackmail somebody into handing something over."}	\N	\N	\N
人権問題	じんけんもんだい	{}	{"the human rights question"}	\N	\N	\N
人権	じんけん	{人間が人間として当然に持っている権利。基本的人権。}	{"human rights; civil liberties"}	\N	\N	\N
懸ける	かける	{}	{"（賞金を）offer a prize（命を）risk one's life"}	\N	\N	\N
命がかかってるんだ	いのちがかかってるんだ	{}	{"life is at stake"}	\N	{命が懸かってるんだ}	\N
命を懸ける	いのちをかける	{命を捨てる覚悟で物事に立ち向かう。「新しい研究に―・ける」「―・けた恋」}	{"risk one's life"}	\N	{命をかける}	\N
取り返す	とりかえす	{"1 人手に渡ったものを取り戻す。「おもちゃを―・す」「優勝旗を―・す」",再びもとのようにする。もとへ戻す。「元気を―・す」「勉強の遅れを―・す」}	{"get back; take back","recover; catch up; make up"}	\N	{取返す}	\N
一か八か	いちかばちか	{}	{"all-or-nothing proposition; sink-or-swim; 結果はどうなろうと、運を天に任せてやってみること。のるかそるか。「よし、―勝負してみよう」"}	\N	\N	\N
礼	れい	{"1 社会秩序を保ち、人間関係を円滑に維持するために守るべき、社会生活上の規範。礼儀作法・制度など。「―にかなったやり方」「―を失する」「―を尽くす」","2 敬意を表すために頭を下げること。おじぎ。「先生に―をする」",謝意を表すこと。また、その言葉。また、謝礼のために贈る金品。「本を借りた―を言う」「世話になった人に―をする」}	{〔礼儀〕etiquette,"〔おじぎ〕a bow〔女性が片足を引いて身を低くするおじぎ〕a curts(e)y","〔感謝〕thanks; gratitude"}	\N	\N	\N
外れる	はずれる	{"1 掛けたりはめたりした位置から抜け出る。「ボタンが―・れている」「障子が―・れる」","2 目標からそれる。「狙 (ねら) いが―・れる」「くじに―・れる」",予測や期待していたこととは違う結果になる。くいちがう。「当てが―・れる」「予報が―・れる」}	{"〔留めてあるもの・掛けてあるものが離れる〕be disconnected; (handle) come off; (button) is undone","〔外へそれる〕be beside (the point); be off (key); out of (tune)","〔当たらない〕miss (a mark); draw a blank; be proved wrong"}	\N	\N	\N
運動	うんどう	{からだを鍛え、健康を保つために身体を動かすこと。スポーツ。体操。「肥満防止のために―する」「―競技」}	{"〔体を動かすこと〕exercise〔スポーツ〕sports〔運動競技〕athletics 〜する get [take] exercise; exercise"}	{名,スル}	\N	\N
咽頭	いんとう	{口腔 (こうこう) 、鼻腔および食道の間の筋肉性の袋状の管。呼吸・嚥下 (えんか) ・発声などの作用をする。}	{"the pharynx (複 〜es; -rynges)"}	\N	\N	\N
厳粛	げんしゅく	{おごそかで、心が引き締まるさま。「―な儀式」}	{"solemnity; gravity; 〜な (に) solemn(ly); grave(ly)"}	{形動}	\N	\N
裏側	うらがわ	{裏のほう。また、裏面。裏手。「山脈の―」「事態の―が見えてきた」⇔表側。}	{"back side; hidden side"}	\N	\N	\N
政界	せいかい	{政治にたずさわる者の社会。政治家の世界。}	{"the political world; political circles"}	\N	\N	\N
纏まる	まとまる	{"1 ばらばらのものが統一のとれたひとかたまりになる。「引っ越し荷物が―・る」「―・った金額」","2 物事の筋道が立って整う。片付く。「計画が―・る」「考えが―・る」",決まりがつく。互いの意志を一致させる。「交渉が―・る」「縁談が―・る」}	{"〔集まる〕be collected","〔整う〕be well arranged〔統一がある〕be united","〔決着がつく〕be settled"}	\N	\N	\N
入って来る	はいってくる	{}	{"arriving; incoming"}	\N	{入ってくる}	\N
箪笥	たんす	{}	{"〔整理箪笥〕a chest of drawers; a wardrobe (米) a bureau; a dresser"}	\N	\N	\N
正面	まとも	{"1 まっすぐに向かい合うこと。正しく向かい合うこと。また、そのさま。真正面。「―に風を受ける」「―に相手の顔を見る」",まじめなこと。正当であること。また、そのさま。「―な人間になりたい」「これは―な金だ」}	{"〔正面〕〜に 〔じかに〕directly〔まっすぐに〕straight〔面と向かって〕to one's face","〔誤りのないこと〕〜な 〔正直な〕honest〔妥当な〕proper〔ちゃんとした〕respectable"}	{名,形動}	{真面}	\N
通じる	つうじる	{}	{"1〔道路などが〕lead〔鉄道・バス・道などが〕run (from a place to another place; between a place and another place)","2 go ((to)); 〔鉄道・バス・道などが〕run ((from a place to another place; between a place and another place))","3〔連絡する〕let someone know〔相手に理解される〕get (point) across; make (oneself) understood;","4〔電話が〕reach; get to"}	\N	\N	\N
在り来たり	ありきたり	{珍しくないこと。ありふれていること。また、そのさま。平凡。並。凡俗。俗。「―な（の）意見」}	{"〜の common（平凡な）ordinary"}	{名,形動}	\N	\N
突き落とす	つきおとす	{突いて高い所から下へ落とす。「谷底に―・す」}	{"〔突いて〕push (a rock) over/off (a cliff)"}	\N	{突落す,突落とす,突き落す}	\N
収賄	しゅうわい	{賄賂 (わいろ) を受け取ること。⇔贈賄。}	{"acceptance of a bribe; (米口) graft 〜する take [accept] a bribe; take graft"}	{名,スル}	\N	\N
贈賄	ぞうわい	{賄賂(わいろ)をおくること。⇔収賄。}	{bribery}	{名,スル}	\N	\N
賄賂	わいろ	{自分の利益になるようとりはからってもらうなど、不正な目的で贈る金品。袖の下。まいない。裏金。「―を受け取る」}	{"〔贈収賄〕bribery (主に米) graft〔金・物〕a bribe"}	\N	\N	\N
行き過ぎる	いきすぎる	{}	{"go past; go beyond","（極端になる）go too far"}	\N	\N	\N
流れ	ながれ	{"1 液体や気体が流れること。また、その状態や、そのもの。「潮の―が速い」「空気の―が悪い」「川の―をせき止める」","2 流れるように連なって動くもの。また、その動き。「人の―に逆らって歩く」「車の―がとどこおる」","3 時間の経過や物事の移り変わり。「時代の―に乗る」「試合の―を読む」",""}	{"a stream; a current (of water/air)","a stream; flow (of cars/people)","（時の）the passage of time","（話の）the flow of talk; a storyline"}	{名}	\N	\N
壬	みずのえ	{《「水の兄 (え) 」の意》十干の9番目・第九。「壬申」}	{"The Ninth of the ten Celestial or Heavenly Stems"}	\N	\N	{じん}
窒素	ちっそ	{}	{"nitrogen (記号N)"}	\N	\N	\N
委嘱	いしょく	{一定期間、特定の仕事を他の人に任せること。委託。「監査役を―する」}	{"〔職権などの委任〕commissioning (of)〔任命〕appointment"}	\N	{名,スル}	\N
旋回	せんかい	{}	{"revolution; circling"}	{名,スル}	\N	\N
言葉	ことば	{"1 人が声に出して言ったり文字に書いて表したりする、意味のある表現。言うこと。「友人の―を信じる」",音声や文字によって人の感情・思想を伝える表現法。言語。「日本の―をローマ字で書く」}	{"〔言ったこと〕(make) a statement; a remark〔演説〕a speech","〔言語〕(a) language; speech"}	\N	{詞,辞}	\N
\.


--
-- TOC entry 2293 (class 0 OID 16722)
-- Dependencies: 174
-- Data for Name: names; Type: TABLE DATA; Schema: public; Owner: e
--

COPY names (name, reading, description, origin) FROM stdin;
闇芝居	やみのしばい	テレビ東京ほかで放送された、都市伝説を題材とした日本のショートアニメ	mixed-entities
如月	きさらぎ	陰暦2月の異称。《季 春》「―やふりつむ雪をまのあたり／万太郎」	politicians
梅原大吾	うめはら だいご	天才のスト選手。	street-fighter
斑鳩	いかるが	奈良県生駒郡斑鳩町法隆寺を中心とした地域。古くは鵤とも表記された。	mixed-locations
笹団子	ささだんご	新潟県特産の餡の入ったヨモギ団子を数枚のササの葉でくるみ、スゲまたはイグサの紐で両端を絞り、中央で結んで蒸した和菓子である。	food
煎餅	せんべい	干菓子の一。小麦粉に卵・砂糖・水などを加えて溶いて焼いた瓦煎餅の類と、米の粉をこねて薄くのばし、醤油や塩で味つけして焼いた塩煎餅の類とがある。	food
萩原朔太郎	はぎわら さくたろう	（１８８６-1942年）日本の詩人。大正時代に近代詩の新しい地平を拓き「日本近代詩の父」と称される。	writers
金田正太郎	かねだ しょうたろう	主人公。自称「健康優良不良少年」。高い運動神経の持ち主であるとともに、走り屋としては度胸のある走りをする。そのすばしっこさや逃げ足の速さは、軍隊でも捕まえられないほどで、大佐を驚嘆させた。	akira
島鉄雄	しま てつお	もうひとりの主人公。41号とも呼ばれる。金田の幼馴染み。金田チームのスクラムハーフとして暴走中、タカシと衝突事故を起こしたことがきっかけで超能力に覚醒。能力の爆発的な成長によりアキラに迫る力を手に入れ世界を翻弄する。喧嘩も強くリーダー格である幼馴染の金田に対し、幼少の頃から絶えず劣等感を抱き、自分が金田を始めとする仲間たちから庇護されるいじめられやすく弱い存在であることに不満と絶望を抱いていた。	akira
アキラ	あきら	この作品の核心に位置する少年。28号とも呼ばれる。1982年に覚醒、超能力の暴走により東京崩壊を起こしたため、地下で永久に冷凍封印され軍の厳重な監視下にあった。	akira
ケイ	けい	反政府ゲリラの少女。兄の後輩である竜とは息の合ったコンビ。当初は竜を慕っていた。原作・劇場版とも偶然出会った金田に窮地から助けられ、言い寄られるのを拒否しつつも行動を共にする。	akira
敷島大佐	しきしま たいさ	軍の実質的な最高指揮官で、凍結封印されたアキラの管理者でもあった。軍高官だった父親がアキラの災厄に遭って死亡したことから、アキラにこだわる。劇場版では鉄雄の暴走を食い止めようと奔走し、原作ではクーデターを起こしてまでアキラを奪取しようと試みるも、根津の誤射によりすんでの所で保護に失敗、再びアキラの力を目の当たりにする。	akira
ドクター大西	おおにし	大佐のもとでアキラを始めとするナンバーズ（後述）の研究管理を司る人物だが、研究に熱中するあまり、周囲を顧みずに鉄雄の暴走を許す。作品上、最年長。	akira
竜作	りゅうさき	通称・竜。ケイの反政府ゲリラグループのリーダー。ケイの助言に従い金田をグループに入れた張本人。革命を信じて行動するも、より大きなうねりに翻弄され、幾度と無く危機的な状況に陥った。	akira
タカシ	たかし	26号とも呼ばれる。3人の古いナンバーズの中では最も性格的に幼く、外の世界に出てみたいという単純な理由から物語冒頭にゲリラの手引きで研究施設から脱走、鉄雄の超能力覚醒の引き金となる。	akira
キヨコ	きよこ	25号とも呼ばれる。彼女の未来予知は93〜95%の確率で当たり、ネオ東京崩壊も予知した。身体的にはひどく弱っており、寝たきりで自力で動くことはほとんどできないが、超能力で自分のベッドや自分自身を浮かせることができる。	akira
マサル	まさる	27号と呼ばれる。小児マヒを患っており、そのために浮遊する椅子に座って移動する（座らないシーンも存在する）。	akira
カオリ	かおり	原作では難民→鉄雄の遊び相手→鉄雄の侍女。当初は、被災体験のショックから感情の発露も少なかったが、本来は明るく優しい性格であり、アキラの面倒もよく見ていた。	akira
山形	やまがた	金田チームの特攻隊長的存在。チームで2番目に背が高い。腕っ節が強く乱暴ではあるものの、仲間に対しては義理堅く面倒見もいい性格。劇場版・漫画版共に、超能力を得た鉄雄の前に立ちはだかった末に惨殺される。	akira
甲斐	かい	背が低く、ラフな服装の金田達とは違い、唯一、ジャケットにタイといったトラッドな格好を好む、チーム内ではまともな方。金田に匹敵、オフロードではそれ以上のバイク操縦テクニックの持ち主。	akira
根津	ねづ	国会野党に属する政治家。表ではミヤコの教団の力を背景に政界工作を行い（原作）、裏ではケイの反政府ゲリラに資金を与え指導している（原作・劇場版共）。原作ではタカシを誤って射ち、アーミーの応射によって射殺される。	akira
大佐	たいさ	声：青野武。雷電の上官。	mgs
ミヤコ	みやこ	アキラを奉る宗教を指導する老婆。かつてアキラの力を目の当たりにして失明するも、強い感応力で他人の視覚を共有することができる。原作では仮死状態のまま破棄された元ナンバーズ（19号）であり、ネオ東京崩壊後はメインキャラクター達に多くの助言を与え、鉄雄とも直接対決する。劇場版では完全にエキストラ扱いで、モブシーンに数度登場する程度。	akira
岡本千鶴	おかもと ちづる	誘拐された香織の母親。	akutou
壬生	みぶ	京都市中京区の地名。友禅染めの染色工場が多い。壬生菜の産地。壬生寺がある。	mixed-locations
八岐大蛇	やまたのおろち	『日本書紀』での表記。『古事記』では八俣遠呂智と表記している。	mixed-entities
川島永嗣	かわしま えいじ	埼玉県与野市出身のサッカー選手。スコティッシュ・プレミアシップのダンディー・ユナイテッド所属。日本代表。ポジションはゴールキーパー。	mixed-persons
はじめしゃちょー	初め社長	YouTubeの人！23歳。疲労のヒーローはじめしゃちょーです。気軽にフォローしてください。UUUM所属。AB型。座右の銘は「お菓子は禁止」	mixed-persons
石黒孝雄	いしぐろ・たかお	刑事課・課長（警部）	akutou
杉田智和	すぎた・ともかず	和平ミラーの声優	actors
大塚明夫	おおつか・あきお	スネークの声優	actors
高橋克典	たかはし・かつのり	神奈川県横浜市出身。悪党〜重犯罪捜査班-主演・富樫正義役	actors
飯沼玲子	いいぬま・れいこ	刑事（巡査部長）	akutou
猪原勇作	いのはら・ゆうさく	刑事課第一係・係長（警部補）	akutou
北村一平	きたむら・いっぺい	和田の遊び仲間	akutou
霧島修	きりしま・	暴力団の元構成員・第四係が情報屋として利用	akutou
霧島	きりしま・	霧島修。暴力団の元構成員・第四係が情報屋として利用	akutou
三枝由美	さえぐさ・ゆみ	交通課・警官（共に階級は巡査）	akutou
里中啓一郎	さとなか・けいいちろう	刑事課第四係・係長（警部補）	akutou
里中理恵	さとなか・りえ	里中の妻	akutou
柴田安春	しばた・やすはる	刑事（巡査部長）	akutou
田丸由紀夫	たまる・ゆきお	横浜城東貿易会長の長男・後継者	akutou
津上譲司	つがみ・じょうじ	刑事（巡査長）	akutou
富樫正義	とがし・まさよし	刑事課第四係主任（巡査部長）	akutou
富樫のぞみ	とがし・のぞみ	富樫の娘。富樫の妻・紀子の連れ子なので実子ではない。中学二年生。	akutou
富樫紀子	とがし・のりこ	富樫正義の妻	akutou
徳永靖	とくなが・やすし	横浜港町署刑事課第四係・前係長	akutou
氷室哲夫	ひむろ・てつお	村雨組の幹部。柴田と顔見知り。	akutou
平松亜美	ひらまつ・あみ	交通課・警官（共に階級は巡査）	akutou
藤井佐知代	ふじい・さちよ	富樫の妻・紀子の母親。のぞみの祖母。身体が弱いために、富樫やのぞみと同居している。	akutou
西村和也	にしむら・かずや	玲子の年下の交際相手。実際はヒモ	akutou
前島隆造	まえじま・りゅうぞう	警務部長（階級不明）	akutou
緑川麻子	みどりかわ・あさこ	由紀夫の婚約者・被害者	akutou
緑川信子	みどりかわ・のぶこ	麻子の母親	akutou
村雨組	むらさめぐみ	暴力団。	akutou
森川明日香	もりかわ・あすか	フリージャーナリスト	akutou
山下学	やました・がく	刑事（巡査部長）	akutou
井上康生	いのうえこうせい	宮崎県宮崎市出身[1]の柔道家（六段）、柔道指導者。2000年のシドニー五輪で金メダルを獲得。2001年の全日本選手権では全日本の絶対的エースであった篠原信一を決勝で破り初優勝。その後、大会3連覇を果たす。	budo
木村政彦	きむら・まさひこ	熊本県出身の伝説柔道家	budo
斉藤仁	さいとう ひとし	(1961-2015年)元柔道選手。ロサンゼルスオリンピック、ソウルオリンピック柔道競技男子95kg超級金メダリスト。現在柔道コーチ、国士舘大学体育学部教授で同大学柔道部監督。青森県青森市出身。段位は九段。	budo
篠原信一	しのはら しんいち	青森県東津軽郡平内町生まれ、兵庫県神戸市長田区出身。身長190cm。現役時代の体重135kg。「篠」は、正式には「イ|」のない漢字（竹冠がついた「条」（筿）に近い）である。芸能事務所「エース・アラウンド」所属。	budo
牛島辰熊	うしじま・たつくま	柔道史上最強を謳われる木村政彦の師匠として有名だ	budo
大山倍達	おおやまますたつ	極真会創設者	budo
山下泰裕	やましたやすひろ	熊本県出身の九段柔道家。日本オリンピック委員会理事。引退から逆算して203連勝（95kg超級）	budo
安土城	あづちじょう	琵琶湖東岸の安土山（現在の滋賀県近江八幡市安土町下豊浦）にあった日本の城（山城）。城址は国の特別史跡で、琵琶湖国定公園第1種特別地域になっている。	castles
伏見城	ふしみじょう	現在の京都市伏見区桃山町周辺にあった日本の城。	castles
桃山城	ももやまじょう	現在の京都市伏見区桃山町周辺にあった日本の城。	castles
安渓鉄観音	あんけいてっかんのん・安溪铁观音・ĀnxīTiěguānyīn	お金を出しても以前ほどの品質の鉄観音は手に入らなくなった。安渓に行ったけれど鉄観音は無かったよ。	cha
烏龍茶	うーろんちゃ	中国茶のうち青茶と分類され、茶葉を発酵途中で加熱して発酵を止め、半発酵させた茶である。中国語でいう「青」は「黒っぽい藍色」を指す。	cha
緊圧茶	きんあつちゃ	茶葉を圧縮成形して固めた、加工された中国茶の茶葉の形状を表す言葉である。団茶、片茶、圧縮茶、固形茶とも呼ばれる。	cha
黄山毛峰茶	こうざんもうほうちゃ	中国安徽省歙県の名山黄山を産地とする緑茶である。いわゆる「十大名茶」の一つ。	cha
紅茶	こうちゃ	摘み取った茶の葉と芽を萎凋（乾燥）させ、もみ込んで完全発酵させ、乾燥させた茶葉。	cha
磚茶	じゅあんちゃ	英語圏ではTea brickと呼ばれている。	cha
締茶	じんちゃ	沱茶の一種である。キノコあるいは駒のような形状をしている。	cha
青茶	せいちゃ	烏龍茶と同じだ。	cha
たん茶	磚茶	英語圏ではTea brickと呼ばれている。	cha
知覧茶	ちらちゃ	日本有数の緑茶生産地である鹿児島県南九州市にて栽培されている緑茶の総称またはそのブランド。	cha
鉄観音	てっかんのん・铁观音・Tiěguānyīn	中国茶のうち青茶（半発酵茶）の一種で、広い意味の烏龍茶の一種である。中華人民共和国の福建省安渓県で作られる安渓鉄観音と台湾の台北市文山区付近で作られる木柵鉄観音が代表的銘柄である。	cha
沱茶	とうちゃ	1917年に雲南省の製茶場が開発した形状である。もともとはお椀のような形状を表す『坨(い)茶』と名付けられていたが、沱江の水で淹れるとおいしいとのことから現在の名称に改名された。	cha
花茶	はなちゃ	は中国茶の一種。緑茶や青茶など茶の製法によって分類する六大分類とは別種に分類される。そのため、最近では六大分類に花茶を加える方法で中国茶を分類するのが主流となっている。	cha
碧螺春	ピールオチュン	１千年前宋王朝には既に存在していたお茶です。	cha
戸田山	とだやま	神奈川県警本部捜査一課刑事	akutou
餅茶	びんちゃ	円茶は、丸餅を模した緊圧茶である。表面はやや盛り上がった丘陵状、裏面は中央部にくぼみが作られている。	cha
武夷岩茶	ぶいがんちゃ	拼音：Wŭyíyánchá。福建省北部の武夷山市で生産される青茶（烏龍茶）・他の種類。茶樹が山肌の風化した岩に生育しているためにこの名がある。	cha
普洱熟茶	ぷーあるじゅくちゃ	プーアル生茶を多湿状態に置くことで、カビによる発酵をさせて作られる。年代を経た茶葉の風味を短時間で量産できる方法として、1973年頃から作られるようになった。生茶に比べて色が濃く、暗褐色を呈す。一般的によく知られているプーアル茶は熟茶である。	cha
普洱茶	ぷーあるちゃ	中華人民共和国雲南省南部及び南西部を原産地とする中国茶（黒茶）の一種。生茶と熟茶の2種類ある。	cha
普洱生茶	ぷーあるなまちゃ	緑茶を残存する酵素で発酵させた茶葉。生産されてまだ日が浅い茶葉は、極めて緑茶に近い。しかし、年代を経るほどに、白茶様、烏龍茶様、紅茶様の香りとなり、最終的にはプーアル熟茶に近い香りと味わいになる。	cha
佛茶	ぶっちゃ	日本：ぶっちゃ、中国：Fo cha; Buddhist tea	cha
方茶	ほうちゃ	磚茶の一種。平たい正方形に整形される。上面に文字があしらわれていることが多い。	cha
木柵鉄観音	もくさくてっかんのん・木柵鐵觀音・MùshānTiěguānyīn	台湾の北部、台北市の文山区を起源としております。	cha
六安瓜片茶	ろくあんかへんちゃ	リュウアンゴピエンちゃ。古く中国茶歴史中にある中国十大名茶の一つです。	cha
緑茶	りょくちゃ	チャノキの葉から作った茶のうち、摘み取った茶葉を加熱処理して発酵を妨げたもの。もしくはそれに湯を注ぎ、成分を抽出した飲料のこと。	cha
龍井茶	ろんじんちゃ	中華人民共和国杭州市特産の緑茶。色が緑、茶葉が平、味が醇和、香が馥郁であることから四絶と中国では称されている。中国を代表的する緑茶であると誰もが答える逸品である。	cha
安徽省	あんきしょう	英語:Anhui。中華人民共和国の省。名称は安慶の安、徽州（現黄山市）の徽による。省都は合肥市。略称は皖。	chuugoku-chiri
安渓県	あんけいけん・Ānxī	泉州市に位置する県。	chuugoku-chiri
雲南省	うんなんしょう	英語:Yunnan。中華人民共和国西南部に位置する省。略称は滇（てん）。省都は昆明市。	chuugoku-chiri
杭州	こうしゅうし	英語:Hangzhou。中華人民共和国浙江省の省都（副省級市）。浙江省の省人民政府の所在地。中国八大古都の一であり、国家歴史文化名城に指定されている。13世紀は世界最大の都市であった。	chuugoku-chiri
江蘇省	こうそしょう	英語:Jiangsu。東部にある行政区。長江の河口域であり、北部は淮河が流れ黄海に面する。名称は江寧（現南京市）の江、蘇州の蘇による。省都は南京市。略称は蘇。	chuugoku-chiri
昆明市	こんめいし	英語: Kunming。中華人民共和国雲南省の省都であり、雲南省の政治、経済、文化、交通の中心地である。また1400年の歴史を有する国家歴史文化名城でもある。	chuugoku-chiri
四川省	しせんしょう	英語: Sichuan。中華人民共和国西南部に位置する省。略称は川あるいは蜀。省都は成都。	chuugoku-chiri
西湖	せいこ	拼音: Xī Hú。浙江省杭州市にある湖。	chuugoku-chiri
浙江省	せっこうしょう	英語:Zhejiang。中華人民共和国の省の一つ。略称は浙。	chuugoku-chiri
台北市	タイペイし・たいほくし・Táiběi Shì	capital city and a special municipality of Taiwan. Sitting at the northern tip of Taiwan, Taipei City is an enclave of the municipality of New Taipei City.	chuugoku-chiri
武夷山	ぶいさん	英語：Wu Yi mountains。福建省にある黄崗山（2,158m）を中心とする山系の総称。	chuugoku-chiri
福州市	ふくしゅうし	英語: Fuzhou。中華人民共和国福建省の省都である。	chuugoku-chiri
福建省	ふっけんしょう	英語:Fujian。省の一つで、大部分を中華人民共和国が統治し、一部の島嶼を中華民国（台湾）が統治している。省都は福州市。	chuugoku-chiri
文山区	ぶんざんく・Wénshān	台北市の市轄区。	chuugoku-chiri
宇都宮市	うつのみやし	関東地方の北部、栃木県の中部に位置する市で、同県の県庁所在地である。1996年4月1日より、中核市に指定されている。	cities
大津市	おおつし	滋賀県の南西端に位置する市で、同県の県庁所在地である。中核市に指定されている。	cities
大阪市	おおさかし	日本の近畿地方（関西地方）、大阪府のほぼ中央に位置する市で、同府の府庁所在地である。政令指定都市に指定されている。	cities
落合福嗣	おちあい ふくし	日本のタレント、歌手、声優。	cities
鎌倉市	かまくらし	神奈川県、三浦半島西側の付け根に位置し、鎌倉を中心部とする市である。	cities
京都市	きょうとし	京都府南部に位置する市で、同府最大の都市であり、府庁所在地である。	cities
甲府市	こうふし	山梨県中部に位置する都市で同県の県庁所在地・特例市。	cities
神戸市	こうべし	兵庫県南部に位置する兵庫県の県庁所在地である。垂水区・須磨区・長田区・兵庫区・中央区・灘区・東灘区・北区・西区から構成される政令指定都市である。	cities
札幌市	さっぽろし	北海道にある政令指定都市で、道庁所在地（都道府県庁所在地）及び石狩振興局所在地となっている。10の行政区がある。	cities
鈴鹿市	すずかし	三重県北部に位置する人口約20万の市である。市のキャッチコピーは「さぁ、きっともっと鈴鹿。	cities
仙台市	せんだいし	宮城県中部に位置する、同県の県庁所在地かつ政令指定都市である。また東北地方最大の都市でもある。	cities
瑞西	ずいす	ヨーロッパにある連邦共和制国家。永世中立国だが、欧州自由貿易連合に加盟している。	countries
雷神	らいじん	日本の民間信仰や神道における雷の神である。	kami
高松市	たかまつし	四国の北東部、香川県の中央に位置する市で、香川県の県庁所在地である。旧香川郡・木田郡・綾歌郡（1890年2月15日の市制当時の区域は旧香川郡）。四国の経済の中心地で、国から中核市に指定されている。高松都市圏の中心都市である。	cities
津市	つし	日本の三重県中部に位置する都市で、三重県の県庁所在地である。	cities
函館	はこだて	北海道の町	cities
日之影町	ひのかげちょう	宮崎県の北部に位置する町で、西臼杵郡に属している。	cities
姫路市	ひめじし	近畿地方の西部、兵庫県南西部（播磨地方）に位置する市。旧飾磨郡・神崎郡・揖保郡・印南郡・宍粟郡（1889年の市制当時の区域は旧飾磨郡）。中核市に指定されており、周辺自治体を含めて約74万人の姫路都市圏を形成している。中播磨県民センターの管轄。	cities
平安京	へいあんきょう	延暦13年10月22日（西暦794年）の桓武天皇入京以降、日本の首都と見なされた計画都市である。	cities
別府市	べっぷし	大分県の東海岸の中央にある市。大分県第二の都市である。	cities
那覇市	なはし	沖縄本島南部の中核市で、沖縄県の県庁所在地である。	cities
奈良市	ならし	日本の奈良県の北部に位置する都市で、同県の県庁所在地である。日本政府から中核市に指定されている。	cities
前橋市	まえばしし	関東地方群馬県の中南部にある中核市。群馬県の県庁所在地である。	cities
松江市	まつえし	島根県東部（出雲地方）に位置する市で、同県の県庁所在地である。2012年（平成24年）4月1日に特例市に移行した。	cities
松本市	まつもとし	長野県中信地方に位置する市。特例市や国際会議観光都市に指定されている。	cities
松山市	まつやまし	愛媛県の中部に位置する中核市。同県の県庁所在地であり、四国地方で最大の人口を擁する。	cities
水戸市	みとし	茨城県の中部に位置する県庁所在地で、特例市である。	cities
盛岡市	もりおかし	岩手県の中部に位置する同県の県庁所在地である。	cities
横浜市	よこはまし	関東地方南部、神奈川県の東部に位置する都市で、同県の県庁所在地。政令指定都市の一つであり、18区の行政区を持つ。現在の総人口は日本の市町村では最も多く、人口集中地区人口も東京23区（東京特別区）に次ぐ。 神奈川県内の市町村では、面積が最も広い。市域の過半は旧武蔵国で、南西部は旧相模国。	cities
龍ケ崎市	りゅうがさきし	茨城県南部に位置する市である。東京都市圏#茨城県。	cities
亘理町	わたりちょう	宮城県南部の太平洋沿岸、阿武隈川の河口に位置する町。	cities
萩原亜咲	はぎわら・あさき	「Whipper Snapper Gym」のオーナー	climbers
小林由佳	こばやし・ゆか	(1989年12月29日)フリークライマー。茨城県那珂郡東海村出身。茨城県立水戸第三高等学校、筑波大学大学院卒、筑波大学体育専門学群特殊体育学研究室出身。	climbers
アメリカ合衆国	アメリカがっしゅうこく	通称アメリカ、50の州及び連邦区から成る連邦共和国である。	countries
伊太利亜	いたりあ	伊と略されることもある。通称イタリアは、ヨーロッパにおける単一議会制共和国である。	countries
伊蘭	いらん	通称イランは、西アジア・中東のイスラム共和制国家。ペルシア、ペルシャともいう。	countries
印度	いんど	南アジアに位置し、インド亜大陸を占める連邦共和制国家で 。	countries
英国	えいこく	通称の一例としてイギリス、ヨーロッパの主権国家である。	countries
埃及	えじぷと	埃と略す。通称エジプトは、中東・アフリカの共和国。首都はカイロ。	countries
越南	えつなん	通称ベトナムは、東南アジアのインドシナ半島東部に位置する社会主義共和制国家。	countries
墺太利	おーすとりあ	オーストリアは、ヨーロッパの連邦共和制国家。首都はウィーン。略表記：墺	countries
和蘭	おらんだ	蘭と略される。オランダ王国の構成国の一つ。国土の大半は西ヨーロッパに位置し、カリブ海にも特別自治体の島を有する。	countries
和蘭陀	おらんだ	蘭と略される。オランダ王国の構成国の一つ。国土の大半は西ヨーロッパに位置し、カリブ海にも特別自治体の島を有する。	countries
阿蘭陀	おらんだ	蘭と略される。オランダ王国の構成国の一つ。国土の大半は西ヨーロッパに位置し、カリブ海にも特別自治体の島を有する。	countries
加奈陀	かなだ	「加」と略される。10の州と3の準州を持つ連邦立憲君主制国家である。イギリス連邦加盟国であり、英連邦王国のひとつ。	countries
韓国	かんこく	朝鮮半島（韓半島）南部を実効統治する東アジアの共和制国家であり、戦後の冷戦で誕生した分断国家。	countries
大韓民國	だいかんみんこく	朝鮮半島（韓半島）南部を実効統治する東アジアの共和制国家であり、戦後の冷戦で誕生した分断国家。	countries
大韓民国	だいかんみんこく	朝鮮半島（韓半島）南部を実効統治する東アジアの共和制国家であり、戦後の冷戦で誕生した分断国家。	countries
柬埔寨	かんぼじあ	通称カンボジアは、東南アジアのインドシナ半島南部に位置する立憲君主制国家。	countries
柬蒲寨	かんぼじあ	通称カンボジアは、東南アジアのインドシナ半島南部に位置する立憲君主制国家。	countries
希臘	ぎりしゃ	通称ギリシャは、東南ヨーロッパに位置する国である。	countries
豪州	ごうしゅう	オーストラリア大陸本土、タスマニア島及び多数の小島から成るオセアニアの国である。	countries
濠洲	ごうしゅう	オーストラリア大陸本土、タスマニア島及び多数の小島から成るオセアニアの国である。	countries
西班牙	すぺいん	西と略す。ヨーロッパ南西部のイベリア半島に位置し、同半島の大部分を占める立憲君主制国家。	countries
瑞典	ずいてん	北ヨーロッパのスカンディナヴィア半島に位置する立憲君主制国家。西にノルウェー、北東にフィンランド、南西にカテガット海峡を挟んでデンマーク、東から南にはバルト海が存在する。首都はストックホルム。スウェーデン語ではSverige（スヴェーリエ）といい、スヴェーア族の国を意味する。	countries
泰	たい	タイ王国。東南アジアに位置する立憲君主制国家。	countries
台湾	たいわん	東アジアの島嶼である。1945年に当時中国大陸を本拠地とした中華民国の統治下に入り、1949年に中華民国政府が台湾に移転した。	countries
中華人民共和国	ちゅうかじんみんきょうわこく	英: People's Republic of China, PRC、通称中国。	countries
中国	ちゅうごく	ユーラシア大陸の東部を占める地域、および、そこに成立した国家や社会。中華と同義。	countries
丁抹	でんまーく	丁と略される。北ヨーロッパのバルト海と北海に挟まれたユトランド半島と、その周辺の多くの島々からなる立憲君主制国家である。	countries
独国	どくこく	独（獨）と略される。通称ドイツは、ヨーロッパ中西部における議会制共和国である。	countries
土国	どこく	通称トルコは、西アジアのアナトリア半島（小アジア）と東ヨーロッパのバルカン半島東端の東トラキア地方を領有する、アジアとヨーロッパの2つの大州にまたがる共和国。	countries
南阿共和国	なんあきょうわこく	通称南アフリカは、アフリカ大陸最南端に位置する共和制国家で、イギリス連邦加盟国である。	countries
日本	にほん	東アジアに位置する日本列島（北海道・本州・四国・九州の主要四島およびそれに付随する島々）及び、南西諸島・小笠原諸島などの諸島嶼から成る島国である。	countries
捏巴爾	ねぱーる	通称ネパールは、南アジアの共和制国家。2008年に王制廃止。	countries
諾	ノルウェー	北ヨーロッパのスカンディナビア半島西岸に位置する立憲君主制国家である。	countries
比律賓	ふぃりぴん	東南アジアに位置する共和制国家である。島国であり、フィリピン海を挟んで日本、ルソン海峡を挟んで台湾地区、スールー海を挟んでマレーシア、セレベス海を挟んでインドネシア、南シナ海を挟んでベトナムと対する。比、菲と略される。	countries
菲律賓	ふぃりぴん	東南アジアに位置する共和制国家である。島国であり、フィリピン海を挟んで日本、ルソン海峡を挟んで台湾地区、スールー海を挟んでマレーシア、セレベス海を挟んでインドネシア、南シナ海を挟んでベトナムと対する。比、菲と略される。	countries
仏国	ふっこく	仏（佛）と略されることが多い。フランスの日本での略称のひとつ。	countries
勃牙利	ぶるがりあ	通称ブルガリアは、東ヨーロッパの共和制国家である。 バルカン半島に位置し、北にルーマニア、西にセルビア、マケドニア共和国、南にギリシャ、トルコと隣接し、東は黒海に面している。首都はソフィア。	countries
伯剌西爾	ぶらじる	伯と略される。通称ブラジルは、南アメリカに位置する連邦共和制国家である。	countries
米国	べいこく	通称アメリカ、50の州及び連邦区から成る連邦共和国である。	countries
白耳義	べるぎー	白と略される。西ヨーロッパに位置する連邦立憲君主制国家。隣国のオランダ、ルクセンブルクと合わせてベネルクスと呼ばれる。	countries
波蘭	ぽーらんど	波と略記される。通称ポーランドは、中央ヨーロッパに位置する共和制国家。	countries
葡萄牙	ぽるとがる	葡と略される。通称ポルトガルは、西ヨーロッパのイベリア半島に位置する共和制国家である。	countries
馬来西亜	まれいしあ	馬と略す。東南アジアのマレー半島南部とボルネオ島北部を領域とする連邦立憲君主制国家で、イギリス連邦加盟国である。	countries
墨西哥	めきしこ	略して墨。通称メキシコは、北アメリカ南部に位置する連邦共和制国家である。	countries
蒙古	もうこ	モンゴル高原に居住する遊牧民や、彼らが居住する地域についての自称モンゴルに対する、中国語による音写の一種。鎌倉時代では、「もうこ」と共に「むくり」や「むこ」などとも呼んでいた。	countries
羅馬尼亜	るーまにあ	ルーマニアは、東ヨーロッパに位置する共和制国家。	countries
露西亜	ろしあ	略称は露。ロシアはユーラシア大陸北部の国である	countries
魯西亜	ろしあ	略称は露。ロシアはユーラシア大陸北部の国である	countries
露西亞	ろしあ	略称は露。ロシアはユーラシア大陸北部の国である	countries
蜘蛛巣城	くものすじょう	1957年1月15日公開の日本映画である。東宝製作・配給。監督は黒澤明、主演は三船敏郎。	eiga
関東地方	かんとうちほう	本州の東部に位置している。その範囲について法律上の明確な定義はないが、一般的には茨城県、栃木県、群馬県、埼玉県、千葉県、東京都、神奈川県の1都6県を指して関東地方と呼ぶ。	eight-regions
九州	きゅうしゅう	日本列島を構成する島の一つで、その南西部に位置する。	eight-regions
近畿地方	きんきちほう	本州中西部に位置する日本の地域である。かつての畿内とその周辺地域から構成される。難波宮や飛鳥から平安京までの王城の地で、現在は関東地方に次ぐ日本第二の都市圏・経済圏であり、西日本の中核である。	eight-regions
四国	しこく	日本列島を構成する島の一つである。	eight-regions
八地方区分	ちほうくぶん	日本の分	eight-regions
中国地方	ちゅうごくちほう	本州の西部に位置する。	eight-regions
中部地方	ちゅうぶちほう	本州中部の総称である。	eight-regions
東北地方	とうほくちほう	本州東北部に位置している。	eight-regions
北海道地方	ほっかいどうちほう	日本の北島	eight-regions
雷電	らいでん	声：堀内賢雄。本名はジャック。	mgs
御柱祭	おんばしらまつり	諏訪大社の祭礼。申 (さる) 年と寅 (とら) 年の春、依り代となる御柱を山中から曳 (ひ) き出し、上社の本宮・前宮と下社の春宮・秋宮それぞれの四隅に建てる。おんばしら。みはしらさい。	events
第二次世界大戦	だいにじせかいたいせん	英語: World War II1939年から1945年までの6年間、ドイツ、日本、およびイタリアの三国同盟を中心とする枢軸国陣営と、イギリス、フランス、ソビエト連邦、アメリカ、および中華民国などの連合国陣営との間で戦われた全世界的規模の巨大戦争。1939年9月のドイツ軍によるポーランド侵攻と続くソ連軍による侵攻、仏英による対独宣戦布告とともにヨーロッパ戦争として始まり、その後1941年12月の日本と米英との開戦によって、戦火は文字通り全世界に拡大し、人類史上最大の大戦争となった。	events
平治の乱	へいじのらん	平安時代末期の平治元年12月9日（1160年1月19日）、院近臣らの対立により発生した政変である。	events
保元の乱	ほうげんのらん	平安時代末期の保元元年（1156年）7月に皇位継承問題や摂関家の内紛により朝廷が後白河天皇方と崇徳上皇方に分裂し、双方の武力衝突に至った政変である。	events
本能寺の変	ほんのうじのへん	（1582年6月21日）明智光秀が謀反を起こして京都の本能寺に宿泊していた主君織田信長を襲撃した事件である。	events
明治維新	めいじいしん	江戸幕府に対する倒幕運動から、明治政府による天皇親政体制の転換とそれに伴う一連の改革をいう。その範囲は、中央官制・法制・宮廷・身分制・地方行政・金融・流通・産業・経済・文化・教育・外交・宗教・思想政策など多岐に及んでいるため、どこまでが明治維新に含まれるのかは必ずしも明確ではない。	events
赤福餅	あかふくもち	三重県伊勢市の和菓子屋赤福の和菓子商品である。	food
浅漬け	あさづけ	短時日漬けること。また、漬けた物。大根・なす・きゅうりなどを塩やぬかで漬け、生漬け・早漬け・一夜漬けなどともいう。	food
亜麻仁	あまに	linfrön	food
磯辺巻	いそべまき	のりを巻いた料理。ゆでたほうれんそう・やまのいも・しそなどの野菜、肉類などを巻く。風味を添え、食べやすくする。	food
恵方巻	えほうまき	節分に食べると縁起が良いとされている「太巻き（巻き寿司）」、および、大阪地方を中心として行われているその太巻きを食べる習慣。	food
御好み焼き	おこのみやき	小麦粉の生地 (きじ) とイカ・豚肉・キャベツなどの具材を焼き、ソース・青海苔 (あおのり) などで味付けした料理。	food
河童巻	かっぱまき	キュウリを芯にした細いのり巻き。	food
昆布ポン酢	こんぶぽんず	昆布だしと柑橘果汁が見事にマッチした味付けぽん酢です。	food
鋤焼き	すきやき	牛肉を豆腐やネギなどと一緒にたれで煮焼きしながら食する鍋料理。	food
寿司	すし	酢で調味した飯に、生、または塩や酢をふりかけた魚などの具を配した料理。握りずし・散らしずし・蒸しずしなど。酢は暑さに耐えるので夏の食品とされた。	food
鮨	すし	酢で調味した飯に、生、または塩や酢をふりかけた魚などの具を配した料理。握りずし・散らしずし・蒸しずしなど。酢は暑さに耐えるので夏の食品とされた。	food
鮓	すし	酢で調味した飯に、生、または塩や酢をふりかけた魚などの具を配した料理。握りずし・散らしずし・蒸しずしなど。酢は暑さに耐えるので夏の食品とされた。	food
ちゃんこ鍋	ちゃんこなべ	大鍋に季節の野菜や魚・鶏肉などを入れて煮立て、つけ汁やポン酢で食べる力士料理。	food
氷見饂飩	ひみうどん	富山県氷見市周辺の郷土料理である。	food
べったら漬け	べったらづけ	短時日漬けること。また、漬けた物。大根・なす・きゅうりなどを塩やぬかで漬け、生漬け・早漬け・一夜漬けなどともいう。	food
饅頭	まんじゅう	小麦粉などの粉をこねた皮であんを包み、蒸すか焼くかしてつくった菓子。そばまんじゅう・酒まんじゅうなど種類が多い。中国で諸葛孔明 (しょかつこうめい) が創始したと伝えられ、日本では、14世紀に宋から渡来した林浄因がつくった奈良饅頭に始まるとされる。	food
万十	まんじゅう	小麦粉などの粉をこねた皮であんを包み、蒸すか焼くかしてつくった菓子。そばまんじゅう・酒まんじゅうなど種類が多い。中国で諸葛孔明 (しょかつこうめい) が創始したと伝えられ、日本では、14世紀に宋から渡来した林浄因がつくった奈良饅頭に始まるとされる。	food
万頭	まんじゅう	小麦粉などの粉をこねた皮であんを包み、蒸すか焼くかしてつくった菓子。そばまんじゅう・酒まんじゅうなど種類が多い。中国で諸葛孔明 (しょかつこうめい) が創始したと伝えられ、日本では、14世紀に宋から渡来した林浄因がつくった奈良饅頭に始まるとされる。	food
曼頭	まんじゅう	小麦粉などの粉をこねた皮であんを包み、蒸すか焼くかしてつくった菓子。そばまんじゅう・酒まんじゅうなど種類が多い。中国で諸葛孔明 (しょかつこうめい) が創始したと伝えられ、日本では、14世紀に宋から渡来した林浄因がつくった奈良饅頭に始まるとされる。	food
もんじゃ焼き	もんじゃやき	お好み焼きに似た食べ物。ゆるく溶いた小麦粉で鉄板に文字を書いて楽しんだりしたところから、「文字焼 (もんじや) き」の音変化という。	food
焼餅	やきもち	あぶり焼いた餅の事。餅を参照。	food
焼蕎麦	やきそば	麺を豚肉等の肉類、キャベツ、人参、玉ねぎ、もやし等の野菜、イカ等の魚介類などと共に炒め（具を入れない場合もある）、調味して作る麺料理。ウスターソースを使用した焼きそばは、日本では普及している。	food
石塚路志人	いしづか・みちしと	株式会社ウエストン ビット エンタテインメントが1985年に設立。	game-designers
袈裟固	けさがため	固技の抑込技7本の一つ。レスリングでも同様の体勢があるため同じ用語が使われることもある。	judo-waza
大場規勝	おおばのりよし	東京都出身のゲームプランナー、ディレクター、プロデューサー。1987年セガ・エンタープライゼス（後の『セガゲームス』）に入社し、プランナーとして、セガのコンシューマゲームソフトウェアの開発に従事。数々の名作を生み出す。	game-designers
古代祐三	こしろ・ゆうぞう	主にコンピュータゲームの音楽を手がける作曲家、ゲームプロデューサー。株式会社エインシャント代表取締役社長。株式会社JAGMO名誉会長。東京都日野市出身、日本大学櫻丘高等学校卒。	game-designers
新川洋司	しんかわ・ようじ	イラストレーター・アートディレクター。広島県出身。既婚。あだ名は「新ちゃん」。	game-designers
西澤龍一	にしざわりゅういち	株式会社ウエストン ビット エンタテインメントが1985年に設立。代表作「忍者くん〜魔城の冒険〜」、「WonderBoy」、「MonsterWorldシリーズ」など。	game-designers
四井浩一	よついこういち	あだ名は「伊助」。大阪府出身。ストライダー飛竜でメインイラストは本作の企画を担当した。代表作「キャノンダンサー」、「落シ刑事 〜刑事さん、私がやりました〜 」、「ノスタルジア1907」、「鈴木爆発」、「チャタンヤラクーシャンク」など。	game-designers
観音	かんのん・观音・觀音・guānyīn	仏教の菩薩の一尊であり、北伝仏教、特に日本や中国において古代より広く信仰を集めている尊格である。「観世音菩薩」（かんぜおんぼさつ）ともいう。	hotoke
観世音菩薩	かんぜおんぼさつ・观世音菩萨・觀世音菩薩・Guānshìyīnpúsà	観音と同じ。	hotoke
軍荼利明王	ぐんだりみょうおう	密教において宝生如来の教輪転身とされ、様々な障碍を除くとされ、五大明王の一尊としては南方に配される。	hotoke
五大明王	ごだいみょうおう	仏教における信仰対象であり、密教特有の尊格である明王のうち、中心的役割を担う5名の明王を組み合わせたものである。	hotoke
不動明王	ふどうみょうおう	仏教の信仰対象であり、密教特有の尊格である明王の一尊。シヴァ神の化身とも言われる。また、五大明王の中心となる明王でもある。	hotoke
飛鳥	あすか	592-710年	jidai
安土桃山	あずちももやま	1573-1603年	jidai
織豊	あずちももやま	1573-1603年(安土桃山時代と同じだ。)	jidai
江戸	えど	1603-1868年	jidai
鎌倉	かまくら	1185-1333年	jidai
建武の新政	けんむのしんせい	1333-36年	jidai
古墳	こふん	3世紀中頃-592年	jidai
縄文	じょうもん	前14000年頃-前3世紀頃	jidai
戦国	せんごく	1467-1590年	jidai
奈良	なら	710-794年	jidai
南北朝	なんぼくちょう	1336-92年	jidai
幕末	ばくまつ	1853-68年	jidai
平安	へいあん	794-1185年	jidai
室町	むろまち	1336-1573年	jidai
弥生	やよい	前3世紀頃-3世紀中頃	jidai
連合国軍占領下	れんごうこくぐんせんりょうか	1945-52年	jidai
一本背負投	いっぽんせおいなげ	投技で手技16本の一つ。前もしくは右（左）前隅に崩しながら、前回りさばきで相手の懐に踏み込む、または、後ろ回りさばきで相手の懐に入って、体を沈め、右（左）腕、すなわち、釣り手で、相手の右肩をつかむか挟むことで固定し、受けの体を背負い上げて、引き手で引いて投げる技。	judo-waza
浮落	うきおとし	投技の一つである。手技15本の一つ。突っ込んで来た相手を、膝を沈めながら、自分の前を通過させる（曲げた足の上を飛び越させる）様に投げる技。	judo-waza
浮腰	うきごし	投技の一つである。腰技11本の一つ。軽く踏み込み、釣り手を脇の下に腕を入れ、その動きに合わせて、後回りさばきで足を引く様に回転し、引き手で袖を引きながら、（腰には乗せず、）腰の回転で投げる技。	judo-waza
後腰	うしろごし	投技の一つ。自然体で相手の背後から左手で腰を抱きかかえ、右手で引きつけ持ち上げた上でたたき落とす難易度の高い技である。	judo-waza
内股	うちまた	投技の足技の一つ。ただし、分類の詳細については歴史の項を参照のこと。	judo-waza
移腰	うつりごし	投技の一つである。腰技11本の一つ。釣込腰や払腰、跳腰といった相手に背を向けて投げる技に対する返し技である。お互いが右組である場合、相手（受）がこれらの技を仕掛けてきた時、自分（取）は相手の技を右にかわしながら膝を曲げながら左手で帯をつかむ。	judo-waza
大内刈	おおうちがり	投げ技の足技21本の一つ。自分の足の外側で相手の足の内側を刈る技。	judo-waza
大腰	おおごし	腰技の一つ。大きく踏み込み、その動きに合わせて、前回りさばきで相手を前に崩し、釣り手を脇の下から腰にまわし、腰を深く入れ（腰に乗せ）、腰を上げて持ち上げる（転がす）ようにして投げる技。	judo-waza
大外刈	おおそとがり	投技の足技21本の一つ。 背負投、内股、巴投と並び、柔道でよく用いられる技である。	judo-waza
大外刈り	おおそとがり	投技の足技21本の一つ。 背負投、内股、巴投と並び、柔道でよく用いられる技である。	judo-waza
送足払	おくりあしばらい	投げ技の足技の一つ。ウラジミール・プーチンの得意技である。相手を横に引きずりながら、足を払って投げる技。	judo-waza
帯落	おびおとし	投技の一つである。手技15本の一つ。右組の場合、自分（取）は右手で相手（受）の前帯を取り引きつける。	judo-waza
踵返	きびすがえし	投げ技の手技の一つ。体を低めながら、片手で相手の踵を内側（もしくは外側）からとって刈り倒す技。	judo-waza
空気投げ	くうきなげ	隅落と同じだ。	judo-waza
朽木倒	くちきたおし	手技の一つ。「取りが片手で受けの片足を刈り、倒す技」が技の起点となる。色々な変化形があり、横に巻き込んで投げ技に転ずるものから、ただ真後ろに倒していくものまである。	judo-waza
小内返	こうちがえし	投技の一つである。手技15本の一つ。相手の小内刈をかわし（すかして）浮落の要領で左もしくは右側にひねって返す技である。	judo-waza
小外刈り	こそとがり	投げ技の足技21本の一つ。自分の足の内側で相手の足の外側を刈る技。	judo-waza
小外掛け	こそとがけ	相手を追い込み、体の後ろ側に足をかけて倒す技です。	judo-waza
支釣込足	ささえつりこみあし	投げ技。足技21本の一つに数えられている。	judo-waza
支え釣り込み腰	ささえつりこみあし	投げ技。足技21本の一つに数えられている。	judo-waza
掬投	すくいなげ	手技の一つ。柔道では掬投と呼ばれる技が二種類あり、それぞれ技の動きは全く違う。	judo-waza
捨身技	すてみわざ	投技の分類の一つ。自ら倒れ込みながら(『体(たい)を捨てる』、という）、その勢いを使って投げる技。	judo-waza
隅落	すみおとし	投げ技の手技16本の一つ。突っ込んで来た相手（相手が踏み込んで来たところ）を自分も踏み込み、隅に投げ落とす技。	judo-waza
背負い投げ	せおいなげ	投技の手技16本の一つ。内股、大外刈、巴投と並んで、柔道の投げ技の定番である。	judo-waza
袖釣込腰	そでつりこみごし	投げ技の腰技16本の一つ。右組の場合、引き手（袖を持った左手）は釣り手側に袖を釣り上げ、釣り手（襟を持った右手）で相手の体前方に崩し、左前回りさばきで踏み込んで体を沈め、肩越しに投げる。	judo-waza
体落	たいおとし	投げ技の手技16本の一つ。後ろ回りさばきで相手を右（左）前すみに崩し、右（左）足を踏み出して相手の出足を止め（自分の足を伸ばして、引っ掛け）、そこを支点にして飛び越させる様に、引き手と押し手（釣り手）をきかせて前方に投げ落とす技。	judo-waza
燕返	つばめがえし	投げ技の足技21本の一つ。受けが足払い系の技（出足払、送足払、払釣込足、支釣込足）又は、小外系の技（小外刈、小外掛）をかけてきたとき、その払ってきた足をすかし、その力を利用して投げる技。	judo-waza
巴投	ともえなげ	真捨身技の一つ。	judo-waza
跳腰返	はねごしがえし	投技の一つである。足技21本の一つ。跳腰に対する返し技である。	judo-waza
払腰	はらいごし	腰技の一つ。相手を腰に乗せ、後ろに足を払って、相手を横に泳がせる様に投げる技。	judo-waza
引込返	ひきこみがえし	投技で真捨身技5本の一つ。現行のルールで引込返とされる技は以下の二つがある。	judo-waza
膝車	ひざぐるま	投げ技の足技21本の一つ。	judo-waza
双手刈	もろてがり	投げ技の手技16本の一つ。現代仮名遣いを用い双手刈りとも表記される。	judo-waza
脇固め	わきがため	基本的には肘を極める技であり、寝技、立ち関節技で使用される。	judo-waza
腋固め	わきがため	基本的には肘を極める技であり、寝技、立ち関節技で使用される。	judo-waza
青木真也	あおき・しんや	総合格闘家、柔術家。静岡県静岡市出身。ブラジリアン柔術黒帯。現ONE世界ライト級王者。元DREAMライト級王者。	kakutougi
久保田玲奈	くぼた・れな	RENA。女子シュートボクサー、女子格闘家。大阪府大阪市出身。	kakutougi
五味隆典	ごみ・たかのり	総合格闘家。神奈川県愛甲郡愛川町出身。久我山ラスカルジム主宰。元PRIDEライト級王者。元修斗世界ウェルター級王者。	kakutougi
榊原信行	さかきばら・のぶゆき	実業家。愛知県半田市出身。元ドリームステージエンターテインメント (DSE) 代表取締役で、株式会社うぼん、株式会社沖縄ドリームファクトリー代表取締役。	kakutougi
桜庭和志	さくらば・かずし	プロレスラー、総合格闘家。秋田県南秋田郡昭和町出身。新聞などでは常用漢字外の文字の使用には制約があるため、桜庭和志と表記されることが多く、著書などでも桜庭の表記が一般的である。	kakutougi
高田延彦	たかだ・のぶひこ	元プロレスラー、総合格闘家、タレント、俳優、実業家。本名・旧リングネーム：髙田 伸彦（読みは同じ）。神奈川県横浜市出身。	kakutougi
田中宏茂	たなか・ひろしげ	福岡県出身。シューティングジム横浜所属。あだ名は「半蔵」	kakutougi
三上アスカ	みかみ・あすか	アウトサイダー出場時の名は「渋谷莉孔」。125Lb。	kakutougi
天照大神	あまてらすおおみかみ	天岩戸の神隠れで有名であり、記紀によれば太陽を神格化した神であり、皇室の祖神（皇祖神）の一柱とされる。信仰の対象、土地の祭神とされる場所は伊勢神宮が特に有名。天照大神 ＞ 月夜見 ＞ 須佐男。	kami
恵比寿	えびす	イザナミ・イザナギの間に生まれた子供を祀ったもので古くは大漁追福の漁業の神である。時代と共に福の神として商売繁盛や五穀豊穣をもたらす神となった。唯一日本由来の神である。	kami
七福神	しちふくじん	福をもたらすとして日本で信仰されている七柱の神である。	kami
須佐之男命	すさのおのみこと	嵐と暴風雨の神。天照大神や月夜見の弟神である。天照大神 ＞ 月夜見 ＞ 須佐男。	kami
須佐男の男命	すさのおのみこと	嵐と暴風雨の神。天照大神や月夜見の弟神である。天照大神 ＞ 月夜見 ＞ 須佐男。	kami
大黒天	だいこくてん	大黒柱と現されるように食物・財福を司る神となった。インドのヒンドゥー教のシヴァ神の化身マハーカーラ神。	kami
月夜見	つくよみ	『記紀』においては、伊弉諾尊（いざなぎ）によって生み出されたとされる。月を神格化した、夜を統べる神であると考えられているが、異説もある（後述）。天照大神の弟神にあたり、建速須佐之男命（たけはやすさのお）の兄神にあたる。天照大神 ＞ 月夜見 ＞ 須佐男。	kami
八幡神	はちまんじん	信仰される神で、清和源氏、桓武平氏など全国の武家から武運の神（武神）「弓矢八幡」として崇敬を集めた。	kami
風神	ふうじん	風を司る神。風の精霊、或いは妖怪をそう呼ぶこともある。また対になる存在として、雷神がある。	kami
ソリッドスネーク		声：大塚明夫。本名はデイビッド。ファミリーネームは不明。1972年誕生。「恐るべき子供達計画」により、ビッグ・ボスのクローンとして人工的 に生み出される。母親は計画に携わっていた日本人の女性科学者。そして、二人の精子と卵子を使い、代理母（サロゲート・マザー）となったのがEVA（後のビッグ・ママ） で ある。	mgs
ローズマリー		声：井上喜久子。雷電の恋人。	mgs
清和源氏	せいわげんじ	第56代清和天皇の皇子・諸王を祖とする源氏氏族で、賜姓皇族の一つ。姓（カバネ）は朝臣。	minamoto
源為義	みなもと・の・ためよし	(1096-1156年)平安時代末期の武将。祖父が源義家、父は源義親。叔父の源義忠暗殺後に河内源氏の棟梁と称す。なお父は源義家で、 源義親と義忠は兄にあたるという説もある。保元の乱において崇徳上皇方の主力として戦うが敗北し、後白河天皇方についた長男の源義朝の手で処刑された。	minamoto
源義朝	みなもと・の・よしとも	(1123-1160年2月11日)河内源氏の武将。源為義の長男。頼朝・義経のお父さん。	minamoto
源義経	みなもと・の・よしつね	(1159-1189年6月15日)鎌倉幕府を開いた源頼朝の異母弟。河内源氏の源義朝の九男として生まれ、幼名を牛若丸（うしわかまる）と呼ばれた。	minamoto
韻書	いんしょ	漢字を韻によって分類した書物。元来、詩や詞、曲といった韻文を作る際に押韻可能な字を調べるために用いられたものであるが、音韻は押韻の必要以上に細かく分類されており、字義も記されているので、字書などの辞典のもつ役割も果たした。	mixed-entities
鯉幟	こいのぼり	布または紙で、鯉の形に作ったのぼり。端午の節句に戸外に立てる。鯉の滝のぼりにちなんだもの。	mixed-entities
少林寺拳法	しょうりんじけんぽう	宗道臣が日本で創始した武道である。武術の体系であると同時に「人づくりの行」であり、「護身錬鍛」「精神修養」「健康増進」の三徳を兼ね備える「身心一如」の修行法をとり、「技」と「教え」と「教育システム」を3本の柱としている。技の特徴は、護身を旨とする拳法。教えの中心思想は「自己確立」と「自他共楽」。	mixed-entities
同志社大学	どうししゃだいがく	京都市上京区に本部のある私立大学。明治8年（1875）新島襄が設立した同志社英学校に始まり、大正9年（1920）旧制大学となる。昭和23年（1948）新制大学移行。	mixed-entities
花札	はなふだ	花合わせ1に用いるカルタ。1～12月にそれぞれ松・梅・桜・藤・菖蒲 (あやめ) ・牡丹 (ぼたん) ・萩 (はぎ) ・薄 (すすき) ・菊・紅葉・柳（雨）・桐の12の草木を当てて描き、おのおの4枚ずつに点数・価値を決めて計48枚の札にしたもの。また、これを用いてする遊びをいう。花ガルタ。花。	mixed-entities
阪神	はんしん	野球のチーム。	mixed-entities
百烈拳	ひゃくれつけん	北斗神拳の技。	mixed-entities
任天堂	にんてんどう	日本の企業。ゲーム機ハードウェア、ソフトウェアにおいて総合首位。	mixed-entities
麻雀	まーじゃん	ゲームの一つ。	mixed-entities
三菱グループ	みつびしグループ	かつての三菱財閥の流れを汲む企業を中心とする企業グループである。	mixed-entities
蒙古族	モンゴル族	中華人民共和国の55の少数民族の1つ。	mixed-entities
天台宗	てんだいしゅう	大乗仏教の宗派のひとつである。妙法蓮華経（法華経）を根本経典とするため、天台法華宗とも呼ばれる。天台教学は中国に発祥し、入唐した最澄（伝教大師）によって平安時代初期に日本に伝えられた。	mixed-entities
大和戦艦	やまとせんかん	大日本帝国海軍が建造した史上最大の戦艦で、大和型戦艦の一番艦であった。	mixed-entities
阿佐谷	あさがや	東京都杉並区の地名である。	mixed-locations
阿蘇山	あそさん	九州中央部、熊本県阿蘇地方に位置する活火山で、気象庁による常時観測火山に指定されている。	mixed-locations
荒川	あらかわ	関東平野を流れる川。	mixed-locations
阿波おどり	あわおどり	徳島県（旧・阿波国）を発祥とする盆踊りである。日本三大盆踊りであり、江戸開府より約400年の歴史がある日本の伝統芸能のひとつである。	mixed-locations
嘉手納町	かでなちょう	沖縄県中頭郡の町。極東最大の米軍基地である嘉手納基地を抱える。	mixed-locations
嘉手納基地	かでなきち	沖縄県中頭郡嘉手納町・沖縄市・中頭郡北谷町にまたがるアメリカ空軍の空軍基地。在日アメリカ空軍（第5空軍）の管轄下にある。	mixed-locations
雷門	かみなりもん	浅草寺の山門。正式の名称は、風神雷神門。 提灯には風雷神門と略されてある。	mixed-locations
竹島	たけしま	日本海の南西部に位置する島。主に2つの急峻な岩石でできた島からなる。	mixed-locations
東海道	とうかいどう	五畿七道の一つ。本州太平洋側の中部の行政区分、および同所を通る幹線道路（古代から近世）を指す。	mixed-locations
渚	なぎさ	長野県松本市の市街地の西側の地区（住居表示実施地区、1-4丁目がある。1-3丁目は1966年、4丁目は1985年に設定）。	mixed-locations
渚駅	なぎさえき	岐阜県高山市久々野町渚にある東海旅客鉄道（JR東海）高山本線の駅。	mixed-locations
比叡山	ひえいざん	滋賀県大津市西部と京都府京都市北東部にまたがる山。	mixed-locations
琵琶湖	びわこ	滋賀県にある湖。	mixed-locations
本州	ほんしゅう	日本列島を構成する島の一つで、その南西部に位置する。	mixed-locations
牧野駅	まきのえき	大阪府枚方市牧野阪二丁目にある、京阪電気鉄道京阪本線の駅。	mixed-locations
荒引健	あらびき・たけし	都内のソフトウェアエンジニア。「R言語上級ハンドブック」共著者。@a_bicky。	mixed-persons
市原悦子	いちはら えつこ	女優、声優。ワンダー・プロ所属。夫は舞台演出家の塩見哲。	mixed-persons
大島渚	おおしま・なぎさ	映画監督	mixed-persons
生頼範義	おおらい のりよし	日本のイラストレーター。油絵風の画法が特徴。	mixed-persons
岡潔	おか・きよし	(1901-78年)日本の数学者。奈良女子大学名誉教授。	mixed-persons
加藤浩次	かとう こうじ	お笑い芸人、俳優、司会者、ニュースキャスター。	mixed-persons
金田朋子	かねだ ともこ	日本の女性声優、ナレーター、タレント。	mixed-persons
金丸順司	かねまる・じゅんじ	友のクライマー	mixed-persons
桐谷美玲	きりたに・みれい	日本のファッションモデル、女優、タレント、ニュースキャスター。千葉県出身。	mixed-persons
小林一茶	こばやし いっさ	江戸時代を代表する俳諧師の一人。本名を小林弥太郎。別号は、圯橋・菊明・亜堂・雲外・一茶坊・二六庵・俳諧寺など。	mixed-persons
早乙女太一	さおとめ・たいち	日本の俳優。大衆演劇の劇団、劇団朱雀の2代目。	mixed-persons
酒井忠嗣	さかい ただつぐ	安房勝山藩の第7代藩主。	mixed-persons
紗綾	さあや	日本のグラビアアイドル。	mixed-persons
潮田玲子	しおた・れいこ	日本の元バドミントン選手。	mixed-persons
勺禰子	しゃく・ねこ	歌を詠みます。普段は工芸品や日本文化を取材・発信。	mixed-persons
薛宇孝	せつ・のきたか	友のクライマー。	mixed-persons
斎藤俊	さいとう しゅん	競技麻雀のプロ雀士。上智大学大学院を首席で卒業。日本プロ麻雀協会所属。	mixed-persons
高岡蒼甫	たかおか　そうすけ	日本の俳優。本名非公開。千葉県出身。	mixed-persons
栃乃和歌清隆	とちのわか きよたか	和歌山県海南市出身で、春日野部屋所属の元大相撲力士。	mixed-persons
豊川幸三	とよかわ・こうぞう	ストックホルムの寿司板前。	mixed-persons
中村詔吏	なかむら・	毎日新聞の記者	mixed-persons
廣川智久	ひろかわ・ともひさ	ミティー採用事務局人	mixed-persons
藤岡弘	ふじおか ひろし	日本の剣豪・俳優・タレント・国際武道家。	mixed-persons
藤岡邦弘	ふじおか くにひろ	日本の剣豪・俳優・タレント・国際武道家。	mixed-persons
正嗣	まさし	ぎょうざ専門店。	mixed-persons
町井勲	 まちいいさお	平成の侍	mixed-persons
松宮育子	まつみや・いくこ	眞弓の母。京都市に住む。	mixed-persons
三島由紀夫	みしまゆきお	(1925-70年)小説家・劇作家・評論家・政治活動家・民族主義者	mixed-persons
水野暁	みずの・あきら	レオの息子。	mixed-persons
水野寛	みずの・ひろし	水野さんの主人	mixed-persons
水野眞弓	みずの・まゆみ	<3	mixed-persons
水野玲央	みずの・れおう	眞弓の息子さん。	mixed-persons
水野玲奈	みずの・らな	眞弓の娘さん。	mixed-persons
森福允彦	もりふく まさひこ	福岡ソフトバンクホークスに所属するプロ野球選手（投手）。愛知県豊橋市出身。	mixed-persons
保田圭	やすだ けい	歌手、女優、タレントである。	mixed-persons
山本昌広	やまもと・まさひろ	神奈川県茅ヶ崎市出身の元プロ野球選手（投手）。	mixed-persons
川上裕太朗	ゆうたろう・かわかみ	友？	mixed-persons
吉田龍	よしだ・りょうた	友	mixed-persons
渡辺貞夫	わたなべ・さだお	日本のミュージシャン・作曲家。栃木県宇都宮市出身。	mixed-persons
亘崇詞	わたり・たかし	サッカー選手	mixed-persons
浅田清	あさだきよし	奈良出身。MD。	ncc
重松康之	しげまつ・やすゆき	一番良いな友。MD。	ncc
丹羽透	にわ・とおる	古部市出身。	ncc
松田恭典	まつだ・やすのり	MD。	ncc
岩田聡	いわた・さとし	(1959-2015年)日本のプログラマ、経営者。任天堂元代表取締役社長であり、HAL研究所代表取締役社長なども歴任した。	nintendo-employees
君島達己	きみしま たつみ	任天堂代表取締役社長。	nintendo-employees
竹田玄洋	たけだ げんよう	専務技術フェロー。NINTENDO64、64DD、ニンテンドーゲームキューブ、Wiiの設計開発責任者を担当しているなど、任天堂のハードウェア製作の中核を担う人物の一人だが、アーケード版の『パンチアウト!!』などソフトウェアの開発も行っていた。	nintendo-employees
宮本茂	みやもと・しげる	任天堂専務取締役 クリエイティブフェロー。『スーパーマリオシリーズ』や『ゼルダの伝説シリーズ』、『ドンキーコングシリーズ』の生みの親として知られる。	nintendo-employees
山内積良	やまうち せきりょう	山内房治郎商店2代店主。元任天堂取締役社長の山内溥は孫にあたる。	nintendo-employees
山内溥	やまうち ひろし	(1927-2013年)玩具メーカーの任天堂株式会社代表取締役社長（個人商店の山内房治郎商店より数えて第3代、1949年 - 2002年）、同社取締役相談役（2002年 - 2005年）を経て、晩年まで同社の相談役を担った。任天堂を電子ゲームによって世界的な企業に押し上げた中興の祖として活躍した。	nintendo-employees
山内房治郎	やまうち ふさじろう	任天堂骨牌（山内房治郎商店）初代店主。元任天堂取締役社長である山内溥は曾孫。名前の漢字について、文献によっては山内 房次郎（任天堂製花札のパッケージなど）と記述されている。	nintendo-employees
横井軍平	よこい・ぐんぺい	(1941-97年)日本の技術者。京都府京都市出身。同志社大学工学部電子工学科卒。任天堂開発第一部部長として『ゲーム&ウオッチ』、『ゲームボーイ』、『バーチャルボーイ』等の開発に携わり、宮本茂と並んで任天堂を世界的大企業へと押し上げる原動力となった。	nintendo-employees
田中角栄	たなか・かくえい	(1918-93年)政治家、建築士。新潟県出身。1972年首相に就任。日中国交正常化を実現。首相退任後やロッキード事件による逮捕後も田中派を通じて政界に隠然たる影響力を保ち続けたことから、マスコミからは「闇将軍」の異名を取った。	politicians
愛知県	あいちけん	太平洋に面するの県。県庁所在地は名古屋市。	prefectures
青森県	あおもりけん	本州最北端に位置する。県庁所在地は青森市。県の人口は全国31位、面積は全国8位である。令制国の陸奥国で構成される。	prefectures
秋田県	あきたけん	日本海に面する。県庁所在地は秋田市。	prefectures
石川県	いしかわけん	本州の中央部、日本海側の北陸地方に位置する。 県域は令制国 の加賀国と能登国 に当たる。県庁所在地は金沢市。	prefectures
茨城県	いばらきけん	関東地方の北東に位置し、東は太平洋に面する。県庁所在地は水戸市。都道府県人口は全国11位、面積は全国24位である。	prefectures
岩手県	いわてけん	県庁所在地は盛岡市。	prefectures
愛媛県	えひめけん	四国地方の北西部から北中部に位置する県。県庁所在地は松山市。令制国の伊予国に当たる。	prefectures
大分県	おおいたけん	九州地方東部にある県。県庁所在地は大分市。	prefectures
大阪府	おおさかふ	近畿地方に属する。府庁所在地は大阪市。	prefectures
岡山県	おかやまけん	中国地方南東部に位置する県。県庁所在地は岡山市。	prefectures
沖縄県	おきなわけん	南西部、かつ最西端に位置する県。かつては琉球王国が存在し、清に朝貢すると同時に、薩摩藩にも従っていた。明治時代より日本に編入される。	prefectures
香川県	かがわけん	瀬戸内海に面し四国の北東に位置して、令制国の讃岐国に当たる。県庁所在地は高松市。県名は、讃岐のほぼ中央に存在し、かつて高松が属していた古代以来の郡「香川郡」から取られた。全国一小さい県だが、災害が少なくコンパクトな中に都市の利便性と豊かな自然が調和した生活環境を併せ持つ特徴を有する。	prefectures
鹿児島県	かごしまけん	九州南部に位置する都道府県である。九州島の南側には離島が点在する。県庁所在地は鹿児島市。	prefectures
神奈川県	かながわけん	関東地方の南西端、東京都の南に位置する。県庁所在地は横浜市。	prefectures
京都府	きょうとふ	794年の平安京遷都以来、天皇の御所がある。令制国でいう山城国の全域、丹波国の東部および丹後国の全域を府域とする。府庁所在地は京都市。	prefectures
岐阜県	ぎふけん	内陸県の一つで、日本の人口重心中央[1]に位置し、その地形は変化に富んでいる。県庁所在地は岐阜市。	prefectures
熊本県	くまもとけん	九州地方の中央に位置する県。県庁所在地は熊本市。	prefectures
群馬県	ぐんまけん	関東地方北西部に位置する。県庁所在地は前橋市。県南部に関東平野、県西部・北部に自然豊かな山地を有する。	prefectures
高知県	こうちけん	四国の太平洋側に位置する。県庁所在地は高知市。	prefectures
埼玉県	さいたまけん	関東地方の中央西側内陸部、東京都の北と群馬県の南に位置する県。県庁所在地はさいたま市。	prefectures
佐賀県	さがけん	九州地方の北西部にある県。県庁所在地は佐賀市。	prefectures
滋賀県	しがけん	琵琶湖を擁する、日本国・近畿地方北東部の内陸県である。県庁所在地は大津市。	prefectures
静岡県	しずおかけん	太平洋に面するの県。県庁所在地は静岡市。中部地方及び東海地方に含まれる。2014年（平成26年）現在人口は約370万人で都道府県別で第10位であり、静岡市と浜松市の2つの政令指定都市を有する。	prefectures
島根県	しまねけん	中国地方の日本海側である山陰地方の西部をなす県である。県庁所在地は松江市。	prefectures
千葉県	ちばけん	関東地方の南東側、東京都の東方に位置する県。房総半島と関東平野の南部にまたがる。県庁所在地は千葉市。	prefectures
東京都	とうきょうと	関東地方に位置する広域地方公共団体の一つである。東京特別区、多摩地域、島嶼部を管轄する。都庁所在地は新宿区。	prefectures
徳島県	とくしまけん	四国の東部に位置する。県庁所在地は徳島市。	prefectures
栃木県	とちぎけん	関東地方北部に位置する。県庁所在地は宇都宮市。県内には日光国立公園が立地し、日光・那須などの観光地・リゾート地を有する。	prefectures
鳥取県	とっとりけん	西日本有数の豪雪地帯でもある。全国47都道府県中、面積は7番目に小さく、人口は最も少ない。また、市の数も最も少ない。県庁所在地は県東部の鳥取市。	prefectures
富山県	とやまけん	北陸地方に属し、日本海に面する。令制国の越中国に相当する。県庁所在地は富山市。	prefectures
長崎県	ながさきけん	九州西端部にある県。県庁所在地は長崎市。	prefectures
長野県	ながのけん	本州内陸部に位置するの県。令制国名の信濃国に因み「信州」とも呼ばれる。海に面していない、いわゆる内陸県であり、大規模な山岳地があるため可住地面積率は小さい。 県庁所在地は長野市で、善光寺の門前町として発展し、第18回冬季オリンピックの開催地となった自治体である。	prefectures
奈良県	ならけん	本州中西部、紀伊半島内陸部、近畿地方の中南部に位置する県。令制国の大和国の領域を占める。県庁所在地は奈良市。	prefectures
新潟県	にいがたけん	中部地方の日本海側、北陸地方に位置する。県庁所在地は新潟市。	prefectures
兵庫県	ひょうごけん	本州の中西部に位置し、近畿地方に属している。県庁所在地は神戸市。	prefectures
広島県	ひろしまけん	中国地方に位置する都道府県の一つ。瀬戸内海に面する。県庁所在地は広島市。	prefectures
福井県	ふくいけん	日本海や若狭湾に面する。県庁所在地は福井市。	prefectures
福岡県	ふくおかけん	九州地方北部にある県。県庁所在地は福岡市。	prefectures
福島県	ふくしまけん	東北地方の南部に位置する。県庁所在地は福島市。太平洋に面し奥羽山脈の東西にまたがって存在する。	prefectures
北海道	ほっかいどう	北部に位置する島である。また、同島および付随する島を管轄する地方公共団体（道）である。島としての北海道は、日本列島を構成する主要4島の一つである。地方公共団体としての北海道は、47都道府県中、唯一の「道」で、道庁所在地は札幌市である。	prefectures
三重県	みえけん	日本最大の半島である紀伊半島の東側に位置する。県庁所在地は県中部の津市。	prefectures
宮城県	みやぎけん	東北地方に属する。東は太平洋に面し、西は奥羽山脈に接する。県庁所在地は仙台市。	prefectures
宮崎県	みやざきけん	は九州南東部に位置する県。県庁所在地は宮崎市。	prefectures
山形県	やまがたけん	日本海に面する。県庁所在地は山形市。	prefectures
山口県	やまぐちけん	本州最西端に位置する。九州地方との連接点の地域である。県庁所在地は山口市。	prefectures
山梨県	やまなしけん	本州の内陸部に位置するの県。県庁所在地は甲府市。令制国の甲斐国に相当する。	prefectures
和歌山県	わかやまけん	県庁所在地は和歌山市。日本最大の半島である紀伊半島の西側に位置する。県南部には大規模な山地を有する。	prefectures
伊賀国	いがのくに	東海道に属する。	provinces
伊勢国	いせのくに	東海道に属する。	provinces
近江国	おうみのくに	東山道に属する。	provinces
尾張国	おわりのくに	東海道に属する。	provinces
薩摩藩	さつまはん	江戸時代に薩摩・大隅の2か国及び日向国諸県郡の大部分を領有し、琉球王国を支配下に置いた藩。	provinces
駿河国	するがのくに	東海道に属する。現在の静岡県部	provinces
但馬国	たじまのくに	山陰道に属する。	provinces
山城国	やましろのくに	畿内に属する。	provinces
大和国	やまとのくに	畿内に属する。	provinces
令制国	りょうせいこく	日本の律令制に基づいて設置された日本の地方行政区分である。奈良時代から明治初期まで、日本の地理的区分の基本単位だった。	provinces
明智光秀	あけち・みつひで	(1528-82年)戦国時代から安土桃山時代にかけての武将。	rekishi
上杉謙信	うえすぎ・けんしん	(1530-78年)戦国時代の越後国（現在の新潟県上越市）の武将・戦国大名。後世、越後の虎や越後の龍、軍神と称される。	rekishi
上杉氏	うえすぎし	日本の氏族の一つ。元は公家であるが、鎌倉幕府の将軍となった宗尊親王の従者として関東に下向して、武家と化した。丹波国何鹿郡上杉荘（現在の京都府綾部市上杉）が名字の地。	rekishi
織田信長	おだのぶなが	(1534-82年)戦国時代から安土桃山時代にかけての武将・戦国大名。三英傑の一人。	rekishi
片桐且元	かたぎり かつもと	(1556-1615年)戦国時代から江戸時代初期にかけての武将、大名。	rekishi
河内源氏	かわちげんじ	河内国（現在の大阪府の一部）に根拠地を置いた清和源氏の一流。一般的に武士で「源氏」という場合、この系統を指す。	rekishi
平清盛	たいら・の・きよもり	(1118-1181年)平安時代末期の武将・公卿。伊勢平氏の棟梁・平忠盛の長男として生まれ、平氏棟梁となる	rekishi
平忠正	たいら・の・ただまさ	(不詳-1156年)平安時代末期の伊勢平氏の武将。平正盛の子、忠盛の弟。平清盛の叔父にあたる。	rekishi
武田氏	たけだし	平安時代末から戦国時代の武家。本姓は源氏。家系は清和源氏の一流・河内源氏の一門、源義光を始祖とする甲斐源氏の宗家である。	rekishi
徳川家康	とくがわ・いえやす	(1543-1616年)戦国時代から安土桃山時代にかけての武将・戦国大名。江戸幕府の初代征夷大将軍。三英傑の一人で海道一の弓取りの異名を持つ。	rekishi
豊臣秀吉	とよとみ・ひでよし	(1537-1598年)戦国時代から安土桃山時代にかけての武将、大名、天下人、関白、太閤。三英傑の一人。	rekishi
服部半蔵	はっとり はんぞう	戦国時代から江戸時代初期にかけて松平氏から徳川氏の麾下で活躍した者を指す。	rekishi
卑弥呼	ひみこ	(生年不明：247年あるいは248年頃)『魏志倭人伝』等の中国の史書に記されている倭国の王（女王）。	rekishi
藤原忠実	ふじわら・の・ただざね	(1078-1162)平安時代後期から末期の公卿。藤原師通の長男。日記『殿暦』を残す。	rekishi
藤原忠通	ふじわら・の・ただみち	(1097-1164)摂政関白太政大臣藤原忠実の長男	rekishi
藤原頼長	ふじわら・の・よりなが	(1120-1156)平安時代末期の公卿。兄の関白・藤原忠通と対立し、父・藤原忠実の後押しにより藤原氏長者・内覧として旧儀復興・ 綱紀粛正に取り組んだが、その苛烈で妥協を知らない性格により悪左府（あくさふ）の異名を取った	rekishi
弁慶	べんけい	(生年不詳-1189年6月15日)武蔵坊弁慶。平安時代末期の僧衆（僧兵）。源義経の郎党。	rekishi
毛利氏	もうりし	日本の武家で、本姓は大江氏。家紋は一文字に三つ星。	rekishi
漆原裕治	うるしはらゆうじ	ハルタの営業マン。TBS『SASUKE』の3人目の完全制覇者であるとともに、唯一2回制覇している。身長163cm、体重53kg。東京都出身。チームUnlimited Clifer所属。	sasuke
阿蘇神社	あそじんじゃ	熊本県阿蘇市にある神社。式内社（名神大社）、肥後国一宮。旧社格は官幣大社で、現在は神社本庁の別表神社。	shrines
伊勢神宮	いせじんぐう	三重県伊勢市にある神社。正式名称は地名の付かない「神宮」（じんぐう）。	shrines
厳島神社	いつくしまじんじゃ	広島県廿日市市の厳島（宮島）にある神社。式内社（名神大社）、安芸国一宮。旧社格は官幣中社で、現在は神社本庁の別表神社。	shrines
稲荷神社	いなりじんじゃ	1 稲荷神を祀る神社。⇒ 稲荷神 2. 日本各地に鎮座する神社。	shrines
宇佐神宮	うさじんぐう	大分県宇佐市にある神社。式内社（名神大社3社）、豊前国一、勅祭社。旧社格は官幣大社で、現在は神社本庁の別表神社。	shrines
椿大神社	つばきおおかみやしろ	三重県鈴鹿市にある神社。式内社、伊勢国一宮。	shrines
都波岐神社	つばきじんじゃ	三重県鈴鹿市にある神社。両社とも式内社で、旧社格は県社。都波岐神社は伊勢国一宮とされる。	shrines
鶴岡八幡宮	つるがおかはちまんぐう	神奈川県鎌倉市にある神社。旧社格は国幣中社で、現在は神社本庁の別表神社。	shrines
諏訪大社	すわたいしゃ	長野県の諏訪湖周辺4ヶ所にある神社。式内社（名神大社）、信濃国一宮。旧社格は官幣大社で、現在は神社本庁の別表神社。神紋は「梶の葉」。	shrines
八幡宮	はちまんぐう	八幡神を祭神とする神社。八幡神社、八幡社、八幡さまとも表記・呼称される。全国に約44,000社あり、大分県宇佐市の宇佐神宮を総本社とする。	shrines
平安神宮	へいあんじんぐう	京都府京都市左京区にある神社である。旧社格は官幣大社、勅祭社。現在は神社本庁の別表神社。	shrines
日光東照宮	にっこうとうしょうぐう	日本の関東地方北部、栃木県日光市に所在する神社。江戸幕府初代将軍・徳川家康を神格化した東照大権現（とうしょうだいごんげん）を祀る。	shrines
宗像大社	むなかたたいしゃ	福岡県宗像市にある神社。式内社（名神大社）で、旧社格は官幣大社。日本各地に七千余ある宗像神社、厳島神社、および宗像三女神を祀る神社の総本社である。祭祀の国宝を多数有し、全国の弁天様の総本宮ともいえる。裏伊勢と称される。	shrines
豪鬼	ごうき	カプコンの対戦型格闘ゲーム『ストリートファイター』シリーズに登場する架空の人物。	street-fighter
剛拳	ごうけん	『スーパーストリートファイターII X』からキャラクター設定が存在し、各種メディアミックスでも何度か描かれていた。『ストリートファイターIV』においてゲーム本編に初登場。	street-fighter
疾風迅雷脚	しっぷうじんらいきゃく	shippu/3s Ken SA3	street-fighter
延暦寺	えんりゃくじ	滋賀県大津市坂本本町にあり、標高848mの比叡山全域を境内とする寺院。比叡山、または叡山（えいざん）と呼ばれることが多い。平安京（京都）の北にあったので北嶺（ほくれい）とも称された。	temples
柴又帝釈天	しばまたたいしゃくてん	東京都葛飾区柴又七丁目にある日蓮宗の寺院の通称である。正式名称は経栄山 題経寺（きょうえいざん だいきょうじ）である。旧本山は大本山中山法華経寺。親師法縁。なお、「帝釈天」とは本来の意味では仏教の守護神である天部の一つを指すが、日本においてはこの柴又帝釈天を指す場合も多い。	temples
法隆寺	ほうりゅうじ	奈良県生駒郡斑鳩町にある寺院。聖徳宗の総本山である。別名は斑鳩寺（いかるがでら、鵤寺とも）、法隆学問寺など。	temples
本能寺	ほんのうじ	京都府京都市中京区にある、法華宗本門流の大本山。明智光秀が謀反を起こし織田信長を討った「本能寺の変」で知られる。	temples
鳥羽	とば	平安時代後期の第74代天皇：1107年-1123年	tennou
崇徳	すとく	第75代天皇：1123年-1142年	tennou
後白河	ごしらかわ	(1127-1192年)平安時代末期の第77代天皇：1155年-1158年。先代：近衛。時代：二条。	tennou
二条	にじょう	(1143-1165年)第78代天皇：1158-1165年。後白河天皇の第一皇子。母は、大炊御門経実の娘で、源有仁の養女・贈皇太后懿子。先代：後白河。時代：六条 。	tennou
六条	ろくじょう	(1164-1176年)第79代天皇：1165-1168年。先代：二条。次代：高倉。	tennou
高倉	たかくら	(1161-1181年)第80代天皇：1168-1180年。先代：六条。次代：安徳。	tennou
安徳	あんとく	(1178-1185年)第81代天皇：1180-1185年。高倉天皇の第一皇子。母は平清盛の娘の徳子。先代：高倉。次代：後鳥羽。	tennou
後鳥羽	ごとば	(1180-1239年)第82代天皇：1183-1198年。先代：安徳。次代：土御門。	tennou
後醍醐	ごだいご	(1288-1339年)鎌倉時代後期から南北朝時代初期にかけての第96代天皇にして、南朝の初代天皇(1318-39年）。先代：花園。次代：南朝：後村上。北朝：光厳天皇、光明天皇。	tennou
孝明	こうめい	(1831-1867年)江戸時代の第121代天皇：1846-1867年。明治天皇の父に当たる。攘夷実行の条件を付けての承知の意を示した。死因は天然痘と診断されたが、他殺説も存在し議論となっている。陵は、京都府京都市東山区今熊野泉山町の泉涌寺内にある後月輪東山陵に治定されている。先代：仁孝。次代：明治。	tennou
明治	めいじ	(1852-1912年)第122代天皇：1867-1912年。先代：孝明。次代：大正。	tennou
大正	たいしょう	(1879-1926年)第123代天皇：1912-1926年。先代：明治。次代：昭和。	tennou
昭和	しょうわ	(1901-1989年)第124代天皇：1926-1989年。次代：大正。次代：平成。	tennou
平成	へいせい	(1933年-現在)第125代天皇：1989年-現在。次代：昭和	tennou
赤坂見附	あかさかみつけ	いまの千代田区紀尾井町・平河町にあたる地に存在した、江戸城の「江戸城三十六見附」のひとつ、及び現在の赤坂見附の跡地や東京メトロ赤坂見附駅付近一帯を指す地名である。	tokyo-locations
秋葉原	あきはばら	千代田区の秋葉原駅周辺、主として東京都千代田区外神田・神田佐久間町および台東区秋葉原周辺を指す地域名である。	tokyo-locations
浅草	あさくさ	台東区の町名。または、旧東京市浅草区の範囲を指す地域名である。	tokyo-locations
上野	うえの	地形は、上野恩賜公園のある上野山が北区の方面から伸びる上野台地（武蔵野台地の分脈）の先端部分にあたる。	tokyo-locations
御徒町	おかちまち	1964年まで存在した東京都台東区の地域名。現在も御徒町・仲御徒町などの地名が鉄道の駅名として使われるなど、通称として使われている。	tokyo-locations
荻窪駅	おぎくぼえき	杉並区にある、東日本旅客鉄道・東京地下鉄の駅である。	tokyo-locations
亀戸	かめいど	江東区の地名で、城東地域内である。	tokyo-locations
錦糸町	きんしちょう	墨田区の錦糸町駅周辺に発達する地区の通称。ビジネス街、繁華街として栄えている。江東区亀戸周辺と共に錦糸町・亀戸副都心を形成している。	tokyo-locations
銀座	ぎんざ	日本有数の繁華街であり下町の一つでもある。東京屈指の高級な商店街として、日本国外においても戦前よりフジヤマ、ゲイシャ、ミキモト、赤坂などとともに知られる。「銀座」の名は一種のブランドになっており全国各地の商店街には「○○銀座」と呼ばれる所がそこかしこに見受けられる。	tokyo-locations
汐留	しおどめ	港区の地区名・旧町名。現在ではおもに、汐留地区に建設された巨大複合都市“汐留シオサイト(siosite)”を指す。	tokyo-locations
辰巳駅	たつみえき	江東区辰巳一丁目にある、東京地下鉄有楽町線の駅である。	tokyo-locations
築地	つきじ	中央区の地名で、旧京橋区にあたる京橋地域内である。	tokyo-locations
仲御徒町	なかおかちまち	台東区上野五丁目にある	tokyo-locations
東銀座	ひがしぎんざ	中央区銀座四丁目にある、東京都交通局・東京地下鉄の駅である。	tokyo-locations
門前仲町	もんぜんなかちょう	江東区の地名で、旧深川区にあたる深川地域内である。	tokyo-locations
有楽町	ゆうらくちょう	千代田区の町名である。住居表示実施済みで一丁目と二丁目がある。	tokyo-locations
足立区	あだちく	隅田川と荒川に挟まれた地区と、面積の大半を占める荒川以北の地区とに分かれている。	tokyo-wards
荒川区	あらかわく	町名の数は東京特別区内で最も少ない。	tokyo-wards
板橋区	いたばしく	現在ではほぼ全域が市街地になっているが、工業地域もある。	tokyo-wards
江戸川区	えどがわく	最東端の自治体にあたる。	tokyo-wards
大田区	おおたく	最南部に位置する。東部には羽田空港がある。前身は大森区と蒲田区で、区の商業は大森駅と蒲田駅に、区の行政は蒲田駅に集中している。	tokyo-wards
葛飾区	かつしかく	区内には、山田洋次監督の映画『男はつらいよ』シリーズで知られる柴又帝釈天や、江戸期の菖蒲文化を伝える堀切菖蒲園、秋本治の漫画『こちら葛飾区亀有公園前派出所』で有名になった亀有（亀有公園はあるが、公園前に派出所（交番）が設置されていたことはない。最も近い実在の交番は亀有駅北口交番）がある。	tokyo-wards
北区	きたく	。旧武蔵国豊嶋郡。	tokyo-wards
江東区	こうとうく	東部、隅田川と荒川に挟まれた位置にあり、東京湾に面している。	tokyo-wards
品川区	しながわく	1947年（昭和22年）に誕生した区の中で唯一、旧区名がそのまま新区名に採用された。	tokyo-wards
渋谷区	しぶやく	区の成立は1932年で、1962年の住居表示施行後から現在まで32の町名がある。区役所の所在地は、区内宇田川町。	tokyo-wards
新宿区	しんじゅくく	都条例上は、同区が都庁所在地だが、地図などでは便宜上「東京」と表されることになっている。	tokyo-wards
墨田区	すみだく	全国的に有名な東京スカイツリーやアサヒビール本社がある。	tokyo-wards
杉並区	すぎなみく	元来この地域は武蔵国多摩郡であり、江戸時代から明治・大正時代も多摩地域に属していた。地理的に東京区部の扱いになったのは、1929年（昭和4年）の世界恐慌後に東京市に編入されてからである。	tokyo-wards
世田谷区	せたがやく	元来この地域は武蔵国にあり、江戸時代、明治・大正時代も同地域の地方郡に属していた。	tokyo-wards
台東区	たいとうく	東京23区の中央からやや北東寄りに位置する。東側は隅田川に接し、対岸の墨田区との区境となっている。また、区南端で隅田川との合流点付近の神田川に接する。	tokyo-wards
中央区	ちゅうおうく	ほぼ中央に位置する。区内には、日本橋・八重洲・築地・月島・晴海・銀座等といった街がある。	tokyo-wards
千代田区	ちよだく	1947年（昭和22年）3月15日に麹町区と神田区が合併して誕生した[1]。その際、江戸城の別名である「千代田城」にちなんで「千代田区」となった。	tokyo-wards
豊島区	としまく	池袋駅を中心とする副都心を擁し、高級住宅街の目白や、「おばあちゃんの原宿」として知られる巣鴨などがある。	tokyo-wards
中野区	なかのく	中野区は旧東多摩郡の東半にあたる。地形的には武蔵野台地の一角に位置する。区内には、東西に鉄道が数多く通っている。	tokyo-wards
練馬区	ねりまく	板橋区の一部だった旧北豊島郡練馬町・上練馬村・中新井村・石神井村・大泉村の区域が1947年8月1日に分離して発足した。	tokyo-wards
文京区	ぶんきょうく	郵便番号（上3桁）は112の地域と113の地域がある。	tokyo-wards
港区	みなとく	企業が本社を最も多く構える区の一つであり、いわば日本のビジネスの中心である。	tokyo-wards
目黒区	めぐろく	主に住宅地として発展。平均世帯年収は664万円で、東京都中央区（709万円）やさいたま市浦和区（693万円）に次ぐ水準である。	tokyo-wards
小島秀夫	こじまひでお	(1963年8月24日)ゲームデザイナー	writers
伊藤潤二	いとうじゅんじ	(1963年七月)漫画家	writers
\.


--
-- TOC entry 2292 (class 0 OID 16688)
-- Dependencies: 173
-- Data for Name: names_metadata; Type: TABLE DATA; Schema: public; Owner: e
--

COPY names_metadata (table_name, tag, class) FROM stdin;
akutou	悪党・重犯罪捜査班	character
hotoke	仏	character
kami	神々	character
mgs	メタルギアソリッド	character
street-fighter	対戦型格闘ゲーム『ストリートファイター』	character
cha	御茶	entity
eiga	映画	entity
events	事件	entity
food	食べ物	entity
jidai	時代区分の一つ	entity
judo-waza	柔道技	entity
mixed-entities	雑多物	entity
cities	日本の町	location
castles	日本の城	location
chuugoku-chiri	中国地理	location
countries	世界の国	location
mixed-locations	雑多地域名	location
prefectures	日本の都道府県の一つ	location
provinces	日本の令制国の一つ	location
eight-regions	八地方区分	location
shrines	御神社	location
temples	御寺	location
tokyo-locations	東京都地域名	location
tokyo-wards	東京都区部	location
actors	俳優	person
budo	武道家	person
climbers	クライマー	person
game-designers	ゲーム作家	person
kakutougi	格闘技	person
minamoto	源氏の人	person
mixed-persons	雑多人名	person
ncc	国内研究がんセンター	person
nintendo-employees	任天堂会社員	person
politicians	政治家	person
rekishi	歴史の人	person
sasuke	サスケ	person
tennou	日本天皇	person
writers	作家	person
akira	アキラ	character
\.


--
-- TOC entry 2294 (class 0 OID 16944)
-- Dependencies: 175
-- Data for Name: tmp_table; Type: TABLE DATA; Schema: public; Owner: e
--

COPY tmp_table (defs, tags) FROM stdin;
\.


--
-- TOC entry 2177 (class 2606 OID 16692)
-- Name: meta_pkey; Type: CONSTRAINT; Schema: public; Owner: e; Tablespace: 
--

ALTER TABLE ONLY names_metadata
    ADD CONSTRAINT meta_pkey PRIMARY KEY (table_name);


--
-- TOC entry 2179 (class 2606 OID 16729)
-- Name: names_pkey; Type: CONSTRAINT; Schema: public; Owner: e; Tablespace: 
--

ALTER TABLE ONLY names
    ADD CONSTRAINT names_pkey PRIMARY KEY (name);


--
-- TOC entry 2175 (class 2606 OID 16485)
-- Name: 単語発音鍵; Type: CONSTRAINT; Schema: public; Owner: e; Tablespace: 
--

ALTER TABLE ONLY goi
    ADD CONSTRAINT "単語発音鍵" PRIMARY KEY ("単語", "発音");


--
-- TOC entry 2181 (class 2620 OID 16487)
-- Name: impute_missing_pronouncation; Type: TRIGGER; Schema: public; Owner: e
--

CREATE TRIGGER impute_missing_pronouncation BEFORE INSERT ON goi FOR EACH ROW EXECUTE PROCEDURE impute_missing_pronouncation();


--
-- TOC entry 2180 (class 2606 OID 16730)
-- Name: names_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: e
--

ALTER TABLE ONLY names
    ADD CONSTRAINT names_origin_fkey FOREIGN KEY (origin) REFERENCES names_metadata(table_name);


--
-- TOC entry 2302 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: e
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM e;
GRANT ALL ON SCHEMA public TO e;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2016-02-24 09:33:05 CET

--
-- PostgreSQL database dump complete
--

