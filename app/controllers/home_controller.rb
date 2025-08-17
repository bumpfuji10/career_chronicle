class HomeController < ApplicationController
  def index
    @user = current_guest || current_member
    @home_features = [
      { icon_id: "ClockIcon", title: "5分で完成", description: "ガイドに従うだけで短時間で作成" },
      { icon_id: "FileIcon", title: "プロ品質", description: "採用担当者に響く文章の作成をサポート" },
      { icon_id: "UserGroupIcon", title: "複数職歴対応", description: "複数の職歴を統合して管理" }
    ]

    @home_step_items = [
      { icon_id: "CompanyIcon", title: "会社名・職歴", description: "どこで、どんな役割で働いていたかを入力します" },
      { icon_id: "BriefcaseIcon", title: "やったこと", description: "具体的な業務内容や担当したプロジェクトを入力します" },
      { icon_id: "LightbulbIcon", title: "工夫したこと", description: "業務における創意工夫や独自のアプローチを入力します" },
      { icon_id: "ChartLineIcon", title: "成果・実績", description: "具体的な成果や数字で示せる実績を入力します" },
      { icon_id: "FileLinesIcon", title: "文章整形", description: "入力した内容を自然な文章に整形して完成です" }
    ]
  end
end
