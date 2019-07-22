require "asana"
require "huginn_agent/spec_helper"
require "rails_helper"
require "huginn_asana_agent/asana_task_query_agent"

describe Agents::AsanaTaskQueryAgent do
  opts = {
    access_token: "some-token",
    id: "12345",
    fields: "name, due_on",
    type: "project"
  }

  let(:agent) {
    _agent = Agents::AsanaTaskQueryAgent.new(name: "Search Asana Tasks", options: opts)
    _agent.user = users(:bob)
    _agent.save!
    _agent
  }

  it "cannot receive events" do
    expect(agent.cannot_receive_events?).to eq true
  end

  describe "#working?" do
    it "would not be working if there are recent error" do
      stub(agent).recent_error_logs? { true }
			expect(agent).not_to be_working
    end
    
    it "would be working if there are no recent error" do
      stub(agent).recent_error_logs? { false }
			expect(agent).to be_working
		end
	end

  describe "#verify_fields" do
    it "returns false if there exists an unsupported field" do
      expect(agent.verify_fields(["name", "abc"])).to be false
    end

    it "returns true only if all fields are supported" do
      expect(agent.verify_fields(["name", "due_on", "resource_type"])).to be true
    end
  end

  context "#validate_options" do
    it "is valid with given options" do
      expect(agent).to be_valid
    end

    it "is invalid if access_token is missing" do
      agent.options[:access_token] = ""
      expect(agent).not_to be_valid
    end

    it "is invalid if id is missing" do
      agent.options[:id] = ""
      expect(agent).not_to be_valid
    end

    it "is invalid if fields are invalid" do
      agent.options[:fields] = "name, due_on, invalid_field"
      expect(agent).not_to be_valid
    end
  end
end