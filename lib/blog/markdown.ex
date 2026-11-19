defmodule Blog.Markdown do
  @moduledoc """
  Turns post bodies from Markdown to HTML
  """

  require Logger

  @options [
    extension: [
      table: true,
      strikethrough: true,
      autolink: true,
      tasklist: true,
      footnotes: true
    ]
  ]

  @doc """
  Converts raw markdown strings into digestible HTML for the page.
  Failures return escaped HTML instead of anything else.
  """
  @spec to_html(String.t()) :: String.t()
  def to_html(markdown) do
    case MDEx.to_html(markdown, @options) do
      {:ok, html} ->
        html

      {:error, reason} ->
        Logger.warning("Markdown rendering failed: #{inspect(reason)}")
        escaped_fallback(markdown)
    end
  end

  @spec escaped_fallback(String.t()) :: String.t()
  defp escaped_fallback(markdown) do
    escaped =
      markdown
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()

    "<pre>#{escaped}</pre>"
  end
end
