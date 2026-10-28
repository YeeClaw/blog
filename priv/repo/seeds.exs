# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Safe to run more than once: posts whose title already exists are skipped.
#
# The sample posts are shaped to exercise upcoming features:
#
#   * Markdown bodies with headings, lists, and code blocks (#7, #25)
#   * published_at spread across years and months (#26)
#   * one draft with no published_at (#10, #12)

alias Blog.Repo
alias Blog.Posts
alias Blog.Posts.Post

posts = [
  %{
    title: "Hello, World",
    published_at: ~U[2025-11-03 09:00:00Z],
    body: """
    Welcome to the blog. This is where I write about the things I build.

    ## Why another blog

    Mostly to learn Elixir and Phoenix by building something real.
    """
  },
  %{
    title: "Pattern Matching Is Not Assignment",
    published_at: ~U[2025-12-14 18:30:00Z],
    body: """
    In Elixir, `=` is the *match operator*, not assignment.

    ## Binding on the left

    ```elixir
    {:ok, post} = Blog.Posts.create_post(attrs)
    ```

    If the right side is `{:error, changeset}`, the match fails and raises.

    ## Matching in function heads

    Multiple clauses of the same function are tried top to bottom:

    ```elixir
    def mount(%{"id" => id}, _session, socket), do: ...
    def mount(_params, _session, socket), do: ...
    ```

    - The specific clause goes first.
    - The catch-all goes last.
    """
  },
  %{
    title: "Static Pages and the 14kb Rule",
    published_at: ~U[2026-02-08 12:00:00Z],
    body: """
    The first TCP round trip carries roughly 14kb. A page that fits in that
    budget renders without waiting on a second round trip.

    ## What this blog does about it

    1. Reader pages are dead views with no JavaScript.
    2. Everything interactive lives in its own LiveView.
    3. A test enforces the budget in CI.

    ## Where it gets hard

    ### Syntax highlighting

    Highlighted code adds a lot of markup.

    ### Tables of contents

    A long post's table of contents grows with the number of headings.
    """
  },
  %{
    title: "Processes All the Way Down",
    published_at: ~U[2026-02-21 20:15:00Z],
    body: """
    Every LiveView is a BEAM process with its own mailbox and state.

    ## Crashing is fine

    When a LiveView process crashes, the client reconnects and the process
    mounts again from scratch.

    ```elixir
    def handle_info({:new_comment, comment}, socket) do
      {:noreply, stream_insert(socket, :comments, comment)}
    end
    ```
    """
  },
  %{
    title: "Draft: Notes on Ecto Changesets",
    published_at: nil,
    body: """
    Unfinished. This post has no `published_at`, so it is a draft.

    ## Validations vs constraints

    - Validations run in memory.
    - Constraints run in the database.
    """
  }
]

for attrs <- posts do
  case Repo.get_by(Post, title: attrs.title) do
    nil -> {:ok, _post} = Posts.create_post(attrs)
    _existing -> :skip
  end
end
