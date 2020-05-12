module Select2Helper
  def select2(val, attrs)
    first("[data-select2-id^='#{attrs[:from]}']").click
    find('.select2-search__field').set(val).native.send_keys(:return)
  end
  end

World(Select2Helper)
