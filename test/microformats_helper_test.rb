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

class ActionController::TestCase
  # Treats +text+ as DOM and uses selectors to check for element occurences.
  # http://www.echographia.com/blog/2009/08/22/assert_select-from-arbitrary-text/
  def assert_select_from(text, *args)
    @selected = HTML::Document.new(text).root.children
    assert_select(*args)
  end
end

class MicroformatsHelperTest < ActionController::TestCase

  # This is the helper with the 'tag' method
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include MicroformatsHelper

  # #######################################################################
  # Testing hcard

  def test_hcard_fn
    output = hcard(:fn => "Ricardo Yasuda")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\">Ricardo Yasuda</span>\n</span>", output
  end
  
  def test_hcard_given_family
    output = hcard(:given => "Ricardo", :family => "Yasuda")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\"> <span class=\"given-name\">Ricardo</span> <span class=\"family-name\">Yasuda</span></span>\n</span>", output
  end

  def test_hcard_given_additional_family
    output = hcard(:given => "Ricardo", :additional => "Shiota", :family => "Yasuda")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\"> <span class=\"given-name\">Ricardo</span> <span class=\"additional-name\">Shiota</span> <span class=\"family-name\">Yasuda</span></span>\n</span>", output
  end

  def test_hcard_org
    output = hcard(:org => "DBurns Design")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\"> <span class=\"org\">DBurns Design</span></span>\n</span>", output
  end

  def test_hcard_prefix_suffix
    output = hcard(:given => "Gregory", :family => "House", :prefix => "Dr.", :suffix => "M.D.")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\"><span class=\"honorific-prefix\">Dr.</span> <span class=\"given-name\">Gregory</span> <span class=\"family-name\">House</span>, <span class=\"honorific-suffix\">M.D.</span></span>\n</span>", output
  end
  
  def test_hcard_url
    output = hcard(:fn => "Ricardo Yasuda", :url => "http://blog.shadowmaru.org")
    assert_equal "<span class=\"vcard\"><a href=\"http://blog.shadowmaru.org\" class=\"fn n url\">Ricardo Yasuda</a></span>", output
  end
  
  def test_hcard_address
    output = hcard(:fn => "John Doe", :street => "123 Fictional Lane", :locality => "Neverland", :region => "Imagination")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\">John Doe</span>\n\n<span class=\"adr\"><span class=\"street-address\">123 Fictional Lane</span> <span class=\"locality\">Neverland</span> - <span class=\"region\">Imagination</span></span>\n</span>", output
  end
  
  def test_hcard_email
    output = hcard(:fn => "John Doe", :email => "john@doe.org")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\">John Doe</span>\n\n<a href=\"mailto:john@doe.org\" class=\"email\">john@doe.org</a>\n</span>", output
  end
  
  def test_hcard_tel
    output = hcard(:fn => "John Doe", :tel => { "home" => "555-5555", "fax" => "544-5544" })
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\">John Doe</span>\n\n<span class=\"tel\"><span class=\"tel-label-home type\">Home: </span><span class=\"value\">555-5555</span>\n<span class=\"tel-label-fax type\">Fax: </span><span class=\"value\">544-5544</span>\n</span>\n</span>", output
  end


end
