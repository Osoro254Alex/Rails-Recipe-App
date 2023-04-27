class RecipesController < ApplicationController
  def index
    @recipe = current_user.recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.recipe_foods.where(recipe: @recipe)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    puts params.inspect
    if @recipe.save
      flash[:success] = 'Recipe successfully created'
      redirect_to recipes_path
    else
      flash[:danger] = "Couldn't create recipe"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:success] = 'Recipe deleted!'
    redirect_to recipes_path
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.public = !@recipe.public
    @recipe.save
    redirect_to recipe_path(@recipe), notice: 'Recipe status updated.'
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
