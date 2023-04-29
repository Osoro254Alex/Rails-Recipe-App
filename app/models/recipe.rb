class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :cooking_time, presence: true
  validates :preparation_time, presence: true

  def all_food_items
    recipe_foods.select(:food_id).distinct.count
  end

  def total_price
    recipe_foods.includes(:food).sum { |recipe_food| recipe_food.food.price * recipe_food.quantity }
  end
end
