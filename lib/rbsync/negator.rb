
module RBSync
  class Negator

    def initialize rbsync
      @rbsync = rbsync

      methods = rbsync.class.public_instance_methods(true)
      methods -= ::Kernel.public_instance_methods(false)
      methods |= ["to_s","to_a","inspect","==","=~","==="]

      methods.select { |m| m =~ /\!$/ }.each do |m|

        (class << self; self; end).class_eval <<-RUBY
          def #{m}
            @rbsync.send :"#{m.gsub(/!$/, '')}=", false
          end
        RUBY

      end
    end

  end
end