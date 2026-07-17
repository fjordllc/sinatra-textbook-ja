# レビュー担当

FBC ベテランメンター

# 対象

第7章「編集と削除で CRUD を完成させる」

# 総評

FBC の Sinatra 課題で重要になる PATCH、DELETE、method override、PRG への足場が自然に入っている。Network タブでは POST と `_method` を確認し、Sinatra ログで PATCH/DELETE を確認するという説明は、レビューで頻出する誤解を防げる。

# 良い点

- HTML フォームが直接送れるメソッドは GET と POST だけ、という前提が明確である。
- `enable :method_override` を明示しており、暗黙の設定に頼っていない。
- 編集画面表示の GET と更新処理の PATCH を分けて説明している。
- 更新時にもタイトル必須チェックを行い、入力値を保持している。
- 削除後は一覧へ戻す設計が自然である。

# 改善が必要な点

## must

なし。

## should

- 問題: `views/edit.erb` と `views/show.erb` の完成コードが章末にない。
- 理由: 第7章は CRUD 完成の節目であり、フォームと詳細画面の最終形を確認できないと初学者が差分を追いにくい。
- 修正案: 第7章で追加・変更した `views/edit.erb` と `views/show.erb`、CSS 追加分を章末に載せる。

## could

- 改善案: 削除確認を省略する理由は本文にあるので十分。

# 疑問点

なし。

# 判定

完成コードを補えば次へ進める。
