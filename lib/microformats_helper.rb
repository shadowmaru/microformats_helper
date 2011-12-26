require 'microformats_helper/helpers'
require 'active_support'

if ActiveSupport.respond_to?(:on_load)
  ActiveSupport.on_load(:action_view) do
    include MicroformatsHelper::Helpers
  end
else
  ActionView::Base.send :include, MicroformatsHelper::Helpers
end