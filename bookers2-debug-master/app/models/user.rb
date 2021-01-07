class User < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def following?(user)
    followings.include?(user)
  end

  def follow(user)
    active_relationships.create(followed_id: user)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user).destroy
  end

  def self.search_record(word, how_to)
    if how_to == 'match_all'
      User.where(name: word)
    elsif how_to == 'match_forward'
      User.where('name LIKE ?', "#{word}%")
    elsif how_to == 'match_backward'
      User.where('name LIKE ?', "%#{word}")
    else
      User.where('name LIKE ?', "%#{word}%")
    end
  end
  
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
end

end
