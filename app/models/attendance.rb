class Attendance < ApplicationRecord
  include Api::Identifiers
  has_paper_trail ignore: [:created_at, :updated_at]

  has_many :attendance_origins
  has_many :origins, through: :attendance_origins

  # Temporary attributes used for import from Action Network
  attr_accessor :event_uuid
  attr_accessor :person_uuid


  scope :attended, -> { where(attended: true) }
  scope :unsynced, -> { where(synced: false) }
  validates :person_id, uniqueness: { scope: :event_id }


  has_many :tickets
  belongs_to :person
  belongs_to :event

  has_many :email_addresses, through: :person
  has_many :phone_numbers, through: :person
  has_many :personal_addresses, through: :person

  def export(group)
    Api::ActionNetwork::Attendance.export!(self, group)
    self.update_attribute(:synced, true)
  end

  def self.activity_feed(group, date=Date.today)
    group.attendances.includes(:event).where(
      updated_at: date.beginning_of_day...date.end_of_day
    ).group_by do |att|
      "#{att.event.title}-#{att.event.id}"
    end
  end
end
