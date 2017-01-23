When(/^User visits home page$/) do
  visit root_path
end

Then(/^User sees a banner$/) do
  assert page.has_css?('#background')
end

Then(/^User sees four buttons$/) do
  assert page.has_css?('a.btn-flat', count: 4)
end
