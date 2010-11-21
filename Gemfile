source 'http://rubygems.org'

gem 'compass',              '~>0.10.6'
gem 'compass-susy-plugin',  '~>0.8.1' # Responsive web design with grids the quick and reliable way
                                    # To susy-fy your project, run:
                                    # compass init rails -r susy -u susy --sass-dir=app/stylesheets --css-dir=public/stylesheets/compiled
                                    # from the command-line.
gem 'haml',                 '~>3.0.24'
gem 'mysql2',               '~>0.2.6'
gem 'rails',                '~>3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end


group :development do
  gem 'cucumber-rails',           '~>0.3.2' # Cucumber Generators and Runtime for Rails
  gem 'mongrel',                  '1.2.0.pre2'  # Need this version when running Ruby 1.9.2
end

group :development, :test do
  gem 'capybara',                 '~>0.4.0' # Integration testing tool for rack based web applications. It simulates how a user would interact with a website
  gem 'cucumber',                 '~>0.9.4' # Behaviour Driven Development with elegance and joy
  gem 'database_cleaner',         '~>0.6.0'
  gem 'factory_girl_rails',       '1.0'
  gem 'launchy',                  '~>0.3.7' # So you can do Then show me the page
  gem 'pickle',                   '~>0.4.3' # Easy model creation and reference in your cucumber features
  gem 'remarkable_activerecord',  '>=4.0.0.alpha4' # See http://ruby-lambda.blogspot.com/2010/05/remarkable-400alpha2.html
  # gem 'remarkable_rails',         '3.1.13', :require => nil
  gem 'rspec-rails',              '~>2.1.0'
  gem 'spork',                    '~>0.8.4' # A forking Drb spec server
end