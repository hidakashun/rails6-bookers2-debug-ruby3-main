class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  #グループ作成
  has_many :group_users, dependent: :destroy


  # ユーザーにたくさんのいいねを持つことができるようにする。いいねはユーザーに依存してるから、ユーザーが消えたらいいねも消えるようにする
  has_many :favorites, dependent: :destroy

  #複数のBookComentと関連付ける。userが消されたとき関連するBookComentも同時に消される
  has_many :book_comments, dependent: :destroy
  #DM関係
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  #閲覧数関係
  has_many :view_counts, dependent: :destroy

  # フォローをした、されたの関係
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使う
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower

  # フォローしたときの処理
  def follow(user_id)
    followers.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_users.include?(user)#20行目の定義した名前に合わせないといけない。
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }

  validates :introduction, length: { maximum: 50 }

  has_one_attached :profile_image
  def get_profile_image(width, height)
    unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
