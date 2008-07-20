module Nakajima
  module Rebound
    VERSION = '0.0.1'
  end
end  

%w(rubygems ruby2ruby).each { |lib| require lib } unless defined?(Ruby2Ruby)

require File.join(File.dirname(__FILE__), 'core_ext', 'object')

class UnboundMethod
  # eval's and memoizes the output of Ruby2Ruby's #to_ruby method
  def to_proc
    @to_proc ||= eval(to_ruby)
  end
  
  # Simple string name. Taken from Pat Maddox's with_context
  def name
    to_s.split("#").last.delete(">")
  end
  
  alias_method :bind_without_indifference, :bind
  # Allows an unbound method to be bound to any object, instead
  # of only those of the same class. Goes with original #bind method
  # first, and if that fails, meta_def's using #to_proc
  def bind_with_indifference(obj)
    bind_without_indifference(obj) rescue obj.meta_def(name, &to_proc)
  end
  alias_method :bind, :bind_with_indifference
end