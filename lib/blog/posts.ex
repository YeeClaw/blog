defmodule Blog.Posts do
  import Ecto.Query
  alias Blog.Repo
  alias Blog.Posts.Post

  def get_post!(id) do
    Repo.get!(Post, id)
  end

  def list_posts() do
    Repo.all(Post)
  end

  def search_posts(term) do
    query =
      from p in Post,
        where: like(p.title, ^"%#{term}%"),
        order_by: [desc: p.inserted_at]

    Repo.all(query)
  end

  def get_post_by_slug!(slug) do
    Repo.get_by!(Post, slug: slug)
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
