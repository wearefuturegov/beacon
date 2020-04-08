# frozen_string_literal: true

module ContactsHelper
  def boolean_formatter(field)
    if field
      image_tag("red-tick.svg", alt: "Yes")
    else
      '-'
    end
  end
end
