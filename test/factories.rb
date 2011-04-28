Factory.define :user do |u|
  u.name 'John Doe'
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :email do |e|
  e.association :user, :factory => :user
  e.address 'johndoe@example.com'
end
