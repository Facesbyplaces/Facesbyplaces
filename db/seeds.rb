# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# users = User.all 

# users.each do |user|
#     user.update(hideBirthdate: false, hideBirthplace: false, hideEmail: false, hideAddress: false, hidePhonenumber: false,)
# end

# Admin
admin = User.new(
            first_name: "FBP",
            last_name: "Admin",
            account_type: 1,
            phone_number: '09053536495',
            email: "admin@email.com",
            username: "admin",
            password: 'admin123',
            is_verified: true
        )

# admin.image.attach(io: File.open('/app/assets/images'), filename: 'admin.jpg')
admin.save 
admin.add_role :admin
