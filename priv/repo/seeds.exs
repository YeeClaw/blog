# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Safe to run more than once: posts whose title already exists are skipped.
#
# The sample posts are shaped to exercise upcoming features:
#
#   * Markdown bodies with headings, lists, and code blocks (BLOG-2, BLOG-15)
#   * every GFM extension Blog.Markdown enables: tables, strikethrough,
#     autolinks, task lists, footnotes (BLOG-2)
#   * raw HTML and special characters that must be stripped or escaped (BLOG-2)
#   * one long post with many headings and code blocks (BLOG-15, BLOG-18)
#   * published_at spread across years and months (BLOG-16)
#   * one draft with no published_at (BLOG-22)
#
# Bodies that contain `#{` or backslashes use ~S""" so Elixir doesn't
# interpolate or unescape them.

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
  },
  %{
    title: "A Field Guide to GitHub Flavored Markdown",
    published_at: ~U[2026-03-19 15:45:00Z],
    body: """
    Plain CommonMark has no tables or task lists. This blog turns on five GFM
    extensions, and this post uses every one of them.

    ## Tables

    | Extension       | Syntax            | Renders as        |
    |-----------------|-------------------|-------------------|
    | `table`         | pipes and dashes  | `<table>`         |
    | `strikethrough` | `~~text~~`        | `<del>`           |
    | `autolink`      | a bare URL        | `<a href>`        |
    | `tasklist`      | `- [x] item`      | a disabled box    |
    | `footnotes`     | `[^1]`            | `<sup>` + section |

    Columns can be aligned:

    | Left | Center | Right |
    |:-----|:------:|------:|
    | a    |   b    |     1 |
    | ccc  |  ddd   |   100 |

    ## Strikethrough

    The editor is ~~a LiveComponent~~ a full LiveView.

    ## Autolinks

    Phoenix lives at https://www.phoenixframework.org and MDEx at
    https://github.com/leandrocp/mdex. Neither URL is written as a link.

    ## Task lists

    - [x] Add `mdex` to the deps
    - [x] Write `Blog.Markdown`
    - [ ] Style the rendered HTML
    - [ ] Highlight code blocks

    ## Footnotes

    MDEx wraps a Rust parser[^comrak] and loads it as a NIF.[^nif]

    [^comrak]: The parser is comrak, which follows the CommonMark and GFM specs.
    [^nif]: A NIF is native code that the BEAM calls like an ordinary function.
    """
  },
  %{
    title: "What Happens to Raw HTML in a Post",
    published_at: ~U[2026-06-02 11:20:00Z],
    body: ~S"""
    Markdown allows raw HTML. This blog strips it, so every tag in this post
    should be missing from the rendered page.

    ## Inline tags

    This sentence has <b>bold</b> and <span style="color:red">red</span> tags.
    The words stay; the tags go.

    ## Block tags

    <script>alert("this must never run")</script>

    <div class="callout">
    A div with a class.
    </div>

    <details><summary>A collapsible section</summary>Hidden text.</details>

    ## A link with a dangerous scheme

    [Click me](javascript:alert(1)) should not produce a working
    `javascript:` link.

    ## Special characters

    These must be escaped, not parsed: 1 < 2, 3 > 2, and AT&T.

    In code they stay literal: `<div>`, `&amp;`, and `"#{interpolation}"`.

    ```html
    <p class="example">HTML inside a code block is shown, not rendered.</p>
    ```

    A backslash escape: \*not italic\*.
    """
  },
  %{
    title: "Supervision Trees, From the Ground Up",
    published_at: ~U[2026-09-27 08:05:00Z],
    body: ~S"""
    A long post with many sections and code blocks in several languages. It is
    the stress test for the table of contents and the 14kb budget.

    ## Processes

    Everything in Elixir runs inside a process. Processes are cheap: a fresh
    one costs a few kilobytes.

    ```elixir
    pid = spawn(fn -> IO.puts("hello from #{inspect(self())}") end)
    ```

    ### Mailboxes

    Each process has a mailbox. `send/2` puts a message in it, and `receive`
    takes one out.

    ```elixir
    send(pid, {:greet, "Ada"})

    receive do
      {:greet, name} -> IO.puts("Hi, #{name}")
    after
      1_000 -> IO.puts("nobody wrote")
    end
    ```

    ### Links and monitors

    A **link** ties two processes together: if one crashes, the other does too.
    A **monitor** only sends a `:DOWN` message.

    > Let it crash. A supervisor will restart it in a known good state.

    ## GenServers

    A GenServer wraps the receive loop for you.

    ```elixir
    defmodule Counter do
      use GenServer

      def start_link(start), do: GenServer.start_link(__MODULE__, start, name: __MODULE__)
      def increment, do: GenServer.call(__MODULE__, :increment)

      @impl true
      def init(start), do: {:ok, start}

      @impl true
      def handle_call(:increment, _from, n), do: {:reply, n + 1, n + 1}
    end
    ```

    ### Call vs cast

    1. `call` waits for a reply.
    2. `cast` returns immediately.
       - Use it when the caller doesn't need an answer.
       - Nothing tells you if the message was lost.
    3. `send` skips the GenServer API entirely.

    ## Supervisors

    A supervisor starts children and restarts them when they crash.

    ### Restart strategies

    | Strategy        | When one child crashes        |
    |-----------------|-------------------------------|
    | `:one_for_one`  | restart that child            |
    | `:one_for_all`  | restart every child           |
    | `:rest_for_one` | restart it and those after it |

    ### Child specs

    ```elixir
    children = [
      Blog.Repo,
      {Phoenix.PubSub, name: Blog.PubSub},
      BlogWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
    ```

    ## Watching it from the shell

    ```shell
    iex -S mix
    ```

    Then open the observer:

    ```shell
    :observer.start()
    ```

    ## The same idea in JavaScript

    JavaScript has no supervisors, so you write the restart loop by hand:

    ```javascript
    async function supervise(task) {
      for (;;) {
        try {
          await task();
        } catch (err) {
          console.error("restarting after", err);
        }
      }
    }
    ```

    ## Takeaways

    - Processes are cheap, so use many.
    - Crashes are local, so isolate risky work.
    - Supervisors turn crashes into restarts.
    """
  }
]

for attrs <- posts do
  case Repo.get_by(Post, title: attrs.title) do
    nil -> {:ok, _post} = Posts.create_post(attrs)
    _existing -> :skip
  end
end
