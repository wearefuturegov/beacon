module Select2Helper
  def select2(select_id, val)
    @hidden_select_value = find("##{select_id} option", text: val.to_s)[:value].downcase
    find("##{select_id} + .select2.select2-container.select2-container--default").click
    @results_container = find("#select2-#{select_id}-results")
    @results_container.find("li[id$='#{@hidden_select_value}']").click
  end
end

World(Select2Helper)
