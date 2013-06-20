require 'sqlite3'
require 'pry'

class Student

  attr_accessor :name, :id, :bio, :tagline

  DB = SQLite3::Database.new( "students.db" )

  ATTRIBUTES = {
    "id" => "INTEGER PRIMARY KEY AUTOINCREMENT",
    "name" => "TEXT",
    "tagline" => "TEXT",
    "bio" => "TEXT"
  }

  def self.create_table
    # DB.execute("CREATE TABLE students (#{('?, '*ATTRIBUTES.size)[0..-3]});",ATTRIBUTES)
    DB.execute("CREATE TABLE students (
      #{ATTRIBUTES.collect {|key, value| 
        key + " " + value
        }.join(",")});") 
  end

  def self.drop
    DB.execute("DROP TABLE IF EXISTS students;")
  end 

  def self.table_exists?(table)
    exists = DB.execute("SELECT name FROM sqlite_master WHERE 
      type='table' AND name='#{table}'
      ;")
  end

  def save
    if @id #already in database
      DB.execute("UPDATE students SET 
        name = '#{@name}', id = #{@id} WHERE 
        id = #{@id}
        ;")
    else #if it isn't
      DB.execute("INSERT INTO students(name, bio, tagline) VALUES (?,?,?);",[@name, @bio, @tagline]) 
      max_id = DB.execute("SELECT max(id) FROM students;")
      @id = max_id.flatten.first
    end
  end

  def self.make_student_from_record(record)
    student = Student.new.tap do |s|
      s.id = record[0]
      s.name = record[1] 
      s.bio = record[2] 
      s.tagline = record[3]
    end
  end

  def self.find_by_name(name)
    record = DB.execute("SELECT * FROM students WHERE name = '#{name}';").first
    make_student_from_record(record)
    #Student.new.tap{|s| s.name = record.first[1]}
  end

  def self.find_by_bio(bio)
    record = DB.execute("SELECT * FROM students WHERE bio = '#{bio}';").first
    make_student_from_record(record)
  end

  def self.find_by_tagline(tagline)
    record = DB.execute("SELECT * FROM students WHERE tagline = '#{tagline}';").first
    make_student_from_record(record)
  end

  def self.all
    DB.execute("SELECT * FROM students;").collect{|record| Student.new.tap{|s| s.name = record[1]}}
  end

  def self.find(finder_id)
    record = DB.execute("SELECT * FROM students WHERE id = #{finder_id};").first
    make_student_from_record(record)
    #Student.new.tap{|s| s.id = record.first.first ; s.name = record.first.last}
  end

  def self.where(query)
    records = DB.execute("SELECT * FROM students WHERE name = '#{query[:name]}';")
    if records.size > 1 
      records
    else
      records.first
    end
  end


end




