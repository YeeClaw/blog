defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :body, :text, null: false
      add :slug, :string, null: false
      add :published_at, :utc_datetime

      timestamps()
    end

    create unique_index(:posts, [:slug])
  end
end
