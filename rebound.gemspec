Gem::Specification.new do |s|
  s.name = %q{rebound}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima"]
  s.date = %q{2008-07-20}
  s.description = %q{By default, instances of UnboundMethod can only be bound to objects that are a kind_of? the method's original class. Pretty lame.  rebound allows unbound methods (instances of UnboundMethod class) to be bound to objects of any class. It uses the alias_method_chain pattern to accomplish this, meaning you also get a bind_without_indifference method that retains the original behavior.}
  s.email = ["patnakajima@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.textile"]
  s.files = ["History.txt", "Manifest.txt", "README.textile", "Rakefile", "lib/rebound.rb", "spec/rebound_spec.rb", "spec/spec_helper.rb", "rebound.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nakajima/rebound}
  s.rdoc_options = ["--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{By default, instances of UnboundMethod can only be bound to objects that are a kind_of? the method's original class. This fixes that.}
  s.test_files = ["spec/rebound_spec.rb"]
  s.add_dependency('ruby2ruby', [">= 1.1.9"])
end
