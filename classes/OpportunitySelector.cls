public class OpportunitySelector {

    public static List<Opportunity> selectOpportunities() {
        List<Opportunity> opportunities = [SELECT Id, Name, (SELECT Id, Product2.Id, Quantity FROM OpportunityLineItems)
        FROM Opportunity
        WHERE IsClosed = FALSE
        WITH SECURITY_ENFORCED];
        return opportunities;
    }

}