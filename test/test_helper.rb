begin
  require "rubygems"
  require "bundler/setup"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler` and do a `bundle install`."
end
# Here's the helper file we need
require File.dirname(__FILE__) + '/../lib/microformats_helper'
require 'test/unit'
Bundler.require(:test)

class ActiveSupport::TestCase
  def assert_select_from(text, *args)
    @selected = HTML::Document.new(text).root.children
    assert_select(*args)
    yield @selected if block_given?
  end
end