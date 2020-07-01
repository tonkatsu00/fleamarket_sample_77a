class ProductsController < ApplicationController
before_action :set_parents, only: [:index, :new, :create, :show]

  def index
    @products = Product.includes(:images).order('created_at DESC').all.page(params[:page]).per(4)
  end

  def new
    @product = Product.new
    @product.images.build
  end

  def show
    @product = Product.find(params[:id])
    @comment = Comment.new
    @commentALL = @product.comments
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def search
    respond_to do |format|
      format.html
      format.json do
        if params[:parent_id]
          #子カテゴリーを探して変数@childrenに代入
          @children = Category.find(params[:parent_id]).children
        elsif params[:children_id]
          @grandchildren = Category.find(params[:children_id]).children
        end
      end
    end

  end

  def set_parents
    @parents = Category.where(ancestry: nil)
  end

  private
  def product_params
    params.require(:product).permit(
      :size,
      :status,
      :name,
      :estimated_delivery,
      :shipping_fee_burden,
      :prefectures,
      :amount_of_money,
      :good_number,
      :product_details,
      :shipping_method,
      :category_id,
      images_attributes: [:image] 
    ).merge(exhibitor: current_user).merge(user_id: current_user.id)
  end

end
