module Apitizer
  Error = Class.new(StandardError)

  @defaults = {
    format: :json,
    adaptor: :standard,
    headers: {}
  }.freeze

  @actions = [ :index, :show, :create, :update, :delete ].freeze
  @collection_actions = [ :index, :create ].freeze
  @member_actions = [ :show, :update, :delete ].freeze

  @action_dictionary = {
    :index => :get,
    :show => :get,
    :create => :post,
    :update => :put,
    :delete => :delete
  }.freeze

  singleton_class.class_eval do
    attr_reader :defaults, :actions, :collection_actions,
      :member_actions, :action_dictionary
  end
end
