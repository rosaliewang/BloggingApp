class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :trash, :destroy]
  before_action :correct_user,   only: [:edit, :update, :trash, :destroy]

  def index
    @articles = user.articles
  end

  def show
    @article = Article.friendly.find(params[:id])
    @user = @article.user
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if publishing?
      @article.published_at = Time.zone.now
      @article.published = true
    end
    if unpublishing?
      @article.published = false
    end

    if @article.save
      if publishing?
        flash[:success] = "Blog was successfully created."
      end
      if unpublishing?
        flash[:success] = "Blog was successfully saved to draft."
      end
      redirect_to @article
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if publishing?
      @article.published_at = Time.zone.now
      @article.published = true
      @article.deleted = false
    elsif unpublishing?
      @article.published_at = nil
      @article.published = false
      @article.deleted = false
    elsif move_to_trash?
      @article.deleted = true
      @article.published_at = nil
      @article.published = false
    end

    if @article.update_attributes(article_params)
      # Handle a successful update.
      if publishing?
        flash[:success] = "Blog was successfully updated."
        redirect_to @article
      elsif unpublishing?
        flash[:success] = "Blog was successfully saved to draft."
        redirect_to current_user
      elsif move_to_trash?
        flash[:success] = "Blog was successfully moved to trash."
        redirect_to current_user
      end
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:success] = "Blog was permentantly deleted."
    redirect_to current_user
  end

  def update_multiple
    @articles_to_update = Article.friendly.find(params[:article_ids])
    if publishing?
      @articles_to_update.each do |article|
        article.update_attributes(:published_at => Time.zone.now,
                                :published => true, :deleted => false)
      end
      flash[:success] = "Blogs was successfully published."
    elsif unpublishing?
      @articles_to_update.each do |article|
        article.update_attributes(:published_at => nil, :published => false, :deleted => false)
      end
      flash[:success] = "Blogs was successfully saved to draft."
    elsif move_to_trash?
      @articles_to_update.each do |article|
        article.update_attributes(:deleted => true, :published_at => nil, :published => false)
      end
      flash[:success] = "Blogs were successfully moved to Trash."
    elsif destroy?
      @articles_to_update.each do |article|
        article.destroy
      end
      flash[:success] = "Blogs were permentantly deleted."
    end
    redirect_to root_url
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :publish)
    end

    def correct_user
      @article = current_user.articles.friendly.find(params[:id])
      redirect_to root_url if @article.nil?
    end

    def publishing?
      params[:commit] == "Publish"
    end

    def unpublishing?
      params[:commit] == "Save as Draft" ||
        params[:commit] == "Revert to Draft"
    end

    def move_to_trash?
      params[:commit] == "Move to Trash"
    end

    def destroy?
      params[:commit] == "Delete"
    end
end
