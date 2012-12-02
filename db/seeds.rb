# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

u = User.new(
  :first_name => "Kyle",
  :last_name => "Conarro",
  :email => "kyle.conarro@gmail.com",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)