module TopMethod
  def top(how_many = 3)
    sorted_by_rating_in_desc_order = self.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0, how_many]
  end
end
