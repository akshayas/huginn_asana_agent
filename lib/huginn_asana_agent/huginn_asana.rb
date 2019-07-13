require 'asana'

module HuginnAsana
  refine Asana::Resources::Task do
    def to_json(fields)
      payload = {
        "id" => self.id,
        "gid" => self.gid
      }

      fields.each do |field|
        payload[field] = self.send(field)
      end

      payload.to_json
    end
  end
end
