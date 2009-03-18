# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'rbsync'

task :default => 'spec:run'

PROJ.name = 'rbsync'
PROJ.authors = 'Caleb Land'
PROJ.email = 'caleb.land@gmail.com'
PROJ.url = 'http://www.github.com/caleb/rbsync'
PROJ.version = RBSync::VERSION
PROJ.rubyforge.name = 'rbsync'

PROJ.spec.opts << '--color'

# EOF
