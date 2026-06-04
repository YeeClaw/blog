defmodule BlogWeb.PostLive.Index do
  use BlogWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :posts, Blog.Posts.list_posts())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <form phx-change="search" phx-debounce="300">
        <input type="text" name="q" placeholder="Search posts..." />
      </form>

      <ul id="posts" phx-update="stream">
        <li :for={{id, post} <- @streams.posts} id={id}>
          <.link href={~p"/posts/#{post.slug}"}>{post.title}</.link>
        </li>
      </ul>
    </Layouts.app>
    """
  end

  def handle_event("search", %{"q" => term}, socket) do
    {:noreply, stream(socket, :posts, Blog.Posts.search_posts(term), reset: true)}
  end
end
