defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @type t :: %__MODULE__{
          id: integer() | nil,
          title: String.t() | nil,
          body: String.t() | nil,
          slug: String.t() | nil,
          published_at: DateTime.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :published_at, :utc_datetime

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body, :slug, :published_at])
    |> put_slug()
    |> validate_required([:title, :body, :slug])
    |> unique_constraint(:slug)
  end

  @spec slugify(String.t()) :: String.t()
  defp slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end

  @spec put_slug(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_slug(changeset) do
    case {get_field(changeset, :title), get_field(changeset, :slug)} do
      {nil, _slug} -> changeset
      {title, nil} -> put_change(changeset, :slug, slugify(title))
      {_title, _slug} -> changeset
    end
  end
end
