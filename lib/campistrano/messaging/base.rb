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
          content: "#{deployer}\n
                    status: Started deploying\n
                    on: branch #{branch} of #{application}\n
                    to: #{stage}"

        }
      end

      def payload_for_updating
        {
          content: "#{deployer}\n
                    status: Is deploying\n
                    on: Branch #{branch} of #{application}\n
                    to: #{stage}"
        }
      end

      def payload_for_reverting
        {
          content: "#{deployer}\n
                    status: Started rolling back\n
                    on: Branch #{branch} of #{application}\n
                    to: #{stage}"
        }
      end

      def payload_for_updated
        {
          content: "#{deployer}\n
                    status: Finished deploying\n
                    on: Branch #{branch} of #{application}\n
                    to: #{stage}"
        }
      end

      def payload_for_reverted
        {
          content: "#{deployer}\n
                    status: Finished rolling back\n
                    on: Branch #{branch} of #{application}\n
                    to: #{stage}"
        }
      end

      def payload_for_failed
        {
          content: "#{deployer}\n
                    status: Failed to #{deploying? ? 'deploy' : 'rollback'}\n
                    on: Branch #{branch} of #{application}\n
                    to: #{stage}\n"
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
