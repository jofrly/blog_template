class PostsController < ApplicationController
  before_action :require_authentication, except: [:index, :show]

  def index
    @posts = Post.recent_first.including_content
  end

  def show
    @post = Post.find_by(slug: params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find_by(slug: params[:id])
  end

  def create
    result = PostInteractor::Create.call(
      user: Current.user,
      post_params: post_params
    )
    @post = result.post

    if result.success?
      redirect_to blog_post_path(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find_by(slug: params[:id])

    if @post.update(post_params)
      redirect_to blog_post_path(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find_by(slug: params[:id])

    @post&.destroy

    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :slug)
  end
end
