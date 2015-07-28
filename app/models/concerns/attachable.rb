require 'active_support/concern'

module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attaches, as: :attachable, dependent: :destroy
    accepts_nested_attributes_for :attaches, reject_if: :all_blank, allow_destroy: true
  end
end
