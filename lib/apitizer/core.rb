module Apitizer
  Error = Class.new(StandardError)

  @defaults = {
    format: :json,
    adaptor: :standard,
    dictionary: {
      :index => :get,
      :show => :get,
      :create => :post,
      :update => :put,
      :delete => :delete
    },
    headers: {}
  }

  @actions = [ :index, :show, :create, :update, :delete ]
  @collection_actions = [ :index, :create ]
  @member_actions = [ :show, :update, :delete ]

  singleton_class.class_eval do
    attr_reader :defaults, :actions, :collection_actions, :member_actions
  end
end
