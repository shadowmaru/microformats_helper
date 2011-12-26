require 'microformats_helper/helpers'

ActiveSupport.on_load(:action_view) do
  include MicroformatsHelper::Helpers
end