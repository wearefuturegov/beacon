class Need < ApplicationRecord
  belongs_to :contact, counter_cache: true
  belongs_to :user, optional: true
  has_many :notes, dependent: :destroy

  has_paper_trail

  scope :completed, -> { where.not(completed_on: nil) }
  scope :uncompleted, -> { where(completed_on: nil) }
  scope :filter_by_category, -> (category) { where(category: category) }
  scope :filter_by_user_id, -> (user_id) { where(user_id: user_id) }
  scope :filter_by_status, -> (status) do
    status = status.downcase
      if status == 'to do'
        where(completed_on: nil)
      else
        where.not(completed_on: nil)
      end
    end

  counter_culture :contact,
                  column_name: proc { |model| model.completed_on ? 'completed_needs_count' : 'uncompleted_needs_count' },
                  column_names: {
                      Need.uncompleted => :uncompleted_needs_count,
                      Need.completed => :completed_needs_count
                  }


  validates :name, presence: true

  delegate :name, :is_vulnerable, to: :contact, prefix: true
  delegate :name, to: :user, prefix: true
end
