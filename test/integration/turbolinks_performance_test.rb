require 'test_helper'

class TurbolinksPerformanceTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end

  test 'shows blog posts' do
    # Warm up the app
    visit '/'

    Benchmark.bm do |bm|
      bm.report " No Turbolinks" do
        visit_pages 'off'
      end

      bm.report "Yes Turbolinks" do
        visit_pages 'on'
      end
    end
  end

  def visit_pages(enabled)
    5.times do
      visit "/?turbolinks=#{enabled}"
      click_on 'Course one'
      click_on 'Teacher one'
      click_on 'Course one'
      click_on 'Student one'
      click_on 'List All Teachers'
      click_on 'List All Students'
      click_on 'Student two'
      click_on 'Course two'
      click_on 'Teacher two'
    end
  end
end
