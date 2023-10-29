class RemoveStyleOldFromBeers < ActiveRecord::Migration[7.0]
  def up
    remove_column :beers, :style_old, :string
  end

  def down
    # TODO: this could be made reversible
    raise ActiveRecord::IrreversibleMigration
  end
end
