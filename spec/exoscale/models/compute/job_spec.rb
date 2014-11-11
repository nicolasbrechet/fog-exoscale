# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Job" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }

    @client = Fog::Compute::Exoscale.new(@config)
  end
  
  describe "when accessing a job's attributes" do
    before do
      @job = @client.jobs.new
    end
    
    it "must respond to #id" do
      @job.must_respond_to :id
      @job.id.must_be_kind_of NilClass
    end
    
    it "must respond to #user_id" do
      @job.must_respond_to :user_id
      @job.user_id.must_be_kind_of NilClass
    end
    
    it "must respond to #account_id" do
      @job.must_respond_to :account_id
      @job.account_id.must_be_kind_of NilClass
    end
    
    it "must respond to #cmd" do
      @job.must_respond_to :cmd
      @job.cmd.must_be_kind_of NilClass
    end
    
    it "must respond to #job_status" do
      @job.must_respond_to :job_status
      @job.job_status.must_be_kind_of NilClass
    end
    
    it "must respond to #job_result_type" do
      @job.must_respond_to :job_result_type
      @job.job_result_type.must_be_kind_of NilClass
    end
    
    it "must respond to #job_result_code" do
      @job.must_respond_to :job_result_code
      @job.job_result_code.must_be_kind_of NilClass
    end
    
    it "must respond to #job_proc_status" do
      @job.must_respond_to :job_proc_status
      @job.job_proc_status.must_be_kind_of NilClass
    end
    
    it "must respond to #created_at" do
      @job.must_respond_to :created_at
      @job.created_at.must_be_kind_of NilClass
    end
    
    it "must respond to #job_result" do
      @job.must_respond_to :job_result
      @job.job_result.must_be_kind_of NilClass
    end
  end

  describe "when working with a job" do
    before do
      @job = @client.jobs.new
    end
    
    it "must respond to #reload" do
      @job.must_respond_to :reload
    end
    
    it "must respond to #ready?" do
      @job.must_respond_to :ready?
    end
    
    it "must respond to #successful?" do
      @job.must_respond_to :successful?
    end
    
    it "must respond to #result" do
      @job.must_respond_to :result
    end
  end
end