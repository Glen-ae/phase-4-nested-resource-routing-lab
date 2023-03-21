class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  def index
    return render json: User.find_by!(id:params[:user_id]).items if params[:user_id]
    render json: Item.all, include: :user
  end
  
  def show
    return render json: User.find_by!(id:params[:user_id]).items.find_by!(id: params[:id]) if params[:user_id]
    render json: Item.find_by!(id: params[:id])
  end

  def create
    item= Item.create(item_params)
    User.find_by!(id:params[:user_id]).items << item 
    render json: item, status: :created
  end
  
  private 
  def not_found_response
    render json: {error: "No item with id: #{params[:id]} found"},status: :not_found
  end

  def item_params
    params.permit :name, :description, :price
  end

end