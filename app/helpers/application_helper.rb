module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titlesize
    direction = (column == sort_column) && sort_direction == "asc" ? "desc" : "asc"
    css_class = "hilite"
    link_to title, {:sort_column => column, :sort_direction => direction}, {:class => css_class}
  end
  
  def was_highlighted?(column)
    (sort_column() == column) ? 'hilite' : ''
  end
end
