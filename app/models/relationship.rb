class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"



  #belongs_to :userとすると、どっちがどっちのuserかわからなくなるので、followerとfollowedで分けている。

  #class_nameがないと、followerテーブルとfollowedテーブルを探しに行ってしまうので、class_name: "User"でuserテーブルからデータをとってきてもらうようにしている。
  #class_nameとは
  #関連名と参照先のクラス名を異なるものに置き換えることができるオプション。モデル名を直接指定できる。関連付けの相手となるオブジェクト名を関連付け名から生成できない事情がある場合に役立つ！
end