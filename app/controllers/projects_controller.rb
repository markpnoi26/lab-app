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

  get "/projects/:id" do
    erb :"projects/show"
  end

  get "/projects/:id/edit" do
    erb :"projects/edit"
  end

  patch "/projects/:id" do
  end

  delete "/projects/:id" do
  end

end
