class GeneralShoppingListController < ApplicationController
  def index
    @missing_foods = current_user.foods.where.not(id: RecipeFood.includes(:recipe)
                             .where(recipes: { user_id: current_user.id }).pluck(:food_id))
    @shopping_list_items = {}
    @total_items = 0
    @total_price = 0.0

    @missing_foods.each do |food|
      quantity = food.quantity
      price = food.price * quantity
      if @shopping_list_items[food.id].present?
        @shopping_list_items[food.id][:quantity] += quantity
        @shopping_list_items[food.id][:price] += price
      else
        @shopping_list_items[food.id] = { food:, quantity:, price: }
      end
      @total_price += price
    end
    @total_items += @missing_foods.select(:id).distinct.count
    @shopping_list_items = @shopping_list_items.values.sort_by { |item| item[:food].name }
  end
end
