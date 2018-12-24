defmodule CSysWeb.FileController do
  @moduledoc """
  Files
  """
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  swagger_path :upload do
    post "/admin/api/upload"
    description "File Uploader"
    parameters do
      file :body, :file, "file", required: true
    end
    response 201, "success"
  end

  @http_path "http://jwxt.sustc.seeuio.com/files"
  # @file_path "/Users/neo/Desktop/csys"
  # @file_path "/root/csys"
  @file_path "/seeu/csys_store/files"

  def upload(conn, params) do
    IO.inspect params
    if upload = params["file"] do
      # extension = Path.extname(upload.filename)
      
      # filename = "/media/#{DateTime.utc_now |> DateTime.to_unix}-profile#{extension}"
      filename = "/#{DateTime.utc_now |> DateTime.to_unix}-#{:rand.uniform(99999)}#{upload.filename |> fetch_suffix()}" # |> URI.encode
      File.cp(upload.path, "#{@file_path}#{filename}")
      conn
      |> put_status(:created)
      |> json(%{
        message: "success",
        filename: "#{@http_path}#{filename}"
      })
    else
      conn
      |> put_status(:bad_request)
      |> json(%{
        messgae: "upload fail"
      })
    end
  end

  defp fetch_suffix(""), do: ""
  defp fetch_suffix(str) do
    if String.contains?(str, ".") do
      result = str |> String.split(".") |> List.last
      ".#{result}"
    else
      str
    end
  end
end
