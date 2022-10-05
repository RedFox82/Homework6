public class ProductSelector {
    public static List<Product2> selectProduct2s() {
        List<Product2> products = [SELECT Id, Name, Stock__c
                                   FROM Product2
                                   WHERE IsActive = TRUE
                                   WITH SECURITY_ENFORCED
                                   ORDER BY Name ASC ];
        return products;
    }

    public static List<PricebookEntry> selectProductsPrice(Set<String> Ids) {
        String Standard_pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE].Id;
        List<PricebookEntry> pr = new List<PricebookEntry>();
        if (Standard_pricebook != null) {
            pr = [SELECT Product2.Id, Product2.Name, UnitPrice
                  FROM PricebookEntry
                  WHERE Pricebook2.Id = :Standard_pricebook AND Product2.Id IN :Ids
                  WITH SECURITY_ENFORCED];
        }
        return pr;
    }

}