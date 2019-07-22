require "json"
require_relative "huginn_asana"

module Agents
  class AsanaTaskQueryAgent < Agent
    using HuginnAsana

    cannot_create_events!

    gem_dependency_check { defined?(Asana::Client) }

    description do
      <<-MD
        The Asana Task Create Agent allows to create Asana tasks given some metadata

        To authenticate you need to set `access_token`. You can find it within Asana
        webapp from "My Profile Settings" > Apps > Manage developer apps > Personal access token.
        Note that personal access tokens will only be shown once after which you wont be able to see it again.
        Make sure you are ready to save the access token in Huginn or in your password vault (1Password)
      MD
    end

    default_schedule "every_1h"

    def default_options
      {
        "access_token" => "",
        "id" => "",
        "type" => "",
        "name" => "",
        "notes" => "",
        "assignee" => "",
        "due_on" => ""
      }
    end

    def working?
      !recent_error_logs?
    end

    def validate_options
      errors.add(:base, "you need to specify your Asana access token") unless options["access_token"].present?
    end

    def generate_events(result, fields)
      result.each do |item|
        create_event(payload: item.to_json(fields))
      end
    end

    def check
      asanaClient = Asana::Client.new do |c|
        c.authentication :oauth2, bearer_token: interpolated["access_token"]
      end

      data = {
        "name" => interpolated["name"]
        "assignee" => interpolated["assignee"]
      }

      case options["type"]
      when "project"

        result = asanaClient.tasks.find_by_project(projectId: interpolated["id"], options: { fields: fields })
        generate_events(result, fields)
      when "workspace"
        result = asanaClient.tasks.find_by_section(section: interpolated["id"], options: { fields: fields })
        generate_events(result, fields)
      when "tag"
        result = asanaClient.tasks.find_by_tag(tag: interpolated["id"], options: { fields: fields })
        generate_events(result, fields)
      end
    end
  end
end
