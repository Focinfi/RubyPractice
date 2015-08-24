class ManagedDomain < ActiveRecord::Base

  enum dns_state: [
    :unprovisioned,       # default state
    :provision_failed,    # added provision_failed back else we can't save the records that have provision_failed already
    :prevalidated,        # not using domain management service
    :user_created,        # created CloudFlare account
    :full_zone_set,       # full zone has been created
    :zone_records_added,  # full zone has been set
    :provision_success,   # records has been added
    :nameservers_updated, # nameservers has been changed
  ]

  # Validation
  validates :user_id, presence: true
  validates :domain, presence: true
  # validates :dns_state, inclusion: DNS_STATES

  # Relationship
  belongs_to :user

  # Scopes
  scope :failed,              -> { self.provision_failed }
  scope :transferring,        -> { self.provision_success }
  scope :transferred,         -> { self.nameservers_updated }

  # attributes
  attr_accessible :user_id, :domain, :dns_state, :dns_zone_id

  # checker
  # activate ManagedDomain.exists_in_scope?

  # define_method version
  def self.metaclass
    class << self
      self
    end
  end

  [:failed, :transferring, :transferred].each do |scope|
    self.metaclass.instance_eval do
      define_method "exists_in_#{scope}?" do |domain|
        send(scope).pluck(:domain).include? domain
      end
    end
  end

  # method_missing version
  def self.method_missing(method_name, domain)
    # get the scope work in `exists_in_scope?
    match_result = method_name.to_s.match(%r{^exists_in_([a-z]*)\?$})
    # only handle 3 kinds of scope
    scope = match_result.captures.first if match_result
    super unless scope && [:failed, :transferring, :transferred].include?(scope.to_sym)
    self.send(scope).pluck(:domain).include? domain
  end

end
