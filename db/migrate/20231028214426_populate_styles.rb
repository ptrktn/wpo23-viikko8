class PopulateStyles < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      INSERT INTO styles (name, created_at, updated_at)
      SELECT DISTINCT(style), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM beers;
    SQL
  end

  def down
    execute <<-SQL
      DELETE FROM styles WHERE 1 = 1;
    SQL
  end
end
