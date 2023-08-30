class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy

  # ユーザーにたくさんのいいねを持つことができるようにする。いいねはユーザーに依存してるから、ユーザーが消えたらいいねも消えるようにする
  has_many :favorites, dependent: :destroy

  #複数のBookComentと関連付ける。userが消されたとき関連するBookComentも同時に消される
  has_many :book_comments, dependent: :destroy

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
    following_user.include?(user)
  end

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { in: 2..20 }

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
