require 'microformats_helper/helpers'
require 'active_support'

ActiveSupport.on_load(:action_view) do
  include MicroformatsHelper::Helpers
end