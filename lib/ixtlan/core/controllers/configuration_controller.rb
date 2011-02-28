module Ixtlan
  module Core
    module Controllers
      module ConfigurationController
        
        # GET /configuration
        # GET /configuration.xml
        # GET /configuration.json
        def show
          @config = Rails.application.config.configuration_model.instance
          
          respond_to do |format|
            format.html # index.html.erb 
            format.xml  { render :xml => @config }
            format.json  { render :json => @config }
          end
        end

        # GET configuration/edit
        def edit
          @config = Rails.application.config.configuration_model.instance
        end
        
        # PUT configuration
        # PUT configuration.xml
        def update
          @config = Rails.application.config.configuration_model.instance
          
          if @config.respond_to? :current_user && respond_to? :current_user
            @config.current_user = current_user
          end

          respond_to do |format|
            if @config.update_attributes
              format.html { redirect_to(@config, :notice => 'configuration was successfully updated.') }
              format.xml  { render :xml => @config }
              format.json  { render :json => @config }
            else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @config.errors, :status => :unprocessable_entity }
              format.json  { render :json => @config.errors, :status => :unprocessable_entity }
            end
          end
        end
      end
    end
  end
end
