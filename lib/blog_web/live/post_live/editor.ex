defmodule BlogWeb.PostLive.Editor do
  use BlogWeb, :live_view
  alias Blog.Posts
  alias Blog.Posts.Post

  def mount(%{"id" => id}, _session, socket) do
    post = Posts.get_post!(id)
    {:ok, assign(socket, post: post, form: to_form(Posts.change_post(post)))}
  end

  def mount(%{}, _session, socket) do
    post = %Post{}
    {:ok, assign(socket, post: post, form: to_form(Posts.change_post(post)))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <h1>{@live_action}</h1>
      <.form for={@form} id="post-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />

        <.input :if={@live_action == :edit} field={@form[:slug]} type="text" label="Slug" />

        <div :if={@live_action == :new} id="slug-preview" class="text-sm">
          <p>URL: /posts/{@form[:slug].value}</p>
          <p :for={error <- @form[:slug].errors} class="text-red-600">
            {translate_error(error)}
          </p>
        </div>

        <.input field={@form[:body]} type="textarea" label="Content" />

        <.button id="save-post" phx-disable-with="Saving...">Save</.button>
      </.form>
      <.link :if={@live_action == :edit} id="view-post" href={~p"/posts/#{@post.slug}"}>
        View post
      </.link>
    </Layouts.app>
    """
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Posts.change_post(socket.assigns.post, post_params)

    new_socket =
      socket
      |> assign(form: to_form(changeset, action: :validate))
      |> clear_flash()

    {:noreply, new_socket}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    updated_state = save_post(socket, socket.assigns.live_action, post_params)
    {:noreply, updated_state}
  end

  defp save_post(socket, :new, post_params) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        socket
        |> put_flash(:info, "Post created")
        |> push_navigate(to: ~p"/posts/#{post.id}/edit")

      {:error, changeset} ->
        socket
        |> put_flash(:error, "Unable to create post")
        |> assign(form: to_form(changeset))
    end
  end

  defp save_post(socket, :edit, post_params) do
    case Posts.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        socket
        |> put_flash(:info, "Successfully updated post")
        |> assign(post: post, form: to_form(Posts.change_post(post)))

      {:error, changeset} ->
        socket
        |> put_flash(:error, "Unable to update post")
        |> assign(form: to_form(changeset))
    end
  end
end
