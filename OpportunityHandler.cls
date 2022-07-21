public with sharing class OpportunityHandler {

    public static List<Opportunity> updateOpportunityStage(String stageOld,String stageNew) {
        List<Opportunity> queriedCOpportunity = new List<Opportunity>{null};

        List<Schema.PicklistEntry> opportunityStages =
                Opportunity.StageName.getDescribe().getPicklistValues();

        List<String> pickLabels = new List<String>();
        for(Schema.PicklistEntry picks : opportunityStages){
            pickLabels.add(picks.getLabel());
        }

        if (pickLabels.contains(stageOld) && pickLabels.contains(stageNew)) {
            try {
                queriedCOpportunity = [SELECT Id, StageName
                FROM Opportunity
                WHERE StageName = :stageOld];
                for (Opportunity opps : queriedCOpportunity) {
                    opps.StageName = stageNew;
                }
                update queriedCOpportunity;

            } catch (DmlException err) {
                System.debug('A DML exception has occurred: ' + err.getMessage());
            }
        } else {
            System.debug('Value stage (Old or New) not from Opportunity Stage PickList!');
        }
        return queriedCOpportunity;
    }

}