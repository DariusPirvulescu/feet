class Object
  def self.const_missing(c)
    return nil if @const_missing_called == c.to_s

    require_relative '../utils/namespace.rb'
    namesp = Namespace.new

    @const_missing_called = c.to_s
    require namesp.to_snake_case(c.to_s)
    klass = Object.const_get(c)
    @const_missing_called = nil

    klass
  end
end