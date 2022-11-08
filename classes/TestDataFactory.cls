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

    public static List<Contact> ListContacts (Integer amount, String AccountId) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < amount; i++) {
            contacts.add(new Contact(LastName = 'Test' + i, AccountId = AccountId));
        }
        return contacts;
    }

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

    public static List<PurchaseOrder__c> ListPOs (Integer amount, String AccountId) {
        List<PurchaseOrder__c> purchaseOrders = new List<PurchaseOrder__c>();
        for (Integer i = 0; i < amount; i++) {
            purchaseOrders.add(new PurchaseOrder__c(Vendor__c = AccountId, Name = 'Order Test '+ i, Status__c = 'Draft'));
        }
        return purchaseOrders;
    }

    public static List<PurchaseOrderLineItem__c> ListPOLines (Integer amount, List<String> orderIds, List<Product2> products) {
        List<PurchaseOrderLineItem__c> purchaseOrderLines = new List<PurchaseOrderLineItem__c>();

        for (Integer i = 0; i < amount; i++) {
            for (Id id : orderIds) {
                for (Product2 product : products) {
                    purchaseOrderLines.add(new PurchaseOrderLineItem__c(Purchase_Order__c = id, Product__c = product.Id, Name = 'Test Line ', Quantity__c = 1, Unit_Price__c = 100));
                }
            }
        }
        return purchaseOrderLines;
    }

    public static List<Account> createAccounts(String recordTypeName, Integer amount) {
        List<Account> accs = new List<Account>();
        String recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();

        for (Integer i = 0; i < amount; i++) {
            accs.add(new Account(Name = recordTypeName + ' Account ' + i, RecordTypeId = recType, Phone = '(653) 897-3540'));
        }
        return accs;
    }

    public static List<Product2> ListProduct2s (String accountId, Integer amount) {
        List<Product2> product2s = new List<Product2>();
        for (Integer i = 0; i < amount; i++) {
            product2s.add(new Product2(Vendor__c = accountId, Name = 'Product' + i, Stock__c = 1, Family = 'Mobile phones', Product_Type__c = 'Smartphones', ProductCode = 'PC' + i));
        }
        return product2s;
    }
}