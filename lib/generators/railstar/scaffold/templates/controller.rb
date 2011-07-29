# -*- coding: utf-8 -*-
# destroyメソッドに注意。モバイル対応＆テキストリンク利用のためイレギュラーなことをしている
# restに対応した形を徹底したい場合は、削除確認ページへのリンクを以下の様に、formにする
# <%%= form_tag(<%= singular_controller_name %>_path(<%= singular_name %>, :mode => "draft"), :method=>:delete) do %><%%= submit_tag "delete", :name => "delete" %><%% end %>

class <%= controller_class_name %>Controller < ApplicationController
  def index
    @<%= plural_name %> = <%= model_name %>.paginate(:per_page => 5, :page => params[:page], :order => "created_at desc")
  end

  def show
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
    render "destroy" if params[:mode] == "draft"
  end

  def new
    @<%= singular_name %> = <%= model_name %>.new(params[:<%= singular_name %>])
  end

  def edit
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
  end

  def create
    @<%= singular_name %> = <%= model_name %>.new(params[:<%= singular_name %>])
    save
  end

  def update
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
    @<%= singular_name %>.attributes = params[:<%= singular_name %>]
    save
  end

  def destroy
    @<%= singular_name %> = <%= model_name %>.find(params[:id])
    if params.key?("back")
      redirect_to(<%= plural_controller_path %>_url)
    elsif params[:mode] != "draft"
      @<%= singular_name %>.destroy
      redirect_to(<%= plural_controller_path %>_url)
    end
  end

  
  private
  def save
    if !params.key?("back") && @<%= singular_name %>.valid?
      if params[:mode] == "draft"
        render :action => 'confirm'
      else
        @<%= singular_name %>.save!
        redirect_to <%= singular_controller_path %>_path(@<%= singular_name %>)
      end
    else
      render (@<%= singular_name %>.new_record? ? :new : :edit)
    end
  end
end
