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

u = User.new(
  :first_name => "Tan",
  :last_name => "Li",
  :email => "tanl@andrew.cmu.edu",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Hui",
  :last_name => "Sun",
  :email => "huis@andrew.cmu.edu",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Andi",
  :last_name => "Wang",
  :email => "andiw@andrew.cmu.edu",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Xaio",
  :last_name => "Fu",
  :email => "xaiof@andrew.cmu.edu",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Dan",
  :last_name => "Li",
  :email => "dli1@andrew.cmu.edu",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Evan",
  :last_name => "Miller",
  :email => "ewmst5@gmail.com",
  :password => 'p4ssw0rd'
)
u.save!(:validate => false)