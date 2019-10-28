class ProjectsController < ApplicationController

  get "/projects" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      @projects = Project.all
      erb :"projects/index"
    else
      redirect "/signin"
    end
  end

  get "/projects/new" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      erb :"projects/new"
    else
      redirect "/signin"
    end
  end

  post "/projects" do
    if params[:content] != "" && params[:title] != "" && params[:date] != ""
      Project.create(title: params[:title], content: params[:content], date: params[:date], scientist_id: session[:scientist_id])
      redirect "/projects"
    else
      redirect "/projects/new"
    end
  end

  get "/projects/:id" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      @project = Project.find_by_id(params[:id])
      erb :"projects/show"
    else
      redirect "/signin"
    end
  end

  get "/projects/:id/edit" do
    @project = Project.find_by_id(params[:id])
    @scientist = Scientist.find_by_id(session[:scientist_id])
    if @scientist && @scientist.projects.include?(@project)
      erb :"projects/edit"
    elsif @user
      redirect "/projects"
    else
      redirect "/signin"
    end
  end

  patch "/projects/:id" do
    if params[:content] != "" && params[:title] != "" && params[:date] != ""
      @project = Project.find_by(scientist_id: session[:scientist_id], id: params[:id])
      @project.update(title: params[:title], content: params[:content], date: params[:date])
      redirect "/projects/#{params[:id]}"
    else
      redirect "/projects/#{params[:id]}/edit"
    end
  end

  delete "/projects/:id" do
    @scientist = Scientist.find_by_id(session[:scientist_id])
    @project = Project.find_by_id(params[:id])
    if @scientist && @scientist.projects.include?(@project)
      @project.delete
      redirect "/projects"
    elsif @user
      redirect "/projects"
    else
      redirect "/signin"
    end
  end

end
