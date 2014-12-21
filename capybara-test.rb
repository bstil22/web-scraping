# http://stackoverflow.com/questions/3484169/how-to-use-capybara-in-pure-ruby-without-rails

require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.google.com'

module MyCapybaraTest
  class Test
    include Capybara::DSL
    def test_google
      visit('/')
    end
  end
end

t = MyCapybaraTest::Test.new
t.test_google
