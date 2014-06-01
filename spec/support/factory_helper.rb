module FactoryHelper
  def create_tree(*names)
    operations = names.last.is_a?(Hash) ? names.pop : {}
    root = Apitizer::Routing::Node::Root.new
    leaf = names.inject(root) do |parent, object|
      if object.is_a?(Array)
        name, only = *object
        node = Apitizer::Routing::Node::Collection.new(name, only: only)
      else
        name = object
        node = Apitizer::Routing::Node::Collection.new(name)
      end
      parent.append(node)
      node
    end
    operations.each do |name, action|
      operation = Apitizer::Routing::Node::Operation.new(
        name, action: action, on: :member)
      leaf.append(operation)
    end
    root
  end
end
