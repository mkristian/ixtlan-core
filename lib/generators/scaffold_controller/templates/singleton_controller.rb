class <%= controller_class_name %>Controller < ApplicationController
 
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  # GET <%= route_url %>.json
  def show
    @<%= singular_table_name %> = <%= class_name %>.instance

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= singular_table_name %> }
      format.json  { render :json => @<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/edit
  def edit
    @<%= singular_table_name %> = <%= class_name %>.instance
  end

  # PUT <%= route_url %>
  # PUT <%= route_url %>.xml
  # PUT <%= route_url %>.json
  def update
    @<%= singular_table_name %> = <%= class_name %>.instance
<% orm_class.find(class_name)
   if options[:modified_by] -%>
    @<%= singular_table_name %>.current_user = current_user
<% end -%>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to(<%= singular_table_name %>_path, :notice => '<%= human_name %> was successfully updated.') }
        format.xml  { render :xml => @<%= singular_table_name %> }
        format.json  { render :json => @<%= singular_table_name %> }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
        format.json  { render :json => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end
end
