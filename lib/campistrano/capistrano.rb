require_relative 'messaging/base'
require 'net/http'
require 'json'
require 'forwardable'

load File.expand_path('../tasks/basecamp.rake', __FILE__)

module Campistrano
  class Capistrano

    attr_reader :backend
    private :backend

    extend Forwardable
    def_delegators :env, :fetch, :run_locally

    def initialize(env)
      @env = env
      config = fetch(:campistrano, {})
      config[:webhooks] = config[:webhooks].split if config[:webhooks].is_a?(String)
      @messaging = if config
                     opts = config.dup.merge(env: @env)
                     klass = opts.delete(:klass) || Messaging::Default
                     klass.new(opts)
                   else
                     Messaging::Null.new
                   end
    end

    def run(action)
      _self = self
      run_locally { _self.process(action, self) }
    end

    def process(action, backend)
      @backend = backend

      payload = @messaging.payload_for(action)
      return if payload.nil?

      @messaging.webhooks.each do |webhook|
        post(payload.merge(url: webhook))
      end


      # post(payload)
    end

    private ##################################################

    def post(payload)

      if dry_run?
        post_dry_run(payload)
        return
      end

      begin
        response = post_to_campfire(payload)
      rescue => e
        backend.warn('[campistrano] Error notifying Basecamp!')
        backend.warn(e)
      end

      if response && response.code !~ /^2/
        warn('[campistrano] Basecamp API Failure!')
        warn("[campistrano]   URI: #{response.uri}")
        warn("[campistrano]   Code: #{response.code}")
        warn("[campistrano]   Message: #{response.message}")
        warn("[campistrano]   Body: #{response.body}") if response.message != response.body && response.body !~ /<html/
      end
    end

    def post_to_campfire(payload = {})
      post_to_campfire_as_webhook(payload)
    end

    def post_to_campfire_as_webhook(payload = {})
      uri = URI(payload[:url])
      Net::HTTP.post(uri, payload.to_json, 'Content-Type' => 'application/json')
    end

    def dry_run?
      ::Capistrano::Configuration.env.dry_run?
    end

    def post_dry_run(payload)
        backend.info('[campistrano] Campistrano Dry Run:')
        backend.info("[campistrano]   Webhook: #{@messaging.webhook}")
        backend.info("[campistrano]   Payload: #{payload.to_json}")
    end

  end
end
