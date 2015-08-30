module FeatureHelpers
  module AgentHelper

    def an_agent_exists
      FactoryGirl.create :agent
    end

    def an_agent_exists_with_username
      FactoryGirl.create :agent, :user_name => 'Trisha Marquardt 1'
    end
  end
end