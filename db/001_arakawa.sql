-- 001_arakawa.sql — 荒川区を開ける／座標の印を直す／画像を軽くする／teaserの誤配を直す
--
--   wrangler d1 execute sozoro --file=db/001_arakawa.sql --remote
--
-- 4つとも、根拠が確認できるものだけ入れてあります。判断が要るものは入れていません。
-- 実行前に  wrangler d1 export sozoro --output=backup.sql  を取ってください。

BEGIN TRANSACTION;

-- ── 1 ─────────────────────────────────────────────────────────────
-- 荒川区のライセンスは「要確認」ではなく CC BY。東京都オープンデータカタログで確認済み。
--   文化財一覧   https://catalog.data.metro.tokyo.lg.jp/dataset/t131181d0000000010
--   観光施設一覧 https://catalog.data.metro.tokyo.lg.jp/dataset/t131181d0000000006
-- 区のサイトの /a017/opendata/ は 404 になっているので、カタログ側を出典にする。

UPDATE sources SET license = 'CC BY 4.0',
  url = 'https://catalog.data.metro.tokyo.lg.jp/dataset/t131181d0000000010',
  catalog_id = 't131181d0000000010'
 WHERE id = 'arakawa_bunkazai';

UPDATE sources SET license = 'CC BY 4.0',
  url = 'https://catalog.data.metro.tokyo.lg.jp/dataset/t131181d0000000006',
  catalog_id = 't131181d0000000006'
 WHERE id = 'arakawa_kanko';

-- ── 2 ─────────────────────────────────────────────────────────────
-- coord_quality='chome' の194件は、実際には建物の座標が入っている。
-- 区が配布している 131181_cultural_property.csv の緯度・経度と、
-- 194件すべてが小数5桁まで一致することを確認済み（1件だけ約85mずれる
-- 旧千住製絨所煉瓦塀を除く）。丁目単位なのは所在地の文字列であって座標ではない。

UPDATE destinations SET coord_quality = 'point'
 WHERE source_id = 'arakawa_bunkazai' AND coord_quality = 'chome';

-- ── 3 ─────────────────────────────────────────────────────────────
-- 荒川区を案内対象にする。混雑の中心から徒歩30〜67分の帯にあたり、
-- 人を台東区の外へ逃がすための行き先そのもの。

UPDATE destinations SET status = 'active', updated_at = date('now')
 WHERE ward = '荒川区';


-- ── 4 ─────────────────────────────────────────────────────────────
-- 画像が Wikimedia の原寸。実測で1枚 2.9MB、3案表示だと最大12MB落ちる。
-- Special:FilePath の width で縮める。88pxのぼかしサムネと到着画面には640で足りる。
-- 実測: 2,915,333 bytes → 57,338 bytes (width=480) / 170,451 bytes (width=800)

UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ueno_Royal_Museum.JPG?width=640' WHERE id = 4566;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Senso-ji_Kaminarimon_201503a.jpg?width=640' WHERE id = 5810;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Komagata_Dozeu_-01.jpg?width=640' WHERE id = 5996;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kaneiji_2012.JPG?width=640' WHERE id = 7142;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tenno-ji_by_kolshica_in_Yanaka%2C_Tokyo_2.jpg?width=640' WHERE id = 7143;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jonen-ji_%28Taito%29.JPG?width=640' WHERE id = 7145;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Hoon-ji_%28Taito%29.JPG?width=640' WHERE id = 7146;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Higashi-Hongan-ji_%28Taito%29_01.JPG?width=640' WHERE id = 7147;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jisho-in_%28Taito%29.JPG?width=640' WHERE id = 7148;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tenry%C5%AB-in_%28Yanaka%2C_Taito%29_03.jpg?width=640' WHERE id = 7149;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kaneiji_gokokuin.jpg?width=640' WHERE id = 7151;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Zenshoan_temple_02.JPG?width=640' WHERE id = 7152;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Yuinen-ji_%28Taito%29.JPG?width=640' WHERE id = 7153;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_Senso-ji_2021-12_ac_%282%29.jpg?width=640' WHERE id = 7155;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Saizo-in_%28Taito%29.JPG?width=640' WHERE id = 7160;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kayadera.jpg?width=640' WHERE id = 7163;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ch%C5%8Dan-ji_%28Taito%2C_Tokyo%29_05.jpg?width=640' WHERE id = 7164;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Choo-in.JPG?width=640' WHERE id = 7165;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tokyo_-_Yanaka_090_-_Zuirinji_Temple_%2815623692879%29.jpg?width=640' WHERE id = 7166;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Bairin-ji_%28Taito%29.JPG?width=640' WHERE id = 7167;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kuhon-ji%2C_Taito.jpg?width=640' WHERE id = 7168;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Taho-in_%28Taito%29.JPG?width=640' WHERE id = 7169;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Shonen-ji_%28Taito%29.JPG?width=640' WHERE id = 7171;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Yoden-ji_%28Negishi%2C_Taito%29.JPG?width=640' WHERE id = 7172;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tengaku-in_%28Taito%29.JPG?width=640' WHERE id = 7173;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Shuken-ji_%28Taito%29.JPG?width=640' WHERE id = 7174;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E5%BE%A1%E5%BA%9C%E5%86%85%E5%85%AB%E5%8D%81%E5%85%AB%E3%83%B6%E6%89%80_%5E57_%E6%98%8E%E7%8E%8B%E9%99%A2_-_panoramio.jpg?width=640' WHERE id = 7177;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Nichirin-ji_%28Taito%29.JPG?width=640' WHERE id = 7178;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Busshin-ji_%28Taito%29.JPG?width=640' WHERE id = 7179;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Yokoyama_Taikan_Memorial_Hall.JPG?width=640' WHERE id = 7181;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Gyokurin-ji_%28Taito%29.JPG?width=640' WHERE id = 7182;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tait%C5%8D_Rizen-ji_2026.jpg?width=640' WHERE id = 7184;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sh%C5%8Dfuku-ji_%28Taito%29_04.jpg?width=640' WHERE id = 7186;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/H%C5%8Dgen-ji_%28Taito%2C_Tokyo%29_01.jpg?width=640' WHERE id = 7187;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Genku-ji_%28Taito-ku%2C_Tokyo%29.jpg?width=640' WHERE id = 7189;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tokyo_-_Yanaka_083_%2815622559249%29.jpg?width=640' WHERE id = 7190;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E5%BE%A1%E5%BA%9C%E5%86%85%E5%85%AB%E5%8D%81%E5%85%AB%E3%83%B6%E6%89%80_%5E64_%E5%8A%A0%E7%B4%8D%E9%99%A2_-_panoramio.jpg?width=640' WHERE id = 7192;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Chosho-ji_%28Taito%29.JPG?width=640' WHERE id = 7195;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Myokyo-ji_%28Taito%29.JPG?width=640' WHERE id = 7196;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_Fuji_Sengen_jinja.jpg?width=640' WHERE id = 7197;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Eisho-ji_%28Negishi%2C_Taito%29.JPG?width=640' WHERE id = 7198;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Fukuju-in_%28Taito%2C_Tokyo%29_01.jpg?width=640' WHERE id = 7199;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Seisui-ji_%28Taito-ku%29.jpg?width=640' WHERE id = 7200;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Iriya_Shingenji.jpg?width=640' WHERE id = 7201;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Shitaya_Jinja_Shrine%2C_Ueno.jpg?width=640' WHERE id = 7202;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Hozen-ji_%28Taito%29.JPG?width=640' WHERE id = 7203;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Rinko-ji_%28Taito%29.JPG?width=640' WHERE id = 7204;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Saitoku-ji_%28Taito%29.JPG?width=640' WHERE id = 7205;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Chomyo-ji_%28Taito%29.JPG?width=640' WHERE id = 7206;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Honju-ji_%28Taito%29.JPG?width=640' WHERE id = 7207;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Honryuin_202003a.jpg?width=640' WHERE id = 7208;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Imado-jinja_2021-12_ac_%281%29.jpg?width=640' WHERE id = 7209;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Konrei-ji_%28Taito%29.JPG?width=640' WHERE id = 7210;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Anraku-ji_%28Taito%29.JPG?width=640' WHERE id = 7211;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Saifuku-ji_%28Taito%29.JPG?width=640' WHERE id = 7212;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ryodaishi_04.JPG?width=640' WHERE id = 7213;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kaneiji_2012.JPG?width=640' WHERE id = 7215;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Atsuta-jinja_%28Imado%2C_Taito%29_01.jpg?width=640' WHERE id = 7219;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_shrine_2012.JPG?width=640' WHERE id = 7224;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/K%C5%8Dmy%C5%8D-ji_%28Moto-Asakusa%2C_Taito%29_01.jpg?width=640' WHERE id = 7226;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sorin-ji_%28Taito%29.JPG?width=640' WHERE id = 7229;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/K%C5%8Dgan-ji_%28Kiyokawa%2C_Taito%29_01.jpg?width=640' WHERE id = 7232;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Soji-in_%28Taito%29.JPG?width=640' WHERE id = 7238;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Senju-in_%28Taito%29.JPG?width=640' WHERE id = 7242;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Yofuku-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7247;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kyoo-ji_%28Taito%29.JPG?width=640' WHERE id = 7248;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Suwa_Jinja_%28Arakawa%29.JPG?width=640' WHERE id = 7249;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ishihama_Jinja.JPG?width=640' WHERE id = 7250;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ishihama_Jinja.JPG?width=640' WHERE id = 7251;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Koroku_Jinja_%28Arakawa%29.JPG?width=640' WHERE id = 7252;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jokan-ji.JPG?width=640' WHERE id = 7253;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Hongyo-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7257;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ishihama_Jinja.JPG?width=640' WHERE id = 7260;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Hongyo-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7286;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jokan-ji.JPG?width=640' WHERE id = 7289;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Manko-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7290;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Zensho-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7291;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Suwa_Jinja_%28Arakawa%29.JPG?width=640' WHERE id = 7295;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Joko-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7296;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jiz%C5%8D-ji_%28Nishi-Ogu%2C_Arakawa%29_01.jpg?width=640' WHERE id = 7298;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sekiun-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7303;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Enmei-in_%28Arakawa%29.JPG?width=640' WHERE id = 7304;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ogu_Hachiman_Jinja.JPG?width=640' WHERE id = 7352;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Hokai-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7362;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Nichikei-ji_%28Minami-Senju%2C_Arakawa%29_01.jpg?width=640' WHERE id = 7377;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kyoo-ji_%28Taito%29.JPG?width=640' WHERE id = 7384;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Senju%C5%8Dhashi_-01.jpg?width=640' WHERE id = 7443;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Enmei-in_%28Arakawa%29.JPG?width=640' WHERE id = 7459;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Enmei-in_%28Arakawa%29.JPG?width=640' WHERE id = 7465;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_Culture_Tourist_Information_Center_at_night.jpg?width=640' WHERE id = 7468;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/National_museum_of_western_art05s3200.jpg?width=640' WHERE id = 7469;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/The_oldest_Tokyo_National_University_of_Fine_Arts_and_Music_Concert_Hall.jpg?width=640' WHERE id = 7470;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E6%9D%B1%E4%BA%AC%E9%83%BD%E7%BE%8E%E8%A1%93%E9%A4%A8_-_panoramio.jpg?width=640' WHERE id = 7472;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ueno_Royal_Museum.JPG?width=640' WHERE id = 7473;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Yokoyama_Taikan_Memorial_Hall.JPG?width=640' WHERE id = 7474;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/%E5%A4%A7%E5%90%8D%E6%99%82%E8%A8%88%E5%8D%9A%E7%89%A9%E9%A4%A8.jpg?width=640' WHERE id = 7475;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/NMNC01s3200.jpg?width=640' WHERE id = 7477;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/2019_International_Library_of_Children%27s_Literature.jpg?width=640' WHERE id = 7479;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ichiyo_Memorial_Museum.JPG?width=640' WHERE id = 7480;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Shitamachi-museum-ueno-japan.jpg?width=640' WHERE id = 7482;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Taito-Ku_Calligraphy_Museum.JPG?width=640' WHERE id = 7483;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/ASAKURA_Museum_of_Sculpture_2020-01-12.jpg?width=640' WHERE id = 7484;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tokyo_National_Museum%2C_Honkan_2010.jpg?width=640' WHERE id = 7487;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tokyo_bunka_kaikan01_1920.jpg?width=640' WHERE id = 7488;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ueno_Zoo_20220414a1.jpg?width=640' WHERE id = 7495;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kaneiji_2012.JPG?width=640' WHERE id = 7498;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ootori_jinja.JPG?width=640' WHERE id = 7500;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E5%BE%85%E4%B9%B3%E5%B1%B1%E8%81%96%E5%A4%A9_-_panoramio_%2827%29.jpg?width=640' WHERE id = 7501;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/TorigoeJinja.JPG?width=640' WHERE id = 7506;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_Fuji_Sengen_jinja.jpg?width=640' WHERE id = 7507;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E5%AD%90%E8%A6%8F%E5%BA%B5_-_panoramio.jpg?width=640' WHERE id = 7515;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jomyo-in_%28Taito%29.JPG?width=640' WHERE id = 7518;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Onoterusaki_jinja.JPG?width=640' WHERE id = 7520;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_Senso-ji_2021-12_ac_%282%29.jpg?width=640' WHERE id = 7522;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_shrine_2012.JPG?width=640' WHERE id = 7523;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%2820130309%29%E4%BC%9D%E6%B3%95%E9%99%A2%E9%80%9A%E3%82%8A%EF%BC%8C%E5%8D%88%E5%BE%8C%E3%80%82_-_panoramio.jpg?width=640' WHERE id = 7524;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ueno_T%C5%8Dsh%C5%8D-g%C5%AB_DSC02777.JPG?width=640' WHERE id = 7527;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E5%AF%9B%E6%B0%B8%E5%AF%BA%E6%B8%85%E6%B0%B4%E8%A6%B3%E9%9F%B3%E5%A0%82_Kan-eiji_temple_-_panoramio.jpg?width=640' WHERE id = 7529;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/The_oldest_Tokyo_National_University_of_Fine_Arts_and_Music_Concert_Hall.jpg?width=640' WHERE id = 7530;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E8%A5%BF%E9%83%B7%E9%9A%86%E7%9B%9B%E5%83%8F_Takamori_Saigou_-_panoramio.jpg?width=640' WHERE id = 7532;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tenno-ji_by_kolshica_in_Yanaka%2C_Tokyo_2.jpg?width=640' WHERE id = 7533;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Shitaya_Jinja_Shrine%2C_Ueno.jpg?width=640' WHERE id = 7537;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Senso-ji_Kaminarimon_201503a.jpg?width=640' WHERE id = 7538;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sogenji_temple_kappadera.JPG?width=640' WHERE id = 7539;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Higashi-Hongan-ji_%28Taito%29_01.JPG?width=640' WHERE id = 7540;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Arakawa_yuen_wheel.jpg?width=640' WHERE id = 7566;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Mikawashima_Water_Reclamation_Center_Aerial_Photograph.jpg?width=640' WHERE id = 7568;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Mikawashima_Inari_Jinja.JPG?width=640' WHERE id = 7569;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jokan-ji.JPG?width=640' WHERE id = 7570;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Haiden_Facade.jpg?width=640' WHERE id = 7571;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Koroku_Jinja_%28Arakawa%29.JPG?width=640' WHERE id = 7574;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Entsuji_%28Arakawa%29_08.jpg?width=640' WHERE id = 7575;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ishihama_Jinja.JPG?width=640' WHERE id = 7576;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kannon-ji_%28Taito%29.JPG?width=640' WHERE id = 7578;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Josho-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7580;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jigen-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7581;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Manko-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7582;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sekiun-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7583;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Dairin-in_%28Nishi-Ogu%2C_Arakawa%29_01.jpg?width=640' WHERE id = 7585;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ogu_Hachiman_Jinja.JPG?width=640' WHERE id = 7586;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kez%C5%8D-in_%28Moto-Asakusa%2C_Taito%29_01.jpg?width=640' WHERE id = 7587;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Jiz%C5%8D-ji_%28Nishi-Ogu%2C_Arakawa%29_01.jpg?width=640' WHERE id = 7588;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Zensho-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7589;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Hongy%C5%8D-ji_%28Moto-Asakusa%2C_Taito%29_01.jpg?width=640' WHERE id = 7590;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Kyoo-ji_%28Taito%29.JPG?width=640' WHERE id = 7591;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Yofuku-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7592;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Joko-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7593;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Suwa_Jinja_%28Arakawa%29.JPG?width=640' WHERE id = 7594;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Seiun-ji_%28Arakawa%29.JPG?width=640' WHERE id = 7595;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Shusho-in_%28Arakawa%29.JPG?width=640' WHERE id = 7596;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Enmei-in_%28Taito%29.JPG?width=640' WHERE id = 7597;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Senso-ji_Kaminarimon_201503a.jpg?width=640' WHERE id = 7609;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Isetatsu01.jpg?width=640' WHERE id = 7612;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Komagata_Dozeu_-01.jpg?width=640' WHERE id = 7617;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Suzumoto_engeijo.jpg?width=640' WHERE id = 7622;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Ueno_matsuzakaya_20230127.jpg?width=640' WHERE id = 7632;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa_Hanayashiki_-01.jpg?width=640' WHERE id = 7640;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tsubameyu_20240629.jpg?width=640' WHERE id = 7788;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E6%9D%B1%E4%BA%AC%E9%83%BD%E5%8F%B0%E6%9D%B1%E5%8C%BA%E6%B8%85%E5%B7%9D2-13-18_%E7%8E%89%E5%A7%AB%E5%85%AC%E5%9C%92_%E5%85%AC%E8%A1%86%E4%BE%BF%E6%89%80.jpg?width=640' WHERE id = 7809;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Map_Tokyo_special_wards.svg?width=640' WHERE id = 7819;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Map_Tokyo_special_wards.svg?width=640' WHERE id = 7820;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Map_Tokyo_special_wards.svg?width=640' WHERE id = 7821;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tokyo_Yoshiwara_Taisho_Era_postcard.jpg?width=640' WHERE id = 7831;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E8%8A%B1%E5%9C%92%E5%85%AC%E5%9C%92_-_panoramio.jpg?width=640' WHERE id = 7834;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sumida_Park.jpg?width=640' WHERE id = 7840;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sumida_Park.jpg?width=640' WHERE id = 7841;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sumida_Park.jpg?width=640' WHERE id = 7842;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Sumida_Park.jpg?width=640' WHERE id = 7843;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Tenno-ji_by_kolshica_in_Yanaka%2C_Tokyo_2.jpg?width=640' WHERE id = 7844;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/Asakusa-Mon.JPG?width=640' WHERE id = 7859;
UPDATE destinations SET image_url = 'https://commons.wikimedia.org/wiki/Special:FilePath/1280px-%E6%9D%BE%E3%81%8C%E8%B0%B7%E6%A2%85%E5%9C%92%E5%85%AC%E5%9C%92%EF%BC%88%E5%8F%B0%E6%9D%B1%E5%8C%BA%EF%BC%89.jpg?width=640' WHERE id = 7862;

-- ── 5 ─────────────────────────────────────────────────────────────
-- 「食べる」に寺の teaser が付いている140件。teaser の割り当てを間違えている。
--   例: id=618 そば処 松月庵（飲食店営業・そば）→「観光地図には載っていない、静かな寺」
-- 食べる用の3文に振り直す。文そのものは既存のものをそのまま使っている。

UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 123;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 125;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 138;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 190;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 421;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 473;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 481;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 484;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 499;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 529;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 530;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 534;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 540;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 543;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 568;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 570;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 572;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 581;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 594;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 602;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 612;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 614;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 616;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 618;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 1306;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 1813;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 2132;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 2155;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 2209;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 2228;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 2269;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 2310;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 2391;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 2721;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 2732;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 2740;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 2844;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 2861;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 2884;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 2886;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 2962;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 2990;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 3033;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 3224;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 3345;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 3366;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 3643;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 3876;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 3994;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 4016;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 4017;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 4027;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 4150;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 4187;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 4260;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 4272;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 4280;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 4808;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5027;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5029;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5051;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5058;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5233;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5354;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5372;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5373;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5374;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5375;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5376;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5378;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5390;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5393;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5412;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5413;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5414;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5418;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5432;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5434;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5455;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5458;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5474;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5479;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5483;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5491;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5545;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5581;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5686;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5690;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5691;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5692;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5705;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5730;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5733;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5774;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5779;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 5846;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 5898;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 5999;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6073;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6146;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6183;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6184;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6185;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6188;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6191;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6192;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6194;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6195;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6204;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6205;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6215;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6229;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6234;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6235;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6257;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6263;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6296;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6327;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6381;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6465;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6612;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6619;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6625;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6629;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6638;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6648;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6661;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6711;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6724;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6734;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6770;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6854;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 6877;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 6931;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 6957;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 7050;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 7059;
UPDATE destinations SET teaser = '路地に灯りをともす食事処' WHERE id = 7071;
UPDATE destinations SET teaser = '看板の小さな食事処。地元の人が通う' WHERE id = 7080;
UPDATE destinations SET teaser = '通りから一本入ったところにある食事処' WHERE id = 7115;

COMMIT;

-- 確認
--   SELECT ward, status, COUNT(*) FROM destinations GROUP BY ward, status;
--     → 荒川区 active 253 になっていること
--   SELECT COUNT(*) FROM destinations WHERE source_id='arakawa_bunkazai' AND coord_quality='chome';
--     → 0 になっていること
--   （台東区 taito_bunkazai の46件は hidden のままなので残る。こちらは未検証）
--   SELECT COUNT(*) FROM destinations WHERE image_url LIKE '%upload.wikimedia.org%';
--     → 0 になっていること

