class Food < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :measurement_unit, presence: true
  validates :quantity, presence: true

  belongs_to :user
  has_many :recipe_foods, dependent:
   :destroy
end
