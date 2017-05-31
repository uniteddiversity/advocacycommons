require 'test_helper'
require 'minitest/mock'

class ImportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #find' do
    person = Person.create(given_name: 'example')
    EmailAddress.create(address: 'example@example.com', person: person)
    sign_in person
    url = 'https://www.facebook.com/123465'

    get find_imports_url(remote_event_url: url), as: :json
    assert_redirected_to '/events'

    person = Person.first
    sign_in person

    remote_event = { 'name' => 'Name', 'start_time' => Date.today.to_s }
    facebook_agent = Minitest::Mock.new
    facebook_agent.expect :find, remote_event, [url]

    event = Event.create(start_date: Date.today, status: 'MyString')
    event.groups.push(Group.first)

    Facebook::Event.stub :new, facebook_agent do
      get find_imports_url(remote_event_url: url), as: :json
      json = JSON.parse(@response.body)
      assert_equal 1, json['events']['data'].size
      assert_equal event.id, json['events']['data'].first['id'].to_i
      assert_equal remote_event['name'], json['remote_event']['name']
    end
  end

  test 'post #create when Event not found' do
    current_user = people(:organizer)
    sign_in current_user

    remote_event_count_before = RemoteEvent.count

    post imports_url(
      event_id: '',
      remote_event: {
        id: 'uid',
        name: 'facebook event'
      }
    ), as: :json

    assert_response :unprocessable_entity
    assert_equal remote_event_count_before, RemoteEvent.count
    assert_equal 'Event can\'t be blank', JSON.parse(@response.body)[0]
  end

  test 'post #create when missing id' do
    current_user = people(:organizer)
    sign_in current_user

    remote_event_count_before = RemoteEvent.count

    post imports_url(
      event_id: Event.first,
      remote_event: {
        id: '',
        name: 'facebook event'
      }
    ), as: :json

    assert_response :unprocessable_entity
    assert_equal remote_event_count_before, RemoteEvent.count
    assert_equal 'Uid can\'t be blank', JSON.parse(@response.body)[0]
  end

  test 'post #create' do
    current_user = people(:organizer)
    sign_in current_user

    remote_event_count_before = RemoteEvent.count

    post imports_url(
      event_id: Event.first,
      remote_event: {
        id: 'uid',
        name: 'facebook event'
      }
    ), as: :json

    assert_response :success
    assert_equal remote_event_count_before + 1, RemoteEvent.count
    assert_equal remote_event_count_before + 1, FacebookEvent.count
  end
end
