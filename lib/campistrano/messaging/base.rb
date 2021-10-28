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
                    <span style=color:green>has <b>started deploying</b> </span> <br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_updating
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:#a39926>is <b>deploying</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_reverting
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:orange>has <b>started rolling back</b></span>     <br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_updated
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:green>has <b>finished deploying</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_reverted
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:green>has <b>finished rolling back</b></span><br>
                    branch <b>#{branch}</b> of <b>#{application}</b> <br>
                    to <b>#{stage}</b>"
        }
      end

      def payload_for_failed
        {
          content: "<b>#{deployer}</b><br>
                    <span style=color:red>has <b>failed to #{deploying? ? 'deploy' : 'rollback'}</b></span><br>
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
