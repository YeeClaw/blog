defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :published_at, :utc_datetime

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :slug, :published_at])
    |> validate_required([:title, :body, :slug])
    |> unique_constraint(:slug)
  end
end
