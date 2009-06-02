
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe RBSync do
  before :each do
    @rsync = RBSync::RBSync.new
  end

  it "should not have the archive flag set when archive! is not called" do
    @rsync.archive.should be_nil
  end

  it "should include the archive flag when archive! is called" do
    @rsync.archive!
    @rsync.archive.should be_true
  end

  it "should include the archive flag when archive is set to true with archive=" do
    @rsync.archive = true
    @rsync.archive.should be_true
  end

  it "should have the archive flag set to false when ~ is used on the option" do
    ~ @rsync.archive!
    @rsync.archive.should be_false
  end

  it "should have the archive flag set to false when archive! is chained with no" do
    @rsync.no.archive!
    @rsync.archive.should be_false
  end

  it "should raise an ArgumentError if a non boolean value (one that is not true, false, or nil) is assigned to a boolean flag" do
    lambda {
      @rsync.archive = "string"
    }.should raise_error(ArgumentError)
  end

  it "should set the rsh flag when called with rsh=" do
    @rsync.rsh = "/usr/bin/ssh"
    @rsync.rsh.should == "/usr/bin/ssh"
  end

  it "should raise a NameError when a non boolean flag is used with rsync.no" do
    lambda {
      @rsync.no.rsh = "/usr/bin/ssh"
    }.should raise_error(NameError)
  end

  it "should allow chaining of boolean flags" do
    @rsync.archive!.fuzzy!
    @rsync.archive.should be_true
    @rsync.fuzzy.should be_true
  end

  #destination
  it "should construct an rsync path when the individual destination properties are set" do
    @rsync.to_user = "user"
    @rsync.to_host = "host.com"
    @rsync.to_path = "/home/user"

    @rsync.to.should == "user@host.com:/home/user"
  end
  it "should have a nil destination if a user is set but not a host and vice versa for a destination" do
    @rsync.to_user = "user"
    @rsync.to_path = "/home/user"
    @rsync.to.should be_nil

    rsync2 = RBSync::RBSync.new
    rsync2.to_host = "host.com"
    rsync2.to_path = "/home/user"
    rsync2.to.should be_nil
  end
  it "should have a nil destination if a destination path is not provided" do
    @rsync.to_user = "user"
    @rsync.to_host = "host.com"
    @rsync.to.should be_nil
  end
  it "should prefer an explicitly set destination over the components" do
    @rsync.to_user = "user"
    @rsync.to_host = "host.com"
    @rsync.to_path = "/home/user"

    @rsync.to = "newuser@newhost.com:/home/newuser"

    @rsync.to.should == "newuser@newhost.com:/home/newuser"
  end

  # source
  it "should construct an rsync path when the individual source properties are set" do
    @rsync.from_user = "user"
    @rsync.from_host = "host.com"
    @rsync.from_path = "/home/user"

    @rsync.from.should == "user@host.com:/home/user"
  end
  it "should have a nil source if a user is set but not a host and vice versa for a source" do
    @rsync.from_user = "user"
    @rsync.from_path = "/home/user"

    @rsync.from.should be_nil

    rsync2 = RBSync::RBSync.new
    rsync2.from_host = "host.com"
    rsync2.from_path = "/home/user"
    rsync2.from.should be_nil
  end
  it "should have a nil source if a source path is not provided" do
    @rsync.from_user = "user"
    @rsync.from_host = "host.com"

    @rsync.from.should be_nil
  end
  it "should prefer an explicitly set source over the components" do
    @rsync.from_user = "user"
    @rsync.from_host = "host.com"
    @rsync.from_path = "/home/user"

    @rsync.from = "newuser@newhost.com:/home/newuser"

    @rsync.from.should == "newuser@newhost.com:/home/newuser"
  end

  describe "command method" do
    def command_should_have_only command, from, to, *flags
      flags.each do |flag|
        command.should include flag
      end

      command.should =~ /^rsync/
      command.should =~ %r{#{from} #{to}$}

      command.gsub!(/^rsync/, '')
      command.gsub!(%r{#{from} #{to}$}, '')

      flags.each do |flag|
        command.sub! flag, ''
      end

      # with all the flags, the rsync command and the source and destination values stripped, there shouldn't be anything else
      command.strip.should == ""
    end
    
    it "should set the --archive flag when archive! is used" do
      @rsync.archive!
      @rsync.from = "/home/me/"
      @rsync.to = "user@host.com:/home/user"
      
      @rsync.command.should == "rsync --archive /home/me/ user@host.com:/home/user"
    end
    it "should set the --archive and --exclude flags when archive! and exclude= are used" do
      @rsync.archive!
      @rsync.exclude = "*~"
      @rsync.from = "/home/me/"
      @rsync.to = "user@host.com:/home/user"

      command_should_have_only @rsync.command, "/home/me/", "user@host.com:/home/user", "--exclude='*~'", "--archive"
    end
  end

  describe "constructor" do
    it "should take source and destination parameters" do
      @rsync = RBSync::RBSync.new '/home/user', 'user@host.com:/home/user'
      @rsync.from.should == '/home/user'
      @rsync.to.should == 'user@host.com:/home/user'
    end

    it "should have no source or destination if the source and destination parameters are omitted from the constructor" do
      @rsync = RBSync::RBSync.new

      @rsync.from.should be_nil
      @rsync.to.should be_nil
    end
  end

  describe "go!" do
    it "should have the --archive flag when the archive! method is used" do
      @rsync.archive!
      @rsync.from = "-bwah /Users/caleb/Desktop/BBEdit_9.2_Demo.dmg"
      @rsync.to = "/tmp"

      @rsync.go!.should include "--archive"
    end
  end
end

# EOF
