# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe Fog::Compute::Exoscale do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }

    @client = Fog::Compute::Exoscale.new(@config)
    @jobs = @client.jobs
  end  

  it "must respond to #all" do
    @client.jobs.must_respond_to :all
  end

  it "responds to #get" do
    @client.jobs.must_respond_to :get
  end
end