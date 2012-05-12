# -*- coding: utf-8 -*-
# destroyメソッドに注意。モバイル対応＆テキストリンク利用のためイレギュラーなことをしている
# restに対応した形を徹底したい場合は、削除確認ページへのリンクを以下の様に、formにする
# <%= form_tag(Task_path(task, :mode => "draft"), :method=>:delete) do %><%= submit_tag "delete", :name => "delete" %><% end %>

class TasksController < ApplicationController
  def index
    @search = Search::Task.new(params[:search])
    @search.project_id = params[:project_id]
    @tasks = @search.base.order("created_at desc").all
  end

  def show
    @task = Task.find(params[:id])
    render "destroy" if params[:mode] == "draft"
  end

  def new
    @task = Task.new(params[:task])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])
    save
  end

  def update
    @task = Task.find(params[:id])
    @task.attributes = params[:task]
    save
  end

  def destroy
    @task = Task.find(params[:id])
    if params.key?("back")
      redirect_to(task_url)
    elsif params[:mode] != "draft"
      @task.destroy
      redirect_to(task_url, :notice => "deleted success.")
    end
  end

  
  private
  def save
    if !params.key?("back") && @task.valid?
      if params[:mode] == "draft"
        render :action => 'confirm'
      else
        @task.save!
        redirect_to task_path(@task), :notice => 'saved success.'
      end
    else
      render (@task.new_record? ? :new : :edit)
    end
  end
end
