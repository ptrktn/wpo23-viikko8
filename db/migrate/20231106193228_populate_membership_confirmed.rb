class PopulateMembershipConfirmed < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      UPDATE memberships SET confirmed = TRUE WHERE 1 = 1;
    SQL
  end

  def down
    execute <<-SQL
      UPDATE memberships SET confirmed = NULL WHERE 1 = 1;
    SQL
  end
end
