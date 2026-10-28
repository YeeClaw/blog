defmodule BlogWeb.PostLive.IndexTest do
  use BlogWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Blog.Posts

  setup do
    {:ok, post} = Posts.create_post(%{"title" => "Hello World", "body" => "First post."})
    %{post: post}
  end

  test "new post link navigates to the editor", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/posts")

    view |> element("#new-post") |> render_click()

    assert_redirect(view, ~p"/posts/new")
  end

  test "edit link navigates to the post's editor", %{conn: conn, post: post} do
    {:ok, view, _html} = live(conn, ~p"/posts")

    view |> element("#edit-post-#{post.id}") |> render_click()

    assert_redirect(view, ~p"/posts/#{post.id}/edit")
  end
end
