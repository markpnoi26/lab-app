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
      session.delete(:register_condition) if session[:register_condition]
      redirect "/projects"
    else
      @session_message = session[:register_condition]
      erb :"application/register"
    end
  end

  post "/register" do
    @existing_scientist = Scientist.find_by(username: params[:username])
    if params[:name] == "" || params[:username] == "" || params[:email] == "" || params[:password] == ""
      session[:register_condition] = "Cannot register, some fields were left empty."
      redirect "/register"
    elsif @existing_scientist
      session[:register_condition] = "Username already exist, enter a different one."
      redirect "/register"
    else
      @scientist = Scientist.create(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
      session[:scientist_id] = @scientist.id
      session.delete(:register_condition) if session[:register_condition]
      redirect "/projects"
    end
  end

  get "/signin" do
    if session[:scientist_id]
      session.delete(:register_condition) if session[:register_condition]
      session.delete(:sign_in_condition) if session[:sign_in_condition]
      redirect "/projects"
    else
      @session_message = session[:sign_in_condition]
      erb :"application/signin"
    end
  end

  post "/signin" do
    @scientist = Scientist.find_by(username: params[:username])
    if @scientist && @scientist.authenticate(params[:password])
      session[:scientist_id] = @scientist.id
      session.delete(:sign_in_condition) if session[:sign_in_condition]
      session.delete(:register_condition) if session[:register_condition]
      redirect "/projects"
    else
      session[:sign_in_condition] = "Username or Password was entered incorrectly."
      redirect "/signin"
    end
  end

  get "/signout" do
    session.clear
    redirect "/signin"
  end

end
