module AjaxEditHelper
  def click_and_wait(click_id, wait_for_id)
    page.find(click_id).click
    expect(page.find(wait_for_id)).to be_visible
  end
end

World(AjaxEditHelper)
