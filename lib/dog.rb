class Dog
    attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @name = name
        @breed = breed
        @id = id

    end
    def self.create_table 
     sql = <<-SQL
     CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
     )
    SQL
    DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = "DROP TABLE IF EXISTS dogs"
        DB[:conn].execute(sql)
    end
    def self.create_table(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end
    def self.new_from_db(row)
        id = row[0]
        name = row[1]
        breed = row[2]
        self.new(id, name, breed)
    end
    def self.all
        sql = <<-SQL
        SELECT * 
        FROM dogs
        SQL
        DB[:conn].execute(sql)
    end
    def self.find_by_name(name)
        sql = <<-SQL
        SELECT *
        FROM dogs
        WHERE name = ?
        LIMIT 1
        SQL
        DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
        end.first
        end
    end
    def self.find(id)
        sql = <<-SQL
        SELECT *
        FROM dogs
        WHERE id = ?
        LIMIT 1
        SQL
        DB[:conn].execute(sql, id).map do |row|
            self.new_from_db(row)
            end.first   
    end
end
