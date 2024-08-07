require 'date'
require 'spec_helper.rb'
require 'rails_helper.rb'

describe 'DatepickerPlugin', js: true do

  before(:each) do
    visit '/'
    page.has_xpath? '//input[@id="login"]'

    within "form.login" do
      fill_in "username", with: "admin"
      fill_in "password", with: "admin"

      click_button "Sign In"
    end

    expect(page).not_to have_xpath('//input[@id="login"]')
    wait_for_ajax
    expect(page).to have_css('button[title="Show Advanced Search"]')
    first('button[title="Show Advanced Search"]').click
    first('.advanced-search-add-row-dropdown').click
    first('.advanced-search-add-date-row').click
    page.has_css? 'input#v1.date-field'

    @date_field = find 'input#v1.date-field'
    @datepicker_toggle = find 'button[title="Toggle the Date Picker"]'

    expect(page).not_to have_css('body > .datepicker')
    @datepicker_toggle.click
    expect(page).to have_css('body > .datepicker > .datepicker-years', visible: false)
    expect(page).to have_css('body > .datepicker > .datepicker-months', visible: false)
    expect(page).to have_css('body > .datepicker > .datepicker-days', visible: false)
  end

  it 'accepts a pasted year date in yyyy format' do
    @date_field.click
    # warning - this can throw a NotAllowedError if the user is inactive for too long.
    execute_script("navigator.clipboard.writeText('1999').catch(err => { TEST_MESSAGES.append(err); });")
    # js debug message will appear in ci_logs/frontend_test_log.out
    js_debug_messages = page.evaluate_script("TEST_MESSAGES.textContent");
    $logger.debug(js_debug_messages);

    if page.driver.browser.capabilities.platform_name =~ /^mac/
      @date_field.send_keys([:command, 'v'])
    else
      @date_field.send_keys([:control, 'v'])
    end

    expect(page).to have_css('body > .datepicker > .datepicker-years', visible: true)
  end

  it 'accepts a pasted month date in yyyy-mm format' do
    @date_field.click
    execute_script("navigator.clipboard.writeText('1999-12').catch(err => { TEST_MESSAGES.append(err); });")
    if page.driver.browser.capabilities.platform_name =~ /^mac/
      @date_field.send_keys([:command, 'v'])
    else
      @date_field.send_keys([:control, 'v'])
    end

    expect(page).to have_css('body > .datepicker > .datepicker-months', visible: true)
  end

  it 'accepts a pasted day date in yyyy-mm-dd format' do
    @date_field.click
    execute_script("navigator.clipboard.writeText('1999-12-31').catch(err => { TEST_MESSAGES.append(err); });")
    if page.driver.browser.capabilities.platform_name =~ /^mac/
      @date_field.send_keys([:command, 'v'])
    else
      @date_field.send_keys([:control, 'v'])
    end

    expect(page).to have_css('body > .datepicker > .datepicker-days', visible: true)
  end
end
