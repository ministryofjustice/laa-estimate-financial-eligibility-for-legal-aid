require "rails_helper"

RSpec.describe "Check answers page" do
  let(:estimate_id) { SecureRandom.uuid }

  context "when I have entered benefits" do
    before do
      visit estimate_build_estimate_path(estimate_id, :benefits)
      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Child benefit"
      fill_in "Enter amount", with: "150"
      choose "Every week"
      click_on "Save and continue"
    end

    scenario "I can modify those benefits from the 'check answers' screen" do
      visit estimate_build_estimate_path(estimate_id, :check_answers)

      within("#field-list-benefits") { click_on "Change" }
      fill_in "Benefit type", with: "Child Benefits"
      click_on "Save and continue"
      within("#field-list-benefits") do
        expect(page).to have_content "Child Benefits"
      end
    end

    scenario "I can add and remove those benefits from the 'check answers' screen" do
      visit estimate_build_estimate_path(estimate_id, :check_answers)

      within("#subsection-benefits-header") { click_on "Change" }

      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Universal credit"
      fill_in "Enter amount", with: "300"
      choose "Every week"
      click_on "Save and continue"

      find(".button-as-link", match: :first).click

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      expect(page).to have_current_path(estimate_build_estimate_path(estimate_id, :check_answers))

      within("#field-list-benefits") do
        expect(page).not_to have_content "Child benefit"
        expect(page).to have_content "Universal credit"
      end
    end
  end

  context "when I have no benefits so far" do
    scenario "I can create new benefits from the 'check answers' screen" do
      visit estimate_build_estimate_path(estimate_id, :check_answers)
      within("#subsection-benefits-header") { click_on "Change" }
      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Child Benefits"
      fill_in "Enter amount", with: "150"
      choose "Every week"
      click_on "Save and continue"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      expect(page).to have_current_path(estimate_build_estimate_path(estimate_id, :check_answers))

      within("#field-list-benefits") do
        expect(page).to have_content "Child Benefits"
      end
    end
  end
end