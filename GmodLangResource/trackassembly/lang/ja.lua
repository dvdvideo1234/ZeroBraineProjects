﻿return function(sTool, sLimit) local tSet = {} -- Japanese
  tSet["tool."..sTool..".workmode.1"    ] = "通常部分のスポーン／スナップ"
  tSet["tool."..sTool..".workmode.2"    ] = "アクティブポイントの交差点"
  tSet["tool."..sTool..".workmode.3"    ] = "曲線線分フィッティング"
  tSet["tool."..sTool..".desc"          ] = "乗り物が走る線路を組み立てる"
  tSet["tool."..sTool..".name"          ] = "線路の組み立て"
  tSet["tool."..sTool..".phytype"       ] = "一覧済みしたものの物性タイプを選択して"
  tSet["tool."..sTool..".phytype_def"   ] = "<表面物質タイプを選択して>"
  tSet["tool."..sTool..".phyname"       ] = "線路を作る時物性ネームを選択すると表面フリクションに効果が出る"
  tSet["tool."..sTool..".phyname_con"   ] = "表面材料名:"
  tSet["tool."..sTool..".phyname_def"   ] = "<表面物質ネームを選択して>"
  tSet["tool."..sTool..".bgskids"       ] = "コンマ区切りボディーグループ/スキンIDのセレクションコード。"
  tSet["tool."..sTool..".bgskids_con"   ] = "ボディーグループ/スキン:"
  tSet["tool."..sTool..".bgskids_def"   ] = "ここにセレクションコードを登録して。模範1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"          ] = "スポーンする部分の重さ"
  tSet["tool."..sTool..".mass_con"      ] = "部分の質量:"
  tSet["tool."..sTool..".model"         ] = "タイプを拡張してとノードをクリックしてで線路を始まる／続けるために部分を選んで"
  tSet["tool."..sTool..".model_con"     ] = "部分のモデル:"
  tSet["tool."..sTool..".activrad"      ] = "アクティブポイントを選ぶの最小限距離"
  tSet["tool."..sTool..".activrad_con"  ] = "アクティブ半径:"
  tSet["tool."..sTool..".stackcnt"      ] = "スタックする場合線路部分の最大量"
  tSet["tool."..sTool..".stackcnt_con"  ] = "部分の数:"
  tSet["tool."..sTool..".angsnap"       ] = "この程度で最初の部分をスナップして"
  tSet["tool."..sTool..".angsnap_con"   ] = "鋭角的な路線:"
  tSet["tool."..sTool..".resetvars"     ] = "追加的な数値をリセットためにクリックして"
  tSet["tool."..sTool..".resetvars_con" ] = "V 変数リセット V"
  tSet["tool."..sTool..".nextpic"       ] = "追加的原点鋭角的なピッチオフセット"
  tSet["tool."..sTool..".nextpic_con"   ] = "原点ピッチ:"
  tSet["tool."..sTool..".nextyaw"       ] = "追加的原点鋭角的なヨーオフセット"
  tSet["tool."..sTool..".nextyaw_con"   ] = "原点ヨー:"
  tSet["tool."..sTool..".nextrol"       ] = "追加的原点鋭角的なロールオフセット"
  tSet["tool."..sTool..".nextrol_con"   ] = "原点ロール:"
  tSet["tool."..sTool..".nextx"         ] = "追加的原点直線的なXオフセット"
  tSet["tool."..sTool..".nextx_con"     ] = "Xオフセット:"
  tSet["tool."..sTool..".nexty"         ] = "追加的原点直線的なYオフセット"
  tSet["tool."..sTool..".nexty_con"     ] = "Yオフセット:"
  tSet["tool."..sTool..".nextz"         ] = "追加的原点直線的なZオフセット"
  tSet["tool."..sTool..".nextz_con"     ] = "Zオフセット:"
  tSet["tool."..sTool..".gravity"       ] = "スポーンした部分の重力を管理する"
  tSet["tool."..sTool..".gravity_con"   ] = "部分重力を付ける"
  tSet["tool."..sTool..".weld"          ] = "二つの部分と部分とアンカーの間に溶接打点を作る"
  tSet["tool."..sTool..".weld_con"      ] = "溶接"
  tSet["tool."..sTool..".forcelim"      ] = "溶接打点を壊す必要な力を管理する"
  tSet["tool."..sTool..".forcelim_con"  ] = "力の限定:"
  tSet["tool."..sTool..".ignphysgn"     ] = "スポーンした／スナップした／スタックした部分の物理銃掴むを無視する"
  tSet["tool."..sTool..".ignphysgn_con" ] = "物理銃を無視する"
  tSet["tool."..sTool..".nocollide"     ] = "部分と部分とアンカーの間に「突き当たる禁止」を入れる"
  tSet["tool."..sTool..".nocollide_con" ] = "突き当たる禁止"
  tSet["tool."..sTool..".nocollidew"    ] = "部分と世界ーの間に「突き当たる禁止」を入れる"
  tSet["tool."..sTool..".nocollidew_con"] = "な衝突世界突き当たる禁止"
  tSet["tool."..sTool..".freeze"        ] = "動かぬ状態で部分をスポーンする"
  tSet["tool."..sTool..".freeze_con"    ] = "それは移動しません"
  tSet["tool."..sTool..".igntype"       ] = "ツールをスナップする／スタックする時部分の種類を無視させる"
  tSet["tool."..sTool..".igntype_con"   ] = "線路部分タイプを無視して"
  tSet["tool."..sTool..".spnflat"       ] = "次の部分が横にスポーン／スナップ／スタック"
  tSet["tool."..sTool..".spnflat_con"   ] = "横にスポーンして"
  tSet["tool."..sTool..".spawncn"       ] = "真ん中で部分をスポーンして、他のは選んだアクティブポイントに身寄でスポーンする"
  tSet["tool."..sTool..".spawncn_con"   ] = "真ん中から原点"
  tSet["tool."..sTool..".surfsnap"      ] = "プレイヤーに指した表面で部分をスナップして"
  tSet["tool."..sTool..".surfsnap_con"  ] = "トレース表面でスナップして"
  tSet["tool."..sTool..".appangfst"     ] = "最初部分のみに鋭角的なオフセットを付けて"
  tSet["tool."..sTool..".appangfst_con" ] = "最初のに鋭角的のを付けて"
  tSet["tool."..sTool..".applinfst"     ] = "最初部分のみに点直線的なオフセットを付けて"
  tSet["tool."..sTool..".applinfst_con" ] = "最初のに点直線のを付けて"
  tSet["tool."..sTool..".adviser"       ] = "ツールのレンダリング拠点／角度アドバイザーを管理する"
  tSet["tool."..sTool..".adviser_con"   ] = "ドローアドバイザー"
  tSet["tool."..sTool..".pntasist"      ] = "ツールのレンダリングスナップポイントアシスタントを管理する"
  tSet["tool."..sTool..".pntasist_con"  ] = "ドローアシスタント"
  tSet["tool."..sTool..".ghostcnt"      ] = "ツールのレンダリングゴーステッドホルダー部分数を管理する"
  tSet["tool."..sTool..".ghostcnt_con"  ] = "ドローホルダーゴースト"
  tSet["tool."..sTool..".engunsnap"     ] = "プレイヤー物理銃が落とした部分のスナップを管理する"
  tSet["tool."..sTool..".engunsnap_con" ] = "物理銃スナップを可能にする"
  tSet["tool."..sTool..".type"          ] = "フォルダを展開して、使用するトラックタイプを選択します"
  tSet["tool."..sTool..".type_con"      ] = "トラックタイプ:"
  tSet["tool."..sTool..".subfolder"     ] = "フォルダを展開して、使用するトラックカテゴリを選択します"
  tSet["tool."..sTool..".subfolder_con" ] = "トラックカテゴリ:"
  tSet["tool."..sTool..".workmode"      ] = "稼働モード変更の設定"
  tSet["tool."..sTool..".workmode_con"  ] = "稼働モ:"
  tSet["tool."..sTool..".pn_export"     ] = "クリックでクライアントデータベースをファイルにエクスポート"
  tSet["tool."..sTool..".pn_export_lb"  ] = "DB エクスポート"
  tSet["tool."..sTool..".pn_routine"    ] = "よく使った線路部分表"
  tSet["tool."..sTool..".pn_routine_hd" ] = "よく使った部分:"
  tSet["tool."..sTool..".pn_externdb"   ] = "使用可能外部データベース:"
  tSet["tool."..sTool..".pn_externdb_hd"] = "外部データベース:"
  tSet["tool."..sTool..".pn_externdb_lb"] = "右クリックでオプション:"
  tSet["tool."..sTool..".pn_externdb_1" ] = "特異プレフィックスをコピーして"
  tSet["tool."..sTool..".pn_externdb_2" ] = "DSVフォルダーをコピーして"
  tSet["tool."..sTool..".pn_externdb_3" ] = "テーブルニックネームをコピーして"
  tSet["tool."..sTool..".pn_externdb_4" ] = "テーブルパスをコピーして"
  tSet["tool."..sTool..".pn_externdb_5" ] = "テーブルタイムをコピーして"
  tSet["tool."..sTool..".pn_externdb_6" ] = "テーブルサイズをコピーして"
  tSet["tool."..sTool..".pn_externdb_7" ] = "アイテムを編集して(Luapad)"
  tSet["tool."..sTool..".pn_externdb_8" ] = "データベースエントリを消して"
  tSet["tool."..sTool..".pn_ext_dsv_lb" ] = "外部DSVリスト"
  tSet["tool."..sTool..".pn_ext_dsv_hd" ] = "外部DSVデータベースリストはここに見せる"
  tSet["tool."..sTool..".pn_ext_dsv_1"  ] = "データベース特異プレッフィクス"
  tSet["tool."..sTool..".pn_ext_dsv_2"  ] = "アクティブ"
  tSet["tool."..sTool..".pn_display"    ] = "プレーやの線路部分ここに映る"
  tSet["tool."..sTool..".pn_pattern"    ] = "ここにパターンを書くとサーチするためにENTERを押して"
  tSet["tool."..sTool..".pn_srchcol"    ] = "サーチするコラムを選択し"
  tSet["tool."..sTool..".pn_srchcol_lb" ] = "＜でサーチ＞"
  tSet["tool."..sTool..".pn_srchcol_lb1"] = "モデル"
  tSet["tool."..sTool..".pn_srchcol_lb2"] = "タイプ"
  tSet["tool."..sTool..".pn_srchcol_lb3"] = "ネーム"
  tSet["tool."..sTool..".pn_srchcol_lb4"] = "角"
  tSet["tool."..sTool..".pn_routine_lb" ] = "定番アイテム"
  tSet["tool."..sTool..".pn_routine_lb1"] = "期限"
  tSet["tool."..sTool..".pn_routine_lb2"] = "角"
  tSet["tool."..sTool..".pn_routine_lb3"] = "タイプ"
  tSet["tool."..sTool..".pn_routine_lb4"] = "ネーム"
  tSet["tool."..sTool..".pn_display_lb" ] = "部分を映る"
  tSet["tool."..sTool..".pn_pattern_lb" ] = "パターンを書く"
  tSet["Cleanup_"..sLimit               ] = "組み立てた線路部分"
  tSet["Cleaned_"..sLimit               ] = "線路部分全部綺麗にした"
  tSet["SBoxLimit_"..sLimit             ] = "スポーンした線路の限定"
return tSet end
