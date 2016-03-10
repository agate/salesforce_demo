module SalesforceDemo
  ROOT_DIR = File.expand_path('../..', __FILE__)

  module Salesforce; end

  class << self
    def process
      init_salesforce
      processor = Processor.new(owner_id, fixtures)
      processor.process
    end

    private

    def init_salesforce
      client = Databasedotcom::Client.new({
        host:          salesforce_config['host'],
        client_id:     salesforce_config['client_id'],
        client_secret: salesforce_config['client_secret']
      })
      client.authenticate({
        username: salesforce_config['username'],
        password: salesforce_config['password']
      })

      client.sobject_module = Salesforce
      client.materialize([ 'User', 'ActionItem__c' ])
    end

    def owner_id
      @owner_id ||= Salesforce::User.find_by_email(salesforce_config['owner']).Id
    end

    def salesforce_config
      @salesforce_config ||= YAML.load_file("#{ROOT_DIR}/config/salesforce.yml")
    end

    def fixtures
      @fixtures ||= YAML.load_file("#{ROOT_DIR}/fixtures/user_actions.yml")
    end
  end
end

require_relative './salesforce_demo/processer'
