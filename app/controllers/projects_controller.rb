class ProjectsController < ApplicationController

  get "/projects" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      @projects = Project.all
      erb :"projects/index"
    else
      session[:sign_in_condition] = "You must be signed in to access this information."
      redirect "/sign_in"
    end
  end

  get "/projects/new" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      erb :"projects/new"
    else
      session[:sign_in_condition] = "You must be signed in to access this form."
      redirect "/sign_in"
    end
  end

  post "/projects" do
    if params[:content] != "" && params[:title] != "" && params[:date] != ""
      Project.create(title: params[:title], content: params[:content], date: params[:date], scientist_id: session[:scientist_id])
      redirect "/projects"
    else
      session[:new_condition] = "Some fields were left empty."
      redirect "/projects/new"
    end
  end

  get "/projects/:id" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      @project = Project.find_by_id(params[:id])
      erb :"projects/show"
    else
      session[:sign_in_condition] = "You must be signed in to access this information."
      redirect "/sign_in"
    end
  end

  get "/projects/:id/edit" do
    @project = Project.find_by_id(params[:id])
    @scientist = Scientist.find_by_id(session[:scientist_id])
    if @scientist && @scientist.projects.include?(@project)
      erb :"projects/edit"
    elsif @scientist
      redirect "/projects"
    else
      session[:sign_in_condition] = "You must be signed in to edit this information."
      redirect "/sign_in"
    end
  end

  patch "/projects/:id" do
    if params[:content] != "" && params[:title] != "" && params[:date] != ""
      puts params
      @project = Project.find_by(id: params[:id])
      @project.update(title: params[:title], content: params[:content], date: params[:date], scientist_id: params[:scientist_id])
      redirect "/projects/#{params[:id]}"
    else
      session[:edit_condition] = "Cannot edit, some fields were left empty."
      redirect "/projects/#{params[:id]}/edit"
    end
  end

  delete "/projects/:id" do
    @scientist = Scientist.find_by_id(session[:scientist_id])
    @project = Project.find_by_id(params[:id])
    if @scientist && @scientist.projects.include?(@project)
      @project.delete
      redirect "/projects"
    elsif @scientist
      redirect "/projects"
    else
      session[:sign_in_condition] = "You must be signed in to delete this information."
      redirect "/sign_in"
    end
  end

end
