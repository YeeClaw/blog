defmodule Blog.Posts.PostTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Posts.Post

  describe "changeset/2 slug generation" do
    test "derives the slug from the title when no slug is given" do
      changeset = Post.changeset(%Post{}, %{"title" => "My First Post", "body" => "Hi"})

      assert changeset.valid?
      assert get_field(changeset, :slug) == "my-first-post"
    end

    test "keeps an explicit slug" do
      changeset =
        Post.changeset(%Post{}, %{"title" => "My First Post", "body" => "Hi", "slug" => "intro"})

      assert changeset.valid?
      assert get_field(changeset, :slug) == "intro"
    end

    test "collapses punctuation and repeated spaces into single hyphens" do
      changeset = Post.changeset(%Post{}, %{"title" => "  Hello,   World!  ", "body" => "Hi"})

      assert get_field(changeset, :slug) == "hello-world"
    end

    test "requires a title and a slug when neither is given" do
      changeset = Post.changeset(%Post{}, %{"body" => "Hi"})

      refute changeset.valid?
      assert %{title: ["can't be blank"], slug: ["can't be blank"]} = errors_on(changeset)
    end

    test "rejects a title with no letters or digits" do
      changeset = Post.changeset(%Post{}, %{"title" => "!!!", "body" => "Hi"})

      refute changeset.valid?
      assert %{slug: ["can't be blank"]} = errors_on(changeset)
    end

    test "keeps the saved slug when the title of an existing post changes" do
      post = %Post{id: 1, title: "My First Post", body: "Hi", slug: "my-first-post"}

      changeset = Post.changeset(post, %{"title" => "A Better Title"})

      assert changeset.valid?
      assert get_field(changeset, :slug) == "my-first-post"
    end

    test "rebuilds the slug when an existing post's slug is cleared" do
      post = %Post{id: 1, title: "My First Post", body: "Hi", slug: "old-slug"}

      changeset = Post.changeset(post, %{"slug" => ""})

      assert get_field(changeset, :slug) == "my-first-post"
    end
  end

  describe "create_post/1" do
    test "rejects a second post whose title produces the same slug" do
      assert {:ok, _post} = Posts.create_post(%{"title" => "Same Title", "body" => "One"})

      assert {:error, changeset} = Posts.create_post(%{"title" => "Same Title", "body" => "Two"})
      assert %{slug: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
