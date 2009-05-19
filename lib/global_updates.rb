module GlobalUpdates
  # Merge this into the :update JSON node if you want to update all of the global stuff
  # Only use on pages where a user is logged in
  # e.g. render :json => {:something => something_else, :update => {:some_data => "blah"}.merge(global_updates)}
  def global_updates
    raise StandardError.new('Cannot call #global_updates when no one is logged in') if !current_user
    {:nomworth => current_user.nomworth}
  end
  
  private :global_updates
  
end