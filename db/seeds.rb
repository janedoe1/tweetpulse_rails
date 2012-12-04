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

u = User.new(
  :first_name => "Corinne",
  :last_name => "Sherman",
  :email => "csherman@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Ziggy",
  :last_name => "Lin",
  :email => "zihlin@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Sudha",
  :last_name => "Jamthe",
  :email => "sujamthe@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Nirveek",
  :last_name => "Ide",
  :email => "nide@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Palm",
  :last_name => "Norchoovech",
  :email => "pnorchoovech@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Shubha",
  :last_name => "Ranganathan",
  :email => "shranganathan@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Muthu",
  :last_name => "Sundaresan",
  :email => "msundaresan@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)

u = User.new(
  :first_name => "Ronan",
  :last_name => "Gillen",
  :email => "rgillen@ebay.com",
  :password => 'ebaytester'
)
u.save!(:validate => false)
