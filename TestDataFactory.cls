@IsTest
public with sharing class TestDataFactory {

    public static List<Case> ListClosedCase (Integer closed, String id) {
        List<Case> closed_Cases = new List<Case>();
        for (Integer i = 0; i < closed; i++) {
            closed_Cases.add(new Case(Status = 'Closed', Country__c = id, Origin = 'Web', SuccessMessage__c = ''));
        }
        return closed_Cases;
    }

    public static List<Case> ListOpenCase (Integer open, String id) {
        List<Case> open_Cases = new List<Case>();
        for (Integer i = 0; i < open; i++) {
            open_Cases.add(new Case(Status = 'New', Country__c = id, Origin = 'Phone', SuccessMessage__c = ''));
        }
        return open_Cases;
    }


}