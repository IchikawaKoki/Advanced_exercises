class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def self.search_record(word, how_to)
    if how_to == 'match_all'
      Book.where(title: "#{word}")
    elsif how_to == 'match_forward'
      Book.where('title LIKE ?', "#{word}%")
    elsif how_to == 'match_backward'
      Book.where('title LIKE ?', "%#{word}")
    else
      Book.where('title LIKE ?', "%#{word}%")
    end
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
