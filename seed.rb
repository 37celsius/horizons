require_relative 'db_config'
require_relative 'checkpoint'
require_relative 'user'
require_relative 'race'
require_relative 'checkpoint_race_user'

Checkpoint.delete_all # everytime I run seed delete all records

Checkpoint.create name: "Queen St/Flinders Lane",
	description: "On the corner of Queen Street and Flinders Lane",
	latitude: -37.817896,
	longitude: 144.962034

Checkpoint.create name: "Elizabeth St/Flinders Lane",
	description: "On the corner of Elizabeth Street and Flinders Lane",
	latitude: -37.817231,
	longitude: 144.964400

Checkpoint.create name: "Elizabeth St/Flinders Street",
	description: "On the corner of Elizabeth Street and Flinders Street",
	latitude: -37.818125,
	longitude: 144.964829

Checkpoint.create name: "Queen St/Flinders Street",
	description: "On the corner of Queen Street and Flinders Street",
	latitude: -37.818805,
	longitude: 144.962464


User.delete_all

User.create user_name: "Beta",
	email: "beta@37celcius.com",
	password: "password"

User.create user_name: "DT",
	email: "DT@GA.com",
	password: "password1"

User.create user_name: "Phil",
	email: "phil@littlepony.com",
	password: "bigpony"


Race.delete_all

Race.create name: "Melbourne Madness",
	created_at: Time.now


Checkpoint_Race_User.delete_all

Checkpoint_Race_User.create user_id: 1,
	checkpoint_id: 3,
	race_id: 1

Checkpoint_Race_User.create user_id: 1,
	checkpoint_id: 2,
	race_id: 1

Checkpoint_Race_User.create user_id: 2,
	checkpoint_id: 1,
	race_id: 1

Checkpoint_Race_User.create user_id: 2,
	checkpoint_id: 2,
	race_id: 1

Checkpoint_Race_User.create user_id: 3,
	checkpoint_id: 2,
	race_id: 1
