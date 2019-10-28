class ScientistsController < ApplicationController

  get "/scientists" do
    if session[:scientist_id]
      @scientist = Scientist.find_by_id(session[:scientist_id])
      redirect "/users/#{@scientist.slug}"
    else
      redirect "/login"
    end
  end

  get "/scientists/:slug" do
    @scientist = Scientist.find_by_slug(params[:slug])
    @projects = @scientist.projects
    erb :"scientists/show"
  end

end
