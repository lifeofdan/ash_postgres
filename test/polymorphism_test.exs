defmodule AshPostgres.PolymorphismTest do
  use AshPostgres.RepoCase, async: false
  alias AshPostgres.Test.{Post, Rating, Hashtag, HashtagAssignment}

  require Ash.Query

  test "you can create related data" do
    Post
    |> Ash.Changeset.for_create(:create, rating: %{score: 10})
    |> Ash.create!()

    assert [%{score: 10}] =
             Rating
             |> Ash.Query.set_context(%{data_layer: %{table: "post_ratings"}})
             |> Ash.read!()
  end

  test "you can read related data" do
    Post
    |> Ash.Changeset.for_create(:create, rating: %{score: 10})
    |> Ash.create!()

    assert [%{score: 10}] =
             Post
             |> Ash.Query.load(:ratings)
             |> Ash.read_one!()
             |> Map.get(:ratings)
  end

  @tag :focus
  test "you can create relationship on polymorphic resource" do
    hashtag =
      Hashtag
      |> Ash.Changeset.for_create(:create, %{label: "foobar"})
      |> Ash.create!()

    post = Post |> Ash.Changeset.for_create(:create) |> Ash.create!()

    HashtagAssignment
    |> Ash.Changeset.for_create(:create, %{resource_id: post.id})
    |> Ash.Changeset.manage_relationship(:hashtag, hashtag, type: :append_and_remove)
    |> Ash.create!()
  end
end
