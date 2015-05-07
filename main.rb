require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'checkpoint_race_user'
require_relative 'race'
require_relative 'user'
require_relative 'checkpoint'
require 'pry'

enable :sessions

before do
	User.joins(:checkpoints)
	@current_race = Race.last
	@user = current_user
	@users = User.all
end

after do
	ActiveRecord::Base.connection.close
end

get '/' do
	@race = Race.last
	@users = @race.users.distinct
  erb :index
end

get '/register' do
	erb :register
end

get '/login' do
	erb :login
end

get '/race' do
	erb :race
end

post '/race/new' do
	# create new race
	race = Race.create(name: "New Race", created_at: Time.now, ended: false)

	# add the 4 default checkpoints to this race
	CheckpointRaceUser.create(checkpoint_id: 1, race_id: race.id)
	CheckpointRaceUser.create(checkpoint_id: 2, race_id: race.id)
	CheckpointRaceUser.create(checkpoint_id: 3, race_id: race.id)
	CheckpointRaceUser.create(checkpoint_id: 4, race_id: race.id)

	# add the current user to this race
	CheckpointRaceUser.create(race_id: race.id, user_id: current_user.id)

	redirect to '/race'
end


post '/race/join' do
	# make sure they are logged in
	redirect to '/login' if !logged_in?

	# Add current user to the current race
	CheckpointRaceUser.create(
		user_id: current_user.id,
		race_id: current_race.id)

	# Redirect to /race
	redirect to '/race'

end

get '/status' do
	erb :status
end

get '/checkpoints' do
	@checkpoints = Checkpoint.all
	erb :checkpoints
end

get '/checkpoints/new' do
	erb :new_checkpoint
end

post '/checkpoints/new' do
	Checkpoint.create( name: params[:name], description: params[:description], latitude: params[:latitude], longitude: params[:longitude])
		redirect to '/checkpoints'
end

# Current race checkpoints
get '/api/checkpoints' do
	content_type :json
	checkpoints = current_race.checkpoints.distinct
	checkpoints.to_json
end

# Current user completed checkpoints
get '/api/checkpoints/completed' do
	content_type :json
	checkpoints = current_user.checkpoints.distinct # shouldn't need distinct in real life
	checkpoints.to_json
end

post '/api/checkpoints/:id/new' do
	newCP = CheckpointRaceUser.create(
		user_id: current_user.id,
		checkpoint_id: params[:id],
		race_id: current_race.id)
end

# LOGIN
post '/signup' do
	@user = User.create( user_name: params[:username], email: params[:email], password: params[:password])
		session[:user_id] = @user.id
	redirect to '/'
end

# SESSION STUFF
post '/session' do
	@user = User.where(email: params[:email]).first
	if @user && @user.authenticate(params[:password])
		session[:user_id] = @user.id
		redirect to '/'
	else
		erb :login
	end
end

delete '/session' do
	session[:user_id] = nil
	redirect to '/'
end


# HELPERS

helpers do
	def logged_in?
		!!current_user
	end

	def current_user
			User.find_by(id: session[:user_id])
	end

	def current_race
		# return the current race, if there is one running
		if Race.last.ended != true
			current_race = Race.last
		else
			current_race = false
		end
		current_race
	end

	def race_running?
		!!current_race
	end
end

