require 'ostruct'

module Sequencescape::Api::FinderMethods
  module Delegation
    def self.included(base)
      base.with_options(:to => :all) do |all|
        all.delegate :each, :first, :last, :to_a, :size
        all.delegate :empty?, :blank?
        all.delegate :each_page, :first_page, :last_page
      end
    end
  end

  class << self
    def extended(base)
      base.singleton_class.send(:include, Delegation)
    end

    def included(base)
      base.send(:include, Delegation)
    end
  end

  class FindByUuidHandler
    include Sequencescape::Api::BasicErrorHandling

    def initialize(owner)
      @owner = owner
    end

    def new(*args, &block)
      # TODO: Consider updating
      @owner.__send__(:new, *args, &block)
    end
    private :new

    def success(json)
      new(json, true)
    end
  end

  def find(uuid)
    api.read_uuid(uuid, FindByUuidHandler.new(self))
  end

  class AllHandler
    include Sequencescape::Api::BasicErrorHandling

    def initialize(owner)
      @owner = owner
    end

    def api(*args, &block)
      # TODO: Consider updating
      @owner.__send__(:api, *args, &block)
    end
    private :api

    def new(*args, &block)
      # TODO: Consider updating
      @owner.__send__(:new, *args, &block)
    end
    private :new

    def success(json)
      ::Sequencescape::Api::PageOfResults.new(api, json, &method(:new))
    end
  end

  def all
    api.read(actions.read, AllHandler.new(self))
  end
end

module Sequencescape::Api::FinderMethods::Caching
  def all(reload = false)
    @cached_all = super() if @cached_all.nil? or reload
    @cached_all
  end
end

class Sequencescape::Api::PageOfResults
  include Enumerable

  attr_reader :api, :actions
  private :api, :actions

  attr_reader :size

  def initialize(api, json, &block)
    @api, @ctor = api, block
    update_from_json(json)
  end

  def empty?
    return @size.zero? if api.capabilities.size_in_pages?

    first_page
    @objects.empty?
  end

  def present?
    !empty?
  end

  def each(&block)
    walk_pages do
      @objects.each(&block)
    end
  end

  def each_page(&block)
    walk_pages do
      yield(@objects.dup)
    end
  end

  def first
    first_page
    @objects.first
  end

  def last
    last_page
    @objects.last
  end

  def walk_pages
    first_page
    while true
      yield
      break if actions.next.blank?
      next_page
    end
  end
  private :walk_pages

  class UpdateHandler
    include Sequencescape::Api::BasicErrorHandling

    def initialize(owner)
      @owner = owner
    end

    def update_from_json(*args, &block)
      # TODO: Consider updating
      @owner.__send__(:update_from_json, *args, &block)
    end
    private :update_from_json

    def success(json)
      update_from_json(json)
    end
  end

  [ :first, :last, :previous, :next ].each do |page|
    line = __LINE__ + 1
    class_eval(%Q{
      def #{page}_page
        self.tap do
          api.read(actions.#{page}, UpdateHandler.new(self)) unless actions.read == actions.#{page}
          yield(@objects.dup) if block_given?
        end
      end
    }, __FILE__, line)
  end
  private :last_page, :next_page

  def update_from_json(json)
    json.delete('uuids_to_ids')         # Discard unwanted rubbish
    actions = json.delete('actions')
    raise Sequencescape::Api::Error, 'No actions for page!' if actions.blank?

    if api.capabilities.size_in_pages?
      size = json.delete('size')
      raise Sequencescape::Api::Error, 'No size for page!' if size.blank?
      @size = size.to_i
    end

    raise Sequencescape::Api::Error, 'No object json in page!' if json.keys.empty?
    @actions, @objects = OpenStruct.new(actions), json[json.keys.first].map(&@ctor)
  end
  private :update_from_json
end
