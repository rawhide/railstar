class <%= controller_class_name %>Controller < ApplicationController
  
  def index
    @<%= table_name %> = <%= model_name %>.paginate(:per_page => 10, :page => params[:page],
      :order => "created_at DESC")

    respond_to do |format|
      format.html
      format.xml  { render :xml => @<%= table_name %> }
    end
  end

  def show
    @<%= file_name %> = <%= model_name %>.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  def new
    @<%= file_name %> = <%= model_name %>.new(params[:<%= file_name %>])
    return unless request.post?
    unless params[:back]
      render :action => "confirm" if @<%= file_name %>.valid?
    end
  end
  
  def create
    @<%= file_name %> = <%= model_name %>.new(params[:<%= file_name %>])

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= model_name %> was successfully created.'
        format.html { redirect_to :action => "show", :id => @<%= file_name %> }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { redirect_to :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @<%= file_name %> = <%= model_name %>.find(params[:id])
    @<%= file_name %>.attributes = params[:<%= file_name %>]
    return unless request.post?
    unless params[:back]
      render :action => "confirm" if @<%= file_name %>.valid?
    end
  end

  def update
    @<%= file_name %> = <%= model_name %>.find(params[:id])
    @<%= file_name %>.attributes = params[:<%= file_name %>]

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= model_name %> was successfully updated.'
        format.html { redirect_to :action => "show", :id => @<%= file_name %> }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @<%= file_name %> = <%= model_name %>.find(params[:id])
    return unless request.delete?
    @<%= file_name %>.destroy
    flash[:notice] = '<%= model_name %> was successfully destroyed.'

    respond_to do |format|
      format.html { redirect_to(:action => "index") }
      format.xml  { head :ok }
    end
  end
end
