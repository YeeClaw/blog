# Blog

A technical blog built with [Phoenix](https://www.phoenixframework.org/) 1.8 and [LiveView](https://hexdocs.pm/phoenix_live_view) 1.1, backed by SQLite and styled with Tailwind CSS v4.

This is a learning project -- each feature is built incrementally to explore Phoenix and Elixir patterns from the ground up.

## Stack

- **Elixir** + **Phoenix 1.8**
- **Phoenix LiveView 1.1** for real-time, server-rendered UI
- **SQLite** via Ecto for persistence
- **Tailwind CSS v4** for styling

## Getting Started

```sh
mix setup        # install deps, create db, run migrations
mix phx.server   # start the dev server at localhost:4000
```

Or run inside IEx for interactive debugging:

```sh
iex -S mix phx.server
```

## Project Structure

```
lib/
  blog/            # Business logic (contexts, schemas)
    posts/         # Post schema and changesets
    posts.ex       # Posts context (CRUD operations)
  blog_web/        # Web layer
    components/    # UI components and layouts
    controllers/   # Traditional controller-based pages
    router.ex      # Route definitions
```

## Repository

Hosted on Forgejo at [forge.coltco.net/austin/blog](https://forge.coltco.net/austin/blog).
