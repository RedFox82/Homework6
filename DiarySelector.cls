public with sharing class DiarySelector {

    public static List<Diary__c> selectDiariesByContactID(Id contactId) {
        List<Diary__c> diaries = [SELECT Id, Note__c, CreatedDate
        FROM Diary__c
        WHERE Contact__c = :contactId
        WITH SECURITY_ENFORCED
        ORDER BY CreatedDate DESC];
        return diaries;
    }

}