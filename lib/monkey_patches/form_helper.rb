module ActionView
  module Helpers
    module FormHelper
      LEGACY_CLASS_NAME = 'legacy-form'.freeze
      alias rails_form_with form_with
      alias rails_form_for form_for

      def form_with(**options, &block)
        rails_form_with(**options_with_default(options), &block)
      end

      def form_for(record, **options, &block)
        rails_form_for(record, **options_with_default(options), &block)
      end

      private

      def options_with_default(options)
        if options[:html] && options[:html][:class].present?
          options
        else
          options.merge(html: { class: LEGACY_CLASS_NAME })
        end
      end
    end
  end
end
