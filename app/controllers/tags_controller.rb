class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: %i[edit update destroy]

  def index
    # 只顯示當前使用者的標籤
    @tags = current_user.tags.order(created_at: :desc)
  end

  def new
    @tag = current_user.tags.new
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      flash.now[:notice] = t(".success")
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: t(".success")
  end

  private

  def set_tag
    @tag = current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
