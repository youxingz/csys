defmodule CSysWeb.AdminTrainingMajorController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Training
  alias CSys.Training.TrainingMajor
  alias CSysWeb.TrainingMajorView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/training/majors"
    description "获取全部专业"
    response 200, "success"
  end

  swagger_path :show do
    get "/admin/api/training/majors/{major_id}"
    description "获取某一专业"
    parameters do
      id :path, :integer, "major_id", required: true
    end
    response 200, "success"
  end

  swagger_path :create do
    post "/admin/api/training/majors"
    parameters do
      name :query, :string, "计算机科学与技术", required: true
    end
    response 201, "success"
  end

  swagger_path :update do
    put "/admin/api/training/majors/{major_id}"
    parameters do
      id :path, :integer, "major_id", required: true
      name :query, :string, "计算机科学与技术", required: true
    end
    response 201, "success"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/training/majors/{major_id}"
    description "删除专业"
    parameters do
      id :path, :integer, "major_id", required: true
    end
    response 204, "success"
  end

  def index(conn, _params) do
    training_majors = Training.list_training_majors()
    render(conn, TrainingMajorView, "index.json", training_majors: training_majors)
  end

  def create(conn, %{"name" => name} = params) do
    if major = Training.find_training_major_by_name(name) do
      conn |> put_status(400) |> json(%{error: "已经存在专业：#{major.name}"})
    else
      with {:ok, %TrainingMajor{} = training_major} <- Training.create_training_major(params) do
        conn
        |> put_status(:created)
        |> render(TrainingMajorView, "show.json", training_major: training_major)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    training_major = Training.get_training_major!(id)
    render(conn, TrainingMajorView, "show.json", training_major: training_major)
  end

  def update(conn, %{"id" => id} = params) do
    training_major = Training.get_training_major!(id)

    with {:ok, %TrainingMajor{} = training_major} <- Training.update_training_major(training_major, params) do
      render(conn, TrainingMajorView, "show.json", training_major: training_major)
    end
  end

  def delete(conn, %{"id" => id}) do
    training_major = Training.get_training_major!(id)
    case Training.delete_training_major(training_major) do
      {:ok, _} -> send_resp(conn, :no_content, "")
      _ -> json(conn, %{message: "Please remove all course under this major before."})
    end
    # with {:ok, %TrainingMajor{}} <-  do
    #   send_resp(conn, :no_content, "")
    # end
  end
end
