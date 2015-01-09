require 'rails_helper'

RSpec.describe DressSize, :type => :model do

  before { @dress_size = DressSize.new(name: "Small") }

  subject { @dress_size }

  it { should respond_to :name }
  it { should respond_to :style_profiles }
  it { should be_valid }
end
