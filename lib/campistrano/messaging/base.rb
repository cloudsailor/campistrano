require 'forwardable'
require_relative 'helpers'

module Campistrano
  module Messaging
    class Base

      include Helpers

      extend Forwardable
      def_delegators :env, :fetch

      attr_reader :webhooks, :options

      def initialize(options = {})
        @options = options.dup

        @env = options.delete(:env)
        @webhooks = options.delete(:webhooks)

        #   puts 'Bleee' if not @webhooks.id_a(Array)
        # return 'asd' unless @webhooks.id_a(Array)
      end

      def payload_for_starting
        {
          content: "#{deployer}<br>
                    <b>Status</b>: <span style=color:green>Started deploying</span><br>
                    <b>On:</b> branch #{branch} of #{application}<br>
                    <b>to:</b> #{stage}"

        }
      end

      def payload_for_updating
        {
          content: "#{deployer}<br>
                    <b>status</b>: <span style=color:yellow>Is deploying</span><br>
                    <b>on:</b> Branch #{branch} of #{application}<br>
                    <b>to:</b> #{stage}"
        }
      end

      def payload_for_reverting
        {
          content: "#{deployer}<br>
                    <b>status</b>: <span style=color:red>Started rolling back</span><br>
                    <b>on:</b> Branch #{branch} of #{application}<br>
                    <b>to:</b> #{stage}"
        }
      end

      def payload_for_updated
        {
          content: "#{deployer}<br>
                    <b>status</b>: <span style=color:green>Finished deploying</span><br>
                    <b>on:</b> Branch #{branch} of #{application}<br>
                    <b>to:</b> #{stage}"
        }
      end

      def payload_for_reverted
        {
          content: "#{deployer}<br>
                    <b>status:</b> <span style=color:red>Finished rolling back</span><br>
                    <b>on:</b> Branch #{branch} of #{application}<br>
                    <b>to:</b> #{stage}"
        }
      end

      def payload_for_failed
        {
          content: "#{deployer}<br>
                    <b>status</b>: <span style=color:red>Failed to #{deploying? ? 'deploy' : 'rollback'}</span><br>
                    <b>on:</b> Branch #{branch} of #{application}<br>
                    <b>to:</b> #{stage}"
        }
      end

      ################################################################################

      def payload_for(action)
        method = "payload_for_#{action}"
        respond_to?(method) && send(method)
      end
    end
  end
end

require_relative 'default'
require_relative 'null'
