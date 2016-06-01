class Deal < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true, if: ("publishable?")
  validates :min_qty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, if: ("publishable?")
  validates :max_qty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: ->(deal) { deal.min_qty } }, if: ("publishable? && min_qty?")
  validates :start_time, presence: true, if: ("publishable?")
  validates :expire_time, presence: true, if: ("publishable?")
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }, if: ("publishable?")
  validates :max_qty_per_customer, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: ->(deal) { deal.max_qty }}, if: ("publishable? && max_qty? ")
  validates :instructions, presence: true, if: ("publishable?")
  validates :category_id, presence: true
  validates :merchant_id, presence: true
  validates_associated :locations, if: ("publishable?")

  validates_with CategoryValidator
  validates_with MerchantValidator
  validates_with StartTimeValidator, if: ("publishable?")
  validates_with ExpireTimeValidator, if: ("publishable?")

  belongs_to :category
  belongs_to :merchant
  has_many :locations, dependent: :destroy, validate: false
  accepts_nested_attributes_for :locations

  before_update :expired_deal?, if: ("publishable?")
  before_update :live_deal?, if: ("publishable?")


  def publish
    self.publishable = true
    save
  end

  def unpublish
    self.publishable = false
    save
  end

  private

    def expired_deal?
      expire_time > Time.current
    end

    def live_deal?
      !Time.current.between?(start_time, expire_time)
    end
end
