require "pry"
require "pg"

HOSTNAME = :localhost
DATABASE = :todoapp

class Test
	attr_accessor :id, :description	

	def self.create_todo_table
		c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		c.exec %q{
			CREATE TABLE todo (
				id SERIAL PRIMARY KEY,
				description TEXT
				);
			}
			c.close
	end

	def self.create(args)
		todo = Test.new(args)
		todo.save
	end

	def self.all
		c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		results = []

		c.exec "SELECT * FROM todo;"

		res.each do |todo|
			id = todo['id']
			description = todo['description']

			results.push Test.new({:id => id, :description => description})
	end

	c.close
	results
	end

	def initialize(args)
		connect

		if args.has_key? :id
			@id = args[:id]
		end

		if args.has_key? :description
			@description = args[:description]
		end
	end

	def save
		sql = "INSERT INTO todo(description"
		args = [description]

		if id.nil?
			sql = ") VALUES ($1)"
		else
			sql += ", id) VALUES ($1, $2)"
			args.push id
		end

		sql += ' RETURNING *;'

		res = @c.exec_params(sql, args)
		@id = res[0]['id']
		self
	end

	def delete
		sql = "DELETE FROM todo WHERE id=$1"
		@c.exec_params(sql, [id])
		self
	end

	def close
		@c.close
	end

	def to_s
		"#{id}: #{description}"
	end

	private
		def connect
			@c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		end

end

class UI
	
	def self.getAnswer
		puts "Welcome to the todo app, what would you like to do?"
		puts "n - make a new todo"
		puts "l - list all todos"
		puts "u [id] - update a todo with a given id"
		puts "d [id] - delete a todo with a given id, if no id is provided, all todos will be deleted"
		puts "q - quit the application"

		answer = gets
		puts answer
	end
end

	def Test.ask
		# when each of these should have a gets for the input of the todo description
		command = UI.getAnswer
			if @answer == 'q'
				print "Quit"
			elsif @answer == 'n'
				test.create # should activate the create method 
			elsif @answer == 'l'
				all # should activate the all method
			elsif @answer == 'u'
				to_s # should activate the to_s to get to update 
			elsif @answer == 'd'
				delete # should activiate the delete methond
			else
					print "Other Command"
			end
	end

	# there should be something like todo = Test.new({:rating => 6, :title => "Frozen", :description => "A snowman name Olaf is comic relief"})
	# it should have a get for the n command where the user inputs the above

Test.ask
