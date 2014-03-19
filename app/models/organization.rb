# ## Schema Information
#
# Table name: `organizations`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`created_at`**                | `datetime`         |
# **`id`**                        | `integer`          | `not null, primary key`
# **`name`**                      | `string(255)`      |
# **`organization_category_id`**  | `integer`          |
# **`updated_at`**                | `datetime`         |
#
# ### Indexes
#
# * `index_organizations_on_organization_category_id`:
#     * **`organization_category_id`**
#

class Organization < ActiveRecord::Base
  validates_presence_of :organization_category_id, :name
  validates_associated :organization_category
  validates :name, :uniqueness => true

  belongs_to :organization_category
  has_many :memberships
  has_many :organization_aliases, :dependent => :destroy
  has_many :organization_statuses, :dependent => :destroy
  has_many :participants, :through => :memberships
  has_many :charges, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :downtime_entries, :dependent => :destroy
  has_many :tools, :through => :checkouts
  has_many :checkouts, :dependent => :destroy
  has_many :shifts  

  default_scope { order('name asc') }

  scope :search, lambda { |term| where('lower(name) LIKE lower(?)', "%#{term}%") }
  
  def booth_chairs
    memberships.where(:is_booth_chair => true).order('booth_chair_order ASC').map{|m| m.participant}
  end

  def non_booth_chairs
    memberships.where(:is_booth_chair => false).map{|m| m.participant}
  end
  
  def short_name
    short_name = read_attribute(:short_name)
    
    unless short_name.blank?
      return short_name
    else
      return name
    end
  end
end

