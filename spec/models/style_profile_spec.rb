require 'rails_helper'

RSpec.describe StyleProfile, :type => :model do
  let(:shopper){ FactoryGirl.create(:user, user_role: UserRole.find_or_create_by(name: 'SHOPPER')) }
  before do
    @style_profile = StyleProfile.new(user: shopper)
  end

  subject { @style_profile }

  it { should respond_to :user_id }
  it { should respond_to :user }
  it { should respond_to :top_sizes }
  it { should respond_to :bottom_sizes }
  it { should respond_to :dress_sizes }
  it { should respond_to :body_shape_id }
  it { should respond_to :body_shape }
  it { should respond_to :top_fit }
  it { should respond_to :top_fit_id }
  it { should respond_to :bottom_fit }
  it { should respond_to :bottom_fit_id }
  it { should respond_to :special_considerations }
  it { should respond_to :body_builds }
  it { should respond_to :top_budget_index }
  it { should respond_to :bottom_budget_index }
  it { should respond_to :dress_budget_index }
  it { should respond_to :looks }
  it { should respond_to :flaunted_parts }
  it { should respond_to :flaunted_part_ids }
  it { should respond_to :downplayed_parts }
  it { should respond_to :downplayed_part_ids }
  it { should respond_to :avoided_colors }
  it { should respond_to :avoided_color_ids }
  it { should be_valid }

  context "when user is not present" do
    before { @style_profile.user = nil }
    it { should_not be_valid }
  end

end
