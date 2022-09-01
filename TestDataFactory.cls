@IsTest
public with sharing class TestDataFactory {

    public static List<Property__c> ListProperties (Integer amount) {
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < amount; i++) {
            properties.add(new Property__c(
                    Account__c='0017R00002pQoyRQAS',
                    Name='Barad-dur' + i,
                    Property_Title__c='Barad-dur apartments',
                    Address__c='13, Sauron str., Mordor',
                    Price__c=1000));
        }
        return properties;
    }


}