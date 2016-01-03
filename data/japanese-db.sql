--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.0
-- Started on 2016-01-05 13:58:10 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2291 (class 1262 OID 16441)
-- Dependencies: 2290
-- Name: 日本語; Type: COMMENT; Schema: -; Owner: e
--

COMMENT ON DATABASE "日本語" IS 'DB for japanese language data.';


--
-- TOC entry 175 (class 3079 OID 12123)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2294 (class 0 OID 0)
-- Dependencies: 175
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 532 (class 1247 OID 16509)
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
-- TOC entry 535 (class 1247 OID 16596)
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
-- TOC entry 529 (class 1247 OID 16495)
-- Name: word_tag; Type: TYPE; Schema: public; Owner: e
--

CREATE TYPE word_tag AS ENUM (
    '動物',
    '植物',
    '書体',
    '菌類',
    '形動'
);


ALTER TYPE word_tag OWNER TO e;

--
-- TOC entry 188 (class 1255 OID 16486)
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

--
-- TOC entry 549 (class 1255 OID 16493)
-- Name: array_cat_agg(anyarray); Type: AGGREGATE; Schema: public; Owner: e
--

CREATE AGGREGATE array_cat_agg(anyarray) (
    SFUNC = array_cat,
    STYPE = anyarray
);


ALTER AGGREGATE public.array_cat_agg(anyarray) OWNER TO e;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 172 (class 1259 OID 16478)
-- Name: goi; Type: TABLE; Schema: public; Owner: e; Tablespace: 
--

CREATE TABLE goi (
    "単語" character varying(20) NOT NULL,
    "発音" character varying(30) NOT NULL,
    "和" text[],
    "英" text[],
    tags word_tag[]
);


ALTER TABLE goi OWNER TO e;

--
-- TOC entry 2295 (class 0 OID 0)
-- Dependencies: 172
-- Name: TABLE goi; Type: COMMENT; Schema: public; Owner: e
--

COMMENT ON TABLE goi IS 'Table for Japanese words.
Includes word, pronounciation, and definitions in Japanese and English.
Uses array types for the definition columns.';


--
-- TOC entry 2296 (class 0 OID 0)
-- Dependencies: 172
-- Name: COLUMN goi."和"; Type: COMMENT; Schema: public; Owner: e
--

COMMENT ON COLUMN goi."和" IS '日本語定義達。';


--
-- TOC entry 2297 (class 0 OID 0)
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
-- TOC entry 2283 (class 0 OID 16478)
-- Dependencies: 172
-- Data for Name: goi; Type: TABLE DATA; Schema: public; Owner: e
--

COPY goi ("単語", "発音", "和", "英", tags) FROM stdin;
類語	るいご	{語形は異なっているが、意味の似かよっている二つ以上の語。「家」と「住宅」、「言う」と「話す」などの類。}	{synonym}	\N
類似	るいじ	{}	{analogous}	\N
類推	るいすい	{}	{analogy}	\N
累積	るいせき	{}	{accumulation}	\N
嗚呼	ああ	{}	{"Ah!; Oh!; Alas!"}	\N
相	あい	{}	{"together; mutually; fellow"}	\N
愛	あい	{}	{love}	\N
相変わらず	あいかわらず	{}	{"as ever; as usual; the same"}	\N
愛嬌	あいきょう	{}	{"charm; attrictiveness"}	\N
挨拶	あいさつ	{}	{greeting}	\N
頁	ぺーじ	{"本や新聞など印刷物の構成要素。 ページを参照。"}	{page}	\N
ぺろぺろ	ぺろぺろ	{舌で物をなめまわすさま。}	{"the sound of licking"}	\N
留守番	るすばん	{}	{care-taking;caretaker;house-watching}	\N
留守	るす	{}	{"being away; be out (of one´s home or office)"}	\N
愛情	あいじょう	{}	{"love; affection"}	\N
合図	あいず	{}	{"sign; signal"}	\N
愛する	あいする	{}	{"to love"}	\N
愛想	あいそ	{}	{"civility; courtesy; compliments; sociability; graces"}	\N
相対	あいたい	{}	{"confrontation; facing; between ourselves; no third party; tete-a-tete"}	\N
間柄	あいだがら	{}	{relation(ship)}	\N
相手	あいて	{}	{"companion; partner; company; other party; addressee"}	\N
愛憎	あいにく	{}	{"likes and dislikes"}	\N
合間	あいま	{}	{interval}	\N
曖昧	あいまい	{}	{"vague; ambiguous"}	\N
合う	あう	{}	{"fit; suit; be correct"}	\N
会う	あう	{}	{"to meet; to interview"}	\N
遭う	あう	{}	{"meet; encounter (often something unpleasant)"}	\N
敢えて	あえて	{}	{"dare (to do); challenge (to do)"}	\N
青	あお	{}	{"the color blue; the color green (noun); green light"}	\N
青い	あおい	{}	{"blue; pale; green; unripe; inexperienced"}	\N
扇ぐ	あおぐ	{}	{"to fan; to flap"}	\N
仰ぐ	あおぐ	{}	{"to look up (to); to respect; to depend on; to ask for; to seek; to revere; to drink; to take"}	\N
青白い	あおじろい	{}	{pale}	\N
亜科	あか	{}	{"suborder; subfamily"}	\N
赤	あか	{}	{"the color red (noun)"}	\N
赤い	あかい	{}	{red}	\N
証	あかし	{}	{"proof; evidence"}	\N
赤字	あかじ	{}	{"deficit; go in the red"}	\N
明かす	あかす	{}	{"to pass; spend; to reveal; to divulge"}	\N
赤ちゃん	あかちゃん	{}	{"baby; infant"}	\N
赤らむ	あからむ	{}	{"to become red; to redden; to blush"}	\N
明かり	あかり	{}	{"lamplight; brightness"}	\N
上がり	あがり	{}	{"slope; advance income; crop yield; ascent; rise; advance; death; spinning; completion; stop; finish; after (rain); ex (official etc.); freshly-drawn green tea (esp. in sushi shops)"}	\N
上がる	あがる	{}	{"go up; rise"}	\N
明るい	あかるい	{}	{"bright; cheerful"}	\N
明い	あかるい	{}	{"bright; light; cheerful; sunny"}	\N
赤ん坊	あかんぼう	{}	{baby}	\N
明き	あき	{}	{"room; time to spare; emptiness; vacant"}	\N
秋	あき	{}	{"autumn; fall"}	\N
空き	あき	{}	{"room; time to spare; emptiness; vacant"}	\N
空間	あきま	{}	{"vacancy; room for rent or lease"}	\N
空き家	あきや	{人の住んでいない家。あきいえ。}	{"an unoccupied [a vacant; an uninhabited; an empty] house; a house for rent"}	\N
明らか	あきらか	{}	{"obvious; clear"}	\N
諦め	あきらめ	{}	{"resignation; acceptance; consolation"}	\N
諦める	あきらめる	{}	{"give up; abandon"}	\N
飽きる	あきる	{}	{"get tired of; lose interest in"}	\N
赤色	あかいろ	{}	{red}	\N
銅	あかがね	{}	{copper}	\N
明白	あからさま	{}	{"obvious; overt; plainly; frankly"}	\N
商人	あきうど	{}	{"trader; shopkeeper; merchant"}	\N
悪	あく	{}	{"evil; wickedness"}	\N
握手	あくしゅ	{}	{handshake}	\N
欠伸	あくび	{眠いとき、疲れたときなどに思わず口が大きく開いて息を深く吸い込み、やや短く吐き出す呼吸運動。}	{yawn}	\N
悪日	あくび	{}	{"unlucky day"}	\N
悪党	あくとう	{一般に悪人を意味する語。この場合の悪とは、概ね人道に外れた行いや、それに関連する有害なものを指す概念である。悪人、悪漢、ならず者、ごろつき。}	{⇒あくにん(悪人)}	\N
飽くなき	あくなき	{}	{"ravenous; insatiable; gluttonous"}	\N
悪魔	あくま	{}	{"evil spirit; devil; demon"}	\N
悪魔城	あくまじょう	{}	{"demon castle"}	\N
飽くまで	あくまで	{}	{"to the end; stubbornly; persistently"}	\N
悪夢	あくむ	{いやな恐ろしい夢。また、不吉な夢。「ーにうなされる」}	{"〔悪い夢〕a bad dream; 〔恐ろしい夢〕a nightmare; 〔不吉な夢〕an ominous dream"}	\N
明くる	あくる	{}	{"next; following"}	\N
朱	あけ	{}	{vermillion}	\N
明け方	あけがた	{}	{dawn}	\N
明ける	あける	{}	{"to dawn; become daylight"}	\N
開ける	あける	{}	{"become opened up; be up-to-date; become civilized"}	\N
揚げる	あげる	{揚げ物を作る。「てんぷらを―・げる」}	{"fry (tempura)"}	\N
顎	あご	{}	{chin}	\N
憧れ	あこがれ	{}	{"yearning; longing; aspiration"}	\N
憧れる	あこがれる	{}	{"long for; yearn after; admire; be attracted by"}	\N
朝	あさ	{}	{morning}	\N
麻	あさ	{}	{"flax; linen; hemp"}	\N
浅い	あさい	{}	{"shallow; superficial"}	\N
朝御飯	あさごはん	{}	{breakfast}	\N
朝寝坊	あさねぼう	{}	{"over sleep"}	\N
浅ましい	あさましい	{}	{"wretched; miserable; shameful; mean; despicable; abject"}	\N
欺く	あざむく	{}	{"to deceive"}	\N
あざ笑う	あざわらう	{}	{"to sneer at; to ridicule"}	\N
足	あし	{人・動物のあし。特に、くるぶしから先の部分。}	{"foot; pace; gait; leg"}	\N
脚	あし	{あし。本来は、ひざからくるぶしまでの部分。}	{"(すね) shins"}	\N
肢	あし	{"手と足。 胴体から分かれ出た部分。　あしを指すなら「下肢」。"}	{limb}	\N
味	あじ	{}	{taste}	\N
足跡	あしあと	{}	{footprints}	\N
足指	あしゆび	{足のゆび。そくし。}	{toes}	\N
味わい	あじわい	{}	{"flavour; meaning; significance"}	\N
味わう	あじわう	{}	{"to taste; savor; relish"}	\N
預かる	あずかる	{}	{"take charge of; receive deposit"}	\N
預ける	あずける	{}	{"put in charge of; to deposit"}	\N
汗	あせ	{}	{sweat}	\N
焦る	あせる	{}	{"to be in a hurry; to be impatient"}	\N
彼処	あそこ	{}	{"(uk) there; over there; that place; (X) (col) genitals"}	\N
遊び	あそび	{}	{play}	\N
遊ぶ	あそぶ	{}	{"play; make a visit (esp. for pleasure); be idle; do nothing"}	\N
字	あざ	{}	{"section of village"}	\N
明後日	あさって	{}	{"day after tomorrow"}	\N
明日	あした	{}	{tomorrow}	\N
明日	あす	{}	{tomorrow}	\N
東	あずま	{}	{"east; Eastern Japan"}	\N
値	あたい	{}	{"value; price; cost; worth; merit"}	\N
値する	あたいする	{}	{"to be worth; to deserve; to merit"}	\N
与える	あたえる	{}	{"give; to award"}	\N
暖かい	あたたかい	{"寒すぎもせず、暑すぎもせず、程よい気温である。あったかい。「―・い部屋」「―・い地方」《季 春》「―・きドアの出入となりにけり／万太郎」"}	{"warm; mild; genial"}	\N
温かい	あたたかい	{物が冷たくなく、また熱すぎもせず、程よい状態である。「―・い御飯」}	{〔熱さがちょうどいい〕hot}	\N
暖まる	あたたまる	{}	{"to warm oneself; to sun oneself; to warm up; to get warm"}	\N
暖める	あたためる	{程よい温度に高める。あたたかくする。あっためる。「冷えた手を―・める」「ミルクを―・める」}	{"to warm; to heat"}	\N
あだ名	あだな	{本名とは別に、その人の容姿や性質などの特徴から、他人がつける名。ニックネーム。}	{nickname}	\N
渾名	あだな	{本名とは別に、その人の容姿や性質などの特徴から、他人がつける名。ニックネーム。}	{nickname}	\N
綽名	あだな	{本名とは別に、その人の容姿や性質などの特徴から、他人がつける名。ニックネーム。}	{nickname}	\N
頭	あたま	{}	{head}	\N
新しい	あたらしい	{}	{new}	\N
当たり	あたり	{}	{"hit; success; reaching the mark; per ...; vicinity; neighborhood"}	\N
当たり前	あたりまえ	{}	{"usual; common; ordinary; natural; reasonable; obvious"}	\N
当たる	あたる	{}	{"be hit; be successful; confront; lie (in the direction of); undertake; be equivalent to; be applicable; be assigned"}	\N
彼方	あちら	{}	{"there; yonder; that"}	\N
厚い	あつい	{}	{"thick; deep; cordial; kind; warm(hearted)"}	\N
篤い	あつい	{病気が重い。容体が悪い。「師の病の―・いことを知った」}	{"seriously (ill); critical (condition); fervent (religous beliefs)"}	\N
暑い	あつい	{}	{"hot; warm"}	\N
熱い	あつい	{}	{"hot (thing)"}	\N
悪化	あっか	{}	{"deterioration; growing worse; aggravation; degeneration; corruption"}	\N
扱い	あつかい	{}	{"treatment; service"}	\N
扱う	あつかう	{}	{"to handle; deal with"}	\N
厚かましい	あつかましい	{}	{"impudent; shameless; brazen"}	\N
呆気ない	あっけない	{}	{"not enough; too quick (short long etc.)"}	\N
篤	あつし	{病気で弱っているさま。病気がちである。}	{"sickly-ness; easily become sick;"}	\N
圧縮	あっしゅく	{}	{"compression; condensation; pressure"}	\N
圧倒的	あっとうてき	{他より非常に勝っているさま。「―に強い」「―な支持を得る」}	{overwhelming}	\N
圧迫	あっぱく	{}	{"pressure; coercion; oppression"}	\N
集まり	あつまり	{}	{"gathering; meeting; assembly; collection"}	\N
集まる	あつまる	{}	{gather}	\N
集める	あつめる	{多くの人や物を一つところにまとめる。「聴衆を―・める」「切手を―・める」}	{"〔集合させる〕gather; get ((people; things)) together〔集金する，収集する〕collect〔集中する，引きつける〕attract; draw"}	\N
圧力	あつりょく	{}	{"stress; pressure"}	\N
当て	あて	{}	{"object; aim; end; hopes; expectations"}	\N
宛	あて	{}	{"addressed to"}	\N
当て字	あてじ	{}	{"phonetic-equivalent character; substitute character"}	\N
宛名	あてな	{}	{"address; direction"}	\N
当てはまる	あてはまる	{}	{"to apply (a rule)"}	\N
当てはめる	あてはめる	{}	{"to apply; to adapt"}	\N
当てる	あてる	{}	{"to hit"}	\N
宛てる	あてる	{}	{"to address"}	\N
跡	あと	{}	{"trace; tracks; mark; sign; remains; ruins; scar"}	\N
跡継ぎ	あとつぎ	{}	{"heir; successor"}	\N
後回し	あとまわし	{}	{"putting off; postponing"}	\N
穴	あな	{}	{hole}	\N
貴女	あなた	{}	{"you; lady"}	\N
私	あたし	{}	{"I (fem)"}	\N
他人	あだびと	{}	{"another person; unrelated person; outsider; stranger"}	\N
辺り	あたり	{}	{"neighbourhood; vicinity; nearby"}	\N
彼方此方	あちこち	{}	{"here and there"}	\N
貴方	あなた	{対等または目下の者に対して、丁寧に、または親しみをこめていう。「―の考えを教えてください」}	{"〔主格〕you; 〔所有格〕your; yours; 〔目的格〕you ((単複同形)); 〔夫婦，親しい間の呼び掛け〕(my) dear; darling"}	\N
貴方方	あなた‐がた	{「あなた」の複数形。「あなたたち」よりも、やや敬意が高い。「―はどちらからおいでになりましたか」}	{"you (plural)"}	\N
兄	あに	{}	{"older brother"}	\N
姉	あね	{}	{"older sister"}	\N
暴く	あばく	{}	{"〔他人の秘密などをばらす〕expose; disclose; reveal; bring to light"}	\N
発く	あばく	{}	{"〔他人の秘密などをばらす〕expose; disclose; reveal; bring to light"}	\N
暴れる	あばれる	{}	{"act violently; struggle"}	\N
浴びる	あびる	{}	{"bathe; take a shower; bask in the sun"}	\N
危ない	あぶない	{}	{"dangerous; critical; grave; uncertain; unreliable; limping; narrow; close; watch out!"}	\N
脂	あぶら	{}	{"fat; lard"}	\N
油	あぶら	{}	{oil}	\N
油絵	あぶらえ	{}	{"oil painting"}	\N
溢れる	あふれる	{水などがいっぱいになって外にこぼれる。「コップに―・れるほど注ぐ」「川が―・れる」「涙が―・れる」}	{"水がいっぱいになってこぼれる〕overflow; 〔氾濫する〕flood; be inundated"}	\N
尼	あま	{}	{nun}	\N
甘える	あまえる	{}	{"to behave like a spoiled child; to fawn on"}	\N
雨傘	あまがさ	{雨降りの際にさす傘。}	{"an umbrella⇒かさ(傘)"}	\N
雨具	あまぐ	{}	{"rain gear"}	\N
甘口	あまくち	{比較的甘みの強い、または塩分や辛みをおさえた味加減。また、そのもの。「―の酒」⇔辛口。}	{"sweet flavour; mildness; flattery; stupidity"}	\N
天	あまつ	{}	{"heavenly; imperial"}	\N
雨戸	あまど	{}	{"(sliding) storm door"}	\N
甘やかす	あまやかす	{}	{"pamper; spoil"}	\N
余る	あまる	{}	{"remain; be left over; be too many"}	\N
網	あみ	{}	{"net; network"}	\N
網棚	あみだな	{電車・バスなどの座席の上方に、乗客の携帯品をのせるために設けた網張りの棚。}	{"〔客車内などの〕a rack"}	\N
編物	あみもの	{}	{"knitting; web"}	\N
編む	あむ	{}	{"to knit; to braid; compile (anthology; dictionary; etc.); edit"}	\N
雨	あめ	{}	{rain}	\N
天地	あめつち	{}	{"heaven and earth; the universe; nature; top and bottom; realm; sphere; world"}	\N
危うい	あやうい	{}	{"dangerous; watch out!"}	\N
怪しい	あやしい	{不思議な力がある。神秘的な感じがする。変な。「ー・い魅力」「宝石がー・く光る」}	{"suspicious; doubtful"}	\N
操る	あやつる	{}	{"to manipulate; to operate; to pull strings"}	\N
危ぶむ	あやぶむ	{}	{"to fear; to have misgivings; to be doubtful; to mistrust"}	\N
過ち	あやまち	{}	{"fault; error; indiscretion"}	\N
誤り	あやまり	{}	{error}	\N
謝る	あやまる	{}	{apologize}	\N
誤る	あやまる	{}	{"to make a mistake"}	\N
歩み	あゆみ	{}	{walking}	\N
歩む	あゆむ	{}	{"to walk; to go on foot"}	\N
荒い	あらい	{}	{"rough; rude; wild"}	\N
粗い	あらい	{}	{"coarse; rough"}	\N
洗う	あらう	{}	{"to wash"}	\N
予め	あらかじめ	{}	{"beforehand; in advance; previously"}	\N
荒さ	あらさ	{}	{"roughness; coarseness; abrasiveness"}	\N
嵐	あらし	{}	{storm}	\N
荒らす	あらす	{}	{"to lay waste; to devastate; to damage; to invade; to break into"}	\N
粗筋	あらすじ	{}	{"outline; summary"}	\N
争い	あらそい	{}	{"dispute; strife; quarrel; dissension; conflict; rivalry; contest"}	\N
争う	あらそう	{}	{"argue; dispute"}	\N
新た	あらた	{}	{new}	\N
改まる	あらたまる	{}	{"to be renewed"}	\N
甘い	あまい	{}	{delicious}	\N
改めて	あらためて	{}	{again}	\N
荒っぽい	あらっぽい	{}	{"rough; rude"}	\N
あらゆる	あらゆる	{あるかぎりの。すべての。「ー角度から検討する」}	{"all; every"}	\N
現す	あらわす	{}	{"indicate; show; display"}	\N
著す	あらわす	{}	{"write; publish"}	\N
表す	あらわす	{}	{"express; show; reveal"}	\N
現われ	あらわれ	{}	{"embodiment; materialization"}	\N
現れ	あらわれ	{}	{embodiment}	\N
現われる	あらわれる	{}	{"to appear; to come in sight; to become visible; to come out; to embody; to materialize; to express oneself"}	\N
現れる	あらわれる	{}	{"appear; embody; express oneself"}	\N
有り得ない	ありえない	{あるはずがない。ありそうもない。そうなる可能性がない。「時間が逆に進むことは―◦ない」}	{"i can't believe it!"}	\N
有難い	ありがたい	{}	{"grateful; thankful; welcome; appreciated"}	\N
有難う	ありがとう	{}	{thanks}	\N
有様	ありさま	{}	{"state; condition; circumstances; the way things are or should be; truth"}	\N
有りのまま	ありのまま	{}	{"the truth; fact; as it is; frankly"}	\N
或る	ある	{}	{"a certain; one; some; ある場合には: in some cases"}	\N
有る	ある	{}	{"to be; to have"}	\N
在る	ある	{}	{"to live; to be"}	\N
歩く	あるく	{}	{"to walk"}	\N
主	あるじ	{}	{leader}	\N
彼此	あれこれ	{}	{"one thing or another; this and that; this or that"}	\N
泡	あわ	{}	{"bubble; foam; froth"}	\N
合わす	あわす	{}	{"to join together; to face; to unite; to be opposite; to combine; to connect; to add up; to mix; to match; to overlap; to compare; to check with"}	\N
合わせ	あわせ	{}	{"joint together; opposite; facing"}	\N
合わせる	あわせる	{}	{"join together; connect; unite; combine; add up; mix; match; overlap; be opposite; face; compare; check with"}	\N
慌ただしい	あわただしい	{}	{"busy; hurried; confused; flurried"}	\N
慌てる	あわてる	{}	{"to become confused (disconcerted disorganized)"}	\N
哀れ	あわれ	{}	{"helpless; pathos; pity; sorrow; grief; misery; compassion"}	\N
案	あん	{考え。計画。「―を練る」}	{"plan; suffix meaning draft"}	\N
安易	あんい	{}	{easygoing}	\N
暗雲	あんうん	{真っ黒な雲。今にも雨や雪が降りだしそうな気配のある暗い雲。「―が垂れ込める」}	{"〔暗い雲〕dark clouds"}	\N
案外	あんがい	{}	{unexpectedly}	\N
暗記	あんき	{}	{memorization}	\N
暗殺	あんさつ	{}	{assassination}	\N
暗算	あんざん	{}	{"mental arithmetic"}	\N
暗示	あんじ	{}	{"hint; suggestion"}	\N
案じる	あんじる	{}	{"to be anxious; to ponder"}	\N
安心	あんしん	{}	{"peace of mind; relief"}	\N
安静	あんせい	{}	{rest}	\N
安全	あんぜん	{}	{safety}	\N
案ずる	あんずる	{心配する。思い煩う。気遣う。「―・ずるには及ばない」「将来を―・ずる」}	{"worry; fear"}	\N
安定	あんてい	{}	{"stability; equilibrium"}	\N
案内	あんない	{}	{"information; guidance"}	\N
案の定	あんのじょう	{}	{"sure enough; as usual"}	\N
余り	あんまり	{}	{"not very (this form only used as adverb); not much; remainder; rest; remnant; surplus; balance; excess; remains; scraps; residue; fullness; other; too much"}	\N
狗	いぬ	{食肉目イヌ科の哺乳類。嗅覚・聴覚が鋭く、古くから猟犬・番犬・牧畜犬などとして家畜化。多くの品種がつくられ、大きさや体形、毛色などはさまざま。警察犬・軍用犬・盲導犬・競走犬・愛玩犬など用途は広い。}	{"a dog; 〔雌犬〕a bitch; a she-dog; 〔猟犬〕a hound"}	{動物}
蚊	か	{}	{mosquito}	{動物}
罰	ばち	{}	{"(divine) punishment; curse; retribution"}	\N
兎	う	{}	{rabbit}	{動物}
兔	うさぎ	{}	{rabbit}	{動物}
兎	うさぎ	{}	{rabbit}	{動物}
鰻	うなぎ	{}	{eel}	{動物}
馬	うま	{}	{horse}	{動物}
狼	おおかみ	{}	{wolf}	{動物}
蛙	かえる	{}	{frog}	{動物}
亀	かめ	{}	{"tortoise; turtle"}	{動物}
孔雀	くじゃく	{キジ目キジ科クジャク属の鳥の総称。}	{"〔雄〕a peacock; 〔雌〕a peahen; 〔通称〕a peafowl; 〔ひな〕a peachick"}	{動物}
熊	くま	{}	{bear}	{動物}
鯉	こい	{}	{carp}	{動物}
駒	こま	{}	{pony}	{動物}
場	ば	{}	{"place; (physics) field"}	\N
ば	ば	{口語では活用語の仮定形、文語では活用語の未然形に付く。未成立の事柄を成立したものと仮定する条件を表す。もし…ならば。「暇ができれ―行く」「雨天なら―中止する」}	{if}	\N
場合	ばあい	{物事が行われているときの状態・事情。局面。「―が―だけに慎重な判断が必要だ」「時と―による」「遊んでいる―ではない」}	{"case; occasion"}	\N
倍	ばい	{}	{"double; two times"}	\N
売却	ばいきゃく	{売りはらうこと。「土地を―する」}	{"sale; disposal by sale"}	\N
黴菌	ばいきん	{}	{"bacteria; germ(s)"}	\N
売春	ばいしゅん	{女性が報酬を得ることを目的として不特定の相手と性交すること。売淫。売色。売笑。}	{prostitution}	\N
賠償	ばいしょう	{}	{"reparations; indemnity; compensation"}	\N
陪食	ばいしょく	{}	{"Dining with one's superior"}	\N
媒体	ばいたい	{}	{"media (e.g. social)"}	\N
売店	ばいてん	{}	{"shop; stand"}	\N
売買	ばいばい	{}	{"trade; buying and selling"}	\N
倍率	ばいりつ	{}	{"diameter; magnification"}	\N
馬鹿	ばか	{}	{"fool; idiot; trivial matter; folly"}	\N
馬鹿馬鹿しい	ばかばかしい	{}	{stupid}	\N
馬鹿らしい	ばからしい	{}	{absurd}	\N
漠然	ばくぜん	{}	{"obscure; vague; equivocal"}	\N
莫大	ばくだい	{}	{"enormous; vast"}	\N
爆弾	ばくだん	{}	{bomb}	\N
爆破	ばくは	{}	{"blast; explosion; blow up"}	\N
爆発	ばくはつ	{}	{"explosion; detonation; eruption"}	\N
幕府	ばくふ	{日本の中世及び近世における征夷大将軍を首長とする武家政権のことをいう。あるいはその武家政権の政庁、征夷大将軍の居館・居城を指す名称としても用いられる。}	{"shogunate; tokugawa government"}	\N
爆裂	ばくれつ	{爆発して破裂すること。「砲弾が―する」}	{"an explosion⇒ばくはつ(爆発)"}	\N
暴露	ばくろ	{}	{"disclosure; exposure; revelation"}	\N
化ける	ばける	{}	{"to appear in disguise; to take the form of; to change for the worse"}	\N
化け物	ばけもの	{動植物や無生物が人の姿をとって現れるもの。キツネ・タヌキなどの化けたものや、柳の精・桜の精・雪女郎など。また、一つ目小僧・大入道・ろくろ首などあやしい姿をしたもの。お化け。妖怪。}	{"〔怪物〕a monster; 〔幽霊〕a ghost，(口) a spook，(文) a phantom"}	\N
場所	ばしょ	{}	{"place; location"}	\N
猫	ねこ	{}	{cat}	{動物}
鼠	ねずみ	{}	{"〔大型のねずみ〕a rat; 〔小型のねずみ，二十日鼠〕a mouse ((複mice))"}	{動物}
鳩	はと	{}	{"pigeon; dove"}	{動物}
羊	ひつじ	{}	{sheep}	{動物}
伐	ばつ	{}	{"strike; attack; punish"}	\N
罰ゲーム	ばつげーむ	{ゲームや勝負事で負けた人が罰としてやらされる行為。}	{"penatly game"}	\N
伐採	ばっさい	{}	{"felling; deforestation; lumbering"}	\N
罰する	ばっする	{}	{"punish; penalize"}	\N
発条	ばね	{}	{"spring (e.g. coil leaf)"}	\N
婆	ばば	{老女。また、老女をののしっていう語。⇔爺 (じじい) 。}	{"a hag"}	\N
婆あ	ばばあ	{老女。また、老女をののしっていう語。⇔爺 (じじい) 。}	{"a hag"}	\N
場面	ばめん	{}	{"scene; setting (e.g. of novel)"}	\N
散蒔く	ばらまく	{}	{"to disseminate; to scatter; to give money freely"}	\N
晩	ばん	{}	{evening}	\N
番組	ばんぐみ	{}	{"TV program"}	\N
番号	ばんごう	{}	{"number; series of digits"}	\N
番号札	ばんごうふだ	{}	{"number tag"}	\N
晩御飯	ばんごはん	{}	{"dinner; evening meal"}	\N
万歳	ばんざい	{}	{"strolling comic dancer"}	\N
万人	ばんじん	{}	{"all people; everybody; 10000 people"}	\N
万全	ばんぜん	{少しも手落ちのないこと。きわめて完全なこと。}	{"perfection; (to be) absolutely (sure)"}	\N
番地	ばんち	{}	{"house number; address"}	\N
万能	ばんのう	{}	{"all-purpose; almighty; omnipotent"}	\N
番目	ばんめ	{}	{"cardinal number suffix"}	\N
べき	べき	{当然の意を表す。〜して当然だ。〜のはずだ。〜しなければならない}	{"must; should"}	\N
べし	べし	{当然の意を表す。〜して当然だ。〜のはずだ。〜しなければならない}	{"must; should"}	\N
別	べつ	{}	{"distinction; difference; different; another; particular; separate; extra; exception"}	\N
別荘	べっそう	{}	{"holiday house; villa"}	\N
別に	べつに	{}	{"(not) particularly. nothing"}	\N
別々	べつべつ	{}	{"separately; individually"}	\N
弁解	べんかい	{}	{"explanation; justification; defence; excuse"}	\N
便宜	べんぎ	{}	{"convenience; accommodation; advantage; expedience"}	\N
勉強	べんきょう	{}	{"study; diligence; discount; reduction"}	\N
弁護	べんご	{}	{"defense; pleading; advocacy"}	\N
弁護士	べんごし	{当事者その他の関係人の依頼または官公署の委嘱によって、訴訟に関する行為その他一般の法律事務を行うことを職務とする者。一定の資格を持ち、日本弁護士連合会に備えた弁護士名簿に登録されなければならない。}	{"a lawyer，((米)) an attorney (at law); 〔法律顧問〕counsel"}	\N
便所	べんじょ	{}	{"toilet; lavatory; rest room; latrine"}	\N
弁償	べんしょう	{}	{"next word; compensation; reparation; indemnity; reimbursement"}	\N
弁当	べんとう	{}	{"lunch box"}	\N
便利	べんり	{}	{"convenient; handy; useful"}	\N
弁論	べんろん	{}	{"discussion; debate; argument"}	\N
美	び	{}	{beauty}	\N
微行	びこう	{}	{"traveling incognito"}	\N
美術	びじゅつ	{視覚的、空間的な美を表現する造形芸術。絵画・彫刻・建築・工芸など。明治時代は、広く文学・音楽なども含めていった。「古ー」「仏教ー」}	{"art; fine arts"}	\N
美術館	びじゅつかん	{}	{"art gallery"}	\N
微笑	びしょう	{}	{smile}	\N
美人	びじん	{}	{"beautiful person (woman)"}	\N
窒息	ちっそく	{}	{suffocation}	\N
罰	ばつ	{罪や過ちに対するこらしめ。仕置き。「一週間外出禁止の―を受ける」「―として廊下に立たされる」⇔賞。}	{"punishment; 日本語の「罰」のほか，「刑」にも相当することがある); (a) penalty"}	\N
薔薇	ばら	{}	{rose,"male homosexual-manga genre; aka. Men's Love (ML メンズラブ); is a Japanese technical term for a genre of art and fictional media that focuses on male same-sex love; usually created by gay men for a gay audience. The bara genre began in the 1950s with fetish magazines featuring gay art and content."}	\N
糞	ばば	{大便、また、汚いものをいう幼児語。}	{"(child speak) poop; something dirty"}	\N
屎	ばば	{大便、また、汚いものをいう幼児語。}	{"(child speak) poop; something dirty"}	\N
万	ばん	{}	{"many; all"}	\N
吃驚	びっくり	{}	{"be surprised; be amazed; be frightened; astonishment"}	\N
微妙	びみょう	{}	{"delicate; subtle"}	\N
白虎	びゃっこ	{}	{"white tiger"}	\N
白虎隊	びゃっこたい	{}	{"white tiger squad"}	\N
秒	びょう	{}	{"second (time)"}	\N
美容	びよう	{}	{"beauty of figure or form"}	\N
病院	びょういん	{}	{hospital}	\N
病気	びょうき	{}	{"illness; disease; sickness"}	\N
描写	びょうしゃ	{}	{"depiction; description; portrayal"}	\N
平等	びょうどう	{}	{"equality; impartiality; evenness"}	\N
微量	びりょう	{}	{"minuscule amount; extremely small quantity"}	\N
便	びん	{}	{"mail; post; flight (e.g. airline flight); service; opportunity; chance; letter"}	\N
敏感	びんかん	{}	{"sensibility; susceptibility; sensitive (to); well attuned to"}	\N
便箋	びんせん	{}	{"writing paper; stationery"}	\N
瓶詰	びんづめ	{}	{"bottling; bottled"}	\N
貧乏	びんぼう	{}	{"poverty; destitute; poor"}	\N
棒	ぼう	{}	{"pole; rod; stick"}	\N
防衛	ぼうえい	{他からの攻撃に対して、防ぎ守ること。「祖国をーする」「タイトルをーする」「正当ー」}	{"defense; protection; self-defense"}	\N
貿易	ぼうえき	{}	{trade}	\N
望遠鏡	ぼうえんきょう	{}	{telescope}	\N
防火	ぼうか	{}	{"fire prevention; fire fighting; fire proof"}	\N
妨害	ぼうがい	{}	{"disturbance; obstruction; hindrance; jamming; interference"}	\N
防御	ぼうぎょ	{敵の攻撃などを防ぎ守ること。「攻撃は最大のー」「敵の猛攻をーする」}	{defense}	\N
冒険	ぼうけん	{}	{"risk; venture; adventure"}	\N
坊さん	ぼうさん	{}	{"Buddhist priest; monk"}	\N
帽子	ぼうし	{}	{hat}	\N
防止	ぼうし	{}	{"prevention; check"}	\N
紡錘	ぼうすい	{}	{"a spindle"}	\N
紡績	ぼうせき	{}	{spinning}	\N
呆然	ぼうぜん	{}	{"dumbfounded; overcome with surprise; in blank amazement"}	\N
膨大	ぼうだい	{}	{"huge; bulky; enormous; extensive; swelling; expansion"}	\N
膨脹	ぼうちょう	{}	{"expansion; swelling; increase; growth"}	\N
傍聴	ぼうちょう	{}	{"hearing; attendence"}	\N
冒頭	ぼうとう	{}	{"beginning; start; outset"}	\N
暴動	ぼうどう	{}	{"insurrection; rebellion; revolt; riot; uprising"}	\N
某日	ぼうにち	{ある日。どの日か不明な場合や日付を伏せる場合などに用いる。「某月ー」}	{"a certain day"}	\N
防犯	ぼうはん	{}	{"prevention of crime"}	\N
暴風	ぼうふう	{}	{"storm; windstorm; gale"}	\N
暴風雨	ぼうふうう	{激しい風を伴った雨。台風や発達した低気圧によって起こる。あらし。}	{"a rainstorm; 〔台風〕a typhoon; 〔特に西インド諸島付近の〕a hurricane"}	\N
坊や	ぼうや	{}	{boy}	\N
暴力	ぼうりょく	{}	{violence}	\N
暴力的	ぼうりょくてき	{}	{violent}	\N
募金	ぼきん	{}	{"fund-raising; collection of funds"}	\N
牧師	ぼくし	{}	{"pastor; minister; clergyman"}	\N
牧場	ぼくじょう	{}	{"farm (livestock); pasture land; meadow; grazing land"}	\N
牧畜	ぼくちく	{}	{stock-farming}	\N
母語	ぼご	{人が生まれて最初に習い覚えた言語。母国語。}	{"mother tongue"}	\N
母校	ぼこう	{}	{"alma mater"}	\N
募集	ぼしゅう	{}	{"recruiting; taking applications"}	\N
没収	ぼっしゅう	{}	{forfeited}	\N
坊ちゃん	ぼっちゃん	{}	{"son (of others)"}	\N
勃発	ぼっぱつ	{事件などが突然に起こること。「内乱がーする」}	{"outbreak; sudden occurance"}	\N
没落	ぼつらく	{}	{"ruin; fall; collapse"}	\N
藍褸	ぼろ	{}	{"rag; scrap; tattered clothes; fault (esp. in a pretense); defect; run-down or junky"}	\N
盆	ぼん	{}	{"Lantern Festival; Festival of the Dead; tray"}	\N
盆地	ぼんち	{}	{"basin (e.g. between mountains)"}	\N
知的	ちてき	{}	{intellectual}	\N
分	ぶ	{}	{"rate; part; percentage; one percent; thickness; odds; chance of winning; one-hundredth of a shaku; one-quarter of a ryou"}	\N
僕	ぼく	{}	{"I (used by men with close acquaintances)"}	\N
部	ぶ	{}	{"department; part; category; counter for copies of a newspaper or magazine"}	\N
部下	ぶか	{組織などで、ある人の下に属し、その指示・命令で行動する人。配下。手下。}	{"subordinate person"}	\N
武器	ぶき	{}	{"weapon; arms; ordinance"}	\N
不気味	ぶきみ	{気味が悪いこと。また、そのさま。「―な笑い声」}	{"〜な weird; 〔幽霊などを暗示させる〕eerie; 〔不吉な〕ominous; 〔不可解な〕uncanny; 〔この世のものでない〕unearthly"}	\N
無沙汰	ぶさた	{}	{"neglecting to stay in contact"}	\N
武士	ぶし	{}	{"warrior; samurai"}	\N
無事	ぶじ	{}	{"safety; peace; quietness"}	\N
武士道	ぶしどう	{}	{bushido}	\N
部首	ぶしゅ	{}	{"radical of a kanji"}	\N
部署	ぶしょ	{それぞれに役割や分担を決めること。また、その役割や担当した場所。持ち場。「ーを移る」}	{"one's post; one's station"}	\N
侮辱	ぶじょく	{}	{"insult; contempt; slight"}	\N
武装	ぶそう	{}	{"arms; armament; armed"}	\N
無粋	ぶすい	{世態・人情、特に男女の間の微妙な情のやりとりに通じていないこと。また、そのさま。遊びのわからないさま、面白味のないさまなどにもいう。やぼ。「―なことを言う」「―な客」⇔粋。}	{"〜な 〔粗野な〕boorish; 〔洗練されない〕unrefined; unpolished"}	\N
不粋	ぶすい	{世態・人情、特に男女の間の微妙な情のやりとりに通じていないこと。また、そのさま。遊びのわからないさま、面白味のないさまなどにもいう。やぼ。「―なことを言う」「―な客」⇔粋。}	{"〜な 〔粗野な〕boorish; 〔洗練されない〕unrefined; unpolished"}	\N
舞台	ぶたい	{}	{"stage (theatre); scene or setting (e.g. of novel; play; etc.)"}	\N
部隊	ぶたい	{}	{forces}	\N
豚肉	ぶたにく	{}	{pork}	\N
斑	ぶち	{}	{"spots; speckles; mottles"}	\N
物価	ぶっか	{}	{"prices of commodities; prices (in general); cost-of-living"}	\N
物議	ぶつぎ	{}	{"public discussion (criticism)"}	\N
打付ける	ぶつける	{}	{"to knock; to run into; to nail on; to strike hard; to hit and attack"}	\N
物資	ぶっし	{}	{"goods; materials"}	\N
物質	ぶっしつ	{}	{"material; substance"}	\N
物騒	ぶっそう	{}	{"dangerous; disturbed; insecure"}	\N
仏像	ぶつぞう	{}	{"Buddhist image (statue)"}	\N
物体	ぶったい	{}	{"body; object"}	\N
仏壇	ぶつだん	{}	{"buddhist altar"}	\N
物理	ぶつり	{}	{physics}	\N
武道	ぶどう	{}	{budo}	\N
無難	ぶなん	{}	{"safety; security"}	\N
部品	ぶひん	{}	{"parts; accessories"}	\N
部門	ぶもん	{}	{"class; group; category; department; field; branch"}	\N
ぶら下げる	ぶらさげる	{}	{"to hang; to suspend; to dangle; to swing"}	\N
武力	ぶりょく	{}	{"armed might; military power; the sword; force"}	\N
無礼	ぶれい	{}	{"impolite; rude"}	\N
文化	ぶんか	{}	{culture}	\N
分解	ぶんかい	{}	{"analysis; disassembly"}	\N
文学	ぶんがく	{}	{literature}	\N
文化財	ぶんかざい	{}	{"cultural assets; cultural property"}	\N
分割	ぶんかつ	{いくつかに分けること。「土地を―して分け与える」}	{"division; partition"}	\N
分業	ぶんぎょう	{}	{"division of labor; specialization; assembly-line production"}	\N
文芸	ぶんげい	{}	{"literature; art and literature"}	\N
文献	ぶんけん	{}	{"literature; books (reference)"}	\N
分権	ぶんけん	{権力を1か所に集中しないで、分散すること。「地方ー」反：集権。}	{splitting}	\N
文語	ぶんご	{}	{"written language; literary language"}	\N
分散	ぶんさん	{}	{"dispersion; decentralization; variance (statistics)"}	\N
分子	ぶんし	{}	{"numerator; molecule"}	\N
文書	ぶんしょ	{}	{"document; writing; letter; note; records; archives"}	\N
文章	ぶんしょう	{}	{"sentence; article"}	\N
分数	ぶんすう	{}	{"(mathematics) fraction"}	\N
分析	ぶんせき	{複雑な事柄を一つ一つの要素や成分に分け、その構成などを明らかにすること。「情勢の―があまい」「事故の原因を―する」}	{analysis}	\N
文体	ぶんたい	{}	{"literary style"}	\N
分担	ぶんたん	{}	{"apportionment; sharing"}	\N
分配	ぶんぱい	{}	{"division; sharing"}	\N
分布	ぶんぷ	{}	{distribution}	\N
分泌	ぶんぴつ	{}	{secretion}	\N
分母	ぶんぼ	{}	{denominator}	\N
文法	ぶんぽう	{}	{grammar}	\N
文房具	ぶんぼうぐ	{}	{stationery}	\N
文脈	ぶんみゃく	{}	{context}	\N
文明	ぶんめい	{人知が進んで世の中が開け、精神的、物質的に生活が豊かになった状態。特に、宗教・道徳・学問・芸術などの精神的な文化に対して、技術・機械の発達や社会制度の整備などによる経済的・物質的文化をさす。；シビリゼーション}	{civilization}	\N
分野	ぶんや	{}	{"field; sphere; realm; division; branch"}	\N
分離	ぶんり	{}	{"separation; detachment; segregation; isolation"}	\N
分量	ぶんりょう	{}	{"amount; quantity"}	\N
分類	ぶんるい	{}	{classification}	\N
分裂	ぶんれつ	{一つのまとまりが、いくつかのものに分かれること。「会がーする」}	{"split; division; break up"}	\N
地	ち	{}	{earth}	\N
血	ち	{}	{blood}	\N
治安	ちあん	{}	{"public order"}	\N
地位	ちい	{}	{"(social) position; status"}	\N
地域	ちいき	{}	{"area; region"}	\N
小さい	ちいさい	{}	{"small; little; tiny"}	\N
小さな	ちいさな	{}	{small}	\N
知恵	ちえ	{}	{"wisdom; wit; sagacity; sense; intelligence; advice"}	\N
遅延	ちえん	{予定された期日や時間におくれること。また、長引くこと。「雪のために列車がーした」「ー証明」}	{"delay; being late; overdue"}	\N
地下	ちか	{}	{"basement; underground"}	\N
近い	ちかい	{}	{"near; close by; short"}	\N
違い	ちがい	{}	{"difference; discrepancy"}	\N
違いない	ちがいない	{}	{"sure; no mistaking it; for certain"}	\N
誓う	ちかう	{}	{"swear; vow; take an oath; pledge"}	\N
違う	ちがう	{}	{"differ (from)"}	\N
違える	ちがえる	{}	{"to change"}	\N
近く	ちかく	{}	{"near; neighbourhood; vicinity"}	\N
近頃	ちかごろ	{}	{"lately; recently; nowadays"}	\N
地下水	ちかすい	{}	{"underground water"}	\N
近付く	ちかづく	{}	{"to approach; to get near; to get acquainted with; to get closer"}	\N
近付ける	ちかづける	{}	{"bring near; put close; let come near; associate with"}	\N
地下鉄	ちかてつ	{}	{"underground train; subway"}	\N
近寄る	ちかよる	{}	{"approach; draw near"}	\N
力	ちから	{}	{"strength; power"}	\N
力強い	ちからづよい	{}	{"reassuring; emboldened"}	\N
地球	ちきゅう	{}	{"the earth"}	\N
契る	ちぎる	{}	{"to pledge; to promise; to swear"}	\N
地区	ちく	{}	{"district; section; sector"}	\N
逐一	ちくいち	{順を追って、一つ残らず取り上げていくこと。何から何まで全部。いちいち。副詞的にも用いる。一つ一つ。詳しく。「事のーはあとで話そう」}	{"one by one; in detail"}	\N
畜産	ちくさん	{}	{"animal husbandry"}	\N
畜生	ちくしょう	{}	{"beast; brute; damn"}	\N
蓄積	ちくせき	{}	{"accumulation; accumulate; store"}	\N
遅刻	ちこく	{決められた時刻に遅れること。「待ち合わせにーする」}	{"be late; late for"}	\N
知事	ちじ	{各都道府県を統轄し、代表する首長。}	{"a (prefectural) governor"}	\N
知識	ちしき	{}	{"knowledge; information"}	\N
地質	ちしつ	{}	{"geological features"}	\N
知人	ちじん	{}	{"friend; acquaintance"}	\N
地図	ちず	{}	{map}	\N
知性	ちせい	{}	{intelligence}	\N
地帯	ちたい	{}	{"area; zone"}	\N
乳	ちち	{}	{"milk; breast; loop"}	\N
父	ちち	{}	{father}	\N
父親	ちちおや	{}	{father}	\N
縮まる	ちぢまる	{}	{"to be shortened; to be contracted; to shrink"}	\N
縮む	ちぢむ	{}	{"shrink; be contracted"}	\N
縮める	ちぢめる	{}	{"shorten; reduce; boil down; shrink"}	\N
縮れる	ちぢれる	{}	{"be wavy; be curled"}	\N
秩序	ちつじょ	{物事を行う場合の正しい順序・筋道。順番。「ーを立てて考える」}	{"order; systematically"}	\N
地点	ちてん	{}	{"site; point on a map"}	\N
因み	ちなみ	{関係があること。ゆかり。因縁。「籍もあちらへ送った事ゆえ、余 (おれ) にはさっぱり―はない」}	{"to be associated (with); to be connected (with)"}	\N
因みに	ちなみに	{前に述べた事柄に、あとから簡単な補足などを付け加えるときに用いる。ついでに言うと。「―、新郎と新婦は幼いころからのお知り合いです」}	{"by the way"}	\N
知能	ちのう	{}	{"intelligence; brains"}	\N
地平線	ちへいせん	{}	{horizon}	\N
痴呆	ちほう	{}	{dementia}	\N
地方	ちほう	{広い地域；中央に対して}	{"district; the country; the provinces"}	\N
地方分権	ちほうぶんけん	{中央集権を排し、統治権力を地方に分散させること。日本国憲法は地方自治を保障し、地方分権主義を採っている。反：中央集権。}	{"decentralization of power"}	\N
地名	ちめい	{}	{"place name"}	\N
茶	ちゃ	{}	{tea}	\N
茶色	ちゃいろ	{}	{"light brown; tawny"}	\N
茶色い	ちゃいろい	{}	{"brown (adjective)"}	\N
ちゃう	ちゃう	{»ちまう»てしまう。壱）その動作・行為が完了する、すっかりその状態になる意を表す。弐）そのつもりでないのに、ある事態が実現する意を表す。}	{"to do something by accident; to finish completely"}	\N
着	ちゃく	{}	{"counter for suits of clothing; arriving at .."}	\N
着手	ちゃくしゅ	{}	{"embarkation; launch"}	\N
着色	ちゃくしょく	{}	{"colouring; coloring"}	\N
茶水	ちゃすい	{}	{"tea water"}	\N
嫡出	ちゃくしゅつ	{}	{legitimacy}	\N
着席	ちゃくせき	{}	{"sit down; seat"}	\N
着地	ちゃくち	{空中から地面に降り着くこと。着陸。「滑走路に無事―する」}	{"(a) touchdown; 〔軟着陸〕a soft landing"}	\N
着々	ちゃくちゃく	{}	{steadily}	\N
着目	ちゃくもく	{}	{attention}	\N
着陸	ちゃくりく	{}	{"landing; alighting; touch down"}	\N
着工	ちゃっこう	{}	{"start of (construction) work"}	\N
茶葉	ちゃば	{}	{"tea leaves"}	\N
茶の間	ちゃのま	{}	{"living room (Japanese style)"}	\N
茶の湯	ちゃのゆ	{}	{"tea ceremony"}	\N
茶碗	ちゃわん	{}	{"tea cup; rice bowl"}	\N
ちゃんと	ちゃんと	{少しも乱れがなく、よく整っているさま。}	{"regularly; neatly"}	\N
注	ちゅう	{}	{"annotation; explanatory note"}	\N
注意	ちゅうい	{気をつけること。気をくばること。留意。用心。警告。「よくーして観察する」}	{"advise; pay attention; care"}	\N
中央	ちゅうおう	{ある物や場所などのまんなかの位置。「町のーにある公園」}	{"center; middle; central"}	\N
宙返り	ちゅうがえり	{}	{"somersault; looping-the-loop"}	\N
中学	ちゅうがく	{}	{"middle school; junior high school"}	\N
中学校	ちゅうがっこう	{}	{"junior high school"}	\N
中間	ちゅうかん	{}	{"middle; midway; interim"}	\N
中継	ちゅうけい	{「中継放送」の略。競技場・野球場・劇場・国会・事件現場などの実況を、ある放送局がなかつぎして放送すること。「事故現場からーする」}	{"broadcast; relay; hook-up"}	\N
中古	ちゅうこ	{}	{"used; second-hand; old; Middle Ages"}	\N
忠告	ちゅうこく	{}	{"advice; warning"}	\N
中国人	ちゅうごくじん	{}	{"chinese (person)"}	\N
中止	ちゅうし	{}	{"suspension; stoppage; discontinuance; interruption"}	\N
忠実	ちゅうじつ	{}	{"fidelity; faithfulness"}	\N
駐車	ちゅうしゃ	{}	{"parking (e.g. car)"}	\N
注射	ちゅうしゃ	{注射器を使って薬液などを体内に注入すること。注入する部位によって皮下注射・筋肉注射・静脈注射などという。}	{injection}	\N
注釈	ちゅうしゃく	{}	{"annotation; notes; comments"}	\N
駐車場	ちゅうしゃじょう	{}	{"parking lot"}	\N
抽出	ちゅうしゅつ	{}	{extraction}	\N
中旬	ちゅうじゅん	{月の11日から20日までの10日間}	{"second third of a month"}	\N
中傷	ちゅうしょう	{}	{"slander; libel; defamation"}	\N
抽象	ちゅうしょう	{}	{abstract}	\N
抽象的	ちゅうしょうてき	{頭の中だけで考えていて、具体性に欠けるさま。反：具体的}	{abstract}	\N
昼食	ちゅうしょく	{}	{"lunch; midday meal"}	\N
大豆	だいず	{}	{"soy bean"}	\N
中心	ちゅうしん	{まんなか。中央。「町の―に公民館がある」「地域の―」}	{"center; core; heart; pivot; emphasis; balance"}	\N
注水	ちゅうすい	{}	{"pouring water; flooding"}	\N
中枢	ちゅうすう	{}	{"centre; pivot; mainstay; nucleus; backbone; central figure; pillar; key man"}	\N
中世	ちゅうせい	{}	{"Middle Ages; mediaeval times"}	\N
中性	ちゅうせい	{}	{"neuter gender; neutral (chem.); indifference; sterility"}	\N
抽選	ちゅうせん	{}	{"lottery; raffle; drawing (of lots)"}	\N
鋳造	ちゅうぞう	{}	{"casting (e.g. a statue)"}	\N
中断	ちゅうだん	{}	{"interruption; suspension; break"}	\N
中腹	ちゅうっぱら	{}	{"irritated; offended"}	\N
中途	ちゅうと	{}	{"in the middle; half-way"}	\N
中毒	ちゅうどく	{}	{poisoning}	\N
駐屯	ちゅうとん	{}	{"stationing; occupancy"}	\N
注入	ちゅうにゅう	{液体などをそそぎ入れること。つぎこむこと。「ライターにガスを―する」}	{injection}	\N
仲人	ちゅうにん	{}	{"go-between; matchmaker"}	\N
中年	ちゅうねん	{}	{middle-aged}	\N
昼飯	ちゅうはん	{}	{"lunch; midday meal"}	\N
注目	ちゅうもく	{}	{"notice; attention; observation"}	\N
注文	ちゅうもん	{}	{"order; request"}	\N
中立	ちゅうりつ	{}	{neutrality}	\N
駐輪場	ちゅうりんじょう	{}	{bike-parking}	\N
中和	ちゅうわ	{}	{"neutralize; counteract"}	\N
超	ちょう	{}	{"super-; ultra-; hyper-"}	\N
蝶	ちょう	{}	{butterfly}	\N
腸	ちょう	{}	{"guts; bowels; intestines"}	\N
庁	ちょう	{}	{"government office"}	\N
兢	ちょう	{}	{"cautious [hanzi]"}	\N
調印	ちょういん	{}	{"signature; sign; sealing"}	\N
懲役	ちょうえき	{自由刑の一。刑事施設に拘置して一定の労役に服させる刑罰。無期と有期の2種がある。}	{"penal servitude; imprisonment ((with hard labor))"}	\N
兆円	ちょうえん	{}	{"10^12 yen"}	\N
超過	ちょうか	{}	{"excess; being more than"}	\N
聴覚	ちょうかく	{}	{"the sense of hearing"}	\N
長官	ちょうかん	{}	{"chief; (government) secretary"}	\N
朝刊	ちょうかん	{日刊新聞で、朝に発行されるもの。<>夕刊。}	{"a morning edition [paper]"}	\N
長期	ちょうき	{}	{"long time period"}	\N
超級	ちょうきゅう	{スーパークラス}	{"super class"}	\N
聴講	ちょうこう	{}	{"lecture attendance; auditing"}	\N
彫刻	ちょうこく	{}	{"carving; engraving; sculpture"}	\N
調査	ちょうさ	{}	{"investigation; examination; inquiry; survey"}	\N
調子	ちょうし	{}	{"tune; tone; key; pitch; time; rhythm; vein; mood; way; manner; style; knack; condition; state of health; strain; impetus; spur of the moment; trend"}	\N
徴収	ちょうしゅう	{}	{"collection; levy"}	\N
聴衆	ちょうしゅう	{}	{"an audience"}	\N
長所	ちょうしょ	{}	{"strong point; merit; advantage"}	\N
長女	ちょうじょ	{}	{"eldest daughter"}	\N
頂上	ちょうじょう	{}	{"top; summit; peak"}	\N
聴診器	ちょうしんき	{}	{stethoscope}	\N
調整	ちょうせい	{}	{"regulation; adjustment; tuning"}	\N
潮汐	ちょうせき	{}	{tide}	\N
調節	ちょうせつ	{}	{"regulation; adjustment; control"}	\N
挑戦	ちょうせん	{}	{"challenge; defiance"}	\N
朝鮮	ちょうせん	{}	{"〔地域〕Korea; 〔朝鮮民主主義人民共和国〕the Democratic People's Republic of Korea"}	\N
彫塑	ちょうそ	{}	{sculpture}	\N
長大	ちょうだい	{}	{"very long; great length"}	\N
長短	ちょうたん	{}	{"length; long and short; advantages and disadvantages; pluses and minuses; strong and weak points; merits and demerits"}	\N
調停	ちょうてい	{}	{"arbitration; conciliation; mediation"}	\N
朝廷	ちょうてい	{天子が政治を行う所。廟堂 (びょうどう) 。朝堂。また、天子が政治を行う機関。}	{"the Imperial Court"}	\N
頂点	ちょうてん	{}	{"top; summit"}	\N
恰度	ちょうど	{}	{"just; right; exactly"}	\N
丁度	ちょうど	{ある基準に、過不足なく一致するさま。きっかり。ぴったり。きっちり。}	{"exactly; precisely"}	\N
長男	ちょうなん	{}	{"eldest son"}	\N
長編	ちょうへん	{}	{"long (e.g. novel film)"}	\N
長方形	ちょうほうけい	{}	{"rectangle; oblong"}	\N
調味料	ちょうみりょう	{}	{"condiment; seasoning"}	\N
丁目	ちょうめ	{}	{"district of a town; city block (of irregular size)"}	\N
調理	ちょうり	{}	{cooking}	\N
長老	ちょうろう	{}	{elder}	\N
調和	ちょうわ	{}	{harmony}	\N
貯金	ちょきん	{}	{"(bank) savings"}	\N
直後	ちょくご	{}	{"immediately following"}	\N
直接	ちょくせつ	{}	{"direct; immediate; personal; firsthand"}	\N
直線	ちょくせん	{}	{"straight line"}	\N
直前	ちょくぜん	{}	{"just before"}	\N
直通	ちょくつう	{}	{"direct communication"}	\N
勅命	ちょくめい	{天皇の命令。勅諚 (ちょくじょう) 。みことのり。}	{"Imperial order"}	\N
直面	ちょくめん	{}	{confrontation}	\N
直流	ちょくりゅう	{}	{"direct current"}	\N
著作権	ちょさくけん	{著作者が自己の著作物の複製発刊翻訳興行上映放送などに関し，独占的に支配し利益をうける排他的な権利。}	{"a copyright; literary property"}	\N
著者	ちょしゃ	{}	{"author; writer"}	\N
著書	ちょしょ	{}	{"literary work; book"}	\N
貯蔵	ちょぞう	{}	{"storage; preservation"}	\N
貯蓄	ちょちく	{}	{savings}	\N
直角	ちょっかく	{}	{"right angle"}	\N
直感	ちょっかん	{}	{intuition}	\N
直径	ちょっけい	{}	{diameter}	\N
長寿	ちょうじゅ	{寿命の長いこと。長命。「―を保つ」}	{"a long life; longevity"}	\N
一寸	ちょっと	{}	{"(ateji) (adv int) (uk) just a minute; a short time; a while; just a little; somewhat; easily; readily; rather"}	\N
弔問	ちょうもん	{}	{"condolence call"}	\N
著名	ちょめい	{世間に名が知られていること。また、そのさま。有名。「―な芸術家」}	{"well-known; noted; celebrated"}	\N
散らかす	ちらかす	{}	{"scatter around; leave untidy"}	\N
散らかる	ちらかる	{}	{"be in disorder; lie scattered around"}	\N
散らす	ちらす	{}	{"scatter; disperse; distribute"}	\N
地理	ちり	{}	{"geography; geographical features"}	\N
塵紙	ちりがみ	{}	{"tissue paper; toilet paper"}	\N
塵取り	ちりとり	{}	{dustpan}	\N
治療	ちりょう	{}	{"medical treatment"}	\N
散る	ちる	{花や葉が、茎や枝から離れて落ちる。「花が―・る」}	{"〔ばらばらに落ちる〕to fall; scatter"}	\N
賃金	ちんぎん	{}	{wages}	\N
賃貸	ちんたい	{賃料を取り、物を相手方に貸すこと。賃貸し。「駐車場を―する」「―価格」「―マンション」⇔賃借。}	{"〜する 〔土地・建物・機械などを〕lease; 〔土地・建物などを〕rent; 〔家・部屋などを〕rent"}	\N
沈殿	ちんでん	{}	{"precipitation; settlement"}	\N
チンピラ	チンピラ	{不良少年少女。また、やくざなどの下っ端。「町の―」}	{"a hooligan; ((米)) a punk"}	\N
沈没	ちんぼつ	{}	{"sinking; foundering"}	\N
沈黙	ちんもく	{}	{"silence; reticence"}	\N
賃料	ちんりょう	{}	{rent}	\N
陳列	ちんれつ	{}	{"exhibition; display; show"}	\N
段々	だんだん	{いくつかの段のあるもの。また特に、階段。「石のーを上る」}	{"gradually; more and more; little by little; step by step"}	\N
大	だい	{}	{"great; large"}	\N
題	だい	{}	{"title; subject; theme; topic"}	\N
台	だい	{}	{"stand; rack; table; support"}	\N
第	だい	{}	{ordinal}	\N
第一	だいいち	{}	{"first; foremost; # 1"}	\N
大学	だいがく	{}	{university}	\N
大学院	だいがくいん	{}	{"graduate school"}	\N
大学生	だいがくせい	{}	{"university student"}	\N
代金	だいきん	{}	{"price; payment; cost; charge; the money; the bill"}	\N
大工	だいく	{}	{carpenter}	\N
大小	だいしょう	{}	{size}	\N
大丈夫	だいじょうぶ	{}	{"safe; all right; O.K."}	\N
大臣	だいじん	{}	{"cabinet minister"}	\N
大事	だいじ	{}	{important}	\N
大好き	だいすき	{}	{"very likeable; like very much"}	\N
大体	だいたい	{}	{"general; substantially; outline; main point"}	\N
代替	だいたい	{それに見合う他のもので代えること。かわり。「路面電車を廃止しバスで―する」「―地」}	{substitution}	\N
大胆	だいたん	{}	{"bold; daring; audacious"}	\N
大統領	だいとうりょう	{}	{"president; chief executive"}	\N
台所	だいどころ	{}	{kitchen}	\N
台無し	だいなし	{}	{"mess; spoiled; (come to) nothing"}	\N
代表	だいひょう	{}	{"representative; representation; delegation; type; example; model"}	\N
代表取締役	だいひょうとりしまりやく	{株式会社の取締役会の決議によって選任され、業務を執行し、かつ会社を代表する権限をもつ取締役。}	{"the representative director; the chief executive officer(略CEO); (英)the managing director"}	\N
大部分	だいぶぶん	{}	{"most part; greater part; majority"}	\N
大便	だいべん	{}	{"feces; excrement; shit"}	\N
代弁	だいべん	{}	{"pay by proxy; act for another; speak for another"}	\N
台本	だいほん	{}	{"libretto; scenario"}	\N
代目	だいめ	{助数詞。世代を数えるのに用いる。「二―」「六―菊五郎」}	{"(ordanilization) (2)nd; (3)rd; (4)th"}	\N
題名	だいめい	{}	{title}	\N
代名詞	だいめいし	{}	{pronoun}	\N
代用	だいよう	{}	{substitution}	\N
代理	だいり	{}	{"representation; agency; proxy; deputy; agent; attorney; substitute; alternate; acting (principal; etc.)"}	\N
楕円	だえん	{}	{ellipse}	\N
打開	だかい	{}	{"break in the deadlock"}	\N
駄菓子屋	だがしや	{}	{"old-style candy store"}	\N
妥協	だきょう	{}	{"compromise; giving in"}	\N
打撃	だげき	{}	{"blow; shock; strike; damage; batting (baseball)"}	\N
妥結	だけつ	{}	{agreement}	\N
駄作	ださく	{}	{"poor work; rubbish"}	\N
出汁	だし	{}	{buillion}	\N
出す	だす	{}	{"take out; put out; send"}	\N
惰性	だせい	{}	{"inertia; momentum; habit"}	\N
脱	だつ	{［語素］名詞に付いて、その境遇から抜け出す、の意を表す。「―サラリーマン」}	{datsu}	\N
脱出	だっしゅつ	{危険な場所や好ましくない状態から抜け出すこと。}	{"an escape"}	\N
脱する	だっする	{}	{"to escape from; to get out"}	\N
脱線	だっせん	{}	{"derailment; digression"}	\N
脱退	だったい	{}	{secession}	\N
妥当	だとう	{}	{"valid; proper; right; appropriate"}	\N
黙る	だまる	{}	{"be silent"}	\N
駄目	だめ	{}	{"no; no good; hopeless"}	\N
堕落	だらく	{賄賂など「政治の―」}	{"corruption; depravity"}	\N
だらけ	だらけ	{それのために汚れたり、それが一面に広がったりしているさまを表す。「血―」「どろ―」}	{"all over; full; smeared; riddled; everything (has gone wrong)"}	\N
怠い	だるい	{}	{"sluggish; feel heavy; languid; dull"}	\N
誰か	だれか	{}	{"someone; somebody"}	\N
壇	だん	{}	{"platform; podium; rostrum; (arch) mandala"}	\N
段	だん	{}	{"step; stair; flight of steps; grade; rank; level"}	\N
段階	だんかい	{}	{"gradation; grade; stage"}	\N
弾劾	だんがい	{}	{"impeachment (accusation of an official for unlawful activity)"}	\N
断崖	だんがい	{垂直に切り立ったがけ。きりぎし。「ー絶壁」}	{"cliff; pricipace"}	\N
断崖絶壁	だんがいぜっぺき	{切り立ったがけ。非常に危機的な状況のたとえとして用いられることもある。}	{"a precipitous cliff"}	\N
団結	だんけつ	{}	{"unity; union; combination"}	\N
断言	だんげん	{}	{"declaration; affirmation"}	\N
男子	だんし	{}	{"youth; young man"}	\N
断水	だんすい	{}	{"water outage"}	\N
男性	だんせい	{}	{male}	\N
断然	だんぜん	{}	{"firmly; absolutely; definitely"}	\N
同	どう	{}	{"the same; the said; ibid."}	\N
胴	どう	{}	{"trunk; body; frame"}	\N
大分	だいぶ	{}	{"very; many; a lot"}	\N
大分	だいぶん	{}	{"considerably; greatly; a lot"}	\N
丈	だけ	{}	{"only; just; as"}	\N
団体	だんたい	{ある目的のために、人々が集まって一つのまとまりとなったもの。「―で見学する」「―旅行」「―割引」}	{"〔人の集まり〕a group; 〔一行〕a party; 〔一団〕a body"}	\N
団地	だんち	{}	{"multi-unit apartments"}	\N
断定	だんてい	{}	{"conclusion; decision"}	\N
旦那	だんな	{}	{"master (of house); husband (informal)"}	\N
暖房	だんぼう	{}	{heating}	\N
断面	だんめん	{}	{"cross section"}	\N
弾力	だんりょく	{}	{"elasticity; flexibility"}	\N
出合い	であい	{}	{"an encounter"}	\N
出会い	であい	{思いがけなくあうこと。めぐりあい。「師との運命的な＿」「一冊の本との＿」}	{"meeting; rendezvous; encounter"}	\N
出会う	であう	{ある場所でいっしょになる。「本流と支流が―・う地点」}	{"to hold a rendezvous; to have a date"}	\N
出合う	であう	{}	{"to meet by chance; to come across; to happen to encounter; to hold a rendezvous; to have a date"}	\N
出逢う	であう	{人・事件などに偶然に行きあう。「街角で旧友と―・う」「帰宅途中に事故に―・う」}	{"to meet by chance; happen to encounter"}	\N
出入り	でいり	{}	{"in and out; coming and going; free association; income and expenditure; debits and credit"}	\N
出入り口	でいりぐち	{}	{"exit and entrance"}	\N
出掛ける	でかける	{}	{"depart; set out; start; be going out"}	\N
出かける	でかける	{}	{"depart; go out (e.g. on an excursion or outing); set out; start"}	\N
出来る	できる	{}	{"〔可能である〕can [be able to](do); (事が主語で) be possible"}	\N
出来上がり	できあがり	{}	{"finish; completion; ready; made for; cut out"}	\N
出来上がる	できあがる	{}	{"be finished; be ready; by definition; be very drunk"}	\N
出来事	できごと	{}	{"incident; affair; happening; event"}	\N
出来物	できもの	{}	{"able man; tumour; growth; boil; ulcer; abcess; rash; pimple"}	\N
出切る	できる	{}	{"to be out of; to have no more at hand"}	\N
出来るだけ	できるだけ	{}	{"if at all possible"}	\N
出口	でぐち	{}	{"exit; gateway; way out; outlet; leak; vent"}	\N
出くわす	でくわす	{}	{"to happen to meet; to come across"}	\N
凸凹	でこぼこ	{}	{"unevenness; roughness; ruggedness"}	\N
出鱈目	でたらめ	{}	{"irresponsible utterance; nonsense; nonsensical; random; haphazard; unsystematic"}	\N
出直し	でなおし	{}	{"adjustment; touch up"}	\N
出迎え	でむかえ	{}	{"meeting; reception"}	\N
出迎える	でむかえる	{}	{"to meet; to greet"}	\N
出る	でる	{}	{"appear; come forth; leave"}	\N
田園	でんえん	{}	{"country; rural districts"}	\N
伝記	でんき	{}	{"biography; life story"}	\N
電気	でんき	{}	{"electricity; (electric) light"}	\N
電球	でんきゅう	{}	{"light bulb"}	\N
電源	でんげん	{}	{"source of electricity; power (button on TV etc.)"}	\N
伝言	でんごん	{人に頼んで、相手に用件を伝えること。また、その言葉。ことづて。ことづけ。「彼には妹からーしてもらう」}	{"a message; word"}	\N
電子	でんし	{}	{"electron; (as a prefix) electronic; electronics"}	\N
電子工学	でんしこうがく	{電子伝導、およびその現象を応用する装置・技術についての学問。エレクトロニクス。}	{"electrical engineering; electronics"}	\N
電車	でんしゃ	{}	{"electric train"}	\N
伝承	でんしょう	{伝え聞くこと。人づてに聞くこと。}	{"transmission; 〔物〕folklore; 〔口伝〕(an) oral tradition; a tradition"}	\N
伝説	でんせつ	{}	{"tradition; legend; folklore"}	\N
伝染	でんせん	{}	{contagion}	\N
電線	でんせん	{}	{"electric line"}	\N
電卓	でんたく	{}	{calculator}	\N
伝達	でんたつ	{}	{"transmission (e.g. news); communication; delivery"}	\N
電池	でんち	{}	{battery}	\N
電柱	でんちゅう	{}	{"telephone pole; telegraph pole; lightpole"}	\N
点滴	てんてき	{}	{"hospital drip"}	\N
電灯	でんとう	{}	{light}	\N
伝統	でんとう	{}	{"tradition; convention"}	\N
電波	でんぱ	{}	{"electro-magnetic wave"}	\N
電報	でんぽう	{}	{telegram}	\N
伝来	でんらい	{}	{"ancestral; hereditary; imported; transmitted; handed down"}	\N
電流	でんりゅう	{}	{"electric current"}	\N
電力	でんりょく	{}	{"electric power"}	\N
電話	でんわ	{}	{telephone}	\N
働	どう	{}	{"work; labor"}	\N
同意	どうい	{}	{"agreement; consent; same meaning; same opinion; approval"}	\N
同一	どういつ	{}	{"identity; sameness; similarity; equality; fairness"}	\N
動員	どういん	{}	{mobilization}	\N
同格	どうかく	{}	{"the same rank; equality; apposition"}	\N
同感	どうかん	{}	{"agreement; same opinion; same feeling; sympathy; concurrence"}	\N
動機	どうき	{}	{"motive; incentive"}	\N
同期	どうき	{}	{"sync (on a computer)"}	\N
同級	どうきゅう	{}	{"the same grade; same class"}	\N
同居	どうきょ	{}	{"living together"}	\N
道具	どうぐ	{}	{tool}	\N
洞窟	どうくつ	{}	{"cave; cavern"}	\N
動向	どうこう	{}	{"trend; tendency; movement; attitude"}	\N
同行	どうこう	{一緒に連れ立って行くこと。主たる人に付き従って行くこと。また、その人。同道。「警察へ―を求める」「社長に―する」}	{"accompany; go with; party (of three);"}	\N
動作	どうさ	{}	{"action; movements; motions; bearing; behaviour; manners"}	\N
洞察	どうさつ	{}	{"insight; discernment"}	\N
同志	どうし	{}	{"same mind; comrade; kindred soul"}	\N
同士	どうし	{}	{"fellow; companion; comrade"}	\N
動詞	どうし	{}	{verb}	\N
同時	どうじ	{}	{"simultaneous(ly); concurrent; same time; synchronous"}	\N
如何しても	どうしても	{}	{"by all means; at any cost; no matter what; after all; in the long run; cravingly; at any rate; surely"}	\N
同情	どうじょう	{}	{"sympathy; compassion; sympathize; pity; feel for"}	\N
道場	どうじょう	{}	{"dojo; hall used for martial arts training; mandala"}	\N
同じる	どうじる	{「どう（同）ずる」（サ変）の上一段化。「政府案には―・じない意向だ」}	{"concede; admit; allow"}	\N
どうせ	どうせ	{経過がどうであろうと、結果は明らかだと認める気持ちを表す語。いずれにせよ。結局は。}	{"anyhow; after all"}	\N
同級生	どうきゅうせい	{同性を性愛の対象とすること。また、そのような関係。}	{homosexuality}	\N
銅線	どうせん	{}	{"copper cable"}	\N
どうぞ宜しく	どうぞよろしく	{}	{"pleased to meet you"}	\N
胴体	どうたい	{}	{"body; torso"}	\N
撞着語法	どうちゃくごほう	{つじつまが合わないこと。矛盾。「話の前後が―する」「自家―」}	{"oxymoron; contradictional expression"}	\N
同調	どうちょう	{}	{"sympathy; agree with; alignment; tuning"}	\N
動的	どうてき	{}	{"dynamic; kinetic"}	\N
同等	どうとう	{}	{"equality; equal; same rights; same rank"}	\N
堂々	どうどう	{}	{"magnificent; grand; impressive"}	\N
道徳	どうとく	{}	{morals}	\N
導入	どうにゅう	{}	{"introduction; bringing in; leading in"}	\N
同伴	どうはん	{}	{companion}	\N
同封	どうふう	{}	{"enclosure (e.g. in a letter)"}	\N
動物	どうぶつ	{}	{animal}	\N
動物園	どうぶつえん	{}	{zoo}	\N
同盟	どうめい	{}	{"alliance; union; league"}	\N
動揺	どうよう	{}	{"disturbance; unrest; shaking; trembling; pitching; rolling; oscillation; agitation; excitement; commotion"}	\N
童謡	どうよう	{}	{"nursery rhyme; children's song"}	\N
同様	どうよう	{同じであること}	{"same; like"}	\N
同僚	どうりょう	{}	{"coworker; colleague; associate"}	\N
動力	どうりょく	{}	{"power; motive power; dynamic force"}	\N
道路	どうろ	{}	{"road; highway"}	\N
童話	どうわ	{}	{fairy-tale}	\N
退かす	どかす	{物や人を他の場所へ移して場所をあける。のかせる。「障害物を―・す」}	{"to move (e.g. a heavy stone/car)"}	\N
毒	どく	{}	{poison}	\N
独裁	どくさい	{}	{"dictatorship; despotism"}	\N
毒死	どくし	{毒薬によって死ぬこと。}	{"poisoning death"}	\N
独自	どくじ	{}	{"original; peculiar; characteristic"}	\N
読者	どくしゃ	{}	{reader}	\N
読書	どくしょ	{本を読むこと。}	{reading}	\N
独身	どくしん	{}	{"bachelorhood; single; unmarried; celibate"}	\N
独占	どくせん	{}	{monopoly}	\N
独創	どくそう	{}	{originality}	\N
原典	げんてん	{}	{"original (text)"}	\N
独特	どくとく	{そのものだけが特別にもっていること。また、そのさま。「―な（の）雰囲気」}	{"peculiarity; uniqueness; characteristic"}	\N
独得	どくとく	{そのものだけが特別にもっていること。また、そのさま。「―な（の）雰囲気」}	{"peculiarity; uniqueness; characteristic"}	\N
独房	どくぼう	{刑務所や拘置所で、収容者を一人だけ入れておく居室。}	{"a (solitary) cell"}	\N
独立	どくりつ	{}	{"independence; self-support"}	\N
髑髏	どくろ	{風雨にさらされて肉が落ち、むきだしになった頭蓋骨。されこうべ。しゃれこうべ。}	{"a skull"}	\N
土壌	どじょう	{地殻の最上部にある、岩石の風化物に動植物の遺体あるいはその分解物が加わったもの。地表からの深さはせいぜい1、2メートルまで。つち。}	{soil⇒つち(土)}	\N
何方	どちら	{}	{"which; who"}	\N
土手	どて	{}	{"embankment; bank"}	\N
怒鳴る	どなる	{}	{"to shout; to yell"}	\N
何の	どの	{}	{"which; what"}	\N
土俵	どひょう	{}	{arena}	\N
土木	どぼく	{}	{"public works"}	\N
土曜	どよう	{}	{Saturday}	\N
土曜日	どようび	{}	{Saturday}	\N
泥	どろ	{}	{mud}	\N
努力	どりょく	{ある目的のために力を尽くして励むこと。「ーが実る」「たゆまずーする」「ー家」}	{"great effort; exertion; endeavour; effort"}	\N
何れ位	どれくらい	{}	{"to what degree; (nobody knows) how (sad I am); how (tall he is)"}	\N
どれだけ	どれだけ	{⇒どれくらい(何れ位)}	{"to what degree; (nobody knows) how (sad I am); how (tall he is)"}	\N
泥沼	どろぬま	{}	{"quagmire; march"}	\N
泥棒	どろぼう	{}	{robber}	\N
度忘れ	どわすれ	{}	{"lapse of memory; forget for a moment"}	\N
鈍感	どんかん	{}	{"thickheadedness; stolidity"}	\N
丼	どんぶり	{}	{"porcelain bowl; bowl of rice with food on top"}	\N
貪欲	どんよく	{}	{"gluttonous; ravenous; insatiable"}	\N
永遠	えいえん	{いつまでも果てしなく続くこと。時間を超えて存在すること。永久。「＿に残る名曲」「＿のスター」}	{"〔永久〕eternity; permanence; 〔不滅〕immortality"}	\N
永久	えいきゅう	{いつまでも限りなく続くこと。永遠。「ーに平和を守る」「ー不変」}	{"eternity; permanence"}	\N
襟を正す	えりをただす	{自己の乱れた衣服や姿勢を整える}	{"straighten up; shape up"}	\N
援交	えんこう	{金銭の援助を伴う交際。主に未成年の女子が行う売春をいう俗語。}	{"compensated dating; prostitute"}	\N
絵	え	{}	{"picture; drawing; painting; sketch"}	\N
重	え	{}	{"-fold; -ply"}	\N
映画	えいが	{}	{"movie; film"}	\N
映画館	えいがかん	{}	{"movie theatre (theater); cinema"}	\N
影響	えいきょう	{}	{"influence; effect"}	\N
営業	えいぎょう	{}	{"business; trade; sales; operations"}	\N
英語	えいご	{}	{"the English language"}	\N
英字	えいじ	{}	{"English letter (character)"}	\N
映写	えいしゃ	{}	{projection}	\N
衛生	えいせい	{}	{"health; hygiene; sanitation; medical"}	\N
衛星	えいせい	{}	{satellite}	\N
映像	えいぞう	{}	{"reflection; image"}	\N
英文	えいぶん	{}	{"sentence in English"}	\N
英雄	えいゆう	{}	{"hero; great man"}	\N
栄養	えいよう	{}	{"nutrition; nourishment"}	\N
英和	えいわ	{}	{"English-Japanese (e.g. dictionary)"}	\N
笑顔	えがお	{}	{"smiling face"}	\N
会	え	{}	{understanding}	\N
柄	え	{}	{"handle; grip"}	\N
退ける	どける	{}	{"remove; take away; dislodge; put something out of the way"}	\N
土産	どさん	{}	{"product of the land"}	\N
何れ	どれ	{}	{"well; now; let me see; which (of three or more)"}	\N
何々	どれどれ	{}	{"which (emphatic)"}	\N
液	えき	{}	{"liquid; fluid"}	\N
駅	えき	{}	{station}	\N
液体	えきたい	{}	{"liquid; fluid"}	\N
餌	えさ	{}	{"bait; feed"}	\N
枝	えだ	{}	{branch}	\N
枝豆	えだまめ	{大豆を未熟なうちに茎ごと取ったもの。さやのままゆでて食べる。月見豆。}	{"green soybeans"}	\N
謁見	えっけん	{}	{audience}	\N
閲覧	えつらん	{}	{"inspection; reading"}	\N
夷	えびす	{}	{"barbarian; savage"}	\N
絵の具	えのぐ	{}	{"colors; paints"}	\N
絵巻	えまき	{}	{"picture scroll"}	\N
獲物	えもの	{}	{"game; spoils; trophy"}	\N
偉い	えらい	{}	{"great; celebrated; eminent; terrible; awful; famous; remarkable; excellent"}	\N
選ぶ	えらぶ	{}	{choose}	\N
襟	えり	{}	{"neck; collar; lapel; neckband"}	\N
宴会	えんかい	{}	{"party; banquet"}	\N
円滑	えんかつ	{}	{"harmony; smoothness"}	\N
縁側	えんがわ	{}	{"veranda; porch; balcony; open corridor"}	\N
沿岸	えんがん	{}	{"coast; shore"}	\N
延期	えんき	{}	{"postponement; adjournment"}	\N
演技	えんぎ	{}	{"acting; performance"}	\N
婉曲	えんきょく	{}	{"euphemistic; circumlocution; roundabout; indirect; insinuating"}	\N
円空	えんくう	{［1632?～1695］江戸初期の臨済宗の僧。美濃の人。生涯に12万体の造像を発願し、諸国を遍歴、布教しながら、円空仏とよばれる仏像を多数制作した。}	{enkuu}	\N
園芸	えんげい	{}	{"horticulture; gardening"}	\N
演劇	えんげき	{}	{"theatre play"}	\N
円周	えんしゅう	{}	{circumference}	\N
演習	えんしゅう	{}	{"practice; exercises; manoeuvers"}	\N
演出	えんしゅつ	{}	{"production (e.g. play); direction"}	\N
援助	えんじょ	{}	{"assistance; aid; support"}	\N
炎症	えんしょう	{}	{"inflammation (e.g. in a finger)"}	\N
演じる	えんじる	{}	{"to perform (a play); to play (a part); to act (a part); to commit (a blunder)"}	\N
円錐	えんすい	{コーン。円の平面の外にある一定点から円周上に伸ばした線分が円周上を1周してつくる曲面と、もとの円とによって囲まれる立体。直円錐と斜円錐がある。円錐体。}	{"a (circular) cone"}	\N
演ずる	えんずる	{}	{"to perform; to play"}	\N
演説	えんぜつ	{}	{"speech; address"}	\N
沿線	えんせん	{}	{"along railway line"}	\N
演奏	えんそう	{}	{"musical performance"}	\N
遠足	えんそく	{}	{"trip; hike; picnic"}	\N
縁談	えんだん	{}	{"marriage proposal; engagement"}	\N
園地	えんち	{自然公園で、公園施設を設けた区域。}	{"set (nature) park (in a designated area)"}	\N
苑地	えんち	{自然公園で、公園施設を設けた区域。}	{"set (nature) park (in a designated area)"}	\N
延長	えんちょう	{}	{"extension; elongation; prolongation; lengthening"}	\N
煙突	えんとつ	{}	{chimney}	\N
鉛筆	えんぴつ	{}	{pencil}	\N
遠方	えんぽう	{}	{"long way; distant place"}	\N
円満	えんまん	{}	{"perfection; harmony; peace; smoothness; completeness; satisfaction; integrity"}	\N
遠慮	えんりょ	{}	{"diffidence; restraint; reserve"}	\N
害	がい	{}	{"injury; harm; damage; evil influence"}	\N
外貨	がいか	{}	{"imported goods; foreign money"}	\N
外郭団体	がいかくだんたい	{}	{"an affiliated organization"}	\N
外観	がいかん	{}	{"appearance; exterior; facade"}	\N
外交	がいこう	{外国との交渉・交際。国家相互の関係。ディプロマシー。}	{diplomacy}	\N
外国	がいこく	{}	{"foreign country"}	\N
外国人	がいこくじん	{}	{foreigner}	\N
語彙	ごい	{}	{"vocabulary; glossary"}	\N
街	がい	{}	{"~street; ~quarters"}	\N
蓋	がい	{}	{"cover; lid; cap"}	\N
外出	がいしゅつ	{自宅や勤め先などから、よそへ出かけること。「急用でーする」}	{"go outside;"}	\N
外相	がいしょう	{}	{"Foreign Minister"}	\N
外国人登録証	がいこくじんとうろくしょう	{外国人登録法に基づいて、日本に在留する外国人に交付された証明書。市区町村が発行し、常時携帯が義務づけられていた。平成24年（2012）同法廃止に伴い、法務省が交付する在留カードと特別永住者証明書に切り替わった。}	{"alien registration"}	\N
害する	がいする	{}	{"to injure; to damage; to harm; to kill; to hinder"}	\N
概説	がいせつ	{}	{"general statement; outline"}	\N
街頭	がいとう	{}	{"in the street"}	\N
該当	がいとう	{}	{"corresponding; answering to; coming under"}	\N
概念	がいねん	{}	{"general idea; concept; notion"}	\N
外部	がいぶ	{}	{"the outside; external"}	\N
概要	がいよう	{全体の要点をとりまとめたもの。大要。あらまし。「事件の―」}	{"an outline; a summary ((of))⇒がいりゃく(概略)"}	\N
外来	がいらい	{}	{"imported; outpatient clinic"}	\N
概略	がいりゃく	{}	{"outline; summary; gist; in brief"}	\N
概論	がいろん	{}	{"introduction; outline; general remarks"}	\N
画家	がか	{}	{"painter; artist"}	\N
学	がく	{}	{"learning; scholarship; erudition; knowledge"}	\N
学芸	がくげい	{}	{"arts and sciences; liberal arts"}	\N
学士	がくし	{}	{"university graduate"}	\N
学者	がくしゃ	{}	{scholar}	\N
学習	がくしゅう	{}	{"study; learning"}	\N
学術	がくじゅつ	{}	{"science; learning; scholarship"}	\N
学生	がくせい	{}	{student}	\N
学説	がくせつ	{}	{theory}	\N
学年	がくねん	{}	{"year in school; grade in school"}	\N
楽譜	がくふ	{}	{"score (music)"}	\N
学部	がくぶ	{}	{"department of a university; undergraduate"}	\N
額縁	がくぶち	{}	{frame}	\N
学問	がくもん	{}	{"scholarship; study; learning"}	\N
学力	がくりょく	{}	{"scholarship; knowledge; literary ability"}	\N
学歴	がくれき	{}	{"academic background"}	\N
崖	がけ	{}	{cliff}	\N
雅致	がち	{}	{"artistry; good taste; elegance; grace"}	\N
学科	がっか	{科目。課程。}	{department}	\N
学会	がっかい	{}	{"scientific society; academic meeting"}	\N
がっかり	がっかり	{元気を出せ・失望する様子}	{disappointed}	\N
楽器	がっき	{}	{"musical instrument"}	\N
学期	がっき	{}	{"school term"}	\N
学級	がっきゅう	{}	{"grade in school"}	\N
学校	がっこう	{}	{school}	\N
合唱	がっしょう	{}	{"chorus; singing in a chorus"}	\N
合致	がっち	{}	{"agreement; concurrence; conforming to"}	\N
合併	がっぺい	{}	{"combination; union; amalgamation; consolidation; merger; coalition; fusion; annexation; affiliation; incorporation"}	\N
我慢	がまん	{}	{"patience; endurance; perseverance; tolerance; self-control; self-denial"}	\N
画面	がめん	{描かれている絵の表面。}	{"〔映画・テレビなどの〕a screen"}	\N
硝子	がらす	{}	{glass}	\N
絡み	がらみ	{密接に関連していること。また、入り組んだ関係。「予算との―があって実現は難しい」→がらみ}	{"about / concerning / related to;"}	\N
眼科	がんか	{}	{ophthalmology}	\N
眼球	がんきゅう	{}	{eyeball}	\N
頑固	がんこ	{}	{"stubbornness; obstinacy"}	\N
願書	がんしょ	{}	{"written application or petition"}	\N
頑丈	がんじょう	{}	{"solid; firm; stout; burly; strong; sturdy"}	\N
岩石	がんせき	{}	{rock}	\N
元年	がんねん	{}	{"first year (of a specific reign)"}	\N
原点	げんてん	{}	{"origin (coordinates); starting point"}	\N
額	がく	{}	{"picture (framed); amount (of money)"}	\N
月日	がっぴ	{}	{"(the) date"}	\N
柄	がら	{}	{"pattern; design"}	\N
側	がわ	{}	{"side; row; surroundings; part; (watch) case"}	\N
眼鏡	がんきょう	{}	{"spectacles; glasses"}	\N
頑張る	がんばる	{困難にめげないで我慢してやり抜く。「一致団結して―・る」}	{"〔踏ん張る〕hold out; hang on"}	\N
贋物	がんぶつ	{}	{"imitation; counterfeit; forgery; sham"}	\N
元来	がんらい	{}	{"originally; primarily; essentially; logically; naturally"}	\N
芸術	げいじゅつ	{}	{"fine art; the arts"}	\N
芸能	げいのう	{}	{"public entertainment; accomplishments; attainments"}	\N
迎賓館	げいひんかん	{}	{"reception hall"}	\N
外科	げか	{}	{"surgical department"}	\N
劇	げき	{}	{"performance; play"}	\N
激辛	げきから	{}	{"spicy; hot (spice)"}	\N
劇作	げきさく	{演劇の脚本をつくること。また、その脚本。}	{"play writing"}	\N
劇作家	げきさく	{演劇の脚本や戯曲を書くことを職業とする人。}	{"a playwright; a dramatist"}	\N
劇場	げきじょう	{}	{theatre}	\N
激増	げきぞう	{}	{"sudden increase"}	\N
劇団	げきだん	{}	{"troupe; theatrical company"}	\N
激励	げきれい	{}	{encouragement}	\N
下車	げしゃ	{}	{"alighting; getting off"}	\N
下宿	げしゅく	{}	{lodge}	\N
下旬	げじゅん	{月の21日から末日までの間}	{"last third of month"}	\N
下水	げすい	{}	{"drainage; sewage; ditch; gutter"}	\N
下駄	げた	{}	{"wooden clogs"}	\N
月下	げっか	{}	{"late; under the moon; in the moonlight"}	\N
月給	げっきゅう	{}	{"monthly salary"}	\N
月謝	げっしゃ	{}	{"monthly tuition fee"}	\N
月賦	げっぷ	{}	{"monthly installment"}	\N
月末	げつまつ	{}	{"end of the month"}	\N
月曜	げつよう	{}	{Monday}	\N
月曜日	げつようび	{}	{Monday}	\N
下痢	げり	{}	{diarrhoea}	\N
原因	げんいん	{ある物事や、ある状態・変化を引き起こすもとになること。また、その事柄。「失敗の―をつきとめる」「不注意に―する事故」「―不明の病気」⇔結果。}	{cause}	\N
限界	げんかい	{}	{"limit; bound"}	\N
弦楽	げんがく	{}	{"(musical instrument) string"}	\N
玄関	げんかん	{}	{"entranceway; entry hall"}	\N
元気	げんき	{}	{"health(y); robust; vigor; energy; vitality; vim; stamina; spirit; courage; pep"}	\N
現金	げんきん	{}	{"cash; ready money; mercenary; self-interested"}	\N
原形	げんけい	{}	{"original form; base form"}	\N
言語	げんご	{}	{language}	\N
原稿	げんこう	{}	{"manuscript; copy"}	\N
現行	げんこう	{}	{"present; current; in operation"}	\N
元号	げんごう	{}	{"period (of e.g. power)"}	\N
現在	げんざい	{}	{"present; up to now; nowadays; modern times; current"}	\N
原作	げんさく	{}	{"original work"}	\N
原産	げんさん	{最初に産出したこと。また、したもの。「ヒマラヤ―の品種」}	{"place of origin; habitat"}	\N
原子	げんし	{}	{atom}	\N
原始	げんし	{}	{"origin; primeval"}	\N
現実	げんじつ	{}	{reality}	\N
現時点	げんじてん	{現在の時点。今 (いま) 現在。「―でははっきりしたことは言えない」}	{"〜で at present; at this time [stage]"}	\N
元首	げんしゅ	{}	{"ruler; sovereign"}	\N
厳重	げんじゅう	{}	{"strict; severe; firm; strong; secure; rigour"}	\N
原書	げんしょ	{}	{"original document"}	\N
減少	げんしょう	{}	{"decrease; reduction; decline"}	\N
現象	げんしょう	{}	{phenomenon}	\N
現状	げんじょう	{}	{"present condition; existing state; status quo"}	\N
現職	げん‐しょく	{現在、ある職務に就いていること。また、その職業や職務。「―の警官」}	{"one's (present) post [office]"}	\N
現職者	げんしょくしゃ	{}	{"an incumbent (the holder of an office or post.)"}	\N
元帥	げんすい	{}	{"marshal; admiral"}	\N
元素	げんそ	{}	{"chemical element"}	\N
現像	げんぞう	{}	{"developing (film)"}	\N
原則	げんそく	{}	{"principle; general rule"}	\N
現代	げんだい	{}	{"nowadays; modern times; present-day"}	\N
現地	げんち	{}	{"actual place; local"}	\N
限定	げんてい	{}	{"limit; restriction"}	\N
減点	げんてん	{}	{"subtract; give a demerit"}	\N
限度	げんど	{}	{"limit; bounds"}	\N
現に	げんに	{}	{"actually; really"}	\N
原爆	げんばく	{}	{"atomic bomb"}	\N
原発	げんぱつ	{原子炉で発生した熱エネルギーで蒸気をつくり、タービン発電機を運転して発電する方法。原発 (げんぱつ) 。}	{"「原子力発電」「原子力発電所」の略。nuclear power"}	\N
原文	げんぶん	{}	{"the text; original"}	\N
玄米	げんまい	{}	{"brown rice"}	\N
厳密	げんみつ	{}	{"strict; close"}	\N
原油	げんゆ	{}	{"crude oil"}	\N
原理	げんり	{}	{"principle; theory; fundamental truth"}	\N
原料	げんりょう	{}	{"raw materials"}	\N
言論	げんろん	{}	{discussion}	\N
疑惑	ぎわく	{本当かどうか、不正があるのではないかなどと疑いをもつこと。また、その気持ち。疑い。ダウト「ーの目で見る」}	{doubt}	\N
議案	ぎあん	{}	{"legislative bill"}	\N
議員	ぎいん	{}	{"member of the Diet; congress or parliament"}	\N
議会	ぎかい	{}	{"Diet; congress; parliament"}	\N
戯曲	ぎきょく	{}	{"play; drama"}	\N
議決	ぎけつ	{}	{"resolution; decision; vote"}	\N
技師	ぎし	{}	{"engineer; technician"}	\N
儀式	ぎしき	{}	{"ceremony; rite; ritual; service"}	\N
議事堂	ぎじどう	{}	{"Diet building"}	\N
技術	ぎじゅつ	{}	{technique}	\N
犠牲	ぎせい	{}	{sacrifice}	\N
偽造	ぎぞう	{}	{"forgery; falsification; fabrication; counterfeiting"}	\N
議題	ぎだい	{}	{"topic of discussion; agenda"}	\N
議長	ぎちょう	{}	{chairman}	\N
技能	ぎのう	{}	{"technical skill; ability; capacity"}	\N
義務	ぎむ	{}	{"duty; obligation; responsibility"}	\N
疑問	ぎもん	{本当かどうか、正しいかどうか、疑わしいこと。また、その事柄。「学説にーをいだく」「本物であるかどうかはーだ」}	{"question; problem; doubt; guess"}	\N
逆	ぎゃく	{}	{"reverse; opposite"}	\N
虐殺	ぎゃくさつ	{}	{"slaughter; massacre"}	\N
逆算	ぎゃくさん	{逆の順序で、さかのぼって計算すること。「年齢から生年をーする」}	{"count [calculate/reckon] backward(s)"}	\N
逆境	ぎゃっきょう	{苦労の多い境遇。不運な境遇。「―にめげない」⇔順境。}	{"adverse circumstances; adversity"}	\N
牛耳る	ぎゅうじる	{団体や組織を支配し、思いのままに動かす。牛耳を執る。「党内を―・る」}	{"lead; control; take the lead (in)"}	\N
逆転	ぎゃくてん	{}	{"(sudden) change; reversal; turn-around; coming from behind (baseball)"}	\N
牛肉	ぎゅうにく	{}	{beef}	\N
牛乳	ぎゅうにゅう	{}	{"cow´s milk"}	\N
行	ぎょう	{}	{"line; row; verse"}	\N
行儀	ぎょうぎ	{}	{manners}	\N
行事	ぎょうじ	{}	{"event; function"}	\N
業者	ぎょうしゃ	{}	{"trader; merchant"}	\N
行政	ぎょうせい	{}	{administration}	\N
業績	ぎょうせき	{}	{"achievement; performance; results; work; contribution"}	\N
業務	ぎょうむ	{}	{"business; affairs; duties; work"}	\N
業務上	ぎょうむじょう	{}	{"from a business/professional point of view"}	\N
行列	ぎょうれつ	{}	{"line; procession; matrix (mathematics)"}	\N
御苑	ぎょえん	{}	{"imperial garden"}	\N
漁業	ぎょぎょう	{}	{"fishing (industry)"}	\N
漁船	ぎょせん	{}	{"fishing boat"}	\N
漁村	ぎょそん	{}	{"fishing village"}	\N
魚肉	ぎょにく	{}	{"fish meat"}	\N
義理	ぎり	{}	{"duty; sense of duty; honor; decency; courtesy; debt of gratitude; social obligation"}	\N
議論	ぎろん	{}	{"argument; discussion; dispute"}	\N
銀	ぎん	{}	{silver}	\N
銀行	ぎんこう	{}	{bank}	\N
吟味	ぎんみ	{}	{"testing; scrutiny; careful investigation"}	\N
五	ご	{}	{five}	\N
伍	ご	{}	{"V; roman five"}	\N
語	ご	{}	{"language; word"}	\N
碁	ご	{}	{"go (board game)"}	\N
現場	げんば	{}	{"actual spot; scene; scene of the crime"}	\N
後	ご	{}	{after}	\N
御	ご	{}	{"go-; honourable"}	\N
牛	ぎゅう	{}	{cow}	{動物}
号	ごう	{}	{"number; issue"}	\N
業	ごう	{}	{"Buddhist karma; actions committed in a former life"}	\N
合意	ごうい	{}	{"agreement; consent; mutual understanding"}	\N
強引	ごういん	{}	{"overbearing; coercive; pushy; high-handed"}	\N
豪華	ごうか	{}	{"wonderful; gorgeous; splendor; pomp; extravagance"}	\N
合格	ごうかく	{}	{"success; passing (e.g. exam); eligibility"}	\N
合議	ごうぎ	{}	{"consultation; conference"}	\N
合計	ごうけい	{二つ以上の数値を合わせまとめること。}	{"the sum total; a total"}	\N
剛健	ごうけん	{男性的で、心身が強くたくましいこと。また、そのさま。「勤勉で―な気風」「質実―」}	{"sturdiness; 〜な strong and sturdy"}	\N
合成	ごうせい	{}	{"synthesis; composition; synthetic; composite; mixed; combined; compound"}	\N
強奪	ごうだつ	{暴力や脅迫などで、強引に奪い取ること。きょうだつ。「現金を―する」}	{robbery}	\N
強盗	ごうとう	{}	{"robbery; burglary"}	\N
合同	ごうどう	{}	{"combination; incorporation; union; amalgamation; fusion; congruence"}	\N
合法	ごうほう	{法規にかなっていること。適法。⇔不法。}	{"合法的: lawful; legal"}	\N
傲慢	ごうまん	{}	{arrogant}	\N
拷問	ごうもん	{}	{torture}	\N
合理	ごうり	{}	{rational}	\N
合流	ごうりゅう	{}	{"confluence; union; linking up; merge"}	\N
護衛	ごえい	{}	{"guard; convoy; escort"}	\N
呉音	ごおん	{古く日本に入った漢字音の一。もと、和音とよばれていたが、平安中期以後、呉音ともよばれるようになった。北方系の漢音に対して南方系であるといわれる。仏教関係の語などに多く用いられる。}	{"first import of kanji (5-600 Southern and Northern Dynasties)"}	\N
誤解	ごかい	{ある事実について、まちがった理解や解釈をすること。相手の言葉などの意味を取り違えること。思い違い。「ーを招く」「ーを解く」}	{misunderstanding}	\N
語学	ごがく	{}	{"language study"}	\N
五月	ごがつ	{}	{May}	\N
ご期待に添えず	ごきたいにそえず	{}	{"not live up to expectations"}	\N
語句	ごく	{}	{"words; phrases"}	\N
極	ごく	{普通の程度をはるかに越えているさま。きわめて。非常に。「―親しい間柄」}	{"pole; climax; extreme; extremity; culmination; height; zenith; nadir"}	\N
ごく	極	{普通の程度をはるかに越えているさま。きわめて。非常に。「―親しい間柄」}	{"most; extremely; quite (natural); very (first)"}	\N
極普通	ごくふつう	{}	{"very common; quite usual; very (interesting)"}	\N
ごく普通	ごくふつう	{}	{"very common; quite usual; very (interesting)"}	\N
極秘裏	ごくひり	{他人に知られないようにして。人に知られないうちに。}	{secretly}	\N
極楽	ごくらく	{}	{paradise}	\N
ご苦労様	ごくろうさま	{}	{"Thank you very much for your...."}	\N
御苦労様	ごくろうさま	{「ご苦労様」は目上の人から目下の人に使うのに対し、「お疲れ様」は同僚、目上の人に対して使う。}	{"Keep up the good work"}	\N
語源	ごげん	{}	{"word root; word derivation; etymology"}	\N
午後	ごご	{}	{"afternoon; P.M."}	\N
誤差	ごさ	{}	{error}	\N
ご座います	ございます	{}	{"to be (polite); to exist"}	\N
御座います	ございます	{}	{"to be (polite); to exist"}	\N
誤算	ごさん	{}	{miscalculation}	\N
御神体	ごしんたい	{}	{"the object of worship in a Shinto shrine"}	\N
ご存知	ごぞんじ	{}	{acquaintance}	\N
五十音	ごじゅうおん	{}	{"the Japanese syllabary"}	\N
御愁傷様	ごしゅうしょうさま	{身内を失った人に対するお悔やみの語。}	{"My condolences"}	\N
御主人	ごしゅじん	{}	{"(polite) your husband; her husband"}	\N
午前	ごぜん	{}	{"morning; A.M."}	\N
ご存じ	ごぞんじ	{}	{know}	\N
御馳走	ごちそう	{}	{"feast; treating (someone)"}	\N
ご馳走さま	ごちそうさま	{}	{feast}	\N
毎	ごと	{（「ごとに」の形で用いられることが多い）名詞や動詞の連体形などに付いて、その事をするたびに、そのいずれもが、などの意を表す。…のたびに。どの…もみな。「年―に」「会う人―に」}	{"each respectively"}	\N
五人	ごにん	{}	{"5 people"}	\N
御飯	ごはん	{}	{"rice (cooked); meal"}	\N
碁盤	ごばん	{}	{"Go board"}	\N
御飯粒	ごはんつぶ	{めし粒を丁寧にいう語。飯のつぶ。ごはんつぶ。}	{"a grain of cooked rice"}	\N
ご無沙汰	ごぶさた	{}	{"not writing or contacting for a while"}	\N
誤魔化す	ごまかす	{}	{"to deceive; to falsify; to misrepresent"}	\N
御明察	ごめいさつ	{相手を敬って、その推察をいう語。「―恐れ入ります」}	{"〔はっきり見極めること〕discernment; 〔洞察〕perception; insight"}	\N
ご明察	ごめいさつ	{相手を敬って、その推察をいう語。「―恐れ入ります」}	{"〔はっきり見極めること〕discernment; 〔洞察〕perception; insight"}	\N
御免	ごめん	{}	{"your pardon; declining (something); dismissal; permission"}	\N
御免ください	ごめんください	{}	{"May I come in?"}	\N
御免なさい	ごめんなさい	{}	{"I beg your pardon; excuse me"}	\N
娯楽	ごらく	{}	{"pleasure; amusement"}	\N
御覧	ごらん	{}	{"look; inspection; try"}	\N
御覧なさい	ごらんなさい	{}	{"(please) look; (please) try to do"}	\N
五輪	ごりん	{}	{olympics}	\N
愚	ぐ	{おろかなこと。ばかげたこと。}	{"folly; foolishness"}	\N
具体的	ぐたいてき	{はっきりとした実体を備えているさま。個々の事物に即しているさま。反：抽象的。}	{concrete(ly)}	\N
具合	ぐあい	{}	{condition}	\N
偶数	ぐうすう	{}	{"even number"}	\N
偶然	ぐうぜん	{}	{"chance; accident; fortuity; unexpectedly; suddenly"}	\N
愚図愚図	ぐずぐず	{のろのろといたずらに時間を費やすさま。「借金の返済を―（と）引き延ばす」}	{"~と slowly; tardily; 〔ためらって〕hesitantly; hesitatingly"}	\N
具体	ぐたい	{}	{"concrete; tangible; material"}	\N
愚痴	ぐち	{}	{"idle complaint; grumble"}	\N
紅蓮	ぐれん	{}	{"red lotus"}	\N
群	ぐん	{}	{"group (math)"}	\N
郡	ぐん	{}	{"country; district"}	\N
軍艦	ぐんかん	{}	{"warship; battleship"}	\N
軍事	ぐんじ	{}	{"military affairs"}	\N
群集	ぐんしゅう	{}	{"(social) group; crowd; throng; mob; multitude"}	\N
群衆	ぐんしゅう	{群がり集まった人々。群集。}	{"a crowd (of people) (▼集合体を指すときは単数，個々の構成員を指すときは複数扱い)"}	\N
軍縮	ぐんしゅく	{}	{disarmament}	\N
軍曹	ぐんそう	{}	{cadet}	\N
軍隊	ぐんたい	{}	{"army; troops"}	\N
群島	ぐんとう	{}	{archipalego}	\N
軍備	ぐんび	{}	{"armaments; military preparations"}	\N
軍服	ぐんぷく	{}	{"military or naval uniform"}	\N
葉	は	{}	{leaf}	\N
歯	は	{}	{tooth}	\N
派	は	{}	{"clique; faction; school"}	\N
肺	はい	{}	{lung}	\N
灰色	はいいろ	{}	{"grey; ashen"}	\N
拝謁	はいえつ	{}	{audience；}	\N
胚芽	はいが	{}	{"an embryo; a germ"}	\N
廃棄	はいき	{}	{"annullment; disposal; abandon; scrap; discarding; repeal"}	\N
廃棄所	はいきしょ	{}	{"disposal facility"}	\N
配給	はいきゅう	{}	{"distribution (eg. films rice)"}	\N
俳句	はいく	{}	{"17-syllable poem"}	\N
配偶者	はいぐうしゃ	{}	{"spouse; wife; husband"}	\N
背景	はいけい	{}	{"background; scenery; setting; circumstance"}	\N
拝啓	はいけい	{}	{"Dear (so and so)"}	\N
拝見	はいけん	{見ることをへりくだっていう語。謹んで見ること。}	{"have a look at; see"}	\N
拝観	はいかん	{}	{admission}	\N
背後	はいご	{}	{"back; rear"}	\N
排斥	はいせき	{}	{exclussion}	\N
廃止	はいし	{}	{"abolition; repeal"}	\N
歯医者	はいしゃ	{}	{dentist}	\N
拝借	はいしゃく	{}	{borrowing}	\N
排除	はいじょ	{望ましくないとして除去する}	{"exclusion; removal; rejection"}	\N
灰皿	はいざら	{}	{ashtray}	\N
軍	ぐん	{}	{"army; force; troops"}	\N
刃	は	{刃物のふちの薄くて鋭い、物を切ったり削ったりする部分。「刀の―がこぼれる」}	{"an edge; 〔刀などの〕a blade"}	\N
灰	はい	{}	{ash}	\N
排水	はいすい	{}	{drainage}	\N
排水溝	はいすいこう	{耕地や道路などの水を排除するためのみぞ。}	{"a drain; a drainage ditch; 〔機械などの水口〕a waterway"}	\N
敗戦	はいせん	{}	{"defeat; losing a war"}	\N
配達	はいたつ	{}	{"delivery; distribution"}	\N
配置	はいち	{人や物をそれぞれの位置・持ち場に割り当てて置くこと。また、その位置・持ち場。「全員―に就く」「席の―を決める」「要員を―する」}	{"arrangement (of resources); disposition"}	\N
配布	はいふ	{配って広く行き渡らせること。配る。配付。渡す。「駅前でちらしをーする」}	{distribution}	\N
配分	はいぶん	{}	{"distribution; allotment"}	\N
俳優	はいゆう	{}	{"actor; actress; player; performer"}	\N
配慮	はいりょ	{}	{"consideration; concern; forethought"}	\N
配列	はいれつ	{}	{"arrangement; array (programming)"}	\N
生える	はえる	{}	{"grow; spring up"}	\N
映える	はえる	{}	{"to shine; to look attractive; to look pretty"}	\N
墓	はか	{}	{"gravesite; tomb"}	\N
破壊	はかい	{}	{destruction}	\N
葉書	はがき	{}	{postcard}	\N
剥がす	はがす	{}	{"to tear off; to peel off; to rip off; to strip off; to skin; to flay; to disrobe; to deprive of; to detach; to disconnect"}	\N
剥す	はがす	{}	{"tear off; peel off; rip off; strip off; skin; flay; disrobe; deprive of; detach; disconnect"}	\N
博士	はかせ	{}	{"doctorate; PhD"}	\N
墓地	はかち	{}	{"cemetery; graveyard"}	\N
捗る	はかどる	{}	{"to make progress; to move right ahead (with the work); to advance"}	\N
果ない	はかない	{}	{"fleeting; transient; short-lived; momentary; vain; fickle; miserable; empty; ephemeral"}	\N
鋼	はがね	{}	{steel}	\N
墓参り	はかまいり	{"墓に参って拝むこと。特に、盂蘭盆 (うらぼん) に先祖の墓にお参りすること。墓詣で。ぼさん。《季 秋》"}	{"a visit to a grave"}	\N
量る	はかる	{}	{"to measure; to weigh; to survey; to time (sound gauge estimate)"}	\N
計る	はかる	{}	{"to measure; to weigh; to survey; to time (sound gauge estimate)"}	\N
諮る	はかる	{}	{"to consult with; to confer"}	\N
図る	はかる	{}	{"to plot; to attempt; to plan; to take in; to deceive; to devise; to design; to refer A to B"}	\N
測る	はかる	{ある基準をもとにして物の度合いを調べる。「体温を―・る」「距離を―・る」}	{"measure; fathom"}	\N
破棄	はき	{}	{"revocation; annulment; breaking (e.g. treaty)"}	\N
吐き気	はきけ	{}	{"nausea; sickness in the stomach"}	\N
泊	はく	{}	{"counter for nights of a stay"}	\N
履く	はく	{}	{"to wear; to put on (lower body)"}	\N
掃く	はく	{}	{"to brush; sweep; gather up"}	\N
剥ぐ	はぐ	{}	{"to tear off; to peel off; to rip off; to strip off; to skin; to flay; to disrobe; to deprive of"}	\N
白衣	はくい	{}	{"white lab coat"}	\N
迫害	はくがい	{}	{persecution}	\N
伯爵	はくしゃく	{}	{count}	\N
薄弱	はくじゃく	{}	{"feebleness; weakness; weak"}	\N
拍手	はくしゅ	{}	{"clapping hands; applause"}	\N
白状	はくじょう	{}	{confession}	\N
博物館	はくぶつかん	{}	{museum}	\N
歯車	はぐるま	{}	{"gear; cog-wheel"}	\N
禿	はげ	{毛髪が抜け落ちている部分。また、抜け落ちている状態。}	{baldness}	\N
ハゲ	禿	{毛髪が抜け落ちている部分。また、抜け落ちている状態。}	{baldness}	\N
激しい	はげしい	{}	{"violent; vehement; intense; furious; tempestuous"}	\N
励ます	はげます	{}	{"to encourage; to cheer; to raise (the voice)"}	\N
励む	はげむ	{}	{"to be zealous; to brace oneself; to endeavour; to strive; to make an effort"}	\N
剥げる	はげる	{}	{"to come off; to be worn off; to fade; to discolor"}	\N
派遣	はけん	{}	{"dispatch; send"}	\N
箱	はこ	{}	{box}	\N
運ぶ	はこぶ	{}	{bring}	\N
挟まる	はさまる	{}	{"get between; be caught in"}	\N
挟む	はさむ	{}	{"interpose; hold between; insert"}	\N
破産	はさん	{}	{"(personal) bankruptcy"}	\N
橋	はし	{}	{bridge}	\N
端	はし	{}	{"edge; tip; margin; point; end (e.g. of street)"}	\N
箸	はし	{}	{chopsticks}	\N
恥	はじ	{}	{"shame; embarrassment"}	\N
始まり	はじまり	{}	{"origin; beginning"}	\N
始まる	はじまる	{}	{begin}	\N
始め	はじめ	{物事を行う最も早い時期。最初のころ。副詞的にも用いる。「五月の―」「何をするにも―が肝心だ」「―から終わりまで読み通す」「―君だとは気づかなかった」}	{"start; origin"}	\N
初めて	はじめて	{}	{"for the first time"}	\N
初めに	はじめに	{}	{"in the beginning; at first"}	\N
始めに	はじめに	{}	{"in the beginning; to begin with; first of all"}	\N
始めまして	はじめまして	{}	{"How do you do?; I am glad to meet you"}	\N
始める	はじめる	{物事を行っていない状態から行う状態にする。行いだす。「早朝から作業を―・める」「戦争を―・める」⇔終える／終わる。}	{begin}	\N
柱	はしら	{}	{"pillar; post"}	\N
恥じらう	はじらう	{}	{"to feel shy; to be bashful; to blush"}	\N
恥じる	はじる	{}	{"to feel ashamed"}	\N
橋渡し	はしわたし	{}	{"bridge building; mediation"}	\N
斜	はす	{}	{"aslant; oblique; diagonal"}	\N
筈	はず	{当然そうなるべき道理であることを示す。また、その確信をもっていることを示す。〜べき「君はそれを知っているーだ」}	{"must; should; ought; supposed to;"}	\N
恥ずかしい	はずかしい	{}	{"shameful; be ashamed"}	\N
外す	はずす	{}	{"unfasten; remove"}	\N
弾む	はずむ	{}	{"to spring; to bound; to bounce; to be stimulated; to be encouraged; to get lively; to treat oneself to; to splurge on"}	\N
外れ値	はずれち	{統計学の用語で、データの全体的な傾向から大きく離れた値のこと。}	{outlier}	\N
外れる	はずれる	{}	{"be disconnected; get out of place; be off; be out (e.g. of gear)"}	\N
破損	はそん	{}	{damage}	\N
機	はた	{}	{loom}	\N
旗	はた	{}	{flag}	\N
肌	はだ	{}	{"skin; body; grain; texture; disposition"}	\N
裸	はだか	{}	{"naked; nude; bare"}	\N
肌着	はだぎ	{}	{"underwear; lingerie; singlet; chemise"}	\N
畑	はたけ	{}	{field}	\N
裸足	はだし	{}	{barefoot}	\N
果たして	はたして	{}	{"as was expected; really"}	\N
果たす	はたす	{"１ 物事を成し遂げる。「約束をー・す」「望みをー・す」２ その立場としての仕事をみごとにやってのける。"}	{"to accomplish; to fulfill; to carry out; to achieve"}	\N
二十歳	はたち	{}	{"20 years old; 20th year"}	\N
働き	はたらき	{}	{"work; workings; activity; ability; talent; function; labor; action; operation; movement; motion; conjugation; inflection; achievement"}	\N
働く	はたらく	{}	{"work; to labor; do; to act; commit; practise; work on; come into play; be conjugated; reduce the price"}	\N
八	はち	{}	{eight}	\N
鉢	はち	{}	{"bowl; pot; basin"}	\N
八月	はちがつ	{}	{Aug}	\N
蜂蜜	はちみつ	{}	{honey}	\N
初	はつ	{}	{"first; new"}	\N
発	はつ	{}	{"departure; beginning; counter for gunshots"}	\N
発育	はついく	{}	{"(physical) growth; development"}	\N
発音	はつおん	{音声を出すこと。言語音を出すこと。また、その音声の出し方。動物では発音器官によるもののほか、魚が浮き袋を用いたりキツツキが木をたたいたりして音をたてることにもいう。「正しくーする」}	{pronunciation}	\N
二十日	はつか	{}	{"twenty days; twentieth day of the month"}	\N
発芽	はつが	{}	{burgeoning}	\N
発揮	はっき	{}	{"exhibition; demonstration; utilization; display"}	\N
発掘	はっくつ	{}	{"excavation; exhumation"}	\N
発見	はっけん	{まだ知られていなかったものを見つけ出すこと。また、わからなかった存在を見いだすこと。「新大陸の―」「犯人のアジトを―する」}	{discovery}	\N
発言	はつげん	{言葉を出すこと。口頭で意見を述べること。また、その言葉。はつごん。「―を求める」「会議で―する」}	{"utterance; speech; proposal"}	\N
八個	はっこ	{}	{"8 pieces"}	\N
発行	はっこう	{}	{"issue (publications)"}	\N
弾く	はじく	{}	{"to flip; to snap"}	\N
梯子	はしご	{}	{"ladder; stairs"}	\N
発酵	はっこう	{}	{"fermentation; ferment"}	\N
醗酵	はっこう	{}	{"fermentation; ferment"}	\N
発車	はっしゃ	{}	{"departure of a vehicle"}	\N
発射	はっしゃ	{}	{"firing; shooting; discharge; catapult"}	\N
発信	はっしん	{電信や電波を発すること。「SOSを―する」⇔受信。}	{transmission}	\N
発信機	はっしんき	{通信信号を発する装置の総称。}	{"a transmitter"}	\N
発信機用	はっしんきよう	{}	{transmitter-using}	\N
発生	はっせい	{物事が起こること。生じること。「熱が―する」「事件が―する」}	{"outbreak; spring forth; occurrence; incidence; origin"}	\N
発想	はっそう	{}	{"expression (music); conceptualization"}	\N
発足	はっそく	{}	{"starting; inauguration"}	\N
発達	はったつ	{}	{"development; growth"}	\N
発展	はってん	{}	{"development; growth"}	\N
発電	はつでん	{}	{"generation (e.g. power)"}	\N
発売	はつばい	{}	{sale}	\N
発病	はつびょう	{}	{"attack (disease)"}	\N
発表	はっぴょう	{}	{"announcement; publication"}	\N
初耳	はつみみ	{}	{"something heard for the first time"}	\N
発明	はつめい	{}	{invention}	\N
果て	はて	{}	{"the end; the extremity; the limit(s); the result"}	\N
派手	はで	{}	{"showy; loud; gay; flashy; gaudy"}	\N
果てる	はてる	{}	{"to end; to be finished; to be exhausted; to die; to perish"}	\N
鼻	はな	{}	{nose}	\N
花	はな	{}	{flower}	\N
花盛り	はなざかり	{花が咲きそろっていること。また、その季節。}	{"full bloom"}	\N
話	はなし	{}	{"talk; speech; chat; story; conversation"}	\N
話し合い	はなしあい	{}	{"discussion; conference"}	\N
話し合う	はなしあう	{}	{"discuss; talk together"}	\N
話し掛ける	はなしかける	{}	{"accost a person; talk (to someone)"}	\N
話中	はなしちゅう	{}	{"while talking; the line is busy"}	\N
話す	はなす	{}	{speak}	\N
放す	はなす	{}	{"separate; set free; turn loose"}	\N
離す	はなす	{}	{"part; divide; separate"}	\N
甚だ	はなはだ	{}	{"very; greatly; exceedingly"}	\N
甚だしい	はなはだしい	{}	{"extreme; excessive; terrible; intense; severe; serious; tremendous"}	\N
華々しい	はなばなしい	{}	{"brilliant; magnificent; spectacular"}	\N
花火	はなび	{}	{fireworks}	\N
花びら	はなびら	{}	{"(flower) petal"}	\N
花見	はなみ	{}	{"cherry blossom viewing; flower viewing"}	\N
華やか	はなやか	{}	{"gay; showy; brilliant; gorgeous; florid"}	\N
花嫁	はなよめ	{}	{bride}	\N
放れる	はなれる	{}	{"leave; get free; cut oneself off"}	\N
離れる	はなれる	{}	{"be separated from; leave; go away; be a long way off"}	\N
羽	はね	{}	{"feather; wing"}	\N
羽根	はね	{}	{shuttlecock}	\N
跳ねる	はねる	{}	{"jump; leap; prance; spring up; bound; hop"}	\N
母	はは	{親のうち、女性のほう。実母・義母・継母の総称。母親。おんなおや。⇔父。}	{"〔母親〕one's mother"}	\N
幅	はば	{}	{"width; breadth"}	\N
母親	ははおや	{}	{mother}	\N
派閥	はばつ	{一党}	{"faction; political faction"}	\N
阻む	はばむ	{}	{"to keep someone from doing; to stop; to prevent; to check; to hinder; to obstruct; to oppose; to thwart"}	\N
省く	はぶく	{}	{"omit; eliminate; curtail; economize"}	\N
破片	はへん	{}	{"fragment; splinter; broken piece"}	\N
浜	はま	{}	{"beach; seashore"}	\N
浜辺	はまべ	{}	{"beach; foreshore"}	\N
填まる	はまる	{}	{"to get into; to go into; to fit; to be fit for; to suit; to fall into; to plunge into; to be deceived; to be taken in; to fall into a trap; to be addicted to; to be deep into"}	\N
歯磨き	はみがき	{}	{"dentifrice; toothpaste"}	\N
歯磨き粉	はみがきこ	{}	{"dentifrice; toothpaste"}	\N
刃物	はもの	{切り物}	{cutlery}	\N
早い	はやい	{}	{early}	\N
速い	はやい	{}	{"quick; fast; swift"}	\N
早口	はやくち	{}	{fast-talking}	\N
林	はやし	{}	{"woods; forest"}	\N
生やす	はやす	{}	{"to grow; to cultivate; to wear beard"}	\N
早める	はやめる	{}	{"to hasten; to quicken; to expedite; to precipitate; to accelerate"}	\N
流行る	はやる	{}	{"flourish; thrive; be popular; come into fashion"}	\N
腹	はら	{}	{"abdomen; belly; stomach"}	\N
払い込む	はらいこむ	{}	{"deposit; pay in"}	\N
払い戻す	はらいもどす	{}	{"repay; pay back"}	\N
払う	はらう	{}	{pay}	\N
腹立ち	はらだち	{}	{anger}	\N
原っぱ	はらっぱ	{}	{"open field; empty lot; plain"}	\N
波乱	はらん	{大小の波。波濤 (はとう) 。}	{eventful}	\N
針	はり	{}	{"needle; fish hook; pointer; hand (clock)"}	\N
針金	はりがね	{}	{wire}	\N
張り紙	はりがみ	{}	{"paper patch; paper backing; poster"}	\N
張り切る	はりきる	{}	{"be in high spirits; be full of vigor; be enthusiastic; be eager; stretch to breaking point"}	\N
貼り付け	はりつけ	{}	{paste}	\N
春	はる	{}	{spring}	\N
張る	はる	{}	{"to stick; paste; put; affix; stretch; spread; strain; stick out; slap; be expensive; tighten"}	\N
貼る	はる	{}	{"to stick; paste"}	\N
晴れ	はれ	{}	{"clear weather"}	\N
破裂	はれつ	{}	{"explosion; rupture; break off"}	\N
晴れる	はれる	{}	{"be sunny; clear away; stop raining"}	\N
腫れる	はれる	{}	{"to swell (from inflammation); to become swollen"}	\N
半	はん	{}	{half}	\N
版	はん	{}	{edition}	\N
班	はん	{}	{"group; party; section (mil)"}	\N
藩	はん	{}	{"a han; a feudal clan; 〔領地〕a feudal domain"}	\N
犯	はん	{}	{~crime}	\N
範囲	はんい	{ある一定の限られた広がり「できる―で協力する」}	{"scope (of influence); range (of possibility); sphere (of contacts); extent"}	\N
繁栄	はんえい	{}	{"prospering; prosperity; thriving; flourishing"}	\N
版画	はんが	{}	{"art print"}	\N
反感	はんかん	{}	{"antipathy; revolt; animosity"}	\N
反響	はんきょう	{}	{"echo; reverberation; repercussion; reaction; influence"}	\N
半径	はんけい	{}	{radius}	\N
反撃	はんげき	{}	{"counterattack; counteroffensive; counterblow"}	\N
判決	はんけつ	{}	{"judicial decision; judgement; sentence; decree"}	\N
判子	はんこ	{}	{"seal (used for signature)"}	\N
反抗	はんこう	{}	{"opposition; resistance; insubordination; defiance; hostility; rebellion"}	\N
犯行	はんこう	{}	{crime}	\N
犯罪	はんざい	{}	{crime}	\N
判事	はんじ	{}	{"judge; judiciary"}	\N
反射	はんしゃ	{媒質中を進む光・音などの波動が、媒質の境界面に当たって向きを変え、もとの媒質に戻って進むこと。「声が山に―してこだまする」}	{reflection}	\N
反射神経	はんしゃしんけい	{}	{reflexes}	\N
繁盛	はんじょう	{}	{"prosperity; flourishing; thriving"}	\N
繁殖	はんしょく	{}	{"breed; multiply; increase; propagation"}	\N
半身	はんしん	{}	{"half body"}	\N
半身浴	はんしんよく	{みぞおち辺りまでの下半身を、ぬるめの湯につける温浴法。水圧から上半身を解放して心臓の負担を軽減したり、血行をよくしたりする。}	{"bathe the lower part of the body"}	\N
反する	はんする	{}	{"to be inconsistent with; to oppose; to contradict; to transgress; to rebel"}	\N
反省	はんせい	{自分のしてきた言動をかえりみて、その可否を改めて考えること。「常に―を怠らない」「一日の行動を―してみる」}	{"reflection; reconsideration; introspection; meditation; contemplation"}	\N
反対	はんたい	{ある意見などに対して逆らい、同意しないこと。否定的であること。「君の意見には―だ」「法案に―する」「党内の―派」⇔賛成。}	{oppose}	\N
変異	へんい	{}	{mutation}	\N
流行	はやり	{}	{"fashionable; fad; in vogue; prevailing"}	\N
原	はら	{}	{"field; plain; prairie; tundra; moor; wilderness"}	\N
判	はん	{}	{"seal; stamp; monogram signature; judgment"}	\N
反対派	はんたいは	{ある意見などに対して逆らい、同意しないの派。}	{"demostration opponents; an opposition faction"}	\N
繁体字	はんたいじ	{}	{"traditional character (of kanji in China)"}	\N
判断	はんだん	{}	{"judgement; decision; adjudication; conclusion; decipherment; divination"}	\N
判定	はんてい	{}	{"judgement; decision; award; verdict"}	\N
半島	はんとう	{}	{peninsula}	\N
犯人	はんにん	{}	{"offender; criminal"}	\N
反応	はんのう	{}	{"reaction; response"}	\N
販売	はんばい	{}	{"sale; selling; marketing"}	\N
反発	はんぱつ	{}	{"repelling; rebound; recover; oppose"}	\N
半発酵	はんはっこう	{}	{semi-oxidation}	\N
半端	はんぱ	{あるまとまった量・数がそろっていないこと。また、そのさまや、そのもの。「―が出る」「―な布」}	{"〔数量がそろわないこと〕〜物 〔そろわない物〕an odd piece [article]; 〔総称〕odds and ends; remnant; fragment; incomplete set; fraction; odd sum; incompleteness"}	\N
半端無い	はんぱない	{俗に、中途半端ではなく、徹底しているさま。程度がはなはだしいさま。ものすごい。すごく。「あの店のラーメンは量が―・い」}	{"extensive; a lot"}	\N
半分	はんぶん	{}	{half}	\N
反乱	はんらん	{}	{"insurrection; mutiny; rebellion; revolt; uprising"}	\N
氾濫	はんらん	{}	{"overflowing; flood"}	\N
販路	はんろ	{}	{"sales channels"}	\N
塀	へい	{}	{"wall; fence"}	\N
兵	へい	{戦闘に従事する者。軍人。兵士。「―を集める」}	{"a soldier"}	\N
陛下	へいか	{天皇・皇后・皇太后}	{"(your) highness"}	\N
閉会	へいかい	{}	{closure}	\N
兵器	へいき	{}	{"arms; weapons; ordinance"}	\N
平気	へいき	{}	{"coolness; calmness; composure; unconcern"}	\N
閉口	へいこう	{}	{"shut mouth"}	\N
平行	へいこう	{}	{"(going) side by side; concurrent; abreast; at the same time; occurring together; parallel; parallelism"}	\N
平衡	へいこう	{物のつりあいがとれていること。均衡。「からだのーを失う」}	{"balance; equilibrium"}	\N
並行	へいこう	{}	{"(going) side by side; concurrent; abreast; at the same time; occurring together; parallel; parallelism"}	\N
閉鎖	へいさ	{}	{"closing; closure; shutdown; lockout; unsociable"}	\N
兵士	へいし	{}	{soldier}	\N
平日	へいじつ	{}	{"weekday; ordinary days"}	\N
平常	へいじょう	{}	{"normal; usual"}	\N
兵隊	へいたい	{}	{"soldier; sailor"}	\N
平坦	へいたん	{}	{"flat (landscape)"}	\N
閉店	へいてん	{商売をやめて店を閉じること。⇔開店。}	{"close (e.g. a store) 〔廃業する〕「close down [wind up] business; give up one's business"}	\N
閉店時間	へいてんじかん	{}	{"closing time (e.g. for a store)"}	\N
閉店時刻	へいてんじこく	{}	{"closing time"}	\N
閉腹	へいふく	{}	{"close stomach (operation)"}	\N
平方	へいほう	{}	{"square (e.g. metre); square"}	\N
平凡	へいぼん	{}	{"common; commonplace; ordinary; mediocre"}	\N
平野	へいや	{}	{"plain; open field"}	\N
並列	へいれつ	{}	{"arrangement; parallel; abreast"}	\N
平和	へいわ	{}	{"peace; harmony"}	\N
辟易	へきえき	{}	{"wince; shrink back; succumbing to; being frightened; disconcerted"}	\N
凹む	へこむ	{}	{"be dented; be indented; yield to; to give; sink; collapse; cave in; be snubbed"}	\N
下手	へた	{}	{"unskillful; poor; awkward"}	\N
隔たり	へだたり	{へだたること。また、その度合い。「十年のー」間隔。距離。差。}	{"distance; difference"}	\N
隔たる	へだたる	{}	{"to be distant"}	\N
隔てる	へだてる	{}	{"be shut out; separate; isolate"}	\N
部屋	へや	{}	{room}	\N
減らす	へらす	{}	{"abate; decrease; diminish; shorten"}	\N
謙る	へりくだる	{}	{"to deprecate oneself and praise the listener"}	\N
減る	へる	{}	{"decrease (in size or number); diminish; abate"}	\N
経る	へる	{}	{"to pass; to elapse; to experience"}	\N
辺	へん	{}	{"side; part; area; vicinity"}	\N
変	へん	{}	{strange}	\N
偏	へん	{}	{"side; left radical of a character; inclining; inclining toward; biased"}	\N
編	へん	{}	{"compilation; editing; completed poem; book; part of book"}	\N
変化	へんか	{変わり}	{change}	\N
変革	へんかく	{}	{"change; reform; revolution; upheaval; (the) Reformation"}	\N
返還	へんかん	{}	{"return; restoration"}	\N
偏屈	へんくつ	{性質がかたくなで、素直でないこと。ひねくれていること。また、そのさま。「ーな人」}	{"〔頑固な〕stubborn; 〔風変わりな〕eccentric"}	\N
偏見	へんけん	{かたよった見方・考え方。ある集団や個人に対して、客観的な根拠なしにいだかれる非好意的な先入観や判断。「―を持つ」「人種的―」}	{"prejudice; narrow view"}	\N
変更	へんこう	{決められた物事などを変えること。「計画を―する」}	{"change; modification; alteration"}	\N
返済	へんさい	{}	{repayment}	\N
遍在	へんざい	{広くあちこちにゆきわたって存在すること。「全国にーする民話」}	{"omnipresent; ubiquitous"}	\N
偏在	へんざい	{}	{maldistribution}	\N
返事	へんじ	{}	{"reply; answer"}	\N
変質	へんしつ	{ふつうとは違う病的な性質や性格。}	{"〔病的な性質〕an abnormal nature 〜的 abnormal 〜者 〔倒錯者〕a pervert"}	\N
変質者	へんしつしゃ	{性格・性質に異常があって、正常の人とは異なっている人。特に、性的に異常な人。性格異常者。}	{"〔倒錯者〕a pervert"}	\N
編集	へんしゅう	{}	{"editing; compilation; editorial (e.g. committee)"}	\N
返信	へんしん	{返事の手紙や電子メールを送ること。また、その手紙やメール。返書。「友人からのメールに―する」⇔往信。}	{"an answer; a reply ((to))"}	\N
変遷	へんせん	{}	{"change; transition; vicissitudes"}	\N
変装	へんそう	{別人にみせかけるために、風貌 (ふうぼう) や服装などを変えること。また、その変えた姿。「かつらとサングラスでーする」}	{"a disguise"}	\N
編注	へんちゅう	{}	{"Editor's Note"}	\N
返答	へんとう	{}	{reply}	\N
変動	へんどう	{}	{"change; fluctuation"}	\N
火	ひ	{}	{fire}	\N
費	ひ	{}	{"cost; expense"}	\N
非	ひ	{}	{"faulty-; non-"}	\N
悲哀	ひあい	{悲しくあわれなこと。「人生のーを感じる」}	{"sorrow; grief"}	\N
日当たり	ひあたり	{}	{"exposure to the sun; sunny place"}	\N
延いては	ひいては	{}	{"not only...but also; in addition to; consequently"}	\N
冷える	ひえる	{}	{"get cold"}	\N
被害	ひがい	{}	{damage}	\N
控室	ひかえしつ	{}	{"waiting room"}	\N
日帰り	ひがえり	{}	{"day trip"}	\N
控える	ひかえる	{}	{"to draw in; to hold back; to make notes; to be temperate in"}	\N
比較	ひかく	{}	{comparison}	\N
比較的	ひかくてき	{}	{"comparatively; relatively"}	\N
日陰	ひかげ	{}	{shadow}	\N
光	ひかり	{}	{light}	\N
光る	ひかる	{}	{"shine; glitter; be bright"}	\N
悲観	ひかん	{}	{"pessimism; disappointment"}	\N
匹	ひき	{助数詞。動物・鳥・昆虫・魚などを数えるのに用いる。上に来る語によっては「びき」「ぴき」となる。「二―の猫」}	{"head; small animal counter; roll of cloth"}	\N
引き上げる	ひきあげる	{}	{"to withdraw; to leave; to pull out; to retire"}	\N
引き揚げる	ひきあげる	{}	{"withdraw; retire"}	\N
率いる	ひきいる	{}	{"to lead; to spearhead (a group); to command (troops)"}	\N
引き受ける	ひきうける	{}	{"to undertake; to take up; to take over; to be responsible for; to guarantee; to contract (disease)"}	\N
引受る	ひきうける	{}	{"undertake; take charge of; take; accept; be responsible for; guarantee"}	\N
引き起こす	ひきおこす	{}	{"to cause"}	\N
引返す	ひきかえす	{}	{"repeat; send back; bring back; retrace one´s steps"}	\N
引き下げる	ひきさげる	{}	{"to pull down; to lower; to reduce; to withdraw"}	\N
引算	ひきざん	{}	{subtraction}	\N
引き締め	ひきしめ	{引き締めること。ゆるみやむだをなくすること。「財政の―」}	{"tightning up; restraint"}	\N
被疑者	ひぎしゃ	{犯罪の嫌疑を受けて捜査の対象となっているが、起訴されていない者}	{suspect}	\N
引きずる	ひきずる	{}	{"to seduce; to drag along; to pull; to prolong; to support"}	\N
日	ひ	{}	{day}	\N
灯	ひ	{}	{light}	\N
東	ひがし	{}	{east}	\N
引き出し	ひきだし	{}	{drawer}	\N
引き出す	ひきだす	{}	{"to pull out; to take out; to draw out; to withdraw"}	\N
引出す	ひきだす	{}	{"pull out; take out; draw out; withdraw"}	\N
引き止める	ひきとめる	{}	{"detain; restrain"}	\N
引き取る	ひきとる	{}	{"to take charge of; to take over; to retire to a private place"}	\N
引き離す	ひきはなす	{分ける・引っ張って離す。無理に離れさせる}	{"pull from (someone or something)"}	\N
卑怯	ひきょう	{}	{"cowardice; meanness; unfairness"}	\N
引き分け	ひきわけ	{勝負事で、決着がつかず、双方勝ち負けなしとして終えること。「試合をーに持ち込む」}	{"a draw (in competition); tie game"}	\N
引分け	ひきわけ	{}	{"tie game; draw"}	\N
引く	ひく	{}	{"minus; pull; draw; play (string instr.)"}	\N
低い	ひくい	{⇔高い。}	{"short; low; humble; low (voice)"}	\N
髭	ひげ	{人、特に男性の口の上やあご・ほおのあたりに生える毛。}	{"facial hair"}	\N
鬚	ひげ	{人、特に男性の口の上やあご・ほおのあたりに生える毛。}	{"facial hair"}	\N
髯	ひげ	{人、特に男性の口の上やあご・ほおのあたりに生える毛。}	{"facial hair"}	\N
悲劇	ひげき	{}	{tragedy}	\N
否決	ひけつ	{}	{"rejection; negation; voting down"}	\N
非行	ひこう	{}	{"delinquency; misconduct"}	\N
飛行	ひこう	{}	{"flying; flight; aviation"}	\N
飛行機	ひこうき	{}	{airplane}	\N
飛行場	ひこうじょう	{}	{"airfield; airport"}	\N
日頃	ひごろ	{}	{"normally; habitually"}	\N
膝	ひざ	{}	{"knee; lap"}	\N
陽射	ひざし	{}	{sunlight}	\N
久しい	ひさしい	{}	{"long; long-continued; old (story)"}	\N
久し振り	ひさしぶり	{}	{"after a long time"}	\N
久しぶり	ひさしぶり	{}	{"after a long time; long time (no see)"}	\N
久々	ひさびさ	{長い間とだえていたさま。前のときから、長い時間が経過したさま。久しぶり。「―に訪れたチャンス」「―のヒット曲」}	{"after a long time"}	\N
悲惨	ひさん	{}	{misery}	\N
肘	ひじ	{}	{elbow}	\N
匕首	ひしゅ	{}	{"dagger; dirk"}	\N
比重	ひじゅう	{}	{"specific gravity"}	\N
批准	ひじゅん	{日本では内閣が行うが、国会の承認を必要とする。「通商条約をーする」}	{"ratification; official way to confirm something; usually by vote"}	\N
秘書	ひしょ	{}	{"(private) secretary"}	\N
非常	ひじょう	{普通でない差し迫った状態。また、思いがけない変事。緊急事態。「―を告げる電話の声」「―持ち出しの荷物」}	{"emergency; extraordinary; unusual"}	\N
非常に	ひじょうに	{並の程度でないさま。はなはだしいさま。「―悲しい」「それが―好きだ」「―驚いた」}	{"very; greatly"}	\N
密か	ひそか	{}	{"secret; private; surreptitious"}	\N
潜む	ひそむ	{}	{"to hide"}	\N
浸す	ひたす	{}	{"to soak; to dip; to drench"}	\N
一向	ひたすら	{}	{earnestly}	\N
左	ひだり	{}	{"left hand side"}	\N
左利き	ひだりきき	{}	{"left-handedness; sake drinker; left-hander"}	\N
引っ掛かる	ひっかかる	{}	{"be caught in; be stuck in; be cheated"}	\N
引っ掻く	ひっかく	{}	{"to scratch"}	\N
引っ掛ける	ひっかける	{}	{"to hang (something) on (something); to throw on (clothes); to hook; to catch; to trap; to ensnare; to cheat; to evade payment; to jump a bill; to drink (alcohol); to spit at (a person); to hit the ball off the end of the bat (baseball)"}	\N
筆記	ひっき	{}	{"(taking) notes; copying"}	\N
引っ繰り返す	ひっくりかえす	{}	{"turn over; overturn; knock over; upset; turn inside out"}	\N
引っ繰り返る	ひっくりかえる	{}	{"be overturned; be upset; topple over; be reversed"}	\N
必見	ひっけん	{必ず見なければならないこと。見る価値のあること。また、そのもの。「ファン―の映画」「―の資料」}	{"must see; must (e.g. read book)"}	\N
引越し	ひっこし	{}	{"moving (dwelling; office; etc.); changing residence"}	\N
引っ越す	ひっこす	{}	{"move to (house)"}	\N
引っ込む	ひっこむ	{}	{"draw back; sink; cave in"}	\N
必死	ひっし	{}	{"inevitable death; desperation; frantic; inevitable result"}	\N
必至	ひっし	{}	{inevitable}	\N
筆者	ひっしゃ	{}	{"writer; author"}	\N
必修	ひっしゅう	{}	{"required (subject)"}	\N
必需品	ひつじゅひん	{なくてはならない品物。「田舎では車は―だ」「生活―」}	{"necessities; necessary article; requisite; essential"}	\N
必然	ひつぜん	{}	{"inevitable; necessary"}	\N
匹敵	ひってき	{}	{"comparing with; match; rival; equal"}	\N
引っ張る	ひっぱる	{}	{"pull; draw; stretch; drag"}	\N
必要	ひつよう	{}	{necessary}	\N
否定	ひてい	{}	{"negation; denial; repudiation"}	\N
酷い	ひどい	{}	{"cruel; awful; severe; very bad; serious; terrible; heavy; violent"}	\N
一息	ひといき	{}	{"puffy; a breath; a pause; an effort"}	\N
単	ひとえ	{}	{"one layer; single"}	\N
人柄	ひとがら	{}	{"personality; character; personal appearance; gentility"}	\N
人込み	ひとごみ	{}	{"crowd of people"}	\N
一頃	ひところ	{}	{"once; some time ago"}	\N
人差指	ひとさしゆび	{}	{"index finger"}	\N
等しい	ひとしい	{}	{"equal; similar; like; equivalent"}	\N
人質	ひとじち	{交渉を有利にするために、特定の人の身柄を拘束すること。また、拘束された人。}	{hostage}	\N
一筋	ひとすき	{}	{"a line; earnestly; blindly; straightforwardly"}	\N
一つ	ひとつ	{}	{one}	\N
一月	ひとつき	{}	{"one month"}	\N
一通り	ひととおり	{}	{"ordinary; usual; in general; briefly"}	\N
人通り	ひとどおり	{}	{"pedestrian traffic"}	\N
一まず	ひとまず	{}	{"for the present; once; in outline"}	\N
瞳	ひとみ	{}	{"eye; pupil (of eye)"}	\N
一休み	ひとやすみ	{}	{rest}	\N
独り	ひとり	{}	{"alone; unmarried"}	\N
日取り	ひどり	{}	{"fixed date; appointed day"}	\N
独り言	ひとりごと	{}	{"soliloquy; monologue; speaking to oneself"}	\N
一人でに	ひとりでに	{}	{"by itself; automatically; naturally"}	\N
一人一人	ひとりひとり	{}	{"one by one; each; one at a time"}	\N
日向	ひなた	{}	{"sunny place; in the sun"}	\N
避難	ひなん	{}	{"taking refuge; finding shelter"}	\N
非難	ひなん	{}	{"blame; attack; criticism"}	\N
皮肉	ひにく	{}	{"cynicism; sarcasm; irony; satire"}	\N
日日	ひにち	{}	{"every day; daily; day after day"}	\N
捻る	ひねる	{}	{"turn (a switch) on or off; twist; puzzle over"}	\N
日の入り	ひのいり	{}	{sunset}	\N
日の出	ひので	{}	{sunrise}	\N
日の丸	ひのまる	{}	{"the Japanese flag"}	\N
火花	ひばな	{}	{spark}	\N
批判	ひはん	{物事に検討を加えて、判定・評価すること。「ー力を養う」}	{"criticism; comment"}	\N
日々	ひび	{}	{"every day; daily; day after day"}	\N
響き	ひびき	{}	{"echo; sound; reverberation; noise"}	\N
響く	ひびく	{}	{"to sound; echo; reverberate"}	\N
批評	ひひょう	{}	{"criticism; review; commentary"}	\N
皮膚	ひふ	{}	{skin}	\N
隙	ひま	{}	{"chance; opportunity; chink (on an armor)"}	\N
肥満	ひまん	{からだが普通以上にふとること。「ーしないように運動する」「ー体」}	{obese}	\N
秘密	ひみつ	{}	{"secret; secrecy"}	\N
姫	ひめ	{}	{princess}	\N
悲鳴	ひめい	{}	{"shriek; scream"}	\N
冷やかす	ひやかす	{}	{"to banter; to make fun of; to jeer at; to cool; to refrigerate"}	\N
百	ひゃく	{}	{"100; hundred"}	\N
百姓	ひゃくしょう	{農業に従事する人。農民。}	{"farming; peasant"}	\N
日焼け	ひやけ	{}	{sunburn}	\N
冷やす	ひやす	{}	{"cool; refrigerate"}	\N
百科事典	ひゃっかじてん	{}	{encyclopedia}	\N
百科辞典	ひゃっかじてん	{}	{encyclopedia}	\N
票	ひょう	{}	{"label; ballot; ticket; sign"}	\N
費用	ひよう	{}	{"cost; expense"}	\N
評価	ひょうか	{}	{"valuation; estimation; assessment; evaluation"}	\N
補給	ほきゅう	{}	{"supply; supplying; replenishment"}	\N
表記	ひょうき	{文字や記号を用いて書き表すこと。「現代仮名遣いで―する」}	{"referring to"}	\N
表現	ひょうげん	{}	{"expression; presentation; (mathematics) representation"}	\N
標語	ひょうご	{}	{"motto; slogan; catchword"}	\N
表紙	ひょうし	{}	{"front cover; binding"}	\N
標識	ひょうしき	{}	{"sign; mark"}	\N
表彰	ひょうしょう	{善行・功績などを人々の前に明らかにし、ほめたたえること。}	{"commendation; 表彰する：to award"}	\N
表示	ひょうじ	{はっきりと表し示すこと。「原料をラベルにーする」}	{"〔指示〕(an) indication; 〔表明〕(an) expression"}	\N
標準	ひょうじゅん	{}	{"standard; level"}	\N
表情	ひょうじょう	{}	{"facial expression"}	\N
評判	ひょうばん	{}	{"fame; reputation; popularity; arrant"}	\N
標本	ひょうほん	{}	{"example; specimen"}	\N
表面	ひょうめん	{}	{"surface; outside; face; appearance"}	\N
漂流	ひょうりゅう	{風や潮のままに海上をただよい流れること。「ボートで―する」}	{drifting}	\N
評論	ひょうろん	{}	{"criticism; critique"}	\N
評論家	ひょうろんか	{評論を仕事にしている人。批評家。「政治ー」}	{"critic; pundit"}	\N
平仮名	ひらがな	{}	{"hiragana; 47 syllables; the cursive syllabary"}	\N
啓く	ひらく	{知識を授ける。啓発する。「蒙 (もう) を―・く」}	{"edify; enlighten; disclose;"}	\N
拓く	ひらく	{未開拓の場所・土地などに手を入れて利用できるようにする。開拓する。開墾する。「山林を―・く」}	{pioneering}	\N
展く	ひらく	{畳んであるもの、閉じてあるものなどを広げる。「本を―・く」}	{"open (e.g. a book)"}	\N
披く	ひらく	{畳んであるもの、閉じてあるものなどを広げる。「本を―・く」}	{"open (e.g. a book)"}	\N
平たい	ひらたい	{}	{"flat; even; level; simple; plain"}	\N
比率	ひりつ	{}	{"ratio; proportion; percentage"}	\N
飛龍	ひりゅう	{空を飛ぶという竜。}	{"flying dragon"}	\N
飛竜	ひりゅう	{空を飛ぶという竜。}	{"flying dragon"}	\N
肥料	ひりょう	{}	{"manure; fertilizer"}	\N
昼	ひる	{}	{"noon; daytime"}	\N
昼御飯	ひるごはん	{}	{"lunch; midday meal"}	\N
昼寝	ひるね	{}	{"nap (at home); siesta"}	\N
昼休み	ひるやすみ	{}	{"lunch break"}	\N
比例	ひれい	{}	{proportion}	\N
広い	ひろい	{}	{"spacious; vast; wide"}	\N
拾う	ひろう	{}	{"pick up"}	\N
披露	ひろう	{手紙・文書などを開いて人に見せること。広く人に知らせること}	{"showcase; exhibition"}	\N
疲労	ひろう	{筋肉・神経などが、使いすぎのためにその機能を低下し、本来の働きをなしえなくなる状態。つかれ。「―が重なる」「心身ともに―する」}	{"fatigue; 〔極度の〕exhaustion"}	\N
広がる	ひろがる	{}	{"spread (out); extend; stretch; reach to; get around"}	\N
広げる	ひろげる	{}	{"spread; extend; expand; enlarge; widen; broaden; unfold; open; unroll"}	\N
広さ	ひろさ	{}	{extent}	\N
広場	ひろば	{}	{plaza}	\N
広々	ひろびろ	{}	{"extensive; spacious"}	\N
広まる	ひろまる	{}	{"to spread; to be propagated"}	\N
広める	ひろめる	{}	{"broaden; propagate"}	\N
貧困	ひんこん	{}	{"poverty; lack"}	\N
品質	ひんしつ	{}	{quality}	\N
貧弱	ひんじゃく	{}	{"poor; meagre; insubstantial"}	\N
品種	ひんしゅ	{}	{"brand; kind; description"}	\N
頻繁	ひんぱん	{しきりに行われること。しばしばであること。また、そのさま。「―に手紙をよこす」「車の往来が―な通り」}	{frequency}	\N
穂	ほ	{}	{"ear (of plant); head (of plant)"}	\N
保育	ほいく	{}	{"nursing; nurturing; rearing; lactation; suckling"}	\N
法	ほう	{}	{law}	\N
倣	ほう	{}	{"imitate; follow; emulate"}	\N
法案	ほうあん	{}	{"bill (law)"}	\N
崩壊	ほうかい	{}	{"collapse; decay (physics); crumbling; breaking down; caving in"}	\N
法学	ほうがく	{}	{"law; jurisprudence"}	\N
方角	ほうがく	{}	{"direction; way; compass point"}	\N
補強	ほきょう	{}	{"compensation; reinforcement"}	\N
方	ほう	{}	{side}	\N
放課後	ほうかご	{学校でその日の授業が終わったあと}	{"after school"}	\N
包括	ほうかつ	{}	{inclusion}	\N
宝器	ほうき	{}	{"treasured article or vessel; outstanding individual"}	\N
放棄	ほうき	{}	{"abandonment; renunciation; abdication (responsibility right)"}	\N
封建	ほうけん	{}	{feudalistic}	\N
方言	ほうげん	{}	{dialect}	\N
方向	ほうこう	{}	{"direction; course; way"}	\N
芳香	ほうこう	{かぐわしい香り。「ーを放つ」}	{"aroma; fragrance"}	\N
縫合	ほうごう	{縫い合わせること。特に、外科手術で外傷などで切断された患部を縫い合わせること。「切開した傷口を―する」}	{"a suture"}	\N
報告	ほうこく	{告げ知らせること。レポート。情報。}	{report}	\N
方策	ほうさく	{}	{"plan; policy"}	\N
豊作	ほうさく	{}	{"abundant harvest; bumper crop"}	\N
奉仕	ほうし	{}	{"attendance; service"}	\N
方式	ほうしき	{}	{"form; method; system"}	\N
放射	ほうしゃ	{}	{"radiation; emission"}	\N
放射能	ほうしゃのう	{}	{radioactivity}	\N
報酬	ほうしゅう	{労務または物の使用の対価として給付される金銭・物品など。報奨。給料。医師・弁護士などの}	{"reward; pay; compensation; (doctor or lawyer) fee"}	\N
放出	ほうしゅつ	{}	{"release; emit"}	\N
報じる	ほうじる	{}	{"to inform; to report"}	\N
方針	ほうしん	{方向；方策；計画；方位を示す磁石の針。磁針。}	{"course; policy; plan"}	\N
報ずる	ほうずる	{}	{"to inform; to report"}	\N
宝石	ほうせき	{}	{"gem; jewel"}	\N
包装	ほうそう	{}	{"packing; wrapping"}	\N
放送	ほうそう	{}	{broadcasting}	\N
法則	ほうそく	{}	{"law; rule"}	\N
包帯	ほうたい	{}	{"bandage; dressing"}	\N
砲台	ほうだい	{}	{cannon}	\N
放題	ほうだい	{常軌を逸していること。自由勝手にふるまうこと。}	{"without reserve; as much as one likes; all-you-can-..."}	\N
放置	ほうち	{}	{"leave as is; leave to chance; leave alone; neglect"}	\N
庖丁	ほうちょう	{}	{"kitchen knife; carving knife"}	\N
包丁	ほうちょう	{}	{"kitchen knife; carving knife"}	\N
法廷	ほうてい	{}	{courtroom}	\N
方程式	ほうていしき	{}	{equation}	\N
報道	ほうどう	{}	{"information; report"}	\N
奉納	ほうのう	{神仏に喜んで納めてもらうために物品を供えたり、その前で芸能・競技などを行ったりすること。「絵馬をーする」「神楽 (かぐら) をーする」}	{"dedication; offering ((of))"}	\N
褒美	ほうび	{}	{"reward; prize"}	\N
豊富	ほうふ	{豊かであること。ふんだんにあること。また、そのさま。「―な天然資源」「―な知識」}	{"abundance; wealth; plenty; bounty"}	\N
報復	ほうふく	{復讐・仕返しをすること。返報。「敵にーする」}	{retaliation}	\N
方法	ほうほう	{}	{"method; process; manner; way; means; technique"}	\N
葬る	ほうむる	{}	{"to bury; to inter; to entomb; to consign to oblivion; to shelve"}	\N
方面	ほうめん	{}	{"direction; district; field (of study)"}	\N
訪問	ほうもん	{}	{"call; visit"}	\N
放り込む	ほうりこむ	{}	{"to throw into"}	\N
放り出す	ほうりだす	{}	{"to throw out; to fire; to expel; to give up; to abandon; to neglect"}	\N
法律	ほうりつ	{社会秩序を維持するために強制される規範。国会の議決を経て制定される法の一形式。法。}	{"law; jurisdiction"}	\N
放流	ほうりゅう	{せき止めた水を放出すること。「貯水池の水を―する」}	{"〔水の〕(a) discharge; released"}	\N
放る	ほうる	{}	{"let go; abandon; leave undone; throw; toss; fling"}	\N
法蓮草	ほうれんそう	{}	{spinach}	\N
飽和	ほうわ	{}	{saturation}	\N
頬	ほお	{}	{"cheek (of face)"}	\N
保温	ほおん	{}	{"retaining warmth; keeping heat in; heat insulation"}	\N
zほか	zほか	{に添えて}	{"in addition"}	\N
捕獲	ほかく	{}	{"capture; seizure"}	\N
朗らか	ほがらか	{}	{"brightness; cheerfulness; melodious"}	\N
保管	ほかん	{}	{"charge; custody; safekeeping; deposit; storage"}	\N
北西	ほくせい	{}	{north-west}	\N
北斗	ほくと	{「北斗七星」の略。「泰山 (たいざん) ー」}	{"((米)) the Big Dipper，((英)) the Plough"}	\N
捕鯨	ほげい	{}	{"whaling; whale fishing"}	\N
保健	ほけん	{}	{"health preservation; hygiene; sanitation"}	\N
保険	ほけん	{}	{"insurance; guarantee"}	\N
矛	ほこ	{}	{halbard}	\N
保護	ほご	{}	{"care; protection; shelter; guardianship; favor; patronage"}	\N
誇り	ほこり	{}	{pride}	\N
誇る	ほこる	{}	{"to boast of; to be proud of"}	\N
綻びる	ほころびる	{}	{"to come apart at the seams; to begin to open; to smile broadly"}	\N
星	ほし	{}	{star}	\N
欲しい	ほしい	{}	{"wanted; wished for; in need of; desired"}	\N
干し葡萄	ほしぶどう	{ブドウの実を干したもの。レーズン。}	{raisin}	\N
干し物	ほしもの	{}	{"dried washing (clothes)"}	\N
保守	ほしゅ	{}	{"conservative; maintaining"}	\N
補充	ほじゅう	{}	{"supplementation; supplement; replenishment; replenishing"}	\N
補助	ほじょ	{不足しているところを補い助けること。また、その助けとなるもの。「生活費を―する」}	{"assistance; support; aid; auxiliary"}	\N
保証	ほしょう	{}	{"guarantee; security; assurance; pledge; warranty"}	\N
補償	ほしょう	{損失を補って、つぐなうこと。特に、損害賠償として、財産や健康上の損失を金銭でつぐなうこと。「労働災害を―する」「公害―裁判」「―金」}	{"compensation; reparation"}	\N
保障	ほしょう	{}	{"guarantee; security; assurance; pledge; warranty"}	\N
干す	ほす	{}	{"to air; dry; desiccate; drain (off); drink up"}	\N
細い	ほそい	{}	{"thin; slender; fine"}	\N
舗装	ほそう	{}	{"pavement; road surface"}	\N
補足	ほそく	{}	{"supplement; complement"}	\N
捕捉	ほそく	{キャプチャー・つかむこと}	{"capture; seizure"}	\N
保存	ほぞん	{}	{"preservation; conservation; storage; maintenance"}	\N
北極	ほっきょく	{}	{"North Pole"}	\N
発作	ほっさ	{}	{"fit; spasm"}	\N
頬っぺた	ほっぺた	{}	{cheek}	\N
程	ほど	{}	{"limit; the more ~ the more"}	\N
歩道	ほどう	{}	{"footpath; walkway; sidewalk"}	\N
施し	ほどこし	{恵み与えること。また、そのもの。布施 (ふせ) 。施与。「―を受ける」「―を乞う」}	{"〔行為〕almsgiving; charity; 〔物〕alms ((単複同形))，((口)) a handout"}	\N
殆ど	ほとんど	{}	{"mostly; almost"}	\N
炎	ほのお	{}	{"flame; blaze"}	\N
保母	ほぼ	{}	{"day care worker in a kindergarten nursery school etc."}	\N
微笑む	ほほえむ	{}	{"to smile"}	\N
褒める	ほめる	{}	{"to praise"}	\N
保養	ほよう	{}	{"health preservation; recuperation; recreation"}	\N
捕吏	ほり	{}	{constable}	\N
堀	ほり	{}	{"moat; canal"}	\N
捕虜	ほりょ	{}	{"prisoner (of war)"}	\N
掘る	ほる	{}	{"dig; excavate"}	\N
彫る	ほる	{}	{"carve; engrave; sculpture; chisel"}	\N
幌	ほろ	{}	{hood}	\N
滅びる	ほろびる	{}	{"to be ruined; to go under; to perish; to be destroyed"}	\N
滅ぼす	ほろぼす	{}	{"to destroy; to overthrow; to wreck; to ruin"}	\N
本	ほん	{}	{book}	\N
本格	ほんかく	{}	{"propriety; fundamental rules"}	\N
本館	ほんかん	{}	{"main building"}	\N
本気	ほんき	{}	{"seriousness; truth; sanctity"}	\N
本質	ほんしつ	{}	{"essence; true nature; reality"}	\N
奔走	ほんそう	{忙しく走り回ること。物事が順調に運ぶようにあちこちかけまわって努力すること。「募金集めにーする」}	{"make every effort (to); busies himself with; played an active part (in)"}	\N
乾	ほし	{}	{"dried; cured"}	\N
解く	ほどく	{結んだり、縫ったり、もつれたりしたものをときはなす。とく。「荷物を―・く」}	{"to unfasten"}	\N
仏	ほとけ	{}	{"Buddha; merciful person; Buddhist image; the dead"}	\N
辺り	ほとり	{}	{"(in the) neighbourhood; vicinity; nearby"}	\N
本体	ほんたい	{}	{"substance; real form; object of worship"}	\N
本棚	ほんだな	{}	{bookshelves}	\N
本当	ほんとう	{偽りや見せかけでなく、実際にそうであること。「一見難しそうだが―は易しい」「うわさは―だ」}	{"truth; reality"}	\N
本人	ほんにん	{}	{"the person himself"}	\N
本音	ほんね	{}	{"real intention; motive"}	\N
本の	ほんの	{}	{"mere; only; just"}	\N
本能	ほんのう	{}	{instinct}	\N
本場	ほんば	{}	{"home; habitat; center; best place; genuine"}	\N
本部	ほんぶ	{}	{HQ}	\N
本文	ほんぶん	{}	{"text (of document); body (of letter)"}	\N
本名	ほんみょう	{}	{"real name"}	\N
本物	ほんもの	{}	{"genuine article"}	\N
翻訳	ほんやく	{}	{translate}	\N
本来	ほんらい	{}	{"essentially; naturally; by nature; in (and of) itself; originally"}	\N
本塁打	ほんるいだ	{}	{"home run"}	\N
不正	ふせい	{正しくないこと。正義に反する。道義に反する。法律に反する。}	{"injustice; unjust; dishonest; unlawful; illegal"}	\N
普通	ふつう	{特に変わっていないこと。；通常}	{"usual; common"}	\N
不当	ふとう	{正当・適当でないこと}	{unjust}	\N
不凍液	ふとうえき	{"不凍剤。 アンチフリーズ"}	{antifreeze}	\N
歩	ふ	{}	{"pawn (in chess or shogi)"}	\N
不安	ふあん	{}	{"anxiety; uneasiness; insecurity; suspense"}	\N
不意	ふい	{}	{"sudden; abrupt; unexpected; unforeseen"}	\N
封	ふう	{}	{seal}	\N
風景	ふうけい	{}	{scenery}	\N
封鎖	ふうさ	{}	{"blockade; freezing (funds)"}	\N
封じる	ふうじる	{}	{"to seal (letter) (2) to prevent; to forbid; to block"}	\N
風習	ふうしゅう	{}	{custom}	\N
風速	ふうそく	{}	{"wind speed"}	\N
風船	ふうせん	{}	{balloon}	\N
風俗	ふうぞく	{}	{"manners; customs; sex service; sex industry"}	\N
風土	ふうど	{}	{"natural features; topography; climate; spiritual features"}	\N
封筒	ふうとう	{}	{envelope}	\N
夫婦	ふうふ	{}	{"married couple; spouses; husband and wife; couple; pair"}	\N
不運	ふうん	{}	{"unlucky; misfortune; bad luck; fate"}	\N
笛	ふえ	{}	{flute}	\N
増える	ふえる	{}	{increase}	\N
殖える	ふえる	{}	{"increase; multiply"}	\N
不可	ふか	{}	{"wrong; bad; improper; unjustifiable; inadvisable"}	\N
不快感	ふかいかん	{不愉快に思う気持ち。「―をあらわにする」「―をつのらせる」「―が軽減される」}	{discomfort}	\N
不可欠	ふかけつ	{}	{"indispensable; essential"}	\N
深さ	ふかさ	{ふかいこと。また、その度合い。}	{〔穴などの〕depth}	\N
更かす	ふかす	{夜遅くまで起きている。夜ふかしをする。「議論で夜をー・す」}	{"stay up 「till late [at night]"}	\N
不可能	ふかのう	{}	{impossible}	\N
深まる	ふかまる	{}	{"deepen; heighten; intensify"}	\N
深める	ふかめる	{}	{"to deepen; to heighten; to intensify"}	\N
不規則	ふきそく	{}	{"irregularity; unsteadiness; disorderly"}	\N
不吉	ふきつ	{縁起が悪いこと。不運の兆しがあること。また、そのさま。不祥。「―な予感がする」「―な夢」}	{"ominous; sinister; bad luck; ill omen; inauspiciousness"}	\N
普及	ふきゅう	{}	{"diffusion; spread"}	\N
不況	ふきょう	{}	{"recession; depression; slump"}	\N
布巾	ふきん	{}	{"tea-towel; dish cloth"}	\N
付近	ふきん	{}	{"neighbourhood; vicinity; environs"}	\N
吹く	ふく	{}	{"blow (wind; etc.); emit"}	\N
福	ふく	{}	{"good fortune"}	\N
服	ふく	{}	{clothes}	\N
拭く	ふく	{}	{"wipe; dry"}	\N
復旧	ふくきゅう	{}	{"restoration; restitution; rehabilitation"}	\N
複合	ふくごう	{}	{"composite; complex"}	\N
複雑	ふくざつ	{}	{complicated}	\N
副詞	ふくし	{}	{adverb}	\N
福祉	ふくし	{公的配慮によって社会の成員が等しく受けることのできる安定した生活環境。「公共ー」「ー事業」}	{"welfare; well-being"}	\N
複写	ふくしゃ	{}	{"copy; duplicate"}	\N
復習	ふくしゅう	{}	{review}	\N
復讐	ふくしゅう	{かたきうちをする。仕返しをする。報復。「―する機会を待つ」}	{"revenge; 〔激しい復しゅう〕vengeance"}	\N
腹心	ふくしん	{どんなことでも打ち明けて相談できること。また、その人。「―の部下」}	{"〔信頼している人〕one's confidant; 〔女性の〕one's confidante"}	\N
複数	ふくすう	{}	{"plural; multiple"}	\N
服装	ふくそう	{}	{garments}	\N
含む	ふくむ	{}	{"hold in the mouth; bear in mind; understand; cherish; harbor; contain; comprise; have; hold; include; embrace; be full of"}	\N
含める	ふくめる	{}	{"include; instruct; make one understand; put in one´s mouth"}	\N
覆面	ふくめん	{}	{"mask; veil; disguise"}	\N
膨らます	ふくらます	{}	{"swell; expand; inflate; bulge"}	\N
膨らむ	ふくらむ	{}	{"expand; get big; become inflated"}	\N
膨れ	ふくれ	{ふくれること。また、ふくれたところや、もの。「水―」「火―」}	{"bulge; bump"}	\N
脹れ	ふくれ	{ふくれること。また、ふくれたところや、もの。「水―」「火―」}	{"bulge; bump"}	\N
膨れる	ふくれる	{}	{"to get cross; to get sulky; to swell (out); to expand; to be inflated; to distend; to bulge"}	\N
袋	ふくろ	{}	{"bag; sack"}	\N
不景気	ふけいき	{}	{"business recession; hard times; depression; gloom; sullenness; cheerlessness"}	\N
不潔	ふけつ	{}	{"unclean; dirty; filthy; impure"}	\N
更ける	ふける	{}	{"get late; advance; wear on;"}	\N
老ける	ふける	{}	{"to age"}	\N
不幸	ふこう	{}	{"unhappiness; sorrow; misfortune; disaster; accident; death"}	\N
富豪	ふごう	{}	{"wealthy person; millionaire"}	\N
符号	ふごう	{}	{"sign; mark; symbol"}	\N
布告	ふこく	{}	{"edict; ordinance; proclamation"}	\N
負債	ふさい	{}	{"debt; liabilities"}	\N
夫妻	ふさい	{}	{"man and wife; married couple"}	\N
不在	ふざい	{}	{absence}	\N
塞がる	ふさがる	{}	{"be plugged up; be shut up"}	\N
塞ぐ	ふさぐ	{}	{"stop up; close up; block (up); occupy; fill up; take up; stand in another´s way; plug up; shut up"}	\N
不山戯る	ふざける	{}	{"to romp; to gambol; to frolic; to joke; to make fun of; to flirt"}	\N
巫山戯る	ふざける	{}	{"〔戯れる〕play (with); 〔子供や動物がはね回って〕frisk; frolic"}	\N
相応しい	ふさわしい	{}	{appropriate}	\N
不思議	ふしぎ	{}	{"wonder; miracle; strange; mystery; marvel; curiosity"}	\N
不死鳥	ふしちょう	{}	{phoenix}	\N
不自由	ふじゆう	{}	{"discomfort; disability; inconvenience; destitution"}	\N
不順	ふじゅん	{}	{"irregularity; unseasonableness"}	\N
負傷	ふしょう	{}	{"injury; wound"}	\N
不祥事	ふしょうじ	{関係者にとって不都合な事件、事柄。類語：凶事・弔事「社員がーを起こす」}	{"scandal; a disgraceful [deplorable] affair"}	\N
不振	ふしん	{}	{"dullness; depression; slump; stagnation"}	\N
不審	ふしん	{}	{"incomplete understanding; doubt; question; distrust; suspicion; strangeness; infidelity"}	\N
夫人	ふじん	{}	{"wife; Mrs.; madam"}	\N
婦人	ふじん	{}	{"woman; female"}	\N
伏す	ふす	{腹ばいになる。また、地面にひざをつくなどして頭を深く下げる。「地にー・す」}	{"bow down; bend down"}	\N
防ぐ	ふせぐ	{}	{"defend (against); protect; prevent"}	\N
不足	ふそく	{}	{"insufficiency; shortage; deficiency; lack"}	\N
付属	ふぞく	{}	{"attached; belonging; affiliated; annexed; associated; subordinate; incidental; dependent; auxiliary"}	\N
附属	ふぞく	{}	{"attached; belonging; affiliated; annexed; associated; subordinate; incidental; dependent; auxiliary"}	\N
双子	ふたご	{}	{"twins; a twin"}	\N
怒り	いかり	{}	{"anger; hatred"}	\N
節	ふし	{}	{"node; section; occasion; time"}	\N
蓋	ふた	{}	{"cover; lid; cap"}	\N
再び	ふたたび	{}	{"again; once more; a second time"}	\N
二つ	ふたつ	{}	{two}	\N
負担	ふたん	{荷物を肩や背にかつぐこと。また、その荷物。義務・責任などを引き受けること。また、その義務・責任など。「費用は全員でーする」}	{"burden; charge; responsibility"}	\N
普段	ふだん	{}	{"usually; habitually; ordinarily; always"}	\N
不調	ふちょう	{}	{"bad condition; not to work out (ie a deal); disagreement; break-off; disorder; slump; out of form"}	\N
不通	ふつう	{}	{"suspension; interruption; stoppage; tie-up; cessation"}	\N
二日	ふつか	{}	{"second day of the month; two days"}	\N
復活	ふっかつ	{}	{"revival (e.g. musical); restoration"}	\N
復興	ふっこう	{}	{"revival; renaissance; reconstruction"}	\N
払拭	ふっしょく	{はらいぬぐい去ること。すっかり取り除くこと。一掃。ふっしき。「因習をーする」「保守色をーする」}	{"wiping; sweeping away"}	\N
沸騰	ふっとう	{}	{"boiling; seething"}	\N
筆	ふで	{}	{"writing brush"}	\N
太い	ふとい	{}	{"fat; thick"}	\N
不動産	ふどうさん	{}	{"real estate"}	\N
不透明	ふとうめい	{透明でないこと。事の成り行きや実状などが、はっきり示されないこと。また、そのさま。「金の流れがーだ」}	{opaque}	\N
太る	ふとる	{}	{"grow fat"}	\N
布団	ふとん	{}	{futon}	\N
船便	ふなびん	{}	{"surface mail (ship)"}	\N
赴任	ふにん	{}	{"(proceeding to) new appointment"}	\N
舟	ふね	{}	{"ship; boat; watercraft; shipping; vessel; steamship"}	\N
船	ふね	{}	{"ship; boat; watercraft; shipping; vessel; steamship"}	\N
腐敗	ふはい	{}	{"decay; depravity"}	\N
不評	ふひょう	{}	{"bad reputation; disgrace; unpopularity"}	\N
吹雪	ふぶき	{}	{"snow storm"}	\N
不服	ふふく	{}	{"dissatisfaction; discontent; disapproval; objection; complaint; protest; disagreement"}	\N
不平	ふへい	{}	{"complaint; discontent; dissatisfaction"}	\N
普遍	ふへん	{}	{"universality; ubiquity; omnipresence"}	\N
不法	ふほう	{法律従わない}	{illegal}	\N
不法滞在	ふほうたいざい	{一般に人が出入国関係法令に違反した状態で外国に滞在している状態をさす。不法滞留。}	{"illegal stay"}	\N
不法滞留	ふほうたいりゅう一	{般に人が出入国関係法令に違反した状態で外国に滞在している状態をさす。不法滞在。}	{"illegal stay"}	\N
不法滞在者	ふほうたいざいしゃ	{}	{"illegal immigrant"}	\N
踏まえる	ふまえる	{}	{"to be based on; to have origin in"}	\N
不満	ふまん	{もの足りなく、満足しないこと。また、そのさまやそう思う気持ち。不満足。「―を口にする」「―な点が残る」「欲求―」}	{"dissatisfaction; displeasure; discontent; complaints; unhappiness"}	\N
不満気	ふまんげ	{不満お様子}	{discontent;}	\N
不味	ふみ	{}	{distaste}	\N
踏切	ふみきり	{}	{"railway crossing; level crossing; starting line; scratch; crossover"}	\N
踏む	ふむ	{}	{"step on"}	\N
不明	ふめい	{}	{"unknown; obscure; indistinct; uncertain; ambiguous; ignorant; lack of wisdom; anonymous; unidentified"}	\N
麓	ふもと	{}	{"foot; the bottom; base (of a mountain)"}	\N
増やす	ふやす	{}	{"to increase; to add to; to augment"}	\N
殖やす	ふやす	{}	{"to increase; to add to; to augment"}	\N
冬	ふゆ	{}	{winter}	\N
富裕	ふゆう	{財産が多くあって、生活が豊かなこと。また、そのさま。裕福。「―な生活」}	{"wealth; ⇒ゆうふく(裕福)　affluence [ǽfluns]; wealth"}	\N
扶養	ふよう	{}	{"support; maintenance"}	\N
不利	ふり	{}	{"disadvantage; handicap; unfavorable; drawback"}	\N
振り	ふり	{}	{"pretence; show; appearance"}	\N
会議	かいぎ	{}	{meeting}	\N
不便	ふべん	{}	{inconvenience}	\N
縁	ふち	{}	{"(surrounding) edge"}	\N
振り返る	ふりかえる	{後方へ顔を向ける。振り向く。「背後の物音に―・る」}	{"〔振り向く〕turn around [round]; look back"}	\N
振り仮名	ふりがな	{}	{"hiragana over kanji; pronunciation key"}	\N
振り込む	ふりこむ	{}	{"Make a payment via bank deposit transfer"}	\N
振り出し	ふりだし	{}	{"outset; starting point; drawing or issuing (draft)"}	\N
不良	ふりょう	{}	{"badness; delinquent; inferiority; failure"}	\N
浮力	ふりょく	{}	{"buoyancy; floating power"}	\N
降る	ふる	{}	{"to precipitate; to fall (e.g. rain)"}	\N
振る	ふる	{}	{"wave; shake; swing; sprinkle; cast (actor); allocate (work)"}	\N
古い	ふるい	{}	{"old (not person); aged; ancient; antiquated; stale; threadbare; outmoded; obsolete article"}	\N
震える	ふるえる	{}	{"shiver; shake; quake"}	\N
故郷	ふるさと	{}	{"hometown; old town"}	\N
振舞う	ふるまう	{}	{"behave; conduct oneself; entertain"}	\N
震わせる	ふるわせる	{}	{"to be shaking; to be trembling"}	\N
触れる	ふれる	{}	{"touch; be touched; touch on a subject; feel; violate (law; copyright; etc.); perceive; be moved (emotionally)"}	\N
風呂	ふろ	{}	{bath}	\N
付録	ふろく	{}	{"appendix; supplement"}	\N
風呂敷	ふろしき	{}	{"wrapping cloth; cloth wrapper"}	\N
雰囲気	ふんいき	{}	{"atmosphere (e.g. musical); mood; ambience"}	\N
噴火	ふんか	{}	{eruption}	\N
憤慨	ふんがい	{}	{"indignation; resentment"}	\N
紛糾	ふんきゅう	{}	{"complication; confusion"}	\N
紛失	ふんしつ	{}	{"losing something"}	\N
噴出	ふんしゅつ	{}	{"spewing; gushing; spouting; eruption; effusion"}	\N
噴水	ふんすい	{}	{"water fountain"}	\N
紛争	ふんそう	{}	{"dispute; trouble; strife"}	\N
奮闘	ふんとう	{}	{"hard struggle; strenuous effort"}	\N
粉末	ふんまつ	{}	{"fine powder"}	\N
噴霧	ふんむ	{}	{spray}	\N
噴霧器	ふんむき	{液体を霧状にしてふき出させて散布する器具。スプレー。}	{sprayer}	\N
胃	い	{}	{stomach}	\N
依	い	{}	{"depending on"}	\N
慰安	いあん	{心をなぐさめ、労をねぎらうこと。また、そのような事柄。「従業員を―する」「―旅行」}	{"consolation; comfort; recreation"}	\N
言う通り	いうどおり	{言葉による指示に沿う・従うさまを意味する表現。}	{"as (you) said; according to said (thing)"}	\N
伊井	いい	{}	{"that one; Italy"}	\N
良い	いい	{}	{good}	\N
いい加減	いいかげん	{}	{"moderate; right; random; not thorough; vague; irresponsible; halfhearted"}	\N
言い方	いいかた	{話のしかた。言葉づかい。言いよう。「持って回ったー」「もう少し何とかーがあったろうに」}	{"expression; saying; way of speech"}	\N
言い出す	いいだす	{}	{"start talking; propose; suggest; break the ice"}	\N
言い付ける	いいつける	{}	{"tell; tell on (someone); to order; to charge; to direct"}	\N
言い訳	いいわけ	{}	{"excuse; explanation"}	\N
委員	いいん	{}	{"committee member"}	\N
委員会	いいんかい	{上位の合議体のために作業する、委員によって構成される組織体。また、その会議。}	{"a committee ((on)); 〔特に政府任命の〕a commission on; a board; 〔会議〕a committee meeting"}	\N
言う	いう	{}	{"to say"}	\N
家	いえ	{}	{"house; family"}	\N
家出	いえで	{}	{"running away from home; leaving home"}	\N
硫黄	いおう	{}	{"sulfur，(英) sulphur (記号S)"}	\N
以下	いか	{}	{"~ or less than?not more than"}	\N
以外	いがい	{}	{"except for; other than"}	\N
意外	いがい	{}	{"unexpected; surprising"}	\N
如何	いかが	{}	{"how; in what way"}	\N
威嚇	いかく	{}	{"threat; malice"}	\N
医学	いがく	{}	{"medical science"}	\N
生かす	いかす	{生き返らせる}	{"spare a person's life; bring ((a person)) back to life; revive ((a person)); make use of; utilize"}	\N
如何に	いかに	{}	{"how?; in what way?; how much?; however; whatever"}	\N
如何にも	いかにも	{}	{"indeed; really; phrase meaning agreement"}	\N
分	ふん	{}	{minute}	\N
遺憾	いかん	{反省}	{resentment}	\N
胃癌	いがん	{胃に発生する悪性腫瘍 (しゅよう) 。初期には自覚症状がないが、進行するにつれ食欲不振や胃の不快感から、しだいに吐血・下血などの症状がみられるようになる。}	{"stomach cancer"}	\N
息	いき	{}	{"breath; tone"}	\N
行き	いき	{}	{going}	\N
粋	いき	{}	{"chic; style; purity; essence"}	\N
遺棄	いき	{捨てて顧みないこと。置き去りにすること。委棄。「死体を―する」}	{"desertation; abandoning"}	\N
意義	いぎ	{}	{"meaning; significance"}	\N
異議	いぎ	{}	{"objection; dissent; protest"}	\N
生き生き	いきいき	{}	{"vividly; lively"}	\N
勢い	いきおい	{}	{"force; vigor; energy; spirit; life; authority; influence; power; might; tendency; necessarily"}	\N
域外	いきがい	{}	{"outside the area"}	\N
意気込む	いきごむ	{}	{"to be enthusiastic about"}	\N
経緯	いきさつ	{}	{"details; whole story; sequence of events; particulars; how it started; how things got this way; complications; position"}	\N
行き違い	いきちがい	{}	{"misunderstanding; estrangement; disagreement; crossing without meeting; going astray"}	\N
憤り	いきどおり	{立腹。憤慨。「―を覚える」}	{"indignation; resentment; anger"}	\N
憤る	いきどおる	{気持ちがすっきりしないで苦しむ。「―・る心の内を思ひ延べ」}	{"be angry ((at; with; about; that)); be enraged ((by; at))⇒おこる(怒る)"}	\N
行き成り	いきなり	{何の前触れもなく急に事が起きるさま。突然。知らせなしに。}	{"suddenly; all of a sudden; without (any) warning"}	\N
息抜き	いきぬき	{緊張を解いて、気分転換のためにしばらく休むこと。休息。「―にテレビを見る」「屋上に出て―する」}	{"〔休息〕(a) rest; 〔一休み〕a breather; a break; a breathing spell; 〔気晴らし〕relaxation"}	\N
生き物	いきもの	{}	{animal}	\N
生きる	いきる	{}	{"live; exist"}	\N
行く	いく	{}	{"to go"}	\N
逝く	いく	{}	{"die; pass away"}	\N
戦	いくさ	{}	{"war; battle; campaign; fight"}	\N
育児	いくじ	{}	{"childcare; nursing; upbringing"}	\N
育成	いくせい	{}	{"rearing; training; nurture; cultivation; promotion"}	\N
幾多	いくた	{}	{"many; numerous"}	\N
幾つ	いくつ	{}	{"how many?; how old?"}	\N
幾分	いくぶん	{}	{somewhat}	\N
幾ら	いくら	{}	{"how much?; how many?"}	\N
池	いけ	{}	{pond}	\N
いけない	いけない	{「悪い」の遠回しな言い方。人のしたことなどに対して非難するさま。感心できない。よくない。「いたずらばかりして、―◦ない子だ」「定刻に遅れたのが―◦ない」}	{"〔よくない〕bad; wrong⇒だめ(駄目)"}	\N
生け花	いけばな	{}	{"flower arrangement"}	\N
活ける	いける	{}	{"to arrange (flowers)"}	\N
異見	いけん	{}	{"different opinion; objection"}	\N
意見	いけん	{}	{opinion}	\N
以後	いご	{}	{"from now on; thereafter"}	\N
意向	いこう	{}	{"intention; idea; inclination"}	\N
移行	いこう	{}	{"switching over to"}	\N
以降	いこう	{}	{"on and after; hereafter; thereafter"}	\N
些か	いささか	{数量・程度の少ないさま。ほんの少し。わずか。ついちょっと。「ーなりともお役に立ちたい」「この問題はー難しい」}	{"a little; a bit; slightly"}	\N
勇ましい	いさましい	{}	{"brave; valiant; gallant; courageous"}	\N
石	いし	{}	{stone}	\N
意志	いし	{}	{"will; volition"}	\N
意思	いし	{}	{"intention; purpose"}	\N
医師	いし	{}	{doctor}	\N
意地	いじ	{}	{"disposition; spirit; willpower; obstinacy; backbone; appetite"}	\N
維持	いじ	{}	{"maintenance; preservation"}	\N
石垣	いしがき	{石壁}	{"stone [rock] wall [fence]"}	\N
意識	いしき	{心が知覚を有しているときの状態。「ーを取り戻す」}	{consciousness;}	\N
碑	いしぶみ	{}	{"stone monument bearing an inscription"}	\N
苛める	いじめる	{}	{"to tease; to torment; to persecute; to chastise"}	\N
医者	いしゃ	{}	{"doctor (medical)"}	\N
移住	いじゅう	{}	{"migration; immigration"}	\N
萎縮	いしゅく	{しぼんでちぢむこと。また、元気がなくなること。「寒くて手足が―する」「聴衆を前にして―してしまう」}	{"〔しなびて縮むこと〕withering; 〔栄養不良などによる〕atrophy"}	\N
衣装	いしょう	{}	{"clothing; costume; outfit; garment; dress"}	\N
衣裳	いしょう	{}	{"costume; outfit"}	\N
以上	いじょう	{}	{"more than; over"}	\N
異常	いじょう	{普通と違っていること。正常でないこと。また、そのさま。「この夏は―に暑かった」「―な執着心」「害虫の―発生」⇔正常。}	{"strangeness; abnormality; disorder"}	\N
衣食住	いしょくじゅう	{}	{"necessities of life (food; clothing; etc.)"}	\N
弄る	いじる	{}	{"to touch; to tamper with"}	\N
意地悪	いじわる	{}	{"malicious; ill-tempered; unkind"}	\N
維新	いしん	{}	{restoration}	\N
椅子	いす	{}	{chair}	\N
泉	いずみ	{}	{"spring; fountain"}	\N
何れ	いずれ	{いろいろな過程を経たうえでの結果をいう。いずれにしても。結局。どのみち}	{"anyhow; in any case;"}	\N
何れにしても	いずれにしても	{どちらを選ぶにしても。事情がどうであろうとも。どっちみち。いずれにせよ。}	{whichever}	\N
何れにせよ	いずれにせよ	{経過がどうであろうと、結果は明らかだと認める気持ちを表す語。どうせ。結局は。}	{"at any rate; anyhow"}	\N
異性	いせい	{}	{"the opposite sex"}	\N
遺跡	いせき	{}	{"historic ruins (remains relics)"}	\N
依然	いぜん	{}	{"still; as yet"}	\N
以前	いぜん	{}	{"ago; since; before; previous"}	\N
忙しい	いそがしい	{}	{"busy; irritated"}	\N
急ぐ	いそぐ	{}	{"hurry (up)"}	\N
遺族	いぞく	{}	{"bereaved family (frantagen)"}	\N
依存	いそん	{}	{"dependence; dependent; reliance"}	\N
板	いた	{}	{"board; plank"}	\N
痛い	いたい	{}	{painful}	\N
遺体	いたい	{}	{死人}	\N
偉大	いだい	{すぐれて大きいさま。りっぱであるさま。「ーな業績」「ーな人物」}	{greatness}	\N
委託	いたく	{}	{"consign (goods (for sale) to a firm); entrust (person with something); commit"}	\N
致す	いたす	{}	{do}	\N
悪戯	いたずら	{}	{"tease; prank; trick; practical joke; mischief"}	\N
頂	いただき	{}	{"(top of) head; summit; spire"}	\N
至って	いたって	{}	{"very much; exceedingly; extremely"}	\N
痛み	いたみ	{}	{"pain; ache; sore; grief; distress"}	\N
悼む	いたむ	{}	{mourn}	\N
痛む	いたむ	{}	{"to hurt; to feel a pain; to be injured"}	\N
痛める	いためる	{}	{"to hurt; to injure; to cause pain; to worry; to bother; to afflict; to be grieved over"}	\N
至る	いたる	{}	{"come; arrive"}	\N
労る	いたわる	{}	{"to pity; to sympathize with; to console; to care for; to be kind to"}	\N
一	いち	{}	{one}	\N
壱	いち	{}	{"I (roman 1)"}	\N
位地	いち	{}	{"place; situation; position; location"}	\N
位置	いち	{}	{"location; position"}	\N
一々	いちいち	{}	{"one by one; separately"}	\N
一応	いちおう	{}	{"once; tentatively; in outline; for the time being"}	\N
一概に	いちがいに	{}	{"unconditionally; as a rule"}	\N
一月	いちがつ	{}	{January}	\N
一見	いちげん	{}	{"unfamiliar; never before met"}	\N
一時	いちじ	{}	{"one hour; short time; once; temporarily; at one time"}	\N
市	いち	{}	{"market; fair"}	\N
一言	いちげん	{}	{"single word"}	\N
一日	いちじつ	{}	{"one day; first of month"}	\N
著しい	いちじるしい	{}	{"remarkable; considerable"}	\N
一段と	いちだんと	{}	{"greater; more; further; still more"}	\N
一度	いちど	{}	{"once; one time"}	\N
一同	いちどう	{}	{"all present; all concerned; all of us"}	\N
一度に	いちどに	{}	{"all at once"}	\N
一宮	いちのみや	{ある地域の中で最も社格の高いとされる神社のことである。}	{"historical term referring to the Japanese Shinto shrines with the highest shrine rank (ja:社格) in a province or prefecture."}	\N
市場	いちば	{一定の商品を大量に卸売りする所。「魚―」「青物―」}	{"town market; the marketplace (economics)"}	\N
一番	いちばん	{}	{"best; first; number one; a game; a round; a bout; a fall; an event (in a meet)"}	\N
一部	いちぶ	{}	{"one copy e.g. of a document; a part; partly; some"}	\N
一部分	いちぶぶん	{}	{"a part"}	\N
一別	いちべつ	{}	{parting}	\N
一面	いちめん	{}	{"one side; one phase; front page; the other hand; the whole surface"}	\N
一目	いちもく	{}	{"a glance; a look; a glimpse"}	\N
一様	いちよう	{}	{"uniformity; evenness; similarity; equality; impartiality"}	\N
一律	いちりつ	{}	{"evenness; uniformity; monotony; equality"}	\N
一流	いちりゅう	{}	{"foremost; top-notch; unique"}	\N
一例	いちれい	{一つの例。「―を挙げる」}	{"an example; an instance⇒れい(例)4"}	\N
一連	いちれん	{}	{"a series; a chain; a ream (of paper)"}	\N
何時	いつ	{}	{"when; how soon"}	\N
一家	いっか	{}	{"house; home; a family; a household; one´s family; one´s folks; a style"}	\N
五日	いつか	{}	{"five days; the fifth day (of the month)"}	\N
何時か	いつか	{}	{"sometime; some day"}	\N
一階	いっかい	{}	{"first floor"}	\N
一括	いっかつ	{}	{"all together; batch; one lump; one bundle; summing up"}	\N
一貫	いっかん	{}	{"consistency; coherence"}	\N
一気	いっき	{}	{"drink!(said repeatedly as a party cheer)"}	\N
一挙に	いっきょに	{}	{"at a stroke; with a single swoop"}	\N
慈しみ	いつくしみ	{}	{affection}	\N
一刻	いっこく	{わずかな時間。瞬時。「―を争う」「―も早く」}	{"〔わずかな時間〕a moment"}	\N
一刻者	いっこくもの	{頑固で自分を曲げない人。一徹者。}	{"「an obstinate [a stubborn] person"}	\N
一国者	いっこくもの	{頑固で自分を曲げない人。一徹者。}	{"「an obstinate [a stubborn] person"}	\N
一切	いっさい	{}	{"all; everything; without exception; the whole; entirely; absolutely"}	\N
一種	いっしゅ	{}	{"species; kind; variety"}	\N
一瞬	いっしゅん	{}	{"moment; instant"}	\N
一緒	いっしょ	{}	{"together; meeting; company"}	\N
一生	いっしょう	{}	{"lifetime; all through life; generation; age; era; the whole world"}	\N
一生懸命	いっしょうけんめい	{}	{"as well as one can; as hard as one can"}	\N
一生に一度	いっしょういちど	{}	{"once in a lifetime"}	\N
一心	いっしん	{}	{"one mind; wholeheartedness; the whole heart"}	\N
一心不乱	いっしんふらん	{心を一つの事に集中して、他の事に気をとられないこと。また、そのさま。「―に祈る」「―に研究する」}	{"be completely absorbed (by drawing a picture)"}	\N
一斉	いっせい	{同時。いちどき。「―に立ち上がる」}	{simultaneous}	\N
一層	いっそう	{}	{"much more; still more; all the more"}	\N
一帯	いったい	{}	{"a region; a zone; the whole place"}	\N
一体	いったい	{}	{"one object; one body; generally; what on earth? really?"}	\N
逸脱	いつだつ	{本筋や決められた枠から外れること。「任務を―する行為」}	{"〔本筋からそれること〕(a) deviation; (a) departure"}	\N
一旦	いったん	{}	{"once; for a moment; one morning; temporarily"}	\N
一致	いっち	{}	{"coincidence; agreement; union; match; conformity; consistency; cooperation"}	\N
五つ	いつつ	{}	{five}	\N
一箇	いっか	{}	{"1 piece (inanimate objects)"}	\N
一箇	いっこ	{}	{"1 piece (inanimate objects)"}	\N
一個	いっこ	{}	{"1 piece (article)"}	\N
一日	いちにち	{}	{"first of month"}	\N
何時でも	いつでも	{}	{"(at) any time; always; at all times; never (neg); whenever"}	\N
何時の間に	いつのまに	{いつ。いつかわからないうちに。「ー仕上げたのだろう」}	{"all too soon; without our noticing it; before (we) know it; not sure since when"}	\N
一敗	いっぱい	{}	{"one defeat"}	\N
一杯	いっぱい	{}	{"one (e.g. glas)"}	\N
一般	いっぱん	{}	{"general; universal; ordinary; average; liberal"}	\N
一匹	いっぴき	{魚・虫・獣など一つ。→匹 (ひき) }	{"one (small) animal"}	\N
一変	いっぺん	{}	{"complete change; about-face"}	\N
一方	いっぽう	{}	{"one side; one way; one direction; one party; the other party; on the other hand; meanwhile; only; simple; in turn"}	\N
何時までも	いつまでも	{ある事柄が終わるときの限度がないさま。末長く。「―お幸せに」}	{"forever; as long as you like"}	\N
何時も	いつも	{}	{"always; usually; every time; never (with neg. verb)"}	\N
何時もながら	いつもながら	{常と変わらないさま。いつものことではあるが。「ー元気だね」「ーの親切」}	{"perennially; as always"}	\N
いつもながら	何時もながら	{常と変わらないさま。いつものことではあるが。「ー元気だね」「ーの親切」}	{"perennially; as always"}	\N
移転	いてん	{}	{"moving; transfer; demise"}	\N
遺伝子	いでんし	{}	{gene}	\N
意図	いと	{}	{"intention; aim; design"}	\N
糸	いと	{}	{thread}	\N
井戸	いど	{}	{"water well"}	\N
緯度	いど	{}	{"latitude (geography)"}	\N
移動	いどう	{}	{"removal; migration; movement"}	\N
異動	いどう	{}	{"a change"}	\N
従兄弟	いとこ	{}	{"male cousin"}	\N
従姉妹	いとこ	{}	{"female cousin"}	\N
営む	いとなむ	{}	{"to carry on (e.g. in ceremony); to run a business"}	\N
挑む	いどむ	{}	{"to challenge; to contend for; to make love to"}	\N
以内	いない	{}	{within}	\N
田舎	いなか	{}	{"the country; country side"}	\N
稲光	いなびかり	{}	{"(flash of) lightning"}	\N
古	いにしえ	{}	{"antiquity; ancient times"}	\N
稲	いね	{}	{"rice plant"}	\N
居眠り	いねむり	{}	{"dozing; nodding off"}	\N
命	いのち	{}	{"(mortal) life"}	\N
祈り	いのり	{}	{"prayer; supplication"}	\N
祈る	いのる	{}	{pray}	\N
尿	いばり	{}	{urine}	\N
威張る	いばる	{}	{"swagger; be proud"}	\N
違反	いはん	{}	{"violation (of law); transgression"}	\N
衣服	いふく	{}	{clothes}	\N
違法	いほう	{法律・規定などにそむくこと。また、その行為。「―駐車」⇔適法。}	{"illegality; unlawfulness"}	\N
居間	いま	{}	{"living room (Western style)"}	\N
今	いま	{}	{"this; now"}	\N
今更	いまさら	{}	{"now; at this late hour"}	\N
今道心	いま‐どうしん	{仏門に入ったばかりの者。青道心。新発意 (しんぼち) 。}	{"neophyte (a person who is new to a subject or activity)"}	\N
今に	いまに	{}	{"before long; even now"}	\N
今にも	いまにも	{}	{"at any time; soon"}	\N
意味	いみ	{}	{"meaning; significance"}	\N
忌み	いみ	{}	{lourning}	\N
移民	いみん	{}	{"emigration; immigration; emigrant; immigrant"}	\N
忌む	いむ	{}	{hate}	\N
芋	いも	{}	{"〔じゃがいも〕a potato; 〔さつまいも〕a sweet potato; a yam;"}	\N
妹	いもうと	{}	{"younger sister"}	\N
否	いや	{}	{"no; nay; yes; well"}	\N
嫌	いや	{}	{"disagreeable; detestable; unpleasant; reluctant"}	\N
嫌がる	いやがる	{}	{"hate; dislike"}	\N
卑しい	いやしい	{}	{"greedy; vulgar; shabby; humble; base; mean; vile"}	\N
意欲	いよく	{}	{"will; desire; ambition"}	\N
一定	いってい	{一つに定まって変わらないこと。「―の分量」「―の収入」}	{"fixed; settled; definite; uniform; regularized; standardized; prescribed"}	\N
暇	いとま	{}	{"free time; leisure; leave; spare time; farewell"}	\N
未だ	いまだ	{}	{"as yet; hitherto; not yet (neg)"}	\N
依頼	いらい	{}	{"request; commission; dispatch; dependence; trust"}	\N
以来	いらい	{}	{"since; henceforth"}	\N
衣料	いりょう	{}	{clothing}	\N
医療	いりょう	{}	{"medical care; medical treatment"}	\N
威力	いりょく	{}	{"power; might; authority; influence"}	\N
要る	いる	{}	{need}	\N
煎る	いる	{}	{"to parch; to fry; to fire; to broil; to roast; to boil down (in oil)"}	\N
射る	いる	{矢を弓につがえて放つ。「弓をいる」}	{"shot (e.g. an arrow)"}	\N
衣類	いるい	{}	{"clothes; clothing; garments"}	\N
入れ物	いれもの	{}	{"container; case; receptacle"}	\N
入れる	いれる	{}	{"put in; take in; bring in; let in; admit; introduce; usher in; insert; employ; listen to; tolerate; comprehend; include; pay (interest); cast (votes)"}	\N
容れる	いれる	{認めて受け入れる。認めてやる。聞きいれる。「要求を―・れる」「人を―・れる度量がない」}	{"to grant (a request); accept (an opinion); comply (to a request); to take (advice)"}	\N
挿れる	いれる	{挿入すること。慣用的な読み方。}	{"to insert (sexual context; same as 入れる)"}	\N
色	いろ	{}	{"color; sensuality; lust"}	\N
色々	いろいろ	{}	{various}	\N
彩り	いろどり	{色をつけること。彩色。}	{"〔彩色〕coloring，((英)) colouring"}	\N
異論	いろん	{}	{"different opinion; objection"}	\N
岩	いわ	{}	{"rock; crag"}	\N
祝い	いわい	{}	{"celebration; festival"}	\N
祝う	いわう	{}	{"congratulate; celebrate"}	\N
曰く	いわく	{}	{"to say; to reason"}	\N
言わば	いわば	{}	{"so to speak; so to call it; as it were"}	\N
所謂	いわゆる	{}	{"the so-called; so to speak"}	\N
員	いん	{}	{member}	\N
印鑑	いんかん	{}	{"stamp; seal"}	\N
陰気	いんき	{}	{"gloom; melancholy"}	\N
隠居	いんきょ	{}	{"retirement; retired person"}	\N
印刷	いんさつ	{}	{printing}	\N
印象	いんしょう	{}	{impression}	\N
引退	いんたい	{役職や地位から身を退くこと。スポーツなどで現役から退くこと。「ー興行」}	{retire}	\N
隠蔽	いんぺい	{人の所在、事の真相などを故意に覆い隠すこと。「証拠をーする」「ー工作」}	{"hiding; concealment"}	\N
引用	いんよう	{}	{"quotation; citation"}	\N
淫乱	いんらん	{色欲をほしいままにしてみだらなこと。また、そのさま。「―な性向」}	{"excessive indulgence in sex; alcohol; or drugs; debauchery; lechery; lasciviousness;"}	\N
飲料	いんりょう	{飲むためのもの。飲み物。「清涼―」「―水」}	{"a drink; a beverage"}	\N
引力	いんりょく	{}	{gravity}	\N
寺院	じいん	{仏寺とそれに付属する別舎をあわせた称。また、広くイスラム教・キリスト教の礼拝堂にもいう。てら。}	{temple}	\N
自衛	じえい	{}	{self-defense}	\N
自衛隊	じえいたい	{防衛省に属し、日本の平和と独立を守り、国の安全を保つことを主な任務とする防衛組織。陸上・海上・航空の三自衛隊からなり、内閣総理大臣の統率のもとに防衛大臣が隊務を統括する。昭和29年（1954）防衛庁設置法（現、防衛省設置法）に基づき、保安隊（警察予備隊の後身）・警備隊（海上警備隊の後身）を改組・改称し、新たに航空自衛隊を創設して発足。}	{"self-defense force"}	\N
字音	じおん	{ある文字の発音。}	{"the Japanized pronunciation of a Chinese character"}	\N
自我	じが	{}	{"self; the ego"}	\N
自覚	じかく	{}	{self-conscious}	\N
直に	じかに	{}	{"directly; in person; headlong"}	\N
時間	じかん	{}	{time}	\N
入口	いりぐち	{}	{"entrance; gate; approach; mouth"}	\N
入口	いりくち	{}	{"entrance; gate; approach; mouth"}	\N
入る	いる	{}	{"to get in; to go in; to come in; to flow into; to set; to set in"}	\N
居る	いる	{人や動物が、ある場所に存在する。「ペンギンは北極にはーない」「そこにー・るのは誰ですか」}	{"to be (animate); to exist"}	\N
印	いん	{}	{"seal; stamp; mark; print"}	\N
字	じ	{}	{character}	\N
地方	じかた	{}	{"area; locality; district; region; the coast"}	\N
時間帯	じかんたい	{1日のうちの、ある時刻とある時刻との間の一定の時間}	{"time zone"}	\N
時間割	じかんわり	{}	{"timetable; schedule"}	\N
直	じき	{}	{"direct; in person; soon; at once; just; near by; honesty; frankness; simplicity; cheerfulness; correctness"}	\N
磁器	じき	{}	{"porcelain; china"}	\N
時期	じき	{}	{"time; season; period"}	\N
磁気	じき	{}	{magnetism}	\N
自供	じきょう	{警察官などの取り調べに対し、容疑者・犯人が自己の犯罪事実などを申し述べること}	{confession}	\N
地形	じぎょう	{}	{"terrain; geographical features; topography"}	\N
事業	じぎょう	{}	{"project; enterprise; business; industry; operations"}	\N
軸	じく	{}	{"axis; stem; shaft; axle"}	\N
事件	じけん	{世間が話題にするような出来事。問題となる出来事。「奇妙な―が起こる」}	{"event; affair; incident; case; plot; trouble; scandal"}	\N
自己	じこ	{}	{"self; oneself"}	\N
事故	じこ	{}	{accident}	\N
事項	じこう	{}	{"matter; item; facts"}	\N
時刻	じこく	{}	{"instant; time; moment"}	\N
地獄	じごく	{}	{hell}	\N
時刻表	じこくひょう	{}	{"table; diagram; chart; timetable; schedule"}	\N
時差	じさ	{}	{"time difference"}	\N
自在	じざい	{}	{"freely; at will"}	\N
自殺	じさつ	{}	{suicide}	\N
持参	じさん	{}	{"bringing; taking; carrying"}	\N
自粛	じしゅく	{自分から進んで、行いや態度を慎むこと。「露骨な広告を業界が―する」}	{self-restraint}	\N
事実	じじつ	{}	{"fact; truth; reality"}	\N
磁石	じしゃく	{}	{magnet}	\N
自主	じしゅ	{}	{"independence; autonomy"}	\N
自首	じしゅ	{}	{"surrender; give oneself up"}	\N
自習	じしゅう	{}	{self-study}	\N
辞書	じしょ	{}	{"dictionary; lexicon"}	\N
事情	じじょう	{}	{"circumstances; consideration; conditions; situation; reasons"}	\N
耳小骨	じしょうこつ	{}	{"ear drum"}	\N
辞職	じしょく	{}	{resignation}	\N
自信	じしん	{}	{self-confidence}	\N
自身	じしん	{}	{"by oneself; personally"}	\N
自信過剰	じしんかじょう	{自分と信じていることが過ぎる}	{"overconfident (self-faith-too-much-excess)"}	\N
地震	じしん	{}	{earthquake}	\N
事前	じぜん	{}	{"prior; beforehand; in advance"}	\N
時速	じそく	{}	{"speed (per hour)"}	\N
持続	じぞく	{}	{continuation}	\N
自尊心	じそんしん	{}	{"self-respect; conceit"}	\N
字体	じたい	{}	{"type; font; lettering"}	\N
辞退	じたい	{}	{refusal}	\N
事態	じたい	{物事の状態、成り行き。「容易ならないーを収拾する」}	{"the situation; the state of affairs"}	\N
時代	じだい	{}	{"age; period; generation"}	\N
次代	じだい	{}	{"next era"}	\N
自宅	じたく	{}	{"own house"}	\N
自治	じち	{}	{"self-government; autonomy"}	\N
実感	じっかん	{}	{"feelings (actual; true)"}	\N
実業家	じつぎょうか	{}	{"industrialist; businessman"}	\N
実験	じっけん	{事柄の当否などを確かめるために、実際にやってみること。また、ある理論や仮説で考えられていることが、正しいかどうかなどを実際にためしてみること。「化学のー」「ーを繰り返す」}	{experiment}	\N
実現	じつげん	{}	{"implementation; materialization; realization"}	\N
実行	じっこう	{実際に行うこと。「計画をーに移す」「予定どおりにーする」}	{"practice; performance; realization; execution (e.g. program)"}	\N
実際	じっさい	{}	{"practical; actual condition; status quo"}	\N
実施	じっし	{}	{"enforcement; enact; put into practice; carry out; operation"}	\N
実質	じっしつ	{}	{"substance; essence"}	\N
実習	じっしゅう	{}	{"practice; training"}	\N
実情	じつじょう	{}	{"real condition; actual circumstances; actual state of affairs"}	\N
実績	じっせき	{}	{"achievements; actual results"}	\N
実践	じっせん	{}	{"practice; put into practice"}	\N
実線	じっせん	{幾何や製図などで、切れ目なく連続して引かれる線。}	{"a solid line"}	\N
実態	じったい	{}	{"truth; fact"}	\N
実に	じつに	{}	{"indeed; truly; surely"}	\N
実は	じつは	{}	{"as a matter of fact; by the way"}	\N
実費	じっぴ	{}	{"actual expense; cost price"}	\N
実物	じつぶつ	{}	{"real thing; original"}	\N
実用	じつよう	{}	{"practical use; utility"}	\N
実力	じつりょく	{}	{"merit; efficiency; arms; force"}	\N
実例	じつれい	{}	{"example; illustration"}	\N
自転	じてん	{}	{"rotation; spin"}	\N
辞典	じてん	{}	{dictionary}	\N
自転車	じてんしゃ	{}	{bicycle}	\N
自動	じどう	{}	{automatic}	\N
児童	じどう	{}	{"children; juvenile"}	\N
自動詞	じどうし	{}	{"intransitive verb (no direct obj)"}	\N
自動車	じどうしゃ	{}	{automobile}	\N
辞任	じにん	{就いていた任務・職務を、自分から申し出て辞めること。「議長を―する」}	{"resignation (from a post)"}	\N
地主	じぬし	{}	{landlord}	\N
自白	じはく	{自分の秘密や犯した罪などを包み隠さずに言うこと。自供。自首「カンニングをーする」}	{confession}	\N
地盤	じばん	{}	{"the ground"}	\N
耳鼻科	じびか	{}	{otolaryngology}	\N
字引	じびき	{}	{dictionary}	\N
自分	じぶん	{}	{"myself; oneself"}	\N
字幕	じまく	{}	{subtitles}	\N
自慢	じまん	{}	{"pride; boast"}	\N
地味	じみ	{}	{"plain; simple"}	\N
地道	じみち	{手堅く着実に物事をすること。地味でまじめなこと。また、そのさま。「―な努力をする」「―に働く」}	{"〜な steady"}	\N
事務	じむ	{}	{"business; office work"}	\N
事務所	じむしょ	{}	{office}	\N
事務局	じむきょく	{議会や団体などの、事務を取り扱う部局。}	{"a secretariat"}	\N
地元	じもと	{}	{local}	\N
邪教	じゃきょう	{}	{heresy}	\N
弱	じゃく	{}	{"weakness; the weak; little less then"}	\N
弱体化	じゃくたいか	{組織などの力が衰えること。「チームが―する」}	{weakening}	\N
蛇口	じゃぐち	{}	{"faucet; tap"}	\N
弱点	じゃくてん	{}	{"weak point; weakness"}	\N
若干	じゃっかん	{}	{"some; few; number of"}	\N
邪魔	じゃま	{}	{"obstacle; intrusion"}	\N
邪悪	じゃあく	{}	{heinous}	\N
砂利	じゃり	{}	{"gravel; ballast; pebbles"}	\N
住	じゅう	{}	{"dwelling; living"}	\N
拾	じゅう	{十番目。第十。}	{"10; ten"}	\N
自由	じゆう	{自分の意のままに振る舞うことができること。「＿な時間をもつ」「車を＿にあやつる」}	{freedom}	\N
住居	じゅうきょ	{}	{"dwelling; house; residence; address"}	\N
住居表示	じゅきょひょうじ	{日本の住居表示に関する法律に基づく住所の表し方である。地番とは異なる。}	{"address sign (showing ward and block information)"}	\N
従業員	じゅうぎょういん	{}	{"employee; worker"}	\N
重視	じゅうし	{}	{"importance; stress; serious consideration"}	\N
従事	じゅうじ	{}	{"engaging; pursuing; following"}	\N
充実	じゅうじつ	{}	{"fullness; completion; perfection; substantiality; enrichment"}	\N
柔術	じゅうじゅつ	{徒手で打つ・突く・蹴る・投げる・組み伏せるなどの方法によって相手を攻撃し、また防御する日本古来の武術。やわら。→柔道}	{ju-jutsu}	\N
従順	じゅうじゅん	{性質・態度などがすなおで、人に逆らわないこと。おとなしくて人の言うことをよく聞くこと。また、そのさま。「権力には―である」「―な部下」}	{"obedience ((to)); 〔服従〕submission ((to))"}	\N
柔順	じゅうじゅん	{性質・態度などがすなおで、人に逆らわないこと。おとなしくて人の言うことをよく聞くこと。また、そのさま。「権力には―である」「―な部下」}	{"obedience ((to)); 〔服従〕submission ((to))"}	\N
住所	じゅうしょ	{}	{address}	\N
十字路	じゅうじろ	{}	{crossroads}	\N
渋滞	じゅうたい	{}	{"congestion (e.g. traffic); delay; stagnation"}	\N
重体	じゅうたい	{}	{"seriously ill; serious condition; critical state"}	\N
重大	じゅうだい	{}	{"serious; important; grave; weighty"}	\N
銃	じゅう	{}	{gun}	\N
住宅	じゅうたく	{}	{"resident; housing"}	\N
重点	じゅうてん	{}	{"important point; lay stress on; emphasis; colon"}	\N
充電器	じゅうでんき	{}	{charge}	\N
柔道	じゅうどう	{}	{judo}	\N
柔軟	じゅうなん	{}	{"flexible; lithe"}	\N
十二支	じゅうにし	{暦法で、子 (し) ・丑 (ちゅう) ・寅 (いん) ・卯 (ぼう) ・辰 (しん) ・巳 (し) ・午 (ご) ・未 (び) ・申 (しん) ・酉 (ゆう) ・戌 (じゅつ) ・亥 (がい) の称。これらを12の動物にあてはめて、日本では、ね（鼠）・うし（牛）・とら（虎）・う（兎）・たつ（竜）・み（蛇）・うま（馬）・ひつじ（羊）・さる（猿）・とり（鶏）・いぬ（犬）・い（猪）とよぶ。時刻や方角を表すのに用い、また、十干 (じっかん) と組み合わせて年や日を表す。→十干}	{"the twelve (animal) signs of the (Chinese and Japanese) zodiac"}	\N
重複	じゅうふく	{}	{"duplication; repetition; overlapping; redundancy; restoration"}	\N
重宝	じゅうほう	{}	{"priceless treasure; convenience; usefulness"}	\N
住民	じゅうみん	{}	{"citizens; inhabitants; residents; population"}	\N
重要	じゅうよう	{物事の根本・本質・成否などに大きくかかわること。きわめて大切であること。また、そのさま。「戦略上―な地域」「―性」}	{"important; momentous; essential; principal; major"}	\N
従来	じゅうらい	{}	{"up to now; so far; traditional"}	\N
重量	じゅうりょう	{}	{"weight; heavyweight boxer"}	\N
重力	じゅうりょく	{}	{gravity}	\N
儒教	じゅきょう	{}	{confucianism}	\N
授業	じゅぎょう	{}	{"lesson; class work"}	\N
塾	じゅく	{}	{"coaching school; lessons"}	\N
熟語	じゅくご	{}	{"idiom; idiomatic phrase; kanji compound"}	\N
熟練	じゅくれん	{物事に慣れて、手際よくじょうずにできること。また、そのさま。「―を要する仕事」「―した技能」}	{"〔すぐれた腕前〕skill (in gardening; with a saw); (文) dexterity; 〔習熟〕mastery (of)"}	\N
熟練度	じゅくれんど	{}	{"level of skill"}	\N
受験	じゅけん	{}	{"taking an examination"}	\N
受諾	じゅだく	{}	{acceptance}	\N
述語	じゅつご	{}	{predicate}	\N
十つ	じゅっつ	{}	{"10 (of something)"}	\N
寿命	じゅみょう	{}	{"life span"}	\N
樹木	じゅもく	{}	{"trees and shrubs; arbour"}	\N
需要	じゅよう	{}	{"demand; request"}	\N
受理	じゅり	{}	{acceptance}	\N
樹立	じゅりつ	{}	{"establish; create"}	\N
受話器	じゅわき	{}	{"telephone receiver"}	\N
順	じゅん	{}	{"order; turn"}	\N
純	じゅん	{}	{〔混じりけがないこと〕purity}	\N
順位	じゅんい	{一定の基準によって上下あるいはあとさきの関係で順に並べられるときの、それぞれの位置。「―をつける」「―が下がる」「優先―」}	{"order; ranking"}	\N
循環	じゅんかん	{}	{"circulation; rotation; cycle"}	\N
準急	じゅんきゅう	{}	{"local express (train slower than an express)"}	\N
準拠	じゅんきょ	{あるものをよりどころとしてそれに従うこと。また、そのよりどころ。「史実に―した小説」}	{"〜する be based upon; follow"}	\N
巡査	じゅんさ	{}	{"police; policeman"}	\N
遵守	じゅんしゅ	{法律や道徳・習慣を守り、従うこと。循守。「古い伝統を―する」}	{"obey [observe／follow] (the law)"}	\N
順守	じゅんしゅ	{法律や道徳・習慣を守り、従うこと。循守。「古い伝統を―する」}	{"obey [observe／follow] (the law)"}	\N
順々	じゅんじゅん	{}	{"in order; in turn"}	\N
順序	じゅんじょ	{}	{"order; sequence; procedure"}	\N
純情	じゅんじょう	{}	{"pure heart; naivete; self-sacrificing devotion"}	\N
殉職	じゅんしょく	{}	{"dying at one's post"}	\N
準じる	じゅんじる	{}	{"to follow; to conform; to apply to"}	\N
純粋	じゅんすい	{}	{"pure; true; genuine; unmixed"}	\N
準ずる	じゅんずる	{}	{"to apply correspondingly; to correspond to; to be proportionate to; to conform to"}	\N
順調	じゅんちょう	{}	{"favourable; doing well; O.K.; all right"}	\N
街道	かいどう	{}	{highway}	\N
順応	じゅんおう	{環境や境遇の変化に従って性質や行動がそれに合うように変わること。「新しい生活に―する」「―性」}	{"adapt (oneself); adjust (oneself); conform;"}	\N
十分	じゅうぶん	{}	{enough}	\N
重役	じゅうやく	{}	{"heavy responsibilities; director"}	\N
順番	じゅんばん	{順序に従って代わる代わるそのことに当たること。順序。秩序。「ーを待つ」}	{order}	\N
準備	じゅんび	{}	{prepare}	\N
純和風式	じゅんわふうしき	{}	{"genuine japanese style"}	\N
助	じょ	{}	{"help; rescue; assistant"}	\N
状	じょう	{}	{shape}	\N
尉	じょう	{}	{"jailer; old man; rank; company officer"}	\N
嬢	じょう	{}	{"young woman"}	\N
情	じょう	{}	{"feelings; emotion; passion"}	\N
上位	じょうい	{}	{"superior (rank not class); higher order (e.g. byte); host computer (of connected device)"}	\N
攘夷	じょうい	{外敵を追い払って国内に入れないこと。}	{"the exclusion of foreigners (from Japan); 攘夷論 exclusionism; the principle of excluding foreigners"}	\N
上演	じょうえん	{}	{"performance (e.g. music)"}	\N
城下	じょうか	{}	{"land near the castle"}	\N
蒸気	じょうき	{}	{"steam; vapour"}	\N
上記	じょうき	{ある記事の上、または前に書いてあること。また、その文句。「集合時間は―のとおり」⇔下記。}	{"上述の above-mentioned [-stated]"}	\N
定規	じょうぎ	{}	{"(measuring) ruler"}	\N
上級	じょうきゅう	{}	{"advanced level; high grade; senior"}	\N
上京	じょうきょう	{}	{"proceeding to the capital (Tokyo)"}	\N
状況	じょうきょう	{移り変わる物事の、その時々のありさま；状態；環境；}	{"situation; circumstances"}	\N
上空	じょうくう	{}	{"sky; the skies; high-altitude sky; upper air"}	\N
条件	じょうけん	{}	{"conditions; terms"}	\N
上司	じょうし	{}	{"superior authorities; boss"}	\N
常識	じょうしき	{}	{"common sense"}	\N
乗車	じょうしゃ	{}	{"taking a train"}	\N
乗車券	じょうしゃけん	{}	{"a (railway; streetcar) ticket; 割引乗車券a discount ticket"}	\N
上旬	じょうじゅん	{月の1日から10日までの10日間。初旬}	{"first 10 days of month"}	\N
情緒	じょうしょ	{}	{"emotion; feeling"}	\N
上昇	じょうしょう	{}	{"rising; ascending; climbing"}	\N
浄水	じょうすい	{清らかな水。けがれのない水。}	{"clean water"}	\N
情勢	じょうせい	{}	{"state of things; condition; situation"}	\N
醸造	じょうぞう	{}	{brewing}	\N
状態	じょうたい	{人や物事の、ある時点でのありさま。状況。}	{"state; condition"}	\N
上達	じょうたつ	{}	{"improvement; advance; progress"}	\N
冗談	じょうだん	{}	{"jest; joke"}	\N
上等	じょうとう	{}	{"superiority; first-class; very good"}	\N
情熱	じょうねつ	{}	{"passion; enthusiasm; zeal"}	\N
蒸発	じょうはつ	{}	{"evaporation; unexplained disappearance"}	\N
譲歩	じょうほ	{}	{"concession; conciliation; compromise"}	\N
情報	じょうほう	{}	{"information; news; (military) intelligence; gossip"}	\N
情報屋	じょうほうや	{}	{"police informant"}	\N
条約	じょうやく	{国家間または国家と国際機関との間の文書による合意。協定}	{"a treaty; a pact"}	\N
常用	じょうよう	{日常使用すること。「―している万年筆」}	{"〔日常一般に用いること〕common use"}	\N
上陸	じょうりく	{}	{"landing; disembarkation"}	\N
蒸留	じょうりゅう	{}	{distillation}	\N
女王	じょおう	{}	{queen}	\N
除外	じょがい	{}	{"exception; exclusion"}	\N
助教授	じょきょうじゅ	{}	{"assistant professor"}	\N
叙勲	じょくん	{}	{"conferment; to consult together; compare opinions; carry on a discussion or deliberationw"}	\N
丈夫	じょうぶ	{}	{"good health; robustness; strong; solid; durable; hero; gentleman; warrior; manly person"}	\N
上	じょう	{}	{"first volume; superior quality; top; best; high class; going up"}	\N
畳	じょう	{}	{"counter for tatami mats; measure of room size (in mat units)"}	\N
乗客	じょうかく	{}	{passenger}	\N
乗客	じょうきゃく	{}	{passenger}	\N
上手	じょうず	{}	{"skill; skillful; dexterity"}	\N
助言	じょげん	{}	{"advice; suggestion"}	\N
徐行	じょこう	{}	{"going slowly"}	\N
女史	じょし	{}	{Ms.}	\N
助詞	じょし	{}	{"particle; postposition"}	\N
除湿	じょしつ	{湿気を取り除くこと。「室内を―する」「―器」}	{dehumidification}	\N
助手	じょしゅ	{}	{"helper; assistant; tutor"}	\N
徐々に	じょじょに	{}	{"slowly; little by little; gradually; steadily; quietly"}	\N
女性	じょせい	{}	{female}	\N
除染	じょせん	{施設や機器・着衣などが放射性物質や有害化学物質などによって汚染された際に、薬品などを使ってそれを取り除くこと。「―剤の噴霧」「―シャワーを浴びる」}	{Decontamination}	\N
助長	じょちょう	{}	{"promotion/fostering; help+long; じょうga * your body＋ちょう"}	\N
助動詞	じょどうし	{}	{"auxiliary verb"}	\N
女優	じょゆう	{}	{actress}	\N
自立	じりつ	{}	{"independence; self-reliance"}	\N
人格	じんかく	{}	{"personality; character; individuality"}	\N
神宮	じんぐう	{}	{"shinto shrine"}	\N
人口	じんこう	{}	{population}	\N
人工	じんこう	{}	{"artificial; man-made; human work; human skill; artificiality"}	\N
人材	じんざい	{}	{"man of talent"}	\N
人事	じんじ	{社会などの中で、個人の身分の決定などに関する事柄}	{"personnel matters [affairs]"}	\N
神社	じんじゃ	{}	{"Shinto shrine"}	\N
人種	じんしゅ	{人類を骨格・皮膚・毛髪などの形質的特徴によって分けた区分。一般的には皮膚の色により、コーカソイド（白色人種）・モンゴロイド（黄色人種）・ニグロイド（黒色人種）に大別するが、この三大別に入らない集団も多い。}	{"race (of people)"}	\N
人生	じんせい	{}	{"(human) life (i.e. conception to death)"}	\N
人造	じんぞう	{}	{"man-made; synthetic; artificial"}	\N
迅速	じんそく	{}	{"quick; fast; rapid; swift; prompt"}	\N
人体	じんたい	{}	{"human body"}	\N
甚大	じんだい	{程度のきわめて大きいさま。「―な被害」}	{"enormous; tremendous"}	\N
人物	じんぶつ	{}	{"character; personality; person; man; personage; talented man"}	\N
人文科学	じんぶんかがく	{}	{"social sciences; humanities"}	\N
人民	じんみん	{}	{"people; public"}	\N
人命	じんめい	{}	{"(human) life"}	\N
尋問	じんもん	{問いただすこと。取り調べとして口頭で質問すること。}	{"questioning; interrogation; (cross-) examination"}	\N
人目	じんもく	{}	{"glimpse; public gaze"}	\N
迅雷	じんらい	{}	{"thunderclap; åskskräll"}	\N
人類	じんるい	{人間。ひと。動物学上は、脊索動物門哺乳綱霊長目ヒト科ヒト属に分類される。}	{"mankind; humanity"}	\N
可	か	{}	{passable}	\N
仮	か	{}	{"tentative; provisional"}	\N
個	か	{}	{"article counter"}	\N
課	か	{}	{"counter for chapters (of a book)"}	\N
科	か	{}	{"department; section"}	\N
下位	かい	{}	{"low rank; subordinate; lower order (e.g. byte)"}	\N
貝	かい	{}	{"shell; shellfish"}	\N
回	かい	{}	{"counter for occurrences"}	\N
階	かい	{}	{"-floor (counter); stories"}	\N
咼	かい	{}	{[jawbone]}	\N
改悪	かいあく	{}	{"deterioration; changing for the worse"}	\N
会員	かいいん	{}	{"member; the membership"}	\N
海運	かいうん	{}	{"maritime; marine transportation"}	\N
絵画	かいが	{}	{picture}	\N
開会	かいかい	{}	{"opening of a meeting"}	\N
海外	かいがい	{}	{"foreign; abroad; overseas"}	\N
改革	かいかく	{}	{"reform; reformation; innovation"}	\N
貝殻	かいがら	{}	{shell}	\N
会館	かいかん	{}	{"meeting hall; assembly hall"}	\N
海岸	かいがん	{}	{"sea shore"}	\N
女子	じょし	{}	{"woman; girl"}	\N
人	じん	{}	{"man; person; people"}	\N
階級	かいきゅう	{}	{"class; rank; grade"}	\N
海峡	かいきょう	{}	{channel}	\N
快挙	かいきょ	{胸のすくような、すばらしい行為。痛快な行動。}	{"a splendid [heroic] achievement"}	\N
解禁	かいきん	{法律などで禁止していたことを解くこと。「アユ漁がーされる」}	{"lifting of ban; unlocking"}	\N
海軍	かいぐん	{}	{navy}	\N
会計	かいけい	{}	{"account; finance; accountant; treasurer; paymaster; reckoning; bill"}	\N
解決	かいけつ	{}	{"settlement; solution; resolution"}	\N
会見	かいけん	{}	{"interview; audience"}	\N
介護	かいご	{}	{nursing}	\N
会合	かいごう	{}	{"meeting; assembly"}	\N
海賊	かいぞく	{海上を横行し、往来の船などを襲い、財貨を脅し取る盗賊。}	{pirate}	\N
海賊版	かいぞくばん	{"《pirated edition》外国の著作物を著者・出版社の許可を受けずに複製したもの。同一国内のものについてもいう。"}	{"a pirated edition"}	\N
買い込む	かいこむ	{物をたくさん買い入れる。特に、品物の値上がりや欠乏を見越して、多く買い入れる。「値上がりを見越して―・む」}	{"bulk up〔蓄える目的で〕lay in; 〔買う〕buy; purchase"}	\N
開墾	かいこん	{}	{"reclamation; cultivating new land"}	\N
開催	かいさい	{集会や催し物を開き行うこと}	{"holding (of an event opening)"}	\N
改札	かいさつ	{}	{"examination of tickets"}	\N
解散	かいさん	{}	{"breakup; dissolution"}	\N
開始	かいし	{}	{"start; commencement; beginning"}	\N
会社	かいしゃ	{}	{"company; corporation"}	\N
解釈	かいしゃく	{}	{"explanation; interpretation"}	\N
介錯	かいしゃく	{切腹に際し、本人を即死させてその負担と苦痛を軽減するため、介助者が背後から切腹人の首を刀で斬る行為。}	{"hara-kiri assistant (2nd in command)"}	\N
介錯人	かいしゃくにん	{切腹する人のそばに付き添っていて、その人が刀を腹に突き刺すと同時に、その首を斬って死を助けてやること。また、その人。}	{"a person assisting an act of hara-kiri"}	\N
改修	かいしゅう	{}	{"repair; improvement"}	\N
回収	かいしゅう	{}	{"collection; recovery"}	\N
怪獣	かいじゅう	{}	{monster}	\N
解除	かいじょ	{今まであった制限・禁止、あるいは特別の状態などをなくして、もとの状態に戻すこと。「規制を―する」}	{"cancellation; rescinding; release; calling off"}	\N
会場	かいじょう	{}	{"the place of meeting"}	\N
海水浴	かいすいよく	{}	{"sea bathing; seawater bath"}	\N
回数	かいすう	{}	{"number of times; frequency"}	\N
回数券	かいすうけん	{}	{"book of tickets"}	\N
改正	かいせい	{}	{"revision; amendment; alteration"}	\N
快晴	かいせい	{}	{"good weather"}	\N
解析	かいせき	{事物の構成要素を細かく理論的に調べることによって、その本質を明らかにすること。「調査資料を―する」}	{analysis}	\N
解説	かいせつ	{}	{"explanation; commentary"}	\N
回線	かいせん	{電信・電話をつなぐ線。「通信ー」}	{"circuit; (communication) line"}	\N
改善	かいぜん	{}	{"betterment; improvement; incremental and continuous improvement"}	\N
回送	かいそう	{}	{forwarding}	\N
階層	かいそう	{}	{"class; level; stratum; hierarchy"}	\N
海草	かいそう	{}	{"(a kind of) seaweed; (marine) alga (複algae)"}	\N
海藻	かいそう	{}	{"(a kind of) seaweed; (marine) alga (複algae)"}	\N
快速	かいそく	{気持ちがよいほど速いこと。また、そのさま。「快速電車」の略。「通勤ー」}	{"high speed"}	\N
改造	かいぞう	{改装}	{"remodeling; reshuffle"}	\N
開拓	かいたく	{新しい分野などを切り開くこと}	{"reclamation (of wasteland); cultivation; pioneer"}	\N
会談	かいだん	{}	{"conversation; conference; discussion; interview"}	\N
階段	かいだん	{}	{stairs}	\N
懐中電灯	かいちゅうでんとう	{}	{flashlight}	\N
開通	かいつう	{}	{"opening; open"}	\N
貝塚	かいづか	{}	{"midden (old dump)"}	\N
改訂	かいてい	{}	{revision}	\N
改定	かいてい	{}	{reform}	\N
海底	かいてい	{海の底。}	{"sea bottom"}	\N
快適	かいてき	{}	{"pleasant; agreeable; comfortable"}	\N
回転	かいてん	{}	{"rotation; revolution; turning"}	\N
回答	かいとう	{}	{"reply; answer"}	\N
解答	かいとう	{}	{"answer; solution"}	\N
解読	かいどく	{}	{"deciphering; decoding"}	\N
介入	かいにゅう	{}	{intervention}	\N
開発	かいはつ	{}	{"development; exploitation"}	\N
海抜	かいばつ	{}	{"height above sea level"}	\N
回避	かいひ	{物事を避けてぶつからないようにすること。また、不都合な事態にならないようにすること。「責任を―する」}	{"〔責任などの〕evasion; 〔危険などの〕avoidance"}	\N
開封	かいふう	{郵便物などの封を切ること。「無断でーする」}	{"open (a letter)"}	\N
回復	かいふく	{}	{"recovery (from illness); improvement; rehabilitation; restoration"}	\N
介抱	かいほう	{}	{"nursing; looking after"}	\N
解放	かいほう	{}	{"release; liberation; emancipation"}	\N
開放	かいほう	{}	{"open; throw open; liberalization"}	\N
解剖	かいぼう	{}	{"dissection; autopsy"}	\N
買い物	かいもの	{}	{shopping}	\N
海洋	かいよう	{}	{ocean}	\N
回覧	かいらん	{}	{circulation}	\N
海流	かいりゅう	{}	{"ocean current"}	\N
改良	かいりょう	{}	{"improvement; reform"}	\N
回路	かいろ	{}	{"circuit (electric)"}	\N
会話	かいわ	{複数の人が互いに話すこと。また、その話。「―を交わす」「親しそうに―する」「英―」}	{"〔会談〕(a) conversation; a talk ((with)); 〔対話〕a dialogue"}	\N
買う	かう	{}	{buy}	\N
飼う	かう	{}	{"keep; raise; feed"}	\N
返す	かえす	{}	{"return (something)"}	\N
帰す	かえす	{}	{"to send back"}	\N
却って	かえって	{}	{"on the contrary; rather; all the more; instead"}	\N
帰り	かえり	{}	{"return (noun)"}	\N
省みる	かえりみる	{}	{"to reflect"}	\N
顧みる	かえりみる	{}	{"to look back; to turn around; to review"}	\N
変える	かえる	{変化する}	{change}	\N
反る	かえる	{}	{"change; turn over; turn upside down"}	\N
返る	かえる	{}	{"to return; to come back; to go back"}	\N
替える	かえる	{}	{"to exchange; to interchange; to substitute; to replace"}	\N
代える	かえる	{}	{"to exchange; to interchange; to substitute; to replace"}	\N
換える	かえる	{}	{"to exchange; to interchange; to substitute; to replace"}	\N
帰る	かえる	{}	{"go back; go home; come home; return"}	\N
顔	かお	{頭部の前面。目・口・鼻などのある部分。つら。おもて。「毎朝―を洗う」}	{face}	\N
家屋	かおく	{}	{"house; building"}	\N
顔付き	かおつき	{}	{"(outward) looks; features; face; countenance; expression"}	\N
香り	かおり	{よいにおい。香気。}	{"aroma; fragrance; scent; smell"}	\N
薫り	かおり	{よいにおい。香気。}	{"aroma; fragrance; scent; smell"}	\N
香る	かおる	{よいにおいがする。芳香を放つ。「梅が―・る」}	{"be fragrant; smell well"}	\N
薫る	かおる	{よいにおいがする。芳香を放つ。「梅が―・る」}	{"be fragrant; smell well"}	\N
課外	かがい	{}	{extracurricular}	\N
抱える	かかえる	{}	{"hold or carry under or in the arms"}	\N
価格	かかく	{}	{"price; value; cost"}	\N
化学	かがく	{}	{chemistry}	\N
科学	かがく	{}	{science}	\N
掲げる	かかげる	{}	{"to publish; to print; to carry (an article); to put up; to hang out; to hoist; to fly (a sail); to float (a flag)"}	\N
鏡	かがみ	{}	{mirror}	\N
輝く	かがやく	{}	{"shine; glitter; sparkle"}	\N
係り	かかり	{}	{"official; duty; person in charge"}	\N
係長	かかりちょう	{官庁・会社などでの役職の一。その部署の係員の長で、普通は課長の下の地位。}	{"a subsection chief"}	\N
掛かる	かかる	{}	{"take (time); need; cost"}	\N
係わる	かかわる	{重大なつながりをもつ。影響が及ぶ。「命に―・る問題」}	{"concern oneself in; have to do with; affect; influence"}	\N
関わる	かかわる	{関係をもつ。関係する。関する。「研究に―・った人々」}	{"have to do ((with))⇒かんけい(関係)"}	\N
拘る	かかわる	{こだわる。「つまらぬことに―・っている場合ではない」}	{"fixate; fuss over; be concerned"}	\N
下記	かき	{ある記事や文章のあとに書きしるすこと。また、その文章。「詳細は―のとおり」⇔上記。}	{"the following"}	\N
鍵	かぎ	{}	{key}	\N
書留	かきとめ	{}	{"writing down; putting on record"}	\N
書き取り	かきとり	{}	{dictation}	\N
書き取る	かきとる	{}	{"to write down; to take dictation; to take notes"}	\N
垣根	かきね	{}	{hedge}	\N
掻き回す	かきまわす	{}	{"to stir up; to churn; to ransack; to disturb"}	\N
限る	かぎる	{}	{"to limit; restrict; confine"}	\N
家禽	かきん	{}	{fowl}	\N
佳句	かく	{}	{"beautiful passage of literature"}	\N
格	かく	{}	{"status; character; case"}	\N
書く	かく	{文字や符号をしるす。「持ち物に名前を―・く」}	{write}	\N
欠く	かく	{}	{"to lack; to break; to crack; to chip"}	\N
画	かく	{}	{stroke}	\N
核	かく	{}	{"nucleus; kernel"}	\N
各	かく	{主に漢語名詞に付いて、多くのものの一つ一つ、一つ一つのどれもがみな、の意を表す。「―教室」「―大学」「―クラス別々に行う」}	{each}	\N
家具	かぐ	{}	{furniture}	\N
架空	かくう	{}	{"aerial; overhead; fiction; fanciful"}	\N
閣議	かくぎ	{}	{"cabinet meeting"}	\N
覚悟	かくご	{}	{"resolution; resignation; readiness; preparedness"}	\N
格差	かくさ	{資格・等級・価格などの違い。差。「賃金のーを是正する」}	{"〔相違〕a difference; 〔隔たり〕a gap"}	\N
拡散	かくさん	{}	{"scattering; diffusion"}	\N
各自	かくじ	{}	{"individual; each"}	\N
確実	かくじつ	{}	{"certainty; reliability; soundness"}	\N
各種	かくしゅ	{}	{"every kind; all sorts"}	\N
隔週	かくしゅう	{}	{"every other week"}	\N
拡充	かくじゅう	{}	{expansion}	\N
確信	かくしん	{}	{"conviction; confidence"}	\N
革新	かくしん	{}	{"reform; innovation"}	\N
核心部	かくしんぶ	{}	{crux}	\N
隠す	かくす	{}	{"to hide; to conceal"}	\N
覚醒剤	かくせいざい	{例えばアンフェタミン}	{"Awakening Drug; stimulant (e.g. meth-; ampetamine)"}	\N
拡大	かくだい	{}	{"magnification; enlargement"}	\N
核弾頭	かくだんとう	{ミサイル・魚雷などの先端に取り付ける核爆発装置。}	{"a nuclear warhead"}	\N
各地	かくち	{}	{"every place; various places"}	\N
拡張	かくちょう	{}	{"expansion; extension; enlargement; escape"}	\N
確定	かくてい	{}	{"definition (math); decision; settlement"}	\N
角度	かくど	{}	{angle}	\N
各年	かくとし	{}	{"each year"}	\N
獲得	かくとく	{}	{"acquisition; possession"}	\N
確認	かくにん	{}	{"affirmation; confirmation"}	\N
格納庫	かくのうこ	{航空機などを入れ置いたり整備を行ったりするための建物。}	{"a hangar"}	\N
格別	かくべつ	{}	{exceptional}	\N
確保	かくほ	{}	{"guarantee; ensure; maintain; insure; secure"}	\N
革命	かくめい	{}	{revolution}	\N
隔離	かくり	{へだたること。へだて離すこと。「小さい私と広い世の中とを―している此硝子戸の中へ、時々人が入って来る」}	{"isolation; quarantine"}	\N
確立	かくりつ	{}	{establishment}	\N
確率	かくりつ	{}	{probability}	\N
閣僚	かくりょう	{ミニスター}	{minister}	\N
隠れる	かくれる	{}	{"hide; be hidden; conceal oneself; disappear"}	\N
寡欲	かよく	{欲が少ないこと。また、そのさま。「―な（の）人」}	{unselfishness}	\N
寡君	かくん	{他国の人に対して自分の主君をへりくだっていう語。}	{"(humble word for lord towards other countries?)"}	\N
掛け	かけ	{}	{credit}	\N
賭け	かけ	{}	{"betting; gambling; a gamble"}	\N
陰	かげ	{}	{"shade; shadow; other side"}	\N
影	かげ	{}	{"shade; shadow; other side"}	\N
掛け合う	かけあう	{互いに掛ける。「声を―・う」}	{"(apply) to each other"}	\N
駆け足	かけあし	{}	{"running fast; double time"}	\N
家計	かけい	{}	{"household economy; family finances"}	\N
掛け算	かけざん	{}	{multiplication}	\N
可決	かけつ	{会議で、提出議案の承認を決定すること。反：否決。「賛成多数でーする」}	{"approval; adoption; passing"}	\N
角	かく	{}	{"angle; bishop (shogi)"}	\N
ヶ月	かげつ	{}	{"(number of) months"}	\N
駆けっこ	かけっこ	{}	{"(foot) race"}	\N
欠片	かけら	{物の欠けた一片。断片。「せんべいの―」}	{"〔欠けた一片〕a fragment; a broken piece"}	\N
欠ける	かける	{}	{"be lacking"}	\N
掛ける	かける	{}	{"wear; put on; hang; cover; sit down; make a phone call; multiply; turn on (a switch); play (a record); begin to"}	\N
賭ける	かける	{}	{"to wager; to bet; to risk; to stake; to gamble"}	\N
駆ける	かける	{}	{"to run (race esp. horse); to gallop; to canter"}	\N
加減	かげん	{}	{"addition and subtraction; degree; extent; measure; chance"}	\N
過去	かこ	{前のこと}	{past}	\N
火口	かこう	{}	{crater}	\N
下降	かこう	{}	{"downward; descent; fall; drop"}	\N
加工	かこう	{}	{"manufacturing; processing; treatment"}	\N
化合	かごう	{}	{"chemical combination"}	\N
囲む	かこむ	{}	{surround}	\N
傘	かさ	{}	{umbrella}	\N
笠	かさ	{}	{"shade; bamboo hat"}	\N
火災	かさい	{}	{"conflagration; fire"}	\N
火砕流	かさいりゅう	{}	{"(volcanic) eruption"}	\N
佳作	かさく	{}	{"fine work; good piece of work"}	\N
風車	かざぐるま	{}	{"windmill; pinwheel"}	\N
重ねる	かさねる	{}	{"pile up; add; repeat"}	\N
嵩張る	かさばる	{}	{"to be bulky; to be unwieldy; to grow voluminous"}	\N
飾り	かざり	{}	{decoration}	\N
飾る	かざる	{他の物を添えたり、手を加えたりするなどして、美しく見せるようにする。装飾する。「食卓を花で―・る」}	{decorate}	\N
火山	かざん	{}	{volcano}	\N
火山灰	かざんばい	{}	{"volcanic ashes"}	\N
菓子	かし	{}	{pastry}	\N
貸し	かし	{}	{"loan; lending"}	\N
華氏	かし	{}	{fahrenheit}	\N
火事	かじ	{}	{fire}	\N
家事	かじ	{}	{"housework; domestic chores"}	\N
賢い	かしこい	{}	{"wise; clever; smart"}	\N
畏まる	かしこまる	{}	{"to obey respectfully; to humble oneself; to sit straight (upright; respectfully; attentively)"}	\N
畏まりました	かしこまりました	{}	{certainly!}	\N
貸し出し	かしだし	{}	{"lending; loaning"}	\N
過失	かしつ	{}	{"error; blunder; accident"}	\N
加湿器	かしつき	{}	{humidifier}	\N
果実	かじつ	{}	{"fruit; nut; berry"}	\N
貸間	かしま	{}	{"room to let"}	\N
貸家	かしや	{}	{"house for rent"}	\N
歌手	かしゅ	{}	{singer}	\N
個所	かしょ	{}	{"passage; place; point; part"}	\N
箇所	かしょ	{}	{"passage; place; point; part"}	\N
仮称	かしょう	{}	{"temporary name"}	\N
過剰	かじょう	{}	{excess}	\N
箇条書き	かじょうがき	{}	{"itemized form; itemization"}	\N
貸す	かす	{}	{lend}	\N
課す	かす	{}	{"〔負わせる〕impose ((a task on [upon] a person)); 〔割り当てる〕assign ((a task to a person))"}	\N
微か	かすか	{}	{"faint; dim; weak; indistinct; hazy; poor; wretched"}	\N
霞	かすみ	{}	{"〔薄い霧〕a haze; a mist (hazeは煙や塵を思わせるが水分を感じさせない．mistは水分を含む)"}	\N
化する	かする	{}	{"to change into; to convert into; to transform; to be reduced; to influence; to improve (someone)"}	\N
風邪	かぜ	{}	{"common cold"}	\N
風	かぜ	{}	{"wind; cold"}	\N
火星	かせい	{}	{"Mars (planet)"}	\N
課税	かぜい	{}	{taxation}	\N
化石	かせき	{}	{"fossil; petrifaction; fossilization"}	\N
稼ぐ	かせぐ	{}	{"earn income; to labor"}	\N
下線	かせん	{}	{underline}	\N
河川	かせん	{}	{rivers}	\N
化繊	かせん	{}	{"synthetic fibres"}	\N
過疎	かそ	{}	{depopulation}	\N
数える	かぞえる	{}	{count}	\N
加速	かそく	{}	{acceleration}	\N
家族	かぞく	{}	{"family; members of a family"}	\N
加速度	かそくど	{}	{acceleration}	\N
過多	かた	{}	{"excess; superabundance"}	\N
型	かた	{}	{"mold; model; style; shape; data type"}	\N
肩	かた	{}	{shoulder}	\N
固い	かたい	{}	{"firm (not viscous or easily moved); stubborn; certain; solemn"}	\N
硬い	かたい	{}	{"solid; hard (especially metal; stone); unpolished writing"}	\N
堅い	かたい	{}	{"hard (especially wood); steadfast; honorable; stuffy writing"}	\N
難い	かたい	{}	{"difficult; hard"}	\N
課題	かだい	{}	{"subject; theme; task"}	\N
片思い	かたおもい	{}	{"unrequited love"}	\N
片仮名	かたかな	{}	{katakana}	\N
気質	かたぎ	{}	{"spirit; character; trait; temperament; disposition"}	\N
片言	かたこと	{}	{"a smattering; talk like a baby; speak haltingly"}	\N
形	かたち	{}	{"form; shape"}	\N
片付く	かたづく	{}	{"be put in order; be put to rights; be disposed of; be solved; be finished; be married (off)"}	\N
片付け	かたづけ	{}	{"tidying up; finishing"}	\N
片付ける	かたづける	{}	{"tidy up"}	\N
刀	かたな	{}	{"sword; blade"}	\N
堅物	かたぶつ	{きまじめで、融通の利かない人。かたじん。かたぞう。}	{"a strait-laced person; (口)a square;(米口)a straight arrow"}	\N
塊	かたまり	{}	{"lump; mass; clod; cluster"}	\N
固まる	かたまる	{}	{"harden; solidify; become firm; become certain"}	\N
片道	かたみち	{}	{"one-way (trip)"}	\N
傾ける	かたむける	{}	{"to incline; to list; to bend; to lean; to tip; to tilt; to slant; to concentrate on; to ruin (a country); to squander; to empty"}	\N
固める	かためる	{}	{"to harden; to freeze; to fortify"}	\N
片寄る	かたよる	{}	{"be one-sided; partial; prejudiced; biased; lean; be inclined"}	\N
偏る	かたよる	{}	{"to be one-sided; to incline; to be partial; to be prejudiced; to lean; to be biased"}	\N
語る	かたる	{話す。特に、まとまった内容を順序だてて話して聞かせる。「目撃者の―・るところによれば」「決意の程を―・る」}	{"talk; tell; recite"}	\N
傍ら	かたわら	{}	{"beside(s); while; nearby"}	\N
花壇	かだん	{}	{"flower bed"}	\N
価値	かち	{}	{"value; worth; merit"}	\N
勝ち	かち	{}	{"win; victory"}	\N
家畜	かちく	{}	{"domestic animals; livestock; cattle"}	\N
勝ち誇る	かちほこる	{}	{"bragging after a win"}	\N
勝つ	かつ	{}	{"to win"}	\N
割	かつ	{}	{"divide; cut; halve; separate; split; rip; break; crack; smash; dilute"}	\N
且つ	かつ	{}	{"yet; and"}	\N
活気	かっき	{}	{"energy; liveliness"}	\N
画期	かっき	{}	{epoch-making}	\N
担ぐ	かつぐ	{}	{"carry on shoulder"}	\N
括弧	かっこ	{}	{"parenthesis; brackets"}	\N
格好	かっこう	{}	{"shape; form; appearance; manner"}	\N
各国	かっこく	{それぞれの国。「―首脳」}	{"every [each] country [nation]; 〔諸国〕various countries [states]; 〔万国〕all states [countries]"}	\N
活字	かつじ	{}	{"printing type"}	\N
褐色	かっしょく	{}	{brown}	\N
曽て	かつて	{過去のある一時期を表す語。以前。昔。}	{"once; formerly"}	\N
勝手	かって	{他人のことはかまわないで、自分だけに都合がよいように振る舞うこと。「そんな-は許さない」}	{"selfishness; own convenience"}	\N
葛藤	かっとう	{人と人が互いに譲らず対立し、いがみ合うこと。「親子の―」}	{"(a) conflict ((between)); trouble; difficulties; complications"}	\N
活動	かつどう	{}	{"action; activity"}	\N
活発	かっぱつ	{}	{"vigor; active"}	\N
割賦	かっぷ	{}	{"allotment; quota"}	\N
活躍	かつやく	{めざましく活動すること。「社会の第一線で―する」}	{activity}	\N
活用	かつよう	{}	{"conjugation; practical use"}	\N
活力	かつりょく	{}	{"vitality; energy"}	\N
傾く	かたむく	{}	{"incline toward; slant; lurch; be disposed to; go down (sun); wane; sink; decline"}	\N
方	かた	{}	{"polite way of indicating person"}	\N
敵	かたき	{}	{"enemy; rival"}	\N
仮定	かてい	{}	{"assumption; supposition; hypothesis"}	\N
家庭	かてい	{}	{"home; family; household"}	\N
課程	かてい	{}	{"course; curriculum"}	\N
過程	かてい	{}	{"a process"}	\N
仮名	かな	{}	{"kana; alias; pseudonym; pen name"}	\N
家内	かない	{}	{"(my) wife"}	\N
悲しい	かなしい	{心が痛んで泣けてくるような気持ちである。嘆いても嘆ききれぬ気持ちだ。「友が死んで―・い」⇔うれしい。}	{"sad; miserable; ((やや文)) sorrowful"}	\N
哀しい	かなしい	{心が痛んで泣けてくるような気持ちである。嘆いても嘆ききれぬ気持ちだ。「友が死んで―・い」⇔うれしい。}	{"sad; miserable; ((やや文)) sorrowful"}	\N
悲しむ	かなしむ	{}	{"be sad; mourn for; regret"}	\N
仮名遣い	かなづかい	{}	{"kana orthography; syllabary spelling"}	\N
金槌	かなづち	{}	{"(iron) hammer; punishment"}	\N
鉄棒	かなぼう	{}	{"iron rod; crowbar; horizontal bar (gymnastics)"}	\N
必ず	かならず	{}	{certainly}	\N
必ずしも	かならずしも	{}	{"(not) always; (not) necessarily; (not) all; (not) entirely"}	\N
可成	かなり	{}	{"considerably; fairly; quite"}	\N
加入	かにゅう	{}	{"becoming a member; joining; entry; admission; subscription; affiliation; adherence; signing"}	\N
鐘	かね	{}	{"bell; chime"}	\N
予言	かねごと	{}	{"prediction; promise; prognostication"}	\N
加熱	かねつ	{}	{heating}	\N
兼ねて	かねて	{}	{simultaneously}	\N
鐘紡	かねぼう	{（会社の名前）}	{"KaneBou (company name)"}	\N
金持ち	かねもち	{}	{"rich man"}	\N
兼ねる	かねる	{一つの物が二つ以上の働きを合わせもつ。一つの物が二つ以上の用をする。「大は小を―・ねる」「書斎と応接間とを―・ねた部屋」}	{"hold (position); serve; be unable; be beyond one´s ability; cannot; hesitate to; combine with; use with; be impatient"}	\N
可能	かのう	{}	{"possible; practicable; feasible"}	\N
可能性	かのうせい	{物事が実現できる見込み。}	{possibility}	\N
彼女	かのじょ	{}	{she}	\N
下番	かばん	{}	{"going off duty"}	\N
鞄	かばん	{}	{briefcase}	\N
過半数	かはんすう	{}	{majority}	\N
華美	かび	{}	{"pomp; splendor; gaudiness"}	\N
花瓶	かびん	{}	{"(flower) vase"}	\N
株	かぶ	{}	{"share; stock; stump (of tree)"}	\N
株式	かぶしき	{}	{"stock (company)"}	\N
被せる	かぶせる	{}	{"cover (with something); plate something (with a metal); pour or dash a liquid (on something)"}	\N
被る	かぶる	{}	{"wear; put on (head); pour or dash water (on oneself)"}	\N
気触れる	かぶれる	{}	{"to react to; to be influenced by; to go overboard for"}	\N
花粉	かふん	{}	{pollen}	\N
花粉症	かふんしょう	{}	{"hay fever; pollen allergy"}	\N
壁	かべ	{}	{wall}	\N
貨幣	かへい	{}	{"money; currency; coinage"}	\N
釜	かま	{}	{"iron pot; kettle"}	\N
窯	かま	{}	{kiln}	\N
構う	かまう	{}	{"mind; care about; be concerned about"}	\N
構え	かまえ	{}	{"posture; pose; style"}	\N
構える	かまえる	{}	{"to set up"}	\N
加味	かみ	{}	{"seasoning; flavoring"}	\N
神	かみ	{}	{god}	\N
紙	かみ	{}	{paper}	\N
髪	かみ	{}	{hair}	\N
神々	かみがみ	{}	{gods}	\N
噛み切る	かみきる	{}	{"to bite off; to gnaw through"}	\N
紙屑	かみくず	{}	{wastepaper}	\N
神様	かみさま	{}	{god}	\N
剃刀	かみそり	{}	{razor}	\N
過密	かみつ	{}	{crowded}	\N
髪の毛	かみのけ	{}	{"hair (on head)"}	\N
加盟	かめい	{盟約に加入すること。団体や組織に一員として加わること。「国連に―する」}	{"affiliation ((with))"}	\N
仮面	かめん	{}	{mask}	\N
科目	かもく	{}	{"(school) subject; curriculum; course"}	\N
かも知れない	かもしれない	{断定はできないが、その可能性があることを表す。「あの建物は学校ーない」}	{"may; perhaps; might"}	\N
貨物	かもつ	{}	{"cargo; freight; money or assets"}	\N
火曜	かよう	{}	{Tuesday}	\N
歌謡	かよう	{}	{"song; ballad"}	\N
通う	かよう	{}	{"go to (school; work)"}	\N
火曜日	かようび	{}	{Tuesday}	\N
殻	から	{}	{"shell; husk; hull; chaff"}	\N
体付き	からだつき	{筋肉のつき方や骨格など、外部に現れた身体の状況・形。「ひょろっとした―」}	{"body build; figure"}	\N
空っぽ	からっぽ	{}	{"empty; vacant; hollow"}	\N
絡む	からむ	{}	{"to entangle; to entwine"}	\N
下吏	かり	{}	{"lower official"}	\N
借り	かり	{}	{"borrowing; debt; loan"}	\N
狩り	かり	{"山野で鳥獣を追いかけて捕らえること。猟 (りょう) 。狩猟。《季 冬》「弓張や―に出る子のかげぼふし／嘯山」"}	{hunting}	\N
借りる	かりる	{}	{"borrow; hire; rent; buy on credit"}	\N
刈る	かる	{}	{"cut (hair); mow (grass); clip; shear; trim; prune; harvest; reap"}	\N
軽い	かるい	{}	{"light; non-serious; minor"}	\N
加留多	かるた	{}	{"(pt:) (n) playing cards (pt: carta)"}	\N
彼	かれ	{}	{he}	\N
彼等	かれら	{}	{"they (usually male)"}	\N
彼ら	かれら	{}	{they}	\N
枯れる	かれる	{}	{"wither; die (plant)"}	\N
過労	かろう	{}	{"overwork; strain"}	\N
辛うじて	かろうじて	{}	{"barely; narrowly; just manage to do st"}	\N
川	かわ	{}	{river}	\N
河	かわ	{}	{"river; stream"}	\N
皮	かわ	{}	{"skin; hide; leather; fur; pelt; bark; shell"}	\N
革	かわ	{}	{leather}	\N
可愛い	かわいい	{}	{"pretty; cute; lovely; charming; dear; darling; pet"}	\N
可愛がる	かわいがる	{}	{"to love; to be affectionate"}	\N
可哀想	かわいそう	{}	{"poor; pitiable; pathetic"}	\N
可愛らしい	かわいらしい	{"１ 子供らしい無邪気さや見た目の好ましさで、人をほほえませるようなさま。「ー・い口もと」２ 小さくて愛らしい。「指先ほどのー・い魚」"}	{"lovely; adorable; sweet"}	\N
乾かす	かわかす	{}	{"to dry"}	\N
渇き	かわき	{のどに潤いがなくなって、水分が欲しくなること。「ビールで―をいやす」}	{〔のどの〕thirst}	\N
渇く	かわく	{}	{"be thirsty"}	\N
乾く	かわく	{}	{"get dry"}	\N
交わす	かわす	{}	{"to exchange (messages); to dodge; to parry; to avoid; to turn aside"}	\N
為替	かわせ	{}	{"money order; exchange"}	\N
瓦	かわら	{}	{"roof tile"}	\N
代わり	かわり	{}	{"instead of"}	\N
代わる	かわる	{}	{"to take the place of; to relieve; to be substituted for; to be exchanged; to change places with; to take turns; to be replaced"}	\N
代る	かわる	{}	{"take the place of; relieve; be substituted for; be exchanged; change places with; take turns; be replaced"}	\N
変わる	かわる	{}	{change}	\N
代わる代わる	かわるがわる	{}	{alternately}	\N
観	かん	{}	{"look; appearance; spectacle"}	\N
幹	かん	{}	{"(tree) trunk"}	\N
勘	かん	{}	{"perception; intuition"}	\N
缶	かん	{}	{"can; tin"}	\N
簡易	かんい	{}	{"simplicity; easiness; quasi-"}	\N
間隔	かんかく	{物と物とのあいだの距離。「ーを置いて並ぶ」}	{"interval; space (spacial; or in text)"}	\N
感慨	かんがい	{}	{"strong feelings; deep emotion"}	\N
管外	かんがい	{権限の及ぶ区域の外。管轄区域の外。⇔管内。}	{"outside jurisdiction (of a police station)"}	\N
空	から	{}	{emptiness}	\N
辛い	からい	{}	{"painful; heart-breaking"}	\N
考え	かんがえ	{}	{"thinking; thought; ideas; intention"}	\N
考える	かんがえる	{}	{think}	\N
感覚	かんかく	{}	{"sense; sensation"}	\N
管轄	かんかつ	{}	{"jurisdiction; control"}	\N
換気	かんき	{}	{ventilation}	\N
寒気	かんき	{}	{"cold; frost; chill"}	\N
換気扇	かんきせん	{家屋の壁や窓などに取り付け、モーターで羽根を回転させて室内の空気を排出する電気器具。}	{"a ventilation fan; ((英)) an extractor fan"}	\N
観客	かんきゃく	{}	{"audience; spectator(s)"}	\N
環境	かんきょう	{}	{"environment; circumstance"}	\N
関係	かんけい	{二つ以上の物事が互いにかかわり合うこと。また、そのかかわり合い。「前後のーから判断する」「事件にーする」}	{"relation; relationship"}	\N
歓迎	かんげい	{}	{"welcome; reception"}	\N
感激	かんげき	{}	{"deep emotion; impression; inspiration"}	\N
簡潔	かんけつ	{}	{"brevity; conciseness; simplicity"}	\N
還元	かんげん	{}	{"resolution; reduction; return to origins"}	\N
漢語	かんご	{}	{"Chinese word; Sino-Japanese word"}	\N
看護	かんご	{}	{"nursing; (army) nurse"}	\N
看護師	かんごし	{傷病者の看護および療養上の世話、医師の診療の補助を職業とする者。国家試験に合格し、厚生労働大臣の免許を受けた者。}	{nurse}	\N
観光	かんこう	{}	{sightseeing}	\N
慣行	かんこう	{}	{"customary practice; habit; traditional event"}	\N
刊行	かんこう	{}	{"publication; issue"}	\N
勧告	かんこく	{}	{"advice; counsel; remonstrance; recommendation"}	\N
監獄	かんごく	{}	{prison}	\N
看護婦	かんごふ	{}	{nurse}	\N
関西	かんさい	{}	{"Kansai (SW half of Japan; including Osaka)"}	\N
観察	かんさつ	{}	{"observation; survey"}	\N
換算	かんさん	{}	{"conversion; change; exchange"}	\N
閑散	かんさん	{}	{"quiet; leisure; inactivity"}	\N
監視	かんし	{}	{"observation; guarding; inspection; surveillance"}	\N
漢字	かんじ	{}	{"Chinese characters; kanji"}	\N
感じ	かんじ	{}	{"feeling; sense; impression"}	\N
感謝	かんしゃ	{}	{"thanks; gratitude"}	\N
患者	かんじゃ	{}	{"a patient"}	\N
観衆	かんしゅう	{}	{"spectators; onlookers; members of the audience"}	\N
慣習	かんしゅう	{}	{"usual (historical) custom"}	\N
干渉	かんしょう	{}	{"interference; intervention"}	\N
鑑賞	かんしょう	{}	{appreciation}	\N
勘定	かんじょう	{代金を支払うこと。また、その代金。「―を済まして店を出る」}	{"〔支払い〕payment; 〔決算〕settlement (of accounts); 〔会計〕accounts; 〔勘定書〕a bill [((米)) check]"}	\N
感情	かんじょう	{}	{"emotion(s); feeling(s); sentiment"}	\N
感触	かんしょく	{}	{"sense of touch; feeling; sensation"}	\N
感じる	かんじる	{}	{"feel; sense; experience"}	\N
感心	かんしん	{}	{"admiration; Well done!"}	\N
関心	かんしん	{}	{"concern; interest"}	\N
肝心	かんじん	{}	{"essential; fundamental; crucial; vital; main"}	\N
関する	かんする	{関係がある。かかわる。「将来に―・する問題」「映画に―・しては、ちょっとうるさい」「我―・せず」}	{"concern; be related"}	\N
感ずる	かんずる	{}	{"feel; sense"}	\N
完成	かんせい	{完全に出来上がること。すっかり仕上げること。「―を見る」「ビルが―する」「大作を―する」}	{"complete; completion; perfection; accomplishment"}	\N
歓声	かんせい	{}	{"cheer; shout of joy"}	\N
関税	かんぜい	{}	{"customs; duty; tariff"}	\N
間接	かんせつ	{}	{indirectness}	\N
感染	かんせん	{}	{"infection; contagion"}	\N
幹線	かんせん	{}	{"main line; trunk line"}	\N
完全	かんぜん	{}	{"perfection; completeness"}	\N
勧善懲悪	かんぜんちょうあく	{善事を勧め、悪事を懲らすこと。特に、小説・芝居などで、善玉が最後には栄え、悪玉は滅びるという筋書きによって示される、道徳的な見解にいう。勧懲。}	{"rewarding good and punishing evil; 〔文学で〕poetic justice"}	\N
簡素	かんそ	{}	{"simplicity; plain"}	\N
乾燥	かんそう	{}	{"dry; arid; dehydrated; insipid"}	\N
感想	かんそう	{}	{"impressions; thoughts"}	\N
観測	かんそく	{}	{observation}	\N
寒帯	かんたい	{}	{"frigid zone"}	\N
簡単	かんたん	{}	{"easy; simple"}	\N
勘違い	かんちがい	{}	{"misunderstanding; wrong guess"}	\N
官庁	かんちょう	{}	{"government office; authorities"}	\N
艦長	かんちょう	{1隻の軍艦の乗組員を指揮統率する最高責任者。}	{"(e.g. submarine) captain"}	\N
缶詰	かんづめ	{}	{"canning; canned goods; tin can"}	\N
官邸	かんてい	{大臣や長官など高級官吏の在任中に、住居として政府が提供する邸宅。「首相―」}	{"an official residence"}	\N
観点	かんてん	{}	{"point of view"}	\N
乾電池	かんでんち	{}	{"dry cell; battery"}	\N
感度	かんど	{}	{"sensitivity; severity (quake)"}	\N
関東	かんとう	{}	{"Kantou (eastern half of Japan; including Tokyo)"}	\N
感動	かんどう	{}	{"being deeply moved; deep emotion; excitement; impression"}	\N
監督	かんとく	{}	{"supervision; control; superintendence"}	\N
管内	かんない	{その役所が管轄する区域の内。⇔管外。}	{"within jurisdiction (of this police station)"}	\N
観念	かんねん	{}	{"idea; notion; conception; sense (e.g. of duty); resignation; preparedness; acceptance"}	\N
乾杯	かんぱい	{}	{"toast (drink)"}	\N
看板	かんばん	{}	{"sign; signboard; doorplate; poster; billboard; appearance; figurehead; policy; attraction; closing time"}	\N
看病	かんびょう	{}	{"nursing (a patient)"}	\N
幹部	かんぶ	{}	{"management; (executive) staff; leaders"}	\N
完璧	かんぺき	{}	{"perfection; completeness; flawless"}	\N
勘弁	かんべん	{}	{"pardon; forgiveness; forbearance"}	\N
感無量	かんむりょう	{}	{"deep feeling; inexpressible feeling; filled with emotion"}	\N
艦名	かんめい	{}	{"ship's name"}	\N
勧誘	かんゆう	{}	{"invitation; solicitation; canvassing; inducement; persuasion; encouragement"}	\N
関与	かんよ	{}	{"participation; taking part in; participating in; being concerned in"}	\N
寛容	かんよう	{}	{"forbearance; tolerance; generosity"}	\N
慣用	かんよう	{}	{"common; customary"}	\N
慣用音	かんようおん	{}	{"accustomed-use sound"}	\N
観覧	かんらん	{}	{viewing}	\N
管理	かんり	{}	{"control; management (e.g. of a business)"}	\N
官吏	かんり	{国家公務員のこと。役人。官員}	{"government official"}	\N
完了	かんりょう	{}	{"completion; conclusion"}	\N
官僚	かんりょう	{}	{"bureaucrat; bureaucracy"}	\N
慣例	かんれい	{}	{"custom; precedent; of convention"}	\N
還暦	かんれき	{}	{"60th birthday"}	\N
関連	かんれん	{ある事柄と他の事柄との間につながりがあること。連関。「―が深い」「―する事柄」「―性」「―質問」}	{"relation; connection; relevance"}	\N
貫禄	かんろく	{}	{"presence; dignity"}	\N
緩和	かんわ	{}	{"relief; mitigation"}	\N
漢和	かんわ	{}	{"Chinese-Japanese (e.g. dictionary)"}	\N
毛	け	{}	{"fur; hair; wool"}	\N
計	けい	{}	{plan}	\N
刑	けい	{}	{"penalty; sentence; punishment"}	\N
傾	けい	{}	{"lean; incline"}	\N
系	けい	{ある関係のもとにつながった統一体。体系。}	{"system; lineage; group"}	\N
軽	けい	{「軽自動車」の略。}	{"abbreviation for light car"}	\N
輕	けい	{「軽」の古い版}	{"old version of 軽 kanji"}	\N
敬意	けいい	{}	{"respect; honour"}	\N
経営	けいえい	{}	{"management; administration"}	\N
経営者	けいえいしゃ	{企業を経営する人。経営方針や経営計画を決め、基本的・全般的管理を担当する。広義には、経営管理者の総称。}	{"a manager; 〔総称〕the top management"}	\N
慶応	けいおう	{日本の元号の一つ。}	{"Keiou was a Japanese era name after Genji and before Meiji."}	\N
経過	けいか	{}	{"passage; expiration; progress"}	\N
警戒	けいかい	{}	{"warning; admonition; vigilance"}	\N
軽快	けいかい	{}	{"rhythmical (e.g. melody); casual (e.g. dress); light; nimble"}	\N
計画	けいかく	{ある事を行うために、あらかじめ方法や順序などを考えること。また、その考えの内容。もくろみ。プラン。予定。つもり。「―を立てる」「―を練る」「工場移転を―する」}	{plan}	\N
警官	けいかん	{}	{policeman}	\N
計器	けいき	{}	{"meter; gauge"}	\N
景気	けいき	{}	{"condition; state; business conditions; the times"}	\N
頃	けい	{}	{"time; about; toward; approximately (time)"}	\N
契機	けいき	{}	{"opportunity; chance"}	\N
敬具	けいぐ	{}	{"Sincerely yours"}	\N
経験	けいけん	{実際に見たり、聞いたり、行ったりすること。また、それによって得られた知識や技能など。「―を積む」「―が浅い」「いろいろな部署を―する」}	{experience}	\N
軽減	けいげん	{}	{abatement}	\N
稽古	けいこ	{}	{"practice; training; study"}	\N
敬語	けいご	{}	{"honorific; term of respect"}	\N
傾向	けいこう	{}	{"tendency; trend; inclination"}	\N
蛍光灯	けいこうとう	{}	{"fluorescent lamp; person who is slow to react"}	\N
警告	けいこく	{よくない事態が生じそうなので気をつけるよう、告げ知らせること。「再三の―を無視する」「事前に―する」}	{"warning; advice"}	\N
渓谷	けいこく	{}	{valley}	\N
掲載	けいさい	{}	{"appearance (e.g. article in paper)"}	\N
経済	けいざい	{}	{economy}	\N
警察	けいさつ	{社会公共の秩序と安全を維持するため、国家の統治権に基づき、国民に命令・強制する作用。行政・・。}	{"the police"}	\N
警察官	けいさつかん	{}	{"a policeman"}	\N
計算	けいさん	{}	{"calculation; reckoning"}	\N
掲示	けいじ	{}	{"notice; bulletin"}	\N
刑事	けいじ	{}	{"criminal case; (police) detective"}	\N
形式	けいしき	{}	{"form; formality; format; mathematics expression"}	\N
傾斜	けいしゃ	{}	{"inclination; slant; slope; bevel; list; dip"}	\N
形成	けいせい	{}	{formation}	\N
形勢	けいせい	{}	{"condition; situation; prospects"}	\N
軽率	けいそつ	{}	{"rash; thoughtless; careless; hasty"}	\N
携帯	けいたい	{}	{"carrying something"}	\N
形態	けいたい	{}	{"form; shape; figure"}	\N
毛糸	けいと	{}	{"knitting wool"}	\N
経度	けいど	{}	{longitude}	\N
系統	けいとう	{}	{"system; family line; lineage; ancestry; geological formation"}	\N
競馬	けいば	{}	{"horse racing"}	\N
刑罰	けいばつ	{}	{"judgement; penalty; punishment"}	\N
経費	けいひ	{}	{"expenses; cost; outlay"}	\N
警備	けいび	{}	{"defense; guard; policing; security"}	\N
警部	けいぶ	{}	{"police inspector"}	\N
軽蔑	けいべつ	{}	{"scorn; disdain"}	\N
契約	けいやく	{"二人以上の当事者の意思表示の合致によって成立する法律行為。売買・交換・贈与・貸借・雇用・請負・委任・寄託など。「―を結ぶ」「三年間の貸借を―する」→単独行為 →合同行為"}	{"contract; compact; agreement"}	\N
経由	けいゆ	{}	{"go by the way; via"}	\N
形容詞	けいようし	{}	{"(true) adjective"}	\N
形容動詞	けいようどうし	{}	{"adjectival noun; quasi-adjective"}	\N
経歴	けいれき	{}	{"personal history; career"}	\N
経路	けいろ	{}	{"course; route; channel"}	\N
怪我	けが	{}	{"injury; get hurt; be injured"}	\N
汚らわしい	けがらわしい	{}	{"filthy; unfair"}	\N
汚れ	けがれ	{}	{"uncleanness; impurity; disgrace"}	\N
毛皮	けがわ	{}	{"fur; skin; pelt"}	\N
今朝	けさ	{}	{"this morning"}	\N
景色	けしき	{}	{scenery}	\N
消しゴム	けしゴム	{}	{"eraser; India rubber"}	\N
化粧	けしょう	{}	{"make-up (cosmetic)"}	\N
化粧室	けしょうしつ	{化粧や身づくろいをするための部屋。洗面所。便所。}	{"bath room"}	\N
消す	けす	{}	{"erase; delete; turn off power"}	\N
削る	けずる	{}	{"shave (wood or leather); sharpen; plane; whittle; scrape off; reduce; remove; erase"}	\N
桁	けた	{}	{"column; beam; digit"}	\N
獣	けだもの	{}	{"beast; brute"}	\N
傑	けつ	{}	{excellence}	\N
血圧	けつあつ	{}	{"blood pressure"}	\N
決意	けつい	{}	{"decision; determination"}	\N
血液	けつえき	{}	{blood}	\N
結果	けっか	{}	{"result; consequence; outcome"}	\N
結核	けっかく	{}	{"tuberculosis; tubercule"}	\N
欠陥	けっかん	{}	{"defect; fault; deficiency"}	\N
汚す	けがす	{}	{"to disgrace; to dishonour"}	\N
汚れる	けがれる	{}	{"to get dirty; to become dirty"}	\N
血管	けっかん	{}	{"blood vessel"}	\N
決議	けつぎ	{}	{"resolution; vote; decision"}	\N
結局	けっきょく	{}	{"after all; eventually"}	\N
決行	けっこう	{}	{"doing (with resolve); carrying out (i.e. a plan)"}	\N
結構	けっこう	{}	{"splendid; nice; wonderful; delicious; sweet; construction; architecture; well enough; tolerably"}	\N
結合	けつごう	{}	{"combination; union"}	\N
結婚	けっこん	{}	{marriage}	\N
傑作	けっさく	{作品が非常にすぐれたできばえであること。また、その作品。「数々のーを残す」}	{"a masterpiece; a fine piece of work"}	\N
決算	けっさん	{}	{"balance sheet; settlement of accounts"}	\N
決して	けっして	{}	{"definitely; by no means; not at all"}	\N
結晶	けっしょう	{}	{"crystal; crystallization"}	\N
決勝	けっしょう	{}	{"decision of a contest; finals (in sports)"}	\N
決心	けっしん	{}	{"determination; resolution"}	\N
結成	けっせい	{}	{formation}	\N
欠席	けっせき	{}	{"absence; non-attendance"}	\N
結束	けっそく	{}	{"union; unity"}	\N
欠損	けっそん	{物の一部が欠けてなくなること}	{"a deficit; loss"}	\N
決断	けつだん	{}	{"decision; determination"}	\N
決定	けってい	{}	{"decision; determination"}	\N
欠点	けってん	{}	{"faults; defect; weakness"}	\N
欠乏	けつぼう	{}	{"want; shortage; famine"}	\N
結末	けつまつ	{最後の締めくくり。最後に到達した結果。「連載小説に―をつける」「悲惨な―」}	{"the ending"}	\N
結論	けつろん	{}	{"reason; sum up; conclude"}	\N
蹴飛ばす	けとばす	{}	{"to kick away; to kick off; to kick (someone); to refuse; to reject"}	\N
煙い	けむい	{}	{smoky}	\N
煙たい	けむたい	{}	{"smoky; feeling awkward"}	\N
煙	けむり	{}	{"smoke; fumes"}	\N
煙る	けむる	{}	{"to smoke (e.g. fire)"}	\N
家来	けらい	{}	{"retainer; retinue; servant"}	\N
蹴る	ける	{}	{kick}	\N
険しい	けわしい	{}	{"inaccessible place; impregnable position; steep place; sharp eyes"}	\N
県	けん	{}	{prefecture}	\N
権	けん	{}	{"authority; the right (to do something)"}	\N
券	けん	{}	{"ticket; coupon; bond; certificate"}	\N
圏	けん	{}	{"sphere; circle; range"}	\N
権威	けんい	{}	{"authority; power; influence"}	\N
検閲	けんえつ	{査察}	{inspection}	\N
喧嘩	けんか	{}	{quarrel/brawl/fight}	\N
見解	けんかい	{}	{"opinion; point of view"}	\N
見学	けんがく	{}	{"inspection; study by observation; field trip"}	\N
研究	けんきゅう	{}	{"study; research"}	\N
研究室	けんきゅうしつ	{}	{"study (room)"}	\N
謙虚	けんきょ	{}	{"modesty; humility"}	\N
検挙	けんきょ	{検察官・司法警察職員などが認知した犯罪行為について被疑者を取り調べること。容疑者を関係官署に引致する場合をさすこともある。「収賄容疑で―する」}	{arrest}	\N
兼業	けんぎょう	{}	{"side line; second business"}	\N
県警	けんけい	{県の警察}	{"prefecture police"}	\N
権限	けんげん	{}	{"power; authority; jurisdiction"}	\N
健康	けんこう	{異状があるかないかという面からみた、からだの状態。「ーがすぐれない」}	{health}	\N
検査	けんさ	{}	{"inspection (e.g. customs; factory); examination"}	\N
健在	けんざい	{}	{"in good health; well"}	\N
検索	けんさく	{調べて探しだすこと。特に、文献・カード・ファイル・データベース・インターネットなどの中から必要な情報を探すこと。「―の便を図る」「索引で関係事項を―する」}	{"a search"}	\N
検事	けんじ	{}	{"public prosecutor"}	\N
研修	けんしゅう	{}	{training}	\N
懸賞	けんしょう	{}	{"offering prizes; winning; reward"}	\N
聞き取り	ききとり	{}	{"listening comprehension"}	\N
効き目	ききめ	{}	{"effect; virtue; efficacy; impression"}	\N
気配	けはい	{}	{"indication; market trend; worry"}	\N
謙譲	けんじょう	{へりくだりゆずること。自分を低めることにより相手を高めること。また、控えめであるさま。謙遜 (けんそん) 。「ーの美徳」}	{"modesty; humility"}	\N
謙譲語	けんじょうご	{敬語の一。話し手が、自分または自分の側にあると判断されるものに関して、へりくだった表現をすることにより、相対的に相手や話中の人に対して敬意を表すもの。特別の語を用いる場合（「わたくし」「うかがう」「いただく」など）、接辞を付加する場合（「てまえども」など）、補助動詞などの敬語的成分を添える場合（「お..する」など）がある。}	{"modest speak"}	\N
建設	けんせつ	{}	{"construction; establishment"}	\N
健全	けんぜん	{}	{"health; soundness; wholesome"}	\N
謙遜	けんそん	{}	{"humble; humility; modesty"}	\N
見地	けんち	{}	{"point of view"}	\N
検知	けんち	{}	{experience}	\N
建築	けんちく	{}	{"construction; architecture"}	\N
県庁	けんちょう	{}	{"prefectural office"}	\N
県庁所在地	けんちょうしょざいち	{}	{"prefecture capital"}	\N
見当	けんとう	{}	{"be found; aim; mark; estimate; guess; approximation; direction;"}	\N
検討	けんとう	{よく調べ考えること。種々の面から調べて、良いか悪いかを考えること。「ーを重ねる」「問題点をーする」}	{"consideration; examination; investigation; study; scrutiny"}	\N
顕微鏡	けんびきょう	{}	{microscope}	\N
見物	けんぶつ	{}	{"sightseeing; see; look at"}	\N
憲法	けんぽう	{"国家の統治権・統治作用に関する根本原則を定める基礎法。他の法律や命令で変更することのできない国の最高法規。近代諸国では多く成文法の形をとる。→日本国憲法 →大日本帝国憲法"}	{constitution}	\N
拳法	けんぽう	{こぶしによる突きや打ち、あるいは足による蹴りを主とした格闘術。中国で古代から発達し、日本には江戸時代初め陳元贇 (ちんげんぴん) らによって伝えられた。「少林寺―」}	{"a Chinese martial art; 〔広い意味で〕kung fu"}	\N
賢明	けんめい	{}	{"wisdom; intelligence; prudence"}	\N
懸命	けんめい	{力のかぎり努めるさま。全力をつくすさま。精一杯。「―な努力」「―にこらえる」「一生―」}	{"hard; eagerness; strenuous"}	\N
倹約	けんやく	{}	{"thrift; economy; frugality"}	\N
兼用	けんよう	{}	{"multi-use; combined use; combination; serving two purposes"}	\N
権利	けんり	{一定の利益を自分のために主張し、また、これを享受することができる法律上の能力。私権と公権とに分かれる。「店のーを譲る」<->義務。->ライツ（rights）}	{"right; privilege"}	\N
権力	けんりょく	{}	{"power; authority; influence"}	\N
木	き	{}	{"tree; wood; timber"}	\N
期	き	{}	{"period; time"}	\N
気	き	{}	{"spirit; mind"}	\N
気圧	きあつ	{}	{"atmospheric pressure"}	\N
黄色い	きいろい	{}	{yellow}	\N
消える	きえる	{}	{"go out; vanish; disappear"}	\N
記憶	きおく	{}	{"memory; recollection; remembrance"}	\N
気温	きおん	{}	{temperature}	\N
飢餓	きが	{}	{hunger}	\N
器械	きかい	{}	{instrument}	\N
機械	きかい	{}	{"machine; mechanism"}	\N
機械学習	きかいがくしゅう	{}	{"machine learning"}	\N
機会	きかい	{事をするのに最も都合のよい時機。ちょうどよい折。チャンス。}	{"a chance; an opportunity"}	\N
危害	きがい	{}	{"injury; harm; danger"}	\N
着替え	きがえ	{}	{"changing clothes; change of clothes"}	\N
規格	きかく	{}	{"standard; norm"}	\N
企画	きかく	{}	{"planning; project"}	\N
着飾る	きかざる	{}	{"to dress up"}	\N
気兼ね	きがね	{}	{"hesitance; diffidence; feeling constraint; fear of troubling someone; having scruples about doing something"}	\N
気が紛れる	きがまぎれる	{}	{"be distracted"}	\N
気軽	きがる	{}	{"cheerful; buoyant; lighthearted"}	\N
器官	きかん	{}	{"organ (of body); instrument"}	\N
季刊	きかん	{}	{"quarterly (e.g. magazine)"}	\N
機関	きかん	{}	{"organ; mechanism; facility; engine"}	\N
期間	きかん	{}	{"period; term"}	\N
機関車	きかんしゃ	{}	{"locomotive; engine"}	\N
危機	きき	{}	{crisis}	\N
生	き	{}	{"pure; undiluted; raw; crude"}	\N
黄色	きいろ	{}	{"the color yellow (noun)"}	\N
帰京	ききょう	{}	{"returning to Tokyo"}	\N
企業	きぎょう	{}	{"enterprise; undertaking"}	\N
起業家	きぎょうか	{新しく事業をおこして運営する人}	{"entrepreneur (business-starting-guy)"}	\N
基金	ききん	{}	{"fund; foundation"}	\N
飢饉	ききん	{}	{famine}	\N
効く	きく	{}	{"be effective"}	\N
聞く	きく	{音・声を耳に受ける。耳に感じ取る。「物音を―・く」「見るもの―・くものすべてが珍しい」「鳥の声も―・かれない」}	{hear}	\N
聴く	きく	{注意して耳にとめる。耳を傾ける。「名曲を―・く」「有権者の声を―・く」}	{listen}	\N
訊く	きく	{尋ねる。問う。「道を―・く」「自分の胸に―・け」「彼の都合を―・いてみる」}	{"ask; inquire"}	\N
器具	きぐ	{}	{utensil}	\N
喜劇	きげき	{}	{"comedy; funny show"}	\N
棄権	きけん	{}	{"abstain from voting; renunciation of a right"}	\N
危険	きけん	{}	{danger}	\N
起源	きげん	{}	{"origin; beginning; rise"}	\N
機嫌	きげん	{}	{"humour; temper; mood"}	\N
期限	きげん	{}	{"term; period"}	\N
機構	きこう	{}	{"mechanism; organization"}	\N
気候	きこう	{}	{climate}	\N
記号	きごう	{}	{"symbol; code"}	\N
聞こえる	きこえる	{}	{"audible; can hear"}	\N
帰国	きこく	{}	{"return to country / home"}	\N
既婚	きこん	{}	{"marriage; married"}	\N
気障	きざ	{}	{"affectation; conceit; snobbery"}	\N
記載	きさい	{書類・書物などに書いて記すこと。「詳細は説明書に―されている」「―事項」}	{"mention; entry"}	\N
兆し	きざし	{}	{"signs; omen; symptoms"}	\N
貴様	きさま	{男性が、親しい対等の者または目下の者に対して用いる。また、相手をののしる場合にも用いる。おまえ。「―とおれ」「―の顔なんか二度と見たくない」}	{"YOU (bastard)"}	\N
刻む	きざむ	{}	{"mince; chop up; carve; engrave; cut fine; hash; chisel; notch"}	\N
岸	きし	{}	{"bank; shore; coast"}	\N
生地	きじ	{}	{"cloth; material; texture; one´s true character; unglazed pottery"}	\N
記事	きじ	{}	{"article; news story; report; account"}	\N
期日	きじつ	{}	{"fixed date; settlement date"}	\N
汽車	きしゃ	{}	{"train (locomotive)"}	\N
記者	きしゃ	{}	{reporter}	\N
騎手	きしゅ	{}	{ryttare}	\N
機銃	きじゅう	{機の銃}	{"machine gun"}	\N
記述	きじゅつ	{}	{"describing; descriptor"}	\N
基準	きじゅん	{}	{"standard; basis; criteria; norm"}	\N
規準	きじゅん	{}	{"standard; basis; criteria; norm"}	\N
希少	きしょう	{}	{"scarcity; rarity"}	\N
起床	きしょう	{}	{"rising; getting out of bed"}	\N
気象	きしょう	{}	{"weather; climate"}	\N
奇数	きすう	{}	{"odd number"}	\N
築く	きずく	{}	{"to build; to pile up; to amass"}	\N
傷付く	きずつく	{}	{"to be hurt; to be wounded; to get injured"}	\N
規制	きせい	{従うべききまり。規定。}	{regulation}	\N
寄生	きせい	{生物の寄生。(スル)人に頼って暮らすこと}	{"parasitism; (スル) be parasitic"}	\N
奇跡	きせき	{}	{miracle}	\N
季節	きせつ	{}	{season}	\N
着せる	きせる	{}	{"put on clothes"}	\N
汽船	きせん	{}	{steamship}	\N
気絶	きぜつ	{一時的に意識を失うこと。失神。「ショックのあまりーする」}	{"a faint; loss of consciousness"}	\N
基礎	きそ	{}	{"foundation; basis"}	\N
起訴	きそ	{}	{"objection (裁判所で)"}	\N
寄贈	きそう	{}	{"donation; presentation"}	\N
規則	きそく	{}	{regulations}	\N
規則的	きそくてき	{一定のきまりに従っているさま。規則正しいさま。「―な変化」}	{regular(ly)}	\N
貴族	きぞく	{}	{"noble; aristocrat"}	\N
既存	きぞん	{以前から存在すること。「―の施設を活用する」}	{existing}	\N
北	きた	{}	{north}	\N
期待	きたい	{あることが実現するだろうと望みをかけて待ち受けること。当てにして心待ちにすること。「―に添うよう努力する」「活躍を―している」「―薄」}	{"expectation; anticipation; hope"}	\N
気体	きたい	{}	{"vapour; gas"}	\N
鍛える	きたえる	{}	{"to forge; to drill; to temper; to train; to discipline"}	\N
帰宅	きたく	{}	{"returning home"}	\N
北口	きたぐち	{}	{"north exit"}	\N
木太刀	きだち	{木で作ったかたな。木刀。木剣。}	{"wooden sword"}	\N
気立て	きだて	{}	{"disposition; nature"}	\N
汚い	きたない	{}	{"dirty; unclean; filthy"}	\N
基地	きち	{}	{base}	\N
貴重	きちょう	{}	{"precious; valuable"}	\N
几帳面	きちょうめん	{}	{"methodical; punctual; steady"}	\N
喫煙	きつえん	{}	{smoking}	\N
切っ掛け	きっかけ	{物事を始めるための手がかりや機会。また，物事が始まる原因や動機。「話のーをさがす」「ひょんなーで友人となる」}	{"〔初め〕a start; 〔機会〕a chance; an opportunity; 〔手掛かり〕a clue; a lead"}	\N
気付く	きづく	{}	{"notice; recognize; become aware of; perceive; realize"}	\N
狐	きつね	{}	{fox}	\N
喫茶	きっさ	{}	{"tea drinking; tea house"}	\N
喫茶店	きっさてん	{}	{"coffee shop"}	\N
切手	きって	{}	{stamp}	\N
屹度	きっと	{}	{"(uk) surely; undoubtedly; certainly; without fail; sternly; severely"}	\N
切符	きっぷ	{}	{ticket}	\N
規定	きてい	{}	{"regulation; provisions"}	\N
起点	きてん	{}	{"starting point"}	\N
軌道	きどう	{}	{"orbit; railroad track"}	\N
気に入る	きにいる	{}	{"be pleased with; to suit"}	\N
気にする	きにする	{心にとめて不安に思う。心配する。「人がなんと言おうと―◦するな」}	{"mind; care; worry (about)"}	\N
記入	きにゅう	{}	{"entry; filling in of forms"}	\N
絹	きぬ	{}	{silk}	\N
記念	きねん	{}	{"commemoration; memory"}	\N
祈念	きねん	{神仏に、願いがかなうように祈ること。「世界の平和を―する」}	{"a prayer"}	\N
昨日	きのう	{}	{yesterday}	\N
機能	きのう	{}	{"function; faculty"}	\N
甲	きのえ	{}	{"1st in rank; first sign of the Chinese calendar; shell; instep; grade A"}	\N
気の毒	きのどく	{}	{"pitiful; a pity"}	\N
気迫	きはく	{力強く立ち向かってゆく精神力。「―がこもる」「―に満ちた演技」}	{"〔気概〕spirit; 〔決意〕determination; 〔積極性〕drive"}	\N
木肌	きはだ	{}	{bark}	\N
規範	きはん	{}	{"model; standard; pattern; norm; criterion; example"}	\N
基盤	きばん	{}	{"foundation; basis"}	\N
厳しい	きびしい	{}	{strict}	\N
気品	きひん	{}	{aroma}	\N
寄付	きふ	{公共事業や社寺などに、金品を贈ること。「―を募る」「被災者に衣類を―する」「―金」}	{"contribution; donation"}	\N
気風	きふう	{}	{"character; traits; ethos"}	\N
起伏	きふく	{}	{undulation}	\N
気分	きぶん	{}	{mood}	\N
規模	きぼ	{}	{"scale; scope; plan; structure"}	\N
希望	きぼう	{あることの実現をのぞみ願うこと。また、その願い。「みんなの―を入れる」「入社を―する」}	{"hope; wish; aspiration"}	\N
基本	きほん	{}	{"foundation; basis; standard"}	\N
気まぐれ	きまぐれ	{}	{"whim; caprice; whimsy; fickle; moody; uneven temper"}	\N
生真面目	きまじめ	{}	{"too serious; person who is too serious; honesty; sincerity"}	\N
期末	きまつ	{}	{"end of term"}	\N
決まり	きまり	{}	{"settlement; conclusion; regulation; rule; custom"}	\N
決まり悪い	きまりわるい	{}	{"feeling awkward; being ashamed"}	\N
決まる	きまる	{}	{"be decided"}	\N
気味	きみ	{}	{"sensation; feeling"}	\N
奇妙	きみょう	{}	{"strange; queer; curious"}	\N
記名	きめい	{}	{"signature; register"}	\N
決める	きめる	{}	{"decide; determine"}	\N
気持ち	きもち	{}	{feelings}	\N
着物	きもの	{}	{"Japanese traditional dress"}	\N
規約	きやく	{団体内で協議して決めた規則。「組合ー」「連盟ー」}	{"an agreement; the articles (of an association); the bylaws (of a corporation); rules"}	\N
客様	きゃくさま	{}	{"mr guest"}	\N
脚色	きゃくしょく	{}	{"dramatization (e.g. film)"}	\N
客席	きゃくせき	{}	{"guest seating"}	\N
脚本	きゃくほん	{}	{scenario}	\N
客間	きゃくま	{}	{"parlor; guest room"}	\N
客観	きゃっかん	{}	{objective}	\N
旧	きゅう	{}	{ex-}	\N
急	きゅう	{}	{urgent}	\N
級	きゅう	{}	{"class; grade; rank"}	\N
救援	きゅうえん	{}	{"relief; rescue; reinforcement"}	\N
休暇	きゅうか	{}	{"holiday; day off; furlough"}	\N
休学	きゅうがく	{}	{"temporary absence from school; suspension"}	\N
休業	きゅうぎょう	{}	{"closed (e.g. store); business suspended; shutdown; holiday"}	\N
究極	きゅうきょく	{}	{"ultimate; final; eventual"}	\N
窮屈	きゅうくつ	{}	{"narrow; tight; stiff; rigid; uneasy; formal; constrained"}	\N
休憩	きゅうけい	{}	{"rest; break; recess; intermission"}	\N
急激	きゅうげき	{}	{"sudden; precipitous; radical"}	\N
急行	きゅうこう	{}	{"express train"}	\N
休講	きゅうこう	{}	{"lecture cancelled"}	\N
球根	きゅうこん	{}	{"(plant) bulb"}	\N
救済	きゅうさい	{}	{"relief; aid; rescue; salvation; help"}	\N
給仕	きゅうじ	{}	{"office boy (girl); page; waiter"}	\N
吸収	きゅうしゅう	{}	{"absorption; suction; attraction"}	\N
救出	きゅうしゅつ	{危険な状態から救い出すこと。}	{rescue}	\N
救助	きゅうじょ	{}	{"relief; aid; rescue"}	\N
給食	きゅうしょく	{}	{"school lunch; providing a meal"}	\N
急須	きゅうす	{}	{"teapot (漢字：hurry + ought)"}	\N
休戦	きゅうせん	{}	{"truce; armistice"}	\N
休息	きゅうそく	{}	{"rest; relief; relaxation"}	\N
急速	きゅうそく	{}	{"rapid (e.g. progress)"}	\N
旧知	きゅうち	{}	{"old friend; old friendship"}	\N
窮地	きゅうち	{追い詰められて逃げ場のない苦しい状態や立ち場。「ーに陥る」}	{"a difficult situation; a predicament; 「ーに陥った」caught in a dilemma."}	\N
宮殿	きゅうでん	{}	{palace}	\N
急に	きゅうに	{}	{suddenly}	\N
窮乏	きゅうぼう	{}	{poverty}	\N
救命いかだ	きゅうめいいかだ	{}	{"life raft"}	\N
旧友	きゅうゆう	{}	{"old friend"}	\N
給与	きゅうよ	{}	{"allowance; grant; supply"}	\N
休養	きゅうよう	{}	{"rest; break; recreation"}	\N
給料	きゅうりょう	{}	{"salary; wages"}	\N
丘陵	きゅうりょう	{}	{hill}	\N
寄与	きよ	{}	{"contribution; service"}	\N
清い	きよい	{}	{"clear; pure; noble"}	\N
共	きょう	{}	{"both; neither (neg); all; and; as well as; including; with; together with; plural ending"}	\N
供	きょう	{}	{"offer; present; submit; serve (a meal); supply"}	\N
器用	きよう	{}	{"skillful; handy"}	\N
凶悪	きょうあく	{}	{"Heinous; vidrig; avskyvärd"}	\N
驚異	きょうい	{}	{"wonder; miracle"}	\N
教育	きょういく	{訓練；教えること}	{education}	\N
教員	きょういん	{}	{"teaching staff"}	\N
強化	きょうか	{}	{"strengthen; intensify; reinforce; solidify"}	\N
教科	きょうか	{}	{"subject; curriculum"}	\N
境界	きょうかい	{}	{boundary}	\N
協会	きょうかい	{}	{"association; society; organization"}	\N
教会	きょうかい	{}	{church}	\N
共学	きょうがく	{}	{coeducation}	\N
教科書	きょうかしょ	{}	{"text book"}	\N
恐喝	きょうかつ	{相手の弱みなどにつけこみおどすこと。また、おどして金品をゆすりとること。「収賄をねたにーする」}	{"〔脅し〕a threat; a menace; intimidation; 〔ゆすり〕blackmail; extortion"}	\N
共感	きょうかん	{}	{"sympathy; response"}	\N
九	きゅう	{}	{nine}	\N
凶器	きょうき	{人を殺傷するために用いられる道具}	{"a (lethal) weapon"}	\N
虚偽	きょぎ	{真実ではないのに、真実のように見せかけること。うそ。いつわり。「ーの申し立て」}	{"falsehood; untruth; fictionhood"}	\N
競技	きょうぎ	{}	{"game; match; contest"}	\N
協議	きょうぎ	{}	{"conference; consultation; discussion; negotiation"}	\N
供給	きょうきゅう	{}	{"supply; provisions"}	\N
境遇	きょうぐう	{}	{"environment; circumstances"}	\N
教訓	きょうくん	{}	{"lesson; precept; moral instruction"}	\N
狂言	きょうげん	{}	{"〔能狂言〕a farce presented between Noh plays〔芝居の出し物〕a play〔偽り〕a sham"}	\N
強硬	きょうこう	{}	{"firm; vigorous; unbending; unyielding; strong; stubborn; hard-line"}	\N
強行	きょうこう	{}	{"forcing; enforcement"}	\N
胸骨	きょうこつ	{}	{sternum}	\N
教材	きょうざい	{}	{"teaching materials"}	\N
凶作	きょうさく	{}	{"bad harvest; poor crop"}	\N
共産	きょうさん	{}	{communism}	\N
教師	きょうし	{}	{"classroom teacher"}	\N
教旨	きょうし	{}	{"dogma; doctrine"}	\N
教室	きょうしつ	{}	{classroom}	\N
享受	きょうじゅ	{}	{"reception; acceptance; enjoyment; being given"}	\N
教授	きょうじゅ	{}	{"teaching; instruction; professor"}	\N
教習	きょうしゅう	{}	{"training; instruction"}	\N
郷愁	きょうしゅう	{}	{"nostalgia; homesickness"}	\N
恐縮	きょうしゅく	{}	{"shame; very kind of you; sorry to trouble"}	\N
教職	きょうしょく	{}	{"teaching certificate; the teaching profession"}	\N
興じる	きょうじる	{}	{"to amuse oneself; to make merry"}	\N
強靭	きょうじん	{しなやかで強いこと。柔軟でねばり強いこと。また、そのさま。「―な肉体」「―な意志」}	{"〜な tough; strong"}	\N
強制	きょうせい	{}	{"obligation; coercion; compulsion; enforcement"}	\N
矯正	きょうせい	{}	{"〔行いなどを改めさせること〕reform; 〔誤りを正すこと〕correction"}	\N
競争	きょうそう	{}	{compete}	\N
共存	きょうそん	{}	{coexistence}	\N
兄弟	きょうだい	{}	{siblings}	\N
強大	きょうだい	{強くて大きいこと。また、そのさま。「―な勢力を誇る」⇔弱小。}	{"〜な mighty"}	\N
協調	きょうちょう	{}	{"co-operation; conciliation; harmony; firm (market) tone"}	\N
強調	きょうちょう	{}	{"emphasis; stress; stressed point"}	\N
共通	きょうつう	{}	{"commonness; community"}	\N
協定	きょうてい	{}	{"arrangement; pact; agreement"}	\N
共同	きょうどう	{}	{"cooperation; association; collaboration; joint"}	\N
脅迫	きょうはく	{}	{"threat; menace; coercion; terrorism"}	\N
恐怖	きょうふ	{}	{"be afraid; dread; dismay; terror"}	\N
興味	きょうみ	{その物事が感じさせるおもむき。おもしろみ。}	{interest}	\N
共鳴	きょうめい	{}	{"resonance; sympathy"}	\N
教諭	きょうゆ	{先生。教師。}	{"a teacher"}	\N
教養	きょうよう	{}	{"culture; education; refinement; cultivation"}	\N
強要	きょうよう	{無理に要求すること。無理やりさせようとすること。}	{"extortion; coercion; strong persuation"}	\N
郷里	きょうり	{}	{"birth-place; home town"}	\N
強力	きょうりょく	{}	{"powerful; strong"}	\N
協力	きょうりょく	{}	{"cooperation; collaboration"}	\N
強烈	きょうれつ	{力・作用・刺激が強く激しいこと。また、そのさま。「―なパンチ」「―な個性」「―なにおい」}	{"strong; intense; severe"}	\N
共和	きょうわ	{}	{"republicanism; cooperation"}	\N
許可	きょか	{}	{"permission; approval"}	\N
局	きょく	{}	{"channel (i.e. TV or radio); department; affair; situation"}	\N
曲	きょく	{}	{"tune; piece of music"}	\N
局限	きょくげん	{}	{"limit; localize"}	\N
曲線	きょくせん	{}	{curve}	\N
極端	きょくたん	{}	{"extreme; extremity"}	\N
局長	きょくちょう	{局と名のつく組織の最高責任者。}	{"the chief of a bureau; a bureau chief"}	\N
居住	きょじゅう	{}	{residence}	\N
拒絶	きょぜつ	{}	{"refusal; rejection"}	\N
巨大	きょだい	{}	{"huge; gigantic; enormous"}	\N
近代	きんだい	{}	{"present day"}	\N
拠点	きょてん	{活動の足場となる重要な地点・~基地拠点「販売の―を築く」「軍事―」}	{"base; foothold"}	\N
去年	きょねん	{}	{"last year"}	\N
拒否	きょひ	{}	{"denial; veto; rejection; refusal"}	\N
許容	きょよう	{}	{"permission; pardon"}	\N
清らか	きよらか	{}	{"clean; pure; chaste"}	\N
距離	きょり	{}	{"distance; range"}	\N
嫌い	きらい	{}	{"dislike; hate"}	\N
嫌う	きらう	{}	{"hate; dislike; loathe"}	\N
気楽	きらく	{}	{"at ease; comfortable"}	\N
切り	きり	{}	{"limits; end; bounds; period; place to leave off; closing sentence; all there is; only; since"}	\N
霧	きり	{}	{"fog; mist"}	\N
切り替える	きりかえる	{}	{"to change; to exchange; to convert; to renew; to throw a switch; to replace; to switch over"}	\N
規律	きりつ	{}	{"order; rules; law"}	\N
気流	きりゅう	{}	{"atmospheric current"}	\N
切る	きる	{}	{"cut; chop; hash; carve; saw; clip; shear; slice; strip; cut down; punch; sever (connections); pause; break off; disconnect; turn off; hang up; cross (a street); finish; be through; complete"}	\N
斬る	きる	{}	{"murder; behead"}	\N
切れ	きれ	{}	{"cloth; piece; cut; chop; strip; slice; scrap"}	\N
奇麗	きれい	{色・形などが華やかな美しさをもっているさま。「ーな花」「ーに着飾る」}	{"pretty; clean; nice; tidy; beautiful; fair"}	\N
綺麗	きれい	{色・形などが華やかな美しさをもっているさま。「ーな花」「ーに着飾る」}	{"pretty; clean; nice; tidy; beautiful; fair"}	\N
亀裂	きれつ	{}	{"cracking (e.g. the road; ground; earth)"}	\N
切れ目	きれめ	{}	{"break; pause; gap; end; rift; interruption; cut; section; notch; incision; end (of a task)"}	\N
切れる	きれる	{}	{"be sharp (blade); break (off); snap; wear out; burst; collapse; be injured; be disconnected; be out of; expire; be shrewd; have a sharp mind"}	\N
記録	きろく	{}	{"record; minutes; document"}	\N
極み	きわみ	{きわまるところ。物事の行きつくところ。極限。限り。「天地のー」「無礼のー」}	{"pinnacle; height; extremety"}	\N
極めて	きわめて	{}	{"exceedingly; extremely"}	\N
極める	きわめる	{極点に達した状態になる。この上もない程度までそうなる。「ぜいたくを―・める」「困難を―・める」}	{"〔高い所に行き着く〕reach (e.g. a summit)〔この上もなく…である〕extreme; no higher"}	\N
窮める	きわめる	{極点に達した状態になる。この上もない程度までそうなる。「ぜいたくを―・める」「困難を―・める」}	{"〔高い所に行き着く〕reach (e.g. a summit)〔この上もなく…である〕extreme; no higher"}	\N
究める	きわめる	{深く研究して、すっかり明らかにする。「真理を―・める」「道を―・める」}	{"arrived at the end (of a road/research)"}	\N
気を付ける	きをつける	{}	{"be careful; pay attention"}	\N
僅	きん	{}	{"a little; small quantity"}	\N
斤	きん	{}	{"catty (chinese unit)"}	\N
禁煙	きんえん	{}	{"No Smoking!"}	\N
金額	きんがく	{}	{"amount of money"}	\N
近眼	きんがん	{}	{"nearsightedness; shortsightedness; myopia"}	\N
緊急	きんきゅう	{}	{"urgent; pressing; emergency"}	\N
金魚	きんぎょ	{}	{goldfish}	\N
均衡	きんこう	{}	{"equilibrium; balance"}	\N
近郊	きんこう	{}	{"suburbs; outskirts"}	\N
禁止	きんし	{ある行為を行わないように命令すること。「通行を―する」「外出―」}	{"prohibition; ban"}	\N
近視	きんし	{}	{shortsightedness}	\N
近所	きんじょ	{}	{"neighbor hood"}	\N
禁じる	きんじる	{}	{"to prohibit"}	\N
謹慎	きんしん	{}	{"penitence; discipline; house arrest"}	\N
謹慎処分	きんしんしょぶん	{discipline罰}	{"disciplinary punishment"}	\N
禁ずる	きんずる	{}	{"to forbid; to suppress"}	\N
禁制	きんせい	{ある行為を禁じること。また、その法規。「男子―」}	{"〜の forbidden; prohibited"}	\N
金銭	きんせん	{}	{"money; cash"}	\N
金属	きんぞく	{}	{metal}	\N
金玉	きんだま	{男性の精子をつくる器官。精巣 (せいそう) のこと。}	{"the testicles; the testes"}	\N
緊張	きんちょう	{}	{"tension; mental strain; nervousness"}	\N
筋肉	きんにく	{}	{"muscle; sinew"}	\N
金髪	きんぱつ	{}	{"blond; golden hair"}	\N
勤勉	きんべん	{}	{"industry; diligence"}	\N
勤務	きんむ	{}	{"service; duty; work"}	\N
禁物	きんもつ	{}	{"taboo; forbidden thing"}	\N
金融	きんゆう	{金銭の融通。特に、資金の借り手と貸し手のあいだで行われる貨幣の信用取引。}	{"monetary circulation; credit situation〔資金の貸し借り〕finance; financing"}	\N
金曜	きんよう	{}	{Friday}	\N
金曜日	きんようび	{}	{Friday}	\N
勤労	きんろう	{}	{"labor; exertion; diligent service"}	\N
児	こ	{}	{"child; the young of animals"}	\N
故	こ	{}	{"the late (deceased)"}	\N
巨	こ	{}	{"big; large; great"}	\N
弧	こ	{弓なりに湾曲した線。}	{arc}	\N
恋	こい	{}	{"love; tender passion"}	\N
濃い	こい	{}	{"thick (as of color; liquid); dense; strong"}	\N
故意	こい	{わざとすること。また、その気持ち。「ーに取り違える」}	{intention}	\N
恋しい	こいしい	{}	{"dear; beloved; darling;yearned for"}	\N
恋する	こいする	{}	{"to fall in love with; to love"}	\N
恋人	こいびと	{}	{"lover; sweetheart"}	\N
校	こう	{}	{"-school; proof"}	\N
溝	こう	{}	{"10^38; hundred undecillion (American); hundred sextillion (British)"}	\N
請う	こう	{他人に、物を与えてくれるよう求める。訊く}	{"ask; inquire"}	\N
好意	こうい	{}	{"good will; favor; courtesy"}	\N
行為	こうい	{}	{"act; deed; conduct"}	\N
行員	こういん	{}	{"bank clerk"}	\N
工員	こういん	{}	{"factory worker"}	\N
幸運	こううん	{}	{"good luck; fortune"}	\N
光栄	こうえい	{業績や行動を褒められたり、重要な役目を任されたりして、名誉に思うこと。栄えること。「ーの至り」「身に過ぎてーなこと」}	{"honor; privilage; glory"}	\N
交易	こうえき	{}	{"trade; commerce"}	\N
公園	こうえん	{}	{"(public) park"}	\N
公演	こうえん	{}	{"public performance"}	\N
講演	こうえん	{}	{"lecture; address"}	\N
高価	こうか	{}	{"high price"}	\N
硬貨	こうか	{}	{coin}	\N
硬化	こうか	{}	{curing}	\N
効果	こうか	{}	{"effect; effectiveness; efficacy; result"}	\N
航海	こうかい	{}	{"sail; voyage"}	\N
子	こ	{}	{child}	{動物}
椎茸	しいたけ	{}	{"Shiitake; Lentinula edodes"}	{菌類}
後悔	こうかい	{}	{"regret; repentance"}	\N
公開	こうかい	{}	{"presenting to the public"}	\N
郊外	こうがい	{}	{suburbs}	\N
公害	こうがい	{}	{"public nuisance; pollution"}	\N
工学	こうがく	{}	{engineering}	\N
工学部	こうがくぶ	{}	{"department of engineering"}	\N
交換	こうかん	{}	{"exchange; interchange; reciprocity; barter; substitution"}	\N
講義	こうぎ	{}	{lecture}	\N
抗議	こうぎ	{}	{"protest; objection"}	\N
高級	こうきゅう	{}	{"high class; high grade"}	\N
皇居	こうきょ	{}	{"Imperial Palace"}	\N
好況	こうきょう	{}	{"prosperous conditions; healthy economy"}	\N
公共	こうきょう	{社会一般。おおやけ。また、社会全体あるいは国や公共団体がそれにかかわること。「―の建物」}	{"public; community; public service; society; communal"}	\N
工業	こうぎょう	{}	{industry}	\N
鉱業	こうぎょう	{}	{"mining industry"}	\N
興業	こうぎょう	{}	{"industrial enterprise"}	\N
高血圧	こうけつあつ	{血圧が持続的に異常に高くなっている状態。一般に、最大血圧140ミリメートル水銀柱、最小血圧90ミリメートル水銀柱以上をいう。高血圧症。血圧亢進症。→低血圧}	{"high blood pressure; hypertension"}	\N
公共交通	こうきょうこうつう	{一般の人々が共同で使用する交通機関。鉄道・バス・航空路・フェリーなど。}	{"public transport"}	\N
航空	こうくう	{}	{"aviation; flying"}	\N
航空券	こうくうけん	{}	{"flight ticket"}	\N
皇宮	こうぐう	{}	{"imperial palace"}	\N
航空機	こうくうき	{人が乗って空中を航行する機器の総称。飛行船・気球・グライダー・飛行機・ヘリコプターなど。現在では主に飛行機をさす。}	{"a plane，((米)) an airplane，((英)) an aeroplane; 〔総称〕aircraft"}	\N
光景	こうけい	{}	{"scene; spectacle"}	\N
工芸	こうげい	{}	{"industrial arts"}	\N
後継者	こうけいしゃ	{}	{successor}	\N
攻撃	こうげき	{}	{"attack; strike; offensive; criticism; censure"}	\N
貢献	こうけん	{ある物事や社会のために役立つように尽力すること。貢ぎ物を奉ること。また、その品物。「学界の発展にーする」「ー度」}	{"contribution; services"}	\N
高原	こうげん	{}	{"tableland; plateau"}	\N
交互	こうご	{}	{"mutual; reciprocal; alternate"}	\N
高校	こうこう	{}	{"high school"}	\N
孝行	こうこう	{}	{"filial piety"}	\N
皇后	こうごう	{}	{"empress; queen"}	\N
高校生	こうこうせい	{}	{"high school student"}	\N
考古学	こうこがく	{}	{archaeology}	\N
広告	こうこく	{}	{advertisement}	\N
広告欄	こうこくらん	{}	{"an advertising column [section]; 〔新聞の三行広告欄〕the classified ads"}	\N
交差	こうさ	{}	{cross}	\N
交際	こうさい	{}	{"company; friendship; association; society; acquaintance"}	\N
工作	こうさく	{}	{"work; construction; handicraft; maneuvering"}	\N
耕作	こうさく	{}	{"cultivation; farming"}	\N
交錯	こうさく	{いくつかのものが入りまじること。「夢と現実がーする」}	{"mix; intertwine"}	\N
交差点	こうさてん	{}	{"crossing; intersection"}	\N
鉱山	こうざん	{}	{"mine (ore)"}	\N
講師	こうし	{}	{lecturer}	\N
皇嗣	こうし	{天子（皇帝や天皇）の跡継ぎのことである。}	{"emperor's oldest son? tronarvinge?"}	\N
工事	こうじ	{}	{"construction work"}	\N
公式	こうしき	{}	{"formula; formality; official"}	\N
口実	こうじつ	{}	{excuse}	\N
校舎	こうしゃ	{}	{"school building"}	\N
後者	こうしゃ	{}	{"the latter"}	\N
侯爵	こうしゃく	{もと五等爵の第二位。伯爵の上。公爵の下。爵}	{marquis}	\N
講習	こうしゅう	{}	{"short course; training"}	\N
公衆	こうしゅう	{}	{"the public"}	\N
口述	こうじゅつ	{}	{"verbal statement"}	\N
控除	こうじょ	{}	{"subsidy; deduction"}	\N
高尚	こうしょう	{}	{"high; noble; refined; advanced"}	\N
交渉	こうしょう	{}	{"negotiations; discussions; connection"}	\N
向上	こうじょう	{}	{"elevation; rise; improvement; advancement; progress"}	\N
講じる	こうじる	{手段を取る。「講ずる」の上一段化。}	{"take (an action; the right step); try (a possibiliy)"}	\N
行進	こうしん	{}	{"march; parade"}	\N
更新	こうしん	{}	{update}	\N
香辛料	こうしんりょう	{}	{spices}	\N
降水	こうすい	{}	{"rainfall; precipitation"}	\N
香水	こうすい	{}	{perfume}	\N
洪水	こうずい	{}	{flood}	\N
構成	こうせい	{文芸・音楽・造形芸術などで、表現上の諸要素を独自の手法で組み立てて作品にすること。「番組を―する」}	{"organization; composition"}	\N
公正	こうせい	{}	{"justice; fairness; impartiality"}	\N
功績	こうせき	{}	{"achievements; merit; meritorious service; meritorious deed"}	\N
光線	こうせん	{}	{"beam; light ray"}	\N
公然	こうぜん	{}	{"open (e.g. secret); public; official"}	\N
酵素	こうそ	{}	{enzyme}	\N
高層	こうそう	{}	{upper}	\N
構想	こうそう	{}	{"plan; plot; idea; conception"}	\N
抗争	こうそう	{}	{"dispute; resistance"}	\N
構造	こうぞう	{}	{"structure; construction"}	\N
高速	こうそく	{}	{"high speed; high gear"}	\N
拘束	こうそく	{思想・行動などの自由を制限すること。「時間に―される」}	{"restriction; restraint〔監禁〕confinement〔拘留〕custody"}	\N
交替	こうたい	{}	{"alternation; change; shift; relief; relay"}	\N
後退	こうたい	{}	{"retreat; backspace (BS)"}	\N
光沢	こうたく	{}	{"brilliance; polish; lustre; glossy finish (of photographs)"}	\N
公団	こうだん	{}	{"public corporation"}	\N
耕地	こうち	{}	{"arable land"}	\N
巧遅	こうち	{出来ばえはすぐれているが、仕上がりまでの時間がかかること。⇔拙速。}	{"slow craft"}	\N
好調	こうちょう	{}	{"favourable; promising; satisfactory; in good shape"}	\N
校長	こうちょう	{}	{principal}	\N
交通	こうつう	{人・乗り物などが行き来すること。通行。「―のさまたげになる」「―止め」}	{traffic}	\N
交通機関	こうつうきかん	{}	{"transportation facilities"}	\N
交通規制	こうつうきせい	{}	{"regulation of traffic"}	\N
校庭	こうてい	{}	{campus}	\N
高弟	こうてい	{}	{"best pupil"}	\N
肯定	こうてい	{そうだと言うこと。認めりこと}	{"affirmation; acknowledgement"}	\N
皇帝	こうてい	{おもに中国で、天子または国王の尊称。秦の始皇帝が初めて称した。}	{"an emperor; sovereign"}	\N
光点	こうてん	{テレビやレーダーなどの受信画像をブラウン管面に表示する場合、画素に相当する走査線ビーム。輝点。}	{"a luminous point; 〔天体〕a radiant"}	\N
更迭	こうてつ	{}	{"recall; change; shake-up"}	\N
高度	こうど	{}	{"altitude; height; advanced"}	\N
口頭	こうとう	{}	{oral}	\N
高等	こうとう	{}	{"high class; high grade"}	\N
高騰	こうとう	{}	{inflation}	\N
講堂	こうどう	{}	{"lecture hall"}	\N
行動	こうどう	{}	{"action; conduct; behaviour; mobilization"}	\N
高等学校	こうとうがっこう	{}	{"senior high school"}	\N
購読	こうどく	{}	{"subscription (e.g. magazine)"}	\N
講読	こうどく	{}	{"reading; translation"}	\N
坑内	こうない	{}	{"underground; within a pit/shaft"}	\N
購入	こうにゅう	{}	{"purchase; buy"}	\N
公認	こうにん	{}	{"official recognition; authorization; licence; accreditation"}	\N
光熱費	こうねつひ	{}	{"cost of fuel and light"}	\N
荒廃	こうはい	{}	{ruin}	\N
後輩	こうはい	{}	{"junior (at work or school)"}	\N
購買	こうばい	{}	{"purchase; buy"}	\N
交番	こうばん	{}	{"police box"}	\N
好評	こうひょう	{}	{"popularity; favorable reputation"}	\N
公表	こうひょう	{}	{"official announcement; proclamation"}	\N
交付	こうふ	{}	{"delivering; furnishing (with copies)"}	\N
降伏	こうふく	{}	{"capitulation; surrender; submission"}	\N
幸福	こうふく	{}	{"happiness; blessedness"}	\N
鉱物	こうぶつ	{}	{mineral}	\N
興奮	こうふん	{}	{"excitement; stimulation; agitation; arousal"}	\N
公平	こうへい	{}	{"fairness; impartial; justice"}	\N
候補	こうほ	{}	{candidacy}	\N
凝らす	こごらす	{}	{"to freeze; to congeal"}	\N
航法	こうほう	{船舶または航空機が、所定の二地点間を、所定の時間内に正確かつ安全に航行するための技術・方法。地文 (ちもん) 航法・天文航法・電波航法などがある。}	{navigation}	\N
公募	こうぼ	{}	{"public appeal; public contribution"}	\N
巧妙	こうみょう	{}	{"ingenious; skillful; clever; deft"}	\N
公務	こうむ	{}	{"official business; public business"}	\N
公務員	こうむいん	{}	{"public servant"}	\N
項目	こうもく	{物事を、ある基準で区分けしたときの一つ一つ。「資料を―別に整理する」}	{"item; 〔題目〕a head(ing); 〔表や計算書などの細目〕an item; 〔条項〕a clause; a provision (in a will)"}	\N
公用	こうよう	{}	{"government business; public use; public expense"}	\N
甲羅	こうら	{}	{shell}	\N
小売	こうり	{}	{retail}	\N
公立	こうりつ	{}	{"public (institution)"}	\N
効率	こうりつ	{}	{efficiency}	\N
攻略	こうりゃく	{}	{capture}	\N
交流	こうりゅう	{}	{"alternating current; intercourse; (cultural) exchange; intermingling"}	\N
考慮	こうりょ	{}	{"consideration; taking into account"}	\N
香料	こうりょう	{}	{spice}	\N
効力	こうりょく	{}	{"effect; efficacy; validity; potency"}	\N
恒例	こうれい	{いつもきまって行われること。多く、儀式や行事にいう。また、その儀式や行事。「新春―の歌会」「―によって一言御挨拶申し上げます」}	{"an established custom 〜の〔しきたりの〕customary; 〔例年の〕annual"}	\N
声	こえ	{}	{voice}	\N
超える	こえる	{}	{"to cross over; to cross; to pass through; to pass over (out of)"}	\N
越える	こえる	{}	{"to cross over; to cross; to pass through; to pass over (out of)"}	\N
氷	こおり	{}	{ice}	\N
凍り付く	こおりつく	{硬く凍る}	{"be frozen；freeze to"}	\N
凍る	こおる	{}	{"freeze; be frozen over; congeal"}	\N
焦がす	こがす	{}	{"burn; scorch; singe; char"}	\N
小柄	こがら	{}	{"short (build)"}	\N
扱き下ろす	こきおろす	{欠点などを殊更に指摘して、ひどくけなす。「上役を―・して溜飲 (りゅういん) を下げる」}	{"criticize severely; ((口)) pan; run down; put down"}	\N
小切手	こぎって	{}	{"cheque; check"}	\N
顧客	こきゃく	{ひいきにしてくれる客。得意客。}	{"a customer; a patron; clientele"}	\N
呼吸	こきゅう	{}	{"breath; respiration; knack; trick; secret (of doing something)"}	\N
故郷	こきょう	{}	{"home town; birthplace; old or historic village"}	\N
漕ぐ	こぐ	{}	{"to row; to scull; to pedal"}	\N
国王	こくおう	{}	{king}	\N
国語	こくご	{}	{"national language"}	\N
国際	こくさい	{}	{international}	\N
国産	こくさん	{}	{"domestic manifacturing"}	\N
黒人	こくじん	{}	{"black person"}	\N
国籍	こくせき	{}	{nationality}	\N
国定	こくてい	{}	{"state-sponsored; national"}	\N
国土	こくど	{}	{realm}	\N
告白	こくはく	{}	{"confession; acknowledgement"}	\N
告発	こくはつ	{悪事や不正を明らかにして、世間に知らせること。告訴。訴え}	{"a formal charge [accusation]((against))"}	\N
黒板	こくばん	{}	{blackboard}	\N
克服	こくふく	{努力して困難にうちかつこと。「病を―する」}	{"subjugation; conquest"}	\N
国防	こくぼう	{}	{"national defence"}	\N
国民	こくみん	{国家を構成し、その国の国籍を有する者。国政に参与する地位では公民または市民ともよばれる。}	{"people; citizen"}	\N
穀物	こくもつ	{}	{"grain; cereal; corn"}	\N
国有	こくゆう	{}	{"national ownership"}	\N
国立	こくりつ	{}	{national}	\N
国連	こくれん	{}	{"U.N.; United Nations"}	\N
固形	こけい	{}	{"solid (固形茶から)"}	\N
焦げ茶	こげちゃ	{}	{"black tea"}	\N
焦げる	こげる	{}	{"burn; be burned"}	\N
個々	ここ	{}	{"individual; one by one"}	\N
箇箇	ここ	{}	{"individual; separate"}	\N
此処	ここ	{話し手が現にいる場所をさす。}	{here}	\N
凍える	こごえる	{}	{"freeze; be chilled; be frozen"}	\N
心地	ここち	{}	{"feeling; sensation; mood"}	\N
九日	ここのか	{}	{"nine days; the ninth day (of the month)"}	\N
九つ	ここのつ	{}	{nine}	\N
心	こころ	{}	{"mind; heart"}	\N
心当たり	こころあたり	{}	{"having some knowledge of; happening to know"}	\N
心得	こころえ	{}	{"knowledge; information"}	\N
心得る	こころえる	{}	{"be informed; have thorough knowledge"}	\N
心掛け	こころがけ	{}	{"readiness; intention; aim"}	\N
心掛ける	こころがける	{}	{"to bear in mind; to aim to do"}	\N
志	こころざし	{}	{"will; intention; motive"}	\N
志す	こころざす	{}	{"to plan; to intend; to aspire to; to set aims (sights on)"}	\N
心強い	こころづよい	{}	{"heartening; reassuring"}	\N
心細い	こころぼそい	{}	{"helpless; forlorn; hopeless; unpromising; lonely; discouraging; disheartening"}	\N
試み	こころみ	{}	{"trial; experiment"}	\N
試みる	こころみる	{}	{"to try; to test"}	\N
快い	こころよい	{}	{"pleasant; agreeable"}	\N
腰	こし	{}	{hip}	\N
孤児	こじ	{}	{orphan}	\N
腰掛け	こしかけ	{}	{"seat; bench"}	\N
腰掛ける	こしかける	{}	{"sit (down)"}	\N
乞食	こじき	{}	{beggar}	\N
故障	こしょう	{}	{breakdown}	\N
故人	こじん	{}	{"the deceased; old friend"}	\N
個人	こじん	{}	{"individual; personal; private"}	\N
超す	こす	{}	{"cross; pass; tide over"}	\N
梢	こずえ	{}	{treetop}	\N
個性	こせい	{}	{"individuality; personality; idiosyncrasy"}	\N
戸籍	こせき	{}	{"census; family register"}	\N
小銭	こぜに	{}	{"coins; small change"}	\N
固体	こたい	{}	{"solid (body)"}	\N
個体	こたい	{}	{"an individual"}	\N
古代	こだい	{}	{"ancient times"}	\N
答	こたえ	{}	{"answer; response"}	\N
答え	こたえ	{}	{"answer (noun)"}	\N
応え	こたえ	{他からの作用・刺激に対する反応。ききめ。効果。「大衆に呼びかけても―がない」}	{result}	\N
答える	こたえる	{}	{"to answer; to reply"}	\N
火燵	こたつ	{}	{"table with heater; (orig) charcoal brazier in a floor well"}	\N
誇張	こちょう	{}	{exaggeration}	\N
国家	こっか	{}	{"state; country; nation"}	\N
国会	こっかい	{}	{"National Diet; parliament; congress"}	\N
小遣い	こづかい	{}	{"personal expenses; pocket money; spending money; incidental expenses; allowance"}	\N
骨格	こっかく	{}	{"〔骨組み〕a framework; 〔動物学上の〕a skeleton; 〔体付き〕a build"}	\N
骨骼	こっかく	{}	{"〔骨組み〕a framework; 〔動物学上の〕a skeleton; 〔体付き〕a build"}	\N
滑稽	こっけい	{笑いの対象となる、おもしろいこと。おどけたこと。また、そのさま。「―なしぐさ」}	{"funny; humorous; comical; laughable; ridiculous; joking"}	\N
滑稽さ	こっけいさ	{}	{"humor; funniness"}	\N
国交	こっこう	{}	{"diplomatic relations"}	\N
骨折	こっせつ	{}	{"bone fracture"}	\N
骨頂	こっちょう	{程度がこれ以上ないこと。}	{pinnacle}	\N
小包	こづつみ	{}	{"parcel; package"}	\N
骨董品	こっとうひん	{}	{curio}	\N
骨盤	こつばん	{}	{"hip bone; pelvis"}	\N
固定	こてい	{}	{fixation}	\N
古典	こてん	{}	{"old book; classic; classics"}	\N
事	こと	{}	{"thing; matter; fact; circumstances; business; reason; experience"}	\N
琴	こと	{}	{"koto (Japanese harp)"}	\N
負かす	まかす	{}	{"to defeat"}	\N
凝る	こごる	{液体状のものが、冷えたり凍ったりして凝固する。「魚の煮汁が―・る」「食うものはなくなった。水筒の水は―・ってしまった」}	{"to congeal; to freeze"}	\N
擦る	こする	{}	{"rub; scrub"}	\N
骨	こつ	{}	{"knack; skill"}	\N
事柄	ことがら	{物事の内容・ようす。また、物事そのもの。「調べた―を発表する」「新企画に関する極秘の―」「重大な―」}	{"matter; thing; affair; circumstance"}	\N
孤独	こどく	{}	{"isolation; loneliness; solitude"}	\N
今年	ことし	{}	{"this year"}	\N
言付ける	ことづける	{}	{"send word; send a message"}	\N
言伝	ことづて	{}	{"declaration; hearsay"}	\N
異なる	ことなる	{}	{"differ; vary; disagree"}	\N
殊に	ことに	{}	{"especially; above all"}	\N
事によると	ことによると	{}	{"depending on the circumstances"}	\N
言葉	ことば	{人が声に出して言ったり文字に書いて表したりする、意味のある表現。言うこと。「友人の―を信じる」}	{"word(s); phrase; language; speech"}	\N
言葉遣い	ことばづかい	{}	{"speech; expression; wording"}	\N
子供	こども	{}	{"children; kids"}	\N
小鳥	ことり	{}	{"(small) bird"}	\N
断る	ことわる	{}	{"refuse; reject; dismiss; turn down; decline; inform; give notice; ask leave; excuse oneself (from)"}	\N
粉	こな	{}	{"flour; meal; powder"}	\N
粉々	こなごな	{}	{"in very small pieces"}	\N
この頃	このごろ	{}	{recently}	\N
好ましい	このましい	{}	{"nice; likeable; desirable"}	\N
好み	このみ	{}	{"liking; taste; choice"}	\N
好む	このむ	{}	{"like; prefer"}	\N
拒む	こばむ	{}	{reject}	\N
個別	こべつ	{}	{"particular case"}	\N
零す	こぼす	{}	{"to spill"}	\N
零れる	こぼれる	{}	{"to overflow; to spill"}	\N
細かい	こまかい	{}	{"small; detailed"}	\N
細やか	こまやか	{}	{friendly}	\N
困る	こまる	{}	{"be troubled; be worried; be bothered"}	\N
混む	こむ	{}	{"to be crowded"}	\N
込む	こむ	{}	{"be crowded"}	\N
小麦	こむぎ	{}	{wheat}	\N
米	こめ	{}	{rice}	\N
込める	こめる	{}	{"to include; to put into"}	\N
篭る	こもる	{}	{"to seclude oneself; to be confined in; to be implied; to be stuffy"}	\N
顧問	こもん	{会社、団体などで、相談を受けて意見を述べる役。また、その人。}	{"an adviser; an advisor ((to)); a counselor，((英)) a counsellor; 〔コンサルタント〕a consultant"}	\N
顧問料	こもんりょう	{}	{"lawyer fees"}	\N
小屋	こや	{}	{"hut; cabin; shed; (animal) pen"}	\N
固有	こゆう	{}	{"characteristic; tradition; peculiar; inherent; eigen-"}	\N
小指	こゆび	{}	{"little finger"}	\N
雇用	こよう	{}	{"employment (long term); hire"}	\N
暦	こよみ	{}	{"calendar; almanac"}	\N
懲らす	こらす	{こらしめる。「悪を―・す」}	{chastise}	\N
孤立	こりつ	{}	{"isolation; helplessness"}	\N
懲りる	こりる	{}	{"to learn by experience; to be disgusted with"}	\N
転がす	ころがす	{}	{"roll (transitive)"}	\N
転がる	ころがる	{}	{"roll; tumble"}	\N
殺す	ころす	{}	{kill}	\N
転ぶ	ころぶ	{}	{"fall down; fall over"}	\N
怖い	こわい	{それに近づくと危害を加えられそうで不安である。自分にとってよくないことが起こりそうで、近づきたくない。「夜道がー・い」「地震がー・い」「ー・いおやじ」}	{frightening}	\N
恐い	こわい	{悪い結果がでるのではないかと不安で避けたい気持ちである。「かけ事はー・いからしない」「あとがー・い」}	{"〔恐ろしい〕fearful; frightening; horrible; dreadful"}	\N
壊す	こわす	{}	{"break; destroy"}	\N
壊れる	こわれる	{}	{"be broken"}	\N
紺	こん	{}	{"navy blue; deep blue"}	\N
婚姻	こんいん	{結婚すること}	{marriage}	\N
今夏	こんか	{}	{"this summer"}	\N
今回	こんかい	{}	{"now; this time; lately"}	\N
根気	こんき	{}	{"patience; perseverance; energy"}	\N
根拠	こんきょ	{}	{"basis; foundation"}	\N
混血	こんけつ	{}	{"mixed race; mixed parentage"}	\N
今月	こんげつ	{}	{"this month"}	\N
今後	こんご	{今からのち。こののち。以後。「―もよろしく願います」「―いっさい関知しない」}	{"〔これから〕after this; from now on; 〔将来〕in (the) future (▼((英))ではtheはつけない)"}	\N
混合	こんごう	{}	{"mixing; mixture"}	\N
懇々	こんこん	{}	{earnestly}	\N
混雑	こんざつ	{}	{"confusion; congestion"}	\N
今週	こんしゅう	{}	{"this week"}	\N
献立	こんだて	{}	{"menu; program; schedule"}	\N
懇談	こんだん	{}	{"informal talk"}	\N
懇談会	こんだんかい	{リラックスしました会議や集まりなど}	{"round-table meeting (informal)"}	\N
昆虫	こんちゅう	{}	{"insect; bug"}	\N
根底	こんてい	{}	{"root; basis; foundation"}	\N
今度	こんど	{}	{"next time"}	\N
混同	こんどう	{}	{"confusion; mixing; merger"}	\N
困難	こんなん	{物事をするのが非常にむずかしいこと。また、そのさま。難儀。苦しみ悩むこと。苦労すること。「―に立ち向かう」「予期しない―な問題にぶつかる」}	{"difficulty; distress"}	\N
今日は	こんにちは	{}	{"hello; good day (daytime greeting id)"}	\N
今晩	こんばん	{}	{"tonight; this evening"}	\N
根本	こんぽん	{}	{"origin; source; foundation; root; base; principle"}	\N
今夜	こんや	{}	{tonight}	\N
婚約	こんやく	{}	{"engagement; betrothal"}	\N
混乱	こんらん	{}	{"disorder; chaos; confusion; mayhem"}	\N
句	く	{}	{"phrase; clause; sentence; passage; paragraph; expression; line; verse; stanza; 17-syllable poem"}	\N
区	く	{}	{"ward; district; section"}	\N
悔い改める	くいあらためる	{過去の過ちを反省して心がけを変える。}	{"repent; is sorry for"}	\N
区域	くいき	{}	{"limits; boundary; domain; zone; sphere; territory"}	\N
食い違う	くいちがう	{}	{"to cross each other; to run counter to; to differ; to clash; to go awry"}	\N
悔いる	くいる	{}	{regret}	\N
食う	くう	{}	{eat}	\N
空間	くうかん	{スペース；宇宙}	{space}	\N
空気	くうき	{}	{air}	\N
空港	くうこう	{}	{"air port"}	\N
空想	くうそう	{}	{"daydream; fantasy; fancy; vision"}	\N
空中	くうちゅう	{}	{"sky; air"}	\N
空白	くうはく	{}	{"vacuum :: empty space"}	\N
空腹	くうふく	{}	{hunger}	\N
区画	くかく	{}	{"division; section; compartment; boundary; area; block"}	\N
区間	くかん	{}	{"section (of track etc)"}	\N
茎	くき	{}	{stalk}	\N
茎茶	くきちゃ	{}	{"stalk tea"}	\N
区切り	くぎり	{}	{"an end; a stop; punctuation"}	\N
苦境	くきょう	{苦しい境遇。苦しい立場。「―を乗りこえる」「―に立つ」「―に陥る」「―に直面する」}	{"predicament;〔難局〕difficulties; 〔逆境〕adversity"}	\N
区切る	くぎる	{}	{"punctuate; cut off; mark off; stop; put an end to"}	\N
草	くさ	{}	{grass}	\N
種々	くさぐさ	{}	{variety}	\N
鎖	くさり	{}	{chain}	\N
腐る	くさる	{}	{"rot; go bad"}	\N
串	くし	{魚貝・獣肉・野菜などを刺し通して焼いたり干したりするのに用いる、先のとがった竹や鉄などの細長い棒。「―を打つ」「―を刺す」}	{"〔焼きぐし〕a skewer; 〔丸焼き用の大型の〕a spit; 〔焼肉用金ぐし〕a broach"}	\N
櫛	くし	{}	{comb}	\N
旧事	くじ	{}	{"past events; bygones"}	\N
籤引	くじびき	{}	{"lottery; drawn lot"}	\N
串焼き	くしやき	{魚貝・肉・野菜などを串に刺して焼くこと。また、焼いたもの。}	{"fish; meat; shellfish; or vegetables grilled on skewers"}	\N
苦笑	くしょう	{他人または自分の行動やおかれた状況の愚かしさ・こっけいさに、不快感やとまどいの気持ちをもちながら、しかたなく笑うこと。にが笑い。「―をもらす」「相手の詭弁 (きべん) に―する」}	{"(give) a wry [bitter] smile"}	\N
苦情	くじょう	{}	{"complaint; troubles; objection"}	\N
苦心	くしん	{}	{"pain; trouble; anxiety; diligence; hard work"}	\N
金色	こんじき	{黄金の色。きんいろ。}	{"golden; golden-colored"}	\N
今日	こんにち	{}	{today}	\N
崩す	くずす	{}	{"destroy; pull down; make change (money)"}	\N
薬	くすり	{}	{medicine}	\N
薬指	くすりゆび	{}	{"ring finger"}	\N
崩れる	くずれる	{}	{"collapse; crumble"}	\N
癖	くせ	{}	{"a habit (often a bad habit; i.e. vice); peculiarity"}	\N
砕く	くだく	{}	{"break; smash"}	\N
砕ける	くだける	{}	{"break; be broken"}	\N
下さい	ください	{「くれ」の尊敬語。相手に物や何かを請求する意を表す。ちょうだいしたい。「手紙を―」「しばらく時間を―」}	{"please; (I) would like"}	\N
下さる	くださる	{}	{"give (polite)"}	\N
草臥れる	くたびれる	{}	{"to get tired; to wear out"}	\N
果物	くだもの	{}	{fruit}	\N
下り	くだり	{}	{"down-train (going away from Tokyo)"}	\N
件	くだん	{}	{"example; precedent; the usual; the said; the above-mentioned; (man) in question"}	\N
口	くち	{}	{"mouth; orifice; opening"}	\N
口裏	くちうら	{言葉や話し方に隠されているもの。また、その人の心の中がうかがえるような、言葉や話し方。「その―から大体のところはわかる」}	{"(a person's) feelings; inner thoughts"}	\N
口占	くちうら	{人の言葉を聞いて吉凶を占うこと。}	{"inner thoughts"}	\N
口裏を合わせる	くちうらをあわせる	{あらかじめ相談して話の内容が食い違わないようにする。}	{"to arrange beforehand to tell the same story"}	\N
口ずさむ	くちずさむ	{}	{"to hum something; to sing to oneself"}	\N
唇	くちびる	{}	{lips}	\N
口紅	くちべに	{}	{lipstick}	\N
朽ちる	くちる	{}	{"to rot"}	\N
靴	くつ	{}	{"shoes; footwear"}	\N
苦痛	くつう	{}	{"pain; agony"}	\N
覆す	くつがえす	{}	{"to overturn; to upset; to overthrow; to undermine"}	\N
靴下	くつした	{}	{socks}	\N
屈折	くっせつ	{}	{"bending; indentation; refraction"}	\N
くっ付く	くっつく	{}	{"to adhere to; to keep close to"}	\N
くっ付ける	くっつける	{}	{"to attach"}	\N
句読点	くとうてん	{}	{"punctuation marks"}	\N
口説く	くどく	{異性に対して、自分の思いを受け入れるよう説得する。言い寄る。「言葉巧みに―・く」}	{"advances (flirt) [persuade; talk some on into doing]"}	\N
国	くに	{}	{country}	\N
国番号	くにばんごう	{}	{"〔国際電話の〕the country code ((for the U.S.))"}	\N
配る	くばる	{}	{"deliver; distribute"}	\N
首	くび	{}	{neck}	\N
首飾り	くびかざり	{}	{necklace}	\N
首輪	くびわ	{}	{"necklace; choker"}	\N
工夫	くふう	{}	{"device; scheme"}	\N
区分	くぶん	{}	{"division; section; compartment; demarcation; (traffic) lane; classification; sorting"}	\N
区別	くべつ	{}	{"distinction; differentiation; classification"}	\N
組	くみ	{}	{"class; group; team; set"}	\N
組合	くみあい	{}	{"association; union"}	\N
組み合わせ	くみあわせ	{}	{combination}	\N
組み合わせる	くみあわせる	{}	{"to join together; to combine; to join up"}	\N
組み込み	くみこみ	{}	{"embedded; built-in; inserted"}	\N
組み込む	くみこむ	{}	{"to insert; to include; to cut in (printing)"}	\N
組み立てる	くみたてる	{}	{"assemble; set up; construct"}	\N
酌む	くむ	{}	{"serve sake"}	\N
組む	くむ	{}	{"put together"}	\N
雲	くも	{}	{"the clouds"}	\N
曇り	くもり	{}	{"cloudiness; cloudy weather; shadow"}	\N
曇る	くもる	{}	{"become cloudy; become dim"}	\N
悔しい	くやしい	{}	{"regrettable; mortifying; vexing"}	\N
悔やむ	くやむ	{}	{mourn}	\N
蔵	くら	{}	{"warehouse; cellar; magazine; granary; godown; depository; treasury; elevator"}	\N
暗い	くらい	{}	{"dark; gloomy"}	\N
前もって	まえもって	{}	{"in advance; beforehand; previously"}	\N
位	くらい	{}	{"grade; rank; court order; dignity; nobility; situation; throne; crown; occupying a position; about; almost; as; rather; at least; enough to"}	\N
暮らし	くらし	{}	{"living; livelihood; subsistence; circumstances"}	\N
暮らす	くらす	{}	{"live; get along"}	\N
比べる	くらべる	{}	{compare}	\N
栗	くり	{}	{chestnut}	\N
繰り返す	くりかえす	{}	{repeat}	\N
狂う	くるう	{}	{"go mad; get out of order"}	\N
苦しい	くるしい	{}	{"painful; difficult"}	\N
苦しむ	くるしむ	{}	{"suffer; groan; be worried"}	\N
苦しめる	くるしめる	{}	{"to torment; to harass; to inflict pain"}	\N
車	くるま	{}	{"car; vehicle; wheel"}	\N
暮れ	くれ	{}	{"year end; sunset; nightfall; end"}	\N
呉々も	くれぐれも	{何度も心をこめて依頼・懇願したり、忠告したりするさま。「―お大事に」}	{"very best (wishes); upmost"}	\N
呉呉も	くれぐれも	{何度も心をこめて依頼・懇願したり、忠告したりするさま。「―お大事に」}	{"very best (wishes); upmost"}	\N
くれぐれも	呉々も	{何度も心をこめて依頼・懇願したり、忠告したりするさま。「―お大事に」}	{"very best (wishes); upmost"}	\N
暮れる	くれる	{}	{"get dark"}	\N
呉れる	くれる	{}	{"to give; to let one have; to do for one; to be given"}	\N
黒	くろ	{}	{"the color black (noun)"}	\N
黒い	くろい	{}	{"black; dark"}	\N
苦労	くろう	{}	{"troubles; hardships"}	\N
玄人	くろうと	{}	{"expert; professional; geisha; prostitute"}	\N
黒帯	くろおび	{}	{"black belt"}	\N
黒字	くろじ	{}	{"balance (figure) in the black"}	\N
黒幕	くろまく	{}	{"black curtains (polical meaning)"}	\N
加える	くわえる	{}	{"append; sum up; include; increase; inflict"}	\N
詳しい	くわしい	{}	{"knowing very well; detailed; full; accurate"}	\N
加わる	くわわる	{}	{"join in; accede to; increase; gain in (influence)"}	\N
訓	くん	{}	{"native Japanese reading of a Chinese character"}	\N
勲	くん	{勲位。勲等。勲等の等級を表す。「―三等」}	{"a decoration; an order"}	\N
君主	くんしゅ	{}	{"ruler; monarch"}	\N
薫製	くんせい	{魚や獣の肉を塩漬けにし、ナラ・カシ・桜など樹脂の少ない木くずをたいた煙でいぶし、乾燥させた食品。特殊の香味をもち、保存性がある。「サケの―」}	{"smoking; 〜の smoked (salmon)"}	\N
燻製	くんせい	{魚や獣の肉を塩漬けにし、ナラ・カシ・桜など樹脂の少ない木くずをたいた煙でいぶし、乾燥させた食品。特殊の香味をもち、保存性がある。「サケの―」}	{"smoking; 〜の smoked (salmon)"}	\N
訓練	くんれん	{}	{"practice; training"}	\N
貧しさ	まずしさ	{財産や金銭がとぼしく、生活が苦しい；乏しい；必要量に足りない}	{poverty}	\N
真に受ける	まにうける	{言葉どおりに受け取る。「冗談をー・ける」}	{"take seriously"}	\N
満場一致	まんじょういっち	{その場にいるすべての人の意見が一致すること。「ーで可決」}	{unanimous}	\N
枚	まい	{}	{"counter for flat objects (e.g. sheets of paper)"}	\N
毎朝	まいあさ	{}	{"every morning"}	\N
毎月	まいげつ	{}	{"every month; each month; monthly"}	\N
迷子	まいご	{}	{"lost (stray) child"}	\N
毎週	まいしゅう	{}	{"every week"}	\N
枚数	まいすう	{}	{"the number of flat things"}	\N
埋蔵	まいぞう	{}	{"buried property; treasure trove"}	\N
毎度	まいど	{}	{"each time; common service-sector greeting"}	\N
毎日	まいにち	{}	{"every day"}	\N
毎晩	まいばん	{}	{"every night"}	\N
参る	まいる	{}	{"come (polite )"}	\N
舞う	まう	{}	{"to dance; to flutter about; to revolve"}	\N
真上	まうえ	{}	{"just above; right overhead"}	\N
前売り	まえうり	{}	{"advance sale; booking"}	\N
前置き	まえおき	{}	{"preface; introduction"}	\N
来る	くる	{}	{"come; come to hand; arrive; approach; call on; set in; be due; become; grow; get; come from; be caused by; derive from"}	\N
君	くん	{}	{"Mr (junior); master; boy"}	\N
前	まえ	{}	{front}	\N
任す	まかす	{}	{"to entrust; to leave to a person"}	\N
任せる	まかせる	{}	{"entrust to another; leave to; do something at one´s leisure"}	\N
賄う	まかなう	{}	{"to give board to; to provide meals; to pay"}	\N
曲がる	まがる	{}	{"to turn; to bend"}	\N
曲る	まがる	{}	{"curve; be bent; be crooked; turn"}	\N
巻	まき	{}	{volume}	\N
薪	まき	{}	{"fire wood"}	\N
紛らわしい	まぎらわしい	{}	{"confusing; misleading; equivocal; ambiguous"}	\N
紛れる	まぎれる	{}	{"to be diverted; to slip into"}	\N
膜	まく	{}	{"membrane; film"}	\N
巻く	まく	{}	{"wind; coil; roll"}	\N
枕	まくら	{}	{"pillow; bolster"}	\N
負け	まけ	{}	{"defeat; loss; losing (a game)"}	\N
負ける	まける	{}	{lose}	\N
曲げる	まげる	{}	{"bend; lean; be crooked"}	\N
孫	まご	{}	{grandchild}	\N
真心	まこころ	{}	{"sincerity; devotion"}	\N
誠	まこと	{}	{"truth; faith; fidelity; sincerity; trust; confidence; reliance; devotion"}	\N
誠に	まことに	{まちがいなくある事態であるさま。じつに。本当に。「―彼女は美しい」「―ありがとうございます」}	{"really (good news); truly (sorry); exactly/just (as you say)"}	\N
実に	まことに	{まちがいなくある事態であるさま。じつに。本当に。「―彼女は美しい」「―ありがとうございます」}	{"really (good news); truly (sorry); exactly/just (as you say)"}	\N
真に	まことに	{まちがいなくある事態であるさま。じつに。本当に。「―彼女は美しい」「―ありがとうございます」}	{"really (good news); truly (sorry); exactly/just (as you say)"}	\N
正しく	まさしく	{}	{"surely; no doubt; evidently"}	\N
摩擦	まさつ	{}	{"friction; rubbing; rubdown; chafe"}	\N
正に	まさに	{}	{"correctly; surely"}	\N
勝る	まさる	{}	{"to excel; to surpass; to outrival"}	\N
混ざる	まざる	{}	{"to be mixed; to be blended with; to associate with; to mingle with; to join"}	\N
交ざる	まざる	{}	{"to be mixed; to be blended with; to associate with; to mingle with; to join"}	\N
増し	まし	{}	{"extra; additional; less objectionable; better; preferable"}	\N
交える	まじえる	{}	{"to mix; to converse with; to cross (swords)"}	\N
真下	ました	{}	{"right under; directly below"}	\N
況して	まして	{}	{"still more; still less (with neg. verb); to say nothing of; not to mention"}	\N
真面目	まじめ	{}	{"diligent; serious; honest"}	\N
混じる	まじる	{}	{"to be mixed; to be blended with; to associate with; to mingle with; to interest; to join"}	\N
交じる	まじる	{}	{"to be mixed; to be blended with; to associate with; to mingle with; to interest; to join"}	\N
魔女	まじょ	{}	{witch}	\N
交わる	まじわる	{}	{"to cross; to intersect; to associate with; to mingle with; to interest; to join"}	\N
増す	ます	{}	{"increase; grow"}	\N
先ず	まず	{}	{"at first"}	\N
麻酔	ますい	{}	{anaesthesia}	\N
不味い	まずい	{}	{"unappetising; unpleasant (taste appearance situation); ugly; unskilful; awkward; bungling; unwise; untimely"}	\N
貧しい	まずしい	{}	{"poor; needy"}	\N
益々	ますます	{}	{"increasingly; more and more"}	\N
混ぜる	まぜる	{}	{"mix; stir"}	\N
交ぜる	まぜる	{}	{"be mixed; be blended with"}	\N
又	また	{}	{"again; and"}	\N
股	また	{}	{"groin; crotch; thigh"}	\N
瞬き	またたき	{}	{"wink; twinkling (of stars); flicker (of light)"}	\N
又は	または	{}	{"or; the other"}	\N
町	まち	{}	{"town; street; road"}	\N
待合室	まちあいしつ	{}	{"waiting room"}	\N
待ち合わせ	まちあわせ	{}	{appointment}	\N
待ち合わせる	まちあわせる	{}	{"rendezvous; meet at a prearranged place and time"}	\N
間違い	まちがい	{}	{mistake}	\N
間違う	まちがう	{あるべき状態や結果と異なる。違う。「―・った考え方」「この手紙は住所が―・っている」}	{"to make a mistake; to be incorrect; to be mistaken"}	\N
間違える	まちがえる	{}	{"make a mistake"}	\N
街角	まちかど	{}	{"street corner"}	\N
満ち足りる	みちたりる	{不足がなく十分である。十分に満足する。「―・りた生活」}	{"get satisfied; find contemption"}	\N
待ち遠しい	まちどおしい	{}	{"looking forward to"}	\N
待ち望む	まちのぞむ	{}	{"to look anxiously for; to wait eagerly for"}	\N
区々	まちまち	{}	{"several; various; divergent; conflicting; different; diverse; trivial"}	\N
松	まつ	{}	{"pine tree; highest (of a three-tier ranking system)"}	\N
待つ	まつ	{}	{wait}	\N
真っ赤	まっか	{}	{"deep red; flushed (of face)"}	\N
末期	まっき	{}	{"closing years (period days); last stage"}	\N
真っ暗	まっくら	{}	{"total darkness; pitch dark; shortsightedness"}	\N
真っ黒	まっくろ	{}	{"pitch black"}	\N
真っ青	まっさお	{}	{"deep blue; ghastly pale"}	\N
真っ先	まっさき	{}	{"the head; the foremost; beginning"}	\N
末梢	まっしょう	{塗りつぶして消すこと。「登録を―する」}	{"erasure; obliteration"}	\N
真っ白	まっしろ	{}	{"pure white"}	\N
まったり	まったり	{味わいがおだやかで、こくのあるさま。「―（と）した味」}	{"chillin (taste)"}	\N
真っ直ぐ	まっすぐ	{}	{"straight (ahead); direct; upright; erect; honest; frank"}	\N
全く	まったく	{完全にその状態になっているさま。すっかり。決して。全然。「―新しい企画」「回復の希望は―絶たれた」}	{"really; truly; entirely; completely; wholly; perfectly; indeed"}	\N
抹茶	まっちゃ	{}	{matcha}	\N
真っ二つ	まっぷたつ	{}	{"in two equal parts"}	\N
祭	まつり	{}	{"festival; feast"}	\N
祭る	まつる	{}	{"deify; enshrine"}	\N
祀る	まつる	{儀式をととのえて神霊をなぐさめ、また、祈願する。「先祖のみ霊 (たま) を―・る」「死者を―・る」}	{worship}	\N
窓	まど	{}	{window}	\N
惑う	まどう	{どうしたらよいか判断に苦しむ。}	{"be perplexed"}	\N
窓口	まどぐち	{}	{"ticket window"}	\N
まとめ	纏め	{まとめること。また、まとめたもの。「―の段階に入る」}	{"〔集める〕collect; gather together〔整える〕put in order; arrange; 〔統一する〕unify"}	\N
学ぶ	まなぶ	{}	{"learn; study (in depth)"}	\N
間に合う	まにあう	{}	{"to be in time (for)"}	\N
免れる	まぬかれる	{}	{"to escape from; to be rescued from; to avoid; to evade; to avert; to elude; to be exempted; to be relieved from pain; to get rid of"}	\N
真似	まね	{}	{"mimicry; imitation; behavior; pretense"}	\N
招き	まねき	{}	{invitation}	\N
招く	まねく	{}	{invite}	\N
真似る	まねる	{}	{"mimic; imitate"}	\N
疎ら	まばら	{物が少なくて、間がすいているさま。すきまのあいているさま。「人通りも―な住宅街」}	{sparse}	\N
麻痺	まひ	{}	{"paralysis; palsy; numbness; stupor"}	\N
目蓋	まぶた	{}	{eyelid}	\N
眩しい	まぶしい	{}	{"blinding (light)"}	\N
幻	まぼろし	{}	{visionary}	\N
間々	まま	{}	{"occasionally; frequently"}	\N
豆	まめ	{}	{"beans; peas; (as a prefix) miniature; tiny"}	\N
間もなく	まもなく	{}	{"soon; before long; in a short time"}	\N
守る	まもる	{}	{"protect; obey; guard; abide (by the rules)"}	\N
眉	まゆ	{}	{eyebrow}	\N
眉毛	まゆげ	{}	{eyebrows}	\N
丸	まる	{}	{circle}	\N
丸い	まるい	{}	{"round; circular; spherical"}	\N
円い	まるい	{}	{"round; circular; spherical"}	\N
丸ごと	まるごと	{}	{"in its entirety; whole; wholly"}	\N
丸で	まるで	{（下に否定的な意味の語を伴って）まさしくその状態であるさま。すっかり。まったく。「―だめだ」「兄弟だが―違う」}	{"〔通例，否定語を伴って，全く…ない〕⇒まったく(全く) no(not) at ALL; entirely (out of question); (don't have the) slightest (idea)"}	\N
丸っきり	まるっきり	{}	{"completely; perfectly; just as if"}	\N
丸々	まるまる	{}	{completely}	\N
末	まつ	{}	{extremity}	\N
的	まと	{}	{"mark; target"}	\N
円	まる	{}	{"circle; money"}	\N
丸める	まるめる	{}	{"to make round; to round off; to roll up; to curl up; to seduce; to cajole; to explain away"}	\N
賓	まろうど	{訪ねて来た人。きゃく。きゃくじん。}	{guests}	\N
回す	まわす	{}	{"turn; revolve"}	\N
周り	まわり	{}	{surroundings}	\N
回り	まわり	{}	{"circumference; surroundings; circulation"}	\N
回り道	まわりみち	{}	{"detour; diversion"}	\N
回る	まわる	{}	{"go round"}	\N
萬	まん	{}	{"10;000; ten thousand"}	\N
万一	まんいち	{}	{"by some chance; by some possibility; if by any chance; 10;000:1 odds"}	\N
満員	まんいん	{}	{"full house; no vacancy; sold out; standing room only; full (of people); crowded"}	\N
漫画	まんが	{}	{cartoon}	\N
満月	まんげつ	{}	{"full moon"}	\N
満場	まんじょう	{}	{"unanimous; whole audience"}	\N
満足	まんぞく	{心にかなって不平不満のないこと。心が満ち足りること。また、そのさま。「―な（の）ようす」「今の生活に―している」}	{"〔満ち足りること〕satisfaction; 〔不満でないこと〕content(ment); 〔自己満足〕complacency; complacence"}	\N
満点	まんてん	{}	{"perfect score"}	\N
真ん中	まんなか	{}	{"middle; center; half way"}	\N
万年筆	まんねんひつ	{}	{"fountain pen"}	\N
真ん前	まんまえ	{}	{"right in front; under the nose"}	\N
満喫	まんきつ	{}	{"fully enjoy"}	\N
真ん丸い	まんまるい	{}	{"perfectly circular"}	\N
目	め	{}	{"eye; eyeball"}	\N
芽	め	{}	{sprout}	\N
明確	めいかく	{}	{"clear up; clarify; define"}	\N
銘柄	めいがら	{}	{"brand; name; stock"}	\N
迷彩	めいさい	{敵の目をごまかすために、航空機・戦車・大砲・建築物・軍服などに不規則な彩色をし、他の物と区別がつきにくいようにすること。「車両に―を施す」「―服」}	{camouflage}	\N
名作	めいさく	{}	{masterpiece}	\N
明察	めいさつ	{相手を敬って、その推察をいう語。「御―のとおりです」}	{"〔はっきり見極めること〕discernment; 〔洞察〕perception; insight"}	\N
名産	めいさん	{}	{"noted product"}	\N
名刺	めいし	{}	{"business card"}	\N
名詞	めいし	{}	{noun}	\N
名所	めいしょ	{}	{"famous place"}	\N
名称	めいしょう	{}	{name}	\N
命じる	めいじる	{}	{"to order; command; appoint"}	\N
迷信	めいしん	{}	{superstition}	\N
名人	めいじん	{}	{"master; expert"}	\N
命ずる	めいずる	{}	{"to command; appoint"}	\N
命中	めいちゅう	{}	{"a hit"}	\N
名物	めいぶつ	{}	{"famous product; speciality"}	\N
名簿	めいぼ	{}	{"register of names"}	\N
銘々	めいめい	{}	{"each; individual"}	\N
名誉	めいよ	{}	{"honor; credit; prestige"}	\N
明瞭	めいりょう	{}	{clarity}	\N
命令	めいれい	{}	{"order; command; decree; directive; (software) instruction"}	\N
明朗	めいろう	{}	{"bright; clear; cheerful"}	\N
迷惑	めいわく	{ある行為がもとで、他の人が不利益を受けたり、不快を感じたりすること。「人にーをかける」}	{"trouble; a nuisance; (an) annoyance"}	\N
迷惑メール	めいわくめーる	{受信者の同意を得ず、広告や勧誘などの目的で不特定多数に大量に配信される電子メール。スパムメール。スパム。ジャンクメール。}	{"junk email; spam"}	\N
メーンストリーム	メーンストリーム	{本流。主流。また、主傾向。}	{mainstream}	\N
目上	めうえ	{}	{"superior(s); senior"}	\N
目方	めかた	{}	{weight}	\N
芽キャベツ	めきゃべつ	{}	{"brussel sprouts"}	\N
恵まれる	めぐまれる	{}	{"be blessed with; be rich in"}	\N
恵み	めぐみ	{}	{blessing}	\N
恵む	めぐむ	{}	{"to bless; to show mercy to"}	\N
巡る	めぐる	{}	{"go around"}	\N
目指す	めざす	{}	{"aim at; have an eye on"}	\N
値段	ねだん	{}	{"price; cost"}	\N
明白	めいはく	{あきらかで疑う余地のないこと。また、そのさま。「―な証拠」}	{obvious}	\N
眼鏡	めがね	{}	{"spectacles; glasses"}	\N
目覚し	めざまし	{}	{"alarm clock (abbreviation)"}	\N
目覚しい	めざましい	{}	{"brilliant; splendid; striking; remarkable"}	\N
目覚める	めざめる	{}	{"to wake up"}	\N
飯	めし	{}	{"meal(s); food"}	\N
召し上がる	めしあがる	{}	{"eat (polite)"}	\N
目下	めした	{}	{"subordinate(s); inferior(s); junior"}	\N
目印	めじるし	{}	{"mark; sign; landmark"}	\N
召す	めす	{}	{"to call; to send for; to put on; to wear; to take (a bath); to ride in; to buy; to eat; to drink; to catch (a cold)"}	\N
雌	めす	{}	{"female (animal)"}	\N
珍しい	めずらしい	{}	{"unusual; strange"}	\N
目立つ	めだつ	{}	{"be conspicuous; stand out"}	\N
滅茶苦茶	めちゃくちゃ	{}	{"absurd; unreasonable; excessive; messed up; spoiled; wreaked"}	\N
滅	めつ	{滅びること。消え失せること。消滅。}	{"destroying (of something)"}	\N
目付き	めつき	{}	{"look; expression of the eyes; eyes"}	\N
めっきり	めっきり	{状態の変化がはっきり感じられるさま。著しい。明白な}	{"remarkably; noticeably; _quite_ (a few)"}	\N
滅多に	めったに	{}	{"rarely (with negative verb); seldom"}	\N
滅亡	めつぼう	{}	{"downfall; ruin; collapse; destruction"}	\N
愛でたい	めでたい	{}	{auspicious}	\N
目に遭う	めにあう	{直接に経験する。体験する。多く、好ましくないことにいう。目を見る。「つらいー・う」「今度ばかりはひどいー・ったよ」}	{"(bad) experience"}	\N
目眩	めまい	{}	{"dizziness; giddiness"}	\N
目盛	めもり	{}	{"scale; gradations"}	\N
目安	めやす	{}	{"criterion; aim"}	\N
麺	めん	{小麦粉に水と塩などを加えた生地を細く長くしたものである。}	{noodle}	\N
免疫	めんえき	{}	{immunity}	\N
面会	めんかい	{}	{interview}	\N
免許	めんきょ	{}	{"license; permit; certificate"}	\N
免除	めんじょ	{義務・役目などを免じること。「実地試験を―する」}	{"exemption; exoneration; discharge"}	\N
面する	めんする	{}	{"to face on; to look out on to"}	\N
免税	めんぜい	{}	{"tax exemption"}	\N
面積	めんせき	{}	{area}	\N
面接	めんせつ	{}	{interview}	\N
面談	めんだん	{面会して直接話をすること。「来客と―する」「委細―」}	{"an interview; talk; conversation"}	\N
面倒	めんどう	{手間がかかったり、解決が容易でなかったりして、わずらわしいこと。また、そのさま。世話。「―な手続き」「―なことにならなければよいが」「断るのも―だ」「―を起こす」}	{"trouble; difficulty; care; attention"}	\N
面倒臭い	めんどうくさい	{}	{"bother to do; tiresome"}	\N
面目	めんぼく	{}	{"face; honour; reputation; prestige; dignity; credit"}	\N
魅する	みする	{不思議な力で人の心をひきつける。「歌声にー・せられる」}	{charm}	\N
民族	みんぞく	{言語・人種・文化・歴史的運命を共有し、同族意識によって結ばれた人々の集団}	{nationality}	\N
身	み	{}	{"body; main part; oneself; sword"}	\N
見合い	みあい	{}	{"formal marriage interview"}	\N
見合わせる	みあわせる	{}	{"to exchange glances; to postpone; to suspend operations; to refrain from performing an action"}	\N
見える	みえる	{}	{"see; can be seen"}	\N
見送り	みおくり	{}	{"seeing one off; farewell; escort"}	\N
見送る	みおくる	{}	{"see off; escort; let pass; wait and see"}	\N
見落とす	みおとす	{}	{"to overlook; to fail to notice"}	\N
見下ろす	みおろす	{}	{"overlook; command a view of"}	\N
未開	みかい	{}	{"savage land; backward region; uncivilized"}	\N
味覚	みかく	{}	{"taste; palate; sense of taste"}	\N
磨く	みがく	{}	{"to polish; shine; brush; refine; improve"}	\N
見掛け	みかけ	{}	{"outward appearance"}	\N
見掛ける	みかける	{}	{"to (happen to) see; to notice; to catch sight of"}	\N
見方	みかた	{}	{viewpoint}	\N
熱	ねつ	{}	{"heat; fever"}	\N
三	み	{}	{"(num) three"}	\N
実	み	{}	{"fruit; nut; seed; content; good result"}	\N
綿	めん	{}	{"raw cotton"}	\N
面	めん	{}	{"face; surface; facial features; mask; side or facet; corner; page"}	\N
味方	みかた	{}	{"friend; ally; supporter"}	\N
右	みぎ	{}	{"right hand side"}	\N
右腕	みぎうで	{}	{"right arm"}	\N
右手	みぎて	{}	{"right hand"}	\N
見切る	みきる	{ものをすっかり見てしまう。見終わる。「広いので一日で―・るのはむずかしい」}	{"〔見限る〕give up (on); be obsolete; abandon; (文) forsake; (口) ditch"}	\N
見苦しい	みぐるしい	{}	{"unsightly; ugly"}	\N
見込み	みこみ	{}	{"hope; prospects; expectation"}	\N
未婚	みこん	{}	{unmarried}	\N
岬	みさき	{}	{"cape (on coast)"}	\N
短い	みじかい	{}	{short}	\N
惨め	みじめ	{}	{miserable}	\N
未熟	みじゅく	{}	{"inexperience; unripeness; raw; unskilled; immature; inexperienced"}	\N
微塵	みじん	{}	{"particle; atom"}	\N
水	みず	{}	{water}	\N
未遂	みすい	{"犯罪の実行に着手したが、まだ成し遂げていないこと。⇔既遂。→障害未遂 →中止未遂"}	{attempt}	\N
湖	みずうみ	{}	{lake}	\N
水脹れ	みずぶくれ	{水をたくさん含んでふくれていること。また、そのもの。「ぶよぶよと―のようなふとり方」}	{"〔皮膚の下の〕a (water) blister"}	\N
水膨れ	みずぶくれ	{水をたくさん含んでふくれていること。また、そのもの。「ぶよぶよと―のようなふとり方」}	{"〔皮膚の下の〕a (water) blister"}	\N
見すぼらしい	みすぼらしい	{}	{"shabby; seedy"}	\N
見せびらかす	みせびらかす	{}	{"to show off; to flaunt"}	\N
見せ物	みせもの	{}	{"show; exhibition"}	\N
店屋	みせや	{}	{"store; shop"}	\N
見せる	みせる	{}	{"to show; to display"}	\N
味噌	みそ	{}	{"miso (bean paste); key (main) point"}	\N
みたい	みたい	{ある事物のようすや内容が他の事物に似ている意を表す。「お寺みたいな建物」}	{"〔類似・具体例を表す〕like〔推測を表す〕look; seem"}	\N
みたいだ	みたいだ	{ある事物のようすや内容が他の事物に似ている意を表す。「お寺みたいな建物」}	{"〔類似・具体例を表す〕like〔推測を表す〕look; seem"}	\N
見出し	みだし	{}	{"heading; caption; subtitle; index"}	\N
満たす	みたす	{}	{"to satisfy; to ingratiate; to fill; to fulfill"}	\N
乱す	みだす	{}	{"to throw out of order; to disarrange; to disturb"}	\N
乱れる	みだれる	{}	{"to get confused; to be disordered; to be disturbed"}	\N
未知	みち	{}	{"not yet known"}	\N
道	みち	{}	{"road; street; way; method"}	\N
身近	みぢか	{}	{"near oneself; close to one; familiar"}	\N
道順	みちじゅん	{}	{"itinerary; route"}	\N
導く	みちびく	{}	{"to be guided; to be shown"}	\N
満ちる	みちる	{}	{"be full; rise (tide); mature; expire"}	\N
密	みつ	{}	{mystery}	\N
蜜	みつ	{}	{"nectar; honey"}	\N
三日	みっか	{}	{"three days; the third day (of the month)"}	\N
見付かる	みつかる	{}	{"be found; be discovered"}	\N
見つかる	みつかる	{}	{"be found"}	\N
見付ける	みつける	{}	{"discover; find fault; detect; find out; locate; be familiar"}	\N
見つける	みつける	{}	{"find out"}	\N
密集	みっしゅう	{}	{"crowd; close formation; dense"}	\N
密接	みっせつ	{}	{"related; connected; close; intimate"}	\N
三つ	みっつ	{}	{three}	\N
密度	みつど	{}	{density}	\N
見積り	みつもり	{}	{"estimation; quotation"}	\N
密輸	みつゆ	{法を犯してひそかに輸出入すること。「麻薬をーする」}	{smuggling}	\N
未定	みてい	{}	{"not yet fixed; undecided; pending"}	\N
見通し	みとおし	{}	{"perspective; unobstructed view; outlook; forecast; prospect; insight"}	\N
緑	みどり	{}	{green}	\N
皆	みな	{}	{"all; everything"}	\N
見直す	みなおす	{}	{"look again; form a better opinion of"}	\N
皆さん	みなさん	{}	{everyone}	\N
港	みなと	{}	{"seaport; harbor"}	\N
港町	みなとまち	{港を中心として発達した町。港のある町。}	{"a port town"}	\N
店	みせ	{}	{"store; shop; establishment"}	\N
認める	みとめる	{}	{"recognize; appreciate; approve; admit; notice"}	\N
源	みなもと	{}	{"source; origin"}	\N
身なり	みなり	{}	{"personal appearance"}	\N
見慣れる	みなれる	{}	{"become used to seeing; be familiar with"}	\N
醜い	みにくい	{}	{ugly}	\N
峰	みね	{}	{"peak; ridge"}	\N
見逃す	みのがす	{見ていながら気づかないでそのままにする。見落とす。「わずかな失敗も―・さない」}	{"to miss; to overlook; to leave at large"}	\N
見遁す	みのがす	{見ていながら気づかないでそのままにする。見落とす。「わずかな失敗も―・さない」}	{"to miss; to overlook; to leave at large"}	\N
実る	みのる	{}	{"bear fruit; ripen"}	\N
見晴らし	みはらし	{}	{view}	\N
身振り	みぶり	{}	{gesture}	\N
身分	みぶん	{}	{"social position; social status"}	\N
見本	みほん	{}	{sample}	\N
見舞	みまい	{}	{"enquiry; expression of sympathy; expression of concern"}	\N
見舞い	みまい	{}	{"enquiry; expression of sympathy or concern"}	\N
見間違い	みまちがい	{見て他のものとまちがえること。見あやまり。見ちがい。誤認。みまちがえ。「時刻表の―をする」}	{"misjudgment; mistake in vision"}	\N
見守る	みまもる	{}	{"watch over"}	\N
未満	みまん	{}	{"less than; insufficient"}	\N
耳	みみ	{}	{ear}	\N
脈	みゃく	{}	{pulse}	\N
脈拍	みゃくはく	{}	{pulse}	\N
雅び	みやび	{上品で優美なこと。また、そのさま。風雅。優雅。「衣装にーを競う」「ーな祭事」⇔俚 (さと) び。}	{"〔優美さ〕elegance; 〔しとやかな上品さ〕grace"}	\N
妙	みょう	{}	{"strange; unusual"}	\N
名字	みょうじ	{}	{"surname; family name"}	\N
明星	みょうじょう	{}	{"Venus / MorningStar"}	\N
未来	みらい	{}	{"future tense; the future (usually distant); the world to come"}	\N
魅力	みりょく	{}	{"charm; fascination; glamour"}	\N
味醂	みりん	{}	{"wine extract"}	\N
見る	みる	{}	{"to see; to watch"}	\N
診る	みる	{診断する。「脈をみる」}	{"(medicine) examine"}	\N
看る	みる	{そのことに当たる。取り扱う。世話をする。「事務をみる」「子供のめんどうをみる」}	{"look after; take care of;"}	\N
試る	みる	{こころみる。ためす。「切れ味をみる」}	{"see (what he goes for); test"}	\N
観る	みる	{"観察・観光・占う・（遠くから）見物する … 実際をよくミル。"}	{"observe; see (as a tourist)"}	\N
視る	みる	{"正視・監視・調査 … 注意してよくミル。"}	{investigate}	\N
未練	みれん	{}	{"lingering affection; attachment; regret(s); reluctance"}	\N
見渡す	みわたす	{}	{"to look out over; to survey (scene); to take an extensive view of"}	\N
民営化	みんえいか	{国や地方公共団体が経営する企業・特殊法人などを民間会社や特殊会社にすること。}	{Privatization}	\N
民間	みんかん	{}	{"private; civilian; civil; popular; folk; unofficial"}	\N
民主	みんしゅ	{}	{"democratic; the head of the nation"}	\N
民宿	みんしゅく	{}	{"private home providing lodging for travelers"}	\N
民俗	みんぞく	{}	{"people; race; nation; racial customs; folk customs"}	\N
民族別	みんぞくべつ	{}	{ethnicity}	\N
民族主義	みんぞくしゅぎ	{民族の存在・独立や利益また優越性を、確保または増進しようとする思想および運動。その極端な形は国家主義とよばれる。ナショナリズム。}	{nationalism}	\N
民族主義者	みんぞくしゅぎしゃ	{}	{nationalist}	\N
民謡	みんよう	{}	{"folk song; popular song"}	\N
もう	もう	{現に、ある事態に立ち至っているさま。また、ある動作が終わっているさま。もはや。既に。「―手遅れだ」「―子供ではない」「今泣いた烏が―笑った」}	{"〔すでに〕already; 〔今や〕now"}	\N
南	みなみ	{}	{"South; proceeding south"}	\N
土産	みやげ	{}	{"product of the land"}	\N
都	みやこ	{}	{capital}	\N
明後日	みょうごにち	{}	{"day after tomorrow"}	\N
申し上げる	もうしあげる	{}	{"say (polite)"}	\N
申し入れる	もうしいれる	{}	{"to propose; to suggest"}	\N
申し込み	もうしこみ	{}	{"application; entry; request; subscription; offer; proposal; overture; challenge"}	\N
申し込む	もうしこむ	{}	{"apply for; propose; offer; challenge; request"}	\N
申出	もうしで	{}	{"proposal; request; claim; report; notice"}	\N
申し出る	もうしでる	{}	{"to report to; to tell; to suggest; to submit; to request; to make an offer; to come forward with information"}	\N
申し分	もうしぶん	{}	{"objection; shortcomings"}	\N
申し訳	もうしわけ	{申し開き。言いわけ。弁解。「―が立つ」「―がない」「出席できず―ありません」}	{"〔弁解〕an excuse 〔わび〕an apology (複-gies)"}	\N
申し訳ない	もうしわけない	{言い訳のしようがない。弁解の余地がない。相手にわびるときに言う語。「世間に対し―・い気持ちで一杯だ」「不始末をしでかして―・い」}	{inexcusable}	\N
申す	もうす	{}	{"say (polite)"}	\N
妄想	もうそう	{}	{"delusion; wild idea"}	\N
盲点	もうてん	{}	{"blind spot"}	\N
盲導犬	もうどうけん	{}	{"guide dog"}	\N
毛布	もうふ	{}	{blanket}	\N
網羅	もうら	{そのことに関するすべてを残らず集めること。「必要な資料を－する」}	{cover}	\N
猛烈	もうれつ	{}	{"violent; vehement; rage"}	\N
萌黄色	もえぎいろ	{鮮やかな黄緑色系統の色。春に萌え出る草の芽をあらわす色で、英語色名の春野の緑を意味するスプリンググリーンに意味的にも色的にも近い。}	{"light green; yellowish-green"}	\N
燃える	もえる	{}	{"to burn"}	\N
藻掻く	もがく	{}	{"to struggle; to wriggle; to be impatient"}	\N
模擬	もぎ	{本物や実際の場合と同じようにすること。「―実験」}	{"imitation; sham; moot (court); mock"}	\N
捥ぎ取る	もぎとる	{もいで取る。}	{"pluck off (e.g. an apple); tear off (a dolls arm)"}	\N
目撃	もくげき	{現場に居合わせて実際に見ること。「交通事故を―する」}	{"〜する to witness (a happening)"}	\N
目撃者	もくげきしゃ	{ある事柄が起こった場所に居合わせて、それを実際に見た人。「事件の―」}	{"a witness; an eyewitness"}	\N
木材	もくざい	{}	{"lumber; timber; wood"}	\N
目次	もくじ	{}	{"table of contents"}	\N
黙想	もくそう	{黙って考えにふけること。黙思。「―にふける」}	{"meditation; contemplation"}	\N
目的	もくてき	{}	{"purpose; goal; aim; objective; intention"}	\N
目標	もくひょう	{}	{"mark; objective; target"}	\N
木曜	もくよう	{}	{Thursday}	\N
木曜日	もくようび	{}	{Thursday}	\N
目録	もくろく	{}	{"catalogue; catalog; list"}	\N
目論見	もくろみ	{}	{"a plan; a scheme; a project; a program; intention; goal"}	\N
模型	もけい	{}	{"model; dummy; maquette"}	\N
模索	もさく	{}	{"groping (for)"}	\N
若し	もし	{まだ現実になっていないことを仮に想定するさま。もしか。万一。「―彼が来たら、知らせてください」}	{"if; provided; in case (of emergency)"}	\N
文字	もじ	{}	{"letter (of alphabet); character"}	\N
若しかして	もしかして	{}	{"perhaps; possibly"}	\N
若しくは	もしくは	{}	{"or; otherwise"}	\N
若しも	もしも	{}	{if}	\N
喪主	もしゅ	{}	{"Chief mourner"}	\N
持ち	もち	{}	{"hold; charge; keep possession; in charge; wear; durability; life; draw; usage (suff)"}	\N
餅	もち	{}	{"sticky rice cake"}	\N
持ち上げる	もちあげる	{}	{"raise; lift up; flatter"}	\N
持ち歩く	もちあるく	{手に持ったり身に付けたりして歩く。「多額の現金をー・く」}	{"walking and carrying around"}	\N
持ち込む	もちこむ	{物を持って中にはいる。「車内に危険物を―・まないこと」}	{"〔運び入れる〕bring (e.g. food) in (e.g. a hotel); take into"}	\N
用いる	もちいる	{}	{"use; make use of"}	\N
持ち切り	もちきり	{}	{"hot topic; talk of the town"}	\N
潜る	もぐる	{}	{"drive; pass through; evade; hide; dive (into or under water); go underground"}	\N
勿論	もちろん	{}	{"of course; certainly; naturally"}	\N
持つ	もつ	{}	{"hold; carry; possess"}	\N
以て	もって	{}	{"with; by; by means of; because; in view of"}	\N
最も	もっとも	{}	{"most; extremely"}	\N
専ら	もっぱら	{}	{"wholly; solely; entirely"}	\N
持て成す	もてなす	{}	{"to entertain; to make welcome"}	\N
持てる	もてる	{}	{"to be well liked; to be popular"}	\N
元	もと	{}	{"origin; original; former"}	\N
素	もと	{原料。材料。たね。「たれの―」「料理の―を仕込む」}	{"Raw materials; Material; Species"}	\N
戻す	もどす	{}	{"restore; put back; return"}	\N
基づく	もとづく	{}	{"be grounded on; be based on; be due to; originate from"}	\N
求める	もとめる	{}	{"seek; request; demand; want; wish for; search for"}	\N
元々	もともと	{}	{"originally; by nature; from the start"}	\N
戻る	もどる	{}	{return}	\N
物	もの	{}	{"thing; object"}	\N
者	もの	{}	{person}	\N
物置き	ものおき	{}	{storeroom}	\N
物置	ものおき	{}	{"storage room"}	\N
物音	ものおと	{}	{sounds}	\N
物語	ものがたり	{}	{"tale; story; legend"}	\N
物語る	ものがたる	{}	{"tell; indicate"}	\N
物事	ものごと	{}	{"things; everything"}	\N
物差し	ものさし	{}	{"ruler; measure"}	\N
物好き	ものずき	{}	{curiosity}	\N
物凄い	ものすごい	{}	{"earth-shattering; staggering; to a very great extent"}	\N
物足りない	ものたりない	{}	{"unsatisfied; unsatisfactory"}	\N
ものの	ものの	{活用語の連体形に付く。逆接の確定条件を表す。…けれども。…とはいえ。「習いはした―、すっかり忘れてしまった」「新機軸を打ち出した―、採用はされなかった」}	{nevertheless}	\N
物真似	ものまね	{人や動物などの身ぶり・しぐさ・声音などをまねること。また、その芸。}	{mimicry}	\N
模範	もはん	{}	{"exemplar; exemplification; exemplum; model; example"}	\N
模倣	もほう	{}	{"imitation; copying"}	\N
靄	もや	{}	{"a haze; a thin mist"}	\N
燃やす	もやす	{}	{"to burn"}	\N
模様	もよう	{}	{"pattern; figure; design"}	\N
催し	もよおし	{人を集めて興行・会合などをすること。「歓迎のーを開く」}	{"event; festivities; function; social gathering; auspices; opening; holding (a meeting)"}	\N
催す	もよおす	{}	{"to hold (a meeting); to give (a dinner); to feel; to show signs of; to develop symptoms of; to feel (sick)"}	\N
貰う	もらう	{}	{"〔物を受け取る〕get; be given〔家に迎える〕〔買う〕〔自分のものにする〕〔うつされる〕〔自分で引き受ける〕〔「…してもらう」の形で〕"}	\N
漏らす	もらす	{}	{"to let leak; to reveal"}	\N
森	もり	{}	{forest}	\N
盛り上がる	もりあがる	{盛ったように高くなる。「水面が―・る」「―・った筋肉」}	{"to rouse; to swell; to rise"}	\N
盛り込む	もりこむ	{盛って中に入れる。「重箱に料理を―・む」}	{"incorporate; include"}	\N
漏る	もる	{}	{"to leak; to run out"}	\N
漏れる	もれる	{}	{"to leak out; to escape; to come through; to shine through; to filter out; to be omitted"}	\N
双手	もろて	{左右の手。両手。「―突き」}	{"both hands"}	\N
両手	もろて	{左右の手。両手。「―突き」}	{"both hands"}	\N
諸手	もろて	{左右の手。両手。「―突き」}	{"both hands"}	\N
問	もん	{}	{"problem; question"}	\N
文句	もんく	{}	{"phrase; complaint"}	\N
問題	もんだい	{}	{"problem; question"}	\N
問答	もんどう	{}	{"questions and answers; dialogue"}	\N
匁	もんめ	{}	{1mom＝3.75g}	\N
息子	むすこ	{}	{son}	\N
紅葉	もみじ	{}	{"autumn colours; (Japanese) maple"}	\N
盛る	もる	{物を容器に入れて満たす。「飯を茶碗に―・る」}	{"prosper; flourish; copulate (animals)"}	\N
木綿	もめん	{}	{cotton}	\N
門	もん	{}	{gate}	\N
基	もと	{}	{basis}	\N
基	もとい	{}	{basis}	\N
無	む	{}	{"nothing; nil; zero"}	\N
六日	むいか	{}	{"six days; sixth (day of month)"}	\N
無意味	むいみ	{}	{"nonsense; no meaning"}	\N
向かい	むかい	{}	{"facing; opposite; across the street; other side"}	\N
向かう	むかう	{}	{"to face; to go towards"}	\N
向う	むかう	{}	{"to face; go towards"}	\N
迎え	むかえ	{}	{"meeting; person sent to pick up an arrival"}	\N
迎え入れる	むかえいれる	{来る人を迎えて中に入れる。「客間にー・れる」}	{"receive; to usher in"}	\N
迎える	むかえる	{}	{"meet; welcome; greet"}	\N
昔	むかし	{時間的にさかのぼった過去の一時期・一時点。時間の隔たりの多少は問わずに用いるが、多く、遠い過去をいう。「―の話」「―のままの姿」「とっくの―」}	{"old time; before; ago"}	\N
向き	むき	{}	{"direction; situation; exposure; aspect; suitability"}	\N
麦	むぎ	{}	{barley}	\N
向く	むく	{}	{"to face"}	\N
剥く	むく	{}	{"peel; skin; pare; hull"}	\N
報う	むくう	{}	{"to reward / recompensate / repay (むch くうstomers is * by having good service)"}	\N
無口	むくち	{}	{reticence}	\N
向け	むけ	{}	{"for ~; oriented towards ~"}	\N
向ける	むける	{}	{"turn towards; point"}	\N
無限	むげん	{}	{infinite}	\N
婿	むこ	{}	{son-in-law}	\N
向こう	むこう	{}	{"beyond; over there; opposite direction; the other party"}	\N
無効	むこう	{}	{"invalid; no effect; unavailable"}	\N
無言	むごん	{}	{silence}	\N
虫	むし	{}	{insect}	\N
無視	むし	{}	{"disregard; ignore"}	\N
無地	むじ	{}	{"plain; unfigured"}	\N
蒸し暑い	むしあつい	{}	{"humid; sultry"}	\N
虫歯	むしば	{}	{"cavity; tooth decay; decayed tooth"}	\N
無邪気	むじゃき	{}	{"innocence; simple-mindedness"}	\N
武者修行	むしゃしゅぎょう	{武士が武芸の修行のために諸国を巡って歩くこと。}	{"a journey around the country to learn from the great masters of the martial arts; acquire greater skill (in music)"}	\N
矛盾	むじゅん	{}	{"contradiction; inconsistency"}	\N
矛盾した表現	むじゅんしたひょうげん	{}	{oxomoron}	\N
寧ろ	むしろ	{}	{"rather; better; instead"}	\N
蒸す	むす	{}	{"to steam; poultice; be sultry"}	\N
無数	むすう	{}	{"countless number; infinite number"}	\N
難しい	むずかしい	{理解や習得がしにくい。複雑でわかりにくい。難解である。「説明が―・い」「―・い文章」⇔易しい。}	{difficult}	\N
結び	むすび	{}	{"ending; conclusion; union"}	\N
結び付き	むすびつき	{}	{"connection; relation"}	\N
結び付く	むすびつく	{}	{"to be connected or related; to join together"}	\N
結び付ける	むすびつける	{}	{"to combine; to join; to tie on; to attach with a knot"}	\N
結ぶ	むすぶ	{"1 ひも帯などの両端をからませてつなぎ合わせる。2 他人と関係をもつ。約束をする。「条約をーぶ」「靴のひもをーぶ」「ネクタイをーぶ」"}	{"tie; bind; link"}	\N
娘	むすめ	{}	{daughter}	\N
無制限	むせいげん	{制限がないこと。制限しないこと。また、そのさま。「―な人間の欲望」「人員を―に増やす」}	{"infinity (stage); 〜の unrestricted; unlimited"}	\N
無線	むせん	{}	{"wireless; radio"}	\N
無駄遣い	むだづかい	{}	{"waste money on; squander money on; flog a dead horse"}	\N
無断	むだん	{}	{"without permission; without notice"}	\N
無知	むち	{}	{ignorance}	\N
無茶	むちゃ	{}	{"absurd; unreasonable; excessive; rash; absurdity; nonsense"}	\N
無茶苦茶	むちゃくちゃ	{}	{"confused; jumbled; mixed up; unreasonable"}	\N
夢中	むちゅう	{}	{"daze; (in a) trance; ecstasy; delirium; engrossment"}	\N
六つ	むっつ	{}	{six}	\N
無敵	むてき	{非常に強くて敵対するものがないこと。対抗できるものがないこと。また、そのさま。「―な（の）猛将」「天下―」}	{"invincible; unrivaled; can not be matched"}	\N
空しい	むなしい	{}	{"vacant; futile; vain; void; empty; ineffective; lifeless"}	\N
胸	むね	{}	{"breast; chest"}	\N
無念	むねん	{}	{"chagrin; regret"}	\N
六	む	{}	{"(num) six"}	\N
無能	むのう	{}	{"inefficiency; incompetence"}	\N
謀反	むほん	{時の為政者に反逆すること。国家・朝廷・君主にそむいて兵を挙げること。律の八虐の規定では国家に対する反逆をいい、「謀叛」の字を用い、謀反 (むへん) 、謀大逆 (ぼうたいぎゃく) に次いで3番目の重罪とされる。}	{rebellion}	\N
無闇に	むやみに	{}	{"unreasonably; absurdly; recklessly; indiscreetly; at random"}	\N
無用	むよう	{}	{"useless; futility; needlessness; unnecessariness"}	\N
村	むら	{}	{village}	\N
群がる	むらがる	{}	{"to swarm; to gather"}	\N
紫	むらさき	{}	{"purple; violet (color)"}	\N
無理	むり	{}	{compulsion}	\N
無料	むりょう	{}	{"free; no charge"}	\N
群れ	むれ	{}	{"group; crowd; flock; herd; bevy; school; swarm; cluster (of stars); clump"}	\N
無論	むろん	{}	{"of course; naturally"}	\N
名	な	{}	{"name; reputation"}	\N
内科	ないか	{}	{"internist clinic; internal medicine"}	\N
内閣	ないかく	{カビネット}	{cabinet}	\N
乃至	ないし	{}	{"from...to; between...and; or"}	\N
内線	ないせん	{}	{"phone extension; indoor wiring; inner line"}	\N
内臓	ないぞう	{}	{"internal organs; intestines; viscera"}	\N
内部	ないぶ	{}	{"interior; inside; internal"}	\N
内容	ないよう	{}	{"subject; contents; matter; substance; detail; import"}	\N
内乱	ないらん	{}	{"civil war; insurrection; rebellion; domestic conflict"}	\N
内陸	ないりく	{}	{inland}	\N
苗	なえ	{種から芽を出して間のない草や木。定植前の草木。}	{"rice seedling"}	\N
尚	なお	{}	{"furthermore; still; yet; more; still more; greater; further; less"}	\N
尚更	なおさら	{}	{"all the more; still less"}	\N
直す	なおす	{}	{repair}	\N
治す	なおす	{}	{"cure; heal; fix; correct; repair"}	\N
直る	なおる	{}	{"be repaired"}	\N
治る	なおる	{}	{"get well"}	\N
仲	なか	{}	{"relation; relationship"}	\N
永い	ながい	{}	{"long; lengthy"}	\N
長い	ながい	{}	{long}	\N
流し	ながし	{}	{sink}	\N
流す	ながす	{}	{"drain; float; shed (blood; tears)"}	\N
仲直り	なかなおり	{}	{"reconciliation; make peace with"}	\N
中々	なかなか	{}	{"very; considerably; easily; readily; by no means (neg); fairly; quite; highly; rather"}	\N
長々	ながなが	{}	{"long; drawn-out; very long"}	\N
長引く	ながびく	{}	{"be prolonged; drag on"}	\N
中程	なかほど	{}	{"middle; midway"}	\N
仲間	なかま	{}	{"company; fellow; colleague; associate; comrade; mate; group; circle of friends; partner"}	\N
中味	なかみ	{}	{"contents; interior; substance; filling; (sword) blade"}	\N
中身	なかみ	{}	{"contents; interior; substance; filling; (sword) blade"}	\N
眺め	ながめ	{}	{"scene; view; prospect; outlook"}	\N
眺める	ながめる	{}	{"view; gaze at"}	\N
仲良し	なかよし	{}	{"intimate friend; close friend"}	\N
ながら	ながら	{二つの動作・状態が並行して行われる意を表す。「ラジオを聞きー勉強する」}	{"as; while; although"}	\N
流れ	ながれ	{}	{"stream; current"}	\N
流れる	ながれる	{}	{"stream; flow; be washed away; run (ink)"}	\N
亡き後	なきあと	{}	{"after the passing"}	\N
泣く	なく	{}	{cry}	\N
鳴く	なく	{}	{"bark; purr; chirp; make sound (animal)"}	\N
慰める	なぐさめる	{}	{"comfort; console; amuse"}	\N
亡くす	なくす	{死なれて失う。死なせる。亡くする。「一人息子を―・す」}	{"lose something or someone; get rid of"}	\N
無くす	なくす	{今まであったもの、持っていたものを失う。無くする。「財布を―・す」「やる気を―・す」}	{lose}	\N
亡くなる	なくなる	{}	{die}	\N
無くなる	なくなる	{}	{"be lost"}	\N
殴る	なぐる	{相手を乱暴に強く打つ。乱暴に物事をする。「ー・る蹴るの暴行」}	{"to strike; to hit"}	\N
嘆かわしい	なげかわしい	{}	{"sad; wretched"}	\N
中指	なかゆび	{}	{"middle finger"}	\N
嘆く	なげく	{}	{"to sigh; to lament; to grieve"}	\N
投げ出す	なげだす	{}	{"to throw down; to abandon; to sacrifice; to throw out"}	\N
投げる	なげる	{}	{throw}	\N
和やか	なごやか	{}	{"mild; calm; gentle; quiet; harmonious"}	\N
名残	なごり	{}	{"remains; traces; memory"}	\N
情け	なさけ	{}	{"sympathy; compassion"}	\N
情け深い	なさけぶかい	{}	{"tender-hearted; compassionate"}	\N
為さる	なさる	{}	{"to do"}	\N
無し	なし	{}	{without}	\N
詰る	なじる	{}	{"to rebuke; to scold; to tell off"}	\N
為す	なす	{}	{"accomplish; do"}	\N
何故	なぜ	{}	{"why; how"}	\N
謎	なぞ	{}	{"riddle; puzzle; enigma"}	\N
名高い	なだかい	{}	{"famous; celebrated; well-known"}	\N
菜種油	なたねあぶら	{}	{"rape seed oil"}	\N
傾らか	なだらか	{}	{"gently-sloping; gentle; easy"}	\N
雪崩	なだれ	{}	{avalanche}	\N
夏	なつ	{}	{summer}	\N
納豆	なっとう	{"よく蒸した大豆に納豆菌を加え、適温の中で発酵させた食品。粘って糸を引くので糸引き納豆ともいい、関東以北でよく用いる。《季 冬》「ーの糸引張って遊びけり／一茶」"}	{"fermented soybeans"}	\N
懐かしい	なつかしい	{}	{"dear; desired; missed"}	\N
懐く	なつく	{}	{"to become emotionally attached"}	\N
名付ける	なづける	{}	{"to name (someone)"}	\N
納得	なっとく	{}	{"consent; assent; understanding; agreement; comprehension; grasp"}	\N
夏休み	なつやすみ	{}	{"summer vacation; summer holiday"}	\N
七歳	ななさい	{}	{"7-years old"}	\N
七つ	ななつ	{}	{seven}	\N
斜め	ななめ	{}	{obliqueness}	\N
何	なに	{}	{what}	\N
何か	なにか	{}	{something}	\N
何気ない	なにげない	{}	{"casual; unconcerned"}	\N
何しろ	なにしろ	{}	{"at any rate; anyhow; anyway; in any case"}	\N
何卒	なにとぞ	{}	{please}	\N
何分	なにぶん	{}	{"anyway; please"}	\N
何も	なにも	{}	{nothing}	\N
何やら	なにやら	{実体がはっきりわからないさま。なにかしら。「ー物音がする」}	{"somewhat; some; something of a"}	\N
何より	なにより	{}	{"most; best"}	\N
名札	なふだ	{}	{"name plate; name tag"}	\N
鍋	なべ	{}	{"saucepan; pot"}	\N
生意気	なまいき	{}	{"impertinent; saucy; cheeky; conceit; audacious; brazen"}	\N
名前	なまえ	{}	{name}	\N
怠ける	なまける	{}	{"be idle; neglect"}	\N
生茶	なまちゃ	{}	{"raw tea"}	\N
生温い	なまぬるい	{}	{"lukewarm; halfhearted"}	\N
生身	なまみ	{}	{"living flesh; flesh and blood; the quick"}	\N
鉛	なまり	{}	{"lead (the metal)"}	\N
鈍る	なまる	{}	{"to become less capable; to grow dull; to become blunt; to weaken"}	\N
波	なみ	{}	{wave}	\N
浪	なみ	{風や震動によって起こる海や川の水面の高低運動。波浪。「ーが寄せてくる」「ーが砕ける」「逆巻くー」}	{waves}	\N
並み	なみ	{}	{"average; medium; common; ordinary"}	\N
並木	なみき	{}	{"roadside tree; row of trees"}	\N
涙	なみだ	{}	{tear}	\N
滑らか	なめらか	{}	{"smoothness; glassiness"}	\N
悩ましい	なやましい	{}	{"seductive; melancholy; languid"}	\N
悩ます	なやます	{}	{"to afflict; to torment; to harass; to molest"}	\N
悩み	なやみ	{}	{"trouble(s); worry; distress; anguish; agony; problem"}	\N
悩む	なやむ	{}	{"be worried; be troubled"}	\N
七日	なのか	{}	{"seven days; the seventh day (of the month)"}	\N
等	など	{一例を挙げ、あるいは、いくつか並べたものを総括して示し、それに限らず、ほかにも同種類のものがあるという意を表す。...なんか。「赤や黄―の落ち葉」「寒くなったのでこたつを出し―する」}	{"〔同類〕and so on; and [or] the like; 〔その他〕etc.〔たとえば...など〕such as; for example"}	\N
なら	なら	{}	{"Attach 「＿」 to the context in which the conditional would occur; [Assumed Context] + ＿ + [Result]; You must not attach the declarative 「だ」."}	\N
習う	ならう	{}	{learn}	\N
倣う	ならう	{}	{"imitate; follow; emulate"}	\N
慣らす	ならす	{}	{"to accustom"}	\N
鳴らす	ならす	{}	{"ring; sound; chime; beat"}	\N
ならでは	ならでは	{ただ＿だけ。「日本―の習慣だ」}	{"only (he is capable); (eat) only (in Japan)"}	\N
並びに	ならびに	{}	{and}	\N
並ぶ	ならぶ	{}	{"line up; stand in a line"}	\N
並べる	ならべる	{}	{"line up; set up"}	\N
成り立つ	なりたつ	{}	{"to conclude; to consist of; to be practical (logical feasible viable); to hold true"}	\N
並び替え	ならびかえ	{}	{sort}	\N
成る	なる	{}	{become}	\N
生る	なる	{}	{"bear fruit"}	\N
鳴る	なる	{}	{"sound; ring"}	\N
成る丈	なるたけ	{}	{"as much as possible; if possible"}	\N
成るべく	なるべく	{}	{"as much as possible"}	\N
成程	なるほど	{他人の言葉を受け入れて、自分も同意見であることを示す。たしかに。まことに。「ーそれはいい」}	{"indeed; really"}	\N
慣れ	なれ	{}	{"practice; experience"}	\N
慣れる	なれる	{}	{"get used to"}	\N
縄	なわ	{}	{"rope; hemp"}	\N
難	なん	{}	{"difficulty; hardships; defect"}	\N
難易度	なんいど	{}	{difficulty}	\N
南極	なんきょく	{}	{"south pole; Antarctic"}	\N
南京豆	なんきんまめ	{マメ科の一年草。茎は横にはい、葉は二対の小葉からなる複葉で、互生する。}	{peanut.}	\N
何だか	なんだか	{}	{"a little; somewhat; somehow"}	\N
何て	なんて	{驚いたり、あきれたり、感心したりする気持ちを表す。なんという。->何と「ーだらしないんだ」「ーすばらしい絵だ」}	{"how...!; what...!"}	\N
何で	なんで	{}	{"Why? What for?"}	\N
何でも	なんでも	{}	{"by all means; everything"}	\N
何と	なんと	{どんなふうに。どのように。驚いたり、あきれたり、感心したりする気持ちを表す。}	{"what; how; whatever"}	\N
何とか	なんとか	{}	{"somehow; anyhow; one way or another"}	\N
何となく	なんとなく	{}	{"somehow or other; for some reason or another"}	\N
何とも	なんとも	{}	{"nothing (with neg. verb); quite; not a bit"}	\N
何度	なんど	{どれほどの回数。また、多くの回数。何回。「―やってもできない」「―でも挑戦するつもりだ」}	{"〔回数を尋ねて〕how many times; how often〔度数を尋ねて〕how many degrees"}	\N
何度も	なんども	{}	{"any number of times"}	\N
南西	なんせい	{}	{south-west}	\N
何なり	なんなり	{}	{"any; anything; whatever"}	\N
南蛮	なんばん	{}	{"spanish pirates; barbarian"}	\N
南米	なんべい	{}	{"South America"}	\N
南北	なんぼく	{}	{"south and north"}	\N
妬む	ねたむ	{他人が自分よりすぐれている状態をうらやましく思って憎む。ねたましく思う。そねむ。}	{"to be jealous/envious"}	\N
熱心	ねっしん	{ある物事に深く心を打ち込むこと。}	{"eagerness; enthusiasm; 〜な eager (about)/ enthusiastic (about); 〜に enthusiastically/ eagerly/ zealously;"}	\N
狙い	ねらい	{弓や鉄砲などで、目標に当てようとねらうこと。}	{aim}	\N
年度	ねんど	{暦年とは別に、事務などの便宜のために区分した1年の期間。}	{"year; school year"}	\N
根	ね	{}	{root}	\N
値打ち	ねうち	{}	{"value; worth; price; dignity"}	\N
願い	ねがい	{}	{"desire; wish; request; prayer; petition; application"}	\N
願う	ねがう	{}	{"to desire; wish; request; beg; hope; implore"}	\N
寝かせる	ねかせる	{}	{"to put to bed; to lay down; to ferment"}	\N
猫背	ねこぜ	{首をやや前に出し、背を丸めた姿勢。また、そのようなからだつき。}	{"stoop (hunched posture)"}	\N
捻子	ねじ	{}	{"screw; helix; spiral"}	\N
ねじ回し	ねじまわし	{}	{screwdriver}	\N
捻じれる	ねじれる	{}	{"to twist; to wrench; to screw"}	\N
強請る	ねだる	{}	{"to tease; to coax; to solicit; to demand"}	\N
音	ね	{}	{"sound; note"}	\N
値	ね	{}	{"value; price; cost; worth; merit; (computer programming) variable"}	\N
熱意	ねつい	{}	{"zeal; enthusiasm"}	\N
熱狂	ねっきょう	{非常に興奮し熱中すること「ファンがライブに―する」}	{excitement}	\N
熱血	ねっけつ	{}	{hot-blooded}	\N
熱する	ねっする	{}	{"to heat"}	\N
熱帯	ねったい	{}	{tropics}	\N
熱中	ねっちゅう	{}	{"enthusiasm; zeal; mania"}	\N
熱湯	ねっとう	{}	{"boiling water"}	\N
熱量	ねつりょう	{}	{temperature}	\N
寝床	ねどこ	{寝るための床。寝るために敷かれた敷物・布団など。「―に入る」}	{"〔ベッド〕a bed; 〔汽車・汽船などの〕a berth"}	\N
粘り	ねばり	{}	{"stickyness; viscosity"}	\N
粘る	ねばる	{}	{"to be sticky; to be adhesive; to persevere; to persist; to stick to"}	\N
値引き	ねびき	{}	{"price reduction; discount"}	\N
寝坊	ねぼう	{}	{"sleeping in late"}	\N
寝巻	ねまき	{}	{"sleep-wear; nightclothes; pyjamas; nightgown; nightdress"}	\N
根回し	ねまわし	{}	{"making necessary arrangements"}	\N
眠い	ねむい	{}	{sleepy}	\N
眠たい	ねむたい	{}	{sleepy}	\N
眠る	ねむる	{}	{sleep}	\N
狙う	ねらう	{}	{"to aim at"}	\N
寝る	ねる	{}	{"go to bed; lie down; sleep"}	\N
練る	ねる	{}	{"to knead; to work over; to polish up"}	\N
寝技	ねわざ	{柔道やレスリングで、からだを倒した姿勢で掛ける技。「―にもち込む」⇔立ち技。}	{"〔柔道で〕groundwork techniques〔レスリングで〕pinning techniques"}	\N
念	ねん	{}	{"sense; idea; thought; feeling; desire; concern; attention; care"}	\N
念入り	ねんいり	{}	{polite}	\N
年鑑	ねんかん	{}	{yearbook}	\N
年間	ねんかん	{}	{"year (interval of time)"}	\N
年号	ねんごう	{}	{"name of an era; year number"}	\N
懇ろ	ねんごろ	{}	{"friendly; kind; intimate"}	\N
年中	ねんじゅう	{}	{"whole year; always; everyday"}	\N
燃焼	ねんしょう	{}	{"burning; combustion"}	\N
年生	ねんせい	{}	{"pupil in .... year; student in .... year"}	\N
年代	ねんだい	{}	{"age; era; period; date"}	\N
年長	ねんちょう	{}	{seniority}	\N
粘土	ねんど	{}	{clay}	\N
年俸	ねんぽう	{1年を単位として定めた俸給。また、1年分の俸給。年給。「―制で契約する」}	{"annual salary"}	\N
燃料	ねんりょう	{}	{fuel}	\N
年輪	ねんりん	{}	{"annual tree ring"}	\N
年齢	ねんれい	{}	{"age; years"}	\N
二	に	{}	{two}	\N
荷	に	{}	{"load; baggage; cargo"}	\N
似合う	にあう	{}	{"suit; match; become; be like"}	\N
煮える	にえる	{}	{"boil; cook; be cooked"}	\N
匂い	におい	{}	{"odour; scent; smell; stench; fragrance; aroma; perfume"}	\N
匂う	におう	{}	{"be fragrant; smell; to stink; glow; be bright"}	\N
苦い	にがい	{}	{bitter}	\N
逃がす	にがす	{}	{"let loose; set free; let escape"}	\N
二月	にがつ	{}	{February}	\N
苦手	にがて	{}	{"poor (at); weak (in); dislike (of)"}	\N
荼	にがな	{}	{"weed: Too many flowers and weeds will start to appear."}	\N
似通う	にかよう	{}	{"to resemble closely"}	\N
面皰	にきび	{}	{"pimple; acne"}	\N
握る	にぎる	{}	{"grasp; seize; mould (sushi)"}	\N
肉	にく	{}	{meat}	\N
憎い	にくい	{}	{"hateful; abominable; poor-looking; detestable; (with irony) lovely; lovable; wonderful"}	\N
憎しみ	にくしみ	{}	{hatred}	\N
肉親	にくしん	{}	{"blood relationship; blood relative"}	\N
肉体	にくたい	{}	{"the body; the flesh"}	\N
憎む	にくむ	{}	{"hate; detest"}	\N
憎らしい	にくらしい	{}	{"odious; hateful"}	\N
逃げ出す	にげだす	{}	{"to run away; to escape from"}	\N
逃げる	にげる	{}	{"run away"}	\N
二軒	けん	{}	{"two flats"}	\N
濁る	にごる	{}	{"become muddy or impure"}	\N
西	にし	{}	{west}	\N
虹	にじ	{}	{rainbow}	\N
人形	にんぎょう	{}	{doll}	\N
年月	ねんげつ	{}	{"months and years"}	\N
にしても	にしても	{...であることを考えても。...する場合でも。とはいえ。...でも「負けるー最善を尽くせ」}	{"even so; even though; even if"}	\N
西日	にしび	{}	{"westering sun"}	\N
日時	にちじ	{}	{"date and time"}	\N
日常	にちじょう	{}	{"ordinary; regular; everyday; usual"}	\N
日没	にちぼつ	{太陽の上端が地平線下に沈むこと。また、その時刻。日の入り。⇔日出 (にっしゅつ) 。}	{"((at)) sunset; ((at)) sundown"}	\N
日没時	にちぼつじ	{日の入りの時刻。太陽の上端が地平線に隠れて見えなくなる瞬間の時刻をいう。}	{"time of sunset"}	\N
日夜	にちや	{}	{"day and night; always"}	\N
日曜日	にちようび	{}	{Sunday}	\N
日用品	にちようひん	{}	{"daily necessities"}	\N
日蓮	にちれん	{［1222～1282］鎌倉時代の僧。日蓮宗の開祖。安房 (あわ) の人。12歳で清澄寺に入り天台宗などを学び、出家して蓮長と称した。比叡山などで修学ののち、建長5年（1253）「南無妙法蓮華経」の題目を唱え、法華経の信仰を説いた。辻説法で他宗を攻撃したため圧迫を受け、「立正安国論」の筆禍で伊豆の伊東に配流。許されたのちも他宗への攻撃は激しく、佐渡に流され、赦免後、身延山に隠栖。武蔵の池上で入寂。著「開目鈔」「観心本尊鈔」など。勅諡号 (ちょくしごう) は立正大師。}	{nichiren}	\N
日蓮宗	にちれんしゅう	{仏教の一宗派。鎌倉時代に日蓮が開いた。法華経を所依 (しょえ) とし、南無妙法蓮華経の題目を唱える実践を重んじ、折伏 (しゃくぶく) ・摂受 (しょうじゅ) の二門を立て、現実における仏国土建設をめざす。のち、分派を形成。法華宗。}	{"the Nichiren sect of Buddhism"}	\N
に就いて	について	{ある事柄に関して、その範囲をそれと限定する。「右の問題―解答せよ」「日時―は後日連絡する」}	{"about; regarding"}	\N
について	に就いて	{ある事柄に関して、その範囲をそれと限定する。「右の問題―解答せよ」「日時―は後日連絡する」}	{"about; regarding"}	\N
日課	にっか	{}	{"daily lesson; daily work; daily routine"}	\N
日記	にっき	{}	{diary}	\N
荷造り	にづくり	{}	{"packing; baling; crating"}	\N
二個	にこ	{}	{"2 pieces (articles)"}	\N
日光	にっこう	{}	{sunlight}	\N
日出	にっしゅつ	{太陽の上端が地平線上に現れること。また、その時刻。ひので。「―時」⇔日没。}	{sunrise}	\N
日中	にっちゅう	{}	{"daytime; during the day; Sino-Japanese"}	\N
日程	にってい	{}	{agenda}	\N
日当	にっとう	{}	{"daily allowance"}	\N
担う	になう	{}	{"to carry on shoulder; to bear (burden); to shoulder (gun)"}	\N
二年間	にねんかん	{}	{"two-year period"}	\N
日本製	にほんせい	{}	{"japan made/manifactured"}	\N
二枚貝	にまいがい	{}	{"[musslor]; Bivalvia; mussles"}	\N
にも拘らず	にもかかわらず	{}	{"in spite of; nevertheless"}	\N
荷物	にもつ	{}	{"baggage; luggage"}	\N
煮物	にもの	{材料に調味した汁を加えて煮ること。また、煮たもの。}	{"〔料理すること〕cooking; 〔煮た食物〕food boiled and seasoned"}	\N
入院	にゅういん	{}	{"enter hospital"}	\N
入学	にゅうがく	{}	{"enter a school"}	\N
入社	にゅうしゃ	{}	{"entry to a company"}	\N
入手	にゅうしゅ	{}	{"obtaining; coming to hand"}	\N
入賞	にゅうしょう	{}	{"winning a prize or place (in a contest)"}	\N
入場	にゅうじょう	{}	{"entrance; admission; entering"}	\N
入門	にゅうもん	{学問・技芸などを学びはじめること。「パソコンの―書」}	{"beginner; under tutorship; pupil; disciple"}	\N
入浴	にゅうよく	{}	{"bathe; bathing"}	\N
入力	にゅうりょく	{コンピューターで、処理させる情報を入れること。インプット。「パソコンにデータを―する」⇔出力。}	{"〔コンピュータの〕input〔電気の〕power input"}	\N
尿	にょう	{}	{urine}	\N
女房	にょうぼう	{}	{wife}	\N
によって	によって	{原因・理由を表す。..ので。..ために。「踏切事故ー電車が遅れる」}	{"depending on (school year (sales) (changes))"}	\N
似る	にる	{}	{"look like"}	\N
煮る	にる	{}	{"boil; cook"}	\N
庭	にわ	{}	{garden}	\N
任意	にんい	{自由意志にまかせること。「ーに選ぶ」}	{"optional; voluntary"}	\N
人気	にんき	{}	{"popular; business conditions; popular feeling"}	\N
任侠	にんきょう	{}	{"chivalrous spirit; heroism"}	\N
日	にち	{}	{"Japan-; Japanese-"}	\N
人間	にんげん	{ひと。人類。「―の歴史」}	{"human being; man; person"}	\N
認識	にんしき	{}	{"recognition; cognizance"}	\N
忍者	にんじゃ	{}	{"a ninja; a Japanese secret agent in feudal times (with almost magical powers of stealth and concealment)"}	\N
認証	にんしょう	{}	{authorization}	\N
人情	にんじょう	{}	{"humanity; empathy; kindness; sympathy; human nature; common sense; customs and manners"}	\N
妊娠	にんしん	{}	{"conception; pregnancy"}	\N
忍耐	にんたい	{苦難などをこらえること。辛抱。我慢。「―のいる仕事」「食糧の不足を―する」}	{"〔耐え忍ぶこと〕patience; 〔耐久力〕endurance; 〔ねばり強さ〕perseverance"}	\N
忍耐力	にんたいりょく	{つらいことや苦しみなどをたえしのぶ力。辛抱する力。がまん強さ}	{"perserverance; fortitude; staying power"}	\N
妊婦	にんぷ	{}	{"pregnant woman"}	\N
任命	にんめい	{}	{"appointment; nomination; ordination; commission; designation"}	\N
任務	にんむ	{ミッション}	{"mission; task"}	\N
之	の	{}	{of}	\N
野	の	{}	{field}	\N
脳	のう	{}	{"brain; memory"}	\N
能	のう	{}	{"talent; gift; function; Noh play"}	\N
農家	のうか	{}	{"farmer; farm family"}	\N
農業	のうぎょう	{}	{agriculture}	\N
農耕	のうこう	{}	{"farming; agriculture"}	\N
納采	のうさい	{結納 (ゆいのう) をとりかわすこと。現在では皇族の場合にだけいう。「―の儀」}	{"part of some ritual?"}	\N
農産物	のうさんぶつ	{}	{"agricultural produce"}	\N
農場	のうじょう	{}	{"farm (agriculture)"}	\N
農村	のうそん	{}	{"agricultural community; farm village; rural"}	\N
農地	のうち	{}	{"agricultural land"}	\N
濃度	のうど	{}	{"concentration; brightness"}	\N
納入	のうにゅう	{}	{"payment; supply"}	\N
農民	のうみん	{}	{"farmers; peasants"}	\N
農薬	のうやく	{}	{"agricultural chemicals"}	\N
能率	のうりつ	{}	{efficiency}	\N
能力	のうりょく	{物事を成し遂げることのできる力。「―を備える」「―を発揮する」「予知―」}	{"ability; faculty"}	\N
逃す	のがす	{}	{"to let loose; to set free; to let escape"}	\N
逃れる	のがれる	{}	{"to escape"}	\N
軒	のき	{}	{"eaves; house"}	\N
軒並み	のきなみ	{}	{"row of houses"}	\N
残す	のこす	{}	{"leave (behind; over); bequeath; save; reserve"}	\N
残らず	のこらず	{}	{"all; entirely; completely; without exception"}	\N
残り	のこり	{}	{"remnant; residue; remaining; left-over"}	\N
残る	のこる	{}	{remain}	\N
載せる	のせる	{}	{"to place on (something); to take on board; to give a ride; to let (one) take part; to impose on; to record; to mention; to load (luggage); to publish; to run (an ad)"}	\N
乗せる	のせる	{}	{"to place on (something); to take on board; to give a ride; to let (one) take part; to impose on; to record; to mention; to load (luggage); to publish; to run (an ad)"}	\N
除く	のぞく	{}	{"remove; exclude"}	\N
望ましい	のぞましい	{}	{"desirable; hoped for"}	\N
望み	のぞみ	{}	{"wish; desire; hope"}	\N
臨む	のぞむ	{向かい対する}	{"to look out on; to face; to deal with; to attend (function)"}	\N
野垂れ死にする	のたれしにする	{"die a dog's death"}	{"die a dog's death"}	\N
乗っ取る	のっとる	{}	{"to capture; to occupy; to usurp"}	\N
ので	ので	{活用語の連体形に付く。あとの叙述の原因・理由・根拠・動機などを表す。「辛い物を食べた―、のどが渇いた」「朝が早かった―、ついうとうとする」「盆地な―、夏は暑い」}	{"（接続助詞）because of; owing to; on account of; as; since; because; so... that"}	\N
喉	のど	{}	{throat}	\N
長閑	のどか	{}	{"tranquil; calm; quiet"}	\N
のに	のに	{活用語の連体形に付く。不平・不満・恨み・非難などの気持ちを表す。「これで幸せになれると思った―」「いいかげんにすればいい―」}	{"〔…と反対に〕though; although; in spite of〔…と比べ〕while; when"}	\N
罵る	ののしる	{}	{"to speak ill of; to abuse"}	\N
押し入れ	おしいれ	{}	{closet}	\N
後	のち	{}	{"afterwards; since then; in the future"}	\N
延ばす	のばす	{}	{"to lengthen; to stretch; to reach out; to postpone; to prolong; to extend; to grow (beard)"}	\N
伸ばす	のばす	{}	{"to lengthen; to stretch; to reach out; to postpone; to prolong; to extend; to grow (beard)"}	\N
延びる	のびる	{}	{"to be prolonged"}	\N
伸びる	のびる	{}	{"to stretch; to extend; to make progress; to grow (beard body height); to grow stale (soba); to lengthen; to spread; to be postponed; to be straightened; to be flattened; to be smoothed; to be exhausted"}	\N
延べ	のべ	{}	{"futures; credit (buying); stretching; total"}	\N
述べる	のべる	{}	{"state; express; mention"}	\N
上り	のぼり	{}	{"ascent; climbing; up-train (i.e. going to Tokyo)"}	\N
昇る	のぼる	{}	{"to arise; to ascend; to go up"}	\N
上る	のぼる	{}	{"to rise; to ascend; to be promoted; to go up; to climb; to go to (the capital); to add up to; to advance (in price); to sail up; to come up (on the agenda)"}	\N
登る	のぼる	{}	{climb}	\N
飲み込む	のみこむ	{}	{"to gulp down; to swallow deeply; to understand; to take in; to catch on to; to learn; to digest"}	\N
飲み物	のみもの	{}	{"drink; beverage"}	\N
飲む	のむ	{}	{"to drink"}	\N
乗り換え	のりかえ	{}	{"transfer (trains buses etc.)"}	\N
乗換	のりかえ	{}	{"transfer (trains; buses; etc.)"}	\N
乗り換える	のりかえる	{乗っていた乗り物を降りて、別の乗り物に乗る。乗り物をかえる。「各駅停車から急行に―・える」}	{transfer}	\N
乗り込む	のりこむ	{}	{"to board; to embark on; to get into (a car); to ship (passengers); to man (a ship); to help (someone) into; to march into; to enter"}	\N
乗り物	のりもの	{}	{"vehicle; vessel"}	\N
載る	のる	{}	{"get on; ride in; board; mount; get up on; be taken in; share in; join; be found in (a dictionary); feel like doing; be mentioned in; be in harmony with; appear (in print); be recorded"}	\N
乗る	のる	{}	{"get on; get up on; ride in; be taken in; share in; join; feel like doing; be mentioned in; be in harmony with"}	\N
詛い	のろい	{のろうこと。呪詛 (じゅそ) 。「―をかける」「―をとく」}	{"a curse; (break) a spell; (place) a curse (on a person)"}	\N
呑気	のんき	{}	{"carefree; optimistic; careless; reckless; heedless; happy-go-lucky; easygoing"}	\N
抜く	ぬく	{攻め落とす。}	{"take out; take down"}	\N
縫いぐるみ	ぬいぐるみ	{}	{"stuffed (e.g. doll)"}	\N
縫い包み	ぬいぐるみ	{}	{"stuffed (e.g. doll)"}	\N
縫う	ぬう	{}	{sew}	\N
抜かす	ぬかす	{}	{"to omit; to leave out"}	\N
脱ぐ	ぬぐ	{}	{"take off clothes"}	\N
抜け出す	ぬけだす	{}	{"to slip out; to sneak away; to excel"}	\N
抜ける	ぬける	{}	{"come out; fall out; be omitted; be missing; escape"}	\N
盗み	ぬすみ	{}	{stealing}	\N
盗む	ぬすむ	{}	{steal}	\N
布	ぬの	{}	{cloth}	\N
沼	ぬま	{}	{"swamp; bog; pond; lake"}	\N
塗る	ぬる	{}	{paint}	\N
温い	ぬるい	{}	{"lukewarm; tepid"}	\N
尾	お	{}	{"tail; ridge"}	\N
甥	おい	{自分の兄弟・姉妹が生んだ男の子。}	{nephew}	\N
追い掛ける	おいかける	{}	{"pursue; chase"}	\N
追い越す	おいこす	{}	{"to pass (e.g. car); outdistance"}	\N
追い込む	おいこむ	{}	{"to herd; to corner; to drive"}	\N
美味しい	おいしい	{}	{delicious}	\N
追い焚き	おいだき	{}	{reheating}	\N
追い出す	おいだす	{}	{"to expel; to drive out"}	\N
追い付く	おいつく	{}	{"overtake; catch up (with)"}	\N
お出でになる	おいでになる	{}	{"to be"}	\N
老いる	おいる	{}	{"to age; to grow old"}	\N
お祝い	おいわい	{}	{celebration}	\N
負う	おう	{}	{"to bear; to owe"}	\N
王	おう	{}	{king}	\N
追う	おう	{}	{chase}	\N
応援	おうえん	{}	{"aid; assistance; help; reinforcement; support; cheering"}	\N
鈍い	のろい	{}	{"dull (e.g. a knife); thickheaded; slow; stupid"}	\N
御	お	{}	{"honorific prefix"}	\N
主	ぬし	{}	{"〔主人〕a master〔持ち主〕〔古くから住み着いたもの，特に霊〕"}	\N
呪い	のろい	{のろうこと。呪詛 (じゅそ) 。「―をかける」「―をとく」}	{"a curse; (break) a spell; (place) a curse (on a person)"}	\N
応急	おうきゅう	{}	{emergency}	\N
王国	おうこく	{}	{kingdom}	\N
黄金	おうごん	{}	{gold}	\N
王様	おうさま	{}	{king}	\N
王子	おうじ	{}	{prince}	\N
王女	おうじょ	{}	{princess}	\N
欧州	おうしゅう	{}	{europe}	\N
応ずる	おうずる	{}	{"answer; respond; meet; satisfy; accept"}	\N
応接	おうせつ	{}	{reception}	\N
応対	おうたい	{}	{"receiving; dealing with"}	\N
横断	おうだん	{}	{crossing}	\N
応答	おうとう	{}	{"reply; comply (compatible)"}	\N
往復	おうふく	{}	{"round trip; coming and going; return ticket"}	\N
欧米	おうべい	{}	{"Europe and America; the West"}	\N
応募	おうぼ	{}	{"subscription; application"}	\N
応用	おうよう	{}	{"application; put to practical use"}	\N
終える	おえる	{}	{"to finish"}	\N
多い	おおい	{}	{"have a lot of"}	\N
大いに	おおいに	{}	{"very; much; greatly"}	\N
覆う	おおう	{}	{"cover; hide; conceal; wrap; disguise"}	\N
大方	おおかた	{}	{"perhaps; almost all; majority"}	\N
大型	おおがた	{物事の内容・規模、また、人物などが他のものより大きいこと。また、そのさま。「―の台風」「―の新人」「―バス」⇔小型。}	{"large; large-sized"}	\N
大柄	おおがら	{}	{"large build; large pattern"}	\N
大きい	おおきい	{}	{"big; large; great"}	\N
大きな	おおきな	{}	{"big; large"}	\N
大げさ	おおげさ	{}	{"grandiose; exaggerated"}	\N
大ざっぱ	おおざっぱ	{}	{"rough (as in not precise); broad; sketchy"}	\N
大筋	おおすじ	{}	{"outline; summary"}	\N
大勢	おおぜい	{}	{"many; a great number (of people)"}	\N
大空	おおぞら	{}	{"heaven; firmament; the sky"}	\N
大通り	おおどおり	{}	{"main street"}	\N
大幅	おおはば	{普通より幅の広いこと。また、そのさま。⇔小幅。}	{"full width; large scale; drastic"}	\N
大水	おおみず	{}	{flood}	\N
大晦日	おおみそか	{1年の最終の日。12月31日。おおつごもり。}	{"the last day of the year; 〔その晩〕New Year's Eve"}	\N
大家	おおや	{}	{"landlord; landlady"}	\N
公	おおやけ	{}	{"official; public; formal; open; governmental"}	\N
大凡	おおよそ	{}	{"about; roughly; approximately; as a rule"}	\N
丘	おか	{}	{hill}	\N
岡	おか	{}	{hill}	\N
お母さん	おかあさん	{}	{"(polite) mother"}	\N
お帰り	おかえり	{　帰る人を敬って、その帰ることをいう語。「―にお寄りください」}	{"〔旅行や外国から帰った人に〕Welcome home [back]!"}	\N
お蔭様で	おかげさまで	{}	{"Thanks to god; thanks to you"}	\N
お菓子	おかし	{}	{"confections; sweets; candy"}	\N
可笑しい	おかしい	{}	{"strange; funny; amusing; ridiculous"}	\N
侵す	おかす	{}	{"to invade; to raid; to trespass; to violate; to intrude on"}	\N
犯す	おかす	{}	{"to commit; to perpetrate; to violate; to rape"}	\N
お菜	おかず	{}	{"side dish; accompaniment for rice dishes"}	\N
お金	おかね	{}	{money}	\N
拝む	おがむ	{}	{"worship; beg"}	\N
お代わり	おかわり	{}	{"second helping; another cup"}	\N
沖	おき	{}	{"open sea"}	\N
置き換える	おきかえる	{物をどかして他の物をそのあとに置く。「床の間の置物を生け花にー・える」「ここはもう少し的確な表現にー・えたい」}	{"〔置く場所を変える〕change the location ((of))，change [shift; move]((a thing from A to B)); 〔配列し直す〕rearrange〔他の物と取り替える〕replace ((A with B)); substitute ((B for A))"}	\N
置き去り	おきざり	{あとに残したまま、行ってしまうこと。置き捨て。「子供をーにする」「絶海の孤島にーにされる」}	{"leave; 〔見捨てる〕desert ((one's family))"}	\N
黄色	おうしょく	{}	{yellow}	\N
大事	おおごと	{}	{"important; valuable; serious matter"}	\N
起き攻め	おきぜめ	{}	{"wake-up attack"}	\N
お気遣いなく	おきづかいなく	{気をつかわないように相手に丁寧に述べる表現。気遣い無用。}	{"no worries!"}	\N
翁	おきな	{}	{"an old man"}	\N
補う	おぎなう	{}	{"compensate for"}	\N
お客様	おきゃくさま	{}	{"venerable mr guest"}	\N
御客様	おきゃくさま	{}	{"venerable mr guest"}	\N
起きる	おきる	{}	{"get up; rise"}	\N
置く	おく	{}	{"put; place"}	\N
奥	おく	{}	{interior}	\N
億	おく	{}	{"a hundred million"}	\N
屋外	おくがい	{}	{outdoors}	\N
奥さん	おくさん	{}	{"(polite) wife; your wife; his wife; married lady; madam"}	\N
屋上	おくじょう	{}	{"the roof top"}	\N
臆病	おくびょう	{}	{"cowardice; timidity"}	\N
遅らす	おくらす	{}	{"to retard; to delay"}	\N
送り仮名	おくりがな	{}	{"kana written after a kanji to complete the full (usually kun) reading of the word"}	\N
贈り物	おくりもの	{}	{gift}	\N
贈る	おくる	{}	{"send; give to; award to; confer on"}	\N
送る	おくる	{}	{"send (a thing); take or escort (a person somewhere); see off (a person); spend a period of time; live a life"}	\N
遅れ	おくれ	{}	{"delay; lag"}	\N
遅れる	おくれる	{}	{"to be late"}	\N
於ける	おける	{作用・動作の行われる場所・時間を表す。…の中の。…での。…にあっての。「日本にー生活」「過去にー経験」}	{"in (a field); within (a country)"}	\N
起す	おこす	{}	{"raise; cause; wake someone"}	\N
厳か	おごそか	{}	{"austere; majestic; dignified; stately; awful; impressive"}	\N
怠る	おこたる	{すべきことをしないでおく。なまける。また、気をゆるめる。油断する。無視する。「学業を―・る」「注意を―・る」}	{"neglect; be off guard; be feeling better"}	\N
行い	おこない	{}	{"deed; conduct; behavior; action; asceticism"}	\N
行う	おこなう	{物事をする。なす。やる。実施する。「儀式を―・う」「合同演習を―・う」「四月五日に入学式が―・われる」}	{"to perform; to do; to conduct oneself; to carry out"}	\N
起こる	おこる	{今までなかったものが新たに生じる。おきる。「静電気が―・る」「さざ波が―・る」}	{"occur; happen"}	\N
長	おさ	{}	{"chief; head"}	\N
押さえる	おさえる	{}	{"to stop; to restrain; to seize; to repress; to suppress; to press down"}	\N
押える	おさえる	{}	{"stop; restrain; seize; repress; suppress; press down"}	\N
抑える	おさえる	{感情・欲望などが高ぶるのをとどめる。抑制する。スポーツで、相手の勢いをとどめる。}	{"surpress; restrain; control"}	\N
お先に	おさきに	{}	{"before; ahead; previously"}	\N
お酒	おさけ	{}	{"(polite) wine; sake"}	\N
幼い	おさない	{年齢が若い。幼少である。いとけない。「息子はまだー・い」}	{"very young; childish"}	\N
治まる	おさまる	{}	{"to be at peace; to clamp down; to lessen (storm terror anger)"}	\N
納まる	おさまる	{}	{"to be obtained; to end; to settle into; to fit into; to be settled; to be paid; to be delivered"}	\N
収まる	おさまる	{}	{"to be obtained; to end; to settle into; to fit into; to be settled; to be paid; to be delivered"}	\N
治める	おさめる	{}	{"govern; manage; subdue"}	\N
納める	おさめる	{}	{"to obtain; to reap; to pay; to supply; to accept"}	\N
収める	おさめる	{}	{"to obtain; to reap; to pay; to supply; to accept"}	\N
お皿	おさら	{}	{"(polite) dish; plate"}	\N
お産	おさん	{}	{"(giving) birth"}	\N
叔父	おじ	{}	{"uncle (younger than one´s parent)"}	\N
押上げ	おしあげ	{}	{push-up}	\N
押し上げ	おしあげ	{}	{push-up}	\N
惜しい	おしい	{}	{"regrettable; disappointing; precious"}	\N
お祖父さん	おじいさん	{}	{"grandfather; male senior-citizen"}	\N
怒る	おこる	{}	{"get angry"}	\N
教え	おしえ	{}	{"teachings; precept; lesson; doctrine"}	\N
教える	おしえる	{}	{"teach; inform; instruct"}	\N
押し固める	おしかためる	{}	{"to press together"}	\N
御辞儀	おじぎ	{}	{bow}	\N
押し込む	おしこむ	{}	{"to push into; to crowd into"}	\N
小父さん	おじさん	{}	{"middle-aged gentleman; uncle"}	\N
伯父さん	おじさん	{}	{"middle-aged gentleman; uncle"}	\N
惜しむ	おしむ	{}	{"to be frugal; to value; to regret"}	\N
お邪魔します	おじゃまします	{}	{"Excuse me for disturbing (interrupting) you"}	\N
押麦	おし‐むぎ	{蒸した大麦を押しつぶして平たくし、乾かしたもの。米にまぜ、炊いて食べる。}	{"rolled barley"}	\N
お洒落	おしゃれ	{}	{"smartly dressed; someone smartly dressed; fashion-conscious"}	\N
お嬢さん	おじょうさん	{}	{"daughter (polite)"}	\N
押し寄せる	おしよせる	{}	{"to push aside; to advance on"}	\N
雄	おす	{}	{"male (animal)"}	\N
押す	おす	{}	{"push; press; stamp (e.g. a passport)"}	\N
お薦め	おすすめ	{}	{recommendation}	\N
お世辞	おせじ	{}	{"flattery; compliment"}	\N
汚染	おせん	{}	{"pollution; contamination"}	\N
遅い	おそい	{}	{"late; slow"}	\N
襲う	おそう	{}	{"to attack"}	\N
遅くとも	おそくとも	{}	{"at the latest"}	\N
恐らく	おそらく	{}	{perhaps}	\N
恐るべき	おそるべき	{恐れなければならない。恐れるのが当然の。ひどく恐ろしい「ー自然破壊」}	{"terrifying; terrible; dreadful"}	\N
恐れ	おそれ	{}	{"fear; horror"}	\N
虞	おそれ	{よくないことが起こるかもしれないという心配。懸念。「自殺の―がある」}	{"〔懸念〕fear ((of))，apprehension ((about)); 〔危険〕danger"}	\N
恐れ入る	おそれいる	{}	{"to be filled with awe; to feel small; to be amazed; to be surprised; to be disconcerted; to be sorry; to be grateful; to be defeated; to confess guilt"}	\N
恐れる	おそれる	{危険を感じて不安になる。恐怖心を抱く。「報復をー・れる」「死をー・れる」}	{"to fear; be afraid of"}	\N
恐ろしい	おそろしい	{}	{"terrible; dreadful"}	\N
教わる	おそわる	{}	{"be taught"}	\N
お大事に	おだいじに	{}	{"Take care of yourself"}	\N
お互い	おたがい	{相対する関係にある二者。双方、または、そのひとつひとつ。「お互い」の形でも用いる。「―の意思を尊重する」「―が譲り合う」}	{"mutual; reciprocal; each other"}	\N
お宅	おたく	{}	{"your house (polite)"}	\N
汚濁	おだく	{}	{"pollution; dirty; corruption. bribery"}	\N
お玉	おたま	{}	{ladle}	\N
穏やか	おだやか	{}	{"calm; gentle; quiet"}	\N
落ち込む	おちこむ	{}	{"to fall into; to feel down (sad)"}	\N
落ち着き	おちつき	{}	{"calm; composure"}	\N
陥る	おちいる	{望ましくない状態になる。よくない状態になる}	{"fall into (critical position/predicament);"}	\N
落着く	おちつく	{}	{"calm down; settle in; be steady"}	\N
落ち葉	おちば	{}	{"fallen leaves; leaf litter; defoliation; shedding leaves"}	\N
お茶	おちゃ	{}	{"tea (green)"}	\N
御茶	おちゃ	{}	{tea}	\N
落ちる	おちる	{}	{"fall; drop; come down"}	\N
乙	おつ	{}	{"strange; quaint; stylish; chic; spicy; queer; witty; tasty; romantic; 2nd in rank; second sign of the Chinese calendar"}	\N
お使い	おつかい	{}	{errand}	\N
御疲れ様	おつかれさま	{相手の労苦をねぎらう意で用いる言葉。また、職場で、先に帰る人へのあいさつにも使う。「ご苦労様」は目上の人から目下の人に使うのに対し、「お疲れ様」は同僚、目上の人に対して使う。}	{"Cheers for good work"}	\N
仰っしゃる	おっしゃる	{}	{"to say; to speak; to tell; to talk"}	\N
追っ手	おって	{逃げていく者をつかまえるために追いかける人}	{pursuer}	\N
夫	おっと	{}	{"(humble) (my) husband"}	\N
お手上げ	おてあげ	{}	{"all over; given in; given up hope; bring to knees"}	\N
お手洗い	おてあらい	{}	{"toilet; restroom; lavatory; bathroom (US)"}	\N
お出掛け	おでかけ	{}	{"about to start out; just about to leave or go out"}	\N
御手数	おてすう	{}	{trouble}	\N
お手伝いさん	おてつだいさん	{}	{maid}	\N
お手並み拝見	おてなみはいけん	{相手の腕前や能力がどれくらいあるか拝見しよう。腕前を見せる}	{"showing of skill"}	\N
音	おと	{}	{sound}	\N
お父さん	おとうさん	{}	{"(polite) father"}	\N
弟神	おとうとがみ	{}	{"younger god brother"}	\N
脅かす	おどかす	{}	{"to threaten; to coerce"}	\N
男	おとこ	{}	{man}	\N
男の子	おとこのこ	{}	{boy}	\N
男の人	おとこのひと	{}	{man}	\N
落し物	おとしもの	{}	{"lost property"}	\N
落とす	おとす	{}	{"drop; let fall"}	\N
訪れる	おとずれる	{}	{"to visit"}	\N
脅す	おどす	{相手を恐れさせる。脅迫する。おどかす。}	{threaten}	\N
大人	おとな	{}	{adult}	\N
お供	おとも	{}	{"attendant; companion"}	\N
踊り	おどり	{}	{dancing}	\N
踊り狂う	おどりくるう	{夢中になって激しく踊る。「若者たちが―・う」}	{"dance like mad [like crazy／in a frenzy] (all night long)"}	\N
劣る	おとる	{}	{"fall behind; be inferior to"}	\N
踊る	おどる	{}	{"to dance"}	\N
衰える	おとろえる	{}	{"to become weak; to decline; to wear; to abate; to decay; to wither; to waste away"}	\N
驚かす	おどろかす	{}	{"surprise; frighten; create a stir"}	\N
驚き	おどろき	{}	{"surprise; astonishment; wonder"}	\N
驚く	おどろく	{}	{"to surprise"}	\N
同い年	おないどし	{}	{"of the same age"}	\N
お腹	おなか	{}	{stomach}	\N
同じ	おなじ	{同様。一緒}	{same}	\N
同じ穴のムジナ	おなじあなのもじな	{普通、悪事を働く同類の意味で使われる}	{"fellow rule-breaker (badger of the same hole)"}	\N
鬼	おに	{}	{"ogre; demon"}	\N
お兄さん	おにいさん	{}	{"(polite) older brother; (vocative) 'Mister?'"}	\N
お姉さん	おねえさん	{}	{"(polite) older sister; (vocative) 'Miss?'"}	\N
お願いします	おねがいします	{}	{please}	\N
自ずから	おのずから	{}	{"naturally; as a matter of course"}	\N
己	おのれ	{}	{yourself}	\N
叔母	おば	{}	{aunt}	\N
お祖母さん	おばあさん	{}	{"grandmother; female senior-citizen"}	\N
お化け	おばけ	{}	{ghost}	\N
伯母さん	おばさん	{}	{aunt}	\N
お早う	おはよう	{}	{"Good morning"}	\N
帯	おび	{}	{"kimono sash"}	\N
お昼	おひる	{}	{"lunch; noon"}	\N
帯びる	おびる	{}	{"to wear; to carry; to be entrusted; to have; to take on; to have a trace of; to be tinged with"}	\N
お弁当	おべんとう	{}	{"lunch box"}	\N
覚え	おぼえ	{}	{"memory; sense; experience"}	\N
憶える	おぼえる	{見聞きした事柄を心にとどめる。記憶する。「子供のころのことはー・えていない」}	{"learn; remember; bear ((a thing)) in mind; memorize"}	\N
溺れる	おぼれる	{}	{"be drowned; indulge in"}	\N
お参り	おまいり	{}	{"worship; shrine visit"}	\N
お任せ	おまかせ	{物事の判断や処理などを他人に任せること。特に、料理屋で料理の内容を店に一任すること。「―コース」「荷造りからすべて―でやってくれる引っ越しサービス」}	{"rely; leave it up to (e.g. the chef; washing machine)"}	\N
御任せ	おまかせ	{物事の判断や処理などを他人に任せること。特に、料理屋で料理の内容を店に一任すること。「―コース」「荷造りからすべて―でやってくれる引っ越しサービス」}	{"rely; leave it up to (e.g. the chef; washing machine)"}	\N
御負け	おまけ	{}	{"a discount; a prize; something additional; bonus; an extra; an exaggeration"}	\N
お祭り	おまつり	{}	{festival}	\N
お巡りさん	おまわりさん	{}	{"policeman (friendly term)"}	\N
お見舞い	おみまい	{}	{"asking after (a person´s health)"}	\N
お宮	おみや	{}	{"Shinto shrine"}	\N
お土産	おみやげ	{}	{souvenir}	\N
弟	おと	{}	{"younger brother"}	\N
弟	おとうと	{}	{"younger brother; faithful service to those older; brotherly affection"}	\N
一昨日	おととい	{}	{"day before yesterday"}	\N
一昨年	おととし	{}	{"year before last"}	\N
汚名	おめい	{}	{"stigma; dishonour; dishonor; infamy"}	\N
お目出度う	おめでとう	{}	{"(ateji) (int) (uk) Congratulations!; an auspicious occasion!"}	\N
お目に掛かる	おめにかかる	{}	{"to see or meet someone"}	\N
重い	おもい	{}	{"heavy; massive; serious; important; severe; oppressed"}	\N
思い掛けない	おもいがけない	{}	{"unexpected; casual"}	\N
思い込む	おもいこむ	{}	{"be under impression that; be convinced that; imagine that; set one´s heart on; be bent on"}	\N
思い切り	おもいきり	{あきらめ。満足できるまでするさま。思う存分。「―遊びたい」「―がいい」}	{"〔思う存分〕to one's heart's content; 〔力一杯〕to the best of one's ability; with all one's might"}	\N
思い出す	おもいだす	{}	{"recall; remember"}	\N
思い付き	おもいつき	{}	{"plan; idea; suggestion"}	\N
思い付く	おもいつく	{}	{"think of; hit upon; come into one´s mind"}	\N
思い出	おもいで	{}	{"memories; recollections; reminiscence"}	\N
思う	おもう	{ある物事について考えをもつ。考える。}	{think}	\N
想う	おもう	{眼前にない物事について、心を働かせる。想像する。「―・ったほどおもしろくない」「夢にも―・わなかった」}	{"think; conceptulize; make up ideas"}	\N
憶う	おもう	{}	{"think; remember; recollect"}	\N
念う	おもう	{願う。希望する。「―・うようにいかない」「背が高くなりたいと―・う」}	{"think; wish; feel; disire"}	\N
思う存分	おもうぞんぶん	{満足がいくまで。思いきり。「―（に）遊びたい」「―の働き」}	{"all (I) want; as hard as one (can); (eat) to one's fill; (cry one) heart out"}	\N
面白い	おもしろい	{}	{"interesting; amusing"}	\N
重たい	おもたい	{}	{"heavy; massive; serious; important; severe; oppressed"}	\N
玩具	おもちゃ	{}	{"〔子供の〕a toy; a plaything"}	\N
主な	おもな	{}	{"main; leading"}	\N
主に	おもに	{}	{"mainly; primarily"}	\N
趣	おもむき	{}	{"meaning; tenor; gist; effect; appearance; taste; grace; charm; refinement"}	\N
赴く	おもむく	{}	{"to go; to proceed; to repair to; to become"}	\N
思わず	おもわず	{そのつもりではないのに。考えもなく。無意識に。気が付かずに。本能的に}	{"unintentionally; spontanuously"}	\N
重んじる	おもんじる	{}	{"to respect; to honor; to esteem; to prize"}	\N
重んずる	おもんずる	{}	{"to honor; to respect; to esteem; to prize"}	\N
親	おや	{}	{parents}	\N
おやおや	おやおや	{意外なことに対して、軽く驚いたり、失望したり、あきれたりしたときに発する語。「―、おかしいぞ」}	{"〔困って〕uh-oh; oh no; oh dear"}	\N
お休み	おやすみ	{}	{"holiday; absence; rest; Good night"}	\N
親父	おやじ	{}	{father}	\N
お八	おやつ	{}	{"(uk) between meal snack; afternoon refreshment; afternoon tea; mid-day snack"}	\N
親指	おやゆび	{}	{thumb}	\N
泳ぎ	およぎ	{}	{swimming}	\N
泳ぐ	およぐ	{}	{swim}	\N
凡そ	およそ	{}	{"about; roughly; as a rule; approximately"}	\N
及び	および	{}	{"and; as well as"}	\N
及ぶ	およぶ	{}	{"to reach; to come up to; to amount to; to befall; to happen to; to extend; to match; to equal"}	\N
及ぼす	およぼす	{}	{"exert; cause; exercise"}	\N
織	おり	{}	{"weave; weaving; woven item"}	\N
折り合い	おりあい	{譲り合って解決すること。妥協・折衷「大筋でのーがつく」}	{compromise}	\N
折り返す	おりかえす	{}	{"to turn up; to fold back"}	\N
折紙	おりがみ	{紙を折って種々の物の形を作る遊び。また、それに使う紙。ふつう、正方形の色紙 (いろがみ) を使う。}	{origami}	\N
織物	おりもの	{}	{"textile; fabric"}	\N
下りる	おりる	{}	{"come down"}	\N
折る	おる	{}	{"break; fold; pick (flower)"}	\N
織る	おる	{}	{"to weave"}	\N
俺	おれ	{}	{"I (ego) (boastful first-person pronoun)"}	\N
面	おも	{}	{face}	\N
表	おもて	{}	{"the front"}	\N
重なる	おもなる	{}	{"main; principal; important"}	\N
重役	おもやく	{}	{"heavy responsibilities; director"}	\N
お礼	おれい	{}	{courtesy}	\N
折れる	おれる	{}	{"break; snap"}	\N
愚か	おろか	{頭の働きが鈍いさま。考えが足りないさま。}	{"foolish; silly; stupid"}	\N
愚かしい	おろかしい	{愚かである。ばかげている。「―・い行為」}	{"foolish; stupid"}	\N
愚かしさ	おろかしさ	{}	{"foolishness; stupidity"}	\N
卸売り	おろしうり	{生産者や輸入業者から大量の商品を仕入れ、小売商に売り渡すこと。また、その業種や業者。}	{wholesale}	\N
下す	おろす	{}	{"take down; launch; drop; lower; let (a person) off; unload; discharge"}	\N
降ろす	おろす	{}	{"to take down; to launch; to drop; to lower; to let (a person) off; to unload; to discharge"}	\N
卸す	おろす	{}	{"sell wholesale; grated (vegetables)"}	\N
疎か	おろそか	{}	{"neglect; negligence; carelessness"}	\N
終わり	おわり	{}	{"the end"}	\N
終わる	おわる	{続いていた物事が、そこでなくなる。しまいになる。済む。「授業が―・る」「一生が―・る」⇔始まる。}	{"〔おしまいになる〕end; be over; finish; be finished; 〔おしまいにする〕finish; end"}	\N
終る	おわる	{}	{"finish; close"}	\N
恩	おん	{}	{"favour; obligation; debt of gratitude"}	\N
音色	おんいろ	{}	{"tone color; tone quality; timbre; synthesizer patch"}	\N
音楽	おんがく	{}	{music}	\N
恩恵	おんけい	{}	{"grace; favor; blessing; benefit"}	\N
温室	おんしつ	{}	{greenhouse}	\N
恩赦	おんしゃ	{}	{"pardon; amnesty"}	\N
暗礁	あんしょう	{}	{"reef; sunken rock"}	\N
音声	おんせい	{テレビなどの音}	{"sound; a voice; speech"}	\N
温泉	おんせん	{}	{"spa; hot spring"}	\N
温帯	おんたい	{}	{"temperate zone"}	\N
温暖	おんだん	{}	{warmth}	\N
御中	おんちゅう	{}	{"and Company; Messrs."}	\N
温度	おんど	{}	{temperature}	\N
音符	おんぷ	{}	{"phonetic component (of a kanji); The part of a character that tells us how that character sounds."}	\N
女	おんな	{}	{"woman; girl; daughter"}	\N
女癖	おんなぐせ	{男がすぐ、女性関係を持つこと。多く「ーが悪い」の形で用いる。}	{"philanderer; womanizer"}	\N
女の子	おんなのこ	{}	{girl}	\N
女の人	おんなのひと	{}	{woman}	\N
怨念	おんねん	{}	{"grudge; hatred"}	\N
御柱	おんばしら	{}	{このページは「御柱祭」へ転送します。}	\N
音量	おんりょう	{}	{volume}	\N
温和	おんわ	{}	{"gentle; mild; moderate"}	\N
生麺	ラーメン	{麺類を成形したままの状態で、未加熱・未乾燥のものをいう。}	{ramen}	\N
来	らい	{}	{"since (last month); for (10 days); next (year)"}	\N
雷雨	らいう	{}	{thunderstrom}	\N
来月	らいげつ	{次の月}	{"next month"}	\N
来週	らいしゅう	{}	{"next week"}	\N
来場	らいじょう	{}	{attendance}	\N
来日	らいにち	{}	{"arrival in Japan; coming to Japan; visit to Japan"}	\N
来年	らいねん	{}	{"next year"}	\N
楽	らく	{}	{"comfort; ease"}	\N
落第	らくだい	{}	{"failure; dropping out of a class"}	\N
酪農	らくのう	{}	{"dairy (farm)"}	\N
落下	らっか	{}	{"fall; drop; come down"}	\N
落花生	らっかせい	{マメ科の一年草。茎は横にはい、葉は二対の小葉からなる複葉で、互生する。}	{peanut}	\N
楽観	らっかん	{}	{optimism}	\N
欄	らん	{}	{"column of text (as in a newspaper)"}	\N
乱交	らんこう	{}	{promiscuous}	\N
乱取り	らんどおり	{柔道で、互いに自由に技をかけ合って練習すること。}	{"〔柔道で〕free exercises (in judo)"}	\N
乱暴	らんぼう	{}	{"rude; violent; rough; lawless; unreasonable; reckless"}	\N
濫用	らんよう	{}	{"abuse; misuse; misappropriation; using to excess"}	\N
礼	れい	{}	{"expression of gratitude"}	\N
例外	れいがい	{}	{exception}	\N
礼儀	れいぎ	{}	{"manners; courtesy; etiquette"}	\N
略奪	りゃくだつ	{}	{"pillage; plunder; looting; robbery"}	\N
廊下	ろうか	{}	{corridor}	\N
零	れい	{}	{"zero; nought"}	\N
礼金	れいきん	{部屋や家を借りるとき、謝礼金という名目で家主に支払う一時金。「―と敷金」}	{"〔専門職に対する〕a fee; 〔家主に払う〕key money"}	\N
冷酷	れいこく	{}	{"cruelty; coldheartedness; relentless; ruthless"}	\N
冷静	れいせい	{}	{"calm; composure; coolness; serenity"}	\N
冷蔵	れいぞう	{}	{"cold storage; refrigeration"}	\N
冷蔵庫	れいぞうこ	{}	{refrigerator}	\N
冷淡	れいたん	{}	{"coolness; indifference"}	\N
零点	れいてん	{}	{"zero; no marks"}	\N
冷凍	れいとう	{}	{"freezing; cold storage; refrigeration"}	\N
冷房	れいぼう	{}	{"cooling; air-conditioning"}	\N
歴史	れきし	{人間社会が経てきた変遷・発展の経過。また、その記録。「日本の―」「―上の事件」「―に残る」「―をひもとく」}	{history}	\N
歴代	れきだい	{何代も経てきていること。また、それぞれの代。歴世。「―の首相」}	{"successive generations"}	\N
列	れつ	{}	{"line; row"}	\N
列車	れっしゃ	{}	{"train (ordinary)"}	\N
列島	れっとう	{}	{"chain of islands"}	\N
恋愛	れんあい	{特定の異性に特別の愛情を感じて恋い慕うこと。また、男女が互いにそのような感情をもつこと。「熱烈にーする」}	{love}	\N
煉瓦	れんが	{}	{brick}	\N
冷却	れいきゃく	{温度を下げること。また、温度が下がること。「機関をーする」「ー水」}	{"cooling; refrigeration"}	\N
連休	れんきゅう	{}	{"consecutive holidays"}	\N
錬金術	れんきんじゅつ	{}	{alchemy}	\N
連合	れんごう	{}	{"union; alliance"}	\N
連日	れんじつ	{}	{"every day; prolonged"}	\N
連射	れんしゃ	{}	{rapid-fire}	\N
練習	れんしゅう	{}	{practice}	\N
連勝	れんしょう	{続けて勝つこと。「連勝式」の略。「連戦ー」}	{"((three)) victories in a row; ((three)) straight wins"}	\N
連想	れんそう	{}	{"association (of ideas); suggestion"}	\N
連続	れんぞく	{}	{"serial; consecutive; continuity; occurring in succession; continuing"}	\N
連帯	れんたい	{}	{solidarity}	\N
連中	れんちゅう	{仲間である者たち。また、同じようなことをする者たちをひとまとめにしていう語。親しみ、あるいは軽蔑 (けいべつ) を込めていう。「クラスのーを誘ってみる」「こういうーは度し難い」}	{"colleagues; company; a lot"}	\N
廉売	れんばい	{商品を安い値段で売ること。安売り。「傷物を―する」「特価大―」}	{"a (bargain) sale⇒やすうり(安売り)"}	\N
連邦	れんぽう	{アメリカ・スイス・ドイツなど。連合国家。}	{"commonwealth; federation of states"}	\N
連盟	れんめい	{}	{"league; union; alliance"}	\N
連絡	れんらく	{}	{"junction; communication; connection; coordination"}	\N
連絡先	れんらくさき	{}	{contacts}	\N
利益	りえき	{}	{"profits; gains; (political; economic) interest"}	\N
理科	りか	{}	{science}	\N
理解	りかい	{物事の道理や筋道が正しくわかること。「―が早い」}	{"understanding; comprehension"}	\N
利害	りがい	{}	{"advantages and disadvantages; interest"}	\N
力士	りきし	{}	{sumo-wrestler}	\N
陸	りく	{}	{"land; shore"}	\N
陸軍	りくぐん	{}	{army}	\N
理屈	りくつ	{}	{"theory; reason"}	\N
利口	りこう	{}	{"clever; shrewd; bright; sharp; wise; intelligent"}	\N
利根	りこん	{}	{intelligence}	\N
離婚	りこん	{}	{divorce}	\N
利子	りし	{}	{"interest (bank)"}	\N
理事	りじ	{団体を代表し、担当事務を処理する特定の役職。}	{"a director; 〔大学などの〕a trustee"}	\N
利潤	りじゅん	{}	{"profit; returns"}	\N
理性	りせい	{}	{"reason; sense"}	\N
理想	りそう	{}	{ideal}	\N
利息	りそく	{}	{"interest (bank)"}	\N
利他	りた	{}	{"〜的 altruistic; unselfish"}	\N
率	りつ	{}	{"rate; ratio; proportion; percentage"}	\N
立秋	りっしゅう	{}	{"first day of autumn"}	\N
立体	りったい	{}	{"solid body"}	\N
立派	りっぱ	{}	{"splendid; fine; handsome; elegant; imposing; prominent; legal; legitimate"}	\N
立法	りっぽう	{}	{"legislation; lawmaking"}	\N
利点	りてん	{}	{"advantage; point in favor"}	\N
略語	りゃくご	{}	{"abbreviation; acronym"}	\N
略す	りゃくす	{}	{abbreviate}	\N
流	りゅう	{}	{"styleof; method of; manner of"}	\N
理由	りゆう	{}	{reason}	\N
留意	りゅうい	{ある物事に心をとどめて、気をつけること。「健康に―する」「―点」}	{"pay attention to; give thought to; keep in mind"}	\N
流域	りゅういき	{}	{"(river) basin"}	\N
留学	りゅうがく	{}	{"studying abroad"}	\N
留学生	りゅうがくせい	{}	{"overseas student"}	\N
粒子	りゅうし	{}	{"particle (of light); grain (of sand)"}	\N
流暢	りゅうちょう	{言葉が滑らかに出てよどみないこと。また、そのさま。「ーな英語で話す」}	{fluency}	\N
流通	りゅうつう	{}	{"circulation of money or goods; flow of water or air; distribution"}	\N
了	りょう	{}	{"finish; completion; understanding"}	\N
量	りょう	{}	{"quantity; amount; volume; portion (of food)"}	\N
料	りょう	{}	{"material; charge; rate; fee"}	\N
寮	りょう	{}	{"hostel; dormitory"}	\N
利用	りよう	{}	{use}	\N
領域	りょういき	{}	{"area; domain; territory; field; region; regime"}	\N
了解	りょうかい	{}	{"comprehension; consent; understanding; roger (on the radio)"}	\N
領海	りょうかい	{}	{"territorial waters"}	\N
両替	りょうがえ	{}	{"change; money exchange"}	\N
両側	りょうがわ	{}	{"both sides"}	\N
利用規約	りようきやく	{}	{"terms of use (規約 agreement; code)"}	\N
両極	りょうきょく	{}	{"both extremities; north and south poles; positive and negative poles"}	\N
料金	りょうきん	{}	{"fee; charge; fare"}	\N
利用権	りようけん	{}	{"right to use"}	\N
良好	りょうこう	{}	{"favorable; satisfactory"}	\N
両国	りょうこく	{両方の国。ある物事にかかわる二つの国。「―の首脳」}	{"the two countries"}	\N
量産	りょうさん	{}	{"mass production"}	\N
漁師	りょうし	{}	{fisherman}	\N
領事	りょうじ	{}	{consul}	\N
良識	りょうしき	{}	{"good sense"}	\N
良質	りょうしつ	{}	{"good quality; superior quality"}	\N
領収	りょうしゅう	{}	{"receipt; voucher"}	\N
領袖	りょうしゅう	{}	{"leader (e.g. president; prime minister; CEO)"}	\N
領収書	りょうしゅうしょ	{金銭を受け取ったしるしに書いて渡す書き付け。受取 (うけとり) 。受領証。領収証。レシート。}	{receipt}	\N
了承	りょうしょう	{}	{"acknowledgement; understanding (e.g. 'please be understanding of the mess during our renovation')"}	\N
良心	りょうしん	{}	{conscience}	\N
両親	りょうしん	{}	{"parents; both parents"}	\N
領地	りょうち	{}	{"territory; dominion"}	\N
両手	りょうて	{左右両方の手。もろて。「―利き」}	{"both hands"}	\N
料亭	りょうてい	{主として日本料理を出す高級な料理屋。}	{"a first-class Japanese restaurant"}	\N
領土	りょうど	{}	{"dominion; territory; possession"}	\N
両方	りょうほう	{}	{both}	\N
料理	りょうり	{}	{"cooking; cookery; cuisine"}	\N
両立	りょうりつ	{}	{"compatibility; coexistence; standing together"}	\N
旅客	りょかく	{}	{"passenger (transport)"}	\N
旅館	りょかん	{}	{"Japanese inn"}	\N
旅券	りょけん	{}	{passport}	\N
旅行	りょこう	{}	{"travel; trip"}	\N
履歴	りれき	{}	{"personal history; background; career; log"}	\N
理論	りろん	{}	{theory}	\N
林業	りんぎょう	{}	{forestry}	\N
臨時	りんじ	{特別「ー急行」「ー休業」「ー休館」}	{"temporary; special; extraordinary"}	\N
隣人	りんじん	{となりに住む人。となり近所の人。また、自分のまわりにいる人。「―愛」}	{"a neighbor，((英)) a neighbour; 〔総称〕the neighborhood"}	\N
倫理	りんり	{人として守り行うべき道。善悪・正邪の判断において普遍的な規準となるもの。道徳。モラル。「ーにもとる行為」「ー観」「政治ー」}	{"ethics; morals"}	\N
炉	ろ	{}	{"〔囲炉裏〕a sunken hearth (cut in the middle of the floor); 〔暖炉〕a fireplace; 〔かまど〕a furnace⇒いろり(囲炉裏)"}	\N
流行	りゅうこう	{}	{"fashionable; fad; in vogue; prevailing"}	\N
輪	りん	{}	{"counter for wheels and flowers"}	\N
楼閣	ろうかく	{}	{"multistoried building"}	\N
老人	ろうじん	{}	{"the aged; old person"}	\N
老衰	ろうすい	{}	{"senility; senile decay"}	\N
労働	ろうどう	{}	{"manual labor; toil; work"}	\N
朗読	ろうどく	{}	{"reading aloud; recitation"}	\N
浪人	ろうにん	{古代、本籍地を離れ、他国を流浪している者。浮浪人。}	{"a person out of work; an unemployed person"}	\N
老婆	ろうば	{年とった女性。老女。老媼 (ろうおう) 。}	{"an old woman"}	\N
浪費	ろうひ	{}	{"waste; extravagance"}	\N
浪費癖	ろうひぐせ	{金銭をむだに使うくせ}	{"Extravagant spending habits"}	\N
労力	ろうりょく	{}	{"labour; effort; toil; trouble"}	\N
録音	ろくおん	{}	{"(audio) recording"}	\N
六十代	ろくじゅうだい	{}	{sixties}	\N
露骨	ろこつ	{}	{"frank; blunt; plain; outspoken; conspicuous; open; broad; suggestive"}	\N
路線	ろせん	{}	{route}	\N
論議	ろんぎ	{}	{discussion}	\N
論じる	ろんじる	{}	{"argue; discuss; debate"}	\N
論ずる	ろんずる	{}	{"argue; discuss; debate"}	\N
論争	ろんそう	{}	{"controversy; dispute"}	\N
論文	ろんぶん	{}	{"thesis; essay; treatise; paper"}	\N
論理	ろんり	{}	{logic}	\N
差	さ	{}	{"difference; variation"}	\N
佐	さ	{}	{help}	\N
歳	さい	{}	{-years-old}	\N
差異	さい	{}	{"difference; disparity"}	\N
再	さい	{}	{"re-; again; repeated"}	\N
再会	さいかい	{}	{"another meeting; meeting again; reunion"}	\N
災害	さいがい	{地震・台風などの自然現象や事故・火事・伝染病などによって受ける思わぬわざわい。また、それによる被害。「不慮の―」「―に見舞われる」}	{"calamity; disaster; misfortune"}	\N
再稼動	さいかどう	{}	{"a restart; restarting"}	\N
再稼働	さいかどう	{}	{"a restart; restarting"}	\N
再起動	さいきどう	{コンピューターや周辺機器の使用を中止し、起動しなおすこと。リブート。リスタート。→ブート}	{"〔コンピュータで〕restart; reboot"}	\N
最強	さいきょう	{}	{strongest}	\N
最近	さいきん	{}	{recently}	\N
細菌	さいきん	{}	{"bacillus; bacterium; germ"}	\N
細工	さいく	{}	{"work; craftsmanship; tactics; trick"}	\N
採掘	さいくつ	{}	{mining}	\N
採決	さいけつ	{}	{"vote; roll call"}	\N
再建	さいけん	{}	{"rebuilding; reconstruction; rehabilitation"}	\N
再現	さいげん	{}	{"reappearance; reproduction; return; revival"}	\N
最後	さいご	{}	{"last time"}	\N
最高	さいこう	{}	{"highest; supreme; the most"}	\N
再三	さいさん	{}	{"again and again; repeatedly"}	\N
採算	さいさん	{}	{profit}	\N
祭司	さいし	{1.祭儀を執り行う者。2.ユダヤ教で、神殿に奉仕して儀式をつかさどる者。}	{"a [an officiating] priest"}	\N
妻子	さいし	{}	{"mother & child"}	\N
祭日	さいじつ	{}	{"national holiday; festival day"}	\N
採集	さいしゅう	{}	{"collecting; gathering"}	\N
最終	さいしゅう	{}	{"last; final; closing"}	\N
最初	さいしょ	{}	{"first time"}	\N
斎場	さいじょう	{神社、寺院などのある清浄な場所}	{"holy precincts"}	\N
再生	さいせい	{}	{"playback; regeneration; resuscitation; return to life; rebirth; reincarnation; narrow escape; reclamation; regrowth"}	\N
最善	さいぜん	{}	{"the very best"}	\N
催促	さいそく	{}	{"request; demand; claim; urge (action); press for"}	\N
最多	さいた	{一番大きい}	{most}	\N
採択	さいたく	{}	{"adoption; selection; choice"}	\N
最中	さいちゅう	{進行中のとき}	{"midst; in the middle of"}	\N
最低	さいてい	{}	{"least; lowest; worst; nasty; disgusting; horrible; yuck!"}	\N
最適	さいてき	{いちばん適していること。また、そのさま。「会計には彼が―だ」「スキーに―な雪質」}	{"optimum (most suitible)"}	\N
覚ます	さます	{}	{"awaken; disabuse; sober up"}	\N
清掃	せいそう	{}	{cleaning}	\N
際	さい	{}	{"edge; brink; verge; side"}	\N
六	ろく	{}	{six}	\N
最適化	さいてきか	{《optimization》システム工学などで、特定の目的に最適の計画・システムを設計すること。コンピューターでは、プログラムを特定の目的に最も効率的なように書き換えること。オプティマイズ。オプティマイゼーション。}	{optimization}	\N
採点	さいてん	{}	{"marking; grading; looking over"}	\N
災難	さいなん	{}	{"calamity; misfortune"}	\N
才能	さいのう	{}	{"talent; ability"}	\N
栽培	さいばい	{}	{cultivation}	\N
再発	さいはつ	{}	{"return; relapse; reoccurrence"}	\N
裁判	さいばん	{}	{"trial; judgement"}	\N
裁判所	さいばんしょ	{司法権を行使する国家機関。具体的事件について公権的な判断を下す権限をもつ。最高裁判所、および下級裁判所の高等・地方・家庭・簡易の各裁判所がある。}	{"a court (of law; of justice); a law court"}	\N
財布	さいふ	{}	{"purse; wallet"}	\N
裁縫	さいほう	{}	{sewing}	\N
細胞	さいぼう	{}	{"cell (biology)"}	\N
債務	さいむ	{}	{debt}	\N
採用	さいよう	{適当であると思われる人物・意見・方法などを、とり上げて用いること。}	{"adoption; employment"}	\N
幸い	さいわい	{その人にとって望ましく、ありがたいこと。また、そのさま。しあわせ。幸福。「不幸中の―」「君たちの未来に―あれと祈る」「御笑納いただければ―です」}	{"happiness; blessedness"}	\N
遮る	さえぎる	{}	{"to interrupt; to intercept; to obstruct"}	\N
坂	さか	{}	{"slope; hill"}	\N
境	さかい	{}	{"border; boundary; mental state"}	\N
栄える	さかえる	{}	{"to prosper; to flourish"}	\N
差額	さがく	{}	{"balance; difference; margin"}	\N
逆さ	さかさ	{}	{"reverse; inversion; upside down"}	\N
逆様	さかさま	{}	{"inversion; upside down"}	\N
捜す	さがす	{}	{"search; seek; look for"}	\N
探す	さがす	{}	{"search for; look for"}	\N
杯	さかずき	{}	{"wine cups"}	\N
逆立ち	さかだち	{}	{"handstand; headstand"}	\N
逆上る	さかのぼる	{}	{"to go back; to go upstream; to make retroactive"}	\N
遡る	さかのぼる	{}	{"go back; go upstream; make retroactive"}	\N
酒場	さかば	{}	{"bar; bar-room"}	\N
逆らう	さからう	{}	{"go against; oppose; disobey; defy"}	\N
盛り	さかり	{}	{"summit; peak; prime"}	\N
下がる	さがる	{}	{down}	\N
盛ん	さかん	{}	{prosperous}	\N
先	さき	{}	{"the future; forward; priority; precedence; former; previous; old; late"}	\N
詐欺	さぎ	{}	{"fraud; swindle"}	\N
一昨昨日	さきおととい	{}	{"two days before yesterday"}	\N
先に	さきに	{}	{"before; earlier than; ahead; beyond; away; previously; recently"}	\N
先程	さきほど	{}	{"some time ago"}	\N
作業	さぎょう	{}	{"work; operation; manufacturing; fatigue duty"}	\N
裂く	さく	{}	{"to tear; split"}	\N
策	さく	{}	{"plan; policy"}	\N
昨	さく	{}	{"last (year); yesterday"}	\N
作	さく	{}	{"a work; a harvest"}	\N
咲く	さく	{}	{"to bloom"}	\N
柵	さく	{}	{"fence; paling"}	\N
索引	さくいん	{}	{"index; indices"}	\N
削減	さくげん	{}	{"cut; reduction; curtailment"}	\N
錯誤	さくご	{}	{mistake}	\N
作者	さくしゃ	{}	{author}	\N
削除	さくじょ	{}	{"elimination; cancellation; deletion; erasure"}	\N
作成	さくせい	{}	{"frame; draw up; make; producing; creating; preparing; writing;"}	\N
作製	さくせい	{}	{manufacture}	\N
作戦	さくせん	{}	{"military or naval operations; tactics; strategy"}	\N
昨年	さくねん	{}	{"last year"}	\N
昨晩	さくばん	{きのうの晩。ゆうべ。昨夜。}	{"last night; yesterday evening"}	\N
作品	さくひん	{}	{"work; opus; performance; production"}	\N
作文	さくぶん	{}	{"composition; writing"}	\N
昨夜	さくや	{}	{"last night"}	\N
探る	さぐる	{}	{"search; look for; sound out"}	\N
作物	さくぶつ	{}	{"literary work"}	\N
下る	さがる	{}	{"hang down; abate; retire; fall; step back"}	\N
炸裂	さくれつ	{着弾した砲弾などがはげしく爆発すること。「榴弾(りゅうだん)が―する」}	{"(an) explosion; 炸裂する explode; go off"}	\N
酒	さけ	{}	{"alcohol; sake"}	\N
叫び	さけび	{}	{"shout; scream; outcry"}	\N
叫ぶ	さけぶ	{}	{"shout; cry out"}	\N
裂ける	さける	{}	{"to split; to tear; to burst"}	\N
避ける	さける	{}	{"avoid (situation); ward off; to avert"}	\N
下げる	さげる	{}	{"hang; let down"}	\N
些細	ささい	{あまり重要ではないさま。取るに足らないさま。「ーなことを気にする」}	{"〜な trifling; trivial"}	\N
支える	ささえる	{}	{"support; prop up"}	\N
査察	ささつ	{状況を視察すること。物事が規定どおり行われているかどうかを調べること。「上空から両国の緩衝地帯を―する」}	{"(an) inspection (e.g. of a factory)"}	\N
刺さる	ささる	{}	{"stick; be stuck"}	\N
些事	さじ	{}	{"something small or petty; trifle"}	\N
差し上げる	さしあげる	{}	{give}	\N
差し掛かる	さしかかる	{}	{"to come near to; to approach"}	\N
指図	さしず	{}	{"instruction; mandate"}	\N
差し出す	さしだす	{}	{"to present; to submit; to tender; to hold out"}	\N
差出人	さしだしにん	{郵便物などの発送者。}	{"the sender; 〔為替の〕the remitter"}	\N
差し出し人	さしだしにん	{郵便物などの発送者。}	{"the sender; 〔為替の〕the remitter"}	\N
差し支え	さしつかえ	{}	{"hindrance; impediment"}	\N
差し支える	さしつかえる	{}	{"to interfere; to hinder; to become impeded"}	\N
差し引き	さしひき	{}	{"deduction; subtraction; balance; ebb and flow; rise and fall"}	\N
差し引く	さしひく	{}	{"to deduct"}	\N
刺身	さしみ	{}	{"sliced raw fish"}	\N
注す	さす	{}	{"pour or serve (drinks)"}	\N
刺す	さす	{}	{"pierce; stab; prick; thrust; bite; sting; pin down"}	\N
差す	さす	{}	{"raise (stretch out) hands; to raise umbrella"}	\N
指す	さす	{}	{"to point; put up umbrella; to play"}	\N
挿す	さす	{}	{"to insert; put in; graft"}	\N
射す	さす	{}	{"to shine; to strike"}	\N
授ける	さずける	{}	{"to grant; to award; to teach"}	\N
させていただく	させていただく	{相手に許しを請うことによって、ある動作を遠慮しながら行う意を表す。「私が司会を―・きます」}	{"will do (on partners permission)"}	\N
誘う	さそう	{}	{"invite; call out"}	\N
定まる	さだまる	{}	{"to become settled; to be fixed"}	\N
定める	さだめる	{}	{"to decide; to establish; to determine"}	\N
札	さつ	{}	{"paper money"}	\N
冊	さつ	{}	{"counter for books"}	\N
撮影	さつえい	{}	{photographing}	\N
作家	さっか	{}	{"author; writer; novelist; artist"}	\N
錯覚	さっかく	{}	{"optical illusion; hallucination"}	\N
擦過傷	さっかしょう	{}	{abrasion}	\N
早急	さっきゅう	{}	{urgent}	\N
作曲	さっきょく	{}	{"composition; setting (of music)"}	\N
殺人	さつじん	{}	{murder}	\N
察する	さっする	{}	{"to guess; to sense; to presume; to judge; to sympathize with"}	\N
早速	さっそく	{}	{"at once; immediately; without delay; promptly"}	\N
砂糖	さとう	{}	{sugar}	\N
悟る	さとる	{}	{"to attain enlightenment; to perceive; to understand; to discern"}	\N
真実	さな	{}	{"truth; reality"}	\N
砂漠	さばく	{}	{desert}	\N
裁く	さばく	{}	{"to judge"}	\N
寂しい	さびしい	{}	{lonely}	\N
差別	さべつ	{}	{"discrimination; distinction; differentiation"}	\N
作法	さほう	{}	{"manners; etiquette; propriety"}	\N
左程	さほど	{}	{"(not) very; (not) much"}	\N
様々	さまざま	{}	{"varied; various"}	\N
冷ます	さます	{}	{"cool; dampen; let cool; throw a damper on; spoil"}	\N
妨げる	さまたげる	{}	{"disturb; prevent"}	\N
三味線	さみせん	{}	{"three-stringed Japanese guitar; shamisen"}	\N
寒い	さむい	{}	{"cold (e.g. weather)"}	\N
侍	さむらい	{}	{"Samurai; warrior"}	\N
覚める	さめる	{}	{"wake; wake up"}	\N
冷める	さめる	{}	{"become cool; wear off; abate; subside; dampen"}	\N
然も	さも	{}	{"with gusto; with satisfaction"}	\N
左右	さゆう	{}	{"left and right; influence; control; domination"}	\N
作用	さよう	{}	{"action; operation; effect; function"}	\N
左様なら	さようなら	{}	{good-bye}	\N
皿	さら	{}	{"plate; dish"}	\N
再来月	さらいげつ	{}	{"month after next"}	\N
さ来月	さらいげつ	{}	{"the month after next"}	\N
再来週	さらいしゅう	{}	{"week after next"}	\N
さ来週	さらいしゅう	{}	{"the week after next"}	\N
再来年	さらいねん	{}	{"year after next"}	\N
拐う	さらう	{}	{"to carry off; to run away with; to kidnap; to abduct"}	\N
更紗	さらさ	{インド起源の木綿地の文様染め製品、及び、その影響を受けてアジア、ヨーロッパなどで製作された類似の文様染め製品を指す染織工芸用語。}	{"Chintz; glazed calico textiles; designs featuring flowers and other patterns in different colours"}	\N
更に	さらに	{}	{"furthermore; again; after all; more and more; moreover"}	\N
去る	さる	{}	{"leave; go away"}	\N
沢	さわ	{浅く水がたまり、草が生えている湿地。}	{"a swamp"}	\N
騒がしい	さわがしい	{}	{noisy}	\N
騒ぎ	さわぎ	{}	{"uproar; disturbance"}	\N
騒ぐ	さわぐ	{}	{"make a noise"}	\N
爽やか	さわやか	{}	{"fresh; refreshing; invigorating; clear; fluent; eloquent"}	\N
障る	さわる	{}	{"to hinder; to interfere with; to affect; to do one harm; to be harmful to"}	\N
触る	さわる	{}	{touch}	\N
酸	さん	{}	{acid}	\N
酸化	さんか	{}	{oxidation}	\N
参加	さんか	{ある目的をもつ集まりに一員として加わり、行動をともにすること。}	{participation}	\N
三角	さんかく	{}	{"triangle; triangular"}	\N
山岳	さんがく	{}	{mountains}	\N
三月	さんがつ	{}	{March}	\N
参観	さんかん	{その場所に行って、見ること。「授業を―する」}	{"a visit"}	\N
参議院	さんぎいん	{}	{"House of Councillors"}	\N
産休	さんきゅう	{}	{"maternity leave"}	\N
産業	さんぎょう	{}	{industry}	\N
産後	さんご	{}	{"postpartum; after childbirth"}	\N
参考	さんこう	{}	{"reference; consultation"}	\N
参考書	さんこうしょ	{調査・研究・教授・学習などの際に参考とする書物。「受験―」}	{"reference book"}	\N
散在	さんざい	{あちこちに散らばってあること。点在。「湖畔に―する別荘」}	{scattered}	\N
産出	さんしゅつ	{}	{"yield; produce"}	\N
算出	さんしゅつ	{計算して数値を出すこと。「必要経費を―する」}	{"calculation; computation"}	\N
参照	さんしょう	{}	{"reference; consultation; consultation"}	\N
参上	さんじょう	{}	{"calling on; visiting"}	\N
算数	さんすう	{}	{arithmetic}	\N
賛成	さんせい	{人の意見や行動をよいと認めて、それに同意すること。「原案に―する」⇔反対。}	{"approval; agreement; support; favour"}	\N
酸性	さんせい	{}	{acidity}	\N
酸素	さんそ	{}	{oxygen}	\N
産地	さんち	{}	{"producing area"}	\N
賛美	さんび	{}	{"praise; adoration; glorification"}	\N
山腹	さんぷく	{}	{"hillside; mountainside"}	\N
産婦人科	さんふじんか	{}	{"maternity and gynecology department"}	\N
産物	さんぶつ	{}	{"product; result; fruit"}	\N
散歩	さんぽ	{}	{"walk; stroll"}	\N
三	さん	{}	{three}	\N
桟橋	さんきょう	{}	{"wharf; bridge; jetty; pier"}	\N
山脈	さんみゃく	{}	{"mountain range"}	\N
山林	さんりん	{}	{"mountain forest; mountains and forest"}	\N
三塁	さんるい	{}	{"third base"}	\N
瀬	せ	{}	{rapids}	\N
正	せい	{}	{"(logical) true; regular"}	\N
制	せい	{}	{"system; organization; imperial command; laws; regulation; control; government; suppression; restraint; holding back; establishment"}	\N
製	せい	{}	{"-made; make"}	\N
所為	せい	{}	{"act; deed; one´s doing"}	\N
姓	せい	{}	{"surname; family name"}	\N
性	せい	{}	{"sex; gender"}	\N
生育	せいいく	{}	{"growth; development; breeding"}	\N
征夷大将軍	せいいたいしょうぐん	{}	{shogun}	\N
精液	せいえき	{}	{semen}	\N
成果	せいか	{あることをして得られたよい結果。}	{Achievement}	\N
正解	せいかい	{}	{"correct; right; correct interpretation (answer solution)"}	\N
制海権	せいかいけん	{}	{"control of the seas"}	\N
性格	せいかく	{}	{"character; personality"}	\N
正確	せいかく	{}	{"accurate; punctual; exact; authentic; veracious"}	\N
生活	せいかつ	{}	{"living; life (one´s daily existence); livelihood"}	\N
生活必需品	せいかつひつじゅひん	{生活していくうえで欠かすことのできない品。食品・衣類・洗剤・燃料など。}	{"necessities of life; daily necessities [essentials]"}	\N
世紀	せいき	{}	{"century; era"}	\N
正規	せいき	{}	{"regular; legal; formal; established; legitimate"}	\N
正義	せいぎ	{}	{"justice; right; righteousness; correct meaning"}	\N
請求	せいきゅう	{}	{"claim; demand; application; request"}	\N
請求書	せいきゅうしょ	{物品や代金の支払いなどを請求するために出す文書。}	{invoice}	\N
生計	せいけい	{}	{"livelihood; living"}	\N
清潔	せいけつ	{}	{clean}	\N
政権	せいけん	{}	{"administration; political power"}	\N
制限	せいげん	{}	{"restriction; restraint; limitation"}	\N
成功	せいこう	{物事を目的どおりに成し遂げること。「失敗はーの母」「新規事業がーをおさめる」「実験にーする」}	{"success; hit"}	\N
精巧	せいこう	{}	{"elaborate; delicate; exquisite"}	\N
星座	せいざ	{}	{constellation}	\N
制裁	せいさい	{}	{"restraint; sanctions; punishment"}	\N
政策	せいさく	{}	{"political measures; policy"}	\N
制作	せいさく	{}	{"work (film; book)"}	\N
製作	せいさく	{}	{"manufacture; production"}	\N
清算	せいさん	{}	{"liquidation; settlement"}	\N
生産	せいさん	{}	{"production; manufacture"}	\N
静止	せいし	{}	{"stillness; repose; standing still"}	\N
生死	せいし	{}	{"life and death"}	\N
政治	せいじ	{}	{politic}	\N
政治家	せいじか	{}	{politician}	\N
正式	せいしき	{}	{"due form; official; formality"}	\N
制式	せいしき	{きめられた様式。きまり。}	{formality}	\N
性質	せいしつ	{}	{"nature; property; disposition"}	\N
誠実	せいじつ	{}	{"sincere; honest; faithful"}	\N
成熟	せいじゅく	{}	{"maturity; ripeness"}	\N
青春	せいしゅん	{}	{"youth; springtime of life; adolescent"}	\N
清純	せいじゅん	{}	{"purity; innocence"}	\N
聖書	せいしょ	{}	{"Bible; scriptures"}	\N
清書	せいしょ	{}	{"clean copy"}	\N
正常	せいじょう	{}	{"normalcy; normality; normal"}	\N
青少年	せいしょうねん	{}	{"youth; young person"}	\N
精神	せいしん	{}	{"mind; soul; heart; spirit; intention"}	\N
成人	せいじん	{}	{adult}	\N
整数	せいすう	{}	{integer}	\N
制する	せいする	{}	{"to control; to command; to get the better of"}	\N
精々	せいぜい	{}	{"at the most; at best; to the utmost; as much (far) as possible"}	\N
成績	せいせき	{}	{"results; record"}	\N
整然	せいぜん	{}	{"orderly; regular; well-organized; trim; accurate"}	\N
盛装	せいそう	{}	{"be dressed up; wear rich clothes"}	\N
背	せい	{}	{"height; stature"}	\N
背	せ	{}	{"height; stature"}	\N
精巣	せいそう	{}	{testicle}	\N
製造	せいぞう	{}	{"manufacture; production"}	\N
生存	せいぞん	{}	{"existence; being; survival"}	\N
盛大	せいだい	{}	{"grand; prosperous; magnificent"}	\N
清濁	せいだく	{}	{"good and evil; purity and impurity"}	\N
成長	せいちょう	{}	{"growth; grow to adulthood"}	\N
生長	せいちょう	{}	{"growth; increment"}	\N
制定	せいてい	{}	{"enactment; establishment; creation"}	\N
静的	せいてき	{}	{static}	\N
製鉄	せいてつ	{}	{"iron manufacture"}	\N
晴天	せいてん	{}	{"fine weather"}	\N
生徒	せいと	{}	{pupil}	\N
制度	せいど	{}	{"system; institution; organization"}	\N
正当	せいとう	{}	{"just; justifiable; right; due; proper; equitable; reasonable; legitimate; lawful"}	\N
政党	せいとう	{}	{"(member of) political party"}	\N
成年	せいねん	{}	{"majority; adult age"}	\N
青年	せいねん	{}	{"youth; young man"}	\N
生年月日	せいねんがっぴ	{}	{"birth date"}	\N
性能	せいのう	{}	{"ability; efficiency"}	\N
制覇	せいは	{}	{"domination; mastery; conquest"}	\N
整備	せいび	{}	{"adjustment; completion; consolidation"}	\N
製品	せいひん	{}	{"manufactured goods"}	\N
政府	せいふ	{政治を行う所。立法・司法・行政のすべての作用を包含する、国家の統治機構の総称。日本では、内閣および内閣の統轄する行政機構をさす。内閣。}	{"government; administration"}	\N
制服	せいふく	{}	{uniform}	\N
征服	せいふく	{}	{"conquest; subjugation; overcoming"}	\N
生物	せいぶつ	{}	{"living things; creature"}	\N
成分	せいぶん	{}	{"ingredient; component; composition"}	\N
性別	せいべつ	{}	{"distinction by sex; sex; gender"}	\N
製法	せいほう	{}	{"manufacturing method; recipe; formula"}	\N
正方形	せいほうけい	{}	{square}	\N
精密	せいみつ	{}	{"precise; exact; detailed; minute; close"}	\N
声明	せいめい	{}	{"declaration; statement; proclamation"}	\N
姓名	せいめい	{}	{"full name"}	\N
生命	せいめい	{}	{"life; existence"}	\N
正門	せいもん	{}	{"main gate; main entrance"}	\N
制約	せいやく	{}	{"limitation; restriction; condition; constraints"}	\N
西洋	せいよう	{}	{"West; Western countries"}	\N
生理	せいり	{}	{"physiology; menses"}	\N
整理	せいり	{}	{"sorting; arrangement; adjustment; regulation"}	\N
成立	せいりつ	{}	{"coming into existence; arrangements; establishment; completion"}	\N
勢力	せいりょく	{}	{"influence; power; might; strength; potency; force; energy"}	\N
精霊	せいれい	{}	{"spirit; ghost; soul"}	\N
西暦	せいれき	{}	{"Christian Era; Anno Domini (A.D.)"}	\N
整列	せいれつ	{}	{"stand in a row; form a line"}	\N
世界	せかい	{}	{world}	\N
急かす	せかす	{}	{"to hurry; to urge on"}	\N
席	せき	{}	{seat}	\N
積	せき	{}	{"〔数学で〕the product"}	\N
隻	せき	{比較的大きい船を数えるのに用いる。「駆逐艦二―」}	{vessels}	\N
石炭	せきたん	{}	{coal}	\N
赤道	せきどう	{}	{equator}	\N
責任	せきにん	{}	{"duty; responsibility"}	\N
責務	せきむ	{}	{"duty; obligation"}	\N
石油	せきゆ	{}	{"oil; petroleum; kerosene"}	\N
世間	せけん	{}	{"world; society"}	\N
世辞	せじ	{}	{"flattery; compliment"}	\N
世帯	せたい	{住居および生計を同じくする者の集まり。所帯。「一―当たりの収入」}	{"household〔家族〕a family"}	\N
世代	せだい	{}	{"generation; the world; the age"}	\N
背丈	せたけ	{かかとから頭頂までの背の高さ。身長。}	{"〔身長〕height; ((文)) stature⇒しんちょう(身長)"}	\N
説	せつ	{}	{theory}	\N
切開	せっかい	{}	{"clearing (land); opening up; cutting through"}	\N
石灰岩	せっかいがん	{}	{limestone}	\N
折角	せっかく	{}	{"with trouble; at great pains; long-awaited"}	\N
赤色	せきしょく	{}	{red}	\N
節	せつ	{}	{"node; section; occasion; time"}	\N
石棺	せっかん	{}	{sarcophagus}	\N
積極的	せっきょくてき	{}	{"positive; active; proactive"}	\N
接近	せっきん	{}	{"getting closer; approaching"}	\N
設計	せっけい	{建造物の工事、機械の製造などに際し、対象物の構造・材料・製作法などの計画を図面に表すこと。「ビルを―する」}	{"plan; design"}	\N
石鹸	せっけん	{}	{soap}	\N
摂氏	せっし	{}	{celsius}	\N
切実	せつじつ	{}	{"compelling; serious; severe; acute; earnest; pressing; urgent"}	\N
摂取	せっしゅ	{}	{ingestion}	\N
雪辱	せつじょく	{}	{"revenge; vindication of honor; making up for a loss"}	\N
接触	せっしょく	{}	{"touch; contact"}	\N
接する	せっする	{}	{"come in contact with; connect; attend; receive"}	\N
拙速	せっそく	{できはよくないが、仕事が早いこと。また、そのさま。「―に事を運ぶ」⇔巧遅 (こうち) }	{"hasty; more haste than caution"}	\N
接続	せつぞく	{}	{"connection; union; join; link; changing trains"}	\N
接続詞	せつぞくし	{}	{conjunction}	\N
設置	せっち	{}	{"establishment; institution"}	\N
折衷	せっちゅう	{いくつかの異なった考え方のよいところをとり合わせて、一つにまとめ上げること。「両者の意見を―する」「和洋―」「―案」}	{"compromise; cross; blending; eclecticism"}	\N
折中	せっちゅう	{いくつかの異なった考え方のよいところをとり合わせて、一つにまとめ上げること。「両者の意見を―する」「和洋―」「―案」}	{"compromise; cross; blending; eclecticism"}	\N
設定	せってい	{}	{"establishment; creation"}	\N
窃盗	せっとう	{盗難}	{theft}	\N
説得	せっとく	{}	{persuasion}	\N
切ない	せつない	{}	{"painful; trying; oppressive; suffocating"}	\N
設備	せつび	{}	{"equipment; device; facilities; installation"}	\N
切腹	せっぷく・はらきり	{}	{"ritual suicide"}	\N
説明	せつめい	{ある事柄が、よくわかるように述べること。「ーを求める」「科学ではーのつかない現象」「事情をーする」}	{explanation}	\N
節約	せつやく	{}	{"economising; saving"}	\N
設立	せつりつ	{}	{"establishment; foundation; institution"}	\N
瀬戸物	せともの	{}	{"earthenware; crockery; china"}	\N
背中	せなか	{}	{back}	\N
背広	せびろ	{}	{"business suit"}	\N
狭い	せまい	{}	{"narrow; confined; small"}	\N
迫る	せまる	{}	{"draw near; press"}	\N
攻め	せめ	{}	{"attack; offence"}	\N
攻める	せめる	{}	{"attack; assault"}	\N
責める	せめる	{}	{"condemn; blame; criticize"}	\N
世論	せろん	{}	{"public opinion"}	\N
世話	せわ	{}	{"take care of"}	\N
千	せん	{}	{"thousand; many"}	\N
栓	せん	{}	{"stopper; cork"}	\N
仙	せん	{}	{"hermit; wizard"}	\N
線	せん	{}	{line}	\N
繊維	せんい	{細い糸状の物質。}	{"fibre; fiber"}	\N
選挙	せんきょ	{}	{election}	\N
宣教	せんきょう	{}	{"religious mission"}	\N
先月	せんげつ	{}	{"last month"}	\N
宣言	せんげん	{個人・団体・国家などが、意見・方針などを外部に表明すること。また、その内容。「国家の独立をーする」}	{"declaration; proclamation; announcement"}	\N
専攻	せんこう	{}	{"major subject; special study"}	\N
先行	せんこう	{}	{"preceding; going first"}	\N
選考	せんこう	{能力・人柄などをよく調べて適格者を選び出すこと。「受賞者を―する」「書類―」}	{"selection; screening"}	\N
線香	せんこう	{}	{incense}	\N
戦災	せんさい	{}	{"war damage"}	\N
洗剤	せんざい	{}	{"detergent; washing material"}	\N
遷徙	せんし	{ある場所を抜け出て他の所へうつること｡また､うつすこと｡}	{"(animal emigration from a land)"}	\N
先日	せんじつ	{}	{"the other day; a few days ago"}	\N
選手	せんしゅ	{}	{"player (in game); team"}	\N
専修	せんしゅう	{}	{specialization}	\N
先週	せんしゅう	{}	{"last week; the week before"}	\N
戦術	せんじゅつ	{}	{tactics}	\N
洗浄	せんじょう	{}	{"washing; cleaning; laundering"}	\N
扇子	せんす	{}	{"folding fan"}	\N
潜水	せんすい	{}	{diving}	\N
専制	せんせい	{}	{"despotism; autocracy"}	\N
先生	せんせい	{}	{"teacher; master; doctor"}	\N
先々月	せんせんげつ	{}	{"month before last"}	\N
先々週	せんせんしゅう	{}	{"week before last"}	\N
先祖	せんぞ	{}	{ancestor}	\N
戦争	せんそう	{}	{war}	\N
先代	せんだい	{}	{"family predecessor; previous age; previous generation"}	\N
洗濯	せんたく	{}	{"washing; laundry"}	\N
選択	せんたく	{}	{"selection; choice"}	\N
選択肢	せんたくし	{}	{choices}	\N
先だって	せんだって	{}	{"recently; the other day"}	\N
先端	せんたん	{}	{"pointed end; tip; fine point; spearhead; cusp; vanguard; advanced; leading edge"}	\N
先着	せんちゃく	{}	{"first arrival"}	\N
船長	せんちょう	{船舶の乗組員の長。船舶の指揮者として法律上の職務・権限や義務をもち、乗組員を監督する者。キャプテン。}	{captain}	\N
宣伝	せんでん	{}	{"propaganda; publicity"}	\N
先天的	せんてんてき	{}	{"a priori; inborn; innate; inherent; congenital; hereditary"}	\N
先頭	せんとう	{}	{"head; lead; vanguard; first"}	\N
戦闘	せんとう	{}	{"battle; fight; combat"}	\N
銭湯	せんとう	{入浴料を取って一般の人を入浴させる浴場。ふろや。ゆや。公衆浴場。}	{"a public bath"}	\N
潜入	せんにゅう	{こっそりと入り込むこと。忍び込むこと。「敵地にーする」}	{"infiltration; sneaking in"}	\N
栓抜き	せんぬき	{瓶の王冠やコルク栓などを抜き取る道具。}	{"bottle opener"}	\N
先輩	せんぱい	{}	{"one´s senior"}	\N
船舶	せんぱく	{}	{ship}	\N
旋風	せんぷう	{}	{"〔つむじ風〕a whirlwind"}	\N
扇風機	せんぷうき	{}	{"electric fan"}	\N
先鋒	せんぽう	{戦闘の際、部隊の先頭に立って進むもの。さきて。「―隊」}	{"the vanguard; the van"}	\N
戦没	せんぼつ	{}	{"death in battle; killed in action"}	\N
洗面	せんめん	{顔を洗うこと。洗顔。}	{"face wash"}	\N
洗面台	せんめんだい	{}	{"wash basin (stand)"}	\N
専門	せんもん	{}	{"expert; speciality"}	\N
専門家	せんもんか	{ある特定の学問・事柄を専門に研究・担当して、それに精通している人。エキスパート。「経済の―」}	{"a specialist; a professional; 〔特に，熟練した〕an expert ((in))"}	\N
専門学校	せんもんがっこう	{}	{"Vocational school (yrkesskola; fackskola)"}	\N
専用	せんよう	{}	{"exclusive use; personal use"}	\N
占領	せんりょう	{}	{"occupation; capture; possession; have a room to oneself"}	\N
戦力	せんりょく	{}	{"war potential"}	\N
線路	せんろ	{}	{"line; track; roadbed"}	\N
詩	し	{}	{"poem; verse of poetry"}	\N
死	し	{}	{"death; decease"}	\N
試合	しあい	{}	{game}	\N
仕上がり	しあがり	{}	{"finish; end; completion"}	\N
仕上がる	しあがる	{}	{"be finished"}	\N
仕上げ	しあげ	{}	{"end; finishing touches; being finished"}	\N
仕上げる	しあげる	{}	{"to finish up; to complete"}	\N
明々後日	しあさって	{}	{"two days after tomorrow"}	\N
幸せ	しあわせ	{}	{"happiness; good fortune; luck; blessing"}	\N
飼育	しいく	{}	{"breeding; raising; rearing"}	\N
強いて	しいて	{}	{"by force"}	\N
強いる	しいる	{}	{"to force; to compel; to coerce"}	\N
仕入れる	しいれる	{}	{"to lay in stock; to replenish stock; to procure"}	\N
ジェット機	ジェットき	{}	{"jet airplane"}	\N
塩辛い	しおからい	{}	{"salty (flavor)"}	\N
歯科	しか	{}	{dentistry}	\N
司会	しかい	{}	{chairmanship}	\N
視界	しかい	{目で見通すことのできる範囲。視野。「濃霧でーがきかない」}	{"the field of vision; visibility"}	\N
市街	しがい	{}	{"urban areas; the streets; town; city"}	\N
四角	しかく	{}	{square}	\N
資格	しかく	{}	{"qualifications; requirements; capabilities"}	\N
視覚	しかく	{}	{"sense of sight; vision"}	\N
四角い	しかくい	{}	{square}	\N
仕掛け	しかけ	{}	{"device; trick; mechanism; gadget; (small) scale; half finished; commencement; set up; challenge"}	\N
仕掛ける	しかける	{}	{"to commence; to lay (mines); to set (traps); to wage (war); to challenge"}	\N
然しながら	しかしながら	{}	{"nevertheless; however"}	\N
如かず	しかず	{及ばない。かなわない。「百聞は一見に―◦ず」}	{"fall short; can not compete;"}	\N
仕方	しかた	{}	{"method; way"}	\N
仕方が無い	しかたがない	{どうすることもできない。ほかによい方法がない。やむを得ない。「ー・い。それでやるか」}	{"nothing to do about it; can not be avoided/helped;"}	\N
四月	しがつ	{}	{April}	\N
叱る	しかる	{}	{scold}	\N
四季	しき	{}	{"four seasons"}	\N
式	しき	{}	{"equation; formula; ceremony"}	\N
指揮	しき	{}	{"command; direction"}	\N
敷金	しききん	{不動産、特に家屋の賃貸借にさいして賃料などの債務の担保にする目的で、賃借人が賃貸人に預けておく保証金。しきがね。}	{"a deposit"}	\N
色彩	しきさい	{}	{"colour; hue; tints"}	\N
式場	しきじょう	{}	{"ceremonial hall; place of ceremony (e.g. marriage)"}	\N
為来り	しきたり	{}	{customs}	\N
敷地	しきち	{}	{site}	\N
式典	しきてん	{}	{"ceremony; rites"}	\N
支給	しきゅう	{}	{"payment; allowance"}	\N
至急	しきゅう	{非常に急ぐこと}	{urgent}	\N
至急お越し	至急お越し	{急いで来て}	{"come ASAP"}	\N
施行	しぎょう	{}	{"execution; enforcing; carrying out"}	\N
仕切る	しきる	{}	{"to partition; to divide; to mark off; to settle accounts; to toe the mark"}	\N
資金	しきん	{}	{"funds; capital"}	\N
敷く	しく	{}	{"spread out; to lay out; take a position"}	\N
仕組み	しくみ	{}	{"devising; plan; plot; contrivance; construction; arrangement"}	\N
死刑	しけい	{}	{"death penalty; capital punishment"}	\N
死刑囚	しけいしゅう	{}	{"condemned; criminal condemned to death"}	\N
刺激	しげき	{}	{"stimulus; impetus; incentive; excitement; irritation; encouragement; motivation"}	\N
茂み	しげみ	{草木の生い茂っている所。「葦 (あし) の―」}	{"〔低木の茂ったところ〕a thicket; 〔丈の低い下生え〕bushes"}	\N
繁み	しげみ	{草木の生い茂っている所。「葦 (あし) の―」}	{"〔低木の茂ったところ〕a thicket; 〔丈の低い下生え〕bushes"}	\N
湿気る	しける	{}	{"to be damp; to be moist"}	\N
茂る	しげる	{}	{"grow thick; luxuriate; be luxurious"}	\N
試験	しけん	{}	{examination}	\N
資源	しげん	{}	{resources}	\N
嗜好	しこう	{}	{"taste; liking; preference"}	\N
志向	しこう	{}	{"intention; aim"}	\N
思考	しこう	{}	{thought}	\N
思考力	しこうりょく	{}	{"thinking power"}	\N
仕事	しごと	{}	{"work; occupation; employment"}	\N
示唆	しさ	{《「じさ」とも》それとなく知らせること。ほのめかすこと。「ーに富む談話」「法改正の可能性をーする」}	{"〔提言〕(a) suggestion; 〔暗示〕a hint"}	\N
施策	しさく	{政策・対策を立てて、それを実地に行うこと。政治などを行うに際して実地にとる策。}	{"〔政策〕a policy; 〔処置〕a measure"}	\N
視察	しさつ	{}	{"inspection; observation"}	\N
刺殺	しさつ	{さしころすこと。野球で、野手が、飛球を捕らえたり、送球を受けたり、走者にタッチしたりして、打者または走者をアウトにすること。プットアウト。→補殺「銃剣で―する」}	{stabbing}	\N
資産	しさん	{}	{"property; fortune; means; assets"}	\N
志士	しし	{高い志を持った人}	{loyalist}	\N
指示	しじ	{}	{"indication; instruction; directions"}	\N
支持	しじ	{}	{"support; maintenance"}	\N
脂質	ししつ	{}	{Lipid}	\N
四捨五入	ししゃごにゅう	{}	{"rounding up (especially fractions)"}	\N
刺繍	ししゅう	{}	{embroidery}	\N
始終	しじゅう	{}	{"continuously; from beginning to end"}	\N
支出	ししゅつ	{}	{"expenditure; expenses"}	\N
師匠	ししょう	{学問または武術・芸術の師。先生。}	{"a teacher; 〔芸術の巨匠など〕a master"}	\N
史上	しじょう	{歴史に現れているところ。歴史上。「―空前の惨事」}	{"in history; from a historical point of view"}	\N
詩人	しじん	{}	{poet}	\N
静か	しずか	{}	{"quiet; peaceful"}	\N
静まる	しずまる	{}	{"calm down; subside; die down; abate; be suppressed"}	\N
沈む	しずむ	{}	{"sink; feel depressed"}	\N
沈める	しずめる	{}	{"to sink; to submerge"}	\N
鎮める	しずめる	{物音や声を小さくさせる。静かにさせる。「場内をー・める」「鳴りをー・める」}	{"to quiet; to calm; to appease"}	\N
姿勢	しせい	{からだの構え方。また、構え。かっこう。「楽なーで話を聞く」}	{"attitude; posture"}	\N
死生	しせい	{死ぬことと生きること。死ぬか生きるか。生死。ししょう。「日本人の―観」}	{"life and death"}	\N
施設	しせつ	{}	{"institution; establishment; facility; (army) engineer"}	\N
自然	しぜん	{}	{"nature; spontaneous"}	\N
自然科学	しぜんかがく	{}	{"natural science"}	\N
思想	しそう	{}	{"thought; idea; ideology"}	\N
子息	しそく	{}	{son}	\N
子孫	しそん	{}	{"descendants; posterity; offspring"}	\N
舌	した	{}	{tongue}	\N
死体	したい	{}	{corpse}	\N
次第	しだい	{}	{"order; precedence; circumstances; immediate(ly); as soon as; dependent upon"}	\N
慕う	したう	{}	{"to yearn for; to miss; to adore; to love dearly"}	\N
従う	したがう	{後ろについて行く。あとに続く。「案内人に―・う」「前を行く人に―・って歩く」}	{"〔服従する〕obey; follow; 〔甘受する〕abide by; accompany"}	\N
随う	したがう	{"目上の人のあとについて行動する。偉い人に随行する という意味。「社長に―ってパリへ行く」"}	{"〔服従する〕obey; follow; 〔甘受する〕abide by; accompany"}	\N
順う	したがう	{言うことを聞く。}	{"obey (a command); follow (an order)"}	\N
遵う	したがう	{道理や法則にしたがう。のっとる。法的対象にしたがう。「遵守」}	{"follow (the law; legal system)"}	\N
下書き	したがき	{}	{"rough copy; draft"}	\N
下着	したぎ	{}	{underwear}	\N
支度	したく	{}	{preparation}	\N
下心	したごころ	{}	{"secret intention; motive"}	\N
下地	したじ	{}	{"groundwork; foundation; inclination; aptitude; elementary knowledge of; grounding in; prearrangement; spadework; signs; symptoms; first coat of plastering; soy"}	\N
親しい	したしい	{}	{"intimate; close"}	\N
親しむ	したしむ	{}	{"to be intimate with; to befriend"}	\N
下調べ	したしらべ	{}	{"preliminary investigation; preparation"}	\N
仕立てる	したてる	{}	{"to tailor; to make; to prepare; to train; to send (a messenger)"}	\N
下取り	したどり	{}	{"trade in; part exchange"}	\N
下火	したび	{}	{"burning low; waning; declining"}	\N
下町	したまち	{}	{"Shitamachi; lower parts of town"}	\N
七	しち	{}	{seven}	\N
七月	しちがつ	{}	{July}	\N
室	しつ	{}	{room}	\N
質	しつ	{}	{quality}	\N
失格	しっかく	{}	{"disqualification; elimination; incapacity (legal)"}	\N
確り	しっかり	{}	{"firmly; tightly; reliable; level-headed; steady"}	\N
疾患	しっかん	{}	{"disease; ailment"}	\N
質疑	しつぎ	{}	{question}	\N
失業	しつぎょう	{}	{unemployment}	\N
湿気	しっけ	{物や空気の中に含まれている水分。水気・モイスチャー}	{"get damp; get soggy"}	\N
仕付ける	しつける	{}	{"to be used to a job; to begin to do; to baste; to tack; to plant"}	\N
湿原	しつげん	{低温で多湿な所に発達した草原。}	{"((米)) a moor; ((英)) a bog; a fen"}	\N
執行	しっこう	{とりおこなうこと。実際に行うこと。「職務を―する」}	{execution}	\N
執行部	しっこうぶ	{}	{"executive office"}	\N
質素	しっそ	{}	{"simplicity; modesty; frugality"}	\N
失着	しっちゃく	{囲碁で、まちがった手を打つこと。また転じて、しくじり。}	{"failure; ⇒しっぱい(失敗)"}	\N
失調	しっちょう	{}	{"lack of harmony"}	\N
嫉妬	しっと	{}	{jealousy}	\N
湿度	しつど	{}	{"level of humidity"}	\N
失敗	しっぱい	{}	{"failure; fail"}	\N
執筆	しっぴつ	{}	{writing}	\N
疾風	しっぷう	{}	{"a gale; a strong wind; 〔気象用語〕a fresh breeze"}	\N
疾風迅雷	しっぷうじんらい	{}	{"buller och bong"}	\N
尻尾	しっぽ	{}	{"tail (animal)"}	\N
失望	しつぼう	{}	{"disappointment; despair"}	\N
質問	しつもん	{}	{"question; inquiry"}	\N
失礼	しつれい	{他人に接する際の心得をわきまえていないこと。礼儀に欠けること。また、そのさま。失敬。「―なやつ」「先日は―しました」}	{"〔無礼〕impoliteness; rudeness; bad manners"}	\N
失恋	しつれん	{}	{"disappointed love; broken heart; unrequited love; be lovelorn;"}	\N
指定	してい	{}	{"designation; specification; assignment; pointing at"}	\N
指摘	してき	{}	{"pointing out; identification"}	\N
私鉄	してつ	{}	{"private railway"}	\N
視点	してん	{}	{"opinion; point of view; visual point"}	\N
支店	してん	{}	{"branch store (office)"}	\N
指導	しどう	{}	{"leadership; guidance; coaching"}	\N
萎びる	しなびる	{}	{"to wilt; to fade"}	\N
品物	しなもの	{}	{"article; goods"}	\N
死に掛かる	しにかかる	{まさに死のうとしている。もうすこしで死にそうである。「おぼれて―・った」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N
死に懸かる	しにかかる	{まさに死のうとしている。もうすこしで死にそうである。「おぼれて―・った」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N
死にかかる	しにかかる	{まさに死のうとしている。もうすこしで死にそうである。「おぼれて―・った」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N
死に掛け	しにかけ	{もう少しで死にそうなこと。瀕死 (ひんし) 。「―のところを助けられる」}	{"the dying (of someone/thing)"}	\N
死に懸け	しにかけ	{もう少しで死にそうなこと。瀕死 (ひんし) 。「―のところを助けられる」}	{"the dying (of someone/thing)"}	\N
死にかけ	しにかけ	{もう少しで死にそうなこと。瀕死 (ひんし) 。「―のところを助けられる」}	{"the dying (of someone/thing)"}	\N
死に掛ける	しにかける	{今にも死にそうになる。死に瀕 (ひん) する。「危うく―・けた」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N
死に懸ける	しにかける	{今にも死にそうになる。死に瀕 (ひん) する。「危うく―・けた」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N
死にかける	しにかける	{今にも死にそうになる。死に瀕 (ひん) する。「危うく―・けた」}	{"moribund; (of a thing) in terminal decline; lacking vitality or vigour; (of a person) at the point of death."}	\N
屎尿	しにょう	{}	{"excreta; raw sewage; human waste; night soil"}	\N
忍び	しのび	{隠れたりして、人目を避けること。人に知られないように、ひそかに物事をすること。→お忍び}	{incognito}	\N
芝	しば	{}	{"lawn; sod; turf"}	\N
支配	しはい	{ある地域や組織に勢力・権力を及ぼして、自分の意のままに動かせる状態に置くこと。統治；統制；指図；管理}	{"rule; control; direction; management"}	\N
賜杯	しはい	{天皇・皇族などが競技・試合などの勝者に与える優勝杯。}	{"the Emperor's Cup"}	\N
芝居	しばい	{}	{"play; drama"}	\N
支配者	しはいしゃ	{}	{"ruler; master"}	\N
始発	しはつ	{}	{"first train"}	\N
芝生	しばふ	{}	{lawn}	\N
支払	しはらい	{}	{payment}	\N
支払う	しはらう	{}	{"to pay"}	\N
暫く	しばらく	{}	{"little while"}	\N
縛る	しばる	{}	{"tie; bind"}	\N
師範	しはん	{}	{"master instructor"}	\N
渋い	しぶい	{}	{"tasteful (clothing); 'cool'; an aura of refined masculinity; astringent; sullen; bitter (taste); grim; quiet; sober; stingy"}	\N
飛沫	しぶき	{}	{"splash; spray"}	\N
私物	しぶつ	{}	{"private property; personal effects"}	\N
紙幣	しへい	{}	{"paper money; notes; bills"}	\N
司法	しほう	{}	{"administration of justice"}	\N
脂肪	しぼう	{}	{"fat; grease; blubber"}	\N
死亡	しぼう	{}	{"death; mortality"}	\N
志望	しぼう	{}	{"wish; desire; ambition"}	\N
萎む	しぼむ	{}	{"to wither; to fade (away); to shrivel; to wilt"}	\N
絞る	しぼる	{}	{"press; wring; squeeze"}	\N
搾る	しぼる	{}	{"squeeze; press"}	\N
資本	しほん	{}	{"funds; capital"}	\N
島	しま	{}	{island}	\N
仕舞	しまい	{}	{"end; termination; informal (Noh play)"}	\N
歯磨剤	しまざい	{歯磨きの際に使用される製品である。}	{"tooth paste"}	\N
島々	しまじま	{}	{islands}	\N
始末	しまつ	{}	{"management; dealing; settlement; cleaning up afterwards"}	\N
閉まる	しまる	{}	{"to close; become closed"}	\N
泌み泌み	しみじみ	{}	{"keenly; deeply; heartily"}	\N
染みる	しみる	{}	{"to pierce; to permeate"}	\N
市民	しみん	{市の住民}	{citizen}	\N
占める	しめる	{あるもの・場所・位置・地位などを自分のものとする。占有する。「三賞を一人で―・める」}	{"occupy; hold"}	\N
品揃え	しなぞろえ	{準備した品物の種類。また、商品の種類をいろいろと用意すること。「豊かなー」}	{assortment}	\N
死ぬ	しぬ	{}	{die}	\N
氏名	しめい	{}	{"full name; identity"}	\N
使命	しめい	{}	{"mission; errand; message"}	\N
締め切り	しめきり	{}	{"closing; cut-off; end; deadline; Closed; No Entrance"}	\N
締切	しめきり	{}	{"closing; cut-off; end; deadline; Closed; No Entrance"}	\N
締め切る	しめきる	{}	{"shut up"}	\N
示す	しめす	{}	{"show; indicate; denote; point out"}	\N
締める	しめる	{}	{"to tie; fasten"}	\N
閉める	しめる	{}	{"to close; shut"}	\N
湿る	しめる	{}	{"be wet; become wet; be damp"}	\N
霜	しも	{}	{frost}	\N
指紋	しもん	{手の指先の、内側にある細い線がつくる紋様。形は弓状・渦状などがあり、人によって異なり一生不変なので、個人の識別や犯罪捜査などに利用される。「―をとる」}	{"a fingerprint; 〔親指の〕a thumbprint"}	\N
諮問	しもん	{}	{"a request for advice; consult (a person on a matter)"}	\N
視野	しや	{}	{"field of vision; outlook"}	\N
社員	しゃいん	{会社の一員として勤務している人。}	{"an employee; a member of the staff (of a company); 〔総称〕the staff"}	\N
社会	しゃかい	{}	{society}	\N
社会科学	しゃかいかがく	{}	{"social science"}	\N
勺	しゃく	{尺貫法の容積の単位。1合の10分の1。約0.018リットル。せき。}	{"〔容積単位〕a shaku (単複同形) (1勺は約0.018liters)"}	\N
爵	しゃく	{中国古代の温酒器。3本足の青銅器で、殷 (いん) 代から周代にかけて祭器として盛行した。}	{nobility}	\N
市役所	しやくしょ	{地方公共団体である市の市長・職員が、市の行政事務を取り扱う役所。市庁。}	{"a town hall，((米)) a city [municipal] hall"}	\N
借用	しゃくよう	{借りて使うこと。使うために借りること。}	{"borrowing; loan"}	\N
車庫	しゃこ	{}	{garage}	\N
社交	しゃこう	{}	{"social life; social intercourse"}	\N
車掌	しゃしょう	{}	{"(train) conductor"}	\N
写真	しゃしん	{}	{photograph}	\N
写生	しゃせい	{}	{"sketch; drawing from nature; portrayal; description"}	\N
社説	しゃせつ	{}	{"editorial; leading article"}	\N
謝絶	しゃぜつ	{}	{refusal}	\N
社宅	しゃたく	{}	{"company owned house"}	\N
遮断	しゃだん	{}	{"cutoff; interception"}	\N
社長	しゃちょう	{}	{president}	\N
借款	しゃっかん	{政府または公的機関の国際的な長期資金の貸借。広義には民間借款も含む。ローン。借用金。}	{"a loan"}	\N
借金	しゃっきん	{}	{"debt; loan; liabilities"}	\N
吃逆	しゃっくり	{}	{"hiccough; hiccup"}	\N
喋る	しゃべる	{物を言う。話す。口数多く話す。口に任せてぺらぺら話す。「一言も＿・らない」「よく＿・る人だ」}	{"talk; chat; chatter"}	\N
三味線	しゃみせん	{}	{shamisen}	\N
斜面	しゃめん	{}	{"slope; slanting surface; bevel"}	\N
車両	しゃりょう	{車輪のついた乗り物の総称。また、特に汽車・電車など鉄道の貨車・客車。「前の―がすいている」「―故障」「大型―」}	{"vehicles (車輪のあるもの．そりも含む); 〔鉄道の車両の総称〕rolling stock; 〔客車〕a coach，(米) a car，(英) a carriage"}	\N
車輪	しゃりん	{}	{"(car) wheel"}	\N
下	しも	{}	{"lower; last"}	\N
僕	しもべ	{}	{"manservant; servant (of God)"}	\N
洒落	しゃらく	{}	{"frank; open-hearted"}	\N
洒落	しゃれ	{}	{"frank; open-hearted"}	\N
洒落る	しゃれる	{}	{"to joke; to play on words; to dress stylishly"}	\N
首位	しゅい	{第一の地位。順位の最上位。第1位。「クラスの―を占める」「―打者」}	{"first place"}	\N
朱印	しゅいん	{朱肉を使って押した印。特に、戦国時代以後、将軍や武将が公文書に押したもの。御朱印。}	{"red seal"}	\N
州	しゅう	{}	{"state; province"}	\N
周	しゅう	{}	{"circuit; lap; circumference; vicinity; Chou (dynasty)"}	\N
週	しゅう	{}	{week}	\N
衆	しゅう	{}	{"masses; great number; the people"}	\N
私有	しゆう	{}	{"private ownership"}	\N
周囲	しゅうい	{もののまわり。ぐるり。また、周辺。}	{surroundings}	\N
収益	しゅうえき	{給料}	{income}	\N
集会	しゅうかい	{}	{"meeting; assembly"}	\N
収穫	しゅうかく	{}	{"harvest; crop; ingathering"}	\N
収穫量	しゅうかくりょう	{}	{"harvested amount; crop quantity"}	\N
修学	しゅうがく	{}	{learning}	\N
就活	しゅうかつ	{}	{"job hunting"}	\N
週間	しゅうかん	{}	{"week; weekly"}	\N
習慣	しゅうかん	{}	{"habit; custom"}	\N
周期	しゅうき	{}	{"cycle; period"}	\N
衆議院	しゅうぎいん	{}	{"Lower House; House of Representatives"}	\N
宗教	しゅうきょう	{}	{religion}	\N
修行	しゅうぎょう	{}	{"pursuit of knowledge; studying; learning; training; ascetic practice; discipline"}	\N
就業	しゅうぎょう	{}	{"employment; starting work"}	\N
集金	しゅうきん	{}	{"money collection"}	\N
集計	しゅうけい	{数を寄せ集めて合計すること。また、その合計した数。「各営業所の売上げを―する」}	{"totalization; aggregate"}	\N
襲撃	しゅうげき	{}	{"attack; charge; raid"}	\N
集合	しゅうごう	{}	{"gathering; assembly; meeting; (mathematics) set"}	\N
修士	しゅうし	{}	{"Masters degree program"}	\N
収支	しゅうし	{}	{"income and expenditure"}	\N
終始	しゅうし	{}	{"beginning and end; from beginning to end; doing a thing from beginning to end"}	\N
習字	しゅうじ	{}	{penmanship}	\N
終日	しゅうじつ	{}	{"all day"}	\N
執着	しゅうじゃく	{}	{"attachment; adhesion; tenacity"}	\N
収集	しゅうしゅう	{}	{"gathering up; collection; accumulation"}	\N
修飾	しゅうしょく	{}	{"ornamentation; embellishment; decoration; adornment; polish up (writing); modification (gram)"}	\N
就職	しゅうしょく	{仕事を見付けること。新しく職を得て勤めること。「地元の企業にーする」}	{"find work [a job]; get a job [position]"}	\N
就寝	しゅうしん	{}	{"going to bed"}	\N
修正	しゅうせい	{不十分・不適当と思われるところを改め直すこと。「文章の誤りをーする」}	{"(make) an amendment; a revision"}	\N
修繕	しゅうぜん	{}	{"repair; mending"}	\N
集団	しゅうだん	{}	{"group; mass"}	\N
集中	しゅうちゅう	{}	{"concentration; focusing the mind"}	\N
終点	しゅうてん	{}	{"terminus; last stop (e.g train)"}	\N
周到	しゅうとう	{手落ちがなく、すべてに行き届いていること。また、そのさま。「―な計画を立てる」「用意―」}	{"meticulous; 〔細かい所まで気を配った〕scrupulous; 〔注意深い〕careful"}	\N
収入	しゅうにゅう	{}	{"income; receipts; revenue"}	\N
就任	しゅうにん	{}	{inauguration}	\N
周辺	しゅうへん	{}	{"circumference; outskirts; environs; (computer) peripheral"}	\N
週末	しゅうまつ	{}	{weekend}	\N
周密	しゅうみつ	{注意が隅々にまで行き届いていること。また、そのさま。「―をきわめた計画」「―な配慮」}	{"scrupulous; exhaustive; very careful (plan)"}	\N
収容	しゅうよう	{}	{"accommodation; reception; seating; housing; custody; admission; entering (in a dictionary)"}	\N
修理	しゅうり	{壊れたり傷んだりした部分に手を加えて、再び使用できるようにすること。修繕。「時計を―に出す」「車を―する」}	{"repairing; mending"}	\N
修了	しゅうりょう	{}	{"completion (of a course)"}	\N
終了	しゅうりょう	{}	{"end; close; termination"}	\N
守衛	しゅえい	{}	{"security guard; doorkeeper"}	\N
主演	しゅえん	{}	{"starring; playing the leading part"}	\N
主観	しゅかん	{}	{"subjectivity; subject; ego"}	\N
主義	しゅぎ	{}	{"doctrine; rule; principle"}	\N
祝賀	しゅくが	{}	{"celebration; congratulations"}	\N
祝日	しゅくじつ	{}	{"national holiday"}	\N
宿舎	しゅくしゃ	{}	{"lodgings; 〔宿泊設備〕accommodations，((英)) accommodation;〔住居〕housing"}	\N
淑女	しゅくじょ	{しとやかで上品な女性。品格の高い女性。レディー。「紳士―」}	{lady}	\N
縮小	しゅくしょう	{}	{"reduction; curtailment"}	\N
宿題	しゅくだい	{}	{homework}	\N
宿泊	しゅくはく	{自宅以外の所に泊まること}	{lodging}	\N
宿命	しゅくめい	{}	{"fate; destiny; predestination"}	\N
手芸	しゅげい	{}	{handicrafts}	\N
主権	しゅけん	{}	{"sovereignty; supremacy; dominion"}	\N
主語	しゅご	{}	{"(grammar) subject"}	\N
主催	しゅさい	{}	{"organization; sponsorship"}	\N
主宰	しゅさい	{人々の上に立って全体をまとめること。団体・結社などを、中心となって運営すること。また、その人。「劇団を―する」}	{"~する 〔監督する〕supervise; superintend; 〔司会する〕preside (over)"}	\N
取材	しゅざい	{}	{"choice of subject; collecting data"}	\N
趣旨	しゅし	{}	{"object; meaning"}	\N
種子	しゅし	{種子植物で、受精した胚珠 (はいしゅ) が成熟して休眠状態になったもの。発芽して次の植物体になる胚と、胚の養分を貯蔵している胚乳、およびそれらを包む種皮からなる。たね。}	{"⇒たね(種)a seed; 〔桃などの〕a stone; (米) a pit"}	\N
手術	しゅじゅつ	{}	{"surgical operation"}	\N
首相	しゅしょう	{}	{"Prime Minister; Chancellor (Germany; Austria; etc.)"}	\N
主食	しゅしょく	{}	{"staple food"}	\N
主人公	しゅじんこう	{}	{"protagonist; main character; hero(ine) (of a story); head of household"}	\N
主体	しゅたい	{}	{"subject; main constituent"}	\N
主題	しゅだい	{}	{"subject; theme; motif"}	\N
手段	しゅだん	{}	{"means; way; measure"}	\N
主張	しゅちょう	{}	{"claim; request; insistence; assertion; advocacy; emphasis; contention; opinion; tenet"}	\N
出演	しゅつえん	{}	{"performance; stage appearance"}	\N
出勤	しゅっきん	{}	{"going to work; at work"}	\N
出血	しゅっけつ	{}	{"bleeding; haemorrhage"}	\N
出現	しゅつげん	{あらわれでること。隠れていたものや見えなかったものなどが、姿をあらわすこと。「救世主が―する」「新技術の―」}	{"appearance; ((文)) emergence"}	\N
出産	しゅっさん	{}	{"(child)birth; delivery; production (of goods)"}	\N
出社	しゅっしゃ	{}	{"arrival (in a country at work etc.)"}	\N
出生	しゅっしょう	{}	{birth}	\N
出身	しゅっしん	{}	{"person´s place of origin; institution from which one graduated; director in charge of employee relations"}	\N
出身地	しゅっしんち	{その人が生まれた土地。また、育った土地。「有名な俳優の―」}	{"the place where one was born; one's native place; one's hometown"}	\N
出世	しゅっせ	{}	{"promotion; successful career; eminence"}	\N
出席	しゅっせき	{}	{attend}	\N
出題	しゅつだい	{}	{"proposing a question"}	\N
出張	しゅっちょう	{}	{"official tour; business trip"}	\N
出動	しゅつどう	{}	{"sailing; marching; going out"}	\N
出発	しゅっぱつ	{}	{depart}	\N
出版	しゅっぱん	{}	{publication}	\N
出費	しゅっぴ	{}	{"expenses; disbursements"}	\N
出品	しゅっぴん	{}	{"exhibit; display"}	\N
出没	しゅつぼつ	{現れたり隠れたりすること。どこからともなく姿を現しては、またいなくなること。「空き巣が―する」}	{"can often be seen; ubiquitous; infested with; frequenting"}	\N
首都	しゅと	{}	{"capital city"}	\N
種痘	しゅとう	{}	{vaccination}	\N
主導	しゅどう	{}	{"main leadership"}	\N
取得	しゅとく	{手に入れること。ある資格・権利・物品などを自分のものとして得ること。「免許を―する」}	{acquisition}	\N
主任	しゅにん	{}	{"person in charge; responsible official"}	\N
執念	しゅうねん	{ある一つのことを深く思いつめる心。執着してそこから動かない心。「―をもってやり遂げる」「―を燃やす」}	{"〔物事にとらわれた心〕an obsession; 〔復讐心，しつこく恨むこと〕vindictiveness"}	\N
首脳	しゅのう	{}	{"head; brains"}	\N
主犯	しゅはん	{二人以上の者による犯罪行為の中心となった者。}	{"the ringleader; the principal offender"}	\N
守備	しゅび	{}	{defense}	\N
主婦	しゅふ	{}	{"housewife; mistress"}	\N
症状	しょうじょう	{病気やけがの状態。病気などによる肉体的、精神的な異状。「自覚―」}	{"symptoms; condition"}	\N
殳部	しゅぶ	{ほこ、ほこづくり、るまた（上部の「几」が片仮名の「ル」に見えたことから「るまた」(ル又)という俗称が付けられた）}	{"(Radical) weapon; missile"}	\N
手法	しゅほう	{物事のやり方。特に、芸術作品などをつくるうえでの表現方法。技法。「写実的な―」「新―を用いる」}	{technique}	\N
趣味	しゅみ	{}	{hobby}	\N
主役	しゅやく	{}	{"leading part; leading actor or actress"}	\N
主要	しゅよう	{}	{"chief; main; principal; major"}	\N
狩猟	しゅりょう	{山野の鳥獣を銃・網・わななどを使って捕らえること。狩り。猟。}	{hunting}	\N
種類	しゅるい	{}	{"variety; kind; type; category; counter for different sorts of things"}	\N
瞬間	しゅんかん	{}	{"moment; second; instant"}	\N
諸	しょ	{}	{"various; many; several"}	\N
小	しょう	{}	{small}	\N
章	しょう	{}	{"chapter; section; medal"}	\N
商	しょう	{}	{quotient}	\N
賞	しょう	{}	{"prize; award"}	\N
症	しょう	{}	{illness}	\N
私用	しよう	{}	{"personal use; private business"}	\N
仕様	しよう	{}	{"way; method; resource; remedy; (technical) specification"}	\N
使用	しよう	{}	{"use; employment"}	\N
省エネ	しょうえね	{「省エネルギー」の略。石油・電力・ガスなどのエネルギーを効率的に使用し、その消費量を節約すること。}	{"energy conservation; saving energy; 省エネのenergy-saving."}	\N
消化	しょうか	{生体が体内で食物を吸収しやすい形に変化させること。また、その過程。多くの動物では消化管内で、消化器の運動（物理的消化）、消化液の作用（化学的消化）、腸内細菌の作用（生物学的消化）などによって行われる。「―のいい食べ物」「よくかまないと―に悪い」}	{〔食べ物の〕digestion}	\N
紹介	しょうかい	{}	{introduce}	\N
障害	しょうがい	{}	{"obstacle; impediment (fault); damage"}	\N
昇格	しょうかく	{}	{promotion}	\N
奨学金	しょうがくきん	{}	{scholarship}	\N
小学生	しょうがくせい	{}	{"little school student"}	\N
小学校	しょうがっこう	{}	{"primary school"}	\N
召喚	しょうかん	{人を呼び出すこと。特に、裁判所が被告人・証人・鑑定人などに対し、一定の日時に裁判所その他の場所に出頭を命ずること。「証人としてーされる」}	{summons}	\N
償還	しょうかん	{}	{redemption}	\N
将棋	しょうぎ	{}	{"Japanese chess"}	\N
将棋駒	しょうぎごま	{}	{"shougi (chess) piece"}	\N
償却	しょうきゃく	{借金などをすっかり返すこと。償還。払い戻し。減価償却}	{"repayment; depreciation"}	\N
消去	しょうきょ	{}	{"elimination; erasing; dying out; melting away"}	\N
商業	しょうぎょう	{}	{"commerce; trade; business"}	\N
消極的	しょうきょくてき	{}	{passive}	\N
賞金	しょうきん	{}	{"prize; monetary award"}	\N
衝撃	しょうげき	{瞬間的に大きな力を物体に加えること。また、その力。「衝突時の―を吸収する」}	{"〔激しい打撃〕a shock; 〔衝突による〕an impact; crash"}	\N
証券	しょうけん	{財産法上の権利・義務に関する記載のされた紙片。有価証券と証拠証券とがある。}	{"〔債務証書〕a bond; 〔株式証券〕a certificate; 〔為替手形など〕a bill; 〔公債，株券などの有価証券〕securities"}	\N
証言	しょうげん	{}	{"evidence; testimony"}	\N
証拠	しょうこ	{}	{"evidence; proof"}	\N
正午	しょうご	{}	{"noon; mid-day"}	\N
照合	しょうごう	{}	{"collation; comparison"}	\N
昇降機	しょうこうき	{}	{lift}	\N
症候群	しょうこうぐん	{同時に起こる一群の症候。シンドローム。「ネフローゼ―」「頸腕 (けいわん) ―」}	{syndrome}	\N
詳細	しょうさい	{}	{"detail; particulars"}	\N
障子	しょうじ	{}	{"paper sliding door"}	\N
正直	しょうじき	{}	{"honesty; integrity; frankness"}	\N
商社	しょうしゃ	{}	{"trading company; firm"}	\N
詔書	しょうしょ	{}	{"decree; imperial edict"}	\N
少々	しょうしょう	{}	{"just a minute; small quantity"}	\N
生じる	しょうじる	{}	{"produce; yield; result from; arise; be generated"}	\N
昇進	しょうしん	{}	{promotion}	\N
精進	しょうじん	{}	{"devotion; diligence"}	\N
小数	しょうすう	{}	{"fraction (part of); decimal"}	\N
少数	しょうすう	{}	{"minority; few"}	\N
称す	しょうする	{名乗る。名づけて言う。「自ら名人と―・する」「論文と―・するほどのものではない」}	{"to pretend; to take the name of; to feign; to purport"}	\N
称する	しょうする	{名乗る。名づけて言う。「自ら名人と―・する」「論文と―・するほどのものではない」}	{"to pretend; to take the name of; to feign; to purport"}	\N
生ずる	しょうずる	{}	{"cause; arise; be generated"}	\N
小説	しょうせつ	{}	{novel}	\N
肖像	しょうぞう	{人の姿や顔を写した絵の像}	{portrait}	\N
消息	しょうそく	{}	{"news; letter; circumstances"}	\N
招待	しょうたい	{}	{invite}	\N
承諾	しょうだく	{}	{"consent; acquiescence; agreement"}	\N
承知	しょうち	{}	{"consent; agree"}	\N
象徴	しょうちょう	{}	{symbol}	\N
焦点	しょうてん	{}	{"focus; point"}	\N
商店	しょうてん	{}	{"shop; business firm"}	\N
消毒	しょうどく	{}	{"disinfection; sterilization"}	\N
衝突	しょうとつ	{}	{"collision; conflict"}	\N
小児科	しょうにか	{}	{pediatrics}	\N
証人	しょうにん	{}	{witness}	\N
使用人	しようにん	{}	{"employee; servant"}	\N
承認	しょうにん	{そのことが正当または事実であると認めること。「相手の所有権をーする」}	{"approval; consent"}	\N
少年	しょうねん	{}	{"boys; juveniles"}	\N
勝敗	しょうはい	{}	{"victory or defeat; issue (of battle)"}	\N
商売	しょうばい	{}	{"trade; business; commerce; transaction; occupation"}	\N
消費	しょうひ	{}	{"consumption; expenditure"}	\N
商品	しょうひん	{}	{"commodity; goods; stock; merchandise"}	\N
賞品	しょうひん	{}	{"prize; trophy"}	\N
勝負	しょうぶ	{}	{"victory or defeat; match; contest; game; bout"}	\N
小便	しょうべん	{老廃物として腎臓で血液中から濾過 (ろか) され、尿管から膀胱 (ぼうこう) にたまり、尿道を経て体外に排出される液体。また、それを排出すること。尿。ゆばり。小用。小水。「―に立つ」「寝―」「立ち―」「―小僧」}	{"(colloquial) urine"}	\N
消防	しょうぼう	{}	{"fire fighting; fire department"}	\N
消防士	しょうぼうし	{}	{"fire fighter; fire man"}	\N
消防署	しょうぼうしょ	{}	{"fire station"}	\N
正味	しょうみ	{}	{"net (weight)"}	\N
賞味	しょうみ	{食べ物のおいしさをよく味わって食べること。「郷土料理をーする」}	{"enjoy (a dish; food)"}	\N
賞味期限	しょうみきげん	{}	{"expiration date (taste / relish + limit)"}	\N
照明	しょうめい	{}	{illumination}	\N
証明	しょうめい	{}	{"proof; verification"}	\N
正面	しょうめん	{}	{"front; frontage; facade; main"}	\N
庄屋	しょうや	{}	{"a village headman (in the Edo period)"}	\N
醤油	しょうゆ	{}	{"soy sauce"}	\N
将来	しょうらい	{これから先。未来。前途。副詞的にも用いる。「―の日本」「―を期待する」「―のある若者」「―医者になりたい」}	{future}	\N
勝利	しょうり	{}	{"victory; triumph; conquest; success; win"}	\N
省略	しょうりゃく	{}	{"omission; abbreviation; abridgment"}	\N
昇龍裂破	しょうりゅうれっぱ	{}	{"shoryu reppa"}	\N
奨励	しょうれい	{ある事柄を、よいこととして、それをするように人に強く勧めること}	{incentive}	\N
抄録	しょうろく	{}	{"summary; extract (of a book)"}	\N
初級	しょきゅう	{}	{"elementary level"}	\N
職	しょく	{}	{employment}	\N
職員	しょくいん	{}	{"staff member; personnel"}	\N
食塩	しょくえん	{}	{"table salt"}	\N
職業	しょくぎょう	{生計を維持するために、人が日常従事する仕事。生業。職。「教師を―とする」「―につく」「家の―を継ぐ」「―に貴賤 (きせん) なし」}	{"occupation; business"}	\N
食事	しょくじ	{}	{meal}	\N
食卓	しょくたく	{}	{"dining table"}	\N
嘱託	しょくたく	{仕事を頼んで任せること。「資料収集をーする」}	{"emporary employee"}	\N
食堂	しょくどう	{}	{"cafeteria; dining room"}	\N
職人	しょくにん	{}	{"worker; mechanic; artisan; craftsman"}	\N
職場	しょくば	{}	{"work place"}	\N
食品	しょくひん	{}	{"commodity; foodstuff"}	\N
植物	しょくぶつ	{}	{"plant; vegetation"}	\N
植民地	しょくみんち	{}	{colony}	\N
職務	しょくむ	{}	{"professional duties"}	\N
食物	しょくもつ	{}	{"food; foodstuff"}	\N
食欲	しょくよく	{}	{"appetite (for food)"}	\N
食糧	しょくりょう	{}	{"provisions; rations"}	\N
食料	しょくりょう	{}	{food}	\N
食料品	しょくりょうひん	{}	{foods}	\N
諸君	しょくん	{}	{"Gentlemen!; Ladies!"}	\N
将軍	しょうぐん	{一軍を指揮して出征する大将のこと。鎌倉時代以降、幕府の主宰者の職名。鎌倉幕府を開いた源頼朝以後、室町幕府の足利 (あしかが) 氏、江戸幕府の徳川氏まで引き継がれた。「鎮東―」}	{"a general; 〔幕府の〕a shogun"}	\N
諸国	しょこく	{多くの国々。いろいろな国。「―を行脚する」「近隣―」}	{"various [all; many] countries; 〔諸地方〕various [all; many] districts"}	\N
書斎	しょさい	{}	{study}	\N
所在	しょざい	{}	{whereabouts}	\N
所持	しょじ	{}	{"possession; owning"}	\N
初旬	しょじゅん	{}	{"first 10 days of the month"}	\N
初心者	しょしんしゃ	{その道に入ったばかりで、まだ未熟な者。習い始め、あるいは覚えたての人。}	{"a beginner; a novice"}	\N
書籍	しょせき	{文章・絵画などを筆写または印刷した紙の束をしっかり綴 (と) じ合わせ、表紙をつけて保存しやすいように作ったもの。巻き物に仕立てることもある。多く、雑誌と区別していう。書物。本。図書。しょじゃく。→電子書籍}	{"book; publication"}	\N
所属	しょぞく	{}	{"attached to; belong to"}	\N
初代	しょだい	{家系・芸道などで、一家を立てた最初の人。また、その人の代。}	{"first (e.g. president)"}	\N
処置	しょち	{その場や状況に応じた判断をし手だてを講じて、物事に始末をつけること。「適切にーする」}	{"treatment; disposal; measures"}	\N
暑中	しょちゅう	{}	{midsummer}	\N
食器	しょっき	{}	{tableware}	\N
所定	しょてい	{}	{"fixed; prescribed"}	\N
書店	しょてん	{}	{bookstore}	\N
書道	しょどう	{}	{calligraphy}	\N
所得	しょとく	{}	{"income; earnings"}	\N
処罰	しょばつ	{}	{punishment}	\N
初版	しょはん	{}	{"first edition"}	\N
書評	しょひょう	{}	{"book review"}	\N
処分	しょぶん	{}	{disposal}	\N
庶民	しょみん	{}	{"masses; common people"}	\N
庶務	しょむ	{}	{"general affairs"}	\N
署名	しょめい	{}	{signature}	\N
書物	しょもつ	{}	{books}	\N
所有	しょゆう	{自分のものとして持っていること。また、そのもの。「多大な財産をーする」「父のーする土地」}	{"possession; proprietary"}	\N
所有者	しょゆうしゃ	{所有している人。所有権のある人。所有主。}	{"proprietary; relating to an owner or ownership"}	\N
処理	しょり	{物事を取りさばいて始末をつけること。「事務を手早く―する」「事後―」「熱―」}	{"processing; dealing with; treatment; disposition; disposal"}	\N
書類	しょるい	{文書・書き付けなどの総称。特に、事務や記録などに関する書き付け。「重要―」}	{"documents; official papers"}	\N
白髪	しらが	{}	{"white or grey hair; trendy hair bleaching"}	\N
知らせ	しらせ	{}	{notice}	\N
知らせる	しらせる	{他の人が知るようにする。言葉やその他の手段で伝える。「手紙で無事を―・せる」「事件を―・せる」「虫が―・せる」}	{"〔分からせる〕let ((a person)) know; 〔告げる〕tell ((a person about [that]))，((文)) inform ((a person of a matter)); 〔暗に知らせる〕suggest"}	\N
報せる	しらせる	{他の人が知るようにする。知らせる}	{report}	\N
知られる	しられる	{知れる、他の人の知るところとなる}	{known}	\N
調べ	しらべ	{}	{"preparation; investigation; inspection"}	\N
調べる	しらべる	{}	{investigate}	\N
尻	しり	{}	{"buttocks; bottom"}	\N
知り合い	しりあい	{}	{acquaintance}	\N
弾	たま	{}	{"bullet; shot; shell"}	\N
私立	しりつ	{}	{"private (e.g. school or detective)"}	\N
資料	しりょう	{研究・調査の基礎となる材料。}	{"materials; data"}	\N
汁	しる	{}	{"juice; sap; soup; broth"}	\N
知る	しる	{}	{"know; understand; be acquainted with; feel"}	\N
記す	しるす	{}	{"to note; to write down"}	\N
指令	しれい	{}	{"orders; instructions; directive"}	\N
白	しろ	{}	{white}	\N
城	しろ	{}	{castle}	\N
代	しろ	{}	{"price; materials; substitution"}	\N
白い	しろい	{}	{white}	\N
素人	しろうと	{}	{"amateur; novice"}	\N
新	しん	{}	{new}	\N
芯	しん	{}	{"core; heart; wick; marrow"}	\N
進化	しんか	{}	{"evolution; progress"}	\N
進学	しんがく	{}	{"going on to university"}	\N
新型	しんがた	{従来のものとは違う、新しい型・形式。また、その製品。「―の車両」}	{"a new style [type]"}	\N
殿	しんがり	{}	{"rear; rear unit guard"}	\N
新幹線	しんかんせん	{}	{"bullet train"}	\N
新規	しんき	{}	{new}	\N
審議	しんぎ	{}	{deliberation}	\N
真空	しんくう	{}	{"vacuum; hollow; empty"}	\N
神経	しんけい	{からだの機能を統率し、刺激を伝える組織。過敏な心の働き。感受性}	{"nerve; sensitivity; nervous"}	\N
真剣	しんけん	{}	{"seriousness; earnestness"}	\N
震源	しんげん	{}	{epicenter}	\N
進行	しんこう	{}	{advance}	\N
信仰	しんこう	{}	{"(religious) faith; belief; creed"}	\N
新興	しんこう	{}	{"rising; developing; emergent"}	\N
振興	しんこう	{}	{"promotion; encouragement"}	\N
侵攻	しんこう	{}	{invasion}	\N
信号	しんごう	{}	{"traffic lights; signal; semaphore"}	\N
申告	しんこく	{}	{"report; statement; filing a return; notification"}	\N
深刻	しんこく	{}	{serious}	\N
新婚	しんこん	{}	{newly-wed}	\N
審査	しんさ	{}	{"judging; inspection; examination; investigation"}	\N
診察	しんさつ	{}	{"medical examination"}	\N
診察券	しんさつけん	{}	{"medical examination card"}	\N
紳士	しんし	{}	{gentleman}	\N
紳士淑女	しんししゅくじょ	{}	{"lady and gentleman"}	\N
寝室	しんしつ	{寝るために使う部屋。ねや。}	{"a bedroom"}	\N
信者	しんじゃ	{}	{"believer; adherent; devotee; Christian"}	\N
真珠	しんじゅ	{}	{pearl}	\N
心中	しんじゅう	{}	{"double suicide; lovers suicide"}	\N
進出	しんしゅつ	{}	{"advance; step forward"}	\N
心情	しんじょう	{}	{mentality}	\N
信じる	しんじる	{}	{"believe; believe in; place trust in; confide in; have faith in"}	\N
心身	しんしん	{}	{"mind and body"}	\N
新人	しんじん	{}	{"new face; newcomer"}	\N
信ずる	しんずる	{}	{"believe; believe in; place trust in; confide in; have faith in"}	\N
神聖	しんせい	{}	{"holiness; sacredness; dignity"}	\N
申請	しんせい	{}	{"application; request; petition"}	\N
親戚	しんせき	{}	{relative}	\N
親切	しんせつ	{}	{kind}	\N
新鮮	しんせん	{}	{fresh}	\N
親善	しんぜん	{}	{friendship}	\N
真相	しんそう	{ある物事の真実のすがた。特に、事件などの、本当の事情・内容。}	{"truth; fact"}	\N
心臓	しんぞう	{}	{heart}	\N
心臓発作	しんぞうほっさ	{}	{"heart attack"}	\N
寝台	しんだい	{}	{"bed; couch"}	\N
診断	しんだん	{}	{diagnosis}	\N
新築	しんちく	{}	{"new building; new construction"}	\N
慎重	しんちょう	{}	{"discretion; prudence"}	\N
身長	しんちょう	{}	{"height (of body); stature"}	\N
慎重な	しんちょうな	{注意深い・思慮深い・用心深い}	{"prudently; carefully"}	\N
進呈	しんてい	{}	{presentation}	\N
進展	しんてん	{}	{"progress; development"}	\N
海路	うみじ	{}	{"sea route"}	\N
神殿	しんでん	{}	{"temple; sacred place"}	\N
進度	しんど	{}	{progress}	\N
深度	しんど	{深さの程度・度合い。「焦点―」}	{depth}	\N
神道	しんとう	{}	{Shinto}	\N
振動	しんどう	{揺れ動くこと。「爆音でガラス戸が―する」}	{"vibration; oscillation"}	\N
侵入	しんにゅう	{}	{"penetration; invasion; raid; aggression; trespass"}	\N
新入生	しんにゅうせい	{}	{"freshman; first-year student"}	\N
信任	しんにん	{}	{"trust; confidence; credence"}	\N
心配	しんぱい	{}	{"worry; concern; anxiety; care"}	\N
神秘	しんぴ	{}	{mystery}	\N
新聞	しんぶん	{}	{newspaper}	\N
新聞社	しんぶんしゃ	{}	{"newspaper office"}	\N
進歩	しんぽ	{}	{"progress; development"}	\N
辛抱	しんぼう	{}	{"patience; endurance"}	\N
審問	しんもん	{}	{"an inquiry ((into)); 〔聴問〕a hearing"}	\N
深夜	しんや	{}	{"late at night"}	\N
親友	しんゆう	{}	{"close friend"}	\N
信用	しんよう	{}	{"confidence; dependence; credit; faith; reliance; belief; credence"}	\N
信頼	しんらい	{}	{"reliance; trust; confidence"}	\N
辛辣	しんらつ	{言うことや他に与える批評の、きわめて手きびしいさま。「―をきわめる」「―な風刺漫画」}	{"〜な acerbic; sharp; sarcastic; sardonic"}	\N
真理	しんり	{}	{truth}	\N
心理	しんり	{}	{mentality}	\N
侵略	しんりゃく	{}	{"aggression; invasion; raid"}	\N
診療	しんりょう	{}	{"medical examination and treatment; diagnosis"}	\N
診療所	しんりょうしょ	{}	{"clinic (local)"}	\N
森林	しんりん	{}	{"forest; woods"}	\N
親類	しんるい	{}	{"relation; kin"}	\N
針路	しんろ	{}	{"course; direction; compass bearing"}	\N
進路	しんろ	{}	{"course; route"}	\N
神話	しんわ	{}	{"myth; legend"}	\N
羊栖菜	ひじき	{}	{"hijiki (sea grass)"}	\N
掃除	そうじ	{}	{"cleaning; sweeping"}	\N
葬式	そうしき	{}	{funeral}	\N
審判	しんばん	{}	{"refereeing; trial; judgement; umpire; referee"}	\N
葦	あし	{}	{"ditch reed"}	{植物}
芦	あし	{}	{"hollow reed"}	{植物}
杏子	あんず	{}	{"あんy apricot brand will do+椅子"}	{植物}
梅	うめ	{}	{"plum; plum-tree; lowest (of a three-tier ranking system)"}	{植物}
荻	おぎ	{}	{reed}	{植物}
柿	かき	{}	{"kaki; persimon"}	{植物}
添う	そう	{}	{"to accompany; to become married; to comply with"}	\N
沿う	そう	{}	{"to run along; to follow"}	\N
僧	そう	{}	{"monk; priest"}	\N
総	そう	{}	{"whole; all; general; gross"}	\N
相違	そうい	{}	{"difference; discrepancy; variation"}	\N
相応	そうおう	{}	{"suitability; fitness"}	\N
騒音	そうおん	{}	{noise}	\N
総会	そうかい	{}	{"general meeting"}	\N
爽快	そうかい	{}	{"refreshing; exhilarating"}	\N
総括	そうかつ	{概要}	{"generalization; summary"}	\N
創刊	そうかん	{}	{"launching (e.g. newspaper); first issue"}	\N
葬儀	そうぎ	{死者をほうむる儀式。葬式}	{Funeral}	\N
創業	そうぎょう	{事業を始めること。会社や店を新しく興すこと。「―して百年になる」}	{"the establishment [founding] of a business"}	\N
送金	そうきん	{}	{"remittance; sending money"}	\N
総計	そうけい	{全体をひっくるめて計算すること。また、その合計。「一か月の支出を―する」→小計}	{"the total [sum]"}	\N
倉庫	そうこ	{}	{"storehouse; warehouse"}	\N
相互	そうご	{}	{"mutual; reciprocal"}	\N
走行	そうこう	{}	{"running a wheeled vehicle (e.g. car); traveling"}	\N
総合	そうごう	{}	{"synthesis; coordination; putting together; integration; composite"}	\N
操作	そうさ	{}	{"operation; management; processing"}	\N
捜査	そうさ	{}	{"search (esp. in criminal investigations); investigation"}	\N
総裁	そうさい	{政党・銀行・公社などの長として、全体を取りまとめる職務。また、その人。「―選挙」「日銀―」}	{"president (総裁候補)"}	\N
総裁候補	そうさいこうほ	{}	{"government candidate"}	\N
捜査官	そうさかん	{}	{"(police) investigator"}	\N
捜索	そうさく	{}	{"search (esp. for someone or something missing); investigation"}	\N
創作	そうさく	{}	{"production; literary creation; work"}	\N
操縦	そうじゅう	{}	{"management; handling; control; manipulation"}	\N
操縦士	そうじゅうし	{}	{pilot}	\N
早熟	そう‐じゅく	{肉体や精神の発育が普通より早いこと。また、そのさま。「―な娘」⇔晩熟。}	{"precocity; (advanced; old beyond one's years; forward; ahead of one's peers; mature)"}	\N
装飾	そうしょく	{}	{ornament}	\N
送信	そうしん	{信号を送ること。特に、電気信号を遠方に送ること。「緊急信号を―する」「メールを―する」⇔受信。}	{"transmission (of a message)"}	\N
創設	そうせつ	{}	{"founding; establishment"}	\N
創造	そうぞう	{}	{creation}	\N
想像	そうぞう	{}	{"imagination; guess"}	\N
騒々しい	そうぞうしい	{}	{"noisy; boisterous"}	\N
相続	そうぞく	{}	{"succession; inheritance"}	\N
壮大	そうだい	{}	{"magnificent; grand; majestic; splendid"}	\N
相談	そうだん	{問題の解決のために話し合ったり、他人の意見を聞いたりすること。また、その話し合い。「―がまとまる」「―に乗る」「友人に―する」「身の上―」}	{"consultation; discussion"}	\N
装置	そうち	{}	{"equipment; installation; apparatus"}	\N
漕艇	そうてい	{}	{"rowing boat"}	\N
相当	そうとう	{}	{"suitable; fair; tolerable; proper; extremely"}	\N
騒動	そうどう	{}	{"strife; riot; rebellion"}	\N
遭難	そうなん	{}	{"disaster; shipwreck; accident"}	\N
挿入	そうにゅう	{中にさし入れること。中にはさみこむこと。「イラストを―する」}	{"(an) insertion (into)"}	\N
相場	そうば	{}	{"market price; speculation; estimation"}	\N
装備	そうび	{必要な機器などを取り付けること。戦闘・登山など特定の目的に応じた用具をそろえたり身につけたりすること。また、その機器や用具。「魚探機をーする」「冬山用のー」}	{equipment}	\N
送別	そうべつ	{}	{"farewell; send-off"}	\N
総理大臣	そうりだいじん	{}	{"Prime Minister"}	\N
創立	そうりつ	{}	{"establishment; founding; organization"}	\N
僧侶	そうりょ	{}	{"a priest⇒そう(僧)"}	\N
送料	そうりょう	{}	{postage}	\N
疎遠	そえん	{遠ざかって関係が薄いこと。音信や訪問が久しく途絶えていること。また、そのさま。「平素の―をわびる」「―になる」「―な間柄」}	{"alienate; estrange; drift (apart)"}	\N
即座に	そくざに	{}	{"immediately; right away"}	\N
即死	そくし	{事故などにあったその時点ですぐさま死ぬこと。「―状態」}	{"instant death"}	\N
促進	そくしん	{}	{"promotion; acceleration; encouragement; facilitation; spurring on"}	\N
即時	そくじ	{すぐその時。即刻。また、短時間。副詞的にも用いる。「ーの判断が要求される」「ー徹退せよ」「ー通話」}	{"instantly; promptly; at once; 〔その場で〕on the spot"}	\N
側室	そくしつ	{貴人のめかけ。そばめ。⇔正室／嫡室。}	{"a nobleman's concubine [mistress]"}	\N
即する	そくする	{}	{"to conform to; to agree with; to be adapted to; to be based on"}	\N
速達	そくたつ	{}	{"express; special delivery"}	\N
測定	そくてい	{}	{measurement}	\N
速度	そくど	{}	{"speed; velocity; rate"}	\N
束縛	そくばく	{}	{"restraint; shackles; restriction; confinement; binding"}	\N
側面	そくめん	{}	{"side; flank; sidelight; lateral"}	\N
測量	そくりょう	{}	{"measurement; surveying"}	\N
速力	そくりょく	{}	{speed}	\N
狙撃	そげき	{狙い撃ち}	{sniping}	\N
其処	そこ	{}	{"that place; there"}	\N
底	そこ	{}	{"bottom; sole"}	\N
損なう	そこなう	{}	{"to harm; to hurt; to injure; to damage; to fail in doing"}	\N
其処ら	そこら	{}	{"everywhere; somewhere; approximately; that area; around there"}	\N
素材	そざい	{もとになる材料。原料。材料}	{material}	\N
阻止	そし	{妨げること。くいとめること。はばむこと。「反対派の入場を―する」}	{"obstruction; check; hindrance; prevention; interdiction"}	\N
組織	そしき	{}	{"organization; structure; construction; tissue; system"}	\N
素質	そしつ	{}	{"character; qualities; genius"}	\N
然して	そして	{}	{and}	\N
訴訟	そしょう	{}	{"litigation; lawsuit"}	\N
租税	そぜい	{国または地方公共団体が、その経費に充てるために、法律に基づいて国民や住民から強制的に徴収する金銭。国税と地方税とがある。税。税金。}	{taxes⇒ぜいきん(税金)}	\N
祖先	そせん	{}	{ancestor}	\N
育ち	そだち	{}	{"breeding; growth"}	\N
育つ	そだつ	{}	{"bring up; be brought up; grow (up)"}	\N
育てる	そだてる	{}	{"bring up"}	\N
措置	そち	{事態に応じて必要な手続きをとること。取り計らって始末をつけること。処置。「万全のーをとる」「適当にーする」}	{"a measure (against); a step"}	\N
其方	そちら	{}	{"over there; the other"}	\N
卒	そつ	{}	{-graduate}	\N
卒業	そつぎょう	{}	{graduate}	\N
卒論	そつろん	{大学の学部の学生が卒業に際して提出し、審査を受ける論文。}	{"a graduation thesis"}	\N
卒業論文	そつぎょうろんぶん	{大学の学部の学生が卒業に際して提出し、審査を受ける論文。}	{"a graduation thesis"}	\N
素っ気ない	そっけない	{}	{"cold; short; curt; blunt"}	\N
率直	そっちょく	{}	{"frankness; candour; openheartedness"}	\N
卒直	そっちょく	{}	{"frankness; candour; openheartedness"}	\N
外方	そっぽ	{}	{"look (or turn) the other way"}	\N
袖	そで	{}	{sleeve}	\N
備え付ける	そなえつける	{}	{"to provide; to furnish; to equip; to install"}	\N
具える	そなえる	{}	{"furnish; provide for; equip; install; have ready; prepare for; possess; have; be endowed with; be armed with"}	\N
備える	そなえる	{ある事態が起こったときにうろたえないように、また、これから先に起こる事態に対応できるように準備しておく。心構えをしておく。「万一に―・える」「地震に―・える」「試験に―・えて夜遅くまで勉強する」}	{"to furnish; to provide for; to equip; to install; to have ready; to prepare for; to possess; to have; to be endowed with; to be armed with"}	\N
備わる	そなわる	{}	{"to be furnished with; to be endowed with; to possess; to be among; to be one of; to be possessed of"}	\N
その上	そのうえ	{}	{"in addition; furthermore"}	\N
其の後	そのご	{ある事があったあと。それ以来。以後。副詞的にも用いる。「事件の―は知らない」「―いかがお過ごしですか」}	{"after that"}	\N
その後	そのご	{ある事があったあと。それ以来。以後。副詞的にも用いる。「事件の―は知らない」「―いかがお過ごしですか」}	{"after that"}	\N
其の度	そのたび	{ある事が行われたり、ある状況になったりすると、決まって生じるさま。その時々・その時その時・決まって・いつも}	{"whenever; each time"}	\N
そのたび	其の度	{ある事が行われたり、ある状況になったりすると、決まって生じるさま。その時々・その時その時・決まって・いつも}	{"whenever; each time"}	\N
その為	そのため	{}	{"hence; for that reason"}	\N
その外	そのほか	{}	{"besides; in addition; the rest"}	\N
蕎麦	そば	{穀物のソバの実を原料とする蕎麦粉を用いて加工した、日本の麺類の一種、および、それを用いた料理である。}	{"soba (buckwheat noodles)"}	\N
祖父	そふ	{}	{"grand father"}	\N
祖母	そぼ	{}	{"grand mother"}	\N
素朴	そぼく	{}	{"simplicity; artlessness; naivete"}	\N
粗末	そまつ	{}	{"crude; rough; plain; humble"}	\N
染まる	そまる	{}	{"to dye"}	\N
背く	そむく	{}	{"to run counter to; to go against; to disobey; to infringe"}	\N
染める	そめる	{}	{"to dye; to colour"}	\N
抑	そもそも	{最初。発端。副詞的にも用いる。元々。大体「この話には―から反対だった」「目的が―違う」}	{"in the first place; from the beginning"}	\N
注ぐ	そそぐ	{}	{"pour (into); fill; irrigate; pay; feed (a fire)"}	\N
外	そと	{}	{"other place; the rest"}	\N
園	その	{}	{"garden; park; plantation"}	\N
側	そば	{}	{"near; close; beside; vicinity; proximity; besides; while"}	\N
逸らす	そらす	{}	{"to turn away; to avert"}	\N
反り	そり	{}	{"warp; curvature; curve; arch"}	\N
剃る	そる	{毛髪やひげなどを、かみそりなどで根元からきれいに切り落とす。「ひげを―・る」}	{"shave (hair)"}	\N
其れ	それ	{}	{"〔相手に近い物〕that; it"}	\N
それでは	それでは	{前に示された事柄を受けて、それに対する判断・意見などを導く。そういうことなら。それなら。では。それじゃ。「ーいずれ手にはいるね」「ーこうしたらどうか」}	{"Well then; all right; So..; now..;"}	\N
それじゃ	それじゃ	{前に示された事柄を受けて、それに対する判断・意見などを導く。そういうことなら。それなら。では。それでは。「ーいずれ手にはいるね」「ーこうしたらどうか」}	{"Well then; all right; So..; now..;"}	\N
其れ程	それほど	{}	{"to that degree; extent"}	\N
其れ故	それゆえ	{}	{"therefore; for that reason; so"}	\N
逸れる	それる	{}	{"stray from subject; get lost; go astray"}	\N
揃える	そろえる	{二つ以上のものの、形・大きさなどを同じにする。「ひもの長さをー・える」「彼とセーターの柄を＿・える」}	{"carries; gathers"}	\N
徐々	そろそろ	{動作が静かにゆっくりと行われるさま。そろり。ぼつぼつ「ー歩く」}	{"gradually; steadily; quietly; slowly; soon"}	\N
算盤	そろばん	{}	{abacus}	\N
損	そん	{}	{"loss; disadvantage"}	\N
損害	そんがい	{}	{"damage; injury; loss"}	\N
尊敬	そんけい	{}	{"respect; esteem; reverence; honour"}	\N
存在	そんざい	{}	{"existence; being"}	\N
損失	そんしつ	{}	{loss}	\N
存続	そんぞく	{}	{"duration; continuance"}	\N
尊重	そんちょう	{}	{"respect; esteem; regard"}	\N
損得	そんとく	{}	{"loss and gain; advantage and disadvantage"}	\N
そんな	そんな	{聞き手、または、そのそばにいる人が当面している事態や、現に置かれている状況がそのようであるさま。それほどの。そのような。「―話は聞いたことがない」「―に嫌ならやめなさい」}	{"(all) that; such (a fuss); very  (much)"}	\N
すっかり	すっかり	{残るもののないさま。ことごとく。まったく。完全に。}	{"completely; really (aged; pleased)"}	\N
清々しい	すがすがしい	{さわやかで気持ちがいい。涼しい}	{refreshing}	\N
即ち	すなわち	{前に述べた事を別の言葉で説明しなおすときに用いる。言いかえれば。つまり。}	{"namely; that is (to say); or"}	\N
術	すべ	{方法や道など}	{"a way; means"}	\N
酢	す	{}	{vinegar}	\N
巣	す	{}	{"nest; rookery; breeding place; beehive; cobweb; den"}	\N
水位	すいい	{一定の基準面から測った水面の高さ。}	{"water level"}	\N
推移	すいい	{時がたつにつれて状態が変化すること。移り変わっていくこと。「情勢が―する」}	{"〔変化〕a change; 〔移行〕a transition"}	\N
水泳	すいえい	{}	{swimming}	\N
西瓜	すいか	{}	{watermelon}	\N
水気	すいき	{}	{"moisture; dampness; vapor; dropsy; edema"}	\N
水源	すいげん	{}	{"source of river; fountainhead"}	\N
水産	すいさん	{}	{"marine products; fisheries"}	\N
水死	すいし	{水におぼれて死ぬこと。溺死(できし)。「池にはまって―する」}	{"death from drowning"}	\N
水死体	すいしたい	{}	{"corpse of a drowned individual"}	\N
炊事	すいじ	{}	{"cooking; culinary arts"}	\N
水準	すいじゅん	{}	{"water level; level; standard"}	\N
水晶	すいしょう	{}	{crystal}	\N
水蒸気	すいじょうき	{}	{"water vapour; steam"}	\N
推進	すいしん	{物を前へおし進めること。「スクリューで＿する」}	{"promote; propel"}	\N
水洗	すいせん	{}	{flushing}	\N
推薦	すいせん	{}	{recommendation}	\N
推薦状	すいせんじょう	{}	{"Letter of recommendation"}	\N
水素	すいそ	{}	{hydrogen}	\N
吹奏	すいそう	{}	{"playing wind instruments"}	\N
推測	すいそく	{}	{"guess; conjecture"}	\N
衰退	すいたい	{減少}	{decline}	\N
垂直	すいちょく	{}	{"vertical; perpendicular"}	\N
推定	すいてい	{}	{"presumption; assumption; estimation"}	\N
水滴	すいてき	{}	{"drop of water"}	\N
家賃	やちん	{}	{rent}	\N
各々	それぞれ	{}	{"each; every; either; respectively; severally"}	\N
水田	すいでん	{}	{"(water-filled) paddy field"}	\N
水筒	すいとう	{}	{"canteen; flask; water bottle"}	\N
水道	すいどう	{}	{"water works"}	\N
水分	すいぶん	{}	{moisture}	\N
水平	すいへい	{}	{"water level; horizon"}	\N
水平線	すいへいせん	{}	{horizon}	\N
睡眠	すいみん	{}	{sleep}	\N
水曜	すいよう	{}	{Wednesday}	\N
水曜日	すいようび	{}	{Wednesday}	\N
推理	すいり	{}	{"reasoning; inference; mystery or detective genre (movie novel etc.)"}	\N
吸う	すう	{}	{"to smoke; breathe in; sip; suck"}	\N
数学	すうがく	{}	{mathematics}	\N
崇敬	すうけい	{あがめうやまうこと。尊崇。「生き仏として―する」「―の念」}	{"veneration; adoration"}	\N
数詞	すうし	{}	{numeral}	\N
数字	すうじ	{}	{"numeral; figure"}	\N
崇拝	すうはい	{}	{"worship; adoration; admiration; cult"}	\N
数量	すうりょう	{}	{quantity}	\N
据え付ける	すえつける	{}	{"to install; to equip; to mount"}	\N
末っ子	すえっこ	{}	{"youngest child"}	\N
据える	すえる	{}	{"to set (table); to lay (foundation); to place (gun); to apply (moxa)"}	\N
姿	すがた	{}	{"figure; shape; appearance"}	\N
好き	すき	{}	{"liking; fondness; love"}	\N
過ぎ	すぎ	{}	{"past; after"}	\N
好き嫌い	すききらい	{}	{"likes and dislikes; taste"}	\N
好き好き	すきずき	{}	{"matter of taste"}	\N
透き通る	すきとおる	{}	{"be or become transparent"}	\N
隙間	すきま	{}	{"crevice; crack; gap; opening"}	\N
過ぎる	すぎる	{}	{pass}	\N
直ぐ	すぐ	{}	{"immediately; soon; easily; right (near); honest; upright"}	\N
救い	すくい	{}	{"help; aid; relief"}	\N
巣喰う	すくう	{悪い考えや病気などが宿る「妄想が―・う」「病魔が―・う」}	{"infest; build a nest"}	\N
救う	すくう	{}	{"rescue from; help out of"}	\N
少ない	すくない	{}	{"few; a little; scarce; insufficient; seldom"}	\N
少なくとも	すくなくとも	{}	{"at least"}	\N
優れる	すぐれる	{}	{"surpass; outstrip; excel"}	\N
凄い	すごい	{}	{"terrible; dreadful; terrific; amazing; great; wonderful; to a great extent"}	\N
少し	すこし	{}	{"small quantity; little; few; something; little while; short distance"}	\N
少しずつ	すこしずつ	{}	{little-by-little}	\N
少しも	すこしも	{}	{"anything of; not one bit"}	\N
過ごす	すごす	{}	{"pass; spend; go through; tide over"}	\N
健やか	すこやか	{}	{"vigorous; healthy; sound"}	\N
筋	すじ	{}	{"muscle; string; line; stripe; plot; plan; sinew"}	\N
濯ぐ	すすぐ	{}	{"to rinse; to wash out"}	\N
進み	すすみ	{}	{progress}	\N
進む	すすむ	{}	{"make progress; advance; improve"}	\N
勧め	すすめ	{}	{"recommendation; advice; encouragement"}	\N
進める	すすめる	{}	{"advance; promote; hasten"}	\N
勧める	すすめる	{}	{"recommend; advise; encourage"}	\N
薦める	すすめる	{ある人や物をほめて、採用するように説く。推薦する。「有望株を―・める」}	{recommend}	\N
鈴	すず	{}	{bell}	\N
涼しい	すずしい	{}	{"cool; refreshing"}	\N
裾	すそ	{}	{"(trouser) cuff; (skirt) hem; cut edge of a hairdo; foot of mountain"}	\N
廃れる	すたれる	{}	{"to go out of use; to become obsolete; to die out; to go out of fashion"}	\N
酸っぱい	すっぱい	{}	{"sour; acid"}	\N
素敵	すてき	{}	{"lovely; dreamy; beautiful; great; fantastic; superb; cool; capital"}	\N
既に	すでに	{ある動作が過去に行われていたことを表す。以前に。前に。「―述べた事柄」}	{"already; too late"}	\N
已に	すでに	{ある動作が過去に行われていたことを表す。以前に。前に。「―述べた事柄」}	{"already; too late"}	\N
既にして	すでにして	{そうこうしているうちに。かれこれする間に。やがて。}	{"in the meantime; soon; before long"}	\N
捨てる	すてる	{}	{throw}	\N
棄てる	すてる	{不用のものとして、手元から放す。ほうる。投棄する。「ごみを―・てる」「武器を―・てて投降する」⇔拾う。}	{"throw away; cast aside; abandon; resign"}	\N
砂	すな	{}	{sand}	\N
素直	すなお	{}	{"obedient; meek; docile; unaffected"}	\N
脛	すね	{膝 (ひざ) からくるぶしまでの間の部分。はぎ。}	{"〔向こうずね〕the shin"}	\N
臑	すね	{膝 (ひざ) からくるぶしまでの間の部分。はぎ。}	{"〔向こうずね〕the shin"}	\N
すね	臑・脛	{膝 (ひざ) からくるぶしまでの間の部分。はぎ。}	{"〔向こうずね〕the shin"}	\N
素早い	すばやい	{}	{"fast; quick; prompt; agile"}	\N
素晴らしい	すばらしい	{}	{"wonderful; splendid; magnificent"}	\N
全て	すべて	{}	{"all; the whole; entirely; in general; wholly"}	\N
滑る	すべる	{}	{"to slide; to slip; to glide"}	\N
住まい	すまい	{}	{"dwelling; house; residence; address"}	\N
澄ます	すます	{}	{"to clear; to make clear; to be unruffled; to look unconcerned; to look demure; look prim; put on airs"}	\N
済ます	すます	{}	{"to finish; to get it over with; to settle; to conclude; to pay back"}	\N
済ませる	すませる	{}	{"be finished"}	\N
済まない	すまない	{}	{"sorry (phrase)"}	\N
墨	すみ	{}	{ink}	\N
隅	すみ	{}	{corner}	\N
住む	すむ	{}	{"abide; reside; live in; inhabit; dwell"}	\N
清む	すむ	{}	{"to clear (e.g. weather); become transparent"}	\N
澄む	すむ	{}	{"to clear (e.g. weather); to become transparent"}	\N
済む	すむ	{}	{end}	\N
相撲	すもう	{}	{"sumo wrestling"}	\N
刷り	すり	{}	{printing}	\N
刷る	する	{}	{"print; publish"}	\N
鋭い	するどい	{}	{"pointed; sharp"}	\N
擦れ違い	すれちがい	{}	{"chance encounter"}	\N
すれ違う	すれちがう	{}	{"to pass by one another; to disagree; to miss each other"}	\N
擦れる	すれる	{}	{"to rub; to chafe; to wear; to become sophisticated"}	\N
座る	すわる	{}	{sit}	\N
寸前	すんぜん	{}	{"on the verge; just (before)"}	\N
寸法	すんぽう	{}	{"measurement; size; dimension"}	\N
田	た	{}	{"rice field"}	\N
他意	たい	{}	{"ill will; malice; another intention; secret purpose; ulterior motive; fickleness; double-mindedness"}	\N
対	たい	{}	{"ratio; versus; against; opposition"}	\N
体育	たいいく	{}	{"physical education; gymnastics; athletics"}	\N
退院	たいいん	{}	{"leave hospital"}	\N
対応	たいおう	{}	{"interaction; correspondence; coping with; dealing with"}	\N
体温	たいおん	{}	{"temperature (body)"}	\N
退化	たいか	{}	{"degeneration; retrogression"}	\N
大会	たいかい	{}	{"convention; tournament; mass meeting; rally"}	\N
大概	たいがい	{}	{"in general; mainly"}	\N
体格	たいかく	{}	{"physique; constitution"}	\N
退学	たいがく	{}	{"dropping out of school"}	\N
体幹	たいかん	{体の主要部分。胴体のこと。また、その部分にある筋肉。コア。「―を鍛える運動器具」}	{core}	\N
体感	たいかん	{からだで感じること。また、からだが受ける感じ。}	{"a feeling in the body; a bodily sensation"}	\N
体感温度	たいかんおんど	{からだに感じる暑さ・寒さなどの度合いを数量で表したもの。気温のほか風速・湿度・日射なども関係する。実効温度・不快指数などがある。}	{"sensible temperature"}	\N
大気	たいき	{}	{atmosphere}	\N
大金	たいきん	{}	{"great cost"}	\N
待遇	たいぐう	{}	{"treatment; reception"}	\N
退屈	たいくつ	{}	{"tedium; boredom"}	\N
体系	たいけい	{}	{"system; organization"}	\N
対決	たいけつ	{}	{"confrontation; showdown"}	\N
体験	たいけん	{}	{"personal experience"}	\N
太鼓	たいこ	{}	{"drum; tambourine"}	\N
対抗	たいこう	{}	{"opposition; antagonism"}	\N
滞在	たいざい	{}	{"stay; staying「不法滞在者：illegal immigrant」"}	\N
耐える	たえる	{}	{"to bear; to endure"}	\N
絶える	たえる	{}	{"to die out; to peter out; to become extinct"}	\N
他	た	{}	{"other (especially people and abstract matters)"}	\N
対策	たいさく	{相手の態度や事件の状況に対応するための方法・手段。「人手不足の―を立てる」「―を練る」「税金―」}	{"〔方策〕measures; a step; 〔対抗策〕a countermeasure"}	\N
大使	たいし	{}	{ambassador}	\N
退治	たいじ	{}	{extermination}	\N
胎児	たいじ	{}	{fetus}	\N
大使館	たいしかん	{}	{embassy}	\N
大した	たいした	{}	{"considerable; great; important; significant; a big deal"}	\N
大して	たいして	{}	{"(not so) much; (not) very"}	\N
対して	たいして	{}	{"for; in regard to; per"}	\N
大衆	たいしゅう	{}	{"general public"}	\N
対処	たいしょ	{}	{"deal with; cope"}	\N
対照	たいしょう	{}	{"contrast; antithesis; comparison"}	\N
対象	たいしょう	{行為の目標となるもの。めあて。「幼児をーとする絵本」「調査のー」}	{"object; subject; target"}	\N
対象外	たいしょうがい	{}	{"not covered (by); not subject (to); exempt"}	\N
退職	たいしょく	{}	{"retirement (from office)"}	\N
対人	たいじん	{}	{interpersonal}	\N
対人恐怖症	たいじんきょうふしょう	{}	{"social phobia"}	\N
対する	たいする	{}	{"face; confront; oppose"}	\N
体勢	たいせい	{からだの構え。姿勢。「崩れた―を立て直す」}	{"a posture; a physical position [stance]"}	\N
大勢	たいせい	{物事の一般的な傾向。大体の状況。「試合の―が決まる」「―に影響はない」}	{"〔大体の情勢〕the general situation; 〔大体の傾向〕the general trend; 〔世の中の趨勢(すうせい)〕the general tendency; 〔時代の風潮〕the current of the times"}	\N
態勢	たいせい	{}	{"attitude; conditions; preparations"}	\N
体制	たいせい	{各部分が統一的に組織されて一つの全体を形づくっている状態。「経営の―を立て直す」「厳戒―」}	{"order; system; structure; set-up; organization"}	\N
体積	たいせき	{}	{"capacity; volume"}	\N
大切	たいせつ	{}	{important}	\N
大戦	たいせん	{}	{"great war; great battle"}	\N
大層	たいそう	{}	{"very much; exaggerated; very fine"}	\N
体操	たいそう	{}	{"gymnastics; physical exercises; calisthenics"}	\N
対談	たいだん	{}	{"talk; dialogue; conversation"}	\N
隊長	たいちょう	{軍隊で、一隊の兵士の指揮権をもつ人。}	{"指導者〕a leader; a captain; 〔一般に，指揮する人〕a commander; 〔軍の〕a commanding officer"}	\N
大抵	たいてい	{}	{"usually; generally"}	\N
大敵	たいてき	{敵にむかうこと。敵として相対すること。敵対。「―する構えを見せる」}	{"〜する〔手向う〕turn [fight] against; 〔反対する〕oppose"}	\N
態度	たいど	{}	{attitude}	\N
対等	たいとう	{}	{equivalent}	\N
滞納	たいのう	{}	{"non-payment; default"}	\N
大半	たいはん	{}	{"majority; mostly; generally"}	\N
対比	たいひ	{}	{"contrast; comparison"}	\N
退避	たいひ	{その場所を退いて危険を避けること。避難。「津波の前に高台まで―する」}	{"take shelter ((in; under))"}	\N
大部	たいぶ	{}	{"most (e.g. most part); greater; fairly; a good deal; much"}	\N
台風	たいふう	{}	{typhoon}	\N
泰平	たいへい	{世の中が平和に治まり穏やかなこと。また、そのさま。「―の夢を破る」「―な（の）世」「天下―」}	{"(world) peace; tranquil (mood)"}	\N
対辺	たいへん	{}	{"(geometrical) opposite side"}	\N
大変	たいへん	{重大な事件。大変事。一大事。「国家の―」}	{"〔程度がはなはだしいこと〕〜な terrible; (口) awful"}	\N
逮捕	たいほ	{人の身体に直接力を加えて身柄を拘束すること。}	{"arrest; apprehension"}	\N
待望	たいぼう	{}	{"expectant waiting"}	\N
大木	たいぼく	{}	{"large tree"}	\N
怠慢	たいまん	{}	{"negligence; procrastination; carelessness"}	\N
対面	たいめん	{}	{"interview; meeting"}	\N
太陽	たいよう	{}	{"sun; solar"}	\N
平ら	たいら	{}	{"flatness; level; smooth; calm; plain"}	\N
大陸	たいりく	{}	{continent}	\N
対立	たいりつ	{}	{"confrontation; opposition; antagonism"}	\N
大量	たいりょう	{数量の多いこと。たくさんなこと。また、そのさま。多量。「―な（の）商品をさばく」⇔少量。}	{"bulk; large quantity; large-scale; mass"}	\N
体力	たいりょく	{}	{"physical strength"}	\N
対話	たいわ	{}	{"interactive; interaction; conversation; dialogue"}	\N
田植え	たうえ	{}	{"rice planting"}	\N
絶えず	たえず	{}	{constantly}	\N
倒す	たおす	{}	{"throw down; beat; bring down; blow down; fell; knock down; trip up; defeat; ruin; overthrow; kill; leave unpaid; cheat"}	\N
倒れる	たおれる	{}	{"fall down"}	\N
高	たか	{}	{"quantity; amount; volume; number; amount of money"}	\N
高い	たかい	{}	{"tall; high; expensive"}	\N
互い	たがい	{}	{"mutual; reciprocal"}	\N
高が	たかが	{程度・質・数量などが、取るに足りないさま。問題にするほどの価値のないさま。「―子供となめてかかる」「―一度の失敗」}	{"mere (child); trivial (sum); (he's) just (a)"}	\N
高まる	たかまる	{}	{"to rise; to swell; to be promoted"}	\N
高める	たかめる	{}	{"raise; lift; boost"}	\N
耕す	たがやす	{}	{"till; plow; cultivate"}	\N
宝	たから	{}	{treasure}	\N
滝	たき	{}	{waterfall}	\N
焚火	たきび	{}	{"(open) fire"}	\N
炊く	たく	{}	{"boil; cook"}	\N
宅	たく	{}	{"house; home; husband"}	\N
類	たぐい	{}	{"a kind"}	\N
沢山	たくさん	{数量の多いこと。また、そのさま。多数。副詞的にも用いる。「ーな（の）贈り物」「本をー持っている」}	{"〔数〕many (things; persons)，(文) many a (thing; person) a good [great] many; a large number of (things; persons)  ，(口) lots of ((things; persons)); 〔量〕much; plenty of; a good [great] deal of; a large quantity of，(口) lots of"}	\N
託す	たくす	{「たく（託）する」（サ変）の五段化。「将来に希望を―・す」}	{"entrust; ask to look after; ⇒あずける(預ける)，いたく(委託)"}	\N
託する	たくする	{自分がなすべきことを他の人に頼む。まかせる。「後事を友人に―・する」}	{"entrust; ask to look after; ⇒あずける(預ける)，いたく(委託)"}	\N
宅配	たくはい	{}	{"home delivery"}	\N
匠	たくみ	{細工師・大工など、手先や道具を使って物を作る職人。工匠。「飛騨のー」}	{"〜な〔熟練した〕skillful，((英)) skilful; 〔上手な〕good; 〔工夫をこらした，巧妙な〕ingenious"}	\N
巧み	たくみ	{細工師・大工など、手先や道具を使って物を作る職人。工匠。「飛騨のー」}	{"〜な〔熟練した〕skillful，((英)) skilful; 〔上手な〕good; 〔工夫をこらした，巧妙な〕ingenious"}	\N
蓄える	たくわえる	{}	{"to store"}	\N
竹	たけ	{}	{"bamboo; middle (of a three-tier ranking system)"}	\N
他国	たこく	{自分の国でない国。よその国。外国。}	{"〔外国〕a foreign country; 〔未知の土地〕a strange land"}	\N
確か	たしか	{}	{"sure; certain"}	\N
確かめる	たしかめる	{}	{ascertain}	\N
足し算	たしざん	{}	{addition}	\N
多少	たしょう	{}	{"more or less; somewhat; a little; some"}	\N
足す	たす	{}	{add}	\N
多数	たすう	{人や物の数が多いこと。「―の参拝客」「―の書物」「市民が―参加する」⇔少数。}	{"〜の a great many; a large number of; a lot of⇒たくさん(沢山)"}	\N
多数決	たすうけつ	{}	{"majority rule"}	\N
助かる	たすかる	{}	{"be saved; be rescued; survive; be helpful"}	\N
助け	たすけ	{}	{assistance}	\N
助ける	たすける	{}	{"help; save; rescue; give relief to; reinforce; promote; abet"}	\N
携わる	たずさわる	{}	{"to participate; to take part"}	\N
訪ねる	たずねる	{}	{visit}	\N
尋ねる	たずねる	{}	{ask}	\N
戦い	たたかい	{}	{"battle; fight; struggle; conflict"}	\N
闘い	たたかい	{}	{"battle; fight; struggle; conflict"}	\N
戦う	たたかう	{}	{"to fight; battle; combat; struggle against; wage war; engage in contest"}	\N
闘う	たたかう	{}	{"to fight; battle; combat; struggle against; wage war; engage in contest"}	\N
但し	ただし	{しかし。前述の事柄に対して、その条件や例外などを示す。}	{"but; however; given that; provided that"}	\N
ただし	但し	{しかし。前述の事柄に対して、その条件や例外などを示す。}	{"but; however; given that; provided that"}	\N
畳む	たたむ	{}	{"fold (clothes)"}	\N
只	ただ	{}	{"trivial matter"}	\N
正しい	ただしい	{道理にかなっている。事実に合っている。正確である。「―・い解答のしかた」「―・い内容」「公選法は―・くは公職選挙法という」}	{"〔正確な〕right; correct〔道理・規則・習慣などにかなっている〕proper; 〔判断などが当を得た〕right; just; 〔合法の〕lawful"}	\N
直ちに	ただちに	{}	{"at once; immediately; directly; in person"}	\N
漂う	ただよう	{}	{"to drift about; to float; to hang in air"}	\N
達	たち	{人を表す名詞や代名詞に付く。複数であることを表す。「子供―」「僕―」}	{"plural (for humans); 俺―：we；子供―：children"}	\N
立ち上がる	たちあがる	{}	{"stand up"}	\N
立方	たちかた	{}	{"dancing (geisha)"}	\N
立ち止まる	たちどまる	{}	{"stop; halt; stand still"}	\N
立場	たちば	{}	{"standpoint; position; situation"}	\N
立ち向かう	たちむかう	{正面から向かっていく。対抗する。「権力に―・う」}	{"〔敢然と直面する〕confront; 〔恐れず向かっていく〕stand up to (▼通例相手は人); 〔戦う〕fight against"}	\N
立ち寄る	たちよる	{}	{"to stop by; to drop in for a short visit"}	\N
立ち技	たちわざ	{柔道やレスリングで、立った姿勢で掛ける技。⇔寝技。}	{"standing technique"}	\N
建つ	たつ	{}	{"build; erect"}	\N
立つ	たつ	{}	{"to stand"}	\N
経つ	たつ	{}	{"pass; lapse"}	\N
発つ	たつ	{}	{"depart (on a plane; train; etc.)"}	\N
絶つ	たつ	{}	{"to sever; to cut off; to suppress; to abstain (from)"}	\N
卓球	たっきゅう	{}	{"table tennis"}	\N
達者	たっしゃ	{}	{"skillful; in good health"}	\N
達する	たっする	{}	{"reach; get to"}	\N
達成	たっせい	{}	{achievement}	\N
尊い	たっとい	{}	{"precious; valuable; priceless; noble; exalted; sacred"}	\N
貴い	たっとい	{}	{"precious; valuable; priceless; noble; exalted; sacred"}	\N
尊ぶ	たっとぶ	{}	{"to value; to prize; to esteem"}	\N
たっぷり	たっぷり	{満ちあふれるほど十分にあるさま。「―な水で麺 (めん) をゆでる」}	{"full; to hearts content; as much as you like"}	\N
竜巻	たつまき	{}	{tornado}	\N
縦	たて	{}	{"length; height"}	\N
盾	たて	{}	{"shield; buckler; escutcheon; pretext"}	\N
建前	たてまえ	{}	{"face; official stance; public position or attitude (as opposed to private thoughts)"}	\N
奉る	たてまつる	{}	{"to offer; to present; to revere; to do respectfully"}	\N
建物	たてもの	{}	{building}	\N
建てる	たてる	{}	{build}	\N
立てる	たてる	{}	{"raise; set up"}	\N
他動詞	たどうし	{}	{"transitive verb (direct obj)"}	\N
仮令	たとえ	{}	{"example; even if; if; though; although"}	\N
例え	たとえ	{}	{"example; even if; if; though; although"}	\N
例えば	たとえば	{}	{"for example"}	\N
例える	たとえる	{}	{"compare; use a simile"}	\N
辿り着く	たどりつく	{尋ね求めながら、やっと目的地に行き着く。}	{"arrive at; work your way to"}	\N
棚	たな	{}	{shelf}	\N
掌	たなごころ	{}	{"the palm"}	\N
谷	たに	{}	{valley}	\N
楽しい	たのしい	{}	{"pleasant; enjoyable; fun"}	\N
楽しみ	たのしみ	{}	{"pleasure; joy"}	\N
楽しむ	たのしむ	{}	{"to enjoy oneself"}	\N
楽む	たのしむ	{}	{"enjoyment; pleasure"}	\N
頼み	たのみ	{}	{"request; favor; reliance; dependence"}	\N
頼む	たのむ	{}	{"to request; ask"}	\N
頼もしい	たのもしい	{}	{"reliable; trustworthy; hopeful; promising"}	\N
束	たば	{}	{"bundle; bunch; sheaf; coil"}	\N
煙草	たばこ	{}	{"(pt:) (n) (uk) tobacco (pt: tabaco); cigarettes"}	\N
足袋	たび	{}	{"Japanese socks (with split toe)"}	\N
旅	たび	{}	{"travel; trip; journey"}	\N
度々	たびたび	{}	{"often; repeatedly; frequently"}	\N
多分	たぶん	{}	{"perhaps; probably"}	\N
食べ物	たべもの	{}	{food}	\N
食べる	たべる	{}	{eat}	\N
他方	たほう	{}	{"another side; different direction; (on) the other hand"}	\N
多忙	たぼう	{}	{"busy; pressure of work"}	\N
偶	たま	{}	{"even number; couple; man and wife; friend; same kind; doll; occasional; rare"}	\N
給う	たまう	{}	{"to receive; to grant"}	\N
卵	たまご	{}	{"egg(s); spawn; roe; (an expert) in the making"}	\N
偶々	たまたま	{}	{"casually; unexpectedly; accidentally; by chance"}	\N
偶に	たまに	{}	{"occasionally; once in a while"}	\N
玉葱	たまねぎ	{ユリ科ネギ属の野菜。}	{onion}	\N
堪らない	たまらない	{}	{"intolerable; unbearable; unendurable"}	\N
貯まる	たまる	{たくわえが多くなる。「資金が―・る」}	{"be saved"}	\N
賜る	たまわる	{}	{"to grant; to bestow"}	\N
民	たみ	{国家や社会を構成する人々。国民。}	{"people; citizen"}	\N
為	ため	{}	{"for; in order to"}	\N
為なら	ためなら	{「柔道の＿死んでもいい」}	{"for the sake of"}	\N
溜息	ためいき	{}	{"a sigh"}	\N
試し	ためし	{}	{"trial; test"}	\N
試す	ためす	{}	{"attempt; test"}	\N
貯める	ためる	{少しずつ集めて量をふやす。集めたものを減らさずに取っておく。集めたくわえる。「雨水を―・める」「目に涙を―・めて哀願する」}	{"save (e.g. money)"}	\N
保つ	たもつ	{}	{"to keep; to preserve; to hold; to retain; to maintain; to support; to sustain; to last; to endure; to keep well (food); to wear well; to be durable"}	\N
容易い	たやすい	{}	{"easy; simple; light"}	\N
多様	たよう	{}	{"diversity; variety"}	\N
便り	たより	{}	{"news; tidings; information; correspondence; letter"}	\N
頼る	たよる	{}	{"rely on; have recourse to; depend on"}	\N
足りる	たりる	{}	{"be sufficient; be enough"}	\N
足る	たる	{}	{"be sufficient; be enough"}	\N
垂れる	たれる	{}	{"to hang; to droop; to drop; to lower; to pull down; to dangle; to sag; to drip; to ooze; to trickle; to leave behind (at death); to give; to confer"}	\N
戯れる	たわむれる	{遊び興じる。何かを相手にして、おもしろがって遊ぶ。「子犬が―・れる」「波と―・れる」}	{"〔遊び興じる〕play (e.g. with a dog)〔ふざける〕(tease) in jest〔いちゃつく〕flirt"}	\N
反	たん	{}	{"roll of cloth (c. 10 yds.); .245 acres; 300 tsubo"}	\N
単位	たんい	{}	{"unit; denomination; credit (in school)"}	\N
単一	たんいつ	{}	{"single; simple; sole; individual; unitory"}	\N
短歌	たんか	{}	{"tanka; 31-syllable Japanese poem"}	\N
担架	たんか	{}	{"stretcher; litter"}	\N
嘆願	たんがん	{}	{plea}	\N
嘆願書	たんがんしょ	{}	{petition}	\N
短気	たんき	{}	{"quick temper"}	\N
短期	たんき	{}	{"short term"}	\N
探検	たんけん	{}	{"exploration; expedition"}	\N
単語	たんご	{}	{"word; vocabulary; (usually) single-character word"}	\N
炭鉱	たんこう	{}	{"coal mine"}	\N
探索	たんさく	{未知の事柄などをさぐり調べること。「古代史の謎を―する」「海底を―する」}	{"a search"}	\N
短縮	たんしゅく	{}	{"shortening; abbreviation; reduction"}	\N
単純	たんじゅん	{}	{simplicity}	\N
短所	たんしょ	{}	{"defect; demerit; weak point; disadvantage"}	\N
誕生	たんじょう	{}	{birth}	\N
誕生日	たんじょうび	{}	{birthday}	\N
淡水	たんすい	{}	{"fresh water"}	\N
炭水化物	たんすいかぶつ	{}	{carbohydrates}	\N
単数	たんすう	{}	{"singular (number)"}	\N
炭素	たんそ	{}	{"carbon (C)"}	\N
短大	たんだい	{}	{"junior college"}	\N
淡々	たんたん	{感じなどが、あっさりしているさま}	{"unconcerned; dispassion"}	\N
単調	たんちょう	{}	{"monotony; monotone; dullness"}	\N
探偵	たんてい	{他人の行動・秘密などをひそかにさぐること。また、それを職業とする人。「一日の動きを―する」「私立―」}	{"〔行為〕detective work; covert investigation; 〔人〕a detective"}	\N
担当	たんとう	{一定の事柄を受け持つこと。「営業部門を―する」「―者」}	{"(in) charge (of); responsibility"}	\N
単独	たんどく	{}	{"sole; independence; single; solo (flight)"}	\N
単なる	たんなる	{それだけで、ほかに何も含まないさま。ただの。}	{"mere; simple"}	\N
単に	たんに	{}	{"simply; merely; only; solely"}	\N
堪能	たんのう	{技芸に優れていること}	{"be skilled/proficient (in)"}	\N
短波	たんぱ	{}	{"short wave"}	\N
蛋白質	たんぱくしつ	{}	{protein}	\N
短編	たんぺん	{}	{"short (e.g. story; film)"}	\N
田ぼ	たんぼ	{}	{"paddy field; farm"}	\N
端末	たんまつ	{}	{terminal}	\N
手	て	{}	{hand}	\N
手当て	てあて	{}	{"allowance; compensation; treatment; medical care"}	\N
手洗い	てあらい	{}	{"restroom; lavatory; hand-washing"}	\N
艇	てい	{細長い小舟}	{"a boat"}	\N
提案	ていあん	{議案や意見を提出すること。また、その議案や意見。「具体策を―する」「―者」}	{"proposal; proposition; suggestion"}	\N
定員	ていいん	{}	{"fixed number of regular personnel; capacity (of boat; hall; aeroplane; etc.)"}	\N
庭園	ていえん	{計画的に草木・池などを配し、整えられた庭。「日本―」「屋上―」}	{"a garden"}	\N
低下	ていか	{}	{"decline; deterioration"}	\N
定価	ていか	{}	{"established price"}	\N
定期	ていき	{}	{"fixed term"}	\N
定義	ていぎ	{物事の意味・内容を他と区別できるように、言葉で明確に限定すること。「敬語の用法をーする」}	{definition}	\N
定期券	ていきけん	{}	{"commuter pass; season ticket"}	\N
定休日	ていきゅうび	{}	{"regular holiday"}	\N
提供	ていきょう	{金品・技能などを相手に役立ててもらうために差し出すこと。申し出。「場所を―する」「血液を―する」}	{"offer; provide"}	\N
提携	ていけい	{}	{"cooperation; tie-up; joint business; link-up"}	\N
低血圧	ていけつあつ	{血圧が持続的に異常に低い状態。一般に、最大血圧100ミリ水銀柱以下をいう。→高血圧}	{"low blood pressure"}	\N
抵抗	ていこう	{}	{"electrical resistance; resistance; opposition"}	\N
体裁	ていさい	{}	{"decency; style; form; appearance; show; get-up; format"}	\N
停止	ていし	{}	{"suspension; interruption; stoppage; ban; standstill; deadlock; stalemate; abeyance"}	\N
提示	ていじ	{}	{"presentation; exhibit; suggest; citation"}	\N
停車	ていしゃ	{}	{"stopping (e.g. train)"}	\N
提出	ていしゅつ	{書類・資料などを、ある場所、特に公 (おおやけ) の場に差し出すこと。「議案の―」「レポートを―する」「辞表を―する」}	{"presentation ((of)); 〔議案などの〕introduction (of; to; into); submission; filing"}	\N
提唱	ていしょう	{意見・主張などを唱え、発表すること。「改革をーする」}	{"proposal; advocation"}	\N
定食	ていしょく	{}	{"set meal; special (of the day)"}	\N
逓信	ていしん	{}	{communications}	\N
訂正	ていせい	{}	{"correction; revision"}	\N
停滞	ていたい	{}	{"stagnation; tie-up; congestion; retention; accumulation; falling into arrears"}	\N
邸宅	ていたく	{}	{"mansion; residence"}	\N
停電	ていでん	{}	{"failure of electricity"}	\N
程度	ていど	{}	{"degree; amount; grade; standard; of the order of (following a number)"}	\N
丁寧	ていねい	{}	{"polite; courteous"}	\N
定年	ていねん	{}	{"retirement age"}	\N
堤防	ていぼう	{}	{"bank; weir"}	\N
低迷	ていめい	{低くただようこと。「暗雲―」}	{"(clouds) hanging over; threatening"}	\N
停留所	ていりゅうじょ	{}	{"bus or tram stop"}	\N
手入れ	ていれ	{}	{"repairs; maintenance"}	\N
手遅れ	ておくれ	{}	{"too late; belated treatment"}	\N
て居ります	て居ります	{「…ている」の丁寧な言い方。「ただ今、外出して―・ります」}	{"～ており is equivalent to ～ていて (which itself comes from ～ている; e.g. 書いている; 'currently writing')"}	\N
手掛かり	てがかり	{}	{"contact; trail; scent; on hand; hand hold; clue; key"}	\N
手掛ける	てがける	{}	{"to handle; to manage; to work with; to rear; to look after; to have experience with"}	\N
手数	てかず	{}	{"number of moves; trouble"}	\N
手紙	てがみ	{}	{letter}	\N
手軽	てがる	{手数がかからず、簡単なさま。「―な食事」「―に扱えるカメラ」}	{"easy; simple; informal; offhand; cheap"}	\N
適応	てきおう	{}	{"adaptation; accommodation; conformity"}	\N
的確	てきかく	{}	{"precise; accurate"}	\N
適確	てきかく	{}	{"precise; accurate"}	\N
適宜	てきぎ	{}	{suitability}	\N
適する	てきする	{}	{"fit; suit"}	\N
適性	てきせい	{}	{aptitude}	\N
適切	てきせつ	{}	{"pertinent; appropriate; adequate; relevance"}	\N
適度	てきど	{}	{moderate}	\N
適当	てきとう	{}	{appropriate}	\N
適用	てきよう	{}	{applying}	\N
手際	てぎわ	{}	{"performance; skill; tact"}	\N
手首	てくび	{}	{wrist}	\N
手頃	てごろ	{}	{"moderate; handy"}	\N
手品	てじな	{}	{"sleight of hand; conjuring trick; magic; juggling"}	\N
手順	てじゅん	{}	{"process; procedure; protocol"}	\N
手錠	てじょう	{}	{"handcuffs; manacles"}	\N
手助け	てだすけ	{他の人の仕事などを助けること。手伝うこと。また、その人。「いくらか―になる」「母を―する」}	{"(give) help; assistance"}	\N
手近	てぢか	{}	{"near; handy; familiar"}	\N
手帳	てちょう	{}	{notebook}	\N
鉄	てつ	{}	{iron}	\N
撤回	てっかい	{いったん提出・公示したものなどを、取り下げること}	{"withdrawal; retreat; reinstate"}	\N
哲学	てつがく	{}	{philosophy}	\N
哲学者	てつがくしゃ	{}	{philosopher}	\N
鉄橋	てっきょう	{}	{"railway bridge; iron bridge"}	\N
鉄拳	てっけん	{}	{"iron fist"}	\N
鉄鋼	てっこう	{}	{"iron and steel"}	\N
徹する	てっする	{}	{"to sink in; to penetrate; to devote oneself; to believe in; to go through; to do intently and exclusively"}	\N
撤退	てったい	{}	{retreat}	\N
手伝い	てつだい	{}	{"help; helper; assistant"}	\N
手伝う	てつだう	{}	{help}	\N
手続き	てつづき	{}	{"procedure; (legal) process; formalities"}	\N
徹底	てってい	{中途半端でなく一貫していること。「―した利己主義者」}	{"〜した 〔徹底的にやる〕thoroughgoing; 〔根っからの〕out-and-out; 〔度し難い〕incorrigible; 〔どうしようもない〕hopeless"}	\N
鉄道	てつどう	{}	{railroad}	\N
鉄片	てっぺん	{}	{"iron scraps"}	\N
鉄砲	てっぽう	{}	{gun}	\N
徹夜	てつや	{}	{"all night; all-night vigil; sleepless night"}	\N
手並み	てなみ	{腕前。技量。「おー拝見」}	{skill}	\N
手拭い	てぬぐい	{}	{"(hand) towel"}	\N
手の施しようがない	てのほどこしようがない	{処置のしようがない}	{"beyond help; there's nothing that can be done"}	\N
手配	てはい	{}	{"arrangement; search (by police)"}	\N
手筈	てはず	{}	{"arrangement; plan; programme"}	\N
手引き	てびき	{}	{"guidance; guide; introduction"}	\N
手袋	てぶくろ	{}	{gloves}	\N
手本	てほん	{}	{"model; pattern"}	\N
手間	てま	{}	{"time; labour"}	\N
手前	てまえ	{}	{"before; this side; we; you"}	\N
手回し	てまわし	{}	{"preparations; arrangements"}	\N
手元	てもと	{}	{"on hand; at hand; at home"}	\N
寺	てら	{}	{temple}	\N
照らす	てらす	{}	{"shine on; illuminate"}	\N
照り返す	てりかえす	{}	{"to reflect; to throw back light"}	\N
照る	てる	{}	{shine}	\N
手分け	てわけ	{}	{"division of labour"}	\N
点	てん	{}	{"point; mark; grade"}	\N
店員	てんいん	{}	{salesclerk}	\N
点火	てんか	{}	{"ignition; lighting; set fire to"}	\N
転回	てんかい	{}	{"revolution; rotation"}	\N
展開	てんかい	{}	{"develop; expansion (opposite of compression)"}	\N
天涯	てんがい	{}	{"horizon; distant land; skyline; heavenly shores; remote region"}	\N
転換	てんかん	{}	{"convert; divert"}	\N
典雅	てんが	{}	{grace}	\N
天気	てんき	{}	{"weather; the elements; fine weather"}	\N
転居	てんきょ	{}	{"moving; changing residence"}	\N
天気予報	てんきよほう	{}	{"weather forecast"}	\N
転勤	てんきん	{}	{"transfer; transmission"}	\N
典型	てんけい	{}	{"type; pattern; archetypal"}	\N
点検	てんけん	{}	{"inspection; examination; checking"}	\N
転校	てんこう	{}	{"change schools"}	\N
天候	てんこう	{}	{weather}	\N
天国	てんごく	{}	{"paradise; heaven; Kingdom of Heaven"}	\N
天災	てんさい	{}	{"natural calamity; disaster"}	\N
天才	てんさい	{}	{"genius; prodigy; natural gift"}	\N
展示	てんじ	{}	{"exhibition; display"}	\N
天守	てんしゅ	{城の本丸に築かれた最も高い物見やぐら。・・閣。}	{"a castle tower [keep]; a donjon"}	\N
天守閣	てんしゅかく	{城の本丸に築かれた最も高い物見やぐら。}	{"a castle tower [keep]; a donjon"}	\N
天井	てんじょう	{}	{"ceiling; ceiling price"}	\N
転じる	てんじる	{}	{"to turn; to shift; to alter; to distract"}	\N
点数	てんすう	{}	{"marks; points; score; number of items; credits"}	\N
点線	てんせん	{}	{"dotted line; perforated line"}	\N
天体	てんたい	{}	{"heavenly body"}	\N
点々	てんてん	{}	{"here and there; little by little; sporadically; scattered in drops; dot; spot"}	\N
転々	てんてん	{}	{"rolling about; moving from place to place; being passed around repeatedly"}	\N
店舗	てんぽ	{商品を並べて売るための建物。みせ。「―を広げる」「大型―」}	{みせ(店)，しょうてん(商店)}	\N
転任	てんにん	{}	{"change of post"}	\N
天然	てんねん	{}	{"nature; spontaneity"}	\N
転覆	てんぷく	{}	{capsize}	\N
展望	てんぼう	{}	{"view; outlook; prospect"}	\N
転落	てんらく	{}	{"fall; degradation; slump"}	\N
展覧会	てんらんかい	{}	{exhibition}	\N
問い	とい	{}	{"question; query"}	\N
問い合わせ	といあわせ	{}	{enquiry}	\N
問い合わせる	といあわせる	{}	{"to enquire; to seek information"}	\N
問屋	といや	{}	{"wholesale store"}	\N
塔	とう	{}	{"tower; pagoda"}	\N
棟	とう	{むねの長い建物。大きい建物。}	{"place; section; building"}	\N
党	とう	{}	{"party (political); faction; -ite"}	\N
問う	とう	{}	{"to ask; to question; to charge (i.e. with a crime); to accuse; without regard to (neg)"}	\N
答案	とうあん	{}	{"examination paper; examination script"}	\N
統一	とういつ	{}	{"unity; consolidation; uniformity; unification; compatible"}	\N
東欧	とうおう	{}	{"Eastern Europe"}	\N
当該	とうがい	{}	{"the (above said)"}	\N
唐辛子	とうがらし	{}	{"cayenne pepper; red pepper"}	\N
冬季	とうがん	{冬の季節。冬のシーズン。冬。「―料金」}	{"winter; wintertime; the winter season"}	\N
冬瓜	とうがん	{ウリ科の蔓性 (つるせい) の一年草。茎に巻きひげがあり、葉は手のひら状に裂けている。}	{"(a white gourd-melon; a wax gourd)"}	\N
陶器	とうき	{}	{"pottery; ceramics"}	\N
討議	とうぎ	{}	{"debate; discussion"}	\N
等級	とうきゅう	{}	{"grade; class"}	\N
峠	とうげ	{}	{"ridge; (mountain) pass; difficult part"}	\N
統計	とうけい	{}	{statistics}	\N
統計者	とうけいしゃ	{}	{statistician}	\N
統計学	とうけいがく	{確率論を基盤にして、集団全体の性質を一部の標本を調べることによって推定するための処理・分析方法について研究する学問。}	{"statistics; statistical"}	\N
登校	とうこう	{}	{"attendance (at school)"}	\N
投稿	とうこう	{インターネット上の決められた場所で、文章・画像・動画などを公開すること。特に、ブログ・簡易ブログ・SNS・BBSなどに文章や画像を掲載したり、動画共有サービスに動画のデータをアップロードしたりすることを指す。}	{"submission; posting"}	\N
統合	とうごう	{}	{"integration; unification; synthesis"}	\N
投稿欄	とうこうらん	{}	{"a readers' [contributors'] column; a letter-to-the-editor column"}	\N
搭載	とうさい	{機器・自動車などに、ある装備や機能を組み込むこと}	{"powered by; loading on board (e.g. missile on a boat)"}	\N
東西	とうざい	{}	{"East and West; Orient and Occident; whole country; Your attention; please!"}	\N
倒産	とうさん	{}	{"(corporate) bankruptcy; insolvency"}	\N
投資	とうし	{}	{investment}	\N
当時	とうじ	{}	{"at that time; in those days"}	\N
戸	と	{}	{"door (Japanese style)"}	\N
統治	とうじ	{}	{"rule; reign; government; governing"}	\N
陶磁器	とうじき	{}	{pottery}	\N
当日	とうじつ	{}	{"appointed day"}	\N
東芝	とうしば	{}	{Toshiba}	\N
投書	とうしょ	{}	{"letter to the editor; letter from a reader; contribution"}	\N
当初	とうしょ	{そのことのはじめ。最初。また、その時期。「―の計画」「―組まれた予算」}	{"(at) first/beginning; original (goal)"}	\N
登場	とうじょう	{}	{"entry (on stage); appearance (on screen); entrance; introduction (into a market)"}	\N
統制	とうせい	{多くの物事を一つにまとめておさめること。管理}	{"(スル) control; place ((a thing)) under one's control; regulate"}	\N
当選	とうせん	{}	{"being elected; winning the prize"}	\N
統率	とうそつ	{}	{"command; lead; generalship; leadership"}	\N
灯台	とうだい	{}	{lighthouse}	\N
到達	とうたつ	{}	{"reaching; attaining; arrival"}	\N
到底	とうてい	{どうやってみても。どうしても。つまるところ。つまり。}	{"absolutely; most; utterly; simply; possibly"}	\N
到着	とうちゃく	{目的地などに行きつくこと。到達。}	{arrival}	\N
丁々	とうとう	{}	{"clashing of swords; felling of trees; ringing of an ax"}	\N
等々	とうとう	{}	{etc.}	\N
党内	とうない	{政党の内部。仲間うち。}	{"inside party; intraparty; internal party (reasons)"}	\N
盗難	とうなん	{}	{"theft; robbery"}	\N
投入	とうにゅう	{}	{"throw; investment; making (an electrical circuit)"}	\N
糖尿病	とうにょうびょう	{}	{diabetes}	\N
当人	とうにん	{}	{"the one concerned; the said person"}	\N
当番	とうばん	{}	{"being on duty"}	\N
逃避	とうひ	{困難などに直面したとき逃げたり、意識しないようにしたりして、それを避けること。「現実から―する」}	{"escape; flight (perfom flee)"}	\N
投票	とうひょう	{}	{"voting; poll"}	\N
豆腐	とうふ	{}	{Tofu}	\N
等分	とうぶん	{}	{"division into equal parts"}	\N
謄本	とうほん	{原本の内容を全部写して作った文書。戸籍謄本・登記簿謄本など。→抄本}	{"a (certified) copy; a transcript"}	\N
逃亡	とうぼう	{}	{escape}	\N
冬眠	とうみん	{}	{"hibernation; winter sleep"}	\N
透明	とうめい	{すきとおって向こうがよく見えること。物体が光をよく通すこと。}	{"transparency; cleanness"}	\N
灯油	とうゆ	{}	{"lamp oil; kerosene"}	\N
東洋	とうよう	{}	{Orient}	\N
登用	とうよう	{}	{任命(昇進appointment)}	\N
棟梁	とうりょう	{一族・一門の統率者。集団のかしら。頭領。また、一国を支える重職。武家の統率者のこと。}	{"leader (e.g. of a clan; group of carpenters etc.)"}	\N
登録	とうろく	{}	{"registration; register; entry; record"}	\N
討論	とうろん	{}	{"debate; discussion"}	\N
遠い	とおい	{}	{"far; distant"}	\N
十日	とおか	{}	{"ten days; the tenth day of the month"}	\N
遠く	とおく	{}	{far}	\N
遠ざかる	とおざかる	{}	{"to go far off"}	\N
通す	とおす	{}	{"let pass; overlook; continue; keep; make way for; persist in"}	\N
遠回り	とおまわり	{}	{"detour; roundabout way"}	\N
通り	とおり	{}	{"street; road"}	\N
通り掛かる	とおりかかる	{}	{"happen to pass by"}	\N
通りかかる	とおりかかる	{}	{"to happen to pass by"}	\N
通り過ぎる	とおりすぎる	{}	{"pass; pass through"}	\N
都会	とかい	{}	{city}	\N
兎角	とかく	{}	{"anyhow; anyway; somehow or other; generally speaking; in any case; this and that; many; be apt to"}	\N
溶かす	とかす	{}	{"melt; dissolve"}	\N
時	とき	{}	{"time; hour; occasion; moment"}	\N
時折	ときおり	{}	{sometimes}	\N
時々	ときどき	{}	{sometimes}	\N
解き放つ	ときはなつ	{つながっているものをほどいて別々にする。}	{"set free; let loose; unleash"}	\N
跡切れる	とぎれる	{}	{"to pause; to be interrupted"}	\N
十	とお	{}	{"10; ten"}	\N
奴	やつ	{}	{dude}	\N
逃走	とうそう	{にげること。にげ去ること。遁走 (とんそう) 。「その場から―する」}	{"flight; desertion; escape"}	\N
説く	とく	{}	{"to explain; to advocate; to preach; to persuade"}	\N
溶く	とく	{}	{"dissolve (e.g. paint)"}	\N
研ぐ	とぐ	{}	{"to sharpen; to grind; to scour; to hone; to polish; to wash (rice)"}	\N
得意	とくい	{}	{"pride; triumph; prosperity; one´s strong point; one´s forte; one´s specialty; customer; client"}	\N
得意技	とくいわざ	{}	{"signature move (assoc. with a martial artist; wrestler; etc.); finishing move"}	\N
特技	とくぎ	{}	{"special skill"}	\N
特産	とくさん	{}	{"specialty; special product"}	\N
特殊	とくしゅ	{}	{"special; unique"}	\N
特集	とくしゅう	{}	{"feature (e.g. newspaper); special edition; report"}	\N
特色	とくしょく	{}	{"characteristic; feature"}	\N
特長	とくちょう	{}	{"forte; merit"}	\N
特徴	とくちょう	{}	{"feature; characteristic"}	\N
特定	とくてい	{}	{"specific; special; particular"}	\N
得点	とくてん	{}	{"score; points made; marks obtained; runs"}	\N
特に	とくに	{}	{specially}	\N
特派	とくは	{}	{"send specially; special envoy"}	\N
特売	とくばい	{}	{"special sale"}	\N
特別	とくべつ	{}	{special}	\N
匿名	とくめい	{}	{"anonymity; pseudonym"}	\N
特命	とくめい	{特別の命令・任命。「ーを帯びる」}	{"special mission"}	\N
特有	とくゆう	{}	{"characteristic (of); peculiar (to)"}	\N
刺	とげ	{}	{"thorn; splinter; spine; biting words"}	\N
朿	とげ	{}	{"thorn; splinter; spine; biting words"}	\N
棘	とげ	{}	{"thorn; splinter; spine; biting words"}	\N
溶け合う	とけあう	{とけて、まざり合い一つになる。「―・わない物質」}	{"〔溶けて入り混じる〕melt together"}	\N
時計	とけい	{}	{"watch; clock"}	\N
溶け込む	とけこむ	{}	{"melt into"}	\N
溶ける	とける	{}	{"melt; thaw; fuse; dissolve"}	\N
解ける	とける	{}	{loosen}	\N
遂げる	とげる	{}	{"to accomplish; to achieve; to carry out"}	\N
床に就く	とこにつく	{寝床に入る。就寝する。「毎晩早く―・く」}	{"go to bed"}	\N
床の間	とこのま	{}	{alcove}	\N
床屋	とこや	{}	{barber}	\N
所	ところ	{}	{place}	\N
所が	ところが	{}	{"however; while; even if"}	\N
所で	ところで	{}	{"by the way; even if; no matter what"}	\N
登山	とざん	{}	{"mountain climbing"}	\N
都市	とし	{}	{"town; city; municipal; urban"}	\N
年	とし	{}	{year}	\N
年上	としうえ	{年齢が上であること。また、その人。年長。年嵩 (としかさ) 。⇔年下。}	{"(three years) older (than); (a wife) older (than oneself)"}	\N
年頃	としごろ	{}	{"age; marriageable age; age of puberty; adolescence; for some years"}	\N
戸締り	とじまり	{}	{"closing up; fastening the doors"}	\N
図書	としょ	{}	{books}	\N
途上	とじょう	{}	{"en route; half way"}	\N
図書館	としょかん	{}	{library}	\N
年寄り	としより	{}	{"old people; the aged"}	\N
閉じる	とじる	{}	{"close (e.g. book; eyes; meeting; etc.); shut"}	\N
都心	としん	{}	{"heart of city"}	\N
渡世	とせい	{}	{"making a living; earning a livelihood"}	\N
途絶える	とだえる	{}	{"to stop; to cease; to come to an end"}	\N
戸棚	とだな	{}	{"cupboard; locker; closet; wardrobe"}	\N
途端	とたん	{}	{"just (now; at the moment; etc.)"}	\N
土地	とち	{}	{"plot of land; lot; soil"}	\N
特急	とっきゅう	{}	{"limited express (train; faster than an express)"}	\N
特許	とっきょ	{}	{"special permission; patent"}	\N
特権	とっけん	{}	{"privilege; special right"}	\N
とっく	疾っく	{ずっと以前。とう。「―からここに住んでいる」}	{"long ago"}	\N
解く	とく	{筋道をたどって解答を出す。「問題を―・く」}	{"solve; answer; unravel; untie"}	\N
とっくに	疾っくに	{ずっと前に。とうに。「食事は―に済ませた」}	{"long ago; (had) long since (forgotten); (is) well (past 12); (is) well (over 60);"}	\N
突如	とつじょ	{}	{"suddenly; all of a sudden"}	\N
突然	とつぜん	{}	{"abruptly; suddenly; unexpectedly; all at once"}	\N
当然	とつぜん	{それがあたりまえであるさま。もちろん}	{"only natural .. of course; ought to; deserves; proper; naturally"}	\N
取っ手	とって	{}	{"handle; grip; knob"}	\N
突破	とっぱ	{}	{"breaking through; breakthrough; penetration"}	\N
届く	とどく	{送った品物や郵便物が相手の所に着く。到着する「母から便りがー・く」}	{"reach; receive; arrive"}	\N
届け	とどけ	{}	{"report; notification; registration"}	\N
届ける	とどける	{}	{deliver}	\N
滞る	とどこおる	{}	{"to stagnate; to be delayed"}	\N
整う	ととのう	{}	{"be prepared; be in order; be put in order; be arranged"}	\N
整える	ととのえる	{}	{"to put in order; to get ready; to arrange; to adjust"}	\N
留める	とどめる	{}	{"to stop; to cease; to put an end to"}	\N
と共に	とともに	{…と一緒に。「友人―学ぶ」}	{"along with"}	\N
都内	とない	{}	{"inner-metropolis; inner-city"}	\N
唱える	となえる	{}	{"to recite; to chant; to call upon"}	\N
隣	となり	{}	{"next to; next door to"}	\N
とにかく	兎に角	{他の事柄は別問題としてという気持ちを表す。何はともあれ。いずれにしても。ともかく。「―話すだけ話してみよう」「間に合うかどうか、―行ってみよう」}	{"anyhow; in any case; anyway"}	\N
殿様	とのさま	{}	{"feudal lord"}	\N
飛ばす	とばす	{}	{"skip over; omit"}	\N
帳	とばり	{}	{curtain}	\N
飛び	とび	{}	{jump}	\N
飛び越える	とびこえる	{}	{"to jump over"}	\N
飛び込む	とびこむ	{}	{"jump in; leap in; plunge into; dive"}	\N
飛び出す	とびだす	{}	{"jump out; rush out; fly out; appear suddenly; protrude; project"}	\N
扉	とびら	{}	{"door; opening"}	\N
跳ぶ	とぶ	{}	{"jump; fly; leap; spring; bound; hop"}	\N
飛ぶ	とぶ	{空中を移動する。飛行する。「鳥が＿・ぶ」}	{"jump; fly; leap; spring; bound; hop"}	\N
徒歩	とほ	{}	{"walking; going on foot"}	\N
乏しい	とぼしい	{}	{"meagre; scarce; limited; destitute; hard up; scanty; poor"}	\N
戸惑い	とまどい	{手段や方法がわからなくてどうしたらよいか迷うこと。「―を感じる」「―の表情を見せる」}	{〔方向が分からないこと〕confusion}	\N
泊まる	とまる	{宿泊する。停泊する。「宿直室にー・まる」「友達を家にー・める」「船が港にー・まる」}	{"stay at (e.g. hotel)"}	\N
停まる	とまる	{「一時的な中断」特に車などの場合、を意味します。停止・停車・調停する。}	{"to halt (espeically a vehicle)"}	\N
富	とみ	{}	{"wealth; fortune"}	\N
富む	とむ	{}	{"to be rich; to become rich"}	\N
泊める	とめる	{宿泊する。停泊する。「宿直室にー・まる」「友達を家にー・める」「船が港にー・まる」}	{"stay at (e.g. hotel)"}	\N
友	とも	{}	{"friend; companion; pal"}	\N
共稼ぎ	ともかせぎ	{}	{"working together; (husband and wife) earning a living together"}	\N
友達	ともだち	{}	{friend}	\N
伴う	ともなう	{}	{"to accompany; to bring with; to be accompanied by; to be involved in"}	\N
共に	ともに	{}	{"sharing with; participate in; both; alike; together; along with; with; including"}	\N
共働き	ともばたらき	{}	{"dual income"}	\N
捕らえる	とらえる	{}	{"to seize; to grasp; to capture; to arrest"}	\N
捕える	とらえる	{}	{"seize; grasp; capture; arrest"}	\N
融資	ゆうし	{}	{"financing; loan"}	\N
止まる	とどまる	{}	{"to be limited to"}	\N
留まる	とどまる	{}	{"remain; abide; stay (in the one place); come to a halt; be limited to; stop"}	\N
取り上げる	とりあげる	{}	{"take up; pick up; disqualify; confiscate; deprive"}	\N
取り扱い	とりあつかい	{}	{"treatment; service; handling; management"}	\N
取り扱う	とりあつかう	{}	{"to treat; to handle; to deal in"}	\N
鳥居	とりい	{}	{"torii (Shinto shrine archway)"}	\N
取り入れる	とりいれる	{}	{"harvest; take in; adopt"}	\N
取り押さえる	とりおさえる	{犯人をつかまえる。とらえる。「泥棒を―・える」「密売の現場を―・える」}	{"〔逮捕する〕arrest; capture"}	\N
取り替え	とりかえ	{}	{"swap; exchange"}	\N
取り替える	とりかえる	{}	{exchange}	\N
取り組む	とりくむ	{}	{"to tackle; to wrestle with; to engage in a bout; to come to grips with"}	\N
取り消す	とりけす	{}	{cancel}	\N
取り下げる	とりさげる	{}	{??}	\N
取締まり	とりしまり	{不正や不法が行われないように監視すること。管理・監督すること。「管内の―にあたる」}	{"control; management; supervision"}	\N
取り締まり	とりしまり	{不正や不法が行われないように監視すること。管理・監督すること。}	{"control; management; supervision"}	\N
取り締まる	とりしまる	{不正や不法が行われないように監視する。管理・監督する。「違法行為を―・る」}	{"to manage; to control; to supervise"}	\N
取り調べ	とりしらべ	{特に、捜査機関が、被疑者や参考人の出頭を求めて犯罪に関する事情を聴取すること。尋問}	{"取り調べること。 interrogation; examination; inquiry"}	\N
取り調べる	とりしらべる	{}	{"to investigate; to examine"}	\N
取り出す	とりだす	{}	{"take out; produce; pick out"}	\N
取り立てる	とりたてる	{}	{"to collect; to extort; to appoint; to promote"}	\N
取り次ぐ	とりつぐ	{}	{"to act as an agent for; to announce (someone); to convey (a message)"}	\N
取り除く	とりのぞく	{}	{"to remove; to take away; to set apart"}	\N
取り引き	とりひき	{}	{"transactions; dealings; business"}	\N
取り巻く	とりまく	{}	{"to surround; to circle; to enclose"}	\N
取り混ぜる	とりまぜる	{}	{"to mix; to put together"}	\N
取り戻す	とりもどす	{}	{"to take back; to regain"}	\N
塗料	とりょう	{}	{paint}	\N
取り寄せる	とりよせる	{}	{"to order; to send away for"}	\N
取り分	とりわけ	{}	{"especially; above all"}	\N
採る	とる	{}	{"adopt (measure; proposal); pick (fruit); assume (attitude)"}	\N
取る	とる	{}	{"take; pick up; harvest; earn; choose"}	\N
撮る	とる	{}	{"take (a photo); make (a film)"}	\N
捕る	とる	{}	{"take; catch (fish); capture"}	\N
取れる	とれる	{}	{"come off; be taken off; be removed; be obtained; leave; come out (e.g. photo); be interpreted"}	\N
繋がる	つながる	{一緒にする}	{"unite; be connected; be tied together"}	\N
摘み	つまみ	{選び・取り}	{picked}	\N
強者	つわもの	{強い者。他にまさる力や権力をもつ者。「―の論理」反：弱者。}	{"a strong man"}	\N
強者揃い	つわものぞろい	{すごく強い}	{"incredibily skilled"}	\N
追加	ついか	{}	{"addition; supplement; appendix"}	\N
追及	ついきゅう	{}	{"gaining on; carrying out; solving (crime)"}	\N
追従	ついじゅう	{あとにつき従うこと}	{"complience; follow"}	\N
追跡	ついせき	{}	{pursuit}	\N
次いで	ついで	{}	{"next; secondly; subsequently"}	\N
追悼	ついとう	{死者の生前をしのんで、悲しみにひたること。}	{mourning}	\N
遂に	ついに	{長い時間ののちに、最終的にある結果に達するさま。とうとう。しまいに。「ー優勝を果たした」「ー完成した」「疲れ果ててー倒れた」}	{"finally; at last"}	\N
追放	ついほう	{}	{"exile; banishment"}	\N
費やす	ついやす	{}	{"to spend; to devote; to waste"}	\N
墜落	ついらく	{}	{"falling; crashing"}	\N
通	つう	{}	{"connoisseur; counter for letters"}	\N
通貨	つうか	{}	{currency}	\N
通過	つうか	{}	{"passage through; passing"}	\N
通学	つうがく	{}	{"commuting to school"}	\N
痛感	つうかん	{}	{"feeling keenly; fully realizing"}	\N
通勤	つうきん	{}	{"commuting to work"}	\N
一日	ついたち	{}	{"first day of month"}	\N
通行	つうこう	{}	{"passage; passing"}	\N
通じる	つうじる	{何かを伝って到達する。また、届かせる。「電話がー・ずる」}	{"run to; lead to; communicate; understand; be well-informed"}	\N
通称	つうしょう	{正式ではないが世間一般で呼ばれている名称。とおり名。鎌倉東慶寺を縁切り寺、徳川光圀を水戸黄門、歌舞伎「与話情浮名横櫛 (よわなさけうきなのよこぐし) 」を「切られ与三 (よさ) 」とよぶ類。}	{"a popular name"}	\N
通常	つうじょう	{特別でなく、普通の状態であること。普通}	{"usual; normal; general"}	\N
通信	つうしん	{}	{"correspondence; communication; news; signal"}	\N
通ずる	つうずる	{何かを伝って到達する。また、届かせる。「電話がー・ずる」}	{"run to; lead to; communicate; understand; be well-informed"}	\N
痛切	つうせつ	{}	{"keen; acute"}	\N
通知	つうち	{}	{"notice; notification"}	\N
通帳	つうちょう	{}	{passbook}	\N
通用	つうよう	{}	{"popular use; circulation"}	\N
通路	つうろ	{}	{"passage; pathway"}	\N
通訳	つうやく	{異なる言語を話す人の間に立って、双方の言葉を翻訳してそれぞれの相手方に伝えること。}	{"interpretation; 〔人〕an interpreter"}	\N
遣い	つかい	{}	{"mission; simple task; doing"}	\N
使い道	つかいみち	{}	{use}	\N
使い慣らす	つかいならす	{いつも使って、物をその作業などになれさせる。「よく―・したグローブ」}	{"accustom (oneself)"}	\N
使い馴らす	つかいならす	{いつも使って、物をその作業などになれさせる。「よく―・したグローブ」}	{"accustom (oneself)"}	\N
使い慣れる	つかいなれる	{長い間使って、その使い方などになれる。「―・れた辞書」}	{"be used to; be accustomed to"}	\N
使い馴れる	つかいなれる	{長い間使って、その使い方などになれる。「―・れた辞書」}	{"be used to; be accustomed to"}	\N
使う	つかう	{}	{"use; handle; manipulate; employ; need; want; spend; consume; speak (English); practise (fencing); take (one´s lunch); circulate (bad money)"}	\N
遣う	つかう	{物・金銭・時間などを、何かをするのに当ててその量や額を減らす。消費する。ついやす。「金を―・う」「時間を有効に―・う」}	{"〔金，時間などを費やす〕spend; 〔消費する〕consume"}	\N
仕える	つかえる	{}	{"to serve; to work for"}	\N
司る	つかさどる	{}	{"to rule; to govern; to administer"}	\N
束の間	つかのま	{}	{"moment; brief time; brief; transient"}	\N
捕まえる	つかまえる	{}	{catch}	\N
捕まる	つかまる	{取り押さえられて、逃げることができなくなる。とらえられる。「どろぼうがー・る」}	{"be caught; be arrested"}	\N
掴む	つかむ	{手でしっかりと握り持つ。強くとらえて離すまいとする。「腕を―・む」「まわしを―・む」}	{"〔物を捕まえる〕catch; take [catch] hold of; 〔急に，力ずくで〕seize; 〔握りしめる〕grasp; 〔しっかりつかむ〕grip"}	\N
攫む	つかむ	{手でしっかりと握り持つ。強くとらえて離すまいとする。「腕を―・む」「まわしを―・む」}	{"〔物を捕まえる〕catch; take [catch] hold of; 〔急に，力ずくで〕seize; 〔握りしめる〕grasp; 〔しっかりつかむ〕grip"}	\N
疲れ	つかれ	{}	{"tiredness; fatigue"}	\N
疲れる	つかれる	{}	{"to get tired; to tire"}	\N
月	つき	{}	{"month; moon"}	\N
付き	つき	{}	{"attached to; impression; sociality; appearance; furnished with; under; to"}	\N
付き合い	つきあい	{}	{"association; socializing; fellowship"}	\N
付き合う	つきあう	{}	{"to associate with; to keep company with; to get on with"}	\N
付合う	つきあう	{}	{"associate with; keep company with; get on with"}	\N
突き上げる	つきあげる	{下から突いて上の方にあげる。突いて押し上げる。「こぶしを天に―・げる」}	{"push up; raise up (e.g. one's fist)"}	\N
突き当たり	つきあたり	{}	{"end (e.g. of street)"}	\N
突き当たる	つきあたる	{}	{"run into; collide with"}	\N
次々	つぎつぎ	{}	{"in succession; one by one"}	\N
月並み	つきなみ	{}	{"every month; common"}	\N
継ぎ目	つぎめ	{}	{"a joint; joining point"}	\N
尽きる	つきる	{}	{"to be used up; to be run out; to be exhausted; to be consumed; to come to an end"}	\N
点く	つく	{}	{"be lit; catch fire"}	\N
着く	つく	{}	{"arrive at; reach"}	\N
付く	つく	{}	{"adjoin; be attached; adhere; be connected with; be dyed; be stained; be scarred; be recorded; start (fires); follow; become allied to; accompany; study with; increase; be added to"}	\N
努める	つとめる	{}	{"to exert oneself; to make great effort; to try hard"}	\N
衝く	つく	{"棒状の物の先端で瞬間的に強く押す。 「指先で－・く」 「背中をどんと－・く」"}	{"perform a quick stab using a pointy object"}	\N
捺く	つく	{"印鑑で印をつける。 「判を－・く」"}	{"make (an seal using the inkan); impress? (heisig meaning)"}	\N
撞く	つく	{"鐘に棒などを打ち当てて音を出す。 「鐘を－・く」"}	{"toll (bell); stab (bell); bump into? (heisig meaning)"}	\N
就く	つく	{}	{"settle in (place); take (seat; position); study (under teacher)"}	\N
継ぐ	つぐ	{前の者のあとを受けて、その仕事・精神・地位などを引き続いて行う。続けてする。相続する。継承する。}	{"succeed; inherit; resume"}	\N
次ぐ	つぐ	{}	{"rank next to; come after"}	\N
接ぐ	つぐ	{}	{"to join; to piece together; to set (bones); to graft (trees)"}	\N
机	つくえ	{}	{desk}	\N
尽くす	つくす	{}	{"to exhaust; to run out; to serve (a person); to befriend"}	\N
償う	つぐなう	{金品を出して、負債や相手に与えた損失の補いをする。弁償する。「修理代を―・う」}	{"〔損害を〕compensate，((文)) recompense ((a person for)); 〔埋め合わせる〕make up ((for)); 〔罪を〕atone ((for one's sin))"}	\N
漬物	つけもの	{}	{"pickled veggies"}	\N
造り	つくり	{}	{"make up; structure; physique"}	\N
作り	つくり	{}	{"make-up; sliced raw fish"}	\N
作る	つくる	{}	{"create; make"}	\N
造る	つくる	{}	{"make; create; manufacture; draw up; write; compose; build; organize; establish"}	\N
繕う	つくろう	{}	{"to mend; to repair; to fix; to patch up; to darn; to tidy up; to adjust; to trim"}	\N
付け加える	つけくわえる	{}	{"to add one thing to another"}	\N
点ける	つける	{}	{"turn on; switch on; light up"}	\N
着ける	つける	{}	{"to arrive; to wear; to put on"}	\N
付ける	つける	{}	{"to attach; to join; to stick; to glue; to fasten; to sew on; to furnish (a house with); to wear; to put on; to make an entry; to appraise; to set (a price); to apply (ointment); to bring alongside; to place (under guard or doctor); to follow; to shad"}	\N
浸ける	つける	{}	{"dip in; soak"}	\N
漬ける	つける	{}	{"soak; pickle"}	\N
告げる	つげる	{}	{"to inform"}	\N
都合	つごう	{ぐあいがよいか悪いかということ。「今日はちょっと―が悪い」}	{circumstances〔便宜〕convenience}	\N
辻	つじ	{十字路・交差点}	{"crossroads; intersection"}	\N
辻褄	つじつま	{}	{"coherence; consistency"}	\N
蔦	つた	{}	{"ivy; 〔つる植物〕a vine; a creeper"}	\N
伝える	つたえる	{}	{"tell; report"}	\N
伝わる	つたわる	{}	{"be handed down; be introduced; be transmitted; be circulated; go along; walk along"}	\N
土	つち	{}	{"earth; soil"}	\N
筒	つつ	{}	{"pipe; tube"}	\N
続き	つづき	{}	{"sequel; continuation"}	\N
続く	つづく	{}	{"continue (to be the case); keep up"}	\N
続ける	つづける	{}	{"continue; go on; follow"}	\N
突っ込む	つっこむ	{}	{"thrust something into something; plunge into; go into deeply; meddle; interfere"}	\N
慎む	つつしむ	{あやまちや軽はずみなことがないように気をつける。慎重に事をなす。「行動をー・む」「言葉をー・みなさい」}	{"to be careful; to be chaste or discreet; to abstain or refrain"}	\N
謹む	つつしむ	{うやうやしくかしこまる。「ー・んで御礼申し上げます」}	{"reverently tighten up"}	\N
突っ張る	つっぱる	{}	{"to support; to become stiff; to become taut; to thrust (ones opponent); to stick to (ones opinion); to insist on"}	\N
慎ましい	つつましい	{}	{"modest; reserved"}	\N
包み	つつみ	{}	{"bundle; package; parcel; bale"}	\N
勤まる	つとまる	{}	{"to be fit for; to be equal to; to function properly"}	\N
務め	つとめ	{}	{"service; duty; business; responsibility; task"}	\N
勤め	つとめ	{}	{"service; duty; business; Buddhist religious services"}	\N
勤め先	つとめさき	{}	{"place of work"}	\N
努めて	つとめて	{}	{"make an effort!; work hard!"}	\N
務める	つとめる	{}	{"to serve; to fill a post; to serve under; to exert oneself; to endeavor; to be diligent; to play (the part of); to work (for)"}	\N
勤める	つとめる	{}	{"serve; fill a post; work (for); exert oneself; endeavor; be diligent; to play (the part of)"}	\N
綱	つな	{}	{rope}	\N
津波	つなみ	{}	{"tsunami; tidal wave"}	\N
常	つね	{いつでも変わることなく同じであること。永久不変であること。「有為転変の、―のない世」}	{"〔普段・平素〕usual; ordinary"}	\N
恒	つね	{いつでも変わることなく同じであること。永久不変であること。「有為転変の、―のない世」}	{"〔普段・平素〕usual; ordinary"}	\N
常々	つねづね	{いつも。ふだん、平生。副詞的にも用いる。「―の心掛け」「―言い聞かせてある」}	{"always; usually"}	\N
常に	つねに	{}	{"always; constantly"}	\N
募る	つのる	{}	{"to invite; to solicit help participation etc"}	\N
唾	つば	{}	{"saliva; sputum"}	\N
翼	つばさ	{}	{wing}	\N
粒	つぶ	{}	{grain}	\N
粒餡	つぶあん	{}	{"grainy azuki bean paste"}	\N
潰す	つぶす	{}	{"smash; waste"}	\N
っぷり	っぷり	{物事の様子や、あり方などを指す表現。「振り」の音便。「書きっぷり」などのように用いられる。}	{"appearance of something; (e.g. 食べ〜 manners of eating)"}	\N
潰れる	つぶれる	{}	{"be smashed; go bankrupt"}	\N
坪	つぼ	{}	{"〔面積の単位〕a tsubo ((単複同形)) (▼約3.3m2 )"}	\N
妻	つま	{}	{wife}	\N
摘む	つまむ	{}	{"to pinch; to hold; to pick up"}	\N
詰らない	つまらない	{}	{"insignificant; boring; trifling"}	\N
詰まる	つまる	{}	{"be blocked; be packed"}	\N
罪	つみ	{}	{"crime; fault; indiscretion"}	\N
積む	つむ	{}	{"pile up; stack"}	\N
錘	つむ	{}	{"a spindle"}	\N
爪	つめ	{}	{"fingernail or toenail; claw; talon; hoof"}	\N
爪切り	つめきり	{}	{"nail clipper"}	\N
冷たい	つめたい	{}	{"cold (to the touch); chilly; icy; freezing; coldhearted"}	\N
詰める	つめる	{}	{"pack; shorten; work out (details)"}	\N
積もり	つもり	{}	{"intention; plan"}	\N
積もる	つもる	{}	{"pile up"}	\N
艶艶	つやつや	{光沢があって美しいさま。「―（と）した肌」}	{"glossy; glowing"}	\N
つやつや	艶艶	{光沢があって美しいさま。「―（と）した肌」}	{"glossy; glowing"}	\N
梅雨	つゆ	{}	{"rainy season; rain during the rainy season"}	\N
露	つゆ	{}	{dew}	\N
強い	つよい	{}	{"strong; powerful; mighty; potent"}	\N
強まる	つよまる	{}	{"to get strong; to gain strength"}	\N
強さ	つよさ	{}	{"force; strength; power"}	\N
強める	つよめる	{}	{"to strengthen; to emphasize"}	\N
連なる	つらなる	{}	{"to extend; to stretch out; to stand in a row"}	\N
貫く	つらぬく	{}	{"to go through"}	\N
連ねる	つらねる	{}	{"to link; to join; to put together"}	\N
釣り合う	つりあう	{}	{"balance; be in harmony; suit"}	\N
釣鐘	つりがね	{}	{"hanging bell"}	\N
吊り革	つりかわ	{}	{strap}	\N
釣る	つる	{}	{"to fish"}	\N
連れ	つれ	{}	{"companion; company"}	\N
連れる	つれる	{}	{bring}	\N
嘘	うそ	{}	{"真実でないこと〕a lie; an untruth; 〔軽いうそ〕a fib"}	\N
植木	うえき	{}	{"garden shrubs; trees; potted plant"}	\N
植え込む	うえこむ	{ある物を、他の物の中にしっかりとはめ入れる}	{implanted}	\N
植える	うえる	{}	{plant}	\N
飢える	うえる	{}	{starve}	\N
生まれつき	うまれつき	{}	{"by nature; by birth; native"}	\N
角	つの	{}	{"〔牛・やぎなどの〕a horn; 〔しかの枝角〕an antler"}	\N
艶	つや	{}	{"gloss; glaze"}	\N
強気	つよき	{}	{"firm; strong"}	\N
辛い	つらい	{}	{"painful; heart-breaking"}	\N
剣	つるぎ	{}	{"a sword⇒けん(剣)"}	\N
浮かぶ	うかぶ	{}	{"to float; to rise to surface; to come to mind"}	\N
浮ぶ	うかぶ	{}	{"float; rise to surface; come to mind"}	\N
浮かべる	うかべる	{}	{"float; express; look (sad; glad)"}	\N
受かる	うかる	{}	{"to pass (examination)"}	\N
浮き彫り	うきぼり	{あるものがはっきりと見えるようになること。「問題点がーにされる」平面に絵・文字などを浮き上がるように彫ること。レリーフ。}	{"bring out (a mean side of personality); relief; the state of being clearly visible due to being accentuated.; a method of moulding; carving in which the design stands out from the surface; to a greater (high relief) or lesser (low relief) extent"}	\N
浮く	うく	{}	{"float; become merry; become loose"}	\N
受け入れ	うけいれ	{}	{"receiving; acceptance"}	\N
受け入れる	うけいれる	{}	{"to accept; to receive"}	\N
承る	うけたまわる	{}	{"(humble) hear; be told; know"}	\N
受け継ぐ	うけつぐ	{}	{"to inherit; to succeed; to take over"}	\N
受付	うけつけ	{}	{reception}	\N
受け付ける	うけつける	{}	{"to be accepted; to receive (an application)"}	\N
受け止める	うけとめる	{}	{"to catch; to stop the blow; to react to; to take"}	\N
受け取り	うけとり	{}	{receipt}	\N
受取人	うけとりにん	{金・書類・物品などを受け取る人。}	{"a recipient; 〔送金の〕a remittee; 〔手形の〕a payee; 〔保険の〕a beneficiary; 〔貨物の〕a consignee"}	\N
受け取り人	うけとりにん	{金・書類・物品などを受け取る人。}	{"a recipient; 〔送金の〕a remittee; 〔手形の〕a payee; 〔保険の〕a beneficiary; 〔貨物の〕a consignee"}	\N
受け取る	うけとる	{}	{"to receive; to get; to accept; to take; to interpret; to understand"}	\N
受身	うけみ	{}	{"passive; passive voice"}	\N
受け持つ	うけもつ	{自分の仕事として引き受けて行う。担当する。担任する。「一年生を―・つ」「この地区の配達を―・つ」}	{"take (be in) charge of"}	\N
受ける	うける	{}	{"have; take; receive"}	\N
動かす	うごかす	{}	{"move; shift; set in motion; operate; inspire;; rouse; ;influence; mobilize; deny; change"}	\N
動き	うごき	{}	{"movement; activity; trend; development; change"}	\N
潮	うしお	{}	{tide}	\N
氏神	うじがみ	{神として祭られた氏族の先祖。藤原氏の天児屋命 (あまのこやねのみこと) 、斎部 (いんべ) 氏の天太玉命 (あまのふとだまのみこと) など。}	{"a tutelary [guardian/patron] deity; house god"}	\N
失う	うしなう	{今まで持っていたもの、備わっていたものをなくす。手に入れかけて、のがしてしまう。取り逃がす。「友情をー・う」「機会をー・う」}	{"lose; part with"}	\N
喪う	うしなう	{失う・世界から消える「15歳にして母をー・う」「絶壁より堕ちてその命をー・う」}	{"miss (something)"}	\N
渦	うず	{}	{swirl}	\N
薄い	うすい	{}	{"thin; weak; watery; diluted"}	\N
薄暗い	うすぐらい	{}	{"dim; gloomy"}	\N
埋まる	うずまる	{}	{"to be buried; to be surrounded; to overflow; to be filled"}	\N
薄める	うすめる	{}	{dilute}	\N
歌	うた	{}	{"song; poetry"}	\N
歌う	うたう	{音楽的な高低・調子などをつけて発声する。「歌を―・う」「ピアノに合わせて―・う」}	{sing}	\N
唄う	うたう	{節をつけてことばを発する、主として日本古来の大衆的なもの。長唄、小唄、端唄、馬子唄など。}	{"sing (a pop song);"}	\N
謡う	うたう	{節をつけてことばを発する、日本古来の文学的なもの。謡曲。}	{"sing (Noh); (Noh) versify"}	\N
生まれる	うまれる	{}	{"be born"}	\N
海	うみ	{}	{"sea; beach"}	\N
氏	うじ	{}	{"family name"}	\N
後	うしろ	{}	{"afterwards; since then; in the future"}	\N
謳う	うたう	{多くの人々が褒めたたえる。謳歌する。「太平の世を―・う」}	{"〔ほめたたえる〕sing the praises ((of)); ((文)) extol"}	\N
詠う	うたう	{詩歌を作る。また、詩歌に節をつけて朗読する。「望郷の心を―・った詩」}	{"versify (a poem)?"}	\N
疑い	うたがい	{}	{"doubt; distrust"}	\N
疑う	うたがう	{}	{"doubt; distrust; be suspicious of; suspect"}	\N
疑わしい	うたがわしい	{}	{"doubtful; suspicious"}	\N
宴	うたげ	{酒宴。宴会。さかもり。「うちあげ（打ち上げ）」の音変化とも、歌酒の意ともいう。}	{banquet}	\N
打たす	うたす	{《「す」はもと使役の助動詞。むちで打って馬を走らせる意から》馬に乗って行く。}	{"ride horse?"}	\N
打たれる	うたれる	{ある物事から強い感動を受ける。「美談に胸を―◦れる」「意外の感に―◦れる」}	{"get hammered"}	\N
内	うち	{}	{inside}	\N
打ち明ける	うちあける	{人に知られたくない事実や秘密などを、思い切って隠さずに話す。うちあかす。「思いのたけを―・ける」}	{"confide ((in a person; a thing to a person))，confess ((to a person; a thing to a person))"}	\N
打ち合わせ	うちあわせ	{}	{"business meeting; previous arrangement; appointment"}	\N
打合せ	うちあわせ	{}	{"business meeting; appointment; previous arrangement"}	\N
打ち合わせる	うちあわせる	{}	{"to knock together; to arrange"}	\N
打ち切る	うちきる	{}	{"to stop; to abort; to discontinue; to close"}	\N
打ち消し	うちけし	{}	{"negation; denial; negative"}	\N
打ち消す	うちけす	{}	{"deny; negate; contradict"}	\N
打ち込む	うちこむ	{}	{"to drive in (e.g. nail stake); to devote oneself to; to shoot into; to smash; to throw into; to cast into"}	\N
宇宙	うちゅう	{}	{"universe; cosmos; space"}	\N
宇宙人	うちゅうじん	{}	{alien}	\N
団扇	うちわ	{}	{fan}	\N
内訳	うちわけ	{}	{"the items; breakdown; classification"}	\N
討つ	うつ	{}	{"attack; avenge"}	\N
射つ	うつ	{弾丸・矢などを発射する。「拳銃で―・つ」「標的を―・つ」}	{〔発射・射撃する〕shoot〔攻撃する〕attack}	\N
撃つ	うつ	{弾丸・矢などを発射する。「拳銃で―・つ」「標的を―・つ」}	{"attack; defeat; destroy"}	\N
美しい	うつくしい	{}	{"beautiful; lovely"}	\N
写し	うつし	{}	{"copy; duplicate; facsimile; transcript"}	\N
移す	うつす	{}	{"remove; transfer; infect"}	\N
写す	うつす	{}	{"copy; photograph"}	\N
映す	うつす	{}	{"project; reflect; cast (shadow)"}	\N
訴え	うったえ	{}	{"lawsuit; complaint"}	\N
訴える	うったえる	{物事の善悪、正邪の判定を求めて裁判所などの機関に申し出る。}	{"appeal; sue; accuse"}	\N
鬱陶しい	うっとうしい	{}	{"gloomy; depressing"}	\N
映る	うつる	{"１鏡・水面などに反射して見える ２映像として見える"}	{"be reflected; show (a TV-image)"}	\N
移る	うつる	{}	{"move; change"}	\N
写る	うつる	{}	{"be photographed; be projected"}	\N
空ろ	うつろ	{}	{"blank; cavity; hollow; empty (space)"}	\N
器	うつわ	{}	{"bowl; vessel; container"}	\N
腕	うで	{}	{arm}	\N
腕前	うでまえ	{巧みに物事をなしうる能力や技術。手並み。技量。技能}	{"skill; ability; talent"}	\N
雨天	うてん	{}	{"rainy weather"}	\N
疎い	うとい	{親しい間柄でない。疎遠だ。「二人の仲は―・くなった」「去る者は日々に―・し」}	{"〔よく知らない〕know little; be ill-informed〔親しくない〕out-of-mind"}	\N
饂飩	うどん	{小麦粉を練って長く切った、ある程度の幅と太さを持つ麺。またその料理。}	{Udon}	\N
促す	うながす	{物事を早くするようにせきたてる；促進する；勧める}	{"stimulate; encourage"}	\N
自惚れ	うぬぼれ	{}	{"pretension; conceit; hubris"}	\N
奪う	うばう	{}	{"snatch away"}	\N
美味い	うまい	{食物などの味がよい。おいしい。「―・い酒」「山の空気が―・い」⇔まずい。}	{delicious}	\N
旨い	うまい	{食物などの味がよい。おいしい。「―・い酒」「山の空気が―・い」⇔まずい。}	{"〔おいしい〕delicious; tasty"}	\N
味酒	うまさけ	{}	{"sweet sake"}	\N
生まれ	うまれ	{}	{"birth; birth-place"}	\N
打つ	うつ	{}	{"hit; beat"}	\N
有無	うむ	{}	{"yes or no; existence; presence or absence marker"}	\N
産む	うむ	{}	{"to give birth; to deliver; to produce"}	\N
埋め込む	うめこむ	{物の全部または一部を、中に入れ込む。「石材を土中に―・む」}	{"to bury; to embed"}	\N
梅干	うめぼし	{}	{"dried plum"}	\N
埋める	うめる	{}	{"bury (e.g. one´s face in hands)"}	\N
敬う	うやまう	{}	{"show respect; to honour"}	\N
裏	うら	{}	{"the back; the wrong side"}	\N
浦	うら	{}	{"〔入り江〕an inlet; a bay，((英)) a creek; 〔海辺〕the seashore; a beach"}	\N
裏返し	うらがえし	{}	{"inside out; upside down"}	\N
裏返す	うらがえす	{}	{"turn inside out; turn the other way; turn over"}	\N
裏切る	うらぎる	{}	{"betray; double-cross"}	\N
裏口	うらぐち	{}	{"back door; rear entrance"}	\N
占う	うらなう	{}	{"forecast; predict"}	\N
裏腹	うらはら	{相反していること。また、そのさま。逆さま。反対。あべこべ。「気持ちと―な言葉」}	{"〔裏表，反対〕reverse; opposite"}	\N
恨み	うらみ	{}	{"resentment; grudge; offence"}	\N
憾む	うらむ	{望みどおりにならず、残念に思う。「機会を逸したことが―・まれる」}	{"to deeply regret; to resent"}	\N
恨む	うらむ	{ひどい仕打ちをした相手を憎く思う気持ちをもちつづける。「冷たい態度を―・む」}	{"feel bitter"}	\N
怨む	うらむ	{憎悪を感じる。「親をー」}	{"feel hatred"}	\N
羨ましい	うらやましい	{}	{"envious; enviable"}	\N
羨む	うらやむ	{}	{envy}	\N
売上	うりあげ	{}	{"amount sold; proceeds"}	\N
売り切れ	うりきれ	{}	{"sold out"}	\N
売り切れる	うりきれる	{}	{"be sold out"}	\N
売り出し	うりだし	{}	{"(bargain) sale"}	\N
売り出す	うりだす	{}	{"to put on sale; to market; to become popular"}	\N
売り場	うりば	{}	{"selling area"}	\N
売る	うる	{}	{sell}	\N
潤う	うるおう	{}	{"to be moist; to be damp; to get wet; to profit by; to be watered; to receive benefits; to favor; to charm; to steepen"}	\N
五月蝿い	うるさい	{}	{"noisy; loud; fussy"}	\N
煩い	うるさい	{}	{"noisy; loud; fussy"}	\N
愁い	うれい	{}	{"grief; sorrow"}	\N
嬉しい	うれしい	{物事が自分の望みどおりになって満足であり、喜ばしい。自分にとってよいことが起き、愉快で、楽しい。「努力が報われてとても―・い」「―・いことに明日は晴れるらしい」⇔悲しい。}	{"be glad ((of; about; to do; that)); be happy; be delighted ((at; with; to do; that))"}	\N
売れ行き	うれゆき	{}	{sales}	\N
売れる	うれる	{}	{"be sold"}	\N
浮気	うわき	{}	{"flighty; fickle; wanton; unfaithful"}	\N
上着	うわぎ	{}	{"coat; tunic; jacket; outer garment"}	\N
噂	うわさ	{そこにいない人を話題にしてあれこれ話すこと。}	{rumour}	\N
上回る	うわまわる	{}	{"to exceed"}	\N
植わる	うわる	{}	{"to be planted"}	\N
運	うん	{}	{"fortune; luck"}	\N
運営	うんえい	{}	{"management; administration; operation"}	\N
運河	うんが	{}	{canal}	\N
運送	うんそう	{}	{"shipping; marine transportation"}	\N
運賃	うんちん	{}	{"freight rates; shipping expenses; fare"}	\N
運転	うんてん	{}	{"operation; motion; driving"}	\N
運転手	うんてんしゅ	{}	{drive}	\N
運動	うんどう	{}	{"motion; exercise"}	\N
運搬	うんぱん	{}	{"transport; carriage"}	\N
運命	うんめい	{}	{fate}	\N
運輸	うんゆ	{}	{transportation}	\N
運用	うんよう	{}	{"making use of; application; investment; practical use"}	\N
和	わ	{}	{"sum; harmony; peace"}	\N
和英	わえい	{}	{Japanese-English}	\N
若い	わかい	{}	{young}	\N
若草色	わかくさいろ	{}	{"grass green"}	\N
沸かす	わかす	{}	{boil}	\N
我がまま	わがまま	{}	{"selfishness; egoism; wilfulness; disobedience; whim"}	\N
我が家	わがや	{自分の家。また、自分の家庭。}	{"〔家庭〕one's home; 〔建物〕one's house"}	\N
輪	わ	{}	{"ring; hoop; circle"}	\N
分かる	わかる	{}	{"to be understood"}	\N
分る	わかる	{}	{"be understood"}	\N
別れ	わかれ	{}	{"parting; separation; farewell; (lateral) branch; fork; offshoot; division; section"}	\N
別れ際	わかれぎわ	{}	{"parting (separating occasion)"}	\N
別れる	わかれる	{}	{separate}	\N
分かれる	わかれる	{}	{"branch off; diverge from; fork; split; dispense; scatter; divide into"}	\N
若々しい	わかわかしい	{}	{"youthful; young"}	\N
脇	わき	{}	{side}	\N
枠	わく	{}	{"frame; slide"}	\N
沸く	わく	{}	{boil}	\N
湧く	わく	{}	{"boil; grow hot; get excited; gush forth"}	\N
惑星	わくせい	{}	{planet}	\N
分ける	わける	{}	{"divide; separate; make distinctions; differentiate (between)"}	\N
技	わざ	{}	{"art; technique"}	\N
態々	わざわざ	{他のことのついでではなく、特にそのためだけに行うさま。特にそのために。故意に。「御親切にも―忠告に来る人がいる」「―出掛けなくても電話で済むことだ」}	{"expressly; purposely; intentionally; specially; doing something especially rather than incidentally"}	\N
わざわざ	態々	{他のことのついでではなく、特にそのためだけに行うさま。特にそのために。故意に。「御親切にも―忠告に来る人がいる」「―出掛けなくても電話で済むことだ」}	{"expressly; purposely; intentionally; specially; doing something especially rather than incidentally"}	\N
和室	わしつ	{}	{"japanese-style room"}	\N
和食	わしょく	{}	{"japanese-style meal"}	\N
僅か	わずか	{}	{"only; merely; a little; small quantity"}	\N
患う	わずらう	{病気で苦しむ。古くは「…にわずらう」の形で用いることが多い。「目を―・う」}	{"fall ill; become sick"}	\N
煩う	わずらう	{あれこれと心をいためる。思い悩む。}	{"become sick"}	\N
煩わしい	わずらわしい	{}	{"troublesome; annoying; complicated"}	\N
忘れ物	わすれもの	{}	{"a thing left behind"}	\N
忘れる	わすれる	{}	{"forget; leave carelessly"}	\N
話題	わだい	{}	{"topic; subject"}	\N
私共	わたくしども	{一人称の人代名詞。自分、または自分の家族・集団などをへりくだっていう語。手前ども。わたくしたち。「―もみな元気に暮らしております」}	{our}	\N
渡す	わたす	{}	{"pass over; hand over"}	\N
移徙	わたまし	{貴人の転居、神輿 (しんよ) の渡御を敬っていう語。}	{"(moving of a venerable person; religious expression)"}	\N
渡座	わたまし	{貴人の転居、神輿 (しんよ) の渡御を敬っていう語。}	{"(moving of a venerable person; religious expression)"}	\N
渡り鳥	わたりどり	{}	{"migratory bird; bird of passage"}	\N
渡る	わたる	{}	{"cross over; go across"}	\N
和風	わふう	{}	{"Japanese style"}	\N
和服	わふく	{}	{"Japanese clothes"}	\N
和文	わぶん	{}	{"Japanese text; sentence in Japanese"}	\N
和睦	わぼく	{争いをやめて仲直りすること。和解。「―を結ぶ」「両国が―する」}	{"peace (negotiations; settlements; talks)"}	\N
罠	わな	{}	{trap}	\N
笑い	わらい	{}	{"laugh; laughter; smile"}	\N
笑う	わらう	{}	{laugh}	\N
割	わり	{比率。割合。「三日に一回の＿で通う」}	{"per; out of; proportion"}	\N
割合	わりあい	{}	{"rate; ratio; proportion; comparatively; contrary to expectations"}	\N
割合に	わりあいに	{}	{comparatively}	\N
割り当て	わりあて	{}	{"allotment; assignment; allocation; quota; rationing"}	\N
割り込む	わりこむ	{}	{"to cut in; to thrust oneself into; to wedge oneself in; to muscle in on; to interrupt; to disturb"}	\N
割り算	わりざん	{}	{"division (math)"}	\N
割算	わりざん	{}	{"(mathematics) division"}	\N
割り出す	わりだす	{ある根拠に基づいて推論し、結論を導き出す。「遺留品から犯人を―・す」}	{"〔推断する〕deduce; figure out; arrive at (a conclussion)"}	\N
割と	わりと	{}	{"relatively; comparatively"}	\N
割引	わりびき	{}	{"discount; reduction; rebate; tenths discounted"}	\N
割る	わる	{}	{"divide; cut; break; halve; separate; split; rip; crack; smash; dilute"}	\N
悪い	わるい	{"１ 人の行動・性質や事物の状態などが水準より劣っているさま。２ 人の行動・性質や事物の状態が、正邪・当否の判断基準に達していないさま。"}	{bad}	\N
悪者	わるもの	{}	{"bad fellow; rascal; ruffian; scoundrel"}	\N
我等	われら	{一人称の人代名詞。「われ」の複数。わたくしたち。われわれ。「―が母校」「―の自由」}	{"we; us"}	\N
割れる	われる	{}	{"split; crack"}	\N
我々	われわれ	{}	{we}	\N
湾	わん	{}	{"bay; gulf; inlet"}	\N
湾曲	わんきょく	{}	{curvature}	\N
腕力	わんりょく	{}	{force}	\N
矢	や	{}	{arrow}	\N
やおい	㚻	{男性同性愛を題材にした漫画や小説などの俗称。また、それらを愛好する人や、作中での同性愛的な関係・あるいはそういったものが好まれる現象の総体をやおいということもある。801と表記されることもある。}	{"also known as Boys' Love (BL); is a Japanese genre of fictional media focusing on romantic or sexual relationships between male characters; typically aimed at a female audience and usually created by female authors."}	\N
八百屋	やおや	{}	{greengrocer}	\N
野外	やがい	{}	{"fields; outskirts; open air; suburbs"}	\N
夜間	やかん	{}	{"at night; nighttime"}	\N
薬缶	やかん	{}	{kettle}	\N
野球	やきゅう	{}	{baseball}	\N
焼く	やく	{}	{"bake; grill"}	\N
約	やく	{}	{"approximately; about; some"}	\N
夜具	やぐ	{}	{bedding}	\N
役者	やくしゃ	{}	{"actor; actress"}	\N
役所	やくしょ	{}	{"government office; public office"}	\N
薬用	やくよう	{薬として用いること。「―クリーム」}	{"medicinal use"}	\N
役職	やくしょく	{}	{"post; managerial position; official position"}	\N
訳す	やくす	{}	{translate}	\N
約束	やくそく	{}	{promise}	\N
役立つ	やくだつ	{使って効果がある。有用である。「社会に―・つ人材」}	{"to be useful; to be helpful; to serve the purpose"}	\N
役に立つ	やくにたつ	{使って効果がある。有用である。「―・つ人材」「急場の―・つ」}	{useful}	\N
役人	やくにん	{}	{"government official"}	\N
役場	やくば	{}	{"town hall"}	\N
薬品	やくひん	{}	{"medicine(s); chemical(s)"}	\N
役目	やくめ	{}	{"duty; business"}	\N
役割	やくわり	{}	{"part; assigning (allotment of) parts; role; duties"}	\N
焼ける	やける	{}	{"be burned"}	\N
優	やさ	{}	{"gentle; affectionate"}	\N
野菜	やさい	{}	{vegetable}	\N
優しい	やさしい	{}	{kind}	\N
易しい	やさしい	{}	{"easy; plain; simple"}	\N
屋敷	やしき	{}	{mansion}	\N
矢印	やじるし	{}	{"directing arrow"}	\N
社	やしろ	{}	{"Shinto shrine"}	\N
野心	やしん	{}	{"ambition; aspiration; designs; treachery"}	\N
安い	やすい	{}	{"cheap; inexpensive; peaceful; quiet; gossipy; thoughtless"}	\N
易い	やすい	{}	{easy}	\N
安っぽい	やすっぽい	{}	{"cheap-looking; tawdry; insignificant"}	\N
休み	やすみ	{}	{"rest; recess; respite; vacation; holiday; absence; suspension"}	\N
休む	やすむ	{}	{"to rest; have a break; take a day off; be finished; be absent; retire; sleep"}	\N
休める	やすめる	{}	{"to rest; to suspend; to give relief"}	\N
安物	やすもの	{値段が安く、粗悪な物。}	{"shlook; cheap"}	\N
安らぎ	やすらぎ	{穏やかなゆったりとした気分。「あわただしさの中に一時の―を見いだす」}	{calmness}	\N
野生	やせい	{動植物が自然に山野で生育すること。「―の猿」}	{wild}	\N
痩せる	やせる	{}	{"lose weight"}	\N
野戦	やせん	{フィールド}	{field}	\N
野戦服	やせんふく	{}	{"battle field uniform"}	\N
夜想曲	やそうきょく	{}	{"nocturne (music inspired by the night)"}	\N
悪口	わるくち	{}	{"abuse; insult; slander; evil speaking"}	\N
厄介	やっかい	{悩み・困難・気遣い}	{"trouble; burden; care; bother; worry; dependence; support; kindness; obligation"}	\N
薬局	やっきょく	{}	{pharmacy}	\N
八つ	やっつ	{}	{eight}	\N
やっ付ける	やっつける	{}	{"to beat"}	\N
矢っ張り	やっぱり	{}	{"also; as I thought; still; in spite of; absolutely"}	\N
奴等	やつら	{}	{"those guys"}	\N
宿	やど	{}	{"inn; lodging"}	\N
野党	やとう	{}	{"opposition party"}	\N
雇う	やとう	{}	{"employ; hire"}	\N
屋根	やね	{}	{roof}	\N
破く	やぶく	{}	{"tear; violate; defeat; smash; destroy"}	\N
破る	やぶる	{}	{"tear; violate; defeat; smash; destroy"}	\N
破れる	やぶれる	{}	{"get torn; wear out"}	\N
野暮	やぼ	{人情の機微に通じないこと。わからず屋で融通のきかないこと。また、その人やさま。無粋 (ぶすい) 。「―を言わずに金を貸してやれ」「聞くだけ―だ」⇔粋 (いき) 。}	{"〜な 〔がさつな，無神経な〕boorish; 〔気のきかない，不器用な〕gauche [óu]; 〔ぎこちない，ぶざまな〕uncouth"}	\N
野望	やぼう	{分不相応な望み。また、身の程を知らない大それた野心。「世界制覇の―を抱く」}	{ambition}	\N
山	やま	{}	{"mountain; pile; heap; climax; critical point"}	\N
闇	やみ	{}	{"darkness; the dark; black-marketeering; dark; shady; illegal"}	\N
止む	やむ	{}	{"stop (e.g. rain)"}	\N
病む	やむ	{}	{"to fall ill; to be ill"}	\N
止むを得ない	やむをえない	{そうするよりほかに方法がない。しかたがない。「撤退もー・ない」}	{unavoidable}	\N
辞める	やめる	{}	{retire}	\N
寡	やもめ	{}	{widow}	\N
遣り通す	やりとおす	{}	{"to carry through; to achieve; to complete"}	\N
やり遂げる	やりとげる	{}	{"to accomplish"}	\N
遣る	やる	{}	{"to do; to have sexual intercourse; to kill; to give (to inferiors animals etc.); to dispatch (a letter); to send; to study; to perform; to play (sports game); to have (eat drink smoke); to row (a boat); to run or operate (a restaurant)"}	\N
軟い	やわい	{壊れやすい、こわれやすい}	{weak}	\N
柔い	やわ・い	{「柔らかい」に同じ。「―・い紙」}	{"〔固くない〕soft〔穏やかな〕soft; gentle; mild"}	\N
軟らかい	やわらかい	{}	{"soft; tender; limp"}	\N
柔らかい	やわらかい	{}	{soft}	\N
和らげる	やわらげる	{}	{"to soften; to moderate; to relieve"}	\N
世	よ	{}	{"world; society; age; generation"}	\N
夜明け	よあけ	{}	{"dawn; daybreak"}	\N
好い	よい	{}	{good}	\N
宵	よい	{日が暮れてまだ間もないころ。古代では夜を3区分した一つで、日暮れから夜中までの間。初夜。「―のうちから床に就く」}	{evening}	\N
用	よう	{}	{"business; errand"}	\N
酔う	よう	{}	{"get drunk; become intoxicated"}	\N
昜	よう	{}	{"[piggy bank radical]"}	\N
用意	ようい	{前もって必要なものをそろえ、ととのえておくこと。したく。「食事の―がととのう」「招待客の車を―する」}	{prepare}	\N
容易	ようい	{}	{"easy; simple; plain"}	\N
要因	よういん	{}	{"primary factor; main cause"}	\N
余韻	よいん	{}	{"a lingering sound"}	\N
溶液	ようえき	{}	{"solution (liquid)"}	\N
八日	ようか	{}	{"eight days; the eighth (day of the month)"}	\N
溶岩	ようがん	{}	{lava}	\N
容器	ようき	{}	{"container; vessel"}	\N
陽気	ようき	{}	{"season; weather; cheerfulness"}	\N
要求	ようきゅう	{}	{"request; demand; requisition"}	\N
謡曲	ようきょく	{}	{"a Noh song; Noh singing"}	\N
用具	ようぐ	{}	{"tool; utensil"}	\N
用件	ようけん	{}	{business}	\N
用語	ようご	{}	{"term; terminology"}	\N
養護	ようご	{}	{"protection; nursing; protective care"}	\N
擁護	ようご	{}	{"protection; support"}	\N
奴	やっこ	{}	{"servant; fellow"}	\N
家主	やぬし	{}	{landlord}	\N
止める	やめる	{}	{"quit smoking"}	\N
夜	よ	{}	{night}	\N
要旨	ようし	{}	{"gist; essentials; summary; fundamentals"}	\N
用紙	ようし	{}	{"blank form"}	\N
幼児	ようじ	{}	{"infant; baby; child"}	\N
用事	ようじ	{}	{"business; errand"}	\N
様式	ようしき	{}	{"style; form; pattern"}	\N
用心	ようじん	{}	{"care; precaution; caution"}	\N
様子	ようす	{外から見てわかる物事のありさま。状況。状態。「当時の―を知る人」「室内の―をうかがう」}	{"aspect; state; appearance"}	\N
要する	ようする	{}	{"to demand; to require; to take"}	\N
要するに	ようするに	{}	{"in a word; after all; the point is ...; in short ..."}	\N
養成	ようせい	{}	{"training; development"}	\N
要請	ようせい	{必要だとして、強く願い求めること。「会長就任をーする」}	{request}	\N
容積	ようせき	{}	{"capacity; volume"}	\N
要素	ようそ	{あるものごとを成り立たせている基本的な内容や条件。成分。要因。}	{elements}	\N
様相	ようそう	{}	{aspect}	\N
幼稚	ようち	{}	{"infancy; childish; infantile"}	\N
幼稚園	ようちえん	{}	{kindergarten}	\N
要点	ようてん	{}	{"gist; main point"}	\N
用途	ようと	{}	{"use; usefulness"}	\N
様な	ような	{例示の意を表す。たとえば＿のようだ。〜似ている；〜と同様である；例示して；〜とかいう}	{"like; such as"}	\N
ような 	ような 	{…に似ている。…と同様である。例示して。}	{"like; such as"}	\N
曜日	ようび	{}	{"day of the week"}	\N
用品	ようひん	{}	{"articles; supplies; parts"}	\N
洋品店	ようひんてん	{}	{"shop which handles Western-style apparel and accessories"}	\N
洋風	ようふう	{}	{"western style"}	\N
洋服	ようふく	{}	{"Western-style clothes"}	\N
養分	ようぶん	{}	{"nourishment; nutrient"}	\N
用法	ようほう	{}	{"directions; rules of use"}	\N
要望	ようぼう	{}	{"demand for; request"}	\N
羊毛	ようもう	{}	{wool}	\N
漸く	ようやく	{}	{"gradually; finally; hardly"}	\N
擁立	ようりつ	{}	{fielded(?)}	\N
要領	ようりょう	{}	{"point; gist; essentials; outline"}	\N
容量	ようりょう	{器物の中に入れることのできる分量。容積。}	{"capacity; 〔容積〕volume"}	\N
余暇	よか	{}	{"leisure; leisure time; spare time"}	\N
予感	よかん	{}	{"presentiment; premonition"}	\N
予期	よき	{前もって期待すること。「―に反する」「―した以上の成果」}	{"expectation; assume will happen; forecast"}	\N
余興	よきょう	{}	{"side show; entertainment"}	\N
夜霧	よぎり	{"夜に立つ霧。《季 秋》「山国の―に劇場 (しばゐ) 出て眠し／水巴」"}	{"night fog"}	\N
預金	よきん	{}	{"deposit; bank account"}	\N
良く	よく	{}	{good}	\N
抑圧	よくあつ	{}	{"check; restraint; oppression; suppression"}	\N
抑止	よくし	{おさえつけて活動などをやめさせること。「地価の高騰をーする」「核のー力」}	{"barestraint; deterrence"}	\N
浴室	よくしつ	{}	{"bathroom; bath"}	\N
翌日	よくじつ	{}	{"next day"}	\N
浴する	よくする	{水や湯を浴びる。入浴する。「温泉に―・する」}	{⇒あびる(浴びる)，にゅうよく(入浴)}	\N
抑制	よくせい	{}	{suppression}	\N
浴槽	よくそう	{湯ぶね。ふろおけ。}	{bathtub}	\N
翌年	よくねん	{}	{"next year"}	\N
欲張り	よくばり	{}	{"avarice; covetousness; greed"}	\N
欲深い	よくふかい	{}	{greedy}	\N
欲望	よくぼう	{}	{"desire; appetite"}	\N
余計	よけい	{}	{"too much; unnecessary; abundance; surplus; excess"}	\N
横	よこ	{}	{"beside; side; width"}	\N
夕暮れ	ゆうぐれ	{}	{"evening; (evening) twilight"}	\N
横文字	よこもじ	{横に書きつづる文字。西洋文字・梵字 (ぼんじ) ・アラビア文字など。特に、西洋文字をいう。}	{"〔西洋の文字〕the Roman alphabet; 〔外国語〕a Western [European] language"}	\N
横切る	よこぎる	{}	{"cross (e.g. arms); traverse"}	\N
寄こす	よこす	{}	{"to send; to forward"}	\N
邪	よこしま	{正しくないこと。道にはずれていること。また、そのさま。「―な考えをいだく」}	{"wicked; evil; not doing the right thing; on the wrong path"}	\N
横しま	よこしま	{正しくないこと。道にはずれていること。また、そのさま。「―な考えをいだく」}	{"wicked; evil; not doing the right thing; on the wrong path"}	\N
横しま風	よこしまかぜ	{横なぐりに吹く風。暴風。「思はぬに―のにふふかに覆ひ来ぬれば」}	{"violent wind;"}	\N
横綱	よこづな	{}	{"sumo grand champion"}	\N
横手	よこて	{横に当たる方向。わき。「寺の―にある堂」「―から入る」}	{"side; beside; next"}	\N
予算	よさん	{}	{"estimate; budget"}	\N
善し悪し	よしあし	{}	{"good or bad; merits or demerits; quality; suitability"}	\N
予習	よしゅう	{}	{preparation}	\N
止す	よす	{}	{"cease; abolish; resign; give up"}	\N
寄せる	よせる	{}	{"collect; gather; add; put aside"}	\N
余所	よそ	{}	{"another place; somewhere else; strange parts"}	\N
予想	よそう	{}	{"expectation; anticipation; prediction; forecast"}	\N
装い	よそい	{身なりを整えたり、身を飾ったりすること。また、その装束や装飾。「農家の婦人の―したる媼ありて」「何ばかりの御―なく、うちやつして」}	{〔服装〕clothing〔飾り付け〕decoration}	\N
粧い	よそい	{身なりを整えたり、身を飾ったりすること。また、その装束や装飾。「農家の婦人の―したる媼ありて」「何ばかりの御―なく、うちやつして」}	{〔服装〕clothing〔飾り付け〕decoration}	\N
予測	よそく	{}	{"prediction; estimation"}	\N
余所見	よそみ	{}	{"looking away; looking aside"}	\N
余地	よち	{}	{"place; room; margin; scope"}	\N
予兆	よちょう	{}	{"omen; portent"}	\N
四日	よっか	{}	{"fourth day of the month; four days"}	\N
四つ角	よつかど	{}	{"four corners; crossroads"}	\N
四つ	よっつ	{}	{four}	\N
依って	よって	{}	{"therefore; consequently; accordingly; because of"}	\N
酔っ払い	よっぱらい	{}	{drunkard}	\N
余程	よっぽど	{}	{"very; greatly; much; to a large extent; quite"}	\N
予定	よてい	{}	{plan}	\N
与党	よとう	{}	{"government party; (ruling) party in power; government"}	\N
予備	よび	{}	{"preparation; preliminaries; reserve; spare"}	\N
呼び掛ける	よびかける	{}	{"call out to; accost; address (crowd); make an appeal"}	\N
呼び出す	よびだす	{}	{"summon; call (e.g. via telephone)"}	\N
呼び止める	よびとめる	{}	{"to challenge; to call somebody to halt"}	\N
呼ぶ	よぶ	{}	{"call out; invite"}	\N
夜更かし	よふかし	{}	{"staying up late; keeping late hours; sitting up late at night; nighthawk"}	\N
夜更け	よふけ	{}	{"late at night"}	\N
余分	よぶん	{}	{"extra; excess; surplus"}	\N
予報	よほう	{}	{"forecast; prediction"}	\N
予防	よぼう	{悪い事態の起こらないように前もってふせぐこと。「病気の蔓延を―する」}	{"prevention; precaution; protection against"}	\N
読み	よみ	{}	{reading}	\N
読み上げる	よみあげる	{}	{"to read out loud (and clearly); to call a roll"}	\N
夜道	よみち	{}	{"night journey; walk after dark"}	\N
読む	よむ	{}	{read}	\N
詠む	よむ	{}	{"chant; recite"}	\N
嫁	よめ	{}	{"bride; daughter-in-law"}	\N
予約	よやく	{}	{reservation}	\N
余裕	よゆう	{必要分以上に余りがあること。また、限度いっぱいまでには余りがあること。「金にーがある」「時間のーがない」}	{"allowance; margin; room"}	\N
有効	ゆうこう	{}	{"validity; availability; effectiveness"}	\N
汚す	よごす	{}	{"disgrace; dishonour; pollute; contaminate; soil; make dirty; stain"}	\N
汚れる	よごれる	{}	{"get dirty"}	\N
夜中	よなか	{}	{"all night; the whole night"}	\N
寄り道	よりみち	{目的地へ行く途中で、他の所へ立ち寄ること。また、回り道して立ち寄ること。回り道。「ーして帰る」}	{"stop on the way; detour; go the long way aaround"}	\N
寄り掛かる	よりかかる	{}	{"to lean against; to recline on; to lean on; to rely on"}	\N
寄る	よる	{}	{"drop in; stop by"}	\N
因る	よる	{それを原因とする。起因する。「濃霧にー・る欠航」「成功は市民の協力にー・る」}	{"come from"}	\N
由る	よる	{それを原因とする。起因する。「濃霧にー・る欠航」「成功は市民の協力にー・る」}	{"come from"}	\N
拠る	よる	{根拠とする。よりどころとする。「実験にー・る結論」「天気予報にー・ると大雨らしい」「法律の定めるところにー・る」}	{"〔基づく〕based on; according; relying upon"}	\N
喜び	よろこび	{}	{"joy; (a) delight; rapture; pleasure; gratification; rejoicing; congratulations; felicitations"}	\N
慶び	よろこび	{}	{"joy; delight; rapture; pleasure; gratification; rejoicing; congratulations; felicitations"}	\N
喜ぶ	よろこぶ	{}	{"be delighted"}	\N
慶ぶ	よろこぶ	{}	{"be delighted; be glad"}	\N
宜しい	よろしい	{}	{good}	\N
宜しく	よろしく	{}	{"well; properly; suitably; best regards; please remember me"}	\N
喜ばしい	よろこばしい	{喜ぶべき状態である。うれしい。「こんな―・いことはない」「―・い知らせ」}	{"〔うれしい〕happy; 〔望ましい〕desirable; 〔よい〕good"}	\N
悦ばしい	よろこばしい	{喜ぶべき状態である。うれしい。「こんな―・いことはない」「―・い知らせ」}	{"〔うれしい〕happy; 〔望ましい〕desirable; 〔よい〕good"}	\N
弱い	よわい	{}	{weak}	\N
弱まる	よわまる	{}	{"to abate; to weaken; to be emaciated; to be dejected; to be perplexed"}	\N
弱める	よわめる	{}	{"to weaken"}	\N
弱る	よわる	{}	{"to weaken; to be troubled; to be downcast; to be emaciated; to be dejected; to be perplexed; to impair"}	\N
湯	ゆ	{}	{"hot water"}	\N
唯一	ゆいいつ	{}	{"only; sole; unique"}	\N
優位	ゆうい	{}	{"predominance; ascendancy; superiority"}	\N
憂鬱	ゆううつ	{}	{"depression; melancholy; dejection; gloom"}	\N
有益	ゆうえき	{}	{"beneficial; profitable"}	\N
優越	ゆうえつ	{}	{"supremacy; predominance; being superior to"}	\N
遊園地	ゆうえんち	{}	{"amusement park"}	\N
誘拐	ゆうかい	{だまして、人を連れ去ること。かどわかし。「幼児を―する」「営利―」→略取誘拐罪}	{"kidnapping; abduction"}	\N
夕方	ゆうがた	{}	{evening}	\N
夕刊	ゆうかん	{}	{"evening paper"}	\N
勇敢	ゆうかん	{}	{"bravery; heroism; gallantry"}	\N
優雅	ゆうが	{}	{elegance}	\N
有機	ゆうき	{}	{organic}	\N
勇気	ゆうき	{}	{"courage; bravery; valour; nerve; boldness"}	\N
遊戯	ゆうぎ	{遊びたわむれること。遊び。「言語―」}	{"〔遊び戯れること〕play; a game"}	\N
遊戯室	ゆうぎしつ	{}	{"a playroom"}	\N
遊技場	ゆうぎじょう	{パチンコ・ビリヤード・ボウリングなどの遊技を行うための施設。}	{"an amusement center"}	\N
遊戯場	ゆうぎじょう	{}	{"a playground"}	\N
悠久	ゆうきゅう	{果てしなく長く続くこと。長く久しいこと。「ーの歴史」}	{"eternity; everlasting"}	\N
友好	ゆうこう	{}	{friendship}	\N
夜	よる	{}	{"evening; night"}	\N
四	よん	{}	{"four; fourth; quadruple"}	\N
優秀	ゆうしゅう	{非常にすぐれていること}	{excellence;superiority}	\N
優勝	ゆうしょう	{}	{"overall victory; championship"}	\N
夕食	ゆうしょく	{夕方にとる食事。夕飯。夕餉 (ゆうげ) 。}	{"supper; dinner"}	\N
友情	ゆうじょう	{}	{"friendship; fellowship"}	\N
友人	ゆうじん	{}	{friend}	\N
融通	ゆうずう	{}	{"lending (money); accommodation; adaptability; versatility; finance"}	\N
有する	ゆうする	{}	{"to own; to be endowed with"}	\N
優勢	ゆうせい	{}	{"superiority; superior power; predominance; preponderance"}	\N
優先	ゆうせん	{}	{"preference; priority"}	\N
郵送	ゆうそう	{}	{mailing}	\N
夕立	ゆうだち	{}	{"(sudden) evening shower (rain)"}	\N
誘導	ゆうどう	{}	{"guidance; leading; induction; introduction; incitement; inducement"}	\N
有能	ゆうのう	{}	{"able; capable; efficient; skill"}	\N
夕飯	ゆうはん	{}	{dinner}	\N
夕日	ゆうひ	{}	{"setting sun"}	\N
優美	ゆうび	{}	{"grace; refinement; elegance"}	\N
郵便	ゆうびん	{}	{"mail; postal service"}	\N
郵便局	ゆうびんきょく	{}	{"post office"}	\N
夕べ	ゆうべ	{きのうの夜。さくや。昨晩。「―は飲み明かした」「―地震があった」}	{"evening; last night"}	\N
有望	ゆうぼう	{}	{"good prospects; full of hope; promising"}	\N
遊牧	ゆうぼく	{}	{nomadism}	\N
有名	ゆうめい	{世間に名が知られていること。また、そのさま。著名。「―な俳優」「風光明媚で―な地」「―人」⇔無名。}	{fame}	\N
夕焼け	ゆうやけ	{}	{sunset}	\N
悠々	ゆうゆう	{}	{"quiet; calm; leisurely"}	\N
猶予	ゆうよ	{ぐずぐず引き延ばして、決定・実行しないこと。「もはや一刻の＿も許されない」}	{hesitation}	\N
有利	ゆうり	{}	{"advantageous; better; profitable; lucrative"}	\N
憂慮	ゆうりょ	{慎む・先を考えること}	{"reserved / foresight"}	\N
有料	ゆうりょう	{}	{"admission-paid; toll"}	\N
有力	ゆうりょく	{}	{"influence; prominence; potent"}	\N
幽霊	ゆうれい	{}	{"ghost; specter; apparition; phantom"}	\N
誘惑	ゆうわく	{}	{"temptation; allurement; lure"}	\N
故に	ゆえに	{前に述べた事を理由として、あとに結果が導かれることを表す。数学の証明問題などでは「∴」の記号が用いられる。よって。したがって。「貴君の功績は大きい。―ーれを賞する」}	{"therefore; accordingly; consequently"}	\N
愉快	ゆかい	{}	{"pleasant; happy"}	\N
浴衣	ゆかた	{}	{"bathrobe; informal summer kimono"}	\N
雪	ゆき	{}	{snow}	\N
行く行くは	ゆくゆくは	{将来。いつか。結局。}	{"in the future; someday; in the end"}	\N
湯気	ゆげ	{}	{"steam; vapour"}	\N
輸血	ゆけつ	{}	{"blood transfusion"}	\N
揺さぶる	ゆさぶる	{}	{"to shake; to jolt; to rock; to swing"}	\N
輸出	ゆしゅつ	{}	{export}	\N
譲る	ゆずる	{}	{"turn over; assign; hand over; transmit; convey; sell; dispose of; yield; surrender"}	\N
輸送	ゆそう	{}	{"transport; transportation"}	\N
豊か	ゆたか	{}	{"abundant; wealthy; plentiful; rich"}	\N
油断	ゆだん	{不注意である；警戒を怠る}	{"be careless; be off (one)'s guard; negligence"}	\N
癒着	ゆちゃく	{}	{"adhesion; fastening; fixing"}	\N
油田	ゆでん	{}	{"an oil field"}	\N
輸入	ゆにゅう	{}	{"importation; import; introduction"}	\N
湯飲み	ゆのみ	{}	{teacup}	\N
湯呑み	ゆのみ	{}	{teacup}	\N
指	ゆび	{}	{finger}	\N
指差す	ゆびさす	{}	{"to point at"}	\N
指輪	ゆびわ	{}	{ring}	\N
弓	ゆみ	{}	{"bow (and arrow)"}	\N
夢	ゆめ	{}	{dream}	\N
由来	ゆらい	{}	{origin}	\N
揺らぐ	ゆらぐ	{}	{"to swing; to sway; to shake; to tremble"}	\N
揺り籠	ゆりかご	{赤ん坊を入れて揺り動かすかご。ようらん。}	{cradle}	\N
善事	ぜんじ	{}	{"good thing/deed"}	\N
床	ゆか	{}	{floor}	\N
揺り籃	ゆりかご	{赤ん坊を入れて揺り動かすかご。ようらん。}	{cradle}	\N
緩い	ゆるい	{}	{"loose; lenient; slow"}	\N
許す	ゆるす	{}	{"permit; allow; approve; exempt (from fine); excuse (from); confide in; forgive; pardon; excuse; release; let off"}	\N
緩む	ゆるむ	{}	{"to become loose; to slacken"}	\N
緩める	ゆるめる	{}	{"to loosen; to slow down"}	\N
緩やか	ゆるやか	{}	{lenient}	\N
揺れる	ゆれる	{}	{"shake; quake"}	\N
財宝	ざいほう	{財産や宝物。財産となる価値の高い物品。宝物。富。}	{"treasure(s); riches"}	\N
財	ざい	{}	{"fortune; riches"}	\N
在学	ざいがく	{}	{"(enrolled) in school"}	\N
財源	ざいげん	{}	{"source of funds; resources; finances"}	\N
在庫	ざいこ	{}	{"stockpile; stock"}	\N
財産	ざいさん	{}	{"property; fortune; assets"}	\N
座椅子	ざいす	{}	{"sitting chair"}	\N
財政	ざいせい	{}	{"economy; financial affairs"}	\N
材木	ざいもく	{}	{"lumber; timber"}	\N
材料	ざいりょう	{}	{"ingredients; material"}	\N
座敷	ざしき	{}	{"tatami room"}	\N
座席	ざせき	{}	{seat}	\N
座卓	ざたく	{}	{"sitting table"}	\N
座談会	ざだんかい	{}	{"symposium; round-table discussion"}	\N
雑	ざつ	{}	{"rough; crude"}	\N
雑音	ざつおん	{}	{"noise (jarring; grating)"}	\N
雑貨	ざっか	{}	{"miscellaneous goods; general goods; sundries"}	\N
雑誌	ざっし	{}	{"journal; magazine"}	\N
雑多	ざった	{いろいろなものが入りまじっていること。また、そのさま。「―な展示物」}	{"miscellaneous; mixed"}	\N
雑談	ざつだん	{}	{"chatting; idle talk"}	\N
雑木	ざつぼく	{}	{"various kinds of small trees; assorted trees"}	\N
座標	ざひょう	{}	{coordinate(s)}	\N
座布団	ざぶとん	{}	{"cushion (Japanese-- square cushion used when sitting on one´s knees on a tatami-mat floor)"}	\N
残金	ざんきん	{}	{"remaining money"}	\N
残酷	ざんこく	{}	{"cruelty; harshness"}	\N
残高	ざんだか	{}	{"(bank) balance; remainder"}	\N
惨敗	ざんぱい	{}	{"crushing defeat; ignominious defeat"}	\N
残念	ざんねん	{}	{sorry}	\N
前係長	ぜんかかりちょう	{前の係長}	{"previous chief"}	\N
税	ぜい	{}	{tax}	\N
税関	ぜいかん	{}	{"customs house"}	\N
税金	ぜいきん	{}	{"tax; duty"}	\N
贅沢	ぜいたく	{}	{"luxury; extravagance"}	\N
税抜	ぜいぬき	{}	{"excl. tax"}	\N
税務署	ぜいむしょ	{}	{"tax office"}	\N
是正	ぜせい	{}	{"correction; revision"}	\N
絶対	ぜったい	{}	{"absolute; unconditional; absoluteness"}	\N
絶版	ぜっぱん	{}	{"out of print"}	\N
絶壁	ぜっぺき	{切り立ったがけ。懸崖 (けんがい) 。「断崖ー」}	{"a precipice; 〔特に海岸の〕a cliff"}	\N
絶望	ぜつぼう	{希望を失うこと。全く期待できなくなること。「深い―におそわれる」「将来に―する」}	{"despair; hopelessness"}	\N
舌鋒	ぜっぽう	{言葉つきの鋭いことを、ほこさきにたとえていう語。「―鋭く追及する」}	{"scathing (question)"}	\N
絶滅	ぜつめつ	{}	{"destruction; extinction"}	\N
是非	ぜひ	{}	{"certainly; without fail"}	\N
是非とも	ぜひとも	{}	{"by all means (with sense of not taking 'no' for an answer)"}	\N
全	ぜん	{}	{"all; whole; entire; complete; overall; pan-"}	\N
善	ぜん	{}	{"good; goodness; right; virtue"}	\N
禅	ぜん	{}	{"Zen (Buddhism)"}	\N
禪	ぜん	{}	{"Zen (Buddhism)"}	\N
膳	ぜん	{}	{"(small) table; tray; meal"}	\N
全員	ぜんいん	{}	{"all members (unanimity); all hands; the whole crew"}	\N
全快	ぜんかい	{}	{"complete recovery of health"}	\N
全形	ぜんけい	{全体の形。すべての形。}	{whole-form}	\N
前後	ぜんご	{}	{"around; throughout; front and back; before and behind; before and after; about that (time); longitudinal; context; nearly; approximately"}	\N
全国	ぜんこく	{}	{"nation-wide; whole country; national"}	\N
禅師	ぜんじ	{}	{"zen master"}	\N
零	ぜろ	{}	{0}	\N
前者	ぜんしゃ	{}	{"the former"}	\N
全集	ぜんしゅう	{}	{"complete works"}	\N
全身	ぜんしん	{}	{"the whole body; full-length (portrait)"}	\N
前進	ぜんしん	{}	{"advance; drive; progress"}	\N
漸進	ぜんしん	{}	{"progressive; steady advance; gradual process"}	\N
全盛	ぜんせい	{}	{"height of prosperity"}	\N
全然	ぜんぜん	{}	{"wholly; entirely; completely; not at all (with neg. verb)"}	\N
全体	ぜんたい	{あるひとまとまりの物事のすべての部分。「組織の―にかかわる問題」「―の構造を把握する」「画用紙の―を使って描く」「―像」}	{"whole; entirety; whatever (is the matter)"}	\N
前提	ぜんてい	{ある物事が成り立つための、前置きとなる条件。「匿名を―に情報を提供する」「結婚を―につきあう」}	{"preamble; premise; reason; prerequisite"}	\N
全逓	ぜんてい	{「全逓信労働組合」の略称}	{"Japan Postal Workers' Union、JPU"}	\N
前途	ぜんと	{}	{"future prospects; outlook; the journey ahead"}	\N
全般	ぜんぱん	{}	{"whole; universal; wholly; general"}	\N
全部	ぜんぶ	{}	{"all; entire; whole; altogether"}	\N
全滅	ぜんめつ	{}	{annihilation}	\N
全裸	ぜんら	{}	{naked}	\N
善良	ぜんりょう	{}	{"goodness; excellence; virtue"}	\N
前例	ぜんれい	{}	{precedent}	\N
続行	ぞっこう	{引き続いて行うこと。}	{"continue; resume"}	\N
沿い	ぞい	{}	{along}	\N
像	ぞう	{}	{"statue; image; figure; picture; portrait"}	\N
増加	ぞうか	{}	{"increase; addition"}	\N
臓器	ぞうき	{}	{"organ (entrails)"}	\N
増強	ぞうきょう	{}	{"augment; reinforce; increase"}	\N
雑巾	ぞうきん	{}	{"dust cloth"}	\N
増減	ぞうげん	{}	{"increase and decrease; fluctuation"}	\N
蔵相	ぞうしょう	{}	{"Minister of Finance"}	\N
増殖	ぞうしょく	{ふえること。また、ふやすこと。「資本をーする」}	{"increase; multiplication; propagation"}	\N
増進	ぞうしん	{}	{"promoting; increase; advance"}	\N
造船	ぞうせん	{}	{shipbuilding}	\N
増大	ぞうだい	{}	{enlargement}	\N
草履	ぞうり	{}	{sandals}	\N
族	ぞく	{}	{"〔家族〕a family; 〔種族〕a race; 〔部族〕a tribe; 〔元素などの〕a group"}	\N
属する	ぞくする	{}	{"belong to; come under; be affiliated with; be subject to"}	\N
続々	ぞくぞく	{}	{"successively; one after another"}	\N
揃い	ぞろい	{衣服の色や柄などが同じであること。一組。揃っていること。}	{"team; gathering"}	\N
存知	ぞんじ	{よく知っていること。理解していること。「今は礼儀を―してこそふるまふべきに」}	{well-known}	\N
存じる	ぞんじる	{}	{"(humble) to know"}	\N
存ずる	ぞんずる	{}	{"(humble) to think; feel; consider; know; etc."}	\N
存知	ぞんち	{よく知っていること。理解していること。「今は礼儀を―してこそふるまふべきに」}	{well-known}	\N
図	ず	{}	{"drawing; picture; illustration"}	\N
ず	ず	{"活用語の未然形に付き、断定的な否定判断を表す。ない。ぬ。→ざり →ぬ"}	{"Another way to indicate an action that was done without doing another action is to replace the 「ない」 part of the negative action that was not done with 「ず」.  食べる → 食べない → 食べず 。 行く → 行かない → 行かず"}	\N
随筆	ずいひつ	{}	{"essays; miscellaneous writings"}	\N
随分	ずいぶん	{}	{"pretty much; very much"}	\N
図々しい	ずうずうしい	{}	{"impudent; shameless"}	\N
図鑑	ずかん	{}	{"picture book"}	\N
図形	ずけい	{}	{figure}	\N
涼む	すずむ	{}	{"cool oneself; cool off; enjoy evening cool"}	\N
ずつ	ずつ	{等しい量の繰り返し「少しー元気を回復した」}	{"(one) by (one); (little) by (little)"}	\N
頭痛	ずつう	{}	{headache}	\N
頭脳	ずのう	{}	{"head; brains; intellect"}	\N
象	ぞう	{}	{elephant}	\N
図表	ずひょう	{}	{"chart; diagram; graph"}	\N
滑れる	ずれる	{}	{"slide; slip off"}	\N
ローマ字	ローマじ	{}	{"romanization; Roman letters"}	\N
乗り越える	のりこえる	{物の上を越えて、向こう側へ行く。「塀を―・えて侵入する」,困難などを切り抜けて進む。「人生の荒波を―・える」}	{"〔上を越えて行く〕climb over (e.g. montain; fence)",〔苦難を切り抜ける〕overcome}	\N
ばりばり	ばりばり	{勢いよく裂いたりはがしたりする音や、そのさまを表す語。「ふすま紙を―（と）裂く」「ベニヤを―（と）はがす」「猫が―（と）爪を研ぐ」,固くこわばっているさま。「のりがきいて―（と）した浴衣」「―（と）した強飯 (こわめし) 」}	{"〔引き裂いたりする音〕rip-rip〔硬いこわばった物の音〕crunch-crunch; munch-munch","〔威勢よく行う様子〕(work) hard / energetically"}	\N
中	ちゅう	{}	{"medium; mediocre"}	\N
中	うち	{ある一定の区域・範囲の中。}	{"out of (a group); inside (a group)"}	\N
中	なか	{}	{"inside; middle; among"}	\N
様	よう	{}	{"way; manner; kind; sort; appearance; like; such as; so as to; in order to; so that","〔…らしい〕seems (to be); looks like (e.g. snow is falling); appearantly (e.g. fails)"}	\N
様に	ように	{〜に似て，同様に,〜の通りに,〜するために}	{"similar to; (light) as (a feather); likewise","(I did) as (told)","in order to; for the sake of; so that; as"}	\N
様	さま	{}	{"Mr. or Mrs.; manner; kind; appearance"}	\N
生臭い	なまぐさい	{}	{"smelling of fish or blood; fish or meat<br />臭い(くさい): stinking<br />面倒臭い(めんどうくさい): bother to do; tiresome"}	\N
取り敢えず	とりあえず	{何する間もなく。すぐに。差し当たり。,ほかのことはさしおいて、まず第一に。なにはさておき。何はさておき}	{"for the time being","first of all"}	\N
いらっしゃる	いらっしゃる	{「行く」の尊敬語。おいでになる。「休日にはどこへ―・るのですか」,「来る」の尊敬語。おいでになる。「先生が―・った」,「居る」の尊敬語。おいでになる。「明日は家に―・いますか」}	{"go; leave (for France)","come by","be; be in; be at home"}	\N
改める	あらためる	{新しくする。古いもの、旧来のものを新しいものと入れ替える。「日を＿・める」「第一項は次のように＿・める」,悪い点、不備な点をよいほうへ変える。改善する。「態度をー・める」「悪習をー・める」,正しいかどうか詳しく調べて確かめる。吟味する。「罪状をー・める」「財布の中身をー・める」}	{"renew; change; reform","correct; reform; improve upon","examine; count"}	\N
順応	じゅんのう	{環境や境遇の変化に従って性質や行動がそれに合うように変わること。「新しい生活に―する」「―性」}	{"adapt (oneself); adjust (oneself); conform;"}	\N
温める	あたためる	{程よい温度に高める。あたたかくする。あっためる。「冷えた手を―・める」「ミルクを―・める」}	{"〔熱くする〕warm (up); heat (up)","〔大事にしておく〕take care of (nursing; keep)"}	\N
世の中	よのなか	{々が互いにかかわり合って生きて暮らしていく場。世間。社会。「―が騒がしくなる」「暮らしにくい―になる」,当世。その時分。「入道殿をはじめ参らせて―におはしある人、参らぬはなかりけり」}	{"society; the world; the times","〔時勢〕times; 〔時代〕an age;"}	\N
行く行く	ゆくゆく	{行く末。やがて。将来。いつか。結局。「ーは家業を継ぐことになる」,歩きながら。道すがら。「何を買おうかとー考えていた」}	{"in the future; someday; in the end","〔途中で〕on the [one's] way"}	\N
設ける	もうける	{前もって用意・準備をする。「一席＿・ける」,建物・機関などを、こしらえる。設置する。「窓口をー・ける」「規則をー・ける」}	{"〔用意する〕provide; prepare","organize; set up; lay down (e.g. rules/laws); make (e.g. excuse)"}	\N
施す	ほどこす	{恵まれない人に物質的な援助を与える。あわれみの気持ちで、人が困っている状態を助けるような行為をする。恵み与える。「難民に食糧を―・す」「医療を―・す」「恩恵を―・す」,効果・影響を期待して、事を行う。「策を―・す」}	{"to donate; to give","to conduct; to apply; to perform"}	\N
変態	へんたい	{形や状態を変えること。また、その形や状態。,普通の状態と違うこと。異常な、または病的な状態。}	{"〔生物の〕(a) metamorphosis ((複-phoses))","〔異常〕abnormality; 〔性的な〕perversion"}	\N
反映	はんえい	{光や色などが反射して光って見えること。「夕日が雪山にーする」,あるものの性質が、他に影響して現れること。反影。また、それを現すこと。「住民の意見を政治にーさせる」}	{reflection,"reflection; influency"}	\N
灰皿	はいさら	{}	{ashtray}	\N
三日月	みかずき	{}	{"new moon; crescent moon"}	\N
三日月	みかづき	{}	{"new moon; crescent moon"}	\N
丈夫	じょうふ	{}	{"hero; gentleman; warrior; manly person; good health; robustness; strong; solid; durable"}	\N
審判	しんぱん	{}	{"refereeing; trial; judgement; umpire; referee"}	\N
作物	さくもつ	{}	{"literary work"}	\N
傾く	かたぶく	{}	{"to incline toward; to slant; to lurch; to heel over; to be disposed to; to trend toward; to be prone to; to go down (sun); to wane; to sink; to decline"}	\N
不便	ふびん	{}	{"pity; compassion"}	\N
鈍い	にぶい	{}	{"dull (e.g. a knife); thickheaded; slow; stupid"}	\N
一個	いっか	{}	{"1 piece (article)"}	\N
検証	けんしょう	{実際に物事に当たって調べ、仮説などを証明すること。「理論の正しさを―する」,裁判官や捜査機関が、直接現場の状況や人・物を観察して証拠調べをすること。「現場―」「実地―」}	{"〔実証〕(a) verification; verify (a hypothesis)","〔証拠物件などの取り調べ〕(an) inspection"}	\N
参謀	さんぼう	{謀議に加わること。また、その人。「選挙―」,高級指揮官の幕僚として、作戦・用兵などの計画に参与し、補佐する将校。}	{"〔相談役〕an adviser; a counselor，((英)) a counsellor; ((口)) a brain，〔総称〕the brains ((of))","〔軍の〕a staff officer; 〔総称〕the staff"}	\N
継続	けいぞく	{そのまま続くこと,中断してはまた続くこと}	{"continuation (of)","(〜に) continual(ly)"}	\N
覚える	おぼえる	{見聞きした事柄を心にとどめる。記憶する。「子供のころのことはー・えていない」,からだや心に感じる。「疲れをー・える」「愛着をー・える」}	{"learn; remember; bear ((a thing)) in mind; memorize",feel}	\N
応じる	おうじる	{呼びかけに返事をする。応答する。,相手の働きかけに対応して行動を起こす。こたえる。従う,物事の変化に合わせて、それにふさわしく対応する。適合する。「その場に―・じた処置」}	{"in answer to (your question); in response to (his call)","consent; agree (to conditions); accept (an order or challenge); meet/satisfy (a demand)","according to; in proportion to; depends on"}	\N
伺う	うかがう	{「聞く」の謙譲語。拝聴する。お聞きする。「おうわさはかねがね―・っております」,「聞く」の謙譲語。拝聴する。お聞きする。「おうわさはかねがね―・っております」,「訪れる」「訪問する」の謙譲語。「明朝、こちらから―・います」,神仏の託宣を願う。「御神託を―・う」,「尋ねる」「問う」の謙譲語。「この件について御意見をお―・いします」}	{"(polite) ask; inquire; hear; be told;","(polite) 〔聞く〕hear; be told (that)","(polite) 〔訪問する〕visit; call on (a person); call at (a place); pay (a person) a visit","implore (a god for an oracle)","(polite) 〔問う，尋ねる〕ask (about; a person something); inquire (about)"}	\N
糸口	いとぐち	{巻いてある糸の端。糸の先。,きっかけ。手がかり。}	{"the end of a thread","a lead; a clue"}	\N
頂く	いただく	{頭にのせる。かぶる。また、頭上にあるようにする。「王冠を―・く」「雪を―・いた山々」「星を―・いて夜道を行く」,「食う」「飲む」の謙譲語。,「もらう」の謙譲語。「激励の言葉を―・く」,（動詞の未然形に使役の助動詞「せる」「させる」の連用形、接続助詞「て」を添えた形に付いて）自己がある動作をするのを、他人に許してもらう意を表す。「させてもらう」の謙譲語。「あとで読ませて―・きます」「本日は休業させて―・きます」}	{"〔上に載せる〕have (a hat) on; wear (a hat; a crown); be crowned (with)","take food or drink","receive (polite)","receiving something for oneself;   (knitt this/explain this) for me"}	\N
鮮やか	あざやか	{ものの色彩・形などがはっきりしていて、目立つさま。「―な若葉の緑」「印象―な短編小説」,技術・動作などがきわだって巧みであるさま。「―な包丁さばき」}	{"〔色・形などが際立っている様子〕〜な vivid; bright","〔技術などがすぐれている様子〕〜な 〔見事な〕fine; 〔巧みな〕skillful，((英)) skilful"}	\N
ずっと	ずっと	{ある範囲内に、残す所なく動作を及ぼすさま。くまなく。隅から隅まで。「広い校内をー探しまわる」「町じゅうをー見まわる」,ためらわずに、また、とどこおらずに動作をするさま。ずいと。「さあ、ーお通りください」,ほかのものと比べてかけ離れているさま。段違いに。はるかに。「このほうがー大きい」「それよりー以前の話だ」「駅は学校のー先にある」}	{"all the (time; way); the whole (night; way)","straight (to a location); (go) right (in)","long (distance; time)"}	\N
しまう	しまう	{保存する。片づける。閉める,完了する。強調的に。好ましくない結果を示して。}	{"keep (e.g. your bankbook safe); put away/back (e.g. toys); close down (e.g. a store)","to do something by accident; to finish completely"}	\N
陵	みささぎ	{天皇・皇后などの墓所。御陵。みはか。}	{"emperor's grave; maosoleum"}	\N
陵	りょう	{尾根の長い大きな丘。「丘陵」,天子の墓。日本では、天皇および三后の墓をいう。山陵。丘の形をした大きな墓。みささぎ。「陵墓／古陵・御陵・山陵」}	{"hump; big hill","a mausoleum"}	\N
最早	もはや	{ある事態が変えられないところまで進んでいるさま。今となっては。もう。「―如何ともしがたい」「―これまで」,ある事態が実現しようとしているさま。早くも。まさに。「―今年も暮れようとしている」}	{"already; now","exactly; as early as"}	\N
萌える	もえる	{草木が芽を出す。芽ぐむ。「若草―・える野山」,俗に、ある物や人に対し、一方的で強い愛着心・情熱・欲望などの気持ちをもつ。→萌え}	{"bud; sprout","(also written 萌ゑ) crush (anime; manga term); fascination; infatuation"}	\N
見舞う	みまう	{病人や災難にあった人などを訪れて慰める。また、書面などで安否をたずねる。「けがをした友人を―・う」,望ましくない事が訪れる。災難などが襲う。「パンチを―・う」「台風に―・われる」}	{"〔人を尋ねて慰める〕inquire [ask] after ((a sick person/a person's health))","〔悪い物事が襲う〕meet with (a misfortune); struck (by waves)"}	\N
見事	みごと	{すばらしいこと,完全に}	{"excellent; splendid; fine; supurb; admirable","completely; proper; real"}	\N
風情	ふぜい	{風流・風雅の趣・味わい。情緒。「ーのある庭」,けはい。ようす。ありさま。「どことなく哀れなー」,名詞に付いて、...のようなもの、...に似通ったもの、などの意を表す。}	{"tasteful; elegant; poetic",appearance,"(traders and) the like; (no place for a fellow) like (that)"}	\N
深い	ふかい	{表面から底まで、また入り口から奥までの距離が長い。「―・い川」「―・い茶碗」「椅子に―・く腰掛ける」「山―・く分け入る」「彫りの―・い顔」⇔浅い。,密度が濃い。また、密生している。程度が大きい。「霧が―・い」「―・い草むら」}	{〔底までの隔たりが大きい〕deep,〔程度が大きい〕}	\N
許り	ばかり	{範囲を限定する意を表す。…だけ。…のみ。「あとは清書する―だ」「大きい―が能じゃない」,おおよその程度・分量を表す。…ほど。…くらい。「まだ半分―残っている」「一〇歳―の男の子」}	{"just (play games); nothing but; just (got home); only","about (20 mins); (ten mins) or so; some (20 people)"}	\N
填める	はめる	{ある形に合うように中に入れておさめる。ぴったりと入れ込む。「障子を桟にー・める」「コートのボタンをー・める」,計略にかける。いっぱいくわせる。「罠 (わな) にー・める」「策略にー・められる」}	{"to get in; to insert; to put on; to make love","わなに陥れる〕entrap; 〔だます〕take in"}	\N
走る	はしる	{足をすばやく動かして移動する。駆ける。「ゴールめざして―・る」「通りを―・って渡る」「―・るのが速い動物」,乗り物などが進む。運行する。また、物が速く動く。「駅から遊園地までモノレールが―・っている」「風を受けてヨットが―・る」「雲が―・る」}	{"to run","(vehicle) advance forward / run"}	\N
把握	はあく	{しっかりとつかむこと。手中におさめること。「政権をーする」,しっかりと理解すること。「その場の状況をーする」}	{"(lit.) grasp; catch","(fig.) grasp; catch; understanding"}	\N
望む	のぞむ	{自分の所に来てくれるように働きかける。欲しがる。「後妻にと―・まれる」,はるかに隔てて見る。遠くを眺めやる。「富士を―・む展望台」}	{"〔願望する〕want; wish，((文)) desire ((to do; a person to do))","〔眺める〕see; 〔見渡す〕((場所を主語にして)) command ((a view))"}	\N
半ば	なかば	{壱：半分,弐：ある程度,参：真ん中あたり}	{half,"partly; in part; half; nearly",mid-;halfway}	\N
土台	どだい	{物事の基礎。物事の根本。「信頼関係をーから揺るがす事件」,根本から。はじめから。もともと。「ー無理な相談だ」「ー勝てるはずがない」}	{"(stone or building) foundation; base; basis","foundation (of a person's character); base on (observations)"}	\N
通る	とおる	{往来する。通過する。突き抜ける。入る,認められて成り立つ。認められる。論理的である「法案がー・る」}	{"pass; go along","be accepted; make sense; be reasonable"}	\N
抱く	いだく	{腕でかかえ持つ。だく。「ひしと―・く」「母親の胸に―・かれる」,かかえるように包み込む。「村々を―・く山塊」「大自然の懐に―・かれる」}	{"embrace; hug; harbour; entertain; sleep with","〔心に持つ〕hold; have; bear，((文)) entertain; harbor，((英)) harbour; 〔心の中に大事にしまっておく〕cherish"}	\N
深い	ぶかい	{程度のはなはだしいさまを表す。「情け―・い」「疑り―・い」}	{〔程度が大きい〕}	\N
抱く	だく	{腕を回して、しっかりとかかえるように持つ。「子供を―・く」「肩を―・く」}	{"〔腕にかかえる〕hold ((a person; a thing)) in one's arms〔抱擁する〕embrace; hug"}	\N
家主	いえぬし	{}	{landlord}	\N
雷	いかずち	{}	{thunder}	\N
怒る	いかる	{}	{"to get angry; to be angry"}	\N
軍	いくさ	{}	{"war; battle; campaign; fight"}	\N
一定	いちじょう	{}	{"fixed; settled; definite; uniform; regularized; defined; standardized; certain; prescribed"}	\N
一人	いちにん	{}	{"one person"}	\N
一昨日	いっさくじつ	{}	{"day before yesterday"}	\N
一昨年	いっさくねん	{}	{"year before last"}	\N
間	かん	{時間の隔たり}	{"during (that time); for (30 mins); 〜で in (3 days)"}	\N
少女	おとめ	{}	{"daughter; young lady; virgin; maiden; little girl"}	\N
女子	おなご	{}	{"woman; girl"}	\N
各々	おのおの	{}	{"each; every; either; respectively; severally"}	\N
間	ま	{時間,空間,ころあい}	{time,space,"chance; opportune moment"}	\N
灰	あく	{}	{"puckery juice"}	\N
空く	あく	{}	{"become vacant"}	\N
開く	あく	{}	{"open (e.g. a festival)"}	\N
彼方此方	あちらこちら	{}	{"here and there"}	\N
悪口	あっこう	{}	{"abuse; insult; slander; evil speaking"}	\N
後	あと	{}	{"afterwards; since then; in the future"}	\N
上	うえ	{}	{"top; best; superior quality; going up; presenting; showing; aboard a ship or vehicle; from the standpoint of; as a matter of (fact)"}	\N
上下	うえした	{}	{"high and low; up and down; unloading and loading; praising and blaming"}	\N
甘い	うまい	{食物などの味がよい。おいしい。「―・い酒」「山の空気が―・い」⇔まずい。}	{delicious}	\N
末	うら	{}	{"top end; tip"}	\N
得る	うる	{}	{"obtain; acquire"}	\N
上手	うわて	{}	{"upper part; upper stream; left side (of a stage); skillful (only in comparisons); dexterity (only in comparisons)"}	\N
描く	かく	{絵・模様や図をえがく。「眉を―・く」「グラフを―・く」}	{"〔鉛筆・クレヨンなどで〕draw; 〔彩色して〕paint"}	\N
画く	えがく	{物の形を絵や図にかき表す。「田園の風景を―・く」}	{"〔鉛筆・ペンなどで〕draw; 〔絵筆で〕paint; sketch"}	\N
役	えき	{}	{"war; campaign; battle"}	\N
得る	える	{}	{"get; gain; win"}	\N
園	えん	{}	{"garden (esp. man-made)"}	\N
縁	えん	{}	{"chance; fate; destiny; relation; bonds; connection; karma"}	\N
塩	えん	{}	{salt}	\N
艶	えん	{}	{"charming; fascinating; voluptuous"}	\N
円	えん	{}	{"yen; circle"}	\N
降りる	おりる	{霧や霜などが地上・空中などに生じる。「露がー・りる」}	{"(e.g. frost;dew) to fall"}	\N
音	おん	{}	{"sound; (music) note"}	\N
禍	か	{災い。ふしあわせ。「―を転じて福となす」⇔福。}	{disaster}	\N
会	かい	{}	{"meeting; assembly; party; association; club"}	\N
画く	かく	{絵・模様や図をえがく。「眉を―・く」「グラフを―・く」}	{"〔鉛筆・クレヨンなどで〕draw; 〔彩色して〕paint"}	\N
重なる	かさなる	{}	{"be piled up; lie on top of one another; overlap each other"}	\N
華奢	かしゃ	{華やかにおごること。はででぜいたくなこと。また、そのさま。}	{"luxury; pomp; delicate; slender; gorgeous"}	\N
火傷	かしょう	{}	{"burn; scald"}	\N
数	かず	{}	{"number; figure"}	\N
間	あいだ	{二つの物・場所にはさまれた部分。ある時からある時までの時間,あるグループの人たちの範囲。関係。間柄}	{"between; during","among (e.g. men/pictures); between (us); among (e.g. four pics); (born) of (Greek))"}	\N
上げる	あげる	{物の位置を低い所から高い所に移す。「箱を棚に―・げる」「幕を―・げる」「すだれを―・げる」⇔下ろす。,人の目についたり、広く知られるようにする。}	{"raise; elevate","bring to attention; mention"}	\N
余り	あまり	{}	{"not very; not much","remainder; remnant; surplus; balance; excess; scraps; residue"}	\N
動く	うごく	{}	{"to move; to stir; to shift; to shake; to swing; to operate; to run; to go; to work; to be touched; to be influenced; to waver; to fluctuate; to vary; to change; to be transferred",move}	\N
描く	えがく	{物の形を絵や図にかき表す。「田園の風景を―・く」,物事のありさまを文章や音楽などで写し出す。描写する。表現する。「下町の生活を―・いた小説」}	{"〔鉛筆・ペンなどで〕draw; 〔絵筆で〕paint; sketch","〔表現する〕describe; ((文)) depict"}	\N
居る	おる	{人が存在する。そこにいる。「海外に何年―・られましたか」,（「おります」の形で、自分や自分の側の者についていう）「いる」の丁寧な言い方。「五時までは会社に―・ります」}	{"be here (polite)","be here (polite)"}	\N
越す	こす	{ある物の上を通り過ぎて一方から他方へ行く。また、難所や障害となるものを通って、その先へ行く。「塀を―・す」「難関を―・す」「峠を―・す」,「行く」「来る」の意の尊敬語。「どちらへお―・しですか」「またお―・しください」}	{"〔横切る〕cross; 〔通り過ぎる〕pass","come over (here to e.g. the hospital)"}	\N
流石	さすが	{あることを認めはするが、特定の条件下では、それと相反する感情を抱くさま。そうは言うものの。それはそうだが、やはり。「味はよいが、これだけ多いと―に飽きる」「非はこちらにあるが、一方的に責められると―に腹が立つ」,予想・期待したことを、事実として納得するさま。また、その事実に改めて感心するさま。なるほど、やはり。「一人暮らしは―に寂しい」「―（は）ベテランだ」}	{"as one would expect","good; see ... (we can do it)"}	\N
餓鬼	がき	{生前の悪行のために餓鬼道に落ち、いつも飢えと渇きに苦しむ亡者。,《食物をがつがつ食うところから》子供を卑しんでいう語。「手に負えないーだ」}	{"〔餓鬼道の亡者〕a starving ghost","〔子供〕a brat"}	\N
添える	そえる	{主となるもののそばにつける。補助として付け加える。「贈り物に手紙を―・える」「薬味を―・える」「介護の手を―・える」,付き添わせる。付き従わせる。「旅行に案内役を―・える」}	{"〔そばに付けておく〕attach (to)","〔付け加える〕add (to)"}	\N
其処で	そこで	{前述の事柄を受けて、次の事柄を導く。それで。そんなわけで。「いろいろ意見された。ー考えた」,話題をかえたり、話題をもとにもどしたりすることを示す。さて。}	{"So then; that was why","now; ..; Okay; .."}	\N
陣	じん	{軍隊を配置して備えること。「背水のー」,軍隊の集結している所。兵営。陣地。陣営。「ーを張る」,いくさ。たたかい。合戦。「大坂夏のー」}	{camp,"a position (in battle)","battle; (ett slag)"}	\N
条	じょう	{細長いものを数えるのに用いる。「帯一―」「一―の川」,いくつかに分かれた事項の数を数えるのに用いる。「十七―の憲法」「第一―」}	{"counter for long things","Article (9 of the Constitution)"}	\N
兆	ちょう	{古代の占いで、亀の甲を焼いてできる裂け目の形。転じて、物事が起こる前ぶれ。きざし。しるし。「災いのー」,数の単位。1億の1万倍。10の12乗。古くは中国で1億の10倍。「八―円の予算」}	{"〔兆候〕⇒きざし(兆し) omen","〔数〕a trillion，((英)) a billion"}	\N
釣	つり	{}	{"change (e.g. for a dollar)",fishing}	\N
詰まり	つまり	{物が詰まること,別の語に置きかえれば。言い換えると。要するに；すなわち}	{"(pillow) is stuffed","in short; in other words; the long and short of it; what it all comes down to; that is to say"}	\N
迷う	まよう	{どうしたらよいか決断がつかない。「進学か就職かで―・う」「判断に―・う」,まぎれて、進むべき道や方向がわからなくなる。「山中で道に―・う」}	{"〔思い惑う〕be at a loss; 〔決断できない〕be irresolute","〔道が分からなくなる〕get lost; lose one's way ((in a wood)); 〔はぐれる〕stray"}	\N
無駄	むだ	{役に立たないこと。それをしただけのかいがないこと。益がないこと,浪費}	{"useless; no use","waste; wastefulness"}	\N
依る	よる	{動作の主体をだれと指し示す。「市民楽団にー・る演奏」,物事の性質や内容などに関係する。応じる。従う。「時と場合にー・る」「人にー・って感想が違う」「成功は努力いかんにー・る」}	{"〔基づく〕based on; attributed to","depending on; according to"}	\N
綿	わた	{}	{"cotton; padding"}	\N
私	わたくし	{}	{"I (formal); myself; private affairs"}	\N
蛇	へび	{}	{"a snake; 〔大蛇〕a serpent"}	{動物}
虎	とら	{}	{"〔動物〕〔雄〕a tiger; 〔雌〕a tigress; 〔子〕a tiger cub","〔酔っぱらい〕a drunk"}	{動物}
擦る	かする	{}	{"to touch lightly; to take a percentage (from)"}	\N
方々	かたがた	{}	{"persons; all people; this and that; here and there; everywhere; any way; all sides"}	\N
日付	かづけ	{}	{"date; dating"}	\N
門	かど	{}	{gate}	\N
角	かど	{}	{"corner; horn"}	\N
金	かね	{}	{"money; metal"}	\N
金庫	かねぐら	{}	{"safe; vault; treasury; provider of funds"}	\N
下品	かひん	{}	{"inferior article"}	\N
上	かみ	{}	{"top; head; upper part; emperor; a superior; upper part of the body; the above"}	\N
雷	かみなり	{}	{thunder}	\N
瓶	かめ	{}	{"earthenware pot"}	\N
身体	からだ	{}	{"the body"}	\N
体	からだ	{}	{"appearance; air; condition; state; form"}	\N
側	かわ	{}	{"side; row; surroundings; part; (watch) case"}	\N
冠	かん	{}	{"crown; diadem; first; best; peerless; cap; naming; designating; initiating on coming of age; top character radical"}	\N
乾	かん	{}	{"heaven; emperor"}	\N
管	かん	{}	{"pipe; tube"}	\N
館	かん	{}	{"house; hall; building; hotel; inn; guesthouse"}	\N
冠	かんむり	{}	{"crown; cap; first; best; peerless; naming; designating; top kanji radical"}	\N
傷	きず	{}	{"wound; injury; hurt; cut; gash; bruise; scratch; scar; weak point"}	\N
来る	きたる	{}	{"to come; to arrive; to be due to; to be next; to be forthcoming"}	\N
気配	きはい	{}	{"indication; market trend; worry"}	\N
君	きみ	{}	{you}	\N
極める	きめる	{}	{"decide; determine"}	\N
客	きゃく	{}	{"guest; customer"}	\N
客人	きゃくじん	{客として来ている人。}	{guest}	\N
華奢	きゃしゃ	{姿かたちがほっそりして、上品に感じられるさま。繊細で弱々しく感じられるさま。「―なからだつき」}	{"〜な 〔ひ弱な感じの〕delicate; 〔ほっそりした〕slender; slim"}	\N
球	きゅう	{}	{"globe; sphere; ball"}	\N
今日	きょう	{}	{"today; this day"}	\N
姉妹	きょうだい	{}	{sisters}	\N
着る	きる	{衣類などを身につける。}	{"put on; wear"}	\N
際	きわ	{}	{"edge; brink; verge; side"}	\N
木綿	きわた	{}	{cotton}	\N
金	きん	{}	{"metal; money; gold"}	\N
金色	きんいろ	{金のような輝きのある黄色。こがねいろ。こんじき。「―の穂波」}	{"golden; golden-colored"}	\N
近々	きんきん	{}	{"nearness; before long"}	\N
金庫	きんこ	{}	{"safe; vault; treasury; provider of funds"}	\N
九	く	{}	{nine}	\N
潜る	くぐる	{}	{"to drive; to pass through; to evade; to hide; to dive (into or under water); to go underground"}	\N
屎	くそ	{動物が、消化器で消化したあと、肛門から排出する食物のかす。大便。ふん。}	{"〔うんこ〕((俗)) shit; 〔牛馬の〕dung⇒だいべん(大便)"}	\N
糞	くそ	{動物が、消化器で消化したあと、肛門から排出する食物のかす。大便。ふん。}	{"〔うんこ〕((俗)) shit; 〔牛馬の〕dung⇒だいべん(大便)"}	\N
管	くだ	{}	{"pipe; tube"}	\N
下る	くだる	{}	{"go down; descend; leave"}	\N
国境	くにざかい	{}	{"national or state border"}	\N
包む	くるむ	{}	{"to be engulfed in; to be enveloped by; to wrap up; to tuck in; to pack; to do up; to cover with; to dress in; to conceal"}	\N
剣	けん	{両刃 (もろは) の刀。また、広く両刃・片刃の区別なく大刀 (だいとう) をいう。つるぎ。太刀 (たち) }	{"a sword; 〔フェンシング用〕an epee; 〔短剣〕a dagger"}	\N
戸	こ	{}	{"counter for houses"}	\N
工場	こうじょう	{}	{factory}	\N
工場	こうば	{}	{"factory; plant; mill; workshop"}	\N
紅葉	こうよう	{}	{"autumn colours"}	\N
堪える	こたえる	{}	{"to bear; to stand; to endure; to put up with; to support; to withstand; to resist; to brave; to be fit for; to be equal to"}	\N
国境	こっきょう	{隣接する国と国との境目。国家主権の及ぶ限界。河川・山脈などによる自然的なものと、協定などによって人為的に決定するものとがある。くにざかい。}	{"national or state border"}	\N
この間	このあいだ	{}	{"the other day; lately; recently"}	\N
この間	このかん	{}	{"during this time"}	\N
堪える	こらえる	{}	{"to bear; to stand; to endure; to put up with; to support; to withstand; to resist; to brave; to be fit for; to be equal to"}	\N
凝る	こる	{冷えて固まる。凍る。「露が―・って霜になる時節なので」}	{"〔筋肉が固くなる〕become stiff"}	\N
頃	ころ	{}	{"time; about; toward; approximately (time)"}	\N
魂	こん	{}	{"soul; spirit"}	\N
盛る	さかる	{勢いが盛んになる。「火が―・る」「燃え―・る炎」}	{"to prosper; to flourish; to copulate (animals)"}	\N
桟橋	さんばし	{船を横づけにして、人の乗り降りや貨物の積みおろしなどができるように、岸から水上に突き出して造った構築物。床面を木・鉄・コンクリートなどの柱で支える。}	{"a pier; a jetty; a wharf ((複wharves))"}	\N
四	し	{}	{four}	\N
市	し	{}	{"market; fair"}	\N
次	し	{}	{"order; sequence; times; next; below"}	\N
氏	し	{}	{"family name; lineage"}	\N
塩	しお	{}	{salt}	\N
市場	しじょう	{売り手と買い手とが特定の商品や証券などを取引する場所。中央卸売市場・証券取引所（金融商品取引所）・商品取引所など。マーケット。}	{"a market; 〔取り引き所〕an exchange"}	\N
下	した	{}	{"under; below; beneath"}	\N
認める	したためる	{}	{"to write up"}	\N
品	しな	{}	{"thing; article; goods; dignity; counter for meal courses"}	\N
姉妹	しまい	{}	{sisters}	\N
種	しゅ	{}	{"kind; variety; species"}	\N
背負う	しょう	{}	{"to be burdened with; to carry on back or shoulder"}	\N
傷	しょう	{}	{"wound; injury; hurt; cut; gash; bruise; scratch; scar; weak point"}	\N
象	しょう	{}	{phenomenon}	\N
消耗	しょうこう	{}	{"exhaustion; consumption"}	\N
少女	しょうじょ	{}	{"daughter; young lady; virgin; maiden; little girl"}	\N
退く	しりぞく	{}	{"to retreat; to recede; to withdraw"}	\N
商人	しょうにん	{}	{"trader; shopkeeper; merchant"}	\N
消耗	しょうもう	{使って減らすこと。また、使って減ること。「電力を―する」}	{"exhaustion; consumption"}	\N
所々	しょしょ	{}	{"here and there; some parts (of something)"}	\N
退ける	しりぞける	{}	{"to repel; to drive away"}	\N
印	しるし	{}	{"seal; stamp; mark; print"}	\N
身体	しんたい	{}	{"body; health"}	\N
玉	ぎょく	{}	{"king (shogi)"}	\N
下品	げひん	{}	{"inferior article"}	\N
原	げん	{}	{"original; primitive; primary; fundamental; raw"}	\N
現場	げんじょう	{}	{"actual spot; scene; scene of the crime"}	\N
強気	ごうぎ	{}	{"great; grand"}	\N
応え	ごたえ	{}	{"well worth (e.g. reading); rich in (content); e.g. 遊び＿ well worth playing"}	\N
数	すう	{}	{"number; (mathematics) function"}	\N
末	すえ	{}	{"end; close; future; finally; tip; top; trivialities; posterity; youngest child"}	\N
空く	すく	{ある空間を満たしていた人や物が少なくなって、あきができる。まばらになる。減る。「がらがらに―・いた電車」「道路が―・く」}	{"be less crowded; open; become open; become empty"}	\N
角	すみ	{}	{"corner; nook"}	\N
天皇	すめらぎ	{}	{"Emperor of Japan"}	\N
為る	する	{}	{"do; try; play; practice; cost; serve as; pass; elapse"}	\N
空	そら	{頭上はるかに高く広がる空間。天。天空。「鳥のようにーを飛び回りたい」,その人の居住地や本拠地から遠く離れている場所。または、境遇。「異国のー」「旅のー」,心の状態。心持ち。心地。また、心の余裕。「生きたーもない」,それらしく思われるが実際はそうでない、という意を表す。うそ。いつわり。「ー涙」「ー笑い」「ーとぼける」,すっかり覚え込んでいて、書いたものなどを見ないで済むこと。「山手線の駅名をーで言える」}	{sky,"land; place; location;","feelings; emotion","pretending; lie","(learn) by heart; (recite) from memory"}	\N
戯れる	ざれる	{ふざける。たわむれる。「男女が―・れる」}	{"play around"}	\N
実	じつ	{}	{"truth; reality; sincerity; fidelity; kindness; faith; substance; essence"}	\N
十分	じっぷん	{}	{"10 minutes"}	\N
戯れる	じゃれる	{ふざけたわむれる。まつわりついてたわむれる。「子猫がまりに―・れる」}	{play}	\N
十	じゅう	{}	{"10; ten"}	\N
上下	じょうげ	{}	{"high and low; up and down; unloading and loading; praising and blaming"}	\N
堪える	たえる	{}	{"to bear; to stand; to endure; to put up with; to support; to withstand; to resist; to brave; to be fit for; to be equal to"}	\N
丈	たけ	{}	{"height; stature; length; measure; all (one has)"}	\N
畳	たたみ	{}	{"tatami mat"}	\N
唯	ただ	{}	{"free of charge; mere; sole; only; usual; common"}	\N
館	たち	{}	{"mansion; small castle"}	\N
唯	たった	{}	{"only; merely; no more than"}	\N
他人	たにん	{}	{"another person; unrelated person; outsider; stranger"}	\N
種	たね	{}	{"seed; kind; variety; quality; tone; material; matter; subject; theme; (news) copy; cause; source; trick; secret; inside story"}	\N
度	たび	{}	{"times (three times; etc.); degree"}	\N
玉	たま	{}	{"ball; sphere; coin"}	\N
球	たま	{}	{"globe; sphere; ball"}	\N
魂	たましい	{生きものの体の中に宿って、心の働きをつかさどると考えられるもの。古来、肉体を離れても存在し、不滅のものと信じられてきた。霊魂。たま。「―が抜けたようになる」「仏作って―入れず」}	{"〔霊魂〕a soul〔心・気力〕spirit"}	\N
例	ためし	{}	{"instance; example; case; precedent; experience; custom; usage; parallel; illustration"}	\N
誰	たれ	{}	{"adjectival suffix for a person"}	\N
値	ち	{}	{value}	\N
近々	ちかぢか	{}	{"nearness; before long"}	\N
父母	ちちはは	{}	{"father and mother; parents"}	\N
昼間	ちゅうかん	{}	{"daytime; during the day"}	\N
中指	ちゅうし	{}	{"middle finger"}	\N
次	つぎ	{}	{"next; stage station; stage; subsequent"}	\N
月日	つきひ	{}	{"(the) date"}	\N
突く	つく	{とがった物で一つ所を勢いよく刺したり、強く当てたりする。「槍で―・く」}	{"thrust; strike; attack; poke; nudge; pick at"}	\N
吐く	つく	{好ましくないことを口に出して言う。「悪態をー・く」「うそをー・く」}	{"told/spit (a lie); drew (e.g. a sigh of relief)"}	\N
注ぐ	つぐ	{}	{"pour (in); fill (with)"}	\N
途中	つちゅう	{}	{"on the way; en route"}	\N
銃	つつ	{}	{gun}	\N
突く	つつく	{}	{"to thrust; to strike; to attack; to poke; to nudge; to pick at"}	\N
包む	つつむ	{}	{"wrap; pack"}	\N
伝言	つてごと	{}	{"verbal message; rumor; word"}	\N
体	てい	{}	{"appearance; air; condition; state; form"}	\N
梯子	ていし	{}	{"ladder; stairs"}	\N
的	てき	{}	{"-like; typical"}	\N
敵	てき	{}	{"foe; enemy; rival"}	\N
店	てん	{}	{"store; shop; establishment"}	\N
天皇	てんのう	{}	{"Emperor of Japan"}	\N
都	と	{}	{"metropolitan; municipal"}	\N
等	とう	{}	{"et cetera; etc.; and the like"}	\N
床	とこ	{}	{"bed; sickbed; alcove; padding"}	\N
所々	ところどころ	{}	{"here and there; some parts (of something)"}	\N
年月	としつき	{}	{"months and years"}	\N
途中	とちゅう	{出発してから目的地に着くまでの間。まだ目的地に到着しないうち。「出勤―の事故」「―で引き返す」}	{"on the way"}	\N
止める	とどめる	{}	{"to stop; to cease; to put an end to"}	\N
幕	とばり	{}	{"curtain; bunting; act (in play)"}	\N
止まる	とまる	{動いていたものが動かなくなる。動きをそこでやめた状態になる。停止する。「時計が―・る」「特急の―・る駅」「エンジンが―・る」}	{"come to a halt"}	\N
留まる	とまる	{一定期間ある場所にいること。動作として止まっているとは限らない。}	{"fasten; turn off; detain"}	\N
灯	ともしび	{}	{light}	\N
誰	だれ	{}	{who}	\N
度	ど	{}	{"time (occurrence); system"}	\N
銅	どう	{}	{copper}	\N
退く	どく	{}	{"retreat; recede; withdraw"}	\N
何々	なになに	{}	{"such and such; What?; What is the matter?"}	\N
生	なま	{}	{"raw; unprocessed"}	\N
平均	ならし	{}	{"equilibrium; balance; average; mean"}	\N
為る	なる	{}	{"change; be of use; reach to"}	\N
南	なん	{}	{south}	\N
悪い	にくい	{}	{"hateful; abominable; poor-looking"}	\N
二人	ににん	{}	{"two persons; two people; pair; couple"}	\N
入る	はいる	{}	{"enter; break into; join; enroll; contain; hold; accommodate; have (an income of)"}	\N
吐く	はく	{}	{"breathe; tell (lies); vomit"}	\N
弾く	ひく	{}	{"play (piano; guitar)"}	\N
額	ひたい	{}	{"forehead; brow"}	\N
日付	ひづけ	{}	{date}	\N
人	ひと	{}	{"man; person; human being; mankind; people; character; personality; true man; man of talent; adult; other people; messenger; visitor"}	\N
一言	ひとこと	{}	{"single word"}	\N
一人	ひとり	{}	{"one person"}	\N
暇	ひま	{}	{"free time; leisure; leave; spare time; farewell"}	\N
表	ひょう	{}	{"table (in a document); chart; list"}	\N
開く	ひらく	{}	{"to open"}	\N
昼間	ひるま	{}	{"daytime; during the daytime"}	\N
品	ひん	{}	{"article; item"}	\N
二人	ふたり	{}	{"two persons; two people; pair; couple"}	\N
仏	ふつ	{}	{French}	\N
不定	ふてい	{決まっていないこと。一定しないこと。また、そのさま。「居所が―な人」「住所―」}	{"〜の〔不安定な〕unsettled; 〔不明確な〕indefinite"}	\N
不定	ふじょう	{さだまらないこと。確かでないこと。また、そのさま。ふてい。「老少―」「生死 (しょうじ) ―」}	{"unforseen; uncertain; unexpected"}	\N
父母	ふぼ	{}	{"father and mother; parents"}	\N
文	ふみ	{}	{"letter; writings"}	\N
糞	ふん	{動物が肛門から排泄 (はいせつ) する食物のかす。大便。くそ。}	{"excrement; ((文))((米)) feces，((英)) faeces [físiz]; ((俗)) a turd; ((卑)) shit; 〔牛・馬など大きい動物の〕dung; 〔特に鳥の〕droppings"}	\N
平均	へいきん	{}	{"equilibrium; balance; average; mean"}	\N
牛	うし	{}	{cow}	{動物}
方々	ほうぼう	{}	{"persons; this and that; here and there; everywhere; any way; all sides; all people"}	\N
外	ほか	{}	{"other place; the rest"}	\N
他	ほか	{}	{"other (especially places and things)"}	\N
骨	ほね	{}	{bone}	\N
判	ばん	{}	{"size (of paper or books)"}	\N
病	びょう	{やむ。やまい。「病気」悪いこと。欠点。「病弊」}	{"sickness; bad point"}	\N
瓶	びん	{}	{"bottle; vase; vial"}	\N
打つ	ぶつ	{}	{"hit; strike"}	\N
分	ぶん	{}	{"part; segment; share; ration; rate; degree; one´s lot; one´s status; relation; duty; kind; lot; in proportion to; just as much as"}	\N
文	ぶん	{}	{sentence}	\N
幕	まく	{}	{"curtain; screen"}	\N
呪い	まじない	{神仏その他不可思議なものの威力を借りて、災いや病気などを起こしたり、また除いたりする術。「―をかける」「人前でもあがらないお―」}	{"(an) incantation"}	\N
未だ	まだ	{}	{"yet; still; more; besides"}	\N
街	まち	{}	{street}	\N
客人	まろうど	{訪ねて来た人。きゃく。きゃくじん。}	{guests}	\N
客	まろうど	{訪ねて来た人。きゃく。きゃくじん。}	{guests}	\N
万	まん	{}	{"10;000; ten thousand; myriad(s); all; everything"}	\N
刃	やいば	{刀剣・刃物などの総称。「―を交える」「―を向ける」}	{"〔刀身〕a blade; 〔刀〕a sword"}	\N
夜行	やぎょう	{}	{"walking around at night; night train; night travel"}	\N
役	やく	{}	{"use; service; role; position"}	\N
訳	やく	{}	{translation}	\N
火傷	やけど	{}	{"burn; scald"}	\N
夜行	やこう	{}	{"walking around at night; night train; night travel"}	\N
養う	やしなう	{養育する}	{"bring up; rear; raise"}	\N
夜中	やちゅう	{}	{"all night; the whole night"}	\N
病	やまい	{病気。わずらい。「胸の―」}	{"〔病気〕illness; 〔特定の病気〕a disease〔悪癖〕a bad habit"}	\N
例	れい	{}	{"instance; example; case; precedent; experience; custom; usage; parallel; illustration"}	\N
訳	わけ	{}	{reason}	\N
禍	わざわい	{災い。ふしあわせ。「―を転じて福となす」⇔福。}	{disaster}	\N
より	より	{比較の標準・基準を表す。「思ったー若い」,ある事物を、他との比較・対照としてとりあげる意を表す。「僕ー君のほうが金持ちだ」「音楽ー美術の道へ進みたい」,事柄の理由・原因・出自を表す。...がもとになって。...から。...のために。,動作・作用の起点を表す。…から。「午前一〇時―行う」「父―手紙が届いた」「東―横綱登場」,動作の移動・経由する場所を表す。…を通って。…を。…から。}	{"(younger) than (you); (better) than (movies); (looks younger) than (her age); (rather have tea) than (coffee)","even (harder/taller);","as a result of; due to 「河川の汚染より伝染病が発生した」","from (6 o'clock); as of (April); according to","〔出発点，起点〕⇒−からfrom; (depart) from (Haneda); (1k away) from (the park); (within 100m) of (the station)"}	\N
ように	様に	{〜に似て，同様に,〜の通りに,〜するために}	{"similar to; (light) as (a feather); likewise","(I did) as (told)","in order to; for the sake of; so that; as"}	\N
背負う	せおう	{}	{"be burdened with; carry on back or shoulder"}	\N
前	せん	{}	{before}	\N
起こす	おこす	{横になっているものを立たせる。「からだを―・す」,目を覚まさせる。「寝入りばなを―・される」,今までなかったものを新たに生じさせる。「風力を利用して電気を―・す」「波を―・す」,平常と異なる状態や、好ましくない事態を生じさせる。ひきおこす。「革命を―・す」「事故を―・す」,""}	{〔横になったものを立てる〕raise,"〔目を覚まさせる〕wake (up)","〔始める〕start; begin","〔引き起こす〕cause; bring about","〔設立する〕establish; found"}	\N
挙げる	あげる	{検挙する。「犯人を―・げる」,表し示す。「例を―・げる」「証拠を―・げる」,""}	{arrest,"bring to attention; mention","to raise; to fly"}	\N
行書	ぎょうしょ	{漢字の書体の一。楷書をやや崩した書体で、楷書と草書の中間にあたる。}	{"Semi-cursive script is a cursive style of Chinese characters. Because it is not as abbreviated as cursive; most people who can read regular script can read semi-cursive."}	{書体}
魚	さかな	{}	{fish}	{動物}
申	さる	{十二支の9番目。}	{"〔十二支の一つ〕the Monkey (the ninth of the twelve signs of the Chinese zodiac); 〔方角〕west-southwest; west by southwest; 〔時刻〕the hour of the Monkey (4:00 p.m.; or the hours between 3:00 p.m. and 5:00 p.m.)"}	{動物}
子	し	{十二支の一で、その1番目。}	{"〔十二支の一つ〕the Rat (the first of the twelve signs of the Chinese zodiac); 〔方角〕north; 〔時刻〕the hour of the Rat (midnight or the hours between 11:00 p.m. and 1:00 a.m.)"}	{動物}
巳	し	{十二支の6番目。}	{"〔十二支の一つ〕the Snake (the sixth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Snake (10:00 a.m. or the hours between 9:00 a.m. and 11:00 a.m.); 〔方角〕south-southeast"}	{動物}
辰	しん	{十二支の一つで、その5番目。}	{"〔十二支の一つ〕the Dragon (the fifth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Dragon (8:00 a.m. or the hours between 7:00 a.m. and 9:00 a.m.); 〔方角〕east-southeast"}	{動物}
亥	ぐ	{十二支の12番目。}	{"〔十二支の一つ〕the Boar (the last of the twelve signs of the Chinese zodiac); 〔方角〕north-northwest; 〔時刻〕the hour of the Boar (10:00 p.m. or the hours between 9:00 p.m. and 11:00 p.m.)"}	{動物}
午	ご	{十二支の7番目。うま。}	{"〔十二支の一つ〕the Horse (the seventh of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Horse (noon or the hours between 11:00 a.m. and 1:00 p.m.); 〔方角〕south"}	{動物}
竜	たつ	{「りゅう（竜）」に同じ。}	{"a dragon"}	{動物}
辰	たつ	{十二支の一つで、その5番目。}	{"〔十二支の一つ〕the Dragon (the fifth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Dragon (8:00 a.m. or the hours between 7:00 a.m. and 9:00 a.m.); 〔方角〕east-southeast"}	{動物}
丑	ちゅう	{十二支の2番目。}	{"〔十二支の一つ〕the Ox (the second of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Ox (2:00 a.m. or the hours between 1:00 a.m. and 3:00 a.m.); 〔方角〕north-northeast"}	{動物}
寅	とら	{十二支の一つで、その3番目。}	{"〔十二支の一つ〕the Tiger (the third of the twelve signs of the Chinese zodiac); 〔方角〕east-northeast; 〔時刻〕the hour of the Tiger (4:00 a.m. or the hours between 3:00 a.m. and 5:00 a.m.)"}	{動物}
酉	とり	{十二支の一つで、その10番目。}	{"〔十二支の一つ〕the Cock (the tenth of the twelve signs of the Chinese zodiac); 〔方角〕west; 〔時刻〕the hour of the Cock (6:00 p.m. or the hours between 5:00 p.m. and 7:00 p.m.)"}	{動物}
豹	ひょう	{}	{panther}	{動物}
蛍	ほたる	{}	{firefly}	{動物}
猛虎	もうこ	{}	{"fierce tiger"}	{動物}
龍	りゅう	{}	{"a dragon"}	{動物}
子	ね	{十二支の一で、その1番目。}	{"〔十二支の一つ〕the Rat (the first of the twelve signs of the Chinese zodiac); 〔方角〕north; 〔時刻〕the hour of the Rat (midnight or the hours between 11:00 p.m. and 1:00 a.m.)"}	{動物}
未	ひつじ	{十二支の8番目。}	{"〔十二支の一つ〕the Sheep; the eighth of the twelve signs of the Chinese Zodiac; 〔時刻〕the hour of the Sheep; 2:00 p.m.; the hours between 1:00 p.m. and 3:00 p.m.; 〔方角〕south-southwest"}	{動物}
楷書	かいしょ	{漢字の書体の一。点画を正確に書き、現在、最も標準的な書体とされている。隷書から転じたもので、六朝 (りくちょう) 中期に始まり唐のころ完成した。真書。正書。}	{"Regular script. also called 正楷. is the newest of the Chinese script styles (appearing by the Cao Wei dynasty ca. 200 CE and maturing stylistically around the 7th century); hence most common in modern writings and publications (after the Ming and sans-serif styles; used exclusively in print)."}	{書体}
楷書体	かいしょたい	{漢字の書体の一。点画を正確に書き、現在、最も標準的な書体とされている。隷書から転じたもので、六朝 (りくちょう) 中期に始まり唐のころ完成した。真書。正書。}	{"Regular script. also called 正楷. is the newest of the Chinese script styles (appearing by the Cao Wei dynasty ca. 200 CE and maturing stylistically around the 7th century); hence most common in modern writings and publications (after the Ming and sans-serif styles; used exclusively in print)."}	{書体}
行書体	ぎょうしょたい	{漢字の書体の一。楷書をやや崩した書体で、楷書と草書の中間にあたる。}	{"Semi-cursive script is a cursive style of Chinese characters. Because it is not as abbreviated as cursive; most people who can read regular script can read semi-cursive."}	{書体}
草書	そうしょ	{書体の一。古くは、篆隷 (てんれい) を簡略にしたもの。後代には、行書 (ぎょうしょ) をさらに崩して点画を略し、曲線を多くしたもの。そう。そうがき。}	{"〔字体〕the fully cursive style of writing (Chinese characters); 〔文字〕a character written in 「a cursive hand [the cursive style]"}	{書体}
草書体	そうしょたい	{書体の一。古くは、篆隷 (てんれい) を簡略にしたもの。後代には、行書 (ぎょうしょ) をさらに崩して点画を略し、曲線を多くしたもの。そう。そうがき。}	{"〔字体〕the fully cursive style of writing (Chinese characters); 〔文字〕a character written in 「a cursive hand [the cursive style]"}	{書体}
篆書	てんしょ	{中国で秦以前に使われた書体。大篆と小篆とがあり、隷書・楷書のもとになった。印章・碑銘などに使用。篆。}	{"a style of writing Chinese characters (mainly used for seals); a tensho hand. The seal script (often called 'small seal' script) is the formal script of the Qín system of writing; which evolved during the Eastern Zhōu dynasty in the state of Qín and was imposed as the standard in areas Qín gradually conquered. Although some modern calligraphers practice the most ancient oracle bone script as well as various other scripts older than seal script found on Zhōu dynasty bronze inscriptions; seal script is the oldest style that continues to be widely practiced."}	{書体}
隷書	れいしょ	{漢字の書体の一。秦の程邈 (ていばく) が小篆 (しょうてん) を簡略化して作ったものといわれる。漢代に装飾的になり、後世、これを八分 (はっぷん) または漢隷、それ以前のものを古隷といって区別した。現在は一般に八分をさす。→八分}	{"Clerical script; also formerly chancery script; is an archaic style of Chinese calligraphy which evolved in the Warring States period to the Qin dynasty; was dominant in the Han dynasty; and remained in use through the Wei-Jin periods."}	{書体}
隷書体	れいしょたい	{漢字の書体の一。秦の程邈 (ていばく) が小篆 (しょうてん) を簡略化して作ったものといわれる。漢代に装飾的になり、後世、これを八分 (はっぷん) または漢隷、それ以前のものを古隷といって区別した。現在は一般に八分をさす。→八分}	{"Clerical script; also formerly chancery script; is an archaic style of Chinese calligraphy which evolved in the Warring States period to the Qin dynasty; was dominant in the Han dynasty; and remained in use through the Wei-Jin periods."}	{書体}
亥	い	{十二支の12番目。}	{"〔十二支の一つ〕the Boar (the last of the twelve signs of the Chinese zodiac); 〔方角〕north-northwest; 〔時刻〕the hour of the Boar (10:00 p.m. or the hours between 9:00 p.m. and 11:00 p.m.)"}	{動物}
戌	じゅつ	{十二支の11番目。}	{"〔十二支の一つ〕the Dog; the eleventh of the twelve signs of the Chinese zodiac; 〔方角〕west-northwest; 〔時刻〕the hour of the Dog (8:00 p.m. or the hours between 7:00 p.m. and 9:00 p.m.)"}	{動物}
狛犬	こまいぬ	{}	{"(mythologic) dog"}	{動物}
鮭	さけ	{}	{bass}	{動物}
猿	さる	{}	{monkey}	{動物}
獅子	しし	{}	{lion}	{動物}
縞馬	しまうま	{}	{zebra}	{動物}
鯛	たい	{}	{"sea bream"}	{動物}
鶴	つる	{}	{crane}	{動物}
鳥	とり	{}	{"bird; fowl; poultry"}	{動物}
卯	う	{十二支の4番目。}	{"〔十二支の一つ〕the Rabbit (the fourth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Rabbit (6:00 a.m. or the hours between 5:00 a.m. and 7:00 a.m.); 〔方角〕east"}	{動物}
丑	うし	{十二支の2番目。}	{"〔十二支の一つ〕the Ox (the second of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Ox (2:00 a.m. or the hours between 1:00 a.m. and 3:00 a.m.); 〔方角〕north-northeast"}	{動物}
未	び	{十二支の8番目。}	{"〔十二支の一つ〕the Sheep; the eighth of the twelve signs of the Chinese Zodiac; 〔時刻〕the hour of the Sheep; 2:00 p.m.; the hours between 1:00 p.m. and 3:00 p.m.; 〔方角〕south-southwest"}	{動物}
卯	ぼう	{十二支の4番目。}	{"〔十二支の一つ〕the Rabbit (the fourth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Rabbit (6:00 a.m. or the hours between 5:00 a.m. and 7:00 a.m.); 〔方角〕east"}	{動物}
蛇	み	{}	{"a snake; 〔大蛇〕a serpent"}	{動物}
巳	み	{十二支の6番目。}	{"〔十二支の一つ〕the Snake (the sixth of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Snake (10:00 a.m. or the hours between 9:00 a.m. and 11:00 a.m.); 〔方角〕south-southeast"}	{動物}
酉	ゆう	{十二支の一つで、その10番目。}	{"〔十二支の一つ〕the Cock (the tenth of the twelve signs of the Chinese zodiac); 〔方角〕west; 〔時刻〕the hour of the Cock (6:00 p.m. or the hours between 5:00 p.m. and 7:00 p.m.)"}	{動物}
竜	りゅう	{「りゅう（竜）」に同じ。}	{"a dragon"}	{動物}
犬	いぬ	{食肉目イヌ科の哺乳類。嗅覚・聴覚が鋭く、古くから猟犬・番犬・牧畜犬などとして家畜化。多くの品種がつくられ、大きさや体形、毛色などはさまざま。警察犬・軍用犬・盲導犬・競走犬・愛玩犬など用途は広い。,他人の秘密などをかぎ回って報告する者。スパイ。「官憲の―」}	{"a dog; 〔雌犬〕a bitch; a she-dog; 〔猟犬〕a hound","〔スパイ〕a spy; a secret agent"}	{動物}
戌	いぬ	{十二支の11番目。}	{"〔十二支の一つ〕the Dog; the eleventh of the twelve signs of the Chinese zodiac; 〔方角〕west-northwest; 〔時刻〕the hour of the Dog (8:00 p.m. or the hours between 7:00 p.m. and 9:00 p.m.)"}	{動物}
猪	い	{豚の原種で、肉は山鯨 (やまくじら) ・牡丹 (ぼたん) といわれ食用。しし。いのこ。}	{"a wild boar"}	{動物}
猪	いのしし	{豚の原種で、肉は山鯨 (やまくじら) ・牡丹 (ぼたん) といわれ食用。しし。いのこ。}	{"a wild boar"}	{動物}
寅	いん	{十二支の一つで、その3番目。}	{"〔十二支の一つ〕the Tiger (the third of the twelve signs of the Chinese zodiac); 〔方角〕east-northeast; 〔時刻〕the hour of the Tiger (4:00 a.m. or the hours between 3:00 a.m. and 5:00 a.m.)"}	{動物}
午	うま	{十二支の7番目。うま。}	{"〔十二支の一つ〕the Horse (the seventh of the twelve signs of the Chinese zodiac); 〔時刻〕the hour of the Horse (noon or the hours between 11:00 a.m. and 1:00 p.m.); 〔方角〕south"}	{動物}
魚	うお	{}	{fish}	{動物}
申	しん	{十二支の9番目。}	{"〔十二支の一つ〕the Monkey (the ninth of the twelve signs of the Chinese zodiac); 〔方角〕west-southwest; west by southwest; 〔時刻〕the hour of the Monkey (4:00 p.m.; or the hours between 3:00 p.m. and 5:00 p.m.)"}	{動物}
柏	かしわ	{}	{"Japanese oak"}	{植物}
桂	かつら	{}	{"Japanese Judas tree"}	{植物}
蒲	がま	{}	{"bulrush; broadleaf cattail; great reedmace; cooper's reed; cumbungi; Typha latifolia [Bredkaveldun]"}	{植物}
茅	かや	{}	{"grassy reed"}	{植物}
萱	かや	{}	{"grassy reed"}	{植物}
桐	きり	{}	{"paulownia tree"}	{植物}
昆布	こんぶ	{}	{"konbu (sea grass)"}	{植物}
桜	さくら	{}	{"cherry blossom; cherry tree"}	{植物}
薩摩芋	さつまいも	{}	{"sweet potato"}	{植物}
杉	すぎ	{}	{"Japanese cedar"}	{植物}
蒲公英	たんぽぽ	{}	{"[maskros]; dandelion; Taraxacum"}	{植物}
椿	つばき	{}	{camelia}	{植物}
梨	なし	{}	{"pear (fruit or tree)"}	{植物}
人参	にんじん	{}	{carrot}	{植物}
海苔	のり	{}	{"nori (sea grass)"}	{植物}
鹿尾菜	ひじき	{}	{"hijiki (sea grass)"}	{植物}
檜	ひのき	{桧。}	{"Japanese Cypress (old)"}	{植物}
桧	ひのき	{}	{"Japanese Cypress"}	{植物}
藤	ふじ	{}	{wisteria}	{植物}
桃	もも	{}	{"peach (tree)"}	{植物}
若布	わかめ	{}	{"wakame (sea grass)"}	{植物}
和布	わかめ	{}	{"wakame (sea grass)"}	{植物}
稚海藻	わかめ	{}	{"wakame (sea grass)"}	{植物}
柳	やなぎ	{}	{willow}	{植物}
榎	えのき	{}	{"enoki-take;  long; thin white mushroom used in East Asian cuisine"}	{菌類}
榎茸	えのきたけ	{}	{"enoki-take;  long; thin white mushroom used in East Asian cuisine"}	{菌類}
エリンギ	エリンギ	{}	{"Eryngii (trumpet mushroom); kungsmussling; king trumpet mushroom; French horn mushroom; king oyster mushroom; king brown mushroom; boletus of the steppes; trumpet royale"}	{菌類}
えりんぎ	えりんぎ	{}	{"Eryngii (trumpet mushroom); kungsmussling; king trumpet mushroom; French horn mushroom; king oyster mushroom; king brown mushroom; boletus of the steppes; trumpet royale"}	{菌類}
占地	シメジ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}
湿地	シメジ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}
占地茸	シメジたけ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}
湿地茸	シメジたけ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}
シメジ	シメジ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}
しめじ	しめじ	{}	{"shimeji; group of edible mushrooms native to East Asia; but also found in northern Europe."}	{菌類}
滑子	ナメコ	{}	{"Nameko; Namekotofsskivling; Pholiota nameko"}	{菌類}
橅占地	ブナシメジ	{}	{"buna-shimeji; Hypsizygus marmoreus"}	{菌類}
橅湿地	ブナシメジ	{}	{"buna-shimeji; Hypsizygus marmoreus"}	{菌類}
ブナシメジ	ブナシメジ	{}	{"buna-shimeji; Hypsizygus marmoreus"}	{菌類}
ぶなしめじ	ぶなしめじ	{}	{"buna-shimeji; Hypsizygus marmoreus"}	{菌類}
舞茸	まいたけ	{}	{"maitake; Grifola frondosa; Korallticka"}	{菌類}
松茸	まつたけ	{}	{"Matsutake; Goliatmusseron"}	{菌類}
合法的	ごうほうてき	{法規にかなっているさま。「―な手段」}	{"〔適法の〕lawful; 〔法定の〕legal; 〔法律上正当な〕legitimate"}	{形動}
形動	けいどう	{形容動詞の略。}	{"adjectival noun, adjectival, or na-adjective is a noun that can function as an adjective by taking the particle 〜な -na. (In comparison, regular nouns can function adjectivally by taking the particle 〜の -no, which is analyzed as the genitive case.)"}	\N
逃走経路	とうそうけいろ	\N	{"an escape route"}	\N
逃走者	とうそうしゃ	\N	{"a runaway; a fugitive (▼主に警察からの)"}	\N
駆除	くじょ	{害を与えるものを追い払うこと。「害虫を―する」「コンピューターウイルスを―する」}	{"'exterminate; get rid of (e.g. rats)'"}	\N
合体	がったい	{二つ以上のものがまとまって一つになること。「両派が―して新党をつくる」}	{union}	\N
切り取り線	きりとりせん	{切り離す位置を示した線。多く破線・点線で示す。}	{"a perforated line; a dotted line; 〔表示〕Cut [Tear off] here"}	\N
斬り取り	きりとり	{}	{"a cut out"}	\N
切り取り	きりとり	{}	{"a cut out"}	\N
弊害	へいがい	{害になること。他に悪い影響を与える物事。害悪。「―を及ぼす」「―が伴う」}	{"an evil; an abuse; 〔悪影響〕「an evil [a harmful] influence, a bad effect"}	\N
\.


--
-- TOC entry 2285 (class 0 OID 16722)
-- Dependencies: 174
-- Data for Name: names; Type: TABLE DATA; Schema: public; Owner: e
--

COPY names (name, reading, description, origin) FROM stdin;
大佐	たいさ	声：青野武。雷電の上官。	mgs
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
戸田山	とだやま	神奈川県警本部捜査一課刑事の母親	akutou
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
-- TOC entry 2284 (class 0 OID 16688)
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
\.


--
-- TOC entry 2169 (class 2606 OID 16692)
-- Name: meta_pkey; Type: CONSTRAINT; Schema: public; Owner: e; Tablespace: 
--

ALTER TABLE ONLY names_metadata
    ADD CONSTRAINT meta_pkey PRIMARY KEY (table_name);


--
-- TOC entry 2171 (class 2606 OID 16729)
-- Name: names_pkey; Type: CONSTRAINT; Schema: public; Owner: e; Tablespace: 
--

ALTER TABLE ONLY names
    ADD CONSTRAINT names_pkey PRIMARY KEY (name);


--
-- TOC entry 2167 (class 2606 OID 16485)
-- Name: 単語発音鍵; Type: CONSTRAINT; Schema: public; Owner: e; Tablespace: 
--

ALTER TABLE ONLY goi
    ADD CONSTRAINT "単語発音鍵" PRIMARY KEY ("単語", "発音");


--
-- TOC entry 2173 (class 2620 OID 16487)
-- Name: impute_missing_pronouncation; Type: TRIGGER; Schema: public; Owner: e
--

CREATE TRIGGER impute_missing_pronouncation BEFORE INSERT ON goi FOR EACH ROW EXECUTE PROCEDURE impute_missing_pronouncation();


--
-- TOC entry 2172 (class 2606 OID 16730)
-- Name: names_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: e
--

ALTER TABLE ONLY names
    ADD CONSTRAINT names_origin_fkey FOREIGN KEY (origin) REFERENCES names_metadata(table_name);


--
-- TOC entry 2293 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: e
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM e;
GRANT ALL ON SCHEMA public TO e;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2016-01-05 13:58:10 CET

--
-- PostgreSQL database dump complete
--

