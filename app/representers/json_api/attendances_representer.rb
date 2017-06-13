require 'roar/json/json_api'

class JsonApi::AttendancesRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :attendances

  attributes do
    property :attended
    property :status
    property :person, extend: JsonApi::PeopleRepresenter, class: Person

    collection :origins do
      property :id
      property :name
    end
  end
end
