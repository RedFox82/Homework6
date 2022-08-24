
public with sharing class DiaryController {

    @AuraEnabled(Cacheable=true)
    public static List<Diary__c> getDiariesByContactId(String contactId) {
        return DiarySelector.selectDiariesByContactID(contactId);


    }

    @AuraEnabled
    public static void addNote(Id contactId, String note) {
        insert (new Diary__c(Contact__c = contactId, Note__c = note));
    }

}