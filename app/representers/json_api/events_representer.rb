require 'roar/json/json_api'

class JsonApi::EventsRepresenter < Roar::Decorator
  include Roar::JSON::JSONAPI.resource :events

  attributes do
    property :organizer, decorator: JsonApi::PersonRepresenter
    property :name
    property :start_date
    property :end_date
    property :status
    property :title
    property :rsvp_count
    property :attended_count
    property :browser_url

    property :group, decorator: JsonApi::GroupsRepresenter, class: Group

    property :location, decorator: Api::Resources::AddressRepresenter, class: EventAddress
    collection :tags, extend: JsonApi::TagsRepresenter
  end
end
