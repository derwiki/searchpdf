source 'https://rubygems.org'
ruby '2.4.0'

gem 'rails', '4.2.8'
gem 'pg', group: :production

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'google-cloud-vision'
gem 'rmagick'
gem 'pdfkit'
gem 'pdf-reader'

install_if -> { RUBY_PLATFORM =~ /darwin/ } do
  # Includes wkthmltopdf binaries for use on Mac OS X
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
end

install_if -> { RUBY_PLATFORM =~ /linux/ } do
  # Includes wkthmltopdf binaries for use on Heroku/AWS
  gem 'wkhtmltopdf-heroku'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

