module Nakajima
  module Rebound
    VERSION = '0.0.2'
  end
end  

%w(rubygems ruby2ruby).each { |lib| require lib } unless defined?(Ruby2Ruby)

class UnboundMethod
  # eval's and memoizes the output of Ruby2Ruby's #to_ruby method
  def to_proc
    @to_proc ||= eval(to_ruby)
  end
  
  alias_method :to_s_without_ruby, :to_s
  # This is sort of ugly, but it does allow us to bind methods that
  # take block arguments (you can't use block arguments with blocks).
  def to_s_with_ruby(opt=nil)
    (opt != :ruby) ? to_s_without_ruby : begin
      @to_s ||= begin
        res = to_ruby
        res.gsub!(/\Aproc \{ /, "def #{name}")      # Replace proc definition
        res.gsub!(/\|([^\|]*)\|\n/, "(#{'\1'})\n")  # Use method param declaration
        res.gsub!(/\}\z/, 'end')                    # Replace proc end brace
        res
      end
    end
  end
  alias_method :to_s, :to_s_with_ruby
  
  # Simple string name. Taken from Pat Maddox's with_context
  def name
    @name ||= to_s.split("#").last.delete(">")
  end
  
  alias_method :bind_without_indifference, :bind
  # Allows an unbound method to be bound to any object, instead
  # of only those of the same class. Goes with original #bind method
  # first, and if that fails, meta_def's using #to_proc
  def bind_with_indifference(obj)
    bind_without_indifference(obj) rescue class<<obj;self;end.class_eval(to_s(:ruby))
  end
  alias_method :bind, :bind_with_indifference
end