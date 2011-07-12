class <%= controller_class_name %>Controller < ApplicationController
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  # GET <%= route_url %>.json
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb 
      format.xml  { render :xml => @<%= plural_table_name %> }
      format.json  { render :json => @<%= plural_table_name %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  # GET <%= route_url %>/1.json
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= singular_table_name %> }
      format.json  { render :json => @<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  # POST <%= route_url %>.json
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>
<% if options[:modified_by] -%>
    @<%= singular_table_name %>.current_user = current_user
<% end -%>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to(@<%= singular_table_name %>, :notice => '<%= human_name %> was successfully created.') }
        format.xml  { render :xml => @<%= singular_table_name %>, :status => :created, :location => @<%= singular_table_name %> }
        format.json  { render :json => @<%= singular_table_name %>, :status => :created, :location => @<%= singular_table_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
        format.json  { render :json => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  # PUT <%= route_url %>/1.json
  def update
<% if options[:optimistic] && options[:timestamps] -%>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "(params[:#{singular_table_name}]||[]).delete(:updated_at), params[:id]").sub(/\.(get|find)/, '.optimistic_\1') %>

    if @<%= singular_table_name %>.nil?
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => nil, :status => :conflict }
        format.json  { render :json => nil, :status => :conflict }
      end
      return
    end
<% else -%>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% end -%>
<% if options[:modified_by] -%>
    @<%= singular_table_name %>.current_user = current_user
<% end -%>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to(@<%= singular_table_name %>, :notice => '<%= human_name %> was successfully updated.') }
        format.xml  { render :xml => @<%= singular_table_name %> }
        format.json  { render :json => @<%= singular_table_name %> }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
        format.json  { render :json => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.xml
  # DELETE <%= route_url %>/1.json
  def destroy
<% if options[:optimistic] && options[:timestamps] -%>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "(params[:#{singular_table_name}]||[]).delete(:updated_at), params[:id]").sub(/\.(get|find)/, '.optimistic_\1') %>

    if @<%= singular_table_name %>.nil?
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => nil, :status => :conflict }
        format.json  { render :json => nil, :status => :conflict }
      end
      return
    end
<% else -%>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% end -%>
<% if options[:modified_by] -%>
    @<%= singular_table_name %>.current_user = current_user
<% end -%>

    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= index_helper %>_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
