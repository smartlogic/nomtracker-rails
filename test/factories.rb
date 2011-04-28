Factory.define :user do |u|
  u.name 'John Doe'
  u.password 'password'
  u.password_confirmation { |u| u.password }
end

Factory.define :email do |e|
  e.association :user
  e.address 'johndoe@example.com'
end
