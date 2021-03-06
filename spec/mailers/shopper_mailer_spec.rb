require "rails_helper"

RSpec.describe ShopperMailer, :type => :mailer do
  let(:retailer){ FactoryGirl.create(:retailer) }
  let!(:owner){ FactoryGirl.create(:retailer_user, retailer: retailer) }
  let(:shopper){ FactoryGirl.create(:shopper_user) }
  let!(:drop_in_availability) {
  FactoryGirl.create(:standard_availability_for_tomorrow,
                     retailer: retailer,
                     location: retailer.location)
  }
  let!(:drop_in){ FactoryGirl.create(:drop_in,
                                   user: shopper,
                                   retailer: retailer,
                                   time: tomorrow_mid_morning) }

  before(:each) do
  end

  describe "drop in scheduled email" do
    let(:asserted_mail_method) { ShopperMailer.drop_in_scheduled_email(drop_in) }
    let(:asserted_greeting) { "Hello #{shopper.first_name}" }
    let(:asserted_body) { ["#{greeting}", "You have scheduled a styling with #{retailer.name} for #{drop_in.colloquial_time}",
                            "Check out all of your upcoming stylings on OpenStile"]}
    let(:asserted_recipient) { shopper.email }
    let(:asserted_subject) { "You have scheduled a styling with #{retailer.name}!" }
    it_behaves_like "a_well_tested_mailer"
    it 'should have ics attachment' do
      expect(ShopperMailer.drop_in_scheduled_email(drop_in).attachments).to_not be_empty
    end
  end

  describe "drop in canceled email" do
    let(:asserted_mail_method) { ShopperMailer.drop_in_canceled_email(drop_in) }
    let(:asserted_greeting) { "Hello #{shopper.first_name}" }
    let(:asserted_body) { ["#{greeting}", "You have canceled your styling with #{retailer.name} for #{drop_in.colloquial_time}",
                            "Check out your updated stylings on OpenStile"]}
    let(:asserted_recipient) { shopper.email }
    let(:asserted_subject) { "You have canceled your styling with #{retailer.name}" }
    it_behaves_like "a_well_tested_mailer"
  end

end
