Factory.define :user do |u|
  u.name 'johndoe'
  u.password 'password'
  u.password_confirmation { |u| u.password }
  u.email 'johndoe@example.com'
end

Factory.define :email do |e|
  e.association :user
  e.address 'otherguy@example.com'
end
