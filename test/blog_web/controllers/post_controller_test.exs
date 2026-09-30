defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Posts

  describe "GET /posts/:slug" do
    setup do
      {:ok, post} = Posts.create_post(%{"title" => "Hello World", "body" => "First post."})
      %{post: post}
    end

    test "renders the post", %{conn: conn, post: post} do
      doc = conn |> get(~p"/posts/#{post.slug}") |> html_response(200) |> LazyHTML.from_document()

      assert doc |> LazyHTML.query("#post-title") |> LazyHTML.text() == "Hello World"
      assert doc |> LazyHTML.query("#post-body") |> LazyHTML.text() == "First post."
    end

    test "links to the discussion page", %{conn: conn, post: post} do
      doc = conn |> get(~p"/posts/#{post.slug}") |> html_response(200) |> LazyHTML.from_document()

      assert doc |> LazyHTML.query("#discuss-link") |> LazyHTML.attribute("href") ==
               ["/posts/hello-world/discuss"]
    end

    test "returns 404 for an unknown slug", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/posts/missing") end
    end
  end
end
