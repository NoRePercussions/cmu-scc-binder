# frozen_string_literal: true
class AddLookupKeyToOrganizationCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :organization_categories, :lookup_key, :string
  end
end
