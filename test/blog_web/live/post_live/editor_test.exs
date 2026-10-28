defmodule BlogWeb.PostLive.EditorTest do
  use BlogWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Blog.Posts

  describe "new post" do
    test "renders the form with a slug preview", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      assert has_element?(view, "#post-form")
      assert has_element?(view, "#slug-preview")
      refute has_element?(view, "#view-post")
    end

    test "previews the slug generated from the title", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      view
      |> form("#post-form", post: %{title: "My First Post"})
      |> render_change()

      assert has_element?(view, "#slug-preview", "/posts/my-first-post")
    end

    test "shows a validation error for a blank title", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      view
      |> form("#post-form", post: %{title: ""})
      |> render_change()

      assert has_element?(view, "#post-form", "can't be blank")
    end

    test "creates the post and navigates to its edit page", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/posts/new")

      result =
        view
        |> form("#post-form", post: %{title: "My New Post", body: "Hello world!"})
        |> render_submit()

      {:ok, edit_view, _html} = follow_redirect(result, conn)

      assert has_element?(edit_view, "#post_title[value='My New Post']")
    end

    test "shows an error when the slug is already taken", %{conn: conn} do
      Posts.create_post(%{title: "Hello World!", body: "Hello!"})

      {:ok, view, _html} = live(conn, ~p"/posts/new")

      view
      |> form("#post-form", post: %{title: "Hello World!", body: "Hello again!"})
      |> render_submit()

      assert has_element?(view, "#slug-preview", "has already been taken")
    end
  end

  describe "edit post" do
    setup do
      {:ok, post} = Posts.create_post(%{"title" => "Original Title", "body" => "Body."})
      %{post: post}
    end

    test "loads the post into the form", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts/#{post.id}/edit")

      assert has_element?(view, "#post_title[value='Original Title']")
      assert has_element?(view, "#view-post[href='/posts/original-title']")
    end

    test "saves changes to the database", %{conn: conn, post: post} do
      {:ok, view, _html} = live(conn, ~p"/posts/#{post.id}/edit")

      view
      |> form("#post-form", post: %{title: "Updated Title"})
      |> render_submit()

      assert Posts.get_post!(post.id).title == "Updated Title"
    end

    test "raises for an unknown id", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/posts/999999/edit") end
    end
  end
end
