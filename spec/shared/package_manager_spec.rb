shared_examples "a package manager" do
  it "should respond_to all required methods" do
    subject.should respond_to(:setup, :install, :update, :cleanup, :teardown)
  end
end
