shared_examples "a package manager" do |params|
  it "should respond_to all required methods" do
    subject.should respond_to(:setup, :install, :update, :cleanup, :teardown)
  end

  params[:for].each do |method|
    it "should start the section '#{params[:with_section_name]}' in #{method}" do
      executor.should_receive(:start_section).with(params[:with_section_name].to_s)
      subject.public_send(method)
    end
  end
end
