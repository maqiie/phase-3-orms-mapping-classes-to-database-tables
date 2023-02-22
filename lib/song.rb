# class Song

#   attr_accessor :name, :album, :id

#   def initialize(name:, album:, :id)
#     @id = id
#     @name = name
#     @album = album
  
#     def self.create_table
#       sql = <<-SQL
#       CREATE TABLE IF NOT EXISTS songs(
#         id INTEGER PRIMARY KEY,
#         name TEXT,
#         album TEXT
#       )
#       SQL
#       DB[:conn].execute(sql)
#     end

# end
require 'sqlite3'

DB = {:conn => SQLite3::Database.new("db/music.db")}

class Song
  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @name = name
    @album = album
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.album)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    self
  end

  def self.create(name:, album:)
    song = self.new(name: name, album: album)
    song.save
    song
  end
end
