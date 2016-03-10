module SalesforceDemo
  class Processor
    def initialize(owner_id, actions)
      @owner_id = owner_id
      @actions = actions
    end

    def process
      @actions.each do |action|
        puts "[#{Time.now}] PROCESSING #{action.to_json}"

        action = OpenStruct.new(action)

        action.is_mobile    = false if action.is_mobile.nil?
        action.sells_ads    = false if action.sells_ads.nil?
        action.uses_geo_loc = false if action.uses_geo_loc.nil?

        use_case = action.use_case.nil? ? nil : action.use_case.split(',')

        Salesforce::ActionItem__c.new({
          'OwnerId'             => @owner_id,
          'IsEmailConfirmed__c' => action.email_confirmed,
          'FactualGUID__c'      => action.user_id,
          'Status__c'           => action.status,
          'OptIn__c'            => action.opt_in,
          'TechnicalOptIn__c'   => action.technical_opt_in,
          'Username__c'         => action.username,
          'FirstName__c'        => action.first_name,
          'LastName__c'         => action.last_name,
          'Email__c'            => action.email,
          'SourceType__c'       => action.source_type,
          'CompanyName__c'      => action.company_name,
          'CompanyWebsite__c'   => action.company_website,
          'AppDesc__c'          => action.app_desc,
          'Dataset__c'          => action.dataset,
          'AuthKey__c'          => action.auth_key,
          'ActionDateTime__c'   => action.created_at,
          'AnalyticsData__c'    => action.analytics_data,
          'IsProduction__c'     => false,

          # New Required Fields
          'Lead_Type__c'        => 'Direct',
          'CurrencyIsoCode'     => 'USD',

          # New Fields For Lead Gen
          'Phone__c'           => action.phone,
          'LeadSource__c'      => action.lead_source,
          'UseCase__c'         => use_case,
          'Industry__c'        => action.industry,
          'UserCount__c'       => action.user_count,
          'UsesGeoLoc__c'      => action.uses_geo_loc,
          'CompanyDesc__c'     => action.company_desc,
          'IsMobile__c'        => action.is_mobile,
          'SellsAds__c'        => action.sells_ads,
          'LeadSourceNotes__c' => action.lead_source_notes,
        }).save

        puts "[#{Time.now}] PROCESSED"
      end
    end
  end
end
