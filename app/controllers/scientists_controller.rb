class ScientistsController < ApplicationController

  get "/scientists" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      @scientists = Scientist.all
      erb :"scientists/index"
    else
      flash[:sign_in_condition] = "You must be signed in to access this information."
      redirect "/sign_in"
    end
  end

  get "/scientists/:slug" do
    if session[:scientist_id] && Scientist.find_by_slug(params[:slug])
      @scientist = Scientist.find_by_slug(params[:slug])
      @projects = @scientist.projects
      erb :"scientists/show"
    else
      flash[:sign_in_condition] = "You must be signed in to access this information."
      redirect "/sign_in"
    end
  end

end
