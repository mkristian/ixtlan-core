class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% attributes.select {|attr| ![:has_one, :has_many].include?(attr.type) }.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% if options[:timestamps] %>
      t.timestamps
<% end -%>
<% if options[:modified_by] %>
      t.references :modified_by
<% end -%>
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
