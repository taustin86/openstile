require 'rails_helper'

RSpec.describe Shoppers::RegistrationsController, :type => :controller do
  let(:shopper){ FactoryGirl.create(:shopper) }
  before {@request.env["devise.mapping"] = Devise.mappings[:shopper]}

  context "when shopper is signed in" do
    before { sign_in shopper }

    context "GET new" do
      it "redirects to root" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context "POST create" do
      it "redirects to root" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
