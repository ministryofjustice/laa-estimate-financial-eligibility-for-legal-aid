require "rails_helper"

RSpec.describe "Housing Benefit Pages", :partner_flag do
  let(:partner_housing_benefit_header) { I18n.t("estimate_flow.partner_housing_benefit.housing_benefit_received.legend") }
  let(:partner_housing_benefit_details_header) { I18n.t("estimate_flow.partner_housing_benefit_details.heading") }
  let(:partner_benefits_page_heading) { I18n.t("estimate_flow.partner_benefits.legend") }

  before do
    visit_flow_page(passporting: false, partner: true, target: :partner_housing_benefit)
  end

  it "shows the correct screen" do
    expect(page).to have_content(partner_housing_benefit_header)
  end

  context "when I omit some required information" do
    before do
      click_on "Save and continue"
    end

    it "shows me an error message" do
      expect(page).to have_content partner_housing_benefit_header
      expect(page).to have_content "Select yes if the partner gets Housing Benefit"
    end
  end

  context "when I say 'no' on the first page" do
    before do
      select_boolean_value("partner-housing-benefit-form", :housing_benefit, false)
      click_on "Save and continue"
    end

    it "Moves me on to the other benefits page" do
      expect(page).to have_content partner_benefits_page_heading
    end
  end

  context "when I say 'yes' on the first page" do
    before do
      select_boolean_value("partner-housing-benefit-form", :housing_benefit, true)
      click_on "Save and continue"
    end

    it "shows the correct screen" do
      expect(page).to have_content(partner_housing_benefit_details_header)
    end

    context "when I omit some required information" do
      before do
        click_on "Save and continue"
      end

      it "shows me an error message" do
        expect(page).to have_content partner_housing_benefit_details_header
        expect(page).to have_content "Enter Housing Benefit amount"
        expect(page).to have_content "Select frequency of Housing Benefit"
      end
    end

    context "when I fill in all required information" do
      before do
        fill_in "partner-housing-benefit-details-form-housing-benefit-value-field", with: 135
        select_radio_value("partner-housing-benefit-details-form", "housing-benefit-frequency", "every_two_weeks")
        click_on("Save and continue")
      end

      it "Moves me on to the other benefits page" do
        expect(page).to have_content partner_benefits_page_heading
      end
    end
  end
end
