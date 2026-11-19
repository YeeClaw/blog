defmodule BlogWeb.PostController do
  use BlogWeb, :controller
  
  import Blog.Markdown

  alias Blog.Posts

  def show(conn, %{"slug" => slug}) do
    post = Posts.get_post_by_slug!(slug)
    render(conn, :show, post: post, body_html: to_html(post.body), page_title: post.title)
  end
end
