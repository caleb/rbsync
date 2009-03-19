
module RBSync
  class Option
    attr_reader :rbsync
    attr_reader :name

    def initialize rbsync, name
      @rbsync = rbsync
      @name = name
    end

    def ~
      self.rbsync.send("#{name}=", false)
    end
  end
end