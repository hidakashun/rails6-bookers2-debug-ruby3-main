class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :message, presence: true, length: { maximum: 140 }
  #空でない＆最大１４０文字以下であるバリデーションも追加しておく！
end
