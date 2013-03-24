shared_examples "a package manager" do |params|
  it "should respond_to all required methods" do
    subject.should respond_to(:setup, :install, :update, :cleanup, :teardown)
  end

  params[:for].each do |method|
    it "should start the section '#{params[:with_section_name]}' in #{method}" do
      executor.should_receive(:start_section).with(params[:with_section_name].to_s)
      # Using send instead of public_send, because we want to run on 1.8.7
      subject.send(method)
    end
  end
end
