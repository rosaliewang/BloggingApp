class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @article = current_user.articles.build
      @feed_items = current_user.feed.where(:published => true).order(:published_at)
      @feed_items = @feed_items.paginate(:per_page => 20, page: params[:page])
      @draft_items = current_user.feed.where(:published => false, :deleted => false)
      @draft_items = @draft_items.paginate(:per_page => 20, page: params[:page])
      @trash_items = current_user.feed.where(:deleted => true)
      @trash_items = @trash_items.paginate(:per_page => 20, page: params[:page])
    end
  end

  def view
    if logged_in?
      @article = current_user.articles.build
      # @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.where(:published => true).order(:published_at)
      @recent_items = @feed_items.limit(5)
      @feed_items = @feed_items.paginate(page: params[:page], :per_page => 10)
    end
  end

  def comments

  end

  def help
  end

  def about
  end

  def contact
  end
end
