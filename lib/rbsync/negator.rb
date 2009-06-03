
module RBSync
  class Negator

    def initialize rbsync
      @rbsync = rbsync

      RBSync.boolean_methods.each do |m|

        (class << self; self; end).class_eval <<-RUBY
          def #{m}
            @rbsync.#{m.gsub(/!$/, '')} = false
          end
        RUBY

      end
    end

  end
end