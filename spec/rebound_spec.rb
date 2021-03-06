require File.join(File.dirname(__FILE__), 'spec_helper')

describe UnboundMethod do
  before(:each) do
    @a = Class.new { def foo; :bar end }
    @b = Class.new { def called?; @called end }
    @mod = Module.new { def call; @called = true; end }
    @object_a = @a.new
    @object_b = @b.new
  end
  
  describe "#name" do
    it "should return name" do
      m = @a.instance_method(:foo)
      m.name.should == 'foo'
    end
  end
  
  describe "#to_s" do
    it "should provide source" do
      m = @a.instance_method(:foo)
      m.to_s(:ruby).should == "def foo()\n  :bar\nend"
    end
    
    it "should be memoized" do
      m = @a.instance_method(:foo)
      m.should_receive(:to_ruby).once.and_return(proc { :bar }.to_ruby)
      2.times { m.to_s(:ruby) }
    end
  end
  
  describe "#bind" do
    it "should bind method from Class.instance_method to object of different class" do
      m = @a.instance_method(:foo)
      m.bind(@object_b)
      @object_b.foo.should == :bar
    end

    it "should bind singleton method to object of different class" do
      class << @object_a; def greet; :hello end end
      m = @object_a.method(:greet).unbind
      m.bind(@object_b)
      @object_b.greet.should == :hello
    end
    
    it "should bind methods that take an argument" do
      class << @object_a; def greet(name); "hello #{name}" end end
      m = @object_a.method(:greet).unbind
      m.bind(@object_b)
      @object_b.greet('pat').should == "hello pat"
    end
    
    it "should bind methods that take splat of arguments" do
      class << @object_a
        def add_these(container, *args)
          args.each { |a| container << a }
        end
      end
      m = @object_a.method(:add_these).unbind
      m.bind(@object_b)
      collector = []
      @object_b.add_these(collector, 'pat', 'tim', 'drew')
      collector.should == ['pat', 'tim', 'drew']
    end
    
    it "should bind methods that take block" do
      class << @object_a
        def append(&block)
          res = [:original]
          res << yield
          res
        end
      end
    
      m = @object_a.method(:append).unbind
      m.bind(@object_b)
      @object_b.append { :addition }.should == [:original, :addition]
    end
    
    it "should bind module instance method" do
      m = @mod.instance_method(:call)
      m.bind(@object_b)
      @object_b.call
      @object_b.should be_called
    end
  end
  
  describe "#to_proc" do
    it "should return proc version" do
      m = @a.instance_method(:foo)
      m.to_proc.call.should == :bar
    end
    
    it "should be memoized" do
      m = @a.instance_method(:foo)
      m.should_receive(:to_ruby).once.and_return(proc { :bar }.to_ruby)
      2.times { m.to_proc }
    end
  end
end