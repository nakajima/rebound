# I love why the lucky stiff.
class Object
  # Easily access an object's metaclass (or eigenclass
  # or singleton class. potato pot-ah-to)
  def metaclass
    class << self; self end
  end
  
  # Evaluate a block in a context of an object's metaclass
  def meta_eval(&block)
    metaclass.instance_eval(&block)
  end
  
  # Define a singleton method on an object.
  def meta_def(name, &block)
    meta_eval do
      define_method(name, &block)
    end
  end
end