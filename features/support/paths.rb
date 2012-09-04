# Taken from the cucumber-rails project.

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/i
      '/login'
    when /the confirmation page/i
      '/login/confirm'
    when /the RCR page/
      '/rcr'
    when /the confirmation help page/i
      '/help/identity'
    when /the token help page/i
      '/help/token'
    when /the Submission confirmation page/i
      '/rcr/submit'
    when /the already complete page/i
      '/locked'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
