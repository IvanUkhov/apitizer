module FactoryHelper
  include ResourceHelper

  def create_tree(*names)
    operations = names.last.is_a?(Hash) ? names.pop : {}

    root = build_root

    leaf = names.inject(root) do |parent, object|
      if object.is_a?(Array)
        name, only = *object
        node = build_collection(name, only: only)
      else
        name = object
        node = build_collection(name)
      end
      parent.append(node)
      node
    end

    operations.each do |name, action|
      on = restful_member_actions.include?(action) ? :member : :collection
      operation = build_operation(name, action: action, on: on)
      leaf.append(operation)
    end

    root
  end

  private

  def build_root(*arguments)
    Apitizer::Routing::Node::Root.new(*arguments)
  end

  def build_collection(*arguments)
    Apitizer::Routing::Node::Collection.new(*arguments)
  end

  def build_operation(*arguments)
    Apitizer::Routing::Node::Operation.new(*arguments)
  end
end
