@IsTest
public with sharing class TestDataFactory {

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

}