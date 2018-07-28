defmodule CSysWeb.Router do
  use CSysWeb, :router
  # alias UserController

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  # 直接放行的 API
  scope "/api", CSysWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
  end

  # 需要权限验证的 API
  scope "/api", CSysWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController, except: [:new, :edit]
  end

  # 权限验证，验证失败就 401
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(MyAppWeb.ErrorView, "401.json", message: "Unauthenticated user")
      |> halt()
    end
  end
end