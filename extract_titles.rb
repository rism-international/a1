Dir['./*.rb'].each {|file| require file }
require 'yaml'

rx = Record.where.not(titel: nil)
res = []

rx.each do |r| 
  res << { r.a1_nummer[1..-1] => r.titel }
end

File.write('20181028-insert_a1_titles.yml', res.to_yaml) 


