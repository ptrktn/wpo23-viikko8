class AddBeerStyleReference < ActiveRecord::Migration[7.0]
  def change
    change_table :beers do |t|
      t.rename :style, :style_old
    end
    add_reference :beers, :style
  end
end
