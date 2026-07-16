# レビュー履歴

章ごとのレビュー、統合結果、修正記録、再レビューを保存します。運用ルールは `docs/WRITING_AND_REVIEW_WORKFLOW.md` を参照してください。

## ディレクトリ構成

```text
reviews/
  templates/
    reviewer.md
    review-summary.md
    changes.md
    second-review.md
  chapter-01/
    01-fbc-mentor.md
    02-technical-editor.md
    03-ruby-sinatra.md
    04-frontend.md
    05-beginner.md
    06-fbc-graduate.md
    review-summary.md
    changes.md
    second-review.md
```

各レビュアーは、ほかの初回レビューを参照せずに担当ファイルを完成させます。6 件が揃った後でのみ `review-summary.md` を作成します。

レビューを複数回行う場合は、`second-review-01.md`、`second-review-02.md` のように番号を増やします。
