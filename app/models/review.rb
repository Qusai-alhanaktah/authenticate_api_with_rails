class Review < ApplicationRecord
  before_save :calc_average_rating
  belongs_to :user
  belongs_to :book

  def calc_average_rating
    self.average_rating = ((self.recommend_rating + self.current_rating)/2).round(1)
  end
  
end
