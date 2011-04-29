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

Factory.define :active_user, :class => User do |u|
  u.name 'jimdoe'
  u.password 'password'
  u.password_confirmation { |u| u.password }
  u.email 'jimdoe@example.com'
  u.user_state 'active'
end

Factory.define :active_email do |e|
  e.association :user, :factory => :active_user
  e.address 'otherguy2@example.com'
  e.active true
end
