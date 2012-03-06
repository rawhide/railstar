# -*- coding: utf-8 -*-
# destroyメソッドに注意。モバイル対応＆テキストリンク利用のためイレギュラーなことをしている
# restに対応した形を徹底したい場合は、削除確認ページへのリンクを以下の様に、formにする
# <%%= form_tag(<%= class_name %>_path(<%= file_name %>, :mode => "draft"), :method=>:delete) do %><%%= submit_tag "delete", :name => "delete" %><%% end %>

class <%= controller_class_name %>Controller < ApplicationController
  def index
    @<%= plural_name %> = <%= model_class_name %>.order("created_at desc").all
  end

  def show
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    render "destroy" if params[:mode] == "draft"
  end

  def new
    @<%= singular_name %> = <%= model_class_name %>.new(params[:<%= singular_name %>])
  end

  def edit
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
  end

  def create
    @<%= singular_name %> = <%= model_class_name %>.new(params[:<%= singular_name %>])
    save
  end

  def update
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    @<%= singular_name %>.attributes = params[:<%= singular_name %>]
    save
  end

  def destroy
    @<%= singular_name %> = <%= model_class_name %>.find(params[:id])
    if params.key?("back")
      redirect_to(<%= singular_name %>_url)
    elsif params[:mode] != "draft"
      @<%= singular_name %>.destroy
      redirect_to(<%= singular_name %>_url, :notice => "deleted success.")
    end
  end

  
  private
  def save
    if !params.key?("back") && @<%= file_name %>.valid?
      if params[:mode] == "draft"
        render :action => 'confirm'
      else
        @<%= file_name %>.save!
        redirect_to <%= singular_name %>_path(@<%= singular_name %>), :notice => 'saved success.'
      end
    else
      render (@<%= singular_name %>.new_record? ? :new : :edit)
    end
  end
end
