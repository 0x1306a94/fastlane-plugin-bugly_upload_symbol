describe Fastlane::Actions::BuglyUploadSymbolAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The bugly_upload_symbol plugin is working!")

      Fastlane::Actions::BuglyUploadSymbolAction.run(nil)
    end
  end
end
