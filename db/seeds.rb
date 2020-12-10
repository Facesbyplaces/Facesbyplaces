# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.all 

users.each do |user|
    user.update(hideBirthdate: false, hideBirthplace: false, hideEmail: false, hideAddress: false, hidePhonenumber: false,)
end