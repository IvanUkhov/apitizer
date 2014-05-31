module Apitizer
  Error = Class.new(StandardError)

  @actions = [ :index, :show, :create, :update, :delete ].freeze
  @collection_actions = [ :index, :create ].freeze
  @member_actions = [ :show, :update, :delete ].freeze
  @action_dictionary = { :index => :get, :show => :get,
    :create => :post, :update => :post, :delete => :delete }.freeze

  singleton_class.class_eval do
    attr_reader :actions, :collection_actions, :member_actions
    attr_reader :action_dictionary
  end
end
