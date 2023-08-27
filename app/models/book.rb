class Book < ApplicationRecord
  belongs_to :user#userに属する1:N の関係性
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
end
