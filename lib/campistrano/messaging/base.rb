require 'forwardable'
require_relative 'helpers'

module Campistrano
  module Messaging
    class Base

      include Helpers

      extend Forwardable
      def_delegators :env, :fetch

      attr_reader :webhook, :options

      def initialize(options = {})
        @options = options.dup

        @env = options.delete(:env)
        @webhook = options.delete(:webhook)
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

      def channels_for(action)
        @channel
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
