defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Posts

  def show(conn, %{"slug" => slug}) do
    post = Posts.get_post_by_slug!(slug)
    render(conn, :show, post: post, page_title: post.title)
  end
end
