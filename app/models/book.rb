class Book < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :body, length: { maximum: 200 }

  has_many :book_comments, dependent: :destroy
  #閲覧数関係
  has_many :view_counts, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user#いいね機能のソート用の記述
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  #ソート機能
  scope :latest, -> {order(created_at: :desc)}#最新のものから順に並べる
  scope :old, -> {order(created_at: :asc)}#古いものから順に並べる
  scope :star_count, -> {order(star: :desc)}#星の数が多い順に並べる

  scope :most_favorited, -> { includes(:favorited_users)
  .sort_by { |x| x.favorited_users.includes(:favorites).size }.reverse }

  #order = データの取り出し,created_at = 投稿日のカラム,desc = 昇順,asc = 降順

  #カテゴリタグを追加し検索
  validates :category, presence: true

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
