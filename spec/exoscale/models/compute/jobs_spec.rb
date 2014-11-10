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
    @job  = @jobs.new
  end  

  it "responds to #reload" do
    assert_respond_to @job, :reload
  end

  it "responds to #ready?" do
    assert_respond_to @job, :ready?
  end

  it "responds to #successful?" do
    assert_respond_to @job, :successful?
  end

  it "responds to #result" do
    assert_respond_to @job, :result
  end

  it "responds to #all" do
    assert_respond_to @jobs, :all
  end

  it "responds to #get" do
    assert_respond_to @jobs, :get
  end

  it "returns a job with format" do  
    @job.id.must_be_kind_of NilClass
    @job.user_id.must_be_kind_of NilClass
    @job.account_id.must_be_kind_of NilClass
    @job.cmd.must_be_kind_of NilClass
    @job.job_status.must_be_kind_of NilClass
    @job.job_result_type.must_be_kind_of NilClass
    @job.job_result_code.must_be_kind_of NilClass
    @job.job_proc_status.must_be_kind_of NilClass
    @job.created_at.must_be_kind_of NilClass
    @job.job_result.must_be_kind_of NilClass
  end
end