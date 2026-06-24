# frozen_string_literal: true

require 'spec_helper'
require 'will_paginate'
require 'will_paginate/array'
require 'kaminari'
require 'pagy'

class DummyActiveRecordRelationForIntegrationTest
  def initialize(items)
    @items = items
    @offset_val = 0
    @limit_val = nil
  end

  def count(*_args)
    @items.count
  end

  def offset(val)
    @offset_val = val
    self
  end

  def limit(val)
    @limit_val = val
    @items[@offset_val, @limit_val] || []
  end
end

RSpec.describe NuecaRailsInterfaces::V2::Pagination do
  describe 'WillPaginateAdapter' do
    it 'correctly paginates an array using will_paginate' do
      collection = [1, 2, 3, 4, 5]
      result = NuecaRailsInterfaces::V2::Pagination::WillPaginateAdapter.paginate(collection, 2, 2)
      expect(result.to_a).to eq([3, 4])
    end
  end

  describe 'KaminariAdapter' do
    it 'correctly paginates a Kaminari array using kaminari' do
      collection = Kaminari.paginate_array([1, 2, 3, 4, 5])
      result = NuecaRailsInterfaces::V2::Pagination::KaminariAdapter.paginate(collection, 2, 2)
      expect(result.to_a).to eq([3, 4])
    end
  end

  describe 'PagyAdapter' do
    it 'correctly paginates a collection using pagy' do
      collection = DummyActiveRecordRelationForIntegrationTest.new([1, 2, 3, 4, 5])
      result = NuecaRailsInterfaces::V2::Pagination::PagyAdapter.paginate(collection, 2, 2)
      expect(result).to eq([3, 4])
    end
  end
end
