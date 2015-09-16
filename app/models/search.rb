class Search
  def self.search(required, where = 'All')
    escaped = Riddle::Query.escape(required)
    return ThinkingSphinx.search(escaped) if where == 'All'
    ThinkingSphinx.search(escaped, classes: [where.constantize])
  end
end