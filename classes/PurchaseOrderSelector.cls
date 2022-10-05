public with sharing class PurchaseOrderSelector {

    public static List<PurchaseOrder__c> selectPurchaseOrders(Set<String> Ids_PurchaseOrders) {
        List<PurchaseOrder__c> purchaseOrders = [SELECT Id,  (SELECT Id, Product__c, Quantity__c FROM PurchaseOrderLineItems__r)
                                                 FROM PurchaseOrder__c
                                                 WHERE Id IN :Ids_PurchaseOrders];
        return purchaseOrders;
    }

    public static List<PurchaseOrder__c> draftPurchaseOrders() {
        List<PurchaseOrder__c> purchaseOrders = [SELECT Id, Name, CreatedDate, (SELECT Id, Product__c, Quantity__c FROM PurchaseOrderLineItems__r)
        FROM PurchaseOrder__c
        WHERE Status__c = 'Draft'];
        return purchaseOrders;
    }

    public static List<PurchaseOrderLineItem__c> selectPurchaseOrderLines(Set<String> Ids_PurchaseOrders) {
        List<PurchaseOrderLineItem__c> purchaseOrderLines = [SELECT Id, Product__c, Quantity__c
                                                             FROM PurchaseOrderLineItem__c
                                                             WHERE Purchase_Order__c IN :Ids_PurchaseOrders];
        return purchaseOrderLines;
    }

    public static List<Product2> selectProducts(Set<String> Ids_Products) {
        List<Product2> products = [SELECT Id, Stock__c
                                   FROM Product2
                                   WHERE Id IN :Ids_Products];
        return products;
    }

}