require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "super_secret_session_code"
  end

  get "/" do
    erb :welcome
  end

  get "/register" do
    if session[:scientist_id]
      redirect "/projects"
    else
      erb :"application/register"
    end
  end

  post "/register" do
    if params[:name] == "" || params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect "/register"
    else
      @scientist = Scientist.create(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
      session[:scientist_id] = @scientist.id
      redirect "/projects"
    end
  end

  get "/signin" do
    if session[:scientist_id]
      redirect "/projects"
    else
      erb :"application/signin"
    end
  end

  post "/signin" do
    @scientist = Scientist.find_by(:username => params[:username])
    if @scientist && @scientist.authenticate(params[:password])
      session[:scientist_id] = @scientist.id
      redirect "/projects"
    else
      redirect "/signin"
    end
  end

  get "/signout" do
    session.clear
    redirect "/signin"
  end

end
