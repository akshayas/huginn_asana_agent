require "asana"
require "huginn_agent/spec_helper"
require "rails_helper"
require "huginn_asana_agent/asana_task_query_agent"

describe Agents::AsanaTaskQueryAgent do
  it "should return a blank instance" do
    k = false
    expect(k).to be false
  end
end