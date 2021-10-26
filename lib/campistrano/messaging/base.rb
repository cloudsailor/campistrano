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
          content: "<b>#{deployer}</b><br>
                    <span style=color:green><b>Started deploying</b> </span> <br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_updating
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:#a39926><b>Is deploying</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_reverting
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:orange><b>Started rolling back</b></span>     <br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_updated
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:green><b>Finished deploying</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_reverted
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:green><b>Finished rolling back</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_failed
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:red><b>Failed to #{deploying? ? 'deploy' : 'rollback'}</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
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
