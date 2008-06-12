# Rubygems is where Rails is located
require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/microformats_helper'
# Here's the helper file we need
require 'action_controller'
require 'action_controller/test_process'
require 'action_view/helpers/tag_helper'

class MicroformatsHelperTest < Test::Unit::TestCase

  # This is the helper with the 'tag' method
  include ActionView::Helpers::TagHelper
  include MicroformatsHelper

  def test_hcard_fn
    output = hcard(:fn => "Ricardo Yasuda")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\">Ricardo Yasuda</span>\n</span>", output
  end
  
  def test_hcard_given_family
    output = hcard(:given => "Ricardo", :family => "Yasuda")
    assert_equal "<span class=\"vcard\">\n<span class=\"fn n\"> <span class=\"given-name\">Ricardo</span> <span class=\"family-name\">Yasuda</span></span>\n</span>", output
  end
end