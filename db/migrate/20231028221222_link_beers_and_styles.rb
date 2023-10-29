class LinkBeersAndStyles < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      UPDATE beers SET style_id = (SELECT id FROM styles WHERE styles.name = style_old);
    SQL
  end

  def down
    execute <<-SQL
      UPDATE beers SET style_id = NULL WHERE 1 = 1;
    SQL
  end
end
