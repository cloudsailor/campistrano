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
          content: "#{deployer} has started deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_updating
        {
          content: "#{deployer} is deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_reverting
        {
          content: "#{deployer} has started rolling back branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_updated
        {
          content: "#{deployer} has finished deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_reverted
        {
          content: "#{deployer} has finished rolling back branch of #{application} to #{stage}"
        }
      end

      def payload_for_failed
        {
          content: "#{deployer} has failed to #{deploying? ? 'deploy' : 'rollback'} branch #{branch} of #{application} to #{stage}"
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
