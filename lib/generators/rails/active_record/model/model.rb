class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% attributes.select {|attr| [:has_one, :has_many].include?(attr.type) }.each do |attribute| -%>
  <%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% if options[:modified_by] -%>
  belongs_to :modified_by, :class_name => "<%= options[:user_model] %>"
<% end -%>
<% if options[:singleton] -%>
  def self.instance
    self.first || self.new
  end
<% end -%>
end
