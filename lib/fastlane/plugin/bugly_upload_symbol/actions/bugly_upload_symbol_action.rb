require "fastlane/action"
require_relative "../helper/bugly_upload_symbol_helper"

module Fastlane
  module Actions
    class BuglyUploadSymbolAction < Action
      def self.run(params)
        UI.message("The bugly_upload_symbol plugin is working!")
        verbose = params[:verbose]
        appid = params[:appid]
        appkey = params[:appkey]
        bundleid = params[:bundleid]
        version = params[:version]
        # platform = params[:platform]
        platform = "IOS"
        inputSymbol = params[:inputSymbol]
        inputSymbolDir = params[:inputSymbolDir]

        UI.message("appid: #{appid}") if verbose
        UI.message("appkey: #{appkey}") if verbose
        UI.message("bundleid: #{bundleid}") if verbose
        UI.message("version: #{version}") if verbose
        UI.message("platform: #{platform}") if verbose
        UI.message("inputSymbol: #{inputSymbol}") if verbose
        UI.message("inputSymbolDir: #{inputSymbolDir}") if verbose
        jar_path = Helper::BuglyUploadSymbolHelper.resource_file("buglyqq-upload-symbol.jar")
        UI.message("jar path: #{jar_path}") if verbose

        base_command = "java -jar #{jar_path} -appid '#{appid}' -appkey '#{appkey}' -bundleid '#{bundleid}' -version '#{version}' -platform '#{platform}'"
        begin
          success_pattern = '{"statusCode":0,"msg":"success"'
          unless inputSymbol.nil?
            final_command = base_command + " -inputSymbol #{File.expand_path(inputSymbol)}"
            command_result = do_run(final_command, verbose)
            return false unless command_result.include?(success_pattern)
          end

          unless inputSymbolDir.nil?
            UI.message("inputSymbolDir: #{File.expand_path(inputSymbolDir)}") if verbose
            Dir.glob("#{File.expand_path(inputSymbolDir)}/*.dSYM").each do |entry|
              UI.message("Find dSYM entry: #{entry}") if verbose
              final_command = base_command + " -inputSymbol #{entry}"
              command_result = do_run(final_command, verbose)
              return false unless command_result.include?(success_pattern)
            end
          end
        rescue => ex
          UI.error("run command error: #{ex}") if verbose
          return false
        end

        return true
      end

      def self.description
        "bugly uploads symbol tables for iOS platforms"
      end

      def self.authors
        ["0x1306a94"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "Whether the upload succeeds. The value is true or false"
      end

      def self.details
        # Optional:
        "bugly uploads symbol tables for iOS platforms"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :appid,
                                       env_name: "BUGLY_UPLOAD_SYMBOL_APPID",
                                       description: "bugly 平台appid",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :appkey,
                                       env_name: "BUGLY_UPLOAD_SYMBOL_APP_KEY",
                                       description: "bugly 平台appkey",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :bundleid,
                                       description: "应用包名",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "应用版本号",
                                       optional: false,
                                       type: String),
          # FastlaneCore::ConfigItem.new(key: :platform,
          #                              description: "待上传的平台 IOS or Android",
          #                              optional: false,
          #                              type: String),
          FastlaneCore::ConfigItem.new(key: :inputSymbol,
                                       description: "符号表文件路径",
                                       conflicting_options: [:inputSymbolDir],
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :inputSymbolDir,
                                       description: "符号表文件目录",
                                       conflicting_options: [:inputSymbol],
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       description: "详细模式",
                                       optional: true,
                                       type: Boolean,
                                       default_value: false),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        [:ios, :mac].include?(platform)
        # true
      end

      private

      def self.do_run(command, verbose)
        UI.message("run command: #{command}") if verbose
        command_result = Actions.sh(command)
        command_result
      end
    end
  end
end
