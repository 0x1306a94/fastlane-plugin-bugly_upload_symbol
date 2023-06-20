require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class BuglyUploadSymbolHelper
      # class methods that you define here become available in your action
      # as `Helper::BuglyUploadSymbolHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the bugly_upload_symbol plugin helper!")
      end

      def self.resource_file(filename)
        File.expand_path(File.join('../../../../../../', 'resources', filename), __FILE__)
      end
    end
  end
end
