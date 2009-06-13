
module Shoulda
  module Nomtracker
    module Macros
    
      def should_redirect_to_login
        should "be redirected to login" do
          assert_redirected_to login_path
        end
      end
      
      def should_render_logout_link
        should "display a logout link in the header" do
          assert_select "a", {:href => logout_url}
        end
      end
    
      def should_render(css_selector)
        should "render #{css_selector}" do
          assert_select css_selector
        end
      end

      def should_not_render(css_selector)
        should "not render #{css_selector}" do
          assert_select css_selector, false
        end
      end
      
      # Messaging Streams via JSON
      def should_update_message(type)
        should "return updated #{type} message stream" do
          json = JSON.parse(@response.body)
          assert_not_nil json['messages'][type.to_s]  
        end
      end
            
    end
  
    module Helpers
      def create_john
        create_user(john_attrs)
      end

      def create_user(options = {})
        record = User.create_and_activate(create_user_attrs.merge(options))
        record
      end

      def create_user_attrs
        { :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :name => 'Quire' }
      end

      def john_attrs
        { :email => 'john@slsdev.net', :password => 'johnjohn', :password_confirmation => 'johnjohn', :name => 'John' }
      end
    end
  end

end
