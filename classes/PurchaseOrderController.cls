public with sharing class PurchaseOrderController {

    @AuraEnabled
    public static String addOrder(Id accountId, String name_order) {
        PurchaseOrder__c po = new PurchaseOrder__c(Vendor__c = accountId, Name = name_order, Status__c = 'Draft');
        insert po;
        return po.Id;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Product2> getProducts() {
        return ProductSelector.selectProduct2s();
    }

    @AuraEnabled
    public static void addLines(Id accountId, String name_order, String j_items) {
        Map<String, Map<Integer, Decimal>> items = (Map<String, Map<Integer, Decimal>>) JSON.deserialize(j_items, Map<String, Map<Integer, Decimal>>.class);

        Id orderId = null;
        orderId = addOrder(accountId, name_order);

        if (orderId != null) {
            Map<Id, Decimal> prices = new Map<Id, Decimal>();
            Map<Id, String> names = new Map<Id, String>();
            List<PurchaseOrderLineItem__c> lineItems = new List<PurchaseOrderLineItem__c>();
            Set<String> Ids = new Set<String> (items.keySet());
            List<PricebookEntry> products = ProductSelector.selectProductsPrice(Ids);

            if (!products.isEmpty()) {
                for (PricebookEntry p : products) {
                    prices.put(p.Product2.Id, p.UnitPrice);
                    names.put(p.Product2.Id, p.Product2.Name);
                }
            }
            if (!prices.isEmpty() && !names.isEmpty()) {
                Map<Integer, Decimal> items2 = new Map<Integer, Decimal>();
                for (Id id : Ids) {
                    items2.putAll(items.get(id));
                    for (Integer key : items2.keySet()) {
                        lineItems.add(new PurchaseOrderLineItem__c(Purchase_Order__c = orderId, Product__c = id, Name = names.get(id),
                                Quantity__c = items2.get(key), Unit_Price__c = prices.get(id)));
                    }
                    items2.clear();

                }

            }

            if (!lineItems.isEmpty()) {
                insert lineItems;
            }
        }
    }

}