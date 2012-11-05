# -*- coding: utf-8 -*-
# destroyメソッドに注意。モバイル対応＆テキストリンク利用のためイレギュラーなことをしている
# restに対応した形を徹底したい場合は、削除確認ページへのリンクを以下の様に、formにする
# <%= form_tag(Project_path(project, :mode => "draft"), :method=>:delete) do %><%= submit_tag "delete", :name => "delete" %><% end %>

class ProjectsController < ApplicationController
  def index
#    @search = Search::Project.new(params[:search])
    @projects = Project.joins("inner join tasks on tasks.project_id = projects.id").order("created_at desc").group("projects.id").all
  end

  def show
    @project = Project.find(params[:id])
    render "destroy" if params[:mode] == "draft"
  end

  def new
    @project = Project.new(params[:project])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    save
  end

  def update
    @project = Project.find(params[:id])
    @project.attributes = params[:project]
    save
  end

  def destroy
    @project = Project.find(params[:id])
    if params.key?("back")
      redirect_to(project_url)
    elsif params[:mode] != "draft"
      @project.destroy
      redirect_to(project_url, :notice => "deleted success.")
    end
  end

  
  private
  def save
    if !params.key?("back") && @project.valid?
      if params[:mode] == "draft"
        render :action => 'confirm'
      else
        @project.save!
        redirect_to project_path(@project), :notice => 'saved success.'
      end
    else
      render (@project.new_record? ? :new : :edit)
    end
  end
end
