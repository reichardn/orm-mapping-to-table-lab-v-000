class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
      @name = name
      @grade = grade
      @id = nil
  end  

  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def save
    sql = <<-SQL 
      INSERT INTO students (name, grade)
      VALUES(?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    select = "SELECT last_insert_rowid() FROM students"
    @id = DB[:conn].execute(select)[0][0]
  end
  
end
