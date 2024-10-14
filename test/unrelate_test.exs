defmodule AshPostgres.Test.UnrelateTest do
  use AshPostgres.RepoCase, async: false

  require Ash.Query

  @tag :focus
  test "can unrelate belongs_to" do
    author =
      AshPostgres.Test.Author
      |> Ash.Changeset.for_create(:create, %{first_name: "is", last_name: "match"})
      |> Ash.create!()

    post =
      AshPostgres.Test.Post
      |> Ash.Changeset.for_create(:create, %{title: "match"})
      |> Ash.Changeset.manage_relationship(:author, author, type: :append_and_remove)
      |> Ash.create!()

    assert is_nil(post.author) == false

    post =
      post
      |> Ash.Changeset.for_update(:update)
      |> Ash.Changeset.manage_relationship(:author, author, type: :remove)
      |> Ash.update!()

    assert is_nil(post.author)
  end
end
