require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "super_secret_session_code"
  end

  not_found do
    status 404
    erb :not_found
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
    @existing_scientist = Scientist.find_by(username: params[:username].downcase)
    if params[:name] == "" || params[:username] == "" || params[:email] == "" || params[:password] == ""
      session[:register_condition] = "Cannot register, some fields were left empty."
      redirect "/register"
    elsif @existing_scientist
      session[:register_condition] = "Username already exist, enter a different one."
      redirect "/register"
    elsif params[:password] != params[:password_confirm]
      session[:register_condition] = "Passwords did not match."
      redirect "/register"
    else
      @scientist = Scientist.create(name: params[:name], username: params[:username].downcase, email: params[:email], password: params[:password])
      session.clear
      session[:scientist_id] = @scientist.id
      redirect "/projects"
    end
  end

  get "/sign_in" do
    if session[:scientist_id]
      redirect "/projects"
    else
      @session_message = session[:sign_in_condition]
      erb :"application/signin"
    end
  end

  post "/sign_in" do
    @scientist = Scientist.find_by(username: params[:username].downcase)
    if @scientist && @scientist.authenticate(params[:password])
      session.clear
      session[:scientist_id] = @scientist.id
      redirect "/projects"
    else
      session[:sign_in_condition] = "Username/Password was entered incorrectly."
      redirect "/sign_in"
    end
  end

  get "/sign_out" do
    session.clear
    redirect "/sign_in"
  end

end
