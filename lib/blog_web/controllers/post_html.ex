defmodule BlogWeb.PostHTML do
  @moduledoc """
  Templates rendered by `BlogWeb.PostController`.
  """
  use BlogWeb, :html

  embed_templates "post_html/*"
end
