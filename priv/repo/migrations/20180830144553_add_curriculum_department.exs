defmodule CSys.Repo.Migrations.AddCurriculumDepartment do
  use Ecto.Migration

  def change do
    alter table(:curriculums) do
      add :department_id, references(:curriculum_departments, on_delete: :delete_all)
    end
  end
end
