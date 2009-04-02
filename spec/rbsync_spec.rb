
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
    @rsync.destination_user = "user"
    @rsync.destination_host = "host.com"
    @rsync.destination_path = "/home/user"

    @rsync.destination.should == "user@host.com:/home/user"
  end
  it "should raise an ArgumentError if a user is set but not a host and vice versa for a destination" do
    @rsync.destination_user = "user"
    @rsync.destination_path = "/home/user"
    lambda {
      @rsync.destination
    }.should raise_error(ArgumentError)

    rsync2 = RBSync::RBSync.new
    rsync2.destination_host = "host.com"
    rsync2.destination_path = "/home/user"
    lambda {
      rsync2.destination
    }.should raise_error(ArgumentError)
  end
  it "should raise an ArgumentError if a destination path is not provided" do
    @rsync.destination_user = "user"
    @rsync.destination_host = "host.com"
    lambda {
      @rsync.destination
    }.should raise_error(ArgumentError)
  end
  it "should prefer an explicitly set destination over the components" do
    @rsync.destination_user = "user"
    @rsync.destination_host = "host.com"
    @rsync.destination_path = "/home/user"

    @rsync.destination = "newuser@newhost.com/home/newuser"

    @rsync.destination.should == "newuser@newhost.com/home/newuser"
  end

  # source
  it "should construct an rsync path when the individual source properties are set" do
    @rsync.source_user = "user"
    @rsync.source_host = "host.com"
    @rsync.source_path = "/home/user"

    @rsync.source.should == "user@host.com:/home/user"
  end
  it "should raise an ArgumentError if a user is set but not a host and vice versa for a source" do
    @rsync.source_user = "user"
    @rsync.source_path = "/home/user"
    lambda {
      @rsync.source
    }.should raise_error(ArgumentError)

    rsync2 = RBSync::RBSync.new
    rsync2.source_host = "host.com"
    rsync2.source_path = "/home/user"
    lambda {
      rsync2.source
    }.should raise_error(ArgumentError)
  end
  it "should raise an ArgumentError if a source path is not provided" do
    @rsync.source_user = "user"
    @rsync.source_host = "host.com"
    lambda {
      @rsync.source
    }.should raise_error(ArgumentError)
  end
  it "should prefer an explicitly set source over the components" do
    @rsync.source_user = "user"
    @rsync.source_host = "host.com"
    @rsync.source_path = "/home/user"

    @rsync.source = "newuser@newhost.com/home/newuser"

    @rsync.source.should == "newuser@newhost.com/home/newuser"
  end
end

# EOF
