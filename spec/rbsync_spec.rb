
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
end

# EOF
