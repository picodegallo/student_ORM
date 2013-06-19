require 'sqlite3'
require 'pry'

class Student

  attr_accessor :name, :id

  DB = SQLite3::Database.new( "students.db" )

  def self.create_table
    DB.execute("CREATE TABLE students (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT
      );")  
  end

  def self.drop
    DB.execute("DROP TABLE IF EXISTS students;")
  end 

  def self.table_exists?(table)
    exists = DB.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='#{table}';")
  end

  def save
    if @id #already in database
      DB.execute("UPDATE students SET name = '#{@name}', id = #{@id} WHERE id = #{@id};")
    else #if it isn't
      DB.execute("INSERT INTO students(name) VALUES ('#{@name}');")
      max_id = DB.execute("SELECT max(id) FROM students;")
      @id = max_id.flatten.first
    end
  end

  def self.find_by_name(name)
    record = DB.execute("SELECT * FROM students WHERE name = '#{name}';")
    Student.new.tap{|s| s.name = record.first.last}
  end

  def self.all
    DB.execute("SELECT * FROM students;")
      .collect{|record| Student.new
        .tap{|s| s.name = record[1]}
      }
  end

  def self.find(finder_id)
    record = DB.execute("SELECT * FROM students WHERE id = #{finder_id};")
    Student.new.tap{|s| s.id = record.first.first ; s.name = record.first.last}
  end


# UPDATE suppliers
# SET name = 'HP'
# WHERE name = 'IBM';







end