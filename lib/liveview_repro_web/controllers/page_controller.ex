defmodule LiveviewReproWeb.PageController do
  use LiveviewReproWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
