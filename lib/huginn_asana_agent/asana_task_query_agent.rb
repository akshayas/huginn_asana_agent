require "json"
require_relative "huginn_asana"

module Agents
  class AsanaTaskQueryAgent < Agent
    include FormConfigurable
    using HuginnAsana

    SUPPORTED_FIELDS=[:id, :assignee, :assignee_status, :created_at, :completed, :custom_fields, :due_at, :due_on]

    cannot_receive_events!

    gem_dependency_check { defined?(Asana::Client) }

    description do
      <<-MD
        The Asana Task Query Agent allows to query all tasks in a given project or section or tag.

        To authenticate you need to set `access_token`. You can find it within Asana
        webapp from "My Profile Settings" > Apps > Manage developer apps > Personal access token.
        Note that personal access tokens will only be shown once after which you wont be able to see it again.
        Make sure you are ready to save the access token in Huginn or in your password vault (1Password)

        List of supported fields

        #{SUPPORTED_FIELDS.map { |f| f.to_s }}
      MD
    end

    default_schedule "every_1h"

    def default_options
      {
        "access_token" => "",
        "id" => "",
        "field" => "",
        "type" => "project"
      }
    end

    form_configurable :access_token
    form_configurable :id
    form_configurable :fields
    form_configurable :type, type: :array, values: ["project", "section", "tag"]

    def working?
      !recent_error_logs?
    end

    def validate_options
      errors.add(:base, "you need to specify your Asana access token") unless options["access_token"].present?
      errors.add(:base, "you need to specify a valid id") unless options["id"].present?
      errors.add(:base, "you need to all the fields you want to receive. id and gid are included by default") unless options["fields"].present?
      fields = interpolated["fields"].split(",").map(&:strip)
      errors.add(:base, "one or more of your fields is invalid. Check your input") unless verify_fields(fields)
    end

    def verify_fields(fields)
      fields.reduce(true) do |result, field|
        result && SUPPORTED_FIELDS.include?(field.to_sym)
      end
    end

    def generate_events(result)
      result.each do |item|
        create_event(payload: item.to_json(fields))
      end
    end

    def check
      asanaClient = Asana::Client.new do |c|
        c.authentication :oauth2, bearer_token: interpolated["access_token"]
      end

      fields = interpolated["fields"].split(",").map(&:strip)

      case options["type"]
      when "project"
        result = asanaClient.tasks.find_by_project(projectId: interpolated["id"], options: { fields: fields })
        generate_events(result)
      when "section"
        result = asanaClient.tasks.find_by_section(section: interpolated["id"], options: { fields: fields })
        generate_events(result)
      when "tag"
        result = asanaClient.tasks.find_by_tag(tag: interpolated["id"], options: { fields: fields })
        generate_events(result)
      end
    end
  end
end
