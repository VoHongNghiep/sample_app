class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  CREATEABLE_ATTR = %i(content image).freeze

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_leng}
  validates :image, content_type: {in: Settings.image_type,
                                   message: :valid_image},
                    size: {less_than: Settings.size_image.megabytes,
                           message: :size_image}

  delegate :name, to: :user, prefix: true
  scope :newest, ->{order(created_at: :desc)}

  def display_image
    image.variant resize_to_limit: Settings.resize_to_limit
  end
end
