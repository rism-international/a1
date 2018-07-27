# encoding: UTF-8
require 'htmlentities'
require "sqlite3"
require 'active_record'
require 'pry'
require 'activerecord-import'
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "database.db"
)
unless ActiveRecord::Base.connection.table_exists? "records"
ActiveRecord::Schema.define do
  create_table :records do |table|
    table.column :komponist, :string
    table.column :lebensdaten, :string
    table.column :komverweis, :string
    table.column :geb, :string
    table.column :gest, :string
    table.column :titel, :string
    table.column :werkverzeichnis, :string
    table.column :opus, :string
    table.column :tonart, :string
    table.column :tonart_english, :string
    table.column :orig_titel, :string
    table.column :schlagwort1, :string
    table.column :schlagwort2, :string
    table.column :verweis_nachdruck, :string
    table.column :enthalten_in, :string
    table.column :impressum_anzeige, :string
    table.column :verlagsort, :string
    table.column :verlagname, :string
    table.column :drucker_stecher, :string
    table.column :plattennr, :string
    table.column :publikationsdatum, :string
    table.column :suchpbldatum1, :string
    table.column :suchpbldatum2, :string
    table.column :suchpbldatum3, :string
    table.column :suchpbldatum4, :string
    table.column :suchpbldatum5, :string
    table.column :suchpbldatum6, :string
    table.column :erscheinungsform, :string
    table.column :vsol, :string
    table.column :coro, :string
    table.column :isol, :string
    table.column :strings, :string
    table.column :woodwimds, :string
    table.column :winds, :string
    table.column :perc, :string
    table.column :iorch, :string
    table.column :keyb, :string
    table.column :plck, :string
    table.column :bc, :string
    table.column :suchbesetzung, :string
    table.column :fundort, :string
    table.column :fundortsregister, :string
    table.column :anmerkungen, :string
    table.column :a1_nummer, :string
    table.column :titelnr, :string
  end
end
end


class Record < ActiveRecord::Base
  def self.bulk_import
    records = []
    cnt = 0
    File.readlines('drucke.txt', :encoding => 'iso-8859-1').each_with_index do |line, index|
      puts cnt += 1
      if index > 0
        records << Record.build(line)
      end
      if records.size > 500
        Record.import(records.compact)
        records = []
      end
    end
    Record.import(records.compact)
  end

  def self.fields
    "komponist | lebensdaten | komverweis | geb | gest | titel | werkverzeichnis | opus | tonart | tonart_english | orig_titel | schlagwort1 | schlagwort2 | verweis_nachdruck | enthalten_in | impressum_anzeige | verlagsort | verlagname | drucker_stecher | plattennr | publikationsdatum | suchpbldatum1 | suchpbldatum2 | suchpbldatum3 | suchpbldatum4 | suchpbldatum5 | suchpbldatum6 | erscheinungsform | vsol | coro | isol | strings | woodwimds | winds | perc | iorch | keyb | plck | bc | suchbesetzung | fundort | fundortsregister | anmerkungen | a1_nummer | titelnr".split(" | ")
  end

  def self.build(line)
    return if line.blank?
    x = Record.fields
    record = Record.new
    #string = line.encode('utf-8')
    y = line.split(" | ")
    x.each_with_index do |e, index|
      begin
        value = HTMLEntities.new.decode y[index].strip
      rescue
        next
      end
      record[e.to_sym] =  value unless value.blank?
    end
    return record 
  end
end




