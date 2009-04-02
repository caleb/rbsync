require 'delegate'

module RBSync
  class Option < SimpleDelegator
    attr_reader :rbsync
    attr_reader :name

    def initialize rbsync, name
      super(rbsync)

      @rbsync = rbsync
      @name = name
    end

    def ~
      self.rbsync.send("#{name}=", false)
    end
  end
end