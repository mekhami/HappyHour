defmodule HappyHourWeb.PageController do
  use HappyHourWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
