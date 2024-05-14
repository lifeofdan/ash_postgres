defmodule AshPostgres.Test.HashtagAssignment do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    polymorphic?(true)
    repo(AshPostgres.TestRepo)
  end

  relationships do
    belongs_to(:hashtag, AshPostgres.Test.Hashtag)
  end

  actions do
    default_accept([:resource_id])

    defaults([:create])
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:resource_id, :uuid, public?: true)
  end
end
