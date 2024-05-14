defmodule AshPostgres.Test.Hashtag do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("hashtags")
    repo(AshPostgres.TestRepo)
  end

  actions do
    default_accept([:label])
    defaults([:create, :read])
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:label, :string, allow_nil?: false)
  end
end
